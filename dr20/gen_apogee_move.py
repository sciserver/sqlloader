"""
Generate SQL to move the carried-over APOGEE tables from PRIMARY heaps onto
SPEC with a proper primary key and compression.

These 10 tables came across in the BestDR19 -> BestDR20 rename and were never
rebuilt, so they sit on PRIMARY as uncompressed heaps.  This is a MOVE of the
data already in BestDR20 -- it does not touch BESTTEST and does not fix the
fact that the rows are DR19-era.  A later reload from BESTTEST supersedes it.

Per table, end to end:
    CREATE <t>_move ON [SPEC]
    ADD CONSTRAINT pk_<t>_<pkcols> PRIMARY KEY CLUSTERED (...) [PAGE] ON [SPEC]
    INSERT ... WITH (TABLOCK) from the original
    VERIFY row count and checksum, abort on mismatch
    sp_rename original -> <t>_old      (kept, NOT dropped)
    sp_rename <t>_move -> <t>

The original is renamed rather than dropped, so nothing is destroyed until you
have checked the result and dropped <t>_old by hand.  That means PRIMARY does
not shrink until you do, and SPEC needs room for the compressed copy alongside.

Compression follows the >= 1M row rule, not IndexMap (which says PAGE for
everything).  Two tables fall below the line and are created uncompressed.

Usage:
    python gen_apogee_move.py          # writes move_apogee_tables.sql
"""

import pymssql

SERVER = 'localhost'
DB = 'BestDR20'
FILEGROUP = 'SPEC'
COMPRESSION_THRESHOLD = 1_000_000
SUFFIX_NEW = '_move'
SUFFIX_OLD = '_old'

OUTPUT = r'H:\GitHub\sqlloader\dr20\move_apogee_tables.sql'

TABLES = [
    'aspcap_apogee_star',
    'astro_nn_apogee_star',
    'astro_nn_apogee_visit',
    'astro_nn_dist_apogee_star',
    'apogee_net_apogee_star',
    'lite_all_star',
    'mwm_apogee_allstar',
    'mwm_apogee_allvisit',
    'the_payne_apogee_star',
    'the_payne_apogee_visit',
]


def col_type(row):
    """Format a SQL Server column type string from INFORMATION_SCHEMA metadata."""
    dt = row['DATA_TYPE']
    if dt in ('varchar', 'nvarchar', 'char', 'nchar', 'varbinary', 'binary'):
        n = row['CHARACTER_MAXIMUM_LENGTH']
        return f"{dt}(max)" if n == -1 else f"{dt}({n})"
    elif dt in ('decimal', 'numeric'):
        return f"{dt}({row['NUMERIC_PRECISION']},{row['NUMERIC_SCALE']})"
    elif dt == 'float':
        p = row['NUMERIC_PRECISION']
        return f"float({p})" if p and p != 53 else 'float'
    elif dt in ('datetime2', 'time', 'datetimeoffset'):
        p = row['DATETIME_PRECISION']
        return f"{dt}({p})" if p is not None else dt
    else:
        return dt


def get_pk_cols(conn, table):
    """CI key column(s) for a table, from IndexMap (code='K')."""
    cur = conn.cursor(as_dict=True)
    cur.execute("SELECT fieldList FROM dbo.IndexMap WHERE code = 'K' AND tableName = %s",
                (table,))
    r = cur.fetchone()
    if not r:
        return None
    return [c.strip() for c in r['fieldList'].split(',')]


def get_columns(conn, table):
    cur = conn.cursor(as_dict=True)
    cur.execute("""
        SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
               NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION, IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
    """, (table,))
    return cur.fetchall()


def get_row_count(conn, table):
    """Row count from catalog metadata - cheap, and exact enough for sizing."""
    cur = conn.cursor(as_dict=True)
    cur.execute("""
        SELECT SUM(p.rows) AS rows
        FROM sys.tables t
        JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id IN (0, 1)
        JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
        WHERE t.name = %s
    """, (table,))
    r = cur.fetchone()
    return r['rows'] if r and r['rows'] is not None else None


def emit_table(table, pk_cols, columns, rows, n, total):
    """Build the SQL block for one table."""
    new = f'{table}{SUFFIX_NEW}'
    old = f'{table}{SUFFIX_OLD}'
    pk_name = f"pk_{table}_{'_'.join(pk_cols)}"
    pk_sql = ', '.join(f'[{c}]' for c in pk_cols)
    compress = rows >= COMPRESSION_THRESHOLD
    compress_clause = ' WITH (DATA_COMPRESSION = PAGE)' if compress else ''

    col_defs = []
    col_names = []
    for c in columns:
        name = c['COLUMN_NAME']
        col_names.append(f'[{name}]')
        null = 'NULL' if c['IS_NULLABLE'] == 'YES' else 'NOT NULL'
        col_defs.append(f"    [{name}] {col_type(c)} {null}")
    col_block = ',\n'.join(col_defs)
    col_list = ', '.join(col_names)

    # Checksum column: first PK column, for a cheap content check alongside
    # the row count.  All these PKs are bigint; cast guards against overflow.
    sum_col = pk_cols[0]

    return f"""
-- ============================================================================
-- {n}/{total}  {table}
--   {rows:,} rows | PK: {pk_name} | compression: {'PAGE' if compress else 'NONE'}
-- ============================================================================
PRINT '';
PRINT '=== {table} ({n}/{total}) ===';
GO

-- Refuse if a previous run left a staging table behind.
IF OBJECT_ID('dbo.{new}') IS NOT NULL
BEGIN
    RAISERROR('dbo.{new} already exists - a previous run did not finish. Inspect and drop it before re-running.', 16, 1);
    SET NOEXEC ON;
END
GO

-- Refuse if this table has already been moved.
IF EXISTS (
    SELECT 1 FROM sys.tables t
    JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id IN (0, 1)
    JOIN sys.data_spaces fg ON i.data_space_id = fg.data_space_id
    WHERE t.name = '{table}' AND fg.name = '{FILEGROUP}')
BEGIN
    RAISERROR('dbo.{table} is already on [{FILEGROUP}] - nothing to do.', 16, 1);
    SET NOEXEC ON;
END
GO

CREATE TABLE dbo.{new} (
{col_block}
) ON [{FILEGROUP}];
GO

-- PK created before the load so rows land in key order already compressed,
-- rather than building a heap and rebuilding it afterwards.
ALTER TABLE dbo.{new}
    ADD CONSTRAINT [{pk_name}] PRIMARY KEY CLUSTERED ({pk_sql}){compress_clause}
    ON [{FILEGROUP}];
GO

PRINT '  loading {rows:,} rows...';
GO

INSERT INTO dbo.{new} WITH (TABLOCK) ({col_list})
SELECT {col_list} FROM dbo.{table};
GO

-- Verify BEFORE renaming anything.  Row count plus a checksum over the key,
-- so a partial or misaligned load is caught rather than silently swapped in.
DECLARE @src_rows bigint, @dst_rows bigint;
DECLARE @src_sum decimal(38,0), @dst_sum decimal(38,0);

SELECT @src_rows = COUNT_BIG(*), @src_sum = SUM(CAST([{sum_col}] AS decimal(38,0)))
FROM dbo.{table};
SELECT @dst_rows = COUNT_BIG(*), @dst_sum = SUM(CAST([{sum_col}] AS decimal(38,0)))
FROM dbo.{new};

IF @src_rows <> @dst_rows OR ISNULL(@src_sum, -1) <> ISNULL(@dst_sum, -1)
BEGIN
    RAISERROR('VERIFY FAILED for {table}: source %I64d rows / dest %I64d rows. Staging table dbo.{new} left in place, nothing renamed.',
              16, 1, @src_rows, @dst_rows);
    SET NOEXEC ON;
END
ELSE
    PRINT '  verified: ' + CAST(@dst_rows AS varchar(20)) + ' rows, checksum matches';
GO

-- Swap.  The original is RENAMED, not dropped - drop dbo.{old} by hand once
-- you are satisfied.  Until then PRIMARY still holds the old heap.
EXEC sp_rename 'dbo.{table}', '{old}';
GO
EXEC sp_rename 'dbo.{new}', '{table}';
GO

PRINT '  done - dbo.{table} now on [{FILEGROUP}]; original kept as dbo.{old}';
GO
"""


def main():
    conn = pymssql.connect(server=SERVER, database=DB)

    lines = [
        '-- Generated by gen_apogee_move.py -- DO NOT EDIT BY HAND',
        '--',
        '-- Moves the carried-over APOGEE tables from PRIMARY heaps onto [SPEC]',
        '-- with a clustered primary key and compression on tables >= 1M rows.',
        '--',
        '-- This moves the data ALREADY IN BestDR20, which is DR19-era. It does not',
        '-- refresh the content; a later reload from BESTTEST supersedes it.',
        '--',
        '-- Originals are renamed to <table>_old and NOT dropped. Drop them by hand',
        '-- after checking the result. PRIMARY does not shrink until you do.',
        '--',
        '-- Safe to run one block at a time. A failed verification sets NOEXEC ON,',
        '-- so everything after it is parsed but not executed.',
        '',
        f'USE {DB};',
        'GO',
        '',
        'SET NOEXEC OFF;   -- clear NOEXEC left over from an earlier aborted run',
        'GO',
        '',
    ]

    total = len(TABLES)
    planned = []

    for n, table in enumerate(TABLES, 1):
        pk_cols = get_pk_cols(conn, table)
        if not pk_cols:
            print(f"SKIP {table}: no IndexMap entry")
            continue

        rows = get_row_count(conn, table)
        if rows is None:
            print(f"SKIP {table}: not present in {DB}")
            continue

        columns = get_columns(conn, table)
        if not columns:
            print(f"SKIP {table}: no columns found")
            continue

        # IndexMap's casing does not always match the column ('spectrum_PK' vs
        # the actual 'spectrum_pk').  Resolve against the real column so the
        # constraint name follows the existing lowercase convention, e.g.
        # pk_allspec_allspec_id.
        actual = {c['COLUMN_NAME'].lower(): c['COLUMN_NAME'] for c in columns}
        missing = [c for c in pk_cols if c.lower() not in actual]
        if missing:
            print(f"SKIP {table}: IndexMap key column(s) {missing} not in table")
            continue
        pk_cols = [actual[c.lower()] for c in pk_cols]

        pk_name = f"pk_{table}_{'_'.join(pk_cols)}"
        comp = 'PAGE' if rows >= COMPRESSION_THRESHOLD else 'NONE'
        print(f"{table}: {rows:,} rows, {len(columns)} cols, {pk_name}, {comp}")
        planned.append((table, rows, comp))

        lines.append(emit_table(table, pk_cols, columns, rows, n, total))

    lines += [
        '',
        '-- ============================================================================',
        '-- Cleanup, once every table above is verified.  Review first - this is the',
        '-- only destructive step, and it is deliberately left commented out.',
        '-- ============================================================================',
        '/*',
    ]
    for table, _, _ in planned:
        lines.append(f'DROP TABLE dbo.{table}{SUFFIX_OLD};')
    lines += [
        '*/',
        '',
        'SET NOEXEC OFF;',
        'GO',
        '',
    ]

    conn.close()

    with open(OUTPUT, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f"\n{len(planned)} of {total} tables written to {OUTPUT}")
    compressed = sum(1 for _, _, c in planned if c == 'PAGE')
    total_rows = sum(r for _, r, _ in planned)
    print(f"{compressed} PAGE, {len(planned) - compressed} uncompressed, "
          f"{total_rows:,} rows total")


if __name__ == '__main__':
    main()

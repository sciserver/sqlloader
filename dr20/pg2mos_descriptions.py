#!/usr/bin/env python3
"""
pg2mos_descriptions.py

Converts pg_schema_descriptions.sql (PostgreSQL DDL with SDSS metadata comments)
to create_minidb_descriptions_ms.sql (MSSQL-compatible format with mos_ prefix).

The output is suitable for parsing by vbs/parseSchema2sql.vbs to generate
loaddbobjects.sql and loaddbcolumns.sql.

Usage:
    python pg2mos_descriptions.py                      # convert
    python pg2mos_descriptions.py --validate           # check against mssql_tables_0603.sql

Workflow:
    1. (Optional but recommended) Export actual types from BestDR20:
       sqlcmd -S localhost -d BestDR20 -E -i get_db_types.sql -s "|" -W -h -1 -o actual_column_types.tsv
    2. python pg2mos_descriptions.py
    3. Copy output to schema/sql/create_minidb_descriptions_ms.sql
    4. cd vbs && cscript parseSchema2sql.vbs xschema_mos.txt
    5. Load schema/csv/loaddbobjects.sql + loaddbcolumns.sql into BestDR20
"""

import re
import sys
import os

INPUT_PG      = 'pg_schema_descriptions.sql'
INPUT_MS      = 'mssql_tables_0603.sql'
INPUT_DB_TYPES = 'actual_column_types.tsv'   # optional; from get_db_types.sql via sqlcmd
OUTPUT        = 'create_minidb_descriptions_ms.sql'

PG_PREFIX  = 'minidb_dr20.dr20_'
MOS_PREFIX = 'mos_'
DR20_PREFIX = 'dr20_'

# Column renames applied during conversion (PostgreSQL name → MSSQL name).
# These are reserved words or other names that pg2mssql.py renames.
COLUMN_RENAMES = {
    'plan': 'planname',
}

# Tables that exist in the PG schema but were not loaded into BestDR20/minidb_dr20_v2.
# Omit them from the descriptions output to keep metadata in sync with the actual DB.
SKIP_TABLES = {
    'mos_carton_csv',
    'mos_catalog_to_gaia_dr2_source_part1',
    'mos_catalog_to_gaia_dr2_source_part2',
    'mos_catalog_to_twomass_psc_part1',
    'mos_catalog_to_twomass_psc_part2',
    'mos_gaia_dr2_source_part1',
    'mos_gaia_dr2_source_part2',
    'mos_legacy_catalog_catalogid',
    'mos_sdss_id_flat_initial',
    'mos_sdss_id_to_catalog_full',
    'mos_target_2025dec9',
    'mos_target_union_legacy',
    'mos_target_union_legacy_initial',
    'mos_twomass_psc_part1',
    'mos_twomass_psc_part2',
}


# ---------------------------------------------------------------------------
# Parse MSSQL types from the actual schema file
# ---------------------------------------------------------------------------

SKIP_COL_KEYWORDS = {'CONSTRAINT', 'PRIMARY', 'UNIQUE', 'INDEX', 'ON', 'WITH'}

def parse_mssql_types(ms_path):
    """Return {mos_tablename: {colname: 'type_string'}} from mssql_tables_0116.sql."""
    tables = {}
    current = None

    with open(ms_path, 'r', encoding='utf-8') as f:
        for raw in f:
            line = raw.rstrip('\n')

            # table start
            m = re.match(r'^CREATE TABLE\s+(?:\[?dbo\]?\.)?\[?dr20_(\S+?)\]?\s*\(', line)
            if m:
                mos_name = MOS_PREFIX + m.group(1).strip('[](), ')
                current = mos_name
                tables[current] = {}
                continue

            if not current:
                continue

            # table end
            if re.match(r'^\s*\)', line):
                current = None
                continue

            # column line: optional brackets around name, then type
            m = re.match(r'^\s+\[?(\w+)\]?\s+(.+?)(?:,\s*)?$', line)
            if not m:
                continue
            col  = m.group(1)
            type_str = m.group(2).strip().rstrip(',').strip()
            if col.upper() not in SKIP_COL_KEYWORDS:
                tables[current][col] = type_str

    return tables


# ---------------------------------------------------------------------------
# DB types (from sqlcmd output of get_db_types.sql)
# ---------------------------------------------------------------------------

def parse_db_types(path):
    """Read table/col/type from sqlcmd pipe-delimited output.
    Returns {mos_tablename: {colname: 'type_string'}}.
    Skips blank lines and sqlcmd separator rows (all dashes)."""
    tables = {}
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line or '|' not in line:
                continue
            # skip sqlcmd separator lines like "---------|----------|----------"
            if set(line.replace('|', '').replace('-', '').replace(' ', '')) == set():
                continue
            parts = [p.strip() for p in line.split('|')]
            if len(parts) < 3:
                continue
            table_name, col_name, type_str = parts[0], parts[1], parts[2]
            if table_name not in tables:
                tables[table_name] = {}
            tables[table_name][col_name] = type_str
    return tables


# ---------------------------------------------------------------------------
# Conversion
# ---------------------------------------------------------------------------

def convert(input_path, output_path, ms_path, db_types_path=None):
    ms_types = parse_mssql_types(ms_path)

    db_types = {}
    if db_types_path and os.path.exists(db_types_path):
        db_types = parse_db_types(db_types_path)
        total_cols = sum(len(v) for v in db_types.values())
        print(f'Loaded {len(db_types)} tables / {total_cols} columns from {os.path.basename(db_types_path)}')

    with open(input_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    out = []
    in_table = False
    tables_found = 0
    current_table = ''
    type_hits = 0
    type_misses = 0

    # Lines outside a CREATE TABLE block that we always skip
    skip_re = re.compile(
        r'^(\\restrict|SET |SELECT pg_catalog|CREATE SCHEMA|ALTER SCHEMA'
        r'|ALTER TABLE|CREATE (UNIQUE )?INDEX|CREATE SEQUENCE|ALTER SEQUENCE'
        r'|REVOKE|GRANT)'
    )

    # Matches a column definition line: leading space, col name, space, type, optional comma+comment
    col_re = re.compile(r'^(\s+)(\[?\w+\]?)(\s+)(.+?)(,?)(\s*--.*)?$')

    for raw in lines:
        line = raw.rstrip('\n')
        stripped = line.strip()

        # --- detect start of a table ---
        m = re.match(r'^CREATE TABLE minidb_dr20\.(dr20_\S+)\s*\(', line)
        if m:
            pg_name  = m.group(1)                               # dr20_allstar...
            mos_name = MOS_PREFIX + pg_name[len(DR20_PREFIX):]  # mos_allstar...
            if mos_name in SKIP_TABLES:
                in_table = True   # enter block so we can skip until closing )
                current_table = ''
                continue
            out.append(f'\nCREATE TABLE {mos_name} (')
            in_table = True
            tables_found += 1
            current_table = mos_name
            continue

        # --- inside a table block ---
        if in_table:
            # end of table
            if re.match(r'^\s*\);?\s*$', line):
                if current_table:          # only write closing ) for non-skipped tables
                    out.append(')')
                    out.append('')
                in_table = False
                current_table = ''
                continue

            if not current_table:          # skipped table — discard content
                continue

            # fix PostgreSQL double-quoted identifiers -> MSSQL brackets
            line = re.sub(r'"(\w+)"', r'[\1]', line)

            # apply column renames (reserved words etc.)
            for pg_col, ms_col in COLUMN_RENAMES.items():
                line = re.sub(
                    r'^(\s+)' + pg_col + r'(\s)',
                    r'\g<1>' + ms_col + r'\2',
                    line
                )

            # substitute real MSSQL datatype if this is a column definition line
            # DB types (from actual database) take priority over SQL file types.
            m = col_re.match(line)
            if m and '--' not in m.group(4):  # group(4) is the type, not a comment
                indent   = m.group(1)
                col_name = m.group(2).strip('[]')
                comma    = m.group(5)
                comment  = m.group(6) or ''
                merged_types = {**ms_types.get(current_table, {}),
                                **db_types.get(current_table, {})}
                if col_name in merged_types:
                    line = indent + m.group(2) + ' ' + merged_types[col_name] + comma + comment
                    type_hits += 1
                elif col_name.upper() not in SKIP_COL_KEYWORDS:
                    type_misses += 1

            out.append(line)
            continue

        # --- outside a table block ---

        # keep the -- Name: comment block but update the table name
        m = re.match(r'^(-- Name: )dr20_(\S+)', line)
        if m:
            mos_name_comment = MOS_PREFIX + m.group(2).split(';')[0]  # strip trailing ;
            if mos_name_comment in SKIP_TABLES:
                continue
            rest = line[m.end():]
            # strip Schema: minidb_dr20 reference
            rest = re.sub(r'; Schema: minidb_dr20', '', rest)
            out.append(f'{m.group(1)}{MOS_PREFIX}{m.group(2)}{rest}')
            continue

        # skip PostgreSQL-specific lines
        if skip_re.match(stripped):
            continue

        # skip lines that still reference minidb_dr20 (owner lines etc.)
        if 'minidb_dr20' in line:
            continue

        out.append(line)

    with open(output_path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(out))
        f.write('\n')

    print(f'Converted {tables_found} tables -> {output_path}')
    print(f'  Types substituted from MSSQL schema: {type_hits}')
    if type_misses:
        print(f'  Columns not found in MSSQL schema (kept pg type): {type_misses}')


# ---------------------------------------------------------------------------
# Validation: compare column names in descriptions vs actual MSSQL schema
# ---------------------------------------------------------------------------

def parse_descriptions(path):
    """Return dict: mos_tablename → set of column names, from descriptions file."""
    tables = {}
    current = None
    col_re = re.compile(r'^\s+(\[?\w+\]?)\s+\S')   # indent + name + type word

    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\n')
            m = re.match(r'^CREATE TABLE (mos_\S+)\s*\(', line)
            if m:
                current = m.group(1)
                tables[current] = set()
                continue
            if current:
                if re.match(r'^\s*\)', line):
                    current = None
                    continue
                m = col_re.match(line)
                if m and '--/D' in line:
                    col = m.group(1).strip('[]')
                    tables[current].add(col)
    return tables


def parse_mssql_schema(path):
    """Return dict: mos_tablename → set of column names, from mssql_tables file.
    mssql_tables uses dr20_ prefix — we map it to mos_ for comparison."""
    tables = {}
    current = None
    col_re = re.compile(r'^\s+\[?(\w+)\]?\s+\S')

    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\n')
            # CREATE TABLE [dbo].[dr20_tablename] or dbo.dr20_tablename
            m = re.match(r'^CREATE TABLE\s+(?:\[?dbo\]?\.)?\[?dr20_(\S+?)\]?\s*\(', line)
            if m:
                mos_name = MOS_PREFIX + m.group(1).strip('[]() ')
                current = mos_name
                tables[current] = set()
                continue
            if current:
                if re.match(r'^\s*\)', line):
                    current = None
                    continue
                m = col_re.match(line)
                if m:
                    col = m.group(1).strip('[]')
                    # skip constraint/index keywords
                    if col.upper() not in ('CONSTRAINT', 'PRIMARY', 'UNIQUE', 'INDEX', 'ON'):
                        tables[current].add(col)
    return tables


def validate(desc_path, ms_path):
    print(f'Comparing:\n  descriptions: {desc_path}\n  mssql schema: {ms_path}\n')

    desc_tables = parse_descriptions(desc_path)
    ms_tables   = parse_mssql_schema(ms_path)

    desc_names = set(desc_tables)
    ms_names   = set(ms_tables)

    only_desc = desc_names - ms_names
    only_ms   = ms_names - desc_names
    common    = desc_names & ms_names

    if only_desc:
        print(f'Tables in descriptions but NOT in mssql schema ({len(only_desc)}):')
        for t in sorted(only_desc):
            print(f'  {t}')
        print()

    if only_ms:
        print(f'Tables in mssql schema but NOT in descriptions ({len(only_ms)}):')
        for t in sorted(only_ms):
            print(f'  {t}')
        print()

    col_issues = 0
    for table in sorted(common):
        desc_cols = desc_tables[table]
        ms_cols   = ms_tables[table]
        only_in_desc = desc_cols - ms_cols
        only_in_ms   = ms_cols - desc_cols
        if only_in_desc or only_in_ms:
            col_issues += 1
            print(f'{table}:')
            if only_in_desc:
                print(f'  in descriptions only: {sorted(only_in_desc)}')
            if only_in_ms:
                print(f'  in mssql schema only: {sorted(only_in_ms)}')

    if col_issues == 0:
        print(f'All {len(common)} common tables have matching column names.')
    else:
        print(f'\n{col_issues} tables have column mismatches.')


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))

    if '--validate' in sys.argv:
        desc_path = os.path.join(script_dir, OUTPUT)
        ms_path   = os.path.join(script_dir, INPUT_MS)
        if not os.path.exists(desc_path):
            print(f'Run without --validate first to generate {OUTPUT}')
            sys.exit(1)
        validate(desc_path, ms_path)
    else:
        input_path    = os.path.join(script_dir, INPUT_PG)
        output_path   = os.path.join(script_dir, OUTPUT)
        ms_path       = os.path.join(script_dir, INPUT_MS)
        db_types_path = os.path.join(script_dir, INPUT_DB_TYPES)
        convert(input_path, output_path, ms_path, db_types_path)

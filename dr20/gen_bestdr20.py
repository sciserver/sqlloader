"""
gen_bestdr20.py - Generate SQL scripts for loading minidb tables into BestDR20

Takes the existing minidb_dr20_v2 schema files and generates BestDR20-ready versions:
  - bestdr20_drop.sql       : Drop all existing mos_* tables in BestDR20
  - bestdr20_tables.sql     : CREATE TABLE with mos_ prefix (+ extra columns, ON [MINIDB])
  - bestdr20_pk.sql         : Primary keys with mos_ prefix + PAGE compression for large tables
  - bestdr20_load.sql       : INSERT...SELECT WITH (TABLOCK) from minidb_dr20_v2
  - bestdr20_indexes.sql    : Nonclustered indexes with mos_ prefix

Load order: drop -> tables -> PKs -> load data -> nonclustered indexes

Column additions vs base mssql_tables_0116.sql (to match minidb_dr20_v2):
  - mos_target             : htmid bigint, cx real, cy real, cz real (pre-computed, copied)
  - mos_allwise            : w1mpro_w2mpro real (PERSISTED in source, copied as regular col)
  - mos_gaia_dr2_source    : parallax_parallax_error real
  - mos_guvcat             : fuv_mag_nuv_mag real

PAGE compression applied to all tables >= 1M rows (73 tables vs original 16).

Usage:
  python gen_bestdr20.py
"""

import re
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

INPUT_TABLES   = os.path.join(SCRIPT_DIR, "mssql_tables_0603.sql")
INPUT_PK       = os.path.join(SCRIPT_DIR, "mssql_pk_0112.sql")
INPUT_INDEXES  = os.path.join(SCRIPT_DIR, "mssql_indexes_0112_portable.sql")

OUTPUT_DROP    = os.path.join(SCRIPT_DIR, "bestdr20_drop.sql")
OUTPUT_TABLES  = os.path.join(SCRIPT_DIR, "bestdr20_tables.sql")
OUTPUT_PK      = os.path.join(SCRIPT_DIR, "bestdr20_pk.sql")
OUTPUT_LOAD    = os.path.join(SCRIPT_DIR, "bestdr20_load.sql")
OUTPUT_INDEXES = os.path.join(SCRIPT_DIR, "bestdr20_indexes.sql")

SOURCE_DB = "minidb_dr20_v2"
TARGET_DB = "BestDR20"

# Tables with >= 1M rows (from minidb_dr20_v2 row count query) - get PAGE compression
# Verified 2026-06-03 via sys.partitions row count query
LARGE_TABLES = {
    "dr20_carton_to_target",          # 395M
    "dr20_assignment",                # 308M
    "dr20_sdss_id_to_catalog",        # 279M
    "dr20_sdss_id_flat",              # 278M
    "dr20_catalog",                   # 272M
    "dr20_magnitude",                 # 250M
    "dr20_catalog_to_tic_v8",         # 200M
    "dr20_target",                    # 186M
    "dr20_catalog_to_gaia_dr2_source",# 185M
    "dr20_catalog_to_allwise",        # 176M
    "dr20_catalog_to_twomass_psc",    # 168M
    "dr20_sdss_id_stacked",           # 126M
    "dr20_catalog_to_panstarrs1",     #  92M
    "dr20_catalog_to_unwise",         #  83M
    "dr20_catalog_to_legacy_survey_dr8", # 81M
    "dr20_unwise",                    #  78M
    "dr20_catalog_to_catwise2020",    #  71M
    "dr20_catwise2020",               #  70M
    "dr20_catalog_to_supercosmos",    #  68M
    "dr20_supercosmos",               #  67M
    "dr20_catalog_to_gaia_dr3_source",#  67M
    "dr20_gaia_dr3_source",           #  67M
    "dr20_tic_v8",                    #  67M
    "dr20_gaia_dr3_astrophysical_parameters", # 66M
    "dr20_gaia_dr2_ruwe",             #  62M
    "dr20_gaia_dr2_source",           #  62M
    "dr20_allwise",                   #  61M
    "dr20_catalog_to_sdss_dr13_photoobj_primary", # 61M
    "dr20_bailer_jones_edr3",         #  60M
    "dr20_gedr3spur_main",            #  60M
    "dr20_geometric_distances_gaia_dr2", # 58M
    "dr20_twomass_psc",               #  56M
    "dr20_gaiadr2_tmass_best_neighbour", # 53M
    "dr20_revised_magnitude",         #  50M
    "dr20_panstarrs1",                #  46M
    "dr20_catalog_to_guvcat",         #  40M
    "dr20_gaia_dr3_synthetic_photometry_gspc", # 39M
    "dr20_catalog_to_legacy_survey_dr10", # 37M
    "dr20_legacy_survey_dr10",        #  37M
    "dr20_catalog_to_skymapper_dr2",  #  36M
    "dr20_skymapper_dr2",             #  36M
    "dr20_xpfeh_gaia_dr3",            #  30M
    "dr20_legacy_survey_dr8",         #  27M
    "dr20_catalog_to_skies_v2",       #  25M
    "dr20_skies_v2",                  #  25M
    "dr20_skies_v1",                  #  23M
    "dr20_catalog_to_skies_v1",       #  23M
    "dr20_sdss_dr13_photoobj_primary",#  20M
    "dr20_galex_gr7_gaia_dr3",        #  16M
    "dr20_guvcat",                    #  12M
    "dr20_catalog_to_sdss_dr16_specobj", # 10M
    "dr20_lamost_dr6",                #   9M
    "dr20_catalog_to_glimpse",        #   9M
    "dr20_catalog_to_tycho2",         #   7M
    "dr20_catalog_to_uvotssc1",       #   6M
    "dr20_catalog_from_sdss_dr19p_speclite", # 6M
    "dr20_sdss_dr19p_speclite",       #   6M
    "dr20_catalog_to_sdss_dr17_specobj", # 5M
    "dr20_sdss_dr17_specobj",         #   5M
    "dr20_erosita_superset_v1_agn",   #   5M
    "dr20_sdss_dr16_specobj",         #   5M
    "dr20_skymapper_gaia",            #   3M
    "dr20_glimpse",                   #   3M
    "dr20_gaia_unwise_agn",           #   2M
    "dr20_tycho2",                    #   2M
    "dr20_ebosstarget_v5",            #   2M
    "dr20_erosita_superset_agn",      #   2M
    "dr20_uvotssc1",                  #   2M
    "dr20_catalog_to_xmm_om_suss_4_1",#  1M
    "dr20_visual_binary_gaia_dr3",    #   1M
    "dr20_catalog_to_milliquas_7_7",  #   1M
    "dr20_milliquas_7_7",             #   1M
    "dr20_catalog_to_xmm_om_suss_5_0",#  1M
    "dr20_xmm_om_suss_5_0",           #   1M
}

# Column size overrides: fixes for varchar columns undersized in mssql_tables_0116.sql
# Discovered during minidb_dr20_v2 load (fix_undersized_columns.sql) and verified again
# for BestDR20. Key: (dr20_table_name, column_name), Value: new varchar size.
COLUMN_SIZE_OVERRIDES = {
    ("dr20_guvcat", "groupgid"):            "varchar(500)",
    ("dr20_guvcat", "groupgiddist"):        "varchar(500)",
    ("dr20_guvcat", "groupgidtot"):         "varchar(500)",
    ("dr20_allstar_dr17_synspec_rev1", "targflags"):  "varchar(200)",
    ("dr20_allstar_dr17_synspec_rev1", "starflags"):  "varchar(200)",
    ("dr20_allstar_dr17_synspec_rev1", "andflags"):   "varchar(200)",
    ("dr20_opsdb_apo_camera_frame", "comment"):       "varchar(500)",
    ("dr20_sdss_apogeeallstarmerge_r13", "apstar_ids"): "varchar(1000)",
    ("dr20_sdss_apogeeallstarmerge_r13", "fields"):   "varchar(200)",
    ("dr20_sdss_apogeeallstarmerge_r13", "surveys"):  "varchar(500)",
    ("dr20_sdss_dr16_qso", "plate_duplicate"):        "varchar(500)",
    ("dr20_sdss_dr16_qso", "mjd_duplicate"):          "varchar(500)",
    ("dr20_sdss_dr16_qso", "fiberid_duplicate"):      "varchar(500)",
    ("dr20_sdss_dr16_qso", "spectro_duplicate"):      "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "stars_pk"):   "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "snr_entry"):  "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "telescopes"): "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "fields"):     "varchar(500)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "visits_pk"):  "varchar(1000)",
}

# Extra columns to append to specific tables (as regular columns - values copied from source)
# Column order must match how they appear in minidb_dr20_v2 (added via ALTER TABLE, so last)
EXTRA_COLUMNS = {
    "mos_target": [
        "    htmid bigint",
        "    cx real",
        "    cy real",
        "    cz real",
    ],
    "mos_allwise": [
        "    w1mpro_w2mpro real",
    ],
    "mos_gaia_dr2_source": [
        "    parallax_parallax_error real",
    ],
    "mos_guvcat": [
        "    fuv_mag_nuv_mag real",
    ],
}

# Expression indexes to skip (replaced by regular column indexes on the extra columns above)
SKIP_INDEX_PATTERNS = [
    r"\(\(\(w1mpro\s*-\s*w2mpro\)\)\)",
    r"\(\(\(parallax\s*-\s*parallax_error\)\)\)",
    r"\(\(\(fuv_mag\s*-\s*nuv_mag\)\)\)",
]

# Replacement indexes for the computed columns (now regular columns in BestDR20)
EXTRA_INDEXES = [
    "CREATE NONCLUSTERED INDEX mos_allwise_w1mpro_w2mpro_idx ON dbo.mos_allwise (w1mpro_w2mpro) ON [MINIDB];",
    "CREATE NONCLUSTERED INDEX mos_gaia_dr2_source_parallax_parallax_error_idx ON dbo.mos_gaia_dr2_source (parallax_parallax_error) ON [MINIDB];",
    "CREATE NONCLUSTERED INDEX mos_guvcat_fuv_mag_nuv_mag_idx ON dbo.mos_guvcat (fuv_mag_nuv_mag) ON [MINIDB];",
]


def dr20_to_mos(text):
    """Replace dr20_ prefix with mos_ in table/constraint names."""
    return text.replace("dr20_", "mos_")


def parse_tables(sql_text):
    """
    Parse mssql_tables_0116.sql into a list of (table_name, full_sql_block) tuples.
    table_name retains the dr20_ prefix.
    """
    pattern = re.compile(
        r'(DROP TABLE IF EXISTS dbo\.(dr20_\w+)\s*\n'
        r'CREATE TABLE dbo\.\2\s*\([^;]*?\);)',
        re.DOTALL
    )
    return [(m.group(2), m.group(1)) for m in pattern.finditer(sql_text)]


def inject_extra_columns(block, mos_name):
    """Inject extra columns before the closing ); of a CREATE TABLE block."""
    extras = EXTRA_COLUMNS.get(mos_name)
    if not extras:
        return block
    extra_sql = ",\n".join(extras)
    return re.sub(r'\n\);(\s*)$', f',\n{extra_sql}\n);\\1', block, flags=re.DOTALL)


def add_filegroup(block):
    """Add ON [MINIDB] to CREATE TABLE closing paren."""
    return re.sub(r'\n\);(\s*)$', r'\n) ON [MINIDB];\1', block, flags=re.DOTALL)


def generate_drop(table_names):
    lines = [
        f"USE {TARGET_DB};",
        "GO",
        "",
        "-- Drop all existing mos_* tables in reverse order",
        "",
    ]
    for tname in reversed(table_names):
        mos_name = dr20_to_mos(tname)
        lines.append(f"IF OBJECT_ID('dbo.{mos_name}', 'U') IS NOT NULL DROP TABLE dbo.{mos_name};")
    lines += ["", "GO", "PRINT 'All mos_* tables dropped.';"]
    return "\n".join(lines)


def generate_tables(tables):
    lines = [
        f"USE {TARGET_DB};",
        "GO",
        "",
        "SET QUOTED_IDENTIFIER ON;",
        "SET ANSI_NULLS ON;",
        "GO",
        "",
    ]
    count = 0
    for tname, block in tables:
        mos_name = dr20_to_mos(tname)
        mos_block = dr20_to_mos(block)
        mos_block = inject_extra_columns(mos_block, mos_name)
        mos_block = add_filegroup(mos_block)
        lines += [mos_block, "", "GO", ""]
        count += 1
    lines.append(f"PRINT 'Created {count} mos_* tables in {TARGET_DB}.';")
    print(f"  Tables: {count}")
    return "\n".join(lines)


def generate_pk(pk_sql, table_names):
    """
    Transform PK script: dr20_ -> mos_, ensure PAGE compression on all large tables.
    Also adds GO after each statement for error isolation.
    """
    # Parse into individual ALTER TABLE blocks
    block_pattern = re.compile(
        r'(ALTER TABLE dbo\.(dr20_\w+)\s+ADD CONSTRAINT \S+ PRIMARY KEY CLUSTERED \([^)]+\)'
        r'(?:\s*\nWITH \(DATA_COMPRESSION = PAGE\))?'
        r'\s+ON \[MINIDB\];)',
        re.DOTALL
    )

    lines = [
        f"USE {TARGET_DB};",
        "GO",
        "",
        "SET QUOTED_IDENTIFIER ON;",
        "SET ANSI_NULLS ON;",
        "GO",
        "",
    ]

    compressed = 0
    uncompressed = 0
    pos = 0
    for m in block_pattern.finditer(pk_sql):
        tname = m.group(2)
        block = m.group(1)
        already_compressed = "DATA_COMPRESSION = PAGE" in block

        if tname in LARGE_TABLES and not already_compressed:
            # Insert compression clause before ON [MINIDB]
            block = re.sub(r'\s+ON \[MINIDB\];$', '\nWITH (DATA_COMPRESSION = PAGE) ON [MINIDB];', block)
            compressed += 1
        elif tname in LARGE_TABLES:
            compressed += 1
        else:
            uncompressed += 1

        mos_block = dr20_to_mos(block)
        lines += [mos_block, "GO", ""]
        pos = m.end()

    lines.append(f"PRINT 'Primary keys created. Compressed: {compressed + uncompressed} total "
                 f"({compressed} with PAGE compression).';")
    print(f"  PKs: {compressed} compressed, {uncompressed} uncompressed")
    return "\n".join(lines)


def generate_load(table_names):
    """
    Generate INSERT...SELECT WITH (TABLOCK) script.
    Load order: tables -> PKs -> THIS SCRIPT -> nonclustered indexes.
    For minimal logging: database recovery model should be BULK_LOGGED or SIMPLE.
    """
    lines = [
        "-- ============================================================",
        f"-- Load data: {SOURCE_DB} -> {TARGET_DB}",
        "-- Run AFTER tables and PKs are created, BEFORE nonclustered indexes",
        "-- For minimal logging: database recovery model must be SIMPLE",
        "--   ALTER DATABASE BestDR20 SET RECOVERY SIMPLE;",
        "-- ============================================================",
        "",
        f"USE {TARGET_DB};",
        "GO",
        "",
        "SET NOCOUNT ON;",
        "GO",
        "",
    ]
    for tname in table_names:
        mos_name = dr20_to_mos(tname)
        lines.append(f"PRINT 'Loading {mos_name}... ' + CONVERT(VARCHAR, SYSDATETIME(), 121);")
        lines.append(f"TRUNCATE TABLE dbo.{mos_name};")
        lines.append(
            f"INSERT INTO dbo.{mos_name} WITH (TABLOCK)\n"
            f"SELECT * FROM {SOURCE_DB}.dbo.{tname};"
        )
        lines += ["GO", ""]
    lines.append(f"PRINT 'All tables loaded. ' + CONVERT(VARCHAR, SYSDATETIME(), 121);")
    print(f"  Load statements: {len(table_names)}")
    return "\n".join(lines)


def generate_indexes(index_sql):
    """Transform index script: dr20_ -> mos_, skip expression indexes, add replacement indexes."""
    skip_patterns = [re.compile(p) for p in SKIP_INDEX_PATTERNS]

    lines = [
        f"USE {TARGET_DB};",
        "GO",
        "",
        "SET QUOTED_IDENTIFIER ON;",
        "SET ANSI_NULLS ON;",
        "GO",
        "",
    ]

    skipped = 0
    kept = 0
    for line in index_sql.splitlines():
        if any(p.search(line) for p in skip_patterns):
            lines.append(f"-- SKIPPED (expression index, use regular col instead): {line.strip()}")
            skipped += 1
        else:
            lines.append(dr20_to_mos(line))
            if line.strip().startswith("CREATE NONCLUSTERED INDEX"):
                kept += 1

    lines += ["", "-- Indexes for extra columns (replaces skipped expression indexes)"]
    for idx in EXTRA_INDEXES:
        lines += [idx, "GO", ""]
        kept += 1

    print(f"  Indexes: {kept} kept, {skipped} expression indexes replaced")
    return "\n".join(lines)


def main():
    print("Reading input files...")
    with open(INPUT_TABLES, encoding="utf-8") as f:
        tables_sql = f.read()
    with open(INPUT_PK, encoding="utf-8") as f:
        pk_sql = f.read()
    with open(INPUT_INDEXES, encoding="utf-8") as f:
        index_sql = f.read()

    print("Parsing tables...")
    tables = parse_tables(tables_sql)
    table_names = [t[0] for t in tables]
    print(f"  Found {len(tables)} tables ({len(LARGE_TABLES)} will get PAGE compression)")

    print(f"\nGenerating {os.path.basename(OUTPUT_DROP)}...")
    with open(OUTPUT_DROP, "w", encoding="utf-8") as f:
        f.write(generate_drop(table_names))

    print(f"Generating {os.path.basename(OUTPUT_TABLES)}...")
    with open(OUTPUT_TABLES, "w", encoding="utf-8") as f:
        f.write(generate_tables(tables))

    print(f"Generating {os.path.basename(OUTPUT_PK)}...")
    with open(OUTPUT_PK, "w", encoding="utf-8") as f:
        f.write(generate_pk(pk_sql, table_names))

    print(f"Generating {os.path.basename(OUTPUT_LOAD)}...")
    with open(OUTPUT_LOAD, "w", encoding="utf-8") as f:
        f.write(generate_load(table_names))

    print(f"Generating {os.path.basename(OUTPUT_INDEXES)}...")
    with open(OUTPUT_INDEXES, "w", encoding="utf-8") as f:
        f.write(generate_indexes(index_sql))

    print("\nOutput files:")
    for path in [OUTPUT_DROP, OUTPUT_TABLES, OUTPUT_PK, OUTPUT_LOAD, OUTPUT_INDEXES]:
        size = os.path.getsize(path)
        print(f"  {os.path.basename(path):35s} {size:>10,} bytes")

    print(f"""
Execution order:
  1. Drop existing mos_* tables:
       sqlcmd -S localhost -d {TARGET_DB} -E -i bestdr20_drop.sql

  2. Create tables (heap, ON [MINIDB]):
       sqlcmd -S localhost -d {TARGET_DB} -E -i bestdr20_tables.sql

  3. Create primary keys (clustered, PAGE compression on {len(LARGE_TABLES)} large tables):
       sqlcmd -S localhost -d {TARGET_DB} -E -i bestdr20_pk.sql -o bestdr20_pk_results.txt

  4. Load data (INSERT...SELECT WITH TABLOCK - set BULK_LOGGED first for minimal logging):
       sqlcmd -S localhost -d {TARGET_DB} -E -i bestdr20_load.sql -o bestdr20_load_results.txt

  5. Create nonclustered indexes:
       sqlcmd -S localhost -d {TARGET_DB} -E -i bestdr20_indexes.sql -o bestdr20_index_results.txt
""")


if __name__ == "__main__":
    main()

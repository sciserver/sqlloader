"""
fix_tables_schema.py - Produce a corrected mssql_tables_0603.sql from mssql_tables_0116.sql

Applies all column size fixes discovered during the DR20 load process
(originally patched via fix_undersized_columns.sql) so the schema file
is correct and can be run without any post-hoc ALTER TABLE patches.
"""

import re
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT  = os.path.join(SCRIPT_DIR, "mssql_tables_0116.sql")
OUTPUT = os.path.join(SCRIPT_DIR, "mssql_tables_0603.sql")

# (table_name, column_name) -> corrected type
# Source: fix_undersized_columns.sql + BestDR20 load verification 2026-06-03
FIXES = {
    ("dr20_guvcat", "groupgid"):            "varchar(500)",
    ("dr20_guvcat", "groupgiddist"):        "varchar(500)",
    ("dr20_guvcat", "groupgidtot"):         "varchar(500)",
    ("dr20_allstar_dr17_synspec_rev1", "targflags"):    "varchar(200)",
    ("dr20_allstar_dr17_synspec_rev1", "starflags"):    "varchar(200)",
    ("dr20_allstar_dr17_synspec_rev1", "andflags"):     "varchar(200)",
    ("dr20_opsdb_apo_camera_frame", "comment"):         "varchar(500)",
    ("dr20_sdss_apogeeallstarmerge_r13", "apstar_ids"): "varchar(1000)",
    ("dr20_sdss_apogeeallstarmerge_r13", "fields"):     "varchar(200)",
    ("dr20_sdss_apogeeallstarmerge_r13", "surveys"):    "varchar(500)",
    ("dr20_sdss_dr16_qso", "plate_duplicate"):          "varchar(500)",
    ("dr20_sdss_dr16_qso", "mjd_duplicate"):            "varchar(500)",
    ("dr20_sdss_dr16_qso", "fiberid_duplicate"):        "varchar(500)",
    ("dr20_sdss_dr16_qso", "spectro_duplicate"):        "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "stars_pk"):   "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "snr_entry"):  "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "telescopes"): "varchar(200)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "fields"):     "varchar(500)",
    ("dr20_sdss_dr17_apogee_allstarmerge", "visits_pk"):  "varchar(1000)",
}

# Build a lookup: table -> {col -> new_type}
table_fixes = {}
for (tname, col), new_type in FIXES.items():
    table_fixes.setdefault(tname, {})[col] = new_type

# Parse into table blocks (same pattern as gen_bestdr20.py)
block_pattern = re.compile(
    r'(DROP TABLE IF EXISTS dbo\.(dr20_\w+)\s*\n'
    r'CREATE TABLE dbo\.\2\s*\([^;]*?\);)',
    re.DOTALL
)

def fix_block(block, tname):
    fixes = table_fixes.get(tname, {})
    for col, new_type in fixes.items():
        before = block
        block = re.sub(
            rf'(\b{re.escape(col)}\s+)varchar\(\d+\)',
            rf'\g<1>{new_type}',
            block
        )
        if block != before:
            print(f"  {tname}.{col} -> {new_type}")
        else:
            print(f"  WARNING: no match for {tname}.{col}")
    return block

with open(INPUT, encoding="utf-8") as f:
    sql = f.read()

# Apply fixes block by block
def replacer(m):
    tname = m.group(2)
    block = m.group(1)
    if tname in table_fixes:
        block = fix_block(block, tname)
    return block

fixed_sql = block_pattern.sub(replacer, sql)

# Add header comment
header = (
    "-- mssql_tables_0603.sql\n"
    "-- Generated from mssql_tables_0116.sql with column size corrections applied.\n"
    "-- Fixes: 22 undersized varchar columns across 6 tables (see fix_undersized_columns.sql).\n"
    "-- Do not edit manually -- regenerate via fix_tables_schema.py if changes are needed.\n\n"
)

with open(OUTPUT, "w", encoding="utf-8") as f:
    f.write(header + fixed_sql)

print(f"\nWrote {OUTPUT}")
print(f"Input size:  {os.path.getsize(INPUT):,} bytes")
print(f"Output size: {os.path.getsize(OUTPUT):,} bytes")

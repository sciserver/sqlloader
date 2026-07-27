#!/usr/bin/env python3
"""
Parse varchar(max) analysis results and fix mssql_tables_0112.sql
"""

import re

# Parse the analysis results
results = []
with open(r'H:\GitHub\sqlloader\dr20\varchar_max_analysis_results.txt', 'r', encoding='utf-8') as f:
    in_data_section = False
    for line in f:
        # Skip until we find the data section
        if '-- ALL VARCHAR(MAX) COLUMNS' in line:
            in_data_section = True
            next(f)  # Skip separator
            next(f)  # Skip header
            continue

        if in_data_section and line.strip() and not line.startswith('--'):
            parts = line.split()
            if len(parts) >= 5:
                table_name = parts[0]
                column_name = parts[1]
                try:
                    max_len = int(parts[2])
                    rec_size = int(parts[3])
                    results.append((table_name, column_name, max_len, rec_size))
                except (ValueError, IndexError):
                    continue

print(f"Found {len(results)} varchar(max) columns to fix")
print()

# Group by recommended size
by_size = {}
for table, col, max_len, rec_size in results:
    if rec_size not in by_size:
        by_size[rec_size] = []
    by_size[rec_size].append((table, col, max_len))

print("Breakdown by recommended size:")
for size in sorted(by_size.keys(), reverse=True):
    print(f"  varchar({size:5}): {len(by_size[size]):3} columns")
print()

# Now fix the mssql_tables_0112.sql file
input_file = r'H:\GitHub\sqlloader\dr20\mssql_tables_0112.sql'
output_file = r'H:\GitHub\sqlloader\dr20\mssql_tables_0116.sql'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Create replacement map: (table_name, column_name) -> size
replacement_map = {(t, c): s for t, c, _, s in results}

# Strategy: Replace varchar(max) with varchar(n) for specific table.column combinations
# We need to be context-aware to only replace the right columns in the right tables

fixes_made = 0
lines = content.split('\n')
current_table = None

for i, line in enumerate(lines):
    # Track which table we're in
    if 'CREATE TABLE' in line:
        match = re.search(r'CREATE TABLE\s+(\[?dbo\]?\.)?\[?(\w+)\]?', line)
        if match:
            current_table = match.group(2)

    # If we're in a table and this line has varchar(max)
    if current_table and 'varchar(max)' in line.lower():
        # Extract column name
        match = re.search(r'^\s*\[?(\w+)\]?\s+varchar\(max\)', line, re.IGNORECASE)
        if match:
            column_name = match.group(1)

            # Check if this table.column is in our replacement map
            if (current_table, column_name) in replacement_map:
                rec_size = replacement_map[(current_table, column_name)]
                # Replace varchar(max) with varchar(n)
                lines[i] = re.sub(r'varchar\(max\)', f'varchar({rec_size})', line, flags=re.IGNORECASE)
                fixes_made += 1

# Write the fixed file
with open(output_file, 'w', encoding='utf-8', newline='\n') as f:
    f.write('\n'.join(lines))

print(f"Fixed {fixes_made} varchar(max) columns")
print(f"Created: {output_file}")
print()
print("Next steps:")
print(f"  1. Use mssql_tables_0116.sql to create tables in minidb_dr20_v2")
print(f"  2. Old file (mssql_tables_0112.sql) unchanged for reference")

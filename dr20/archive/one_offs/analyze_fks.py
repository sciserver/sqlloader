#!/usr/bin/env python3
"""
Analyze foreign key failures by parsing FK definitions and checking database schema
"""

import re
import subprocess
import sys

def run_query(query):
    """Execute SQL query via sqlcmd and return results"""
    cmd = ['sqlcmd', '-S', 'localhost', '-d', 'minidb_dr20_v2', '-E', '-h', '-1', '-W', '-s', '|', '-Q', query]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip()

def parse_fk_file(filename):
    """Parse FK file and extract FK definitions"""
    fks = []
    with open(filename, 'r') as f:
        content = f.read()

    # Pattern: ALTER TABLE dbo.table ADD CONSTRAINT name FOREIGN KEY (col) REFERENCES dbo.parent_table(parent_col);
    pattern = r'ALTER TABLE dbo\.(\w+)\s+ADD CONSTRAINT (\w+) FOREIGN KEY \(([^)]+)\) REFERENCES dbo\.(\w+)\(([^)]+)\)'

    for match in re.finditer(pattern, content):
        child_table = match.group(1)
        fk_name = match.group(2)
        child_col = match.group(3)
        parent_table = match.group(4)
        parent_col = match.group(5).replace('[', '').replace(']', '')

        fks.append({
            'fk_name': fk_name,
            'child_table': child_table,
            'child_column': child_col,
            'parent_table': parent_table,
            'parent_column': parent_col
        })

    return fks

def check_fk(fk):
    """Check FK status and gather diagnostics"""
    # Check if FK exists
    query = f"SELECT CASE WHEN EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = '{fk['fk_name']}') THEN 1 ELSE 0 END"
    fk_exists = run_query(query).strip() == '1'

    if fk_exists:
        return {'status': 'SUCCESS', 'issue': None}

    # Check child column type
    query = f"""
    SELECT TOP 1 ty.name + CASE
        WHEN ty.name IN ('varchar', 'char', 'nvarchar', 'nchar') THEN '(' + CASE c.max_length WHEN -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR) END + ')'
        WHEN ty.name IN ('decimal', 'numeric') THEN '(' + CAST(c.precision AS VARCHAR) + ',' + CAST(c.scale AS VARCHAR) + ')'
        ELSE ''
    END
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID('dbo.{fk['child_table']}') AND c.name = '{fk['child_column']}'
    """
    child_type = run_query(query).strip()

    # Check parent column type
    query = f"""
    SELECT TOP 1 ty.name + CASE
        WHEN ty.name IN ('varchar', 'char', 'nvarchar', 'nchar') THEN '(' + CASE c.max_length WHEN -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR) END + ')'
        WHEN ty.name IN ('decimal', 'numeric') THEN '(' + CAST(c.precision AS VARCHAR) + ',' + CAST(c.scale AS VARCHAR) + ')'
        ELSE ''
    END
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID('dbo.{fk['parent_table']}') AND c.name = '{fk['parent_column']}'
    """
    parent_type = run_query(query).strip()

    # Check if parent column has PK/unique constraint
    query = f"""
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM sys.indexes i
        JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.object_id = OBJECT_ID('dbo.{fk['parent_table']}')
        AND c.name = '{fk['parent_column']}'
        AND (i.is_primary_key = 1 OR i.is_unique = 1)
    ) THEN 1 ELSE 0 END
    """
    has_pk_unique = run_query(query).strip() == '1'

    # Determine issue
    issue = None
    if not child_type:
        issue = f"Child column '{fk['child_column']}' does not exist in table '{fk['child_table']}'"
    elif not parent_type:
        issue = f"Parent column '{fk['parent_column']}' does not exist in table '{fk['parent_table']}'"
    elif child_type != parent_type:
        issue = f"Data type mismatch: {fk['child_table']}.{fk['child_column']} ({child_type}) != {fk['parent_table']}.{fk['parent_column']} ({parent_type})"
    elif not has_pk_unique:
        issue = f"Parent column '{fk['parent_table']}.{fk['parent_column']}' does not have a primary key or unique constraint"
    else:
        # Try to create it and capture the error
        issue = "Unknown - constraint creation failed (possibly orphaned references)"

    return {
        'status': 'FAILED',
        'issue': issue,
        'child_type': child_type,
        'parent_type': parent_type,
        'has_pk_unique': has_pk_unique
    }

def main():
    print("Parsing FK definitions from mssql_fk_0112_skip_plan.sql...")
    fks = parse_fk_file('mssql_fk_0112_skip_plan.sql')
    print(f"Found {len(fks)} FK definitions")
    print()

    print("Analyzing each FK...")
    results = []
    for i, fk in enumerate(fks, 1):
        print(f"  [{i}/{len(fks)}] {fk['fk_name']}", end='', flush=True)
        result = check_fk(fk)
        fk.update(result)
        results.append(fk)
        print(f" ... {result['status']}")

    # Write results to markdown file
    print()
    print("Writing results to fk_analysis_report.md...")

    with open('fk_analysis_report.md', 'w') as f:
        f.write("# Foreign Key Analysis Report\n\n")
        f.write(f"**Total FKs**: {len(results)}\n\n")

        success = [r for r in results if r['status'] == 'SUCCESS']
        failed = [r for r in results if r['status'] == 'FAILED']

        f.write(f"**Successful**: {len(success)}\n\n")
        f.write(f"**Failed**: {len(failed)}\n\n")

        f.write("---\n\n")

        f.write("## Successful Foreign Keys\n\n")
        for fk in success:
            f.write(f"- `{fk['fk_name']}`\n")
            f.write(f"  - {fk['child_table']}.{fk['child_column']} → {fk['parent_table']}.{fk['parent_column']}\n\n")

        f.write("---\n\n")

        f.write("## Failed Foreign Keys\n\n")

        # Group by issue type
        type_mismatch = [r for r in failed if r.get('issue') and 'Data type mismatch' in r['issue']]
        no_pk_unique = [r for r in failed if r.get('issue') and 'does not have a primary key' in r['issue']]
        missing_col = [r for r in failed if r.get('issue') and 'does not exist' in r['issue']]
        unknown = [r for r in failed if r.get('issue') and 'Unknown' in r['issue']]

        if type_mismatch:
            f.write(f"### Data Type Mismatches ({len(type_mismatch)})\n\n")
            for fk in type_mismatch:
                f.write(f"**{fk['fk_name']}**\n\n")
                f.write(f"- Child: `{fk['child_table']}.{fk['child_column']}` ({fk.get('child_type', 'N/A')})\n")
                f.write(f"- Parent: `{fk['parent_table']}.{fk['parent_column']}` ({fk.get('parent_type', 'N/A')})\n")
                f.write(f"- Issue: {fk['issue']}\n\n")

        if no_pk_unique:
            f.write(f"### Missing Primary Key / Unique Constraint ({len(no_pk_unique)})\n\n")
            for fk in no_pk_unique:
                f.write(f"**{fk['fk_name']}**\n\n")
                f.write(f"- Child: `{fk['child_table']}.{fk['child_column']}`\n")
                f.write(f"- Parent: `{fk['parent_table']}.{fk['parent_column']}`\n")
                f.write(f"- Issue: {fk['issue']}\n\n")

        if missing_col:
            f.write(f"### Missing Columns ({len(missing_col)})\n\n")
            for fk in missing_col:
                f.write(f"**{fk['fk_name']}**\n\n")
                f.write(f"- Issue: {fk['issue']}\n\n")

        if unknown:
            f.write(f"### Unknown Issues ({len(unknown)})\n\n")
            f.write("These likely failed due to orphaned references (child records without matching parent records).\n\n")
            for fk in unknown:
                f.write(f"- `{fk['fk_name']}`: {fk['child_table']}.{fk['child_column']} → {fk['parent_table']}.{fk['parent_column']}\n")

    print(f"Report written to fk_analysis_report.md")
    print(f"Summary: {len(success)} succeeded, {len(failed)} failed")

if __name__ == '__main__':
    main()

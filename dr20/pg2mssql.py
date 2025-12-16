#!/usr/bin/env python3
"""
PostgreSQL to MS SQL Server Schema Converter for SDSS Data Releases

Converts PostgreSQL DDL (from pg_dump) to T-SQL compatible with SQL Server 2022.
Generates separate files for tables, primary keys, indexes, and foreign keys.

Usage:
    python pg2mssql.py input.sql output_dir --date 1216 --prefix dbo
"""

import argparse
import os
import sys
from datetime import datetime


class PgToMsSqlConverter:
    """Converts PostgreSQL schema to SQL Server T-SQL."""

    # Tables that should use PAGE compression (Tier 1 + Tier 2: >10 GB CSV files)
    COMPRESSION_TABLES = {
        # Tier 1: >20 GB
        'dr20_allwise', 'dr20_catwise2020', 'dr20_panstarrs1', 'dr20_tic_v8',
        'dr20_sdss_id_to_catalog', 'dr20_unwise', 'dr20_legacy_survey_dr10',
        'dr20_supercosmos', 'dr20_sdss_id_flat', 'dr20_magnitude',
        'dr20_legacy_survey_dr8', 'dr20_catalog',
        # Tier 2: 10-20 GB
        'dr20_twomass_psc', 'dr20_skymapper_dr2', 'dr20_carton_to_target', 'dr20_target',
    }

    def __init__(self, pg_schema_prefix='minidb_dr20.', output_schema='dbo.', enable_compression=True):
        """
        Initialize converter with schema prefixes.

        Args:
            pg_schema_prefix: PostgreSQL schema prefix to replace (e.g., 'minidb_dr20.')
            output_schema: SQL Server schema to use (e.g., 'dbo.')
            enable_compression: Whether to add PAGE compression to large tables
        """
        self.pg_schema_prefix = pg_schema_prefix
        self.output_schema = output_schema
        self.enable_compression = enable_compression
        self.tables = []
        self.pks = []
        self.indexes = []
        self.fks = []
        self.compressed_tables = set()

    def convert_data_types(self, line):
        """Convert PostgreSQL data types to SQL Server equivalents."""
        conversions = {
            'boolean': 'bit',
            'character varying': 'varchar',
            'text': 'varchar(500)',
            'character': 'varchar',
            'timestamp without time zone': 'datetime',
            'uuid': 'uniqueidentifier',
            'bit(1)': 'bit',
        }

        result = line
        for pg_type, mssql_type in conversions.items():
            result = result.replace(pg_type, mssql_type)

        return result

    def handle_reserved_words(self, line):
        """Handle SQL Server reserved words by adding brackets."""
        reserved_words = {
            ' plan ': ' planname ',
            ' plan,': ' planname,',
            'public.': '[public].',
            ' public ': ' [public] ',
            ' public,': ' [public],',
            ' file ': ' [file] ',
            ' file,': ' [file],',
            ' offsets ': ' [offsets] ',
            ' offsets,': ' [offsets],',
        }

        result = line
        for word, replacement in reserved_words.items():
            result = result.replace(word, replacement)

        return result

    def replace_schema_prefix(self, line):
        """Replace PostgreSQL schema prefix with SQL Server schema."""
        return line.replace(self.pg_schema_prefix, self.output_schema)

    def process_line(self, line):
        """Apply all transformations to a line."""
        line = self.replace_schema_prefix(line)
        line = self.convert_data_types(line)
        line = self.handle_reserved_words(line)
        return line

    def parse_file(self, filename):
        """Parse PostgreSQL DDL file and extract database objects."""
        print(f"Reading {filename}...")

        with open(filename, 'r', encoding='utf-8') as f:
            lines = iter(f)
            for line in lines:
                # Create tables
                if line.startswith('CREATE TABLE'):
                    table = [line]
                    for line in lines:
                        table.append(line)
                        if line.startswith(');'):
                            self.tables.append(table)
                            break

                # Primary keys and foreign keys
                elif line.startswith('ALTER TABLE'):
                    alter = [line]
                    for line in lines:
                        alter.append(line)
                        if 'PRIMARY KEY' in line:
                            self.pks.append(alter)
                            break
                        elif 'FOREIGN KEY' in line:
                            self.fks.append(alter)
                            break
                        elif line.strip().endswith(';'):
                            # Some other ALTER statement, skip it
                            break

                # Indexes (but skip q3c spatial indexes)
                elif line.startswith('CREATE INDEX'):
                    if 'q3c_ang2ipix' not in line:
                        self.indexes.append([line])

        print(f"  Found {len(self.tables)} tables")
        print(f"  Found {len(self.pks)} primary keys")
        print(f"  Found {len(self.indexes)} indexes")
        print(f"  Found {len(self.fks)} foreign keys")

    def write_tables(self, output_dir, date_suffix):
        """Write CREATE TABLE statements to file."""
        filename = os.path.join(output_dir, f'mssql_tables_{date_suffix}.sql')
        print(f"\nWriting {filename}...")

        with open(filename, 'w', encoding='utf-8') as f:
            for table in self.tables:
                f.write('\n\n')
                for idx, line in enumerate(table):
                    if idx == 0:
                        # Extract table name and add DROP IF EXISTS
                        parts = line.split()
                        tablename = self.replace_schema_prefix(parts[2])
                        f.write(f'DROP TABLE IF EXISTS {tablename}\n')

                    # Process and write line
                    processed = self.process_line(line)
                    f.write(processed)

        print(f"  Wrote {len(self.tables)} tables")
        return filename

    def write_pks(self, output_dir, date_suffix):
        """Write PRIMARY KEY constraints to file."""
        filename = os.path.join(output_dir, f'mssql_pk_{date_suffix}.sql')
        print(f"\nWriting {filename}...")

        with open(filename, 'w', encoding='utf-8') as f:
            for pk_idx, pk in enumerate(self.pks):
                f.write('\n\n')

                # Extract table name from ALTER TABLE statement
                table_name = None
                for line in pk:
                    if 'ALTER TABLE' in line:
                        # Process the line and remove ONLY keyword
                        processed = self.process_line(line)
                        processed = processed.replace('ONLY ', '')
                        parts = processed.split()
                        for i, part in enumerate(parts):
                            if part == 'TABLE':
                                # Get tablename with schema (e.g., "dbo.dr20_allwise")
                                # The table name is right after TABLE keyword
                                full_name = parts[i + 1].strip()
                                # Remove schema prefix to get just table name
                                if '.' in full_name:
                                    table_name = full_name.split('.', 1)[1]
                                else:
                                    table_name = full_name
                                break
                        break

                # Write the PK constraint - collect all lines first
                pk_lines = []
                for line in pk:
                    processed = self.process_line(line)
                    processed = processed.replace('ONLY ', '')
                    processed = processed.replace('PRIMARY KEY', 'PRIMARY KEY CLUSTERED')
                    pk_lines.append(processed)

                # Add compression if table qualifies
                if self.enable_compression and table_name in self.COMPRESSION_TABLES:
                    # Find the line with the semicolon and replace it
                    for i in range(len(pk_lines) - 1, -1, -1):
                        if ';' in pk_lines[i]:
                            pk_lines[i] = pk_lines[i].rstrip(';\n\r\t ')
                            pk_lines[i] += '\nWITH (DATA_COMPRESSION = PAGE);\n'
                            self.compressed_tables.add(table_name)
                            break

                # Write all lines
                for line in pk_lines:
                    f.write(line)

        if self.compressed_tables:
            print(f"  Wrote {len(self.pks)} primary keys ({len(self.compressed_tables)} with PAGE compression)")
        else:
            print(f"  Wrote {len(self.pks)} primary keys")

        return filename

    def write_indexes(self, output_dir, date_suffix):
        """Write CREATE INDEX statements to file."""
        filename = os.path.join(output_dir, f'mssql_indexes_{date_suffix}.sql')
        print(f"\nWriting {filename}...")

        with open(filename, 'w', encoding='utf-8') as f:
            for idx in self.indexes:
                f.write('\n\n')
                for line in idx:
                    processed = self.process_line(line)
                    processed = processed.replace('CREATE INDEX', 'CREATE NONCLUSTERED INDEX')
                    processed = processed.replace('USING btree', '')
                    f.write(processed)

        print(f"  Wrote {len(self.indexes)} indexes")
        return filename

    def write_fks(self, output_dir, date_suffix):
        """Write FOREIGN KEY constraints to file."""
        filename = os.path.join(output_dir, f'mssql_fk_{date_suffix}.sql')
        print(f"\nWriting {filename}...")

        with open(filename, 'w', encoding='utf-8') as f:
            for fk in self.fks:
                f.write('\n\n')
                for line in fk:
                    processed = self.process_line(line)
                    processed = processed.replace('ONLY ', '')
                    f.write(processed)

        print(f"  Wrote {len(self.fks)} foreign keys")
        return filename

    def validate_output(self, *filenames):
        """Basic validation - check files exist and aren't empty."""
        print("\nValidating output files...")
        all_valid = True

        for filename in filenames:
            if not os.path.exists(filename):
                print(f"  ERROR: {filename} was not created!")
                all_valid = False
            else:
                size = os.path.getsize(filename)
                if size == 0:
                    print(f"  WARNING: {filename} is empty!")
                    all_valid = False
                else:
                    print(f"  OK: {filename} ({size:,} bytes)")

        return all_valid


def main():
    parser = argparse.ArgumentParser(
        description='Convert PostgreSQL schema to SQL Server T-SQL',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python pg2mssql.py input.sql dr20_output
  python pg2mssql.py input.sql dr20_output --date 1216
  python pg2mssql.py input.sql dr20_output --date 1216 --schema dbo
        """
    )

    parser.add_argument('input_file', help='Input PostgreSQL DDL file')
    parser.add_argument('output_dir', help='Output directory for generated SQL files')
    parser.add_argument('--date', default=datetime.now().strftime('%m%d'),
                       help='Date suffix for output files (default: today MMDD)')
    parser.add_argument('--schema', default='dbo',
                       help='SQL Server schema name (default: dbo)')
    parser.add_argument('--pg-schema', default='minidb_dr20',
                       help='PostgreSQL schema prefix to replace (default: minidb_dr20)')
    parser.add_argument('--dry-run', action='store_true',
                       help='Parse input but do not write output files')
    parser.add_argument('--no-compression', action='store_true',
                       help='Disable automatic PAGE compression on large tables')

    args = parser.parse_args()

    # Validate input
    if not os.path.exists(args.input_file):
        print(f"ERROR: Input file '{args.input_file}' not found!")
        return 1

    # Create output directory if needed
    if not args.dry_run:
        os.makedirs(args.output_dir, exist_ok=True)

    # Initialize converter
    pg_schema_prefix = f"{args.pg_schema}."
    output_schema = f"{args.schema}."
    enable_compression = not args.no_compression

    print(f"\nPostgreSQL to SQL Server Schema Converter")
    print(f"=" * 60)
    print(f"Input file:    {args.input_file}")
    print(f"Output dir:    {args.output_dir}")
    print(f"Date suffix:   {args.date}")
    print(f"Schema:        {pg_schema_prefix} -> {output_schema}")
    print(f"Compression:   {'Enabled (16 large tables)' if enable_compression else 'Disabled'}")
    print(f"Dry run:       {args.dry_run}")
    print(f"=" * 60)

    # Parse and convert
    converter = PgToMsSqlConverter(pg_schema_prefix, output_schema, enable_compression)
    converter.parse_file(args.input_file)

    if args.dry_run:
        print("\nDry run - no files written")
        return 0

    # Write output files
    table_file = converter.write_tables(args.output_dir, args.date)
    pk_file = converter.write_pks(args.output_dir, args.date)
    idx_file = converter.write_indexes(args.output_dir, args.date)
    fk_file = converter.write_fks(args.output_dir, args.date)

    # Validate
    if converter.validate_output(table_file, pk_file, idx_file, fk_file):
        print("\n[SUCCESS] Conversion completed successfully!")
        return 0
    else:
        print("\n[WARNING] Conversion completed with warnings")
        return 1


if __name__ == '__main__':
    sys.exit(main())

#!/usr/bin/env python3
"""
SDSS DR20 CSV Bulk Loader

Validates CSV files by loading first 10 rows (test mode) and generates
BULK INSERT SQL scripts for files that pass validation.

Usage:
    python bulk_loader.py E:\\DR20\\minidb_dr20\\casload dr20 --test-mode --generate-sql --connection "Server=localhost;Database=minidb_dr20;Trusted_Connection=yes"
"""

import argparse
import os
import sys
from datetime import datetime
from dataclasses import dataclass
from typing import List, Tuple, Optional


@dataclass
class TestResult:
    """Stores test results for a single CSV file."""
    filename: str
    table_name: str
    file_size_mb: float
    success: bool
    rows_tested: int
    error_message: str
    retry_attempts: int = 0


class BulkLoader:
    """Loads CSV files into SQL Server using BULK INSERT."""

    def __init__(self, csv_dir: str, output_dir: str, connection_string: Optional[str] = None):
        """
        Initialize bulk loader.

        Args:
            csv_dir: Directory containing CSV files (e.g., E:\\DR20\\minidb_dr20\\casload)
            output_dir: Output directory for SQL and report files
            connection_string: SQL Server connection string (optional for SQL generation mode)
        """
        self.csv_dir = csv_dir
        self.output_dir = output_dir
        self.connection_string = connection_string
        self.results: List[TestResult] = []
        self.conn = None

    def connect_database(self):
        """Establish database connection using pymssql."""
        if not self.connection_string:
            print("No connection string provided - SQL generation mode only")
            return False

        try:
            import pymssql
            # Parse connection string (format: "Server=X;Database=Y;Trusted_Connection=yes")
            params = {}
            for part in self.connection_string.split(';'):
                if '=' in part:
                    key, value = part.split('=', 1)
                    params[key.strip()] = value.strip()

            # Map connection string params to pymssql params
            conn_params = {'database': params.get('Database', 'minidb_dr20')}

            if params.get('Trusted_Connection', '').lower() == 'yes':
                # Windows authentication
                conn_params['server'] = params.get('Server', 'localhost')
            else:
                # SQL authentication
                conn_params['server'] = params.get('Server', 'localhost')
                conn_params['user'] = params.get('User Id', params.get('UID', 'sa'))
                conn_params['password'] = params.get('Password', params.get('PWD', ''))

            self.conn = pymssql.connect(**conn_params)
            print(f"Connected to SQL Server: {params.get('Server', 'localhost')} / {params.get('Database', 'minidb_dr20')}")
            return True

        except ImportError:
            print("ERROR: pymssql not installed. Run: pip install pymssql")
            return False
        except Exception as e:
            print(f"ERROR: Database connection failed: {e}")
            return False

    def disconnect_database(self):
        """Close database connection."""
        if self.conn:
            self.conn.close()
            self.conn = None

    def scan_csv_files(self) -> List[Tuple[str, str]]:
        """
        Scan CSV directory for files matching pattern minidb_dr20.dr20_*.csv

        Returns:
            List of (filepath, table_name) tuples
        """
        csv_files = []

        if not os.path.exists(self.csv_dir):
            print(f"ERROR: CSV directory not found: {self.csv_dir}")
            return csv_files

        print(f"\nScanning {self.csv_dir}...")

        for filename in os.listdir(self.csv_dir):
            if filename.startswith('minidb_dr20.dr20_') and filename.endswith('.csv'):
                filepath = os.path.join(self.csv_dir, filename)
                table_name = self.extract_table_name(filename)
                csv_files.append((filepath, table_name))

        csv_files.sort(key=lambda x: x[1])  # Sort by table name
        print(f"Found {len(csv_files)} CSV files\n")

        return csv_files

    def extract_table_name(self, filename: str) -> str:
        """
        Extract table name from CSV filename.

        Args:
            filename: CSV filename (e.g., 'minidb_dr20.dr20_allwise.csv')

        Returns:
            Table name (e.g., 'dr20_allwise')
        """
        # Remove 'minidb_dr20.' prefix and '.csv' suffix
        if filename.startswith('minidb_dr20.'):
            filename = filename[12:]  # Remove 'minidb_dr20.'
        if filename.endswith('.csv'):
            filename = filename[:-4]  # Remove '.csv'
        return filename

    def get_file_size_mb(self, filepath: str) -> float:
        """Get file size in megabytes."""
        try:
            size_bytes = os.path.getsize(filepath)
            return size_bytes / (1024 * 1024)
        except:
            return 0.0

    def get_csv_sample(self, filepath: str, num_lines: int = 5) -> str:
        """
        Read first few lines of CSV for error reporting.

        Args:
            filepath: Path to CSV file
            num_lines: Number of lines to read

        Returns:
            First N lines as string
        """
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                lines = [next(f) for _ in range(min(num_lines, 10))]
                return ''.join(lines)
        except Exception as e:
            return f"Could not read file: {e}"

    def generate_bulk_insert_sql(self, csv_path: str, table_name: str, test_mode: bool = False) -> str:
        """
        Generate BULK INSERT SQL statement.

        Args:
            csv_path: Full path to CSV file
            table_name: Target table name
            test_mode: If True, add LASTROW=11 to load only first 10 rows

        Returns:
            BULK INSERT SQL statement
        """
        sql = f"BULK INSERT dbo.{table_name}\n"
        sql += f"FROM '{csv_path}'\n"
        sql += "WITH (\n"
        sql += "    DATAFILETYPE='char',\n"
        sql += "    FIRSTROW=2,\n"

        if test_mode:
            sql += "    LASTROW=11,\n"

        sql += "    FIELDTERMINATOR=',',\n"
        sql += "    ROWTERMINATOR='0x0a',\n"
        sql += "    TABLOCK,\n"
        sql += "    FIELDQUOTE='\"'\n"
        sql += ");"

        return sql

    def test_load_file(self, csv_path: str, table_name: str) -> TestResult:
        """
        Test load first 10 rows of CSV file.

        Args:
            csv_path: Full path to CSV file
            table_name: Target table name

        Returns:
            TestResult with success status and details
        """
        file_size_mb = self.get_file_size_mb(csv_path)
        filename = os.path.basename(csv_path)

        if not self.conn:
            # No database connection - mark as skipped
            return TestResult(
                filename=filename,
                table_name=table_name,
                file_size_mb=file_size_mb,
                success=False,
                rows_tested=0,
                error_message="No database connection (SQL generation mode)"
            )

        try:
            cursor = self.conn.cursor()

            # Truncate table first to ensure clean slate
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            self.conn.commit()

            # Generate and execute BULK INSERT with LASTROW=11
            bulk_sql = self.generate_bulk_insert_sql(csv_path, table_name, test_mode=True)
            cursor.execute(bulk_sql)
            self.conn.commit()

            # Verify row count
            cursor.execute(f"SELECT COUNT(*) FROM dbo.{table_name}")
            row_count = cursor.fetchone()[0]
            cursor.close()

            if row_count != 10:
                error_msg = f"Expected 10 rows, got {row_count}"
                return TestResult(
                    filename=filename,
                    table_name=table_name,
                    file_size_mb=file_size_mb,
                    success=False,
                    rows_tested=row_count,
                    error_message=error_msg
                )

            # Success - leave data in table for inspection
            return TestResult(
                filename=filename,
                table_name=table_name,
                file_size_mb=file_size_mb,
                success=True,
                rows_tested=10,
                error_message=""
            )

        except Exception as e:
            error_msg = str(e)
            return TestResult(
                filename=filename,
                table_name=table_name,
                file_size_mb=file_size_mb,
                success=False,
                rows_tested=0,
                error_message=error_msg
            )

    def run_test_mode(self, csv_files: List[Tuple[str, str]]):
        """
        Run test mode on all CSV files.

        Args:
            csv_files: List of (filepath, table_name) tuples
        """
        print(f"\n{'='*80}")
        print(f"TEST MODE: Loading first 10 rows from each CSV file")
        print(f"{'='*80}\n")

        total_files = len(csv_files)

        for idx, (csv_path, table_name) in enumerate(csv_files, 1):
            filename = os.path.basename(csv_path)
            print(f"[{idx}/{total_files}] Testing {table_name}... ", end='', flush=True)

            result = self.test_load_file(csv_path, table_name)
            self.results.append(result)

            if result.success:
                print(f"PASSED ({result.rows_tested}/10 rows)")
            else:
                print(f"FAILED")
                if result.error_message and result.error_message != "No database connection (SQL generation mode)":
                    print(f"    Error: {result.error_message[:100]}")

        print(f"\n{'='*80}")
        passed = sum(1 for r in self.results if r.success)
        failed = total_files - passed
        print(f"TESTING COMPLETE: {passed} passed, {failed} failed")
        print(f"{'='*80}\n")

    def write_sql_file(self, date_suffix: str, csv_files: List[Tuple[str, str]]):
        """
        Generate BULK INSERT SQL file for validated files.

        Args:
            date_suffix: Date suffix for filename (MMDD)
            csv_files: List of (filepath, table_name) tuples
        """
        filename = os.path.join(self.output_dir, f'mssql_bulk_insert_{date_suffix}.sql')
        print(f"\nWriting {filename}...")

        passed_results = [r for r in self.results if r.success]
        failed_count = len(self.results) - len(passed_results)

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(f"-- DR20 Bulk Insert Statements\n")
            f.write(f"-- Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"-- Files validated: {len(passed_results)}/{len(self.results)}\n")
            f.write(f"-- Test mode: First 10 rows passed\n\n")

            if failed_count > 0:
                f.write(f"-- WARNING: {failed_count} files failed validation\n")
                f.write(f"-- Review test_results_{date_suffix}.md before proceeding\n\n")

            f.write(f"-- Total data volume: ~{sum(r.file_size_mb for r in passed_results):.1f} MB validated\n")
            f.write(f"\n{'='*80}\n\n")

            # Generate BULK INSERT for each passed file
            for result in passed_results:
                # Find matching CSV file
                csv_path = None
                for path, tbl in csv_files:
                    if tbl == result.table_name:
                        csv_path = path
                        break

                if csv_path:
                    f.write(f"-- File: {result.filename} ({result.file_size_mb:.1f} MB)\n")
                    f.write(f"-- Table: dbo.{result.table_name}\n")
                    f.write(f"-- Test result: PASSED ({result.rows_tested}/10 rows)\n")

                    bulk_sql = self.generate_bulk_insert_sql(csv_path, result.table_name, test_mode=False)
                    f.write(bulk_sql)
                    f.write("\nGO\n\n")

                    f.write(f"SELECT 'Loaded {result.table_name}', COUNT(*) AS row_count FROM dbo.{result.table_name};\n")
                    f.write("GO\n\n\n")

            # Summary
            f.write(f"\n-- SUMMARY\n")
            f.write(f"-- Total files: {len(passed_results)}\n")
            f.write(f"-- Total size: ~{sum(r.file_size_mb for r in passed_results):.1f} MB\n")
            if failed_count > 0:
                f.write(f"-- Failed files: {failed_count} (see test_results_{date_suffix}.md)\n")

        print(f"  Generated SQL for {len(passed_results)} validated files")
        return filename

    def write_markdown_report(self, date_suffix: str, csv_files: List[Tuple[str, str]]):
        """
        Generate markdown test results report.

        Args:
            date_suffix: Date suffix for filename (MMDD)
            csv_files: List of (filepath, table_name) tuples
        """
        filename = os.path.join(self.output_dir, f'test_results_{date_suffix}.md')
        print(f"\nWriting {filename}...")

        passed_results = [r for r in self.results if r.success]
        failed_results = [r for r in self.results if not r.success]

        # Calculate statistics
        total_files = len(self.results)
        passed_count = len(passed_results)
        failed_count = len(failed_results)
        total_size_gb = sum(r.file_size_mb for r in self.results) / 1024
        passed_size_gb = sum(r.file_size_mb for r in passed_results) / 1024

        with open(filename, 'w', encoding='utf-8') as f:
            f.write("# DR20 CSV Bulk Load Test Results\n\n")
            f.write(f"**Date**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            f.write(f"**Test Mode**: First 10 rows per file\n\n")

            # Summary Statistics
            f.write("## Summary Statistics\n\n")
            f.write(f"- **Total CSV files**: {total_files}\n")
            f.write(f"- **Passed validation**: {passed_count} ({passed_count/total_files*100:.1f}%)\n")
            f.write(f"- **Failed validation**: {failed_count} ({failed_count/total_files*100:.1f}%)\n")
            f.write(f"- **Total data volume**: {total_size_gb:.1f} GB\n")
            f.write(f"- **Tested successfully**: {passed_size_gb:.1f} GB\n\n")

            # Files Passed
            f.write("## Files Passed\n\n")
            f.write(f"Total: {passed_count} files ready for bulk loading\n\n")

            if passed_results:
                f.write("| Table Name | File Size | Status |\n")
                f.write("|------------|-----------|--------|\n")
                for result in sorted(passed_results, key=lambda r: r.file_size_mb, reverse=True)[:20]:
                    size_str = f"{result.file_size_mb:.1f} MB" if result.file_size_mb < 1024 else f"{result.file_size_mb/1024:.1f} GB"
                    f.write(f"| {result.table_name} | {size_str} | PASSED ({result.rows_tested}/10 rows) |\n")

                if len(passed_results) > 20:
                    f.write(f"\n*... and {len(passed_results) - 20} more files*\n")

            # Files Failed
            f.write("\n## Files Failed\n\n")

            if failed_results:
                f.write(f"Total: {failed_count} files need attention\n\n")

                for result in failed_results:
                    f.write(f"### {result.table_name}\n\n")
                    size_str = f"{result.file_size_mb:.1f} MB" if result.file_size_mb < 1024 else f"{result.file_size_mb/1024:.1f} GB"
                    f.write(f"- **File**: {result.filename} ({size_str})\n")
                    f.write(f"- **Error**: {result.error_message}\n")

                    # Get CSV sample for failed files
                    if result.error_message != "No database connection (SQL generation mode)":
                        csv_path = None
                        for path, tbl in csv_files:
                            if tbl == result.table_name:
                                csv_path = path
                                break

                        if csv_path:
                            sample = self.get_csv_sample(csv_path, 5)
                            f.write(f"- **Sample Data**:\n")
                            f.write(f"  ```\n")
                            f.write(f"  {sample}")
                            f.write(f"  ```\n")

                    f.write("\n")
            else:
                f.write("No files failed validation! 🎉\n\n")

            # Generated Files
            f.write("## Generated Files\n\n")
            f.write(f"- `mssql_bulk_insert_{date_suffix}.sql` - BULK INSERT statements for {passed_count} validated files\n")
            f.write(f"- `test_results_{date_suffix}.md` - This report\n\n")

            # Next Steps
            f.write("## Next Steps\n\n")
            if failed_count > 0:
                f.write("1. Review failed files with SDSS data team\n")
                f.write("2. Fix data issues or adjust table schemas\n")
                f.write("3. Re-test failed files\n")
                f.write("4. Execute full bulk load on validated files\n")
            else:
                f.write("1. Review generated SQL file\n")
                f.write("2. Execute full bulk load\n")
                f.write("3. Verify row counts match expected values\n")

        print(f"  Generated report with {passed_count} passed, {failed_count} failed")
        return filename


def main():
    parser = argparse.ArgumentParser(
        description='SDSS DR20 CSV Bulk Loader',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Test mode with SQL generation (for validation)
  python bulk_loader.py E:\\DR20\\minidb_dr20\\casload dr20 --test-mode --generate-sql --connection "Server=localhost;Database=minidb_dr20;Trusted_Connection=yes"

  # Just generate SQL without testing
  python bulk_loader.py E:\\DR20\\minidb_dr20\\casload dr20 --generate-sql

  # Future: Full load
  python bulk_loader.py E:\\DR20\\minidb_dr20\\casload dr20 --connection "..."
        """
    )

    parser.add_argument('csv_dir', help='CSV directory (e.g., E:\\DR20\\minidb_dr20\\casload)')
    parser.add_argument('output_dir', help='Output directory for SQL and reports')
    parser.add_argument('--test-mode', action='store_true',
                       help='Load only first 10 rows to validate')
    parser.add_argument('--connection', help='SQL Server connection string')
    parser.add_argument('--date', default=datetime.now().strftime('%m%d'),
                       help='Date suffix for output files (default: today MMDD)')
    parser.add_argument('--generate-sql', action='store_true',
                       help='Generate SQL file for validated files')

    args = parser.parse_args()

    print(f"\n{'='*80}")
    print("SDSS DR20 CSV Bulk Loader")
    print(f"{'='*80}")
    print(f"CSV directory:  {args.csv_dir}")
    print(f"Output directory: {args.output_dir}")
    print(f"Test mode:      {args.test_mode}")
    print(f"Generate SQL:   {args.generate_sql}")
    print(f"Connection:     {'Yes' if args.connection else 'No (SQL generation only)'}")
    print(f"{'='*80}\n")

    # Initialize loader
    loader = BulkLoader(args.csv_dir, args.output_dir, args.connection)

    # Scan for CSV files
    csv_files = loader.scan_csv_files()
    if not csv_files:
        print("ERROR: No CSV files found!")
        return 1

    # Connect to database if connection string provided
    if args.connection and args.test_mode:
        if not loader.connect_database():
            print("ERROR: Cannot connect to database. Test mode requires connection.")
            return 1

    # Run test mode if requested
    if args.test_mode:
        loader.run_test_mode(csv_files)
        loader.disconnect_database()

        # Write markdown report
        loader.write_markdown_report(args.date, csv_files)

    # Generate SQL file if requested
    if args.generate_sql:
        if not args.test_mode:
            # No testing - generate SQL for all files
            print("\nGenerating SQL for all CSV files (no testing performed)...")
            for csv_path, table_name in csv_files:
                filename = os.path.basename(csv_path)
                file_size_mb = loader.get_file_size_mb(csv_path)
                loader.results.append(TestResult(
                    filename=filename,
                    table_name=table_name,
                    file_size_mb=file_size_mb,
                    success=True,
                    rows_tested=0,
                    error_message=""
                ))

        loader.write_sql_file(args.date, csv_files)

    print("\n[SUCCESS] Processing complete!")

    if args.test_mode:
        passed = sum(1 for r in loader.results if r.success)
        failed = len(loader.results) - passed
        print(f"\nTest Results: {passed} passed, {failed} failed")
        print(f"See test_results_{args.date}.md for details")

    if args.generate_sql:
        print(f"See mssql_bulk_insert_{args.date}.sql for BULK INSERT statements")

    return 0


if __name__ == '__main__':
    sys.exit(main())

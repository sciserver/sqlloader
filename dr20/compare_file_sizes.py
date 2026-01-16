#!/usr/bin/env python3
"""
Compare actual CSV file sizes against Utah reference file sizes.
Accounts for potential Linux/Windows line ending differences.
Excludes the 6 reloaded files (those are in casload_20260114).
"""

import os
import sys

# Files that were reloaded from casload_20260114 (skip these)
RELOADED_FILES = {
    'minidb_dr20.dr20_gaia_dr2_source.csv',
    'minidb_dr20.dr20_gaia_dr3_astrophysical_parameters.csv',
    'minidb_dr20.dr20_gaia_dr3_source.csv',
    'minidb_dr20.dr20_gaia_dr3_synthetic_photometry_gspc.csv',
    'minidb_dr20.dr20_gaiadr2_tmass_best_neighbour.csv',
    'minidb_dr20.dr20_lamost_dr6.csv'
}

def read_utah_sizes(filepath):
    """Read Utah reference file sizes."""
    sizes = {}
    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split()
            if len(parts) == 2:
                filename = parts[0]
                size = int(parts[1])
                sizes[filename] = size
    return sizes

def get_actual_sizes(directory):
    """Get actual file sizes from directory."""
    sizes = {}
    if not os.path.exists(directory):
        print(f"ERROR: Directory not found: {directory}")
        return sizes

    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)
        if os.path.isfile(filepath) and filename.endswith('.csv'):
            sizes[filename] = os.path.getsize(filepath)

    return sizes

def compare_sizes(utah_sizes, actual_sizes, tolerance_percent=0.5):
    """Compare file sizes with tolerance for line ending differences."""

    print("=" * 100)
    print("File Size Comparison (Utah Linux vs Windows)")
    print("=" * 100)
    print(f"Tolerance: ±{tolerance_percent}% (accounts for potential line ending differences)")
    print()

    mismatches = []
    missing = []
    extra = []
    matches = 0
    skipped = 0

    # Check Utah files against actual
    for filename, utah_size in sorted(utah_sizes.items()):
        if filename in RELOADED_FILES:
            print(f"SKIP: {filename:60s} (reloaded from casload_20260114)")
            skipped += 1
            continue

        if filename not in actual_sizes:
            missing.append(filename)
            print(f"MISS: {filename:60s} (in Utah list, not found on disk)")
            continue

        actual_size = actual_sizes[filename]
        diff = actual_size - utah_size
        diff_percent = (diff / utah_size * 100) if utah_size > 0 else 0

        if abs(diff_percent) <= tolerance_percent:
            matches += 1
            status = "OK"
        else:
            mismatches.append((filename, utah_size, actual_size, diff, diff_percent))
            status = "DIFF"

        if status == "DIFF":
            print(f"{status}: {filename:60s} Utah: {utah_size:15,d}  Actual: {actual_size:15,d}  Diff: {diff:+12,d} ({diff_percent:+.2f}%)")

    # Check for extra files on disk not in Utah list
    for filename in sorted(actual_sizes.keys()):
        if filename not in utah_sizes and filename not in RELOADED_FILES:
            extra.append(filename)

    # Summary
    print()
    print("=" * 100)
    print("SUMMARY")
    print("=" * 100)
    print(f"Total files in Utah list: {len(utah_sizes)}")
    print(f"Files matching (±{tolerance_percent}%): {matches}")
    print(f"Files skipped (reloaded): {skipped}")
    print(f"Files with size mismatch: {len(mismatches)}")
    print(f"Files missing from disk: {len(missing)}")
    print(f"Extra files on disk: {len(extra)}")

    if mismatches:
        print()
        print("SIZE MISMATCHES:")
        for filename, utah_size, actual_size, diff, diff_percent in mismatches:
            print(f"  {filename}")
            print(f"    Utah:   {utah_size:15,d} bytes")
            print(f"    Actual: {actual_size:15,d} bytes")
            print(f"    Diff:   {diff:+15,d} bytes ({diff_percent:+.2f}%)")

    if missing:
        print()
        print("MISSING FILES:")
        for filename in missing:
            print(f"  {filename}")

    if extra:
        print()
        print("EXTRA FILES (not in Utah list):")
        for filename in extra:
            print(f"  {filename} ({actual_sizes[filename]:,d} bytes)")

    return len(mismatches) == 0 and len(missing) == 0

if __name__ == '__main__':
    utah_file = r'H:\GitHub\sqlloader\dr20\minidb_dr20_file_size.txt'
    casload_dir = r'E:\DR20\minidb_dr20\casload'

    print(f"Reading Utah reference: {utah_file}")
    utah_sizes = read_utah_sizes(utah_file)
    print(f"Found {len(utah_sizes)} files in Utah reference")
    print()

    print(f"Reading actual files: {casload_dir}")
    actual_sizes = get_actual_sizes(casload_dir)
    print(f"Found {len(actual_sizes)} CSV files on disk")
    print()

    success = compare_sizes(utah_sizes, actual_sizes, tolerance_percent=0.5)

    sys.exit(0 if success else 1)

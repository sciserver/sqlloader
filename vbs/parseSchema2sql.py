"""
Parse annotated .sql files and generate metadata INSERT statements
for DBObjects, DBColumns, and DBViewCols tables.

Python replacement for parseSchema2sql.vbs (Alex Szalay, 2001).
Processes the same --/H, --/T, --/A, --/D, --/U, --/K, --/R markup tags.

Usage:
  python parseSchema2sql.py                        # use default xschema.txt
  python parseSchema2sql.py xschema_mos.txt        # use alternate schema list
  python parseSchema2sql.py --sql-dir C:/sqlloader/schema/sql
  python parseSchema2sql.py --out-dir C:/sqlloader/schema/csv
"""

import argparse
import html
import os
import re
import sys
import time


# ── Tag extraction ────────────────────────────────────────────────

TAG_RE = re.compile(r'--/([ADTHUKR])\s*(.*)', re.IGNORECASE)

def get_tag(line, tag):
    """Extract text after a --/X tag from a line. Returns '' if not found.
    Requires whitespace between tag and text (matches VBS behavior)."""
    m = re.search(rf'--/{tag}\s+(.*?)(?:\s*--/(?!{tag})\S.*)?$', line, re.IGNORECASE)
    if not m:
        return ''
    text = m.group(1).strip()
    # Strip any trailing --/ tags (e.g. --/U after --/D)
    text = re.sub(r'\s*--/[A-Z].*$', '', text, flags=re.IGNORECASE).strip()
    return text


def html_encode(s):
    """Escape &, <, > for HTML output."""
    return s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')


def sql_escape(s):
    """Escape single quotes for SQL strings."""
    return s.replace("'", "''")


def check_quote(s):
    """Convert double quotes to single quotes (matches VBS checkQuote)."""
    return s.replace('"', "'")


# ── Name extraction ──────────────────────────────────────────────

def get_name(s):
    """Extract an object/column name, stripping brackets, schema prefix, parens."""
    s = s.strip()
    # Remove [schema]. prefix
    s = re.sub(r'\[.*?\]\.', '', s)
    # Remove brackets
    s = s.replace('[', '').replace(']', '')
    # Remove parens
    s = s.replace('(', '').replace(')', '')
    # Remove @parameter markers
    s = re.sub(r'@.*', '', s)
    # Get first word
    m = re.match(r'(\S+)', s)
    return m.group(1) if m else s


def get_next_word(s):
    """Get the first whitespace-delimited token and return (token, rest)."""
    m = re.match(r'\s*(\S+)\s*(.*)', s, re.DOTALL)
    if m:
        return m.group(1), m.group(2)
    return s.strip(), ''


# ── Comment handling ─────────────────────────────────────────────

def strip_block_comments(line, in_comment):
    """Handle /* ... */ comments. Returns (cleaned_line, still_in_comment)."""
    if in_comment:
        end = line.find('*/')
        if end >= 0:
            return line[end + 2:], False
        return '', True

    # Ignore /* inside a -- line comment
    dash_pos = line.find('--')
    check_line = line[:dash_pos] if dash_pos >= 0 else line

    # Remove inline /* ... */ comments
    check_line = re.sub(r'/\*.*?\*/', '', check_line)

    # Check for opening /*
    start = check_line.find('/*')
    if start >= 0:
        return check_line[:start], True

    return line, False


# ── Main parser ──────────────────────────────────────────────────

def read_lines(path):
    """Read a text file, honouring whatever BOM it happens to carry.

    Windows PowerShell 5.1 writes UTF-16 LE for '>' redirection and ANSI for
    Set-Content, so schema lists and SQL files arrive in a mix of encodings
    depending on how they were produced. Decoding blind as UTF-8 fails on the
    UTF-16 ones with an unhelpful 'invalid start byte' at position 0.
    """
    with open(path, 'rb') as f:
        data = f.read()

    if data.startswith(b'\xff\xfe') or data.startswith(b'\xfe\xff'):
        text = data.decode('utf-16')          # BOM selects the byte order
    elif data.startswith(b'\xef\xbb\xbf'):
        text = data.decode('utf-8-sig')
    else:
        try:
            text = data.decode('utf-8')
        except UnicodeDecodeError:
            # Legacy files saved as ANSI - cp1252 decodes any byte, so this
            # cannot fail and keeps the old errors='replace' behaviour honest.
            text = data.decode('cp1252')

    return text.splitlines(keepends=True)


def resolve_sql_path(sql_dir, entry):
    """Locate a schema-list entry, or None if it cannot be found.

    Entries are normally bare filenames resolved against --sql-dir (see
    xschema.txt), but some lists carry a relative path instead, in which case
    joining it onto --sql-dir produces a path that does not exist. Try the
    normal join first, then the entry as written, then its bare name under
    sql_dir.
    """
    entry = entry.replace('\\', os.sep).replace('/', os.sep)
    for candidate in (os.path.join(sql_dir, entry),
                      entry,
                      os.path.join(sql_dir, os.path.basename(entry))):
        if os.path.exists(candidate):
            return candidate
    return None


def parse_files(sql_dir, schema_list_path, out_dir):
    t0 = time.perf_counter()

    # Read schema list
    raw_lines = read_lines(schema_list_path)

    sql_files = []
    for line in raw_lines:
        line = line.strip()
        if not line or line.startswith('--'):
            continue
        if line.lower().endswith('.sql'):
            sql_files.append(line)

    print(f"Schema list: {os.path.basename(schema_list_path)} ({len(sql_files)} SQL files)")

    # Accumulators
    objects = []   # (name, otype, access, head, text)
    columns = []   # (table, name, unit, ucd, refs, desc)
    viewcols = []  # (colname, viewname, source)

    total_lines = 0

    for sql_file in sql_files:
        path = resolve_sql_path(sql_dir, sql_file)
        if path is None:
            print(f"  WARNING: {sql_file} not found, skipping")
            continue

        lines = read_lines(path)

        total_lines += len(lines)

        # Parser state
        state = 0      # 0=open, 2=table, 4=view, 6=function, 8=procedure
        in_comment = False
        group = ''     # current object name
        head = ''      # --/H text
        text = ''      # --/T text
        access = 'U'   # U=user, A=admin
        view_buf = ''  # accumulated view body

        for raw_line in lines:
            line = raw_line.rstrip('\n\r')

            # Handle block comments
            line, in_comment = strip_block_comments(line, in_comment)

            # Strip leading whitespace
            line = line.lstrip()

            if not line:
                continue

            # State 0: looking for CREATE
            if state == 0:
                upper = line.upper()
                if upper.startswith('CREATE '):
                    rest = line[7:].lstrip()
                    keyword, remainder = get_next_word(rest)
                    keyword_upper = keyword.upper()

                    if keyword_upper == 'TABLE':
                        state = 2
                    elif keyword_upper == 'VIEW':
                        state = 4
                    elif keyword_upper == 'FUNCTION':
                        state = 6
                    elif keyword_upper == 'PROCEDURE':
                        state = 8
                    else:
                        continue

                    group = get_name(remainder)

                    # Skip temp tables
                    if '#' in group:
                        state = 0
                        continue

                    head = ''
                    text = ''
                    access = 'U'
                    view_buf = ''
                continue

            # Inside a TABLE
            if state == 2:
                # End of table
                if line.startswith(')'):
                    objects.append((group, 'U', access,
                                    sql_escape(head.strip()),
                                    sql_escape(text.strip())))
                    state = 0
                    continue

                # Check for header/description tags
                # Pure comment/separator lines (before tag checks,
                # so bare ---- lines don't get matched as tags)
                if re.match(r'^-+$', line):
                    continue

                if '--/A' in line:
                    access = 'A'
                    continue
                if '--/H' in line:
                    tag_text = check_quote(get_tag(line, 'H'))
                    head += tag_text + ' '
                    continue
                if '--/T' in line:
                    tag_text = check_quote(get_tag(line, 'T'))
                    text += tag_text + ' '
                    continue

                # Other comment lines
                if line.startswith('--'):
                    continue

                # Column definition line
                name_token, rest = get_next_word(line)
                col_name = get_name(name_token)

                # Skip non-column keywords
                if col_name.upper() in ('CONSTRAINT', 'PRIMARY', 'ON'):
                    continue

                # Get data type (next word)
                dtype_token, _ = get_next_word(rest)
                dtype = sql_escape(dtype_token) if dtype_token else ''

                # Extract tags
                desc = sql_escape(html_encode(get_tag(line, 'D')))
                unit = sql_escape(get_tag(line, 'U'))
                ucd = sql_escape(get_tag(line, 'K'))
                refs = sql_escape(get_tag(line, 'R'))

                columns.append((group, col_name, unit, ucd, refs, desc))
                continue

            # Inside a VIEW
            if state == 4:
                # Check header tags first
                if '--/A' in line:
                    access = 'A'
                    continue
                if '--/H' in line:
                    head += check_quote(get_tag(line, 'H')) + ' '
                    continue
                if '--/T' in line:
                    text += check_quote(get_tag(line, 'T')) + ' '
                    continue
                if line.startswith('--'):
                    continue

                # Check for GO (end of view)
                if re.match(r'^GO\b', line, re.IGNORECASE):
                    view_buf += ' ' + re.sub(r'GO.*', '', line, flags=re.IGNORECASE)
                    # Emit the object
                    objects.append((group, 'V', access,
                                    sql_escape(head.strip()),
                                    sql_escape(text.strip())))

                    # Parse view body (matches VBS endView)
                    nlist = view_buf
                    # Remove WHERE clause
                    nlist = re.sub(r'WHERE\s+.*', '', nlist, flags=re.IGNORECASE)
                    # Remove WITH (NOLOCK)
                    nlist = re.sub(r'[\s]+WITH\s*\(NOLOCK\)', '', nlist, flags=re.IGNORECASE)
                    # Extract FROM source (keep full FROM clause like VBS)
                    from_match = re.search(r'FROM\s+(.*)', nlist, re.IGNORECASE)
                    if from_match:
                        source = from_match.group(1)
                        # Remove FROM clause from nlist
                        nlist = re.sub(r'FROM\s+.*', '', nlist, flags=re.IGNORECASE)
                    else:
                        source = ''
                    # Extract SELECT columns (or use full nlist if SELECT
                    # was stripped by the per-line .* AS removal)
                    select_match = re.search(r'SELECT\s+(.*)', nlist, re.IGNORECASE | re.DOTALL)
                    col_list = select_match.group(1) if select_match else nlist
                    if source:
                        for col_part in col_list.split(','):
                            col_name = get_name(col_part.strip())
                            if col_name:
                                viewcols.append((col_name, group, source))

                    state = 0
                    continue

                # Strip ".* AS " (greedy) per line — removes CAST expressions,
                # keeps just the alias (matches VBS inView behavior)
                if re.search(r'.* AS ', line, re.IGNORECASE):
                    line = re.sub(r'.* AS ', '', line, flags=re.IGNORECASE)
                view_buf += ' ' + line
                continue

            # Inside a FUNCTION or PROCEDURE
            if state in (6, 8):
                # Check header tags
                if '--/A' in line:
                    access = 'A'
                    continue
                if '--/H' in line:
                    head += check_quote(get_tag(line, 'H')) + ' '
                    continue
                if '--/T' in line:
                    text += check_quote(get_tag(line, 'T')) + ' '
                    continue

                # GO ends function/procedure
                if re.match(r'^GO$', line.strip(), re.IGNORECASE):
                    otype = 'F' if state == 6 else 'P'
                    objects.append((group, otype, access,
                                    sql_escape(head.strip()),
                                    sql_escape(text.strip())))
                    state = 0
                continue

    # ── Write output files ───────────────────────────────────────

    go = '\nGO\n'
    sep = '----------------------------- \n'

    # DBObjects
    obj_path = os.path.join(out_dir, 'loaddbobjects.sql')
    with open(obj_path, 'w', encoding='utf-8') as f:
        f.write(f'\n{sep}--  DBObjects.sql \n{sep}SET NOCOUNT ON{go}TRUNCATE TABLE DBObjects {go}\n')
        for name, otype, acc, h, t in objects:
            f.write(f"INSERT DBObjects VALUES('{name}','{otype}','{acc}','{h}','{t}','0');\n")
        f.write(f'{go}{sep}PRINT \'{len(objects)} lines inserted into DBObjects \'\n{sep}')

    # DBColumns
    col_path = os.path.join(out_dir, 'loaddbcolumns.sql')
    with open(col_path, 'w', encoding='utf-8') as f:
        f.write(f'\n{sep}--  DBColumns.sql \n{sep}SET NOCOUNT ON{go}TRUNCATE TABLE DBColumns {go}\n')
        for tbl, name, unit, ucd, refs, desc in columns:
            f.write(f"INSERT DBColumns VALUES('{tbl}','{name}','{unit}','{ucd}','{refs}','{desc}','0');\n")
        f.write(f'{go}{sep}PRINT \'{len(columns)} lines inserted into DBColumns \'\n{sep}')

    # DBViewCols
    vc_path = os.path.join(out_dir, 'loaddbviewcols.sql')
    with open(vc_path, 'w', encoding='utf-8') as f:
        f.write(f'\n{sep}--  DBViewcols.sql\n{sep}SET NOCOUNT ON{go}TRUNCATE TABLE DBViewcols{go}\n')
        for col, view, src in viewcols:
            f.write(f"INSERT DBViewCols VALUES('{col}','{view}','{src}');\n")
        f.write(f'{go}{sep}PRINT \'{len(viewcols)} lines inserted into DBViewcols\'\n{sep}')

    elapsed = time.perf_counter() - t0
    print(f"\nDone in {elapsed:.2f}s ({total_lines:,} lines parsed)")
    print(f"  DBObjects:  {len(objects):,} entries -> {obj_path}")
    print(f"  DBColumns:  {len(columns):,} entries -> {col_path}")
    print(f"  DBViewCols: {len(viewcols):,} entries -> {vc_path}")

    return len(objects), len(columns), len(viewcols)


def main():
    parser = argparse.ArgumentParser(
        description='Parse annotated SQL schema files into metadata INSERT statements')
    parser.add_argument('schema_list', nargs='?', default='xschema.txt',
                        help='Schema list file (default: xschema.txt)')
    parser.add_argument('--sql-dir', default=None,
                        help='Directory containing .sql files (default: ../schema/sql relative to schema list)')
    parser.add_argument('--out-dir', default=None,
                        help='Output directory (default: ../schema/csv relative to schema list)')
    parser.add_argument('-d', '--debug', action='store_true',
                        help='Print debug output')
    args = parser.parse_args()

    # Resolve paths relative to schema list location
    schema_list = os.path.abspath(args.schema_list)
    if not os.path.exists(schema_list):
        print(f"ERROR: schema list not found: {schema_list}")
        sys.exit(1)

    list_dir = os.path.dirname(schema_list)
    root = os.path.dirname(list_dir)  # parent of vbs/ or wherever the list is

    sql_dir = args.sql_dir or os.path.join(root, 'schema', 'sql')
    out_dir = args.out_dir or os.path.join(root, 'schema', 'csv')

    if not os.path.isdir(sql_dir):
        print(f"ERROR: SQL directory not found: {sql_dir}")
        sys.exit(1)
    if not os.path.isdir(out_dir):
        os.makedirs(out_dir, exist_ok=True)

    print(f"SQL dir: {sql_dir}")
    print(f"Output:  {out_dir}")

    parse_files(sql_dir, schema_list, out_dir)


if __name__ == '__main__':
    main()

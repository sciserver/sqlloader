# parseSchema2sql.py — Schema Metadata Generator

Parses annotated `.sql` files and generates `INSERT` statements for the
`DBObjects`, `DBColumns`, and `DBViewCols` metadata tables.

Python replacement for `parseSchema2sql.vbs` (~1 second vs ~15 minutes).

## Prerequisites

1. **Install Python 3.10+** from https://www.python.org/downloads/
   - During install, check **"Add python.exe to PATH"**
   - No additional packages required (stdlib only)

2. **Verify** in a Command Prompt or PowerShell:
   ```
   python --version
   ```

## Directory Layout

The script expects this standard layout (relative to the repo root):

```
sqlloader/
├── vbs/
│   ├── parseSchema2sql.py    ← the script
│   └── xschema.txt           ← default schema list (not used directly)
├── schema/
│   ├── sql/                  ← annotated .sql source files
│   │   ├── xschema.txt       ← master schema list (on C: drive)
│   │   ├── PhotoTables.sql
│   │   ├── mosTables.sql
│   │   ├── LvmTables.sql
│   │   └── ...
│   └── csv/                  ← output directory
│       ├── loaddbobjects.sql
│       ├── loaddbcolumns.sql
│       └── loaddbviewcols.sql
```

The production copy of `xschema.txt` and the `.sql` files live on the
C: drive at `C:\sqlloader\`.

## Usage

Open a Command Prompt and `cd` to the `vbs\` directory:

```
cd C:\sqlloader\vbs
```

### Generate all metadata (standard + mos_ + LVM tables)

```
python parseSchema2sql.py xschema.txt --sql-dir ..\schema\sql --out-dir ..\schema\csv
```

This reads the schema list at `C:\sqlloader\vbs\xschema.txt`, parses
all listed `.sql` files from `..\schema\sql`, and writes three output
files to `..\schema\csv\`.

### Generate metadata for a subset of tables

Create a one-line text file listing just the `.sql` file(s) you want:

```
echo mosTables.sql > xschema_mos.txt
python parseSchema2sql.py xschema_mos.txt --sql-dir ..\schema\sql --out-dir ..\schema\csv\mos
```

### Other options

```
python parseSchema2sql.py --help
```

## Loading into SQL Server

The output files contain `TRUNCATE TABLE` followed by `INSERT` statements.
Run them in SSMS or via sqlcmd:

```
sqlcmd -S localhost -d BestDR20 -E -i ..\schema\csv\loaddbcolumns.sql
sqlcmd -S localhost -d BestDR20 -E -i ..\schema\csv\loaddbviewcols.sql
sqlcmd -S localhost -d BestDR20 -E -i ..\schema\csv\loaddbobjects.sql
```

**Important notes:**

- `DBObjects` has foreign key references from `DBColumns`, `DBViewCols`,
  `Inventory`, and `IndexMap`. If `TRUNCATE` fails, disable the FK
  constraints first or use `DELETE FROM DBObjects` instead.
- If you need to append metadata (e.g., mos_ tables) without truncating
  existing rows, extract just the `INSERT` lines:
  ```
  findstr /B "INSERT" loaddbcolumns.sql > insert_dbcolumns.sql
  ```
- Load order when truncating: `DBViewCols` → `DBColumns` → `DBObjects`
  (children before parent).

## Markup Tags

The parser recognizes these tags in `.sql` source files:

| Tag | Level | Purpose |
|-----|-------|---------|
| `--/H` | Object | One-line header/description |
| `--/T` | Object | Block of HTML description text |
| `--/A` | Object | Marks object as admin-only (not visible to users) |
| `--/D` | Column | One-line column description |
| `--/U` | Column | Units |
| `--/K` | Column | UCD keywords |
| `--/R` | Column | Reference to enumerated type |

# Uncommitted changes in `C:\sqlloader` (checked 2026-10-27)

`C:\sqlloader` is on **master** at `8d328b9` ("DR19 final state", 2025-12), the same commit as
`origin/master` on GitHub. Its changes are **uncommitted and exist only on that disk**; none of
them are on GitHub master.

Each changed file was compared with the `dr20` branch, ignoring line endings (C: is CRLF, the repo
is LF). The check was read-only (`git --no-optional-locks status` / `diff`); nothing in
`C:\sqlloader` was changed.

**Why it matters:** the next release step is merging dr20 into master. After that, a `git pull` in
`C:\sqlloader` refuses to overwrite these modified files. And without group B, master would be
missing the DR20 VAC/Astra load support DR20 shipped with. So group B should be committed to dr20
(or confirmed obsolete) **before** the merge.

## A. Already on dr20: nothing to do (21 files)

Content matches dr20 except for line endings. They only show as modified because C: is still on
master (DR19).

- `schema/csv/loaddbcolumns.sql`, `loaddbobjects.sql`, `loaddbviewcols.sql`
- `schema/etc/loadMetadata.sql`, `setVersion.sql`
- `schema/sql/AstraTables.sql`, `IndexMap.sql`, `MastarTables.sql`, `SpectroTables.sql`,
  `VacTables.sql`, `mosTables.sql`, `resolveTables.sql`, `spNearby.sql`, `spPublish.sql`,
  `spValidate.sql`, `xschema.txt`
- New files: `schema/sql/LvmTables.sql`, `vbs/README.md`, `vbs/parseSchema2sql.py`

## B. Only in `C:\sqlloader`: commit or confirm obsolete

| File | Difference from dr20 |
|---|---|
| `schema/sql/ApogeeTables.sql` | HTMID/CX/CY/CZ moved from `apogee_drp_allvisit` to `apogee_drp_allstar` (Ani, 2026-02-17) |
| `loadadmin/loadsupport-sp.sql` | DR20VACS added to `spNewTask` (Ani, 2026-07-14) |
| `vbs/csvrobot.vbs` | New `dr20vacs` export type (Ani, 2026-07-08) |
| `vbs/xschema.txt` | Adds `LvmTables.sql`, un-comments `mosTables.sql` |
| `schema/csv/loaddependency.sql` | +8 dependencies for `spPublishDR20VACs` / `spValidateDR20VACs` / `spValidateAstra` (462 -> 470 rows) |
| `schema/csv/loadhistory.sql` | History entries for IndexMap and SpectroTables, 2026-02 to 2026-07 |
| `schema/csv/loadinventory.sql` | VacTables inventory reworked (~60 lines) |
| `schema/sql/spiders_quasar.sql` | **Deleted** on C:, still present on dr20 |
| `vbs/xschema_vac.txt` | New file (2026-07-27) |
| `schema/sql/dr20vacs/` | New folder, 35 files (DR20 VAC table scripts, `IndexMapDR20VACs.sql`, `VacTablesDR20.sql`, ...) |
| `schema/sql/astra_dr20/` | New folder, 15 files (bossnet, slam, snowwhite, mwm_*, ...) |
| `schema/csv/vac/` | New folder, 3 files (VAC versions of loaddbcolumns / loaddbobjects / loaddbviewcols) |
| `admin/connection.js` | `Data Source` changed `SDSSAD2` -> `SDSS5B`. Looks machine-specific; probably should **not** be committed |

## Ignore

- `vbs/__pycache__/`: Python bytecode cache; belongs in `.gitignore`.

## Suggested next step

Commit group B onto the `dr20` branch (from `C:\sqlloader`: `git stash` or commit on a new branch,
then bring it over to dr20), leaving out `connection.js` and `__pycache__`. Once it's on dr20, the
dr20 -> master PR can go ahead.

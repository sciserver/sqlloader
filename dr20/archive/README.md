# DR20 Archive

Superseded files kept for reference. Nothing here is part of the current DR20
workflow — see `dr20/TODO.md` for the canonical file list.

## schema_iterations/

Earlier generated schema/PK/index/FK/bulk-insert files, superseded by the
canonical set:

| Canonical (current) | Superseded by it |
|---|---|
| `mssql_tables_0603.sql` | `mssql_tables_0112.sql`, `mssql_tables_0116.sql`, `mssql_tables_1216.sql`, `mssql_tables_1217.sql` |
| `mssql_pk_0112.sql` | `mssql_pk_1216.sql`, `mssql_pk_1217.sql`, `mssql_pk_0112.sql.bak` |
| `mssql_indexes_0112_portable.sql` | `mssql_indexes_0112_final.sql`, `mssql_indexes_0112_no_computed.sql`, `mssql_indexes_1216/1217.sql` |
| `mssql_fk_0112.sql` | `mssql_fk_0112_batched/final/fixed/skip_plan.sql`, `mssql_fk_1216/1217.sql` |
| `bulk_loader.py` | all `mssql_bulk_insert_*.sql` |

The `_final` / `_fixed` / `_batched` / `_skip_plan` FK variants were attempts at
working around the orphaned-record FK failures documented in
`dr20/FK_FAILURES_REPORT.md`.

## one_offs/

Diagnostic and repair scripts written for a specific problem during the
Dec 2025 – Jan 2026 load and not needed again:

- **FK investigation** — `analyze_fks.py`, `analyze_fk_failures.sql`,
  `create_fks.sql`, `create_foreign_keys*.sql`, `drop_all_fk*.sql`
- **varchar sizing** — `analyze_varchar_max*.sql`, `check_actual_data_lengths.sql`,
  `check_column_sizes.sql`, `fix_varchar_max.py`, `fix_undersized_columns.sql`.
  This work produced `mssql_tables_0116.sql`; the logic now lives in
  `fix_tables_schema.py`.
- **deadlock/blocking diagnosis** — `enable_deadlock_tracing.sql`,
  `find_blocking.sql`, `read_deadlock_log.sql`, `diagnose_during_load.sql`
- **failed-table reloads** — `reload_*.sql`, `test_single_table.sql`
- **LAMOST DR6 pipe-delimited fix** — `fix_lamost_dr6_*.sql`,
  `recreate_pipe_tables.sql`, `lamost_dr6_problem_rows.csv`
- **misc** — `add_computed_columns.sql`, `check_table_sizes.sql`,
  `fix_pk_file.py`, `fix_target_table.sql`, `load_corrected_files_0114.sql`

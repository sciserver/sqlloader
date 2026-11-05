# schema/log/lumberjack_2026

The lumberjack weblog-job investigation notes and scripts that used to be in this folder moved to the
IDIES DBA repository (private) on 2026-11-05. They are still in this repo's history (dr20 branch, before
that date).

| Was here | Now in the DBA repo |
|---|---|
| `lumberjack_mydbsql_findings.md` | `docs/records/LUMBERJACK-MYDBSQL-FINDINGS-2026-10-27.md` |
| `lumberjack_steps1_2_findings.md` | `docs/records/LUMBERJACK-WEBLOG-STEPS-1-2-2026-10-27.md` |
| `weblog_collection_findings_20261027.md` | `docs/records/WEBLOG-COLLECTION-FINDINGS-2026-10-27.md` |
| `weblog_tldr_20261029.md`, `weblog_victor_list_20261029.md` | `docs/records/WEBLOG-MEETING-PREP-2026-10-29.md` |
| `spCopyLocalCasJobsSqlLogs2.sql`, `switch_step5_to_v2.sql`, `verify_step5_v2.sql`, `cutover_checks.sql`, `fix_steps2_6_recompile.sql`, `verify_duplicate_logsources.sql` | `sql/weblog-fix/` (same names) |
| `mydbsql_batchadmin_rcsi.sql`, `mydbsql_scheduler_plan_guide.sql` | `sql/mydbsql/` (same names) |

`bcpweblog_rewrite_handoff.md` stays here: it is the starting point for the bcpWeblog rewrite
(`schema/log/bcpweblog/`).

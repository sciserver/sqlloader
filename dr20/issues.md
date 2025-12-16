# DR20 Loading - December 2024

## General Notes

DR20 contains 185 tables (52 more than DR19). Converting PostgreSQL schema to T-SQL using improved pg2mssql.py script.

## Conversion Notes

- Source: PostgreSQL 15.15 schema from Utah
- Schema prefix: `minidb_dr20.` → `dbo.`
- Table prefix: `dr20_` (kept as-is for minidb loading database)
- CSV files: 171 files in E:\DR20\minidb_dr20\casload\

## Known Issues

*(Issues will be tracked here as they are discovered)*

## TODO

- [ ] Run schema conversion
- [ ] Review generated SQL files
- [ ] Test load on subset of tables
- [ ] Document any schema-specific issues
- [ ] Handle computed column indexes
- [ ] Handle q3c spatial indexes

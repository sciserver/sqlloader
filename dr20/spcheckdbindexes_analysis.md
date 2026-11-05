# `spCheckDBIndexes` — why it reports 217 discrepancies, and what to do

**Measured against BestDR20 on sdss4c, 2026-07-29.** Supersedes the count of 211
in `session_summary_20260728.md`; the difference is today's changes (+7 allspec
IndexMap rows, −1 boss_clam_params).

## Summary for the meeting

**Almost none of the 217 is a real missing index.** The check is comparing
against index names it derives itself, and the derivation is wrong in three
independent ways — a 32-character truncation from SQL Server 6.5, and two
name-prefix filters that no longer match the naming conventions actually in use.

| Direction | Code | Count |
|---|---|---:|
| in DB (index exists, IndexMap has no matching name) | K | 16 |
| in schema (IndexMap row, no matching index name) | K | 190 |
| in schema | I | 7 |
| in schema | F | 4 |
| **Total** | | **217** |

Best estimate of genuinely actionable items: **about 20**, all in the `K`
"in schema" group.

---

## How the check works

`spCheckDBIndexes` builds two lists and diffs them **by name only**:

- **`#isys`** — real indexes, selected by name pattern:
  - `I`: `WHERE i.name LIKE 'i[_]%'`
  - `K`: `WHERE i.name LIKE 'pk[_]%'`
  - `F`: all foreign keys
- **`#imap`** — for every IndexMap row, an *expected* name built by
  `dbo.fIndexName(code, tableName, fieldList, foreignKey)`.

Anything in one list and not the other is reported. It never compares the
index's actual key columns — only the string.

---

## Defect 1 — `fIndexName` truncates to 32 characters

```sql
CREATE FUNCTION fIndexName(...)
RETURNS varchar(32)
...
    SET @constraint = substring(@constraint,1,32);
```

It builds the expected name, cuts it to 32 characters, then compares against the
real, **untruncated** name from `sysindexes`. Any expected name longer than 32
characters can never match.

32 characters was the SQL Server 6.5 identifier limit. The modern limit is 128,
and the real indexes already carry full-length names — so whatever created them
was not this function.

How many IndexMap rows produce an over-length name:

| code | over 32 chars | total rows | share |
|---|---:|---:|---:|
| K | 181 | 348 | 52% |
| I | 33 | 88 | 38% |
| F | 30 | 33 | 91% |

All 16 of the **"in DB"** reports are this: the index matches IndexMap in full,
and only the truncation breaks it. Ten are `pk_<table>_spectrum_pk` names on
astra/APOGEE tables; the other six are the eROSITA PKs, which are named
`pk_erass1_hard_v1_0` where IndexMap expects `pk_erass1_hard_v1_0_uid` — those
six are a real naming inconsistency, just a trivial one.

**Fix:** widen the return type to `varchar(128)` and delete the `substring`.

**Check before doing it:** `fIndexName` is used in 4 other places in
`IndexMap.sql` (index build and drop). If anything relies on the truncated form
it must be updated in the same pass. Evidence suggests nothing does, since the
live indexes have full-length names.

**Effect: clears all 16 "in DB", plus 17 of the "in schema" K rows.**

---

## Defect 2 — the `K` branch only looks at `pk_*`, but 52 clustered indexes are named `ci_*`

```sql
and (i.name like 'pk[_]%' and i.name not like 'pk[_][_]%')
```

`run_vac_load.py` creates clustered indexes named `ci_<table>_<key>` when they
are not primary keys. There are **52** such indexes. The check cannot see any of
them, so their IndexMap rows are always reported as missing.

**Fix:** add `ci_` to the pattern — one `WHERE` clause.

**Effect: clears 44 of the "in schema" K rows.**

---

## Defect 3 — `fIndexName` emits `i_` for indexes, but the convention is `ix_`

```sql
WHEN 'I' THEN 'i_'
```

and correspondingly the check selects real indexes with `i.name LIKE 'i[_]%'`.

`ix_foo` does **not** match `i[_]%` — the second character is `x`, not `_`. So:

| naming | count | visible to the check |
|---|---:|---|
| `i_*` | 81 | yes |
| `ix_*` | 34 | **no** |

This is why **all 7 allspec rows added today are reported as "in schema"**. The
indexes exist and are correct; IndexMap now documents them correctly; the check
expects `i_allspec_specobjid` while the index is `ix_allspec_specobjid`.

**This is a convention decision, not purely a bug.** Either teach the check and
`fIndexName` about `ix_`, or rename the 34 indexes. Teaching the check is far
cheaper and lower risk.

**Effect: clears the 7 "in schema" I rows.**

---

## The 190 "in schema" K rows, decomposed

This is the only group with real content in it.

| Cause | n | Real problem? |
|---|---:|---|
| Real index carries a PostgreSQL `_pkey` name | 125 | **No** — convention decision |
| Real index is named `ci_*` (defect 2) | 44 | **No** — check can't see it |
| Real index is `pk_*`, pure 32-char truncation (defect 1) | 17 | **No** |
| Real index has some other name | 2 | Worth a look |
| **Table has no clustered index at all** | **2** | **Yes — genuinely missing** |

The 125 `_pkey` names are the `mos_*` tables, which carry the names PostgreSQL
generated. Renaming 125 indexes the day before go-live is not sensible; the
question is whether we adopt `_pkey` as acceptable or plan a rename for DR21.

---

## Proposed order

Nothing here is required for go-live — the indexes on disk are correct.

1. **Widen `fIndexName` to `varchar(128)`, drop the `substring`.** Check the 4
   other call sites in `IndexMap.sql` first. — clears **33**
2. **Teach the check about `ci_`.** One `WHERE` clause. — clears **44**
3. **Teach the check and `fIndexName` about `ix_`.** — clears **7**
4. **Investigate the 2 tables with no clustered index and the 2 oddly-named
   ones.** This is the only genuinely actionable group.
5. **Decide on the 125 `mos_*` `_pkey` names** — accept the convention, or
   schedule a rename for DR21.

Steps 1–3 take **217 → about 133**, and all of the remainder is the `_pkey`
convention question (125) plus roughly 4 real items. Resolving step 5 in favour
of accepting the names would take it to about 4.

## The deeper point, worth raising

The check compares **names**, not **definitions**. An index on the wrong columns
with the right name passes; a correct index with an unexpected name fails. Every
defect above is a symptom of that.

A version that compared IndexMap's `fieldList` against
`sys.index_columns` would be immune to all three naming problems and would
actually verify what the check claims to verify. That is a DR21 change, not a
today change — but it is the real fix, and steps 1–3 are patches to a design
that will keep producing this noise.

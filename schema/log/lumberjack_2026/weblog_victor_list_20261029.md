# Weblog: items for the web servers and SQL Agent (2026-10-29)

Only what needs the owner of idieswww01-03 and of lumberjack's Agent jobs. Background and evidence are in
`weblog_collection_findings_20261027.md` (section numbers below).

## Blocking: nothing new can be loaded until these are done

1. **Read access to the SkyServer logs on idieswww02 and idieswww03** (section 5). The weblog loader runs as
   `sdss\mssql` (step 1 calls the exe through `xp_cmdshell`). That account gets "Access is denied" on `LogFiles\W3SVC2`
   on 02 and 03. On 01 it can read, through `BUILTIN\Users`.
   - Which account should the loader use? Suggest a dedicated service account (or a group), given to the weblog step
     through an Agent proxy, so nothing else about Agent changes.
   - Grant it read on `\\idieswww01`, `02` and `03` `\LogFiles\W3SVC2`.
2. **How long are the IIS logs kept on idieswww01-03?** This sets how much history can still be loaded. On 02 and 03
   there are no `W3SVC2` files at all from 2025-07-10 to 2025-08-26 (on 01, from 2025-04-30). Did the servers stop
   logging then, or were the files removed? (Question 2.)

## Soon: logging on the three servers

3. **Make IIS logging the same on all three** (question 2). idieswww01 rolls over **monthly** (25 GB so far this
   month) and doesn't log `sc-bytes`/`cs-bytes`; 02 and 03 roll over daily and do log them. Suggest daily rollover
   and the same field list on all three, including `XForwardedFor`.
4. **idieswww01 wrote no SkyServer log from 2026-10-23 09:53 to 10-28.** Was it out of the load balancer, or did
   logging stop? (Question 1.)
5. **`/dr12/imgcutout/imgcutout.asmx` returns HTTP 500 about once a second** on all three. Is that a health check
   pointed at a broken endpoint? (Question 3.)
6. **Are dsa001/003/005 still meant to be in service?** About 98% of what they log is health checks. (Question 4.)

## SQL Agent on lumberjack

7. **Agent runs as `sdss\victor`** (question 12). If that account's password changes or it's disabled, Agent won't
   start at its next restart, and every job on lumberjack stops. Worth moving to a service account.
8. **The job can't tell when no rows arrive.** Step 1 "succeeds" whether or not anything loaded: the idieswww01
   sources never loaded a row while they were active, with no failure, and 8 sources point at folders that no longer exist. Proposal:
   a small daily check job (yesterday's rows per expected server, alerting through the existing "Weblog Job failure
   alert" operator). It needs a list of the servers that should have rows.
9. **When the new loader is ready:** step 1 changes from a T-SQL step (`xp_cmdshell`) to a CmdExec step, and Python
   is needed on lumberjack. Is that OK?

## A question about the past

10. On 2025-10-21 (the `weblogAll` table swap), the idieswww01 sources were set `INACTIVE`. Was that because they loaded
    nothing, and was collection from the new servers meant to be set up separately? (Question 5.)

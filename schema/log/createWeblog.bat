echo off
REM Invoke the SQL script to create a Weblog DB  > C:\temp\weblogCreateLog.txt
osql -d Master -E -n -iwebLogDBCreate.sql       >> C:\temp\weblogCreateLog.txt
echo WebLog DB created
echo WebLog DB created                          >> C:\temp\weblogCreateLog.txt

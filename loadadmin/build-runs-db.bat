:: --------------------------------------------------------------
:: build-runs-db.bat dataset dbsize logsize
::
:: Create the RUNS PUB database on the pub server
:: Ani Thakar and Alex Szalay
:: 2005-06-09
:: 2009-11-11 Ani: Added 4th CL param to specify db file path.
::---------------------------------------------------------------
:: build-runs-db.bat DR4 10000 5000
:: will create a database for dataset DR4 with 10GB data and 5GB log file
::---------------------------------------------------------------
::
@echo off
::
:: check if command line parameters are present, exit with error msg if not
::
IF [%1]==[] goto nopmt
IF [%2]==[] goto nopmt
IF [%3}==[] goto nopmt
::
:: set the directory where the databases will be created
::
IF [%4]==[] ( SET DBPATH=d:\sql_db\ ) ELSE ( SET DBPATH=%4% )
::
::
:: build environment variables for easy query construction
::
SET DATASET=%1
SET DBSIZE=%2
SET LOGSIZE=%3
SET Q1=%DATASET%','%DATASET%'
SET Q2='%DBPATH%','%DBPATH%',%DBSIZE%,%LOGSIZE%
::
:: set the LOADSERVER environment variable
::
CALL %~d0%~p0set-loadserver.bat
::
:: create a filename for a log file, and delete previous version
::
SET LOGNAME=\\%LOADSERVER%\loadlog\%COMPUTERNAME%-%DATASET%-pubdb.log
::
if exist log.txt DEL /Q log.txt
if exist %LOGNAME% DEL /Q %LOGNAME%
::
date /T >>log.txt
time /T >>log.txt
::
:: execute the SQL script to create both a RUNS and a TARGET version
::
osql -dloadsupport -E -n -Q"EXEC spCreatePubDB 'RUNS%Q1%,'RUNS',  %Q2%"	>>log.txt
::
date /T >>log.txt
time /T >>log.txt
echo =============== >>log.txt
::
MOVE /Y log.txt %LOGNAME%
::
goto end
::-----
:nopmt
::-----
echo Use: make-publish-db DR2 10000 5000
echo      <dataset> <dbsize> <logsize> parameters are required
echo	  <dataset> can be one of (TEST|DR1|DR1C|DR2)
::-----
:end
::-----
SET LOGSIZE=
SET DBSIZE=
SET DBPATH=
SET DATASET=
SET Q1=
SET Q2=
SET LOGNAME=
SET LOADSERVER=
::-----

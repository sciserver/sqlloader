:: --------------------------------
:: Create the loadadmin database
:: 08-08-2002 Alex Szalay and Jan Vandenberg
:: 08-14-2002 Alex Szalay separated off the LoadSupport stuff
:: 08-24-2003 Ani: Added HTM V2 dll name.
::---------------------------------
::
@echo off
::
set LOADSERVER=%COMPUTERNAME%
::
SET LOGNAME=\\%COMPUTERNAME%\loadlog\%COMPUTERNAME%-loadadmin.log
SET HTM=C:\Program Files\Microsoft SQL Server\MSSQL\Binn\
SET XP=xp_SQL_HTM_dll.dll
SET XP2=htm_v2.dll
::
if exist log.txt DEL /Q log.txt
if exist %LOGNAME% DEL /Q %LOGNAME%
::
date /T >>log.txt
time /T >>log.txt
::
:: create all directories needed, if they are not present
:: and set permissions
::
if not exist c:\sql_db\ mkdir c:\sql_db
echo y| cacls c:\sql_db /t /g Administrators:F
::
if not exist c:\loadlog\ mkdir c:\loadlog
echo y| cacls c:\loadlog /t /g Administrators:F Everyone:R
::
echo y| cacls c:\sqlLoader /t /g Administrators:F Everyone:R
::
:: create the shares if not there
::
if not exist \\%COMPUTERNAME%\root net share root=c:\sqlLoader >>log.txt
if not exist \\%COMPUTERNAME%\loadlog net share loadlog=c:\loadlog /grant:everyone,full >>log.txt
::
echo Created directories and shares >>log.txt
::
osql -dmaster 	 -E -n -iloadadmin-build.sql		>>log.txt
osql -dloadadmin -E -n -iloadadmin-schema.sql 		>>log.txt
osql -dloadadmin -E -n -iloadadmin-local-config.sql 	>>log.txt
::
date /T >>log.txt
time /T >>log.txt
::
echo ================================ >>log.txt
::
MOVE /Y log.txt %LOGNAME%
SET LOGNAME=
SET HTM=
SET XP=
::

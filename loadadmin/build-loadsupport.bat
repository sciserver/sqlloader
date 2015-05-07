:: --------------------------------------------------------------
:: Create the loadsupport database
:: Alex Szalay and Jan Vandenberg
:: 08-08-2002
::---------------------------------------------------------------
:: 2002-11-28  Alex: added automatic detection of LOADSERVER
:: 2003-05-08  Ani+Alex: changed share name to root, and added symbol LOADROOT
:: 2003-08-18  Ani: changed location of spHTMmaster to schema\sql from HTM\.
:: 2003-08-22  Ani: added generation of metadata input scripts.
:: 2003-08-24  Ani: added HTM V2 dll copy.
:: 2005-03-17  Ani: added call to loadsupport-setup.sql because 
::                  loadsupport-build.sql was split up into 2 files.
::                  Also added a second optional command-line parameter
::                  "-nobuild" which if present turns off the database
::                  build.
::---------------------------------------------------------------
::
@echo off
::
:: set the loadserver
::
::#######################
CALL %~d0%~p0set-loadserver.bat
::#######################
::
SET LOGNAME=\\%LOADSERVER%\loadlog\%COMPUTERNAME%-loadsupport.log
SET LOADROOT=%LOADSERVER%\root
::
if exist log.txt DEL /Q log.txt
if exist %LOGNAME% DEL /Q %LOGNAME%
::
date /T >>log.txt
time /T >>log.txt
::
:: create the sql_db directory on the C: and D: drives, if not present
:: and set permissions
::
if not exist c:\sql_db\ mkdir c:\sql_db
echo y| cacls c:\sql_db /t /g Administrators:F
::
if not exist d:\sql_db\ mkdir d:\sql_db
echo y| cacls d:\sql_db /t /g Administrators:F
::
echo Created directories and shares >>log.txt
::
cd ..\vbs\
cscript parseSchema2Sql.vbs
cscript parseDocTable.vbs algorithm
cscript parseDocTable.vbs glossary
cscript parseDocTable.vbs tabledesc
cd ..\loadadmin\
echo Regenerated metadata table input scripts >>log.txt
::
:: Create the loadsupport DB only if -nobuild param is not specified.
::
if /i NOT [%2]==[-nobuild] (
osql -dmaster 	   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-build.sql >>log.txt
)
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-schema.sql 	>>log.txt
osql -dloadsupport -E -n -Q"SET NOCOUNT ON;INSERT Loadserver VALUES('%LOADSERVER%')" >>log.txt
osql -dloadsupport -E -n -Q"SET NOCOUNT ON;INSERT FinishPhase VALUES('ALL')" >>log.txt
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-link.sql 	>>log.txt
osql -dmaster 	   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-setup.sql	>>log.txt
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-sp.sql 	>>log.txt
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-utils.sql 	>>log.txt
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-loadutils.sql >>log.txt
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-steps.sql 	>>log.txt
osql -dloadsupport -E -n -i\\%LOADROOT%\loadadmin\loadsupport-show.sql 	>>log.txt
if /i [%1]==[-P] (
osql -dloadsupport   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-pub-role.sql  >>log.txt
)
if /i [%1]==[-L] (
osql -dloadsupport   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-load-role.sql >>log.txt
)
if /i [%1]==[-LP] (
osql -dloadsupport   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-load-role.sql >>log.txt
osql -dloadsupport   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-pub-role.sql  >>log.txt
)
if /i [%1]==[] (
osql -dloadsupport   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-load-role.sql >>log.txt
osql -dloadsupport   -E -n -i\\%LOADROOT%\loadadmin\loadsupport-pub-role.sql  >>log.txt
)
::
:: install the HTM xp into master
::
SET HTM=C:\Program Files\Microsoft SQL Server\MSSQL\Binn\
SET XP=xp_SQL_HTM_dll.dll
SET XP2=htm_v2.dll
if not exist "%HTM%%XP%" copy \\%LOADROOT%\HTM\%XP% "%HTM%%XP%"
if not exist "%HTM%%XP2%" copy \\%LOADROOT%\HTM\%XP2% "%HTM%%XP2%"
::
osql -dmaster -E -n -i\\%LOADROOT%\schema\sql\spHTMmaster.sql >>log.txt
::
date /T >>log.txt
time /T >>log.txt
::
echo ================================ >>log.txt
::
MOVE /Y log.txt %LOGNAME%
SET XP=
SET HTM=
SET LOGNAME=
SET LOADSERVER=
SET LOADROOT=
::

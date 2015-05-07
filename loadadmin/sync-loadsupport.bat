:: --------------------------------------------------------------
:: Synchronize an existing loadsupport database with the sqlLoader
:: on disk (for incremental loading).
:: Ani Thakar and Alex Szalay
:: 03-17-2005
::---------------------------------------------------------------
:: Set up the local directories and shares needed.  Then just
:: call build-loadsupport.bat with special -nobuild parameter
:: to turn the DB creation off.
::
@echo off
::
::
SET LOGNAME=\\%COMPUTERNAME%\loadlog\%COMPUTERNAME%-loadadmin.log
::
if exist log.txt DEL /Q log.txt
if exist %LOGNAME% DEL /Q %LOGNAME%
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
:: Update local config according to loadadmin-local-config.sql
::
osql -dloadadmin -E -n -iloadadmin-local-config.sql 	>>log.txt
::
:: Call build-loadsupport.bat with -nobuild parameter to run the
:: loadsupport setup.
::
build-loadsupport.bat [%1] -nobuild

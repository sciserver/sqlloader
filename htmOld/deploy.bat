@echo ***                         ***
@echo **  Spherical SQL Installer  **  by Tamas Budavari, June 11, 2007
@echo ***                         ***
@echo on

set server=%1
set dbname=%2
set loaddir=%3

if not defined server goto usage
if not defined dbname goto usage
if not defined loaddir set loaddir=C:\sqlLoader

:step1
:dropdbo
echo Uninstalling DBO routines...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalUninstallDBO.sql
if not errorlevel 1 goto step2
echo DBO routines not there - Good.

:step2
:droptypes
echo Dropping types...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\TypesDrop.sql
if not errorlevel 1 goto step3
echo !!! TYPES DROP ERROR !!!
goto usage

:step3
:drop
echo Uninstalling Sph...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalUninstall.sql
if not errorlevel 1 goto step4
echo !!! UNINSTALL ERROR !!!
goto usage

:step4
:asm
echo Deploying...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalDeploy.sql
if not errorlevel 1 goto step5
echo !!! DEPLOY ERROR !!!
goto usage

:step5
:udf
echo Spherical lib...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\schema\sql\spSphericalLib.sql
if not errorlevel 1 goto step6
echo !!! INSTALL ERROR !!!
goto :usage

:step6
:type
echo Creating types...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\TypesCreate.sql
if not errorlevel 1 goto step7
echo !!! TYPES ERROR !!!
goto usage

:step7
:test
echo Testing...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalLibTest.sql
if not errorlevel 1 goto step8
echo !!! TEST ERROR !!!
goto usage

:step8
:htm
echo Creating HTM...
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\schema\sql\spHtmCSharp.sql
if not errorlevel 1 goto step9
echo !!! HTM ERROR !!!
goto usage

:step9
sqlcmd -S %server% -d %dbname% -E -b -v userName=skyuser -i %loaddir%\etc\setUserPrivs.sql
if not errorlevel 1 goto end
echo !!! ERROR SETTING USER PRIVS !!!

:usage
echo Please specify the server and the database!
echo Syntax:   deploy.bat <server> <database> [<loaderdir>]
echo Example:  deploy.bat localhost Test c:\temp\sqlLoader

:end

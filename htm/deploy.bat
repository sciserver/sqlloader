@echo ***                         ***
@echo **  Spherical SQL Installer  **  by Tamas Budavari, June 11, 2007
@echo ***                         ***
@echo off

set server=%1
set dbname=%2
set loaddir=%3

if not defined server goto usage
if not defined dbname goto usage
if not defined loaddir set loaddir=C:\sqlLoader


:dropdbo
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalUninstallDBO.sql
if not errorlevel 1 goto droptypes
echo DBO routines not there - Good.

:droptypes
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\TypesDrop.sql
if not errorlevel 1 goto drop
echo !!! UNINSTALL ERROR !!!
goto :drop

:drop
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalUninstall.sql
if not errorlevel 1 goto asm
echo !!! UNINSTALL ERROR !!!
goto :usage

:asm
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalDeploy.sql
if not errorlevel 1 goto udf
echo !!! DEPLOY ERROR !!!
goto :usage

:udf
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalLib.sql
if not errorlevel 1 goto type
echo !!! INSTALL ERROR !!!
goto :usage

:type
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\TypesCreate.sql
if not errorlevel 1 goto test
echo !!! TYPE INSTALL ERROR !!!
goto :usage

:test
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spSphericalLibTest.sql
if not errorlevel 1 goto htm
echo !!! TEST ERROR !!!
goto :usage

:htm
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\spHtmCsharp.sql
if not errorlevel 1 goto end
echo !!! HTM ERROR !!!
goto :usage

:footprint
sqlcmd -S %server% -d %dbname% -E -b -i %loaddir%\htm\FootprintService.sql
if not errorlevel 1 goto end
echo WARN: Footprint Service routines not installed
goto :usage

:usage
echo Please specify the server and the database!
echo Syntax:   Deploy.bat [server] [database]
echo Example:  Deploy.bat localhost Test

:end

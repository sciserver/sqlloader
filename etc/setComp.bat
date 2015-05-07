@echo ***                         ***
@echo **  Script to set DB compatibility level  **  by Ani Thakar, Apr 26, 2011
@echo ***                         ***
@echo off

set server=%1
set dbname=%2
set loaddir=%3

if not defined server goto usage
if not defined dbname goto usage
if not defined loaddir set loaddir=C:\sqlLoader

:step0
sqlcmd -S %server% -d %dbname% -E -b -v compLevel=100 -i %loaddir%\etc\setCompatibility.sql
if not errorlevel 1 goto end
echo !!! ERROR SETTING COMPATIBILITY LEVEL !!!

:usage
echo Please specify the server and the database!
echo Syntax:   setComp.bat <server> <database> [<loaderdir>]
echo Example:  setComp.bat localhost Test c:\temp\sqlLoader


:end

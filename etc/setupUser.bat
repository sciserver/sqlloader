@echo ***                         ***
@echo **  Script to set up SDSS user privs  **  by Ani Thakar, Apr 26, 2011
@echo ***                         ***
@echo off

set server=%1
set dbname=%2
set uname=%3
set loaddir=%4

if not defined server goto usage
if not defined dbname goto usage
if not defined loaddir set loaddir=C:\sqlLoader

sqlcmd -S %server% -d %dbname% -E -b -v userName=%uname% -i %loaddir%\etc\setUserPrivs.sql
if not errorlevel 1 goto end
echo !!! ERROR SETTING USER PRIVS !!!

:usage
echo Please specify the server and the database!
echo Syntax:   setupUser.bat <server> <database> <userName> [<loaderdir>]
echo Example:  setupUser.bat localhost Test skyuser c:\temp\sqlLoader


:end

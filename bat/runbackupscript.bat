::----------------------------------------------------
:: runbackupscript.bat
:: 2002-12-03 Alex Szalay
::
:: runs automatically by the scheduler
:: backs up the whole v4\current tree nightly
::----------------------------------------------------
@echo off
::
For /f "tokens=1-4 delims=/.- " %%A in ('date /t') do (
     set AAAA=%%A&set BBBB=%%B&set CCCC=%%C&set YYYY=%%D)
For /f "tokens=1-3 delims=/:- " %%A in ('time /t') do (
     set HHHH=%%A&set MMMM=%%B)
::
SET BACKUPROOT=c:\daily-archive
::
SET BACKUPDIR=%BACKUPROOT%\%YYYY%-%BBBB%-%CCCC%-%HHHH%%MMMM%\
SET AAAA=
SET BBBB=
SET CCCC=
SET YYYY=
SET HHHH=
SET MMMM=
::
::
if not exist %BACKUPDIR% mkdir %BACKUPDIR%
::
xcopy /hireskfcoy c:\skyserverv4\current %BACKUPDIR% >> %BACKUPROOT%\log.txt
::
:: get a copy of the admin website directly
::xcopy /hireskfcoy \\skyserver\skyserver\admin %BACKUPDIR%admin >> %BACKUPROOT%\log.txt
::
echo ------------------------------- >> %BACKUPROOT%\log.txt
::
SET BACKUPDIR=
SET BACKUPROOT=
::


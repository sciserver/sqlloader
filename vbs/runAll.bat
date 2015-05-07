::----------------------------------
:: runs all schema parsing scripts
:: Ani Thakar and Alex Szalay
:: 2010-12-09 Ani: Removed Algorthm, Glossary & TableDesc.
::----------------------------------
::@echo off
cd %1%
cscript parseSchema2sql.vbs xschema%2%.txt
::
call get-dependency.bat %2%
::
::@echo on
::----------------------------------



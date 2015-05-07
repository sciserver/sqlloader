cscript dependency.vbs xschema%1%.txt
sort ..\schema\csv\d1.sql >..\schema\csv\d2.sql
cscript remove-dups.vbs
del /Q ..\schema\csv\d1.sql
del /Q ..\schema\csv\d2.sql





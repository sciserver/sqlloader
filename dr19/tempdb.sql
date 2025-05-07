
SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
	+ ' FILENAME = ''D:\sql_db\tempdb\' + f.name
	+ CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
	+ ''');'
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');


ALTER DATABASE tempdb MODIFY FILE (NAME = [tempdev], FILENAME = 'D:\sql_db\tempdb\tempdev.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [templog], FILENAME = 'D:\sql_db\tempdb\templog.ldf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp2], FILENAME = 'D:\sql_db\tempdb\temp2.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp3], FILENAME = 'D:\sql_db\tempdb\temp3.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp4], FILENAME = 'D:\sql_db\tempdb\temp4.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp5], FILENAME = 'D:\sql_db\tempdb\temp5.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp6], FILENAME = 'D:\sql_db\tempdb\temp6.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp7], FILENAME = 'D:\sql_db\tempdb\temp7.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp8], FILENAME = 'D:\sql_db\tempdb\temp8.mdf');
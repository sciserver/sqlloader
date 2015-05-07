-- JVV's SQL commands to set up the tempdb.

alter database tempdb
modify file
(
 name = tempdev,
 filegrowth = 0%
)

alter database tempdb
modify file
(
 name = templog,
 filegrowth = 0%
)

alter database tempdb
add file
(
 name = tempdb_data2,
 filename = 'd:\sql_db\tempdb_data2.ndf',
 size = 20000MB,
 maxsize = UNLIMITED,
 filegrowth = 10%
)

alter database tempdb
add log file
(
 name = tempdb_log2,
 filename = 'd:\sql_db\tempdb_log2.ldf',
 size = 2000MB,
 maxsize = UNLIMITED,
 filegrowth = 10%
)


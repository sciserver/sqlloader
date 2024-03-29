/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [fname]
      ,[targettable]
  FROM [BESTTEST].[dbo].[filesToLoad]

  create table filestoload(
  fname varchar(2000),
  targettable sysname
  )

  create table filesToLoad2(
	id int identity (1,1),
	fname varchar(2000),
	targettable sysname,
	lastLoadDate datetime,
	loadStatus int default 0)


	insert filesToLoad2 (fname, targettable, lastLoadDate, loadStatus)
	select fname, targettable, null, 0
	from filesToLoad


	select * from filestoload2

	select fname from filestoload2

	select fname, replace(fname, 'dr18', 'minidb.dr18')
	from filestoload2

	update filestoload2
	set fname = replace(fname, 'dr18_', 'minidb.dr18_')

	update filestoload2
	set fname = replace(fname, 'minidb.dr18loading', 'dr18loading')

	--dr18_targetdb_version
	--dr18_catalogdb_version
	--dr18_targeting_generation



	exec sp_whoisactive


	exec sp_blitzwho
	




	select * from filesToLoad2
 
------------------------------------------------------------------
-- spCheckDB.sql
-- 2004-09-17 Alex Szalay
------------------------------------------------------------------
-- SkyServer Database checks
--
-------------------------------------------------------------------
-- History:
--* 2004-09-17 Alex: moved here all the spCheckDB* and Diagnostic procs
--*		as well as spGrantAccess
--* 2004-09-17 Alex: moved here spCheckDBIndexes from IndexMap.sql
--* 2004-11-11 Alex: added tableName output to the spCheckDBIndexes, making
--*		it easier to debug differences.
--* 2005-10-11 Ani: spCheckDBIndexes also returns the row count now.
--* 2006-06-18 Ani: Fixed bug in spCheckDBIndexes that was referencing
--*                 temp table #diff after it had been dropped.
--* 2006-06-20 Ani: Added RecentQueries to the list of dynamic tables 
--*                 excluded from diagnostics in spMakeDiagnostics.
--* 2007-01-26 Ani: Removed xp_varbintohexstr from spGrantAccess. 
--* 2007-08-24 Ani: Added access for function/SP viewing and IndexMap
--*                 to spGrantAccess.
--* 2008-06-25 Ani: Added function type strings 'FS' and 'FT' to
--*                 spGrantAccess for scalar and table-valued functions 
--*                 in sql2k5 and beyond (fix for PR #7618).
--* 2010-12-11 Ani: Modified spMakeDiagnostics to use sp_spaceused so
--*                 table row counts are done faster.
--* 2011-03-16 Ani: Modified spMakeDiagnostics, spCheckDBObjects and
--*                 spCheckDBColumns to avoid collation conflicts
--*                 with non-latin collations (e.g. Chinese).
--* 2011-06-14 Ani: Added function type 'IF' to spCheckDBObjects.
--* 2016-07-07 Ani: Excluded diagram Fs and SPs in spCheckDBObjects.
--* 2017-09-14 Ani: Added code to strip qualified table name so that
--*                 Diagnostics table gets all the row counts.
-------------------------------------------------------------------
SET NOCOUNT ON;
GO


--================================================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'spMakeDiagnostics' )
DROP PROCEDURE spMakeDiagnostics
GO
--
CREATE PROCEDURE spMakeDiagnostics
-----------------------------------------------------------
--/H Creates a full diagnostic view of the database
--/A
--/T The stored procedure checks in all tables, views, functions
--/T and stored procedures into the Diagnostics table,
--/T and counts the number of rows in each table and view.
--/T <PRE> EXEC spMakeDiagnostics </PRE>
-----------------------------------------------------------
AS
BEGIN
    --
    -- clear out the table first
    --
    TRUNCATE TABLE Diagnostics;
    --
    --scan through all the user tables and views, leave out the dynamic stuff, and itself
    --
    INSERT INTO Diagnostics
    SELECT name, type, 0
	FROM sysobjects  
    	WHERE type collate latin1_general_ci_as IN ('U','V')
	    -- Object type of User-table and View
	    AND permissions (id)&4096 <> 0
	    AND name collate latin1_general_ci_as NOT IN ('QueryResults','RecentQueries','Diagnostics','SiteDiagnostics','test')
	    AND substring(name,1,3) collate latin1_general_ci_as NOT IN ('sys','dtp')
	ORDER BY type, name
    --
    -- insert all the functions and stored procedures
    --
    INSERT INTO Diagnostics
    SELECT name, type, 0
	FROM sysobjects  
    	WHERE type collate latin1_general_ci_as IN ('P', 'IF', 'FN', 'TF', 'X')	
	-- Object type of Procedure, scalar UDF, table UDF
	  and permissions (id)&32 <> 0
	  and substring(name,1,3) collate latin1_general_ci_as NOT IN
		('sp_' , 'dt_', 'xp_', 'fn_', 'MS_')
    --
    -- get the foreign keys
    --
    INSERT INTO Diagnostics
    SELECT name, type, 0 FROM sysobjects
	WHERE xtype collate latin1_general_ci_as IN ('F')
    --
    -- get the indices, which are not primary or foreign keys
    --
    INSERT INTO Diagnostics
    SELECT name, 'I' as type, 0	FROM sysindexes
	WHERE  keys is not null
	    and name collate latin1_general_ci_as NOT LIKE '%sys%'
	    and name collate latin1_general_ci_as NOT LIKE ('Statistic_%')
	    and name collate latin1_general_ci_as NOT IN (
	  	  select name from sysobjects
		  where xtype collate latin1_general_ci_as IN ('PK', 'F')
		  )

	CREATE TABLE #trows (
		table_name sysname ,
		row_count varchar(64),
		reserved_size VARCHAR(50),
		data_size VARCHAR(50),
		index_size VARCHAR(50),
		unused_size VARCHAR(50))

	SET NOCOUNT ON
	INSERT #trows 
		EXEC sp_msforeachtable 'sp_spaceused ''?'''

	-- strip the qualified table name to just the table name (remove schema name and square brackets)

	UPDATE r

	    SET r.table_name = SUBSTRING(table_name, CHARINDEX('[',table_name,2)+1, (LEN(table_name)-  CHARINDEX('[',table_name,2) - 1) )

    	FROM #trows r
		

	UPDATE d
		SET d.count=CONVERT(bigint,r.row_count)
	FROM Diagnostics d JOIN #trows r on r.table_name collate latin1_general_ci_as=d.name
	WHERE d.type collate latin1_general_ci_as=N'U'    
	--
    -- load all the row counts for the tables
    --
    DECLARE mycursor CURSOR
	FOR
	    select 'UPDATE Diagnostics SET [count] = '+
		' (select count_big(*) from '+name+')'+
		' WHERE name = N''' + name + ''''
	    from Diagnostics 
	    where type collate latin1_general_ci_as = N'V'
    OPEN mycursor
    DECLARE @cmd sysname
    FETCH NEXT FROM mycursor INTO @cmd
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
	EXEC (@cmd)
	FETCH NEXT FROM mycursor INTO @cmd
    END
    DEALLOCATE mycursor
END
GO
--


--================================================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'spUpdateSkyServerCrossCheck' )
DROP PROCEDURE spUpdateSkyServerCrossCheck
GO
--
CREATE PROCEDURE spUpdateSkyServerCrossCheck
-------------------------------------------------------------------
--/H Update the contents of the SiteDiagnostics table
--/A
--/T This procedure copies the Diagnostics into the
--/T SiteDiagnostics table, then it update the value of
--/T the DB checksum and timestamp.
--/T It is used to cross-check the patches applied to the database
--/T <PRE>EXEC spUpdateSkyServerCrossCheck</PRE>
-------------------------------------------------------------------
AS
BEGIN
    --
    -- clear the SiteDiagnostics table
    --
    TRUNCATE TABLE SiteDiagnostics
    --
    -- replicate Diagnostics
    --
    INSERT INTO SiteDiagnostics
	SELECT * FROM Diagnostics
    --
    -- update the checksum
    --
    UPDATE SiteConstants
		SET value = cast(dbo.fGetDiagChecksum() as varchar(64))
		WHERE name='Checksum'
    --
    -- update the timestamp
    --
    UPDATE SiteConstants
		SET value = cast(getdate() as varchar(64))
		WHERE name='DB Version Date'
    --
END
GO


--================================================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'spCompareChecksum' )
DROP PROCEDURE spCompareChecksum
GO
--
CREATE PROCEDURE spCompareChecksum
----------------------------------------------------------------
--/H Compares the checksum in Diagnostics to the one in SiteDiagnostics
--/A
--/T Run this procedure to verify that no changes occured in the
--/T database since the last regular update.
--/T <PRE> spCompareChecksum</PRE>
----------------------------------------------------------------
AS
BEGIN
    DECLARE @SiteChecksum bigint, @Diagchecksum bigint;
    SET @Sitechecksum = (SELECT dbo.fGetDiagChecksum());
    SET @Diagchecksum = (
	SELECT cast(value as bigint) from SiteConstants
	WHERE name='Checksum');
    IF (@Sitechecksum = @Diagchecksum) PRINT 'Checksum OK'
    ELSE PRINT 'Checksum does not match. '+
	' Site: '+CAST(@Sitechecksum as varchar(12))+','+
	' Diag: '+CAST(@Diagchecksum as varchar(12))
END
GO
--

--================================================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'fGetDiagChecksum' )
DROP FUNCTION fGetDiagChecksum
GO
--
CREATE FUNCTION fGetDiagChecksum()
--------------------------------------------
--/H Computes the checksum from the Diagnostics table
--/A
--/T The checksum should be equal to the checksum value in the
--/T SiteConstants table.
--/T <PRE> SELECT dbo.fGetDiagChecksum() </PRE> 
--------------------------------------------
RETURNS BIGINT
AS BEGIN
	RETURN (select sum(count)+count_big(*) from Diagnostics);
END
GO
--

--=============================================
IF EXISTS (SELECT name FROM   sysobjects
 	WHERE  name = N'spUpdateStatistics' )
	DROP PROCEDURE spUpdateStatistics
GO

CREATE PROCEDURE spUpdateStatistics 
---------------------------------------
--/H Update the statistics on user tables
--/A
--/T Update the statistics on the user tables
--/T no parameters
--/T <samp>  exec spUpdateStatistics </samp>
---------------------------------------
AS BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE userObject CURSOR READ_ONLY
	FOR select name from sysobjects 
	where type in ('U ')  -- for indexed views if we ever have them, 'V ') 
  	  and name not like 'dt_%'
    --
    DECLARE @name varchar(256)
    OPEN userObject
    --
    WHILE (@@fetch_status <> -1)
    BEGIN
	FETCH NEXT FROM userObject INTO @name
	IF (@@fetch_status != 0) BREAK
	EXEC ('UPDATE STATISTICS ' + @name)	
    END
    --
    CLOSE userObject
    DEALLOCATE userObject
    --
    RETURN
END
GO


--=============================================
IF EXISTS (SELECT name FROM   sysobjects
 	WHERE  name = N'spCheckDBColumns' )
	DROP PROCEDURE spCheckDBColumns
GO
--
CREATE PROCEDURE spCheckDBColumns
---------------------------------------
--/H Check for a mismatch between the db columns and documentation
--/A
--/T Comapres the columns of tables in syscolumns to
--/T the list stored in DBColumns. Returns the number
--/T of mismatches. It has no parameters.
--/T <samp>  exec spCheckDBColumns</samp>
---------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #indbcolumns (
		tablename varchar(64),
		name	  varchar(64),
		found	varchar(64)
	)
	--
	INSERT #indbcolumns
	SELECT	o.name as tablename, c.name, 'in DB' as found
	    FROM sysobjects o, syscolumns c WITH (nolock)
	    WHERE o.xtype collate latin1_general_ci_as = N'U' 
		AND o.name collate latin1_general_ci_as not like 'dt%'
		AND c.id = o.id
	--
	CREATE TABLE #diff (
		tablename varchar(64),
		name	  varchar(64),
		found	varchar(64)
	)
	--
	INSERT #diff
	SELECT d.tablename as obj, d.name, 'in schema' as found
	    FROM DBColumns d WITH (nolock)
    	    WHERE  d.name collate latin1_general_ci_as not in (
		SELECT name FROM #indbcolumns
		WHERE tablename collate latin1_general_ci_as = d.tablename  collate latin1_general_ci_as
	    )
	------
	INSERT #diff
	SELECT o.tablename as obj, o.name, o.found FROM #indbcolumns o
	    WHERE o.name collate latin1_general_ci_as NOT IN (
		SELECT name FROM DBColumns WITH (nolock)
		WHERE  tableName collate latin1_general_ci_as =o.tablename collate latin1_general_ci_as
	    )

	DECLARE @count int;
	SELECT @count=count(*) FROM #diff
	SELECT * FROM #diff
	RETURN @count;
END
GO



--=============================================
IF EXISTS (SELECT name FROM   sysobjects
 	WHERE  name = N'spCheckDBObjects' )
	DROP PROCEDURE spCheckDBObjects
GO
--
CREATE PROCEDURE spCheckDBObjects
---------------------------------------
--/H Check for a mismatch between the db objects and documentation
--/A
--/T Comapres the all the objects in sysobjects to
--/T the list stored in DBObjects. Returns the number
--/T of mismatches. It has no parameters.
--/T <samp>  exec spCheckDBObjects</samp>
---------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #indbobjects (
		[name] varchar(64),
		type varchar(64),
		found varchar(16)
	)
	--
	CREATE TABLE #diff (
		[name] varchar(64),
		type varchar(64),
		found varchar(16)
	)
	--
	INSERT #indbobjects
	    SELECT name, xtype as type, 'in DB' as found
		FROM sysobjects WITH (nolock)
		WHERE xtype collate latin1_general_ci_as =N'U'   
		    and name collate latin1_general_ci_as not like 'dt%'
	--
	INSERT #indbobjects
	    SELECT name, xtype as type, 'in DB' as found 
		FROM sysobjects WITH (nolock)
		WHERE xtype collate latin1_general_ci_as =N'V' 
		    and name collate latin1_general_ci_as not like N'sys%'
	--
	INSERT #indbobjects
	    SELECT name, xtype as type, 'in DB' as found 
		FROM sysobjects WITH (nolock)
		WHERE xtype=N'P' 
		    and name collate latin1_general_ci_as not like N'dt_%' and name not like 'sp_%diagram%'
	--
	INSERT #indbobjects
	    SELECT name, 'F' as type, 'in DB' as found 
		FROM sysobjects WITH (nolock)
		WHERE xtype collate latin1_general_ci_as  in (N'FN' ,N'TF', N'FS', N'FT', N'IF') and name not like 'fn_diagram%'
	--
	INSERT #diff
	SELECT i.name, i.type, found
	    FROM #indbobjects i
	    WHERE i.name collate latin1_general_ci_as not in (
		select name from DBobjects WITH (nolock)
		where type=i.type collate latin1_general_ci_as 
		)
	--
	INSERT #diff
	SELECT o.name, o.type, 'in schema' as found
	    FROM DBObjects o WITH (nolock)
	    WHERE o.name collate latin1_general_ci_as not in (
		select name from #indbobjects
		where type=o.type collate latin1_general_ci_as 
		)
	--
	SELECT * FROM #diff
	    ORDER BY found, type, name
	--
	DECLARE @count int;
	SELECT @count=count(*) FROM #diff
	--
	RETURN @count;
END
GO
--

--=============================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'spGrantAccess' AND type = 'P')
	DROP PROCEDURE spGrantAccess
GO
--

CREATE PROCEDURE spGrantAccess (@access varchar(20), @user varchar(256))
-------------------------------------------------------------
--/H  spGrantAccess grants access to DB objects
--/A 
--/T Grants select/execute authority to all user db objects
--/T and to the HTM routines in master
--/T If "Admin" is specified, grants the user access to ALL objects. 
--/T <p> parameters:   
--/T <li> access char(1),   		-- U: grant access to dbObjects.access = 'U' objects <br>
--/T					-- A: grant access to all dbObjects
--/T <li> user 	varchar(256),   	-- UserID to grant
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spGrantAccess 'U', 'Test'  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS
BEGIN
	IF (@access not in ('A', 'U'))
		BEGIN
		PRINT 'Error: spGrantAccess @access parameter must be A or U, it is ' + @access
		RETURN
		END

	DECLARE userObject CURSOR
	READ_ONLY
	FOR 	select s.name, s.type
		from sysobjects s , dbObjects o
		where s.type in ('P ', 'FN', 'FS', 'FT', 'TF', 'TR', 'U ', 'V ', 'X ') 
	  	  and s.name = o.name		-- exclude system stuff
		  and o.access in ('U', @access)
		 
	
	DECLARE @name varchar(256)
	DECLARE @type char(2)
	DECLARE @verb varchar(32)
	DECLARE @command nvarchar(1000)
	OPEN userObject
	--
	FETCH NEXT FROM userObject INTO @name, @type  
	WHILE (@@fetch_status <> -1)
	BEGIN
	 	IF	(@type in ('U ', 'V ', 'TF', 'FT'))  SET @verb = 'SELECT' 
		ELSE IF	(@type in ('P ', 'TR', 'FN', 'X ', 'FS'))  SET @verb = 'EXECUTE'
		SET @command = N'GRANT ' + @verb + ' ON ' + @name + ' TO [' + @user +']'
		EXEC (@command)	
		--print @command + ' Type is: ' + @type
		FETCH NEXT FROM userObject INTO @name, @type
		IF (@@fetch_status != 0) BREAK
	END
	--
	CLOSE userObject
	DEALLOCATE userObject
	-- grant access to view function/procedure defs and to see IndexMap
	SET @command = 'GRANT VIEW DEFINITION TO ['+@user+']';
	EXEC (@command)
	SET @command = 'GRANT SELECT ON IndexMap TO ['+@user+']';
	EXEC (@command)
PRINT 'Access granted all "' + @access + '" objects'
END
GO
---------------------------------


--==========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spCheckDBIndexes]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spCheckDBIndexes]
GO
--
CREATE PROCEDURE spCheckDBIndexes
--------------------------------------------------------
--/H Checks all the mismatches ion indexes between the schema and the DB
--/A
--/T
--------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #isys (
		tablename varchar(128),
		name varchar(128),
		code char(1),
		found varchar(32)
	)
	--
	INSERT #isys
	SELECT o.name as tablename,  i.name, 'I' as code, 'in DB' as found
		FROM sysindexes i, sysobjects o WITH (nolock)
		WHERE i.id=o.id 
		and i.indid!=0			-- not a table
		and o.name not like 'dt%'
		and i.name like 'i[_]%' 

	INSERT #isys
	SELECT o.name as tablename,  i.name, 'K' as code, 'in DB' as found
		FROM sysindexes i, sysobjects o WITH (nolock)
		WHERE i.id=o.id 
			and i.indid!=0			-- not a table
			and (o.name not like 'dt%' and o.name not like 'pk[_][_]%')
			and (i.name like 'pk[_]%' and i.name not like 'pk[_][_]%')
	--
	INSERT #isys
	SELECT u.name as tableName, c.name, 'F' as code, 'in DB' as found
		FROM sysobjects u, sysobjects c WITH (nolock)
		WHERE u.xtype='U' and c.type='F'
			and c.parent_obj= u.id
			and u.name != 'dtproperties'
	--
	CREATE TABLE #imap (
		tablename varchar(128),
		name varchar(128),
		code char(1),
		found varchar(32)
	)
	INSERT #imap
	SELECT tableName, dbo.fIndexName(code,tableName,fieldlist,foreignkey),
		code, 'in schema' as found
		FROM IndexMap WITH (nolock)
	--
	CREATE TABLE #diff (
		name varchar(64),
		tableName varchar(64),
		code  varchar(64),
		found	varchar(64)
	)
	--
	INSERT #diff
	SELECT name, tableName, code, found 
		FROM #isys
		WHERE name not in (
			select name from #imap
		)
	--
	INSERT #diff
	SELECT name, tableName, code, found 
		FROM #imap
		WHERE name not in (
			select name from #isys
		)
	--
	SELECT * FROM #diff WITH (nolock)
	ORDER BY found, name
	--
	DROP TABLE #isys
	DROP TABLE #imap
	--
	DECLARE @count int;
	SELECT @count=count(*) FROM #diff
	DROP TABLE #diff
	--
	RETURN @count;
END
GO
--


PRINT '[spCheckDB.sql]: Database checking procs created'
GO

-- Patch to fix order of function params in fDocFunctionParams.

ALTER FUNCTION fDocFunctionParams(@functionname varchar(400))
-------------------------------------------------
--/H Return the parameters of a function
-------------------------------------------------
--/T Used by the auto-doc interface.
--/T<br>
--/T<samp>
--/T select * from dbo.fDocFunctionParams('fGetNearbyObjEq')
--/T</samp>
-------------------------------------------------
RETURNS @params TABLE (
	[name]		varchar(64),
	[type] 		varchar(32),
	[length]	int,
	[inout]		varchar(8),
	pnum		int
)
AS BEGIN
	---------------------------------
	-- get the objectid of DBObject,
	-- and its system type
	---------------------------------
	DECLARE @oid bigint, @type varchar(3);
	SELECT @oid=object_id, @type=type
	FROM sys.objects
	WHERE name=@functionname

	----------------------------
	-- get the input parameters
	----------------------------
	INSERT @params
	SELECT p.name, t.name as type, p.max_length as length,	
		'input', parameter_id as pnum
	FROM sys.objects o
	   JOIN sys.parameters p ON o.object_id = p.object_id
           JOIN sys.types t ON p.system_type_id = t.system_type_id
	WHERE 
	  o.object_id=@oid
	  and p.is_output != 'True'
	ORDER BY pnum
	  
	----------------------------
	-- get the output params
	----------------------------
	INSERT @params
	SELECT p.name, t.name as type, p.max_length as length, 
		'output', p.parameter_id as pnum
	FROM sys.objects o
	   JOIN sys.parameters p ON o.object_id = p.object_id
	   JOIN sys.types t ON p.system_type_id = t.system_type_id
	WHERE 
	  o.object_id=@oid
	  and p.is_output = 'True'

	----------------------------
	-- get the output columns
	----------------------------
	INSERT @params
	SELECT c.name, t.name as type, c.max_length as length, 
		'output', c.column_id as pnum
	FROM sys.objects o
	   JOIN sys.columns c ON o.object_id = c.object_id
	   JOIN sys.types t ON c.system_type_id = t.system_type_id
	WHERE 
	  o.object_id=@oid
	ORDER BY pnum
    RETURN
END
GO




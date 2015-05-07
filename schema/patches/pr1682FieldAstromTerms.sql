-- Patch to fix astrom precision in DR9 Field table.

USE BESTDR9
GO

EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

-- Create the asTrans (temp) table
CREATE TABLE asTrans(
	[run] [smallint] NOT NULL,
	[camcol] [tinyint] NOT NULL,
	[field] [smallint] NOT NULL,
	[a_r] [float] NOT NULL,
	[a_i] [float] NOT NULL,
	[a_u] [float] NOT NULL,
	[a_z] [float] NOT NULL,
	[a_g] [float] NOT NULL,
	[b_r] [float] NOT NULL,
	[b_i] [float] NOT NULL,
	[b_u] [float] NOT NULL,
	[b_z] [float] NOT NULL,
	[b_g] [float] NOT NULL,
	[c_r] [float] NOT NULL,
	[c_i] [float] NOT NULL,
	[c_u] [float] NOT NULL,
	[c_z] [float] NOT NULL,
	[c_g] [float] NOT NULL,
	[d_r] [float] NOT NULL,
	[d_i] [float] NOT NULL,
	[d_u] [float] NOT NULL,
	[d_z] [float] NOT NULL,
	[d_g] [float] NOT NULL,
	[e_r] [float] NOT NULL,
	[e_i] [float] NOT NULL,
	[e_u] [float] NOT NULL,
	[e_z] [float] NOT NULL,
	[e_g] [float] NOT NULL,
	[f_r] [float] NOT NULL,
	[f_i] [float] NOT NULL,
	[f_u] [float] NOT NULL,
	[f_z] [float] NOT NULL,
	[f_g] [float] NOT NULL
)
Go



DECLARE @ret int,
	@cmd nvarchar(1024)

SET @cmd = N'C:\sqlLoader\schema\etc\bcpAsTrans.bat';
EXEC @ret=master.dbo.xp_cmdshell @cmd;

IF (@ret = 0) 
    BEGIN


        -- Change the precision of astrom columns in Field to double precision.
        ALTER TABLE Field ALTER COLUMN a_u FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN a_g FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN a_r FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN a_i FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN a_z FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN b_u FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN b_g FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN b_r FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN b_i FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN b_z FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN c_u FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN c_g FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN c_r FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN c_i FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN c_z FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN d_u FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN d_g FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN d_r FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN d_i FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN d_z FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN e_u FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN e_g FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN e_r FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN e_i FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN e_z FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN f_u FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN f_g FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN f_r FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN f_i FLOAT NOT NULL
        ALTER TABLE Field ALTER COLUMN f_z FLOAT NOT NULL
        
        
        -- Update values in Field with those extracted from asTrans files.
        UPDATE f
        	SET f.a_u = t.a_u,
        	    f.a_g = t.a_g,
        	    f.a_r = t.a_r,
        	    f.a_i = t.a_i,
        	    f.a_z = t.a_z,
        	    f.b_u = t.b_u,
        	    f.b_g = t.b_g,
        	    f.b_r = t.b_r,
        	    f.b_i = t.b_i,
        	    f.b_z = t.b_z,
        	    f.c_u = t.c_u,
        	    f.c_g = t.c_g,
        	    f.c_r = t.c_r,
        	    f.c_i = t.c_i,
        	    f.c_z = t.c_z,
        	    f.d_u = t.d_u,
        	    f.d_g = t.d_g,
        	    f.d_r = t.d_r,
        	    f.d_i = t.d_i,
        	    f.d_z = t.d_z,
        	    f.e_u = t.e_u,
        	    f.e_g = t.e_g,
        	    f.e_r = t.e_r,
        	    f.e_i = t.e_i,
        	    f.e_z = t.e_z,
        	    f.f_u = t.f_u,
        	    f.f_g = t.f_g,
        	    f.f_r = t.f_r,
        	    f.f_i = t.f_i,
        	    f.f_z = t.f_z
        FROM Field f JOIN asTrans t ON f.run=t.run AND f.camcol=t.camcol and f.field=t.field
    END
ELSE
    PRINT 'bcp command failed.'
GO

-- Drop the temp table
DROP TABLE asTrans
GO


-- To disable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO

-- To update the currently configured value for this feature.
RECONFIGURE
GO

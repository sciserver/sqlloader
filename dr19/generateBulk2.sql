----------------------------------------------
-- set these!!!!
DECLARE @doExecute BIT = 1
DECLARE @truncate BIT = 1
-----------------------------------------------

DECLARE @sql NVARCHAR(4000)
DECLARE @id INT
DECLARE @path NVARCHAR(1000)
DECLARE @prefix NVARCHAR(1000)
DECLARE @targettable SYSNAME
DECLARE @fullpath NVARCHAR(1000)
DECLARE @errorMessage NVARCHAR(4000)

DECLARE cur CURSOR FAST_FORWARD FOR 
SELECT id, path, prefix, targettable 
FROM filestoload
WHERE loadStatus = 0

OPEN cur
FETCH NEXT FROM cur INTO @id, @path, @prefix, @targettable

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        SET @fullpath = CONCAT(@path, @prefix, @targettable, '.csv')
        
        -- Build SQL command
        SET @sql = ''
        IF @truncate = 1
            SET @sql = CONCAT('TRUNCATE TABLE ', @targettable, ';')

        SET @sql = CONCAT(@sql, 'BULK INSERT ', @targettable, 
                          ' FROM ''', @fullpath, ''' WITH (DATAFILETYPE=''char'', FIRSTROW=2, 
                          FIELDTERMINATOR='','', ROWTERMINATOR=''0x0a'', TABLOCK, FIELDQUOTE=''"'');')

        PRINT @sql

        IF (@doExecute = 1)
        BEGIN
            BEGIN TRANSACTION

            EXEC sp_executesql @sql

            -- Update load status
            SET @sql = CONCAT('UPDATE filestoload SET lastLoadDate = ''', GETDATE(), 
                              ''', loadStatus = 2 WHERE id = ', @id)

            PRINT @sql
            EXEC sp_executesql @sql

            COMMIT TRANSACTION
        END
    END TRY
    BEGIN CATCH
        -- Rollback if any error occurs
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION

        -- Capture error details
        SET @errorMessage = CONCAT('Error in BULK INSERT for ', @targettable, 
                                   ': ', ERROR_MESSAGE())

        -- Log error (Ensure error_log table exists)
        INSERT INTO error_log (error_time, error_message, related_id)
        VALUES (GETDATE(), @errorMessage, @id)

        -- Print error for debugging
        PRINT @errorMessage

        -- Optionally, update loadStatus to indicate failure
        UPDATE filestoload 
        SET loadStatus = -1 
        WHERE id = @id
    END CATCH

    FETCH NEXT FROM cur INTO @id, @path, @prefix, @targettable
END

CLOSE cur
DEALLOCATE cur
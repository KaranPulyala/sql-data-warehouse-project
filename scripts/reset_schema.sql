/*
===============================================================================
Stored Procedure: Reset Schema by Truncate all the tables in it.
===============================================================================
Script Purpose:
    This stored procedure performs Truncate on all the tables in a Schema mentioned.
		
Parameters:
    @Schema

Usage Example:
    EXEC reset @Schema = 'silver';
===============================================================================
*/


CREATE OR ALTER PROCEDURE dbo.reset
    @Schema NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Sql NVARCHAR(MAX) = '';

    -- 1. Find all tables in the specified schema and build TRUNCATE commands
    SELECT @Sql += 'TRUNCATE TABLE [' + s.name + '].[' + t.name + ']; '
    FROM sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE s.name = @Schema;

    -- 2. Execute the script if tables were found
    IF @Sql <> ''
    BEGIN
        PRINT '>> Resetting all tables in schema: ' + @Schema;
        EXEC sp_executesql @Sql;
        PRINT '>> Reset Complete.';
    END
    ELSE
    BEGIN
        PRINT '>> Error: Schema "' + @Schema + '" not found or contains no tables.';
    END
END;
GO

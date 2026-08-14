-- Stored Procedure: Audit Log Insert with error handling
-- Use Case: Track all data changes in sensitive pharma tables

CREATE OR ALTER PROCEDURE sp_InsertAuditLog
    @TableName      NVARCHAR(100),
    @RecordId       INT,
    @Action         NVARCHAR(10),   -- INSERT, UPDATE, DELETE
    @OldValue       NVARCHAR(MAX) = NULL,
    @NewValue       NVARCHAR(MAX) = NULL,
    @PerformedBy    NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO AuditLog (
            TableName, RecordId, Action,
            OldValue, NewValue,
            PerformedBy, PerformedAt
        )
        VALUES (
            @TableName, @RecordId, @Action,
            @OldValue, @NewValue,
            @PerformedBy, GETDATE()
        );
    END TRY
    BEGIN CATCH
        -- Log error without crashing the calling transaction
        INSERT INTO ErrorLog (ErrorMessage, ErrorDate)
        VALUES (ERROR_MESSAGE(), GETDATE());
    END CATCH
END;

-- Usage:
-- EXEC sp_InsertAuditLog
--     @TableName = 'Vendors', @RecordId = 101,
--     @Action = 'UPDATE', @OldValue = 'ABC Ltd', @NewValue = 'ABC Pharma Ltd',
--     @PerformedBy = 'khyati.jain';
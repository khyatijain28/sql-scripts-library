-- Stored Procedure: Vendor Search with optional filters
-- Demonstrates: optional parameters, dynamic filtering, safe pattern

CREATE OR ALTER PROCEDURE sp_VendorSearch
    @VendorName     NVARCHAR(100) = NULL,
    @CategoryId     INT           = NULL,
    @IsActive       BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.VendorId,
        v.VendorName,
        v.ContactEmail,
        c.CategoryName,
        v.IsActive,
        v.CreatedDate
    FROM Vendors v
    INNER JOIN Categories c ON v.CategoryId = c.CategoryId
    WHERE
        (@VendorName  IS NULL OR v.VendorName  LIKE '%' + @VendorName + '%')
        AND (@CategoryId IS NULL OR v.CategoryId = @CategoryId)
        AND (@IsActive   IS NULL OR v.IsActive   = @IsActive);
END;

-- Usage:
-- EXEC sp_VendorSearch;                              -- All vendors
-- EXEC sp_VendorSearch @VendorName = 'Pharma';      -- By name
-- EXEC sp_VendorSearch @CategoryId = 3, @IsActive = 1; -- Active in category
-- Stored Procedure: Paginated Results
-- Use Case: Large vendor/audit lists with server-side paging

CREATE OR ALTER PROCEDURE sp_GetVendorsPaginated
    @PageNumber     INT = 1,
    @PageSize       INT = 10,
    @SortColumn     NVARCHAR(50)  = 'VendorName',
    @SearchTerm     NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT
        v.VendorId,
        v.VendorName,
        v.ContactEmail,
        v.IsActive,
        COUNT(*) OVER() AS TotalRecords   -- Total count without extra query
    FROM Vendors v
    WHERE (@SearchTerm IS NULL OR v.VendorName LIKE '%' + @SearchTerm + '%')
    ORDER BY
        CASE WHEN @SortColumn = 'VendorName' THEN v.VendorName END ASC,
        CASE WHEN @SortColumn = 'CreatedDate' THEN v.CreatedDate END DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

-- Usage:
-- EXEC sp_GetVendorsPaginated @PageNumber = 1, @PageSize = 10;
-- EXEC sp_GetVendorsPaginated @PageNumber = 2, @PageSize = 10, @SearchTerm = 'ABC';

-- WHY: OFFSET...FETCH is more efficient than ROW_NUMBER() for simple paging.
-- COUNT(*) OVER() avoids a second COUNT query to get total records.
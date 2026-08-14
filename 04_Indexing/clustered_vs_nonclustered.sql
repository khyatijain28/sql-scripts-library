-- Clustered vs Non-Clustered Index
-- Understanding the difference with real examples

-- =============================================
-- CLUSTERED INDEX
-- =============================================
-- Only ONE per table. Defines the physical sort order of the table.
-- By default, created on the Primary Key.

CREATE TABLE Vendors (
    VendorId    INT PRIMARY KEY,        -- Clustered index auto-created here
    VendorName  NVARCHAR(100) NOT NULL,
    CategoryId  INT NOT NULL,
    IsActive    BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

-- Explicit clustered index (if PK is not the best choice)
CREATE CLUSTERED INDEX IX_Vendors_CreatedDate
ON Vendors (CreatedDate);
-- Use when queries most often filter/sort by date

-- =============================================
-- NON-CLUSTERED INDEX
-- =============================================
-- Multiple allowed per table. Separate structure pointing to data rows.

-- Single column index
CREATE NONCLUSTERED INDEX IX_Vendors_CategoryId
ON Vendors (CategoryId);

-- Composite index — column order matters!
-- Put the most selective / most filtered column first
CREATE NONCLUSTERED INDEX IX_Vendors_Category_Active
ON Vendors (CategoryId, IsActive)
INCLUDE (VendorName);   -- Cover columns needed in SELECT

-- =============================================
-- WHEN TO USE WHICH
-- =============================================
-- Clustered  : Range queries, ORDER BY, the "main" lookup key
-- Non-Clustered: Specific filter columns, foreign keys, search fields

-- Check existing indexes on a table
SELECT i.name, i.type_desc, c.name AS ColumnName, ic.is_included_column
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE OBJECT_NAME(i.object_id) = 'Vendors'
ORDER BY i.index_id, ic.key_ordinal;
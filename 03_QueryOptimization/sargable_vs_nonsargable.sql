-- SARGable vs Non-SARGable Queries
-- SARG = Search ARGument — can SQL Server use an index for this condition?

--NON-SARGable: Function on column prevents index use → full scan
SELECT VendorId, VendorName
FROM Vendors
WHERE YEAR(CreatedDate) = 2024;

SELECT VendorId, VendorName
FROM Vendors
WHERE LEFT(VendorCode, 3) = 'PHA';

SELECT VendorId, VendorName
FROM Vendors
WHERE UPPER(VendorName) = 'ABC PHARMA';

-- SARGable rewrites — index can now be used
SELECT VendorId, VendorName
FROM Vendors
WHERE CreatedDate >= '2024-01-01' AND CreatedDate < '2025-01-01';

SELECT VendorId, VendorName
FROM Vendors
WHERE VendorCode LIKE 'PHA%';

SELECT VendorId, VendorName
FROM Vendors
WHERE VendorName = 'ABC Pharma';   -- Use correct case or collation

-- WHY: When a function wraps a column, SQL Server cannot use the index
-- on that column. Always move transformations to the right-hand side
-- of the condition, or rewrite the predicate entirely.
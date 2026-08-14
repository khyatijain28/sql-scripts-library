-- Query Optimization: Before and After Index
-- Use Case: Vendor lookup by name — common in pharma ERP systems

-- BEFORE: No index — full table scan on every search
-- Execution plan shows: Table Scan, high logical reads
SELECT VendorId, VendorName, ContactEmail
FROM Vendors
WHERE VendorName = 'ABC Pharmaceuticals';

-- FIX: Create a non-clustered index on VendorName
CREATE NONCLUSTERED INDEX IX_Vendors_VendorName
ON Vendors (VendorName)
INCLUDE (VendorId, ContactEmail);  -- Cover the SELECT columns to avoid key lookup

-- AFTER: Same query now uses Index Seek — dramatically fewer reads
SELECT VendorId, VendorName, ContactEmail
FROM Vendors
WHERE VendorName = 'ABC Pharmaceuticals';

-- Check index usage stats
SELECT
    i.name AS IndexName,
    s.user_seeks, s.user_scans, s.user_lookups, s.user_updates,
    s.last_user_seek
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats s
    ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE OBJECT_NAME(i.object_id) = 'Vendors';

-- WHY: Index Seek reads only matching rows. Table Scan reads every row.
-- INCLUDE columns make it a covering index — no key lookup needed.
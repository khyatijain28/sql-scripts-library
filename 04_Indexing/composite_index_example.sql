-- Composite Index: Column Order Strategy
-- Use Case: Vendor audit queries filtered by multiple columns

-- Common query pattern in audit systems:
SELECT AuditId, VendorId, AuditDate, Result
FROM AuditRecords
WHERE CategoryId = 3
  AND IsActive = 1
  AND AuditDate >= '2024-01-01';

-- Wrong column order — less selective column first
CREATE NONCLUSTERED INDEX IX_Wrong
ON AuditRecords (IsActive, CategoryId, AuditDate);

-- Correct column order — most selective / equality filter first
CREATE NONCLUSTERED INDEX IX_AuditRecords_Category_Active_Date
ON AuditRecords (CategoryId, IsActive, AuditDate)
INCLUDE (AuditId, VendorId, Result);

-- RULES FOR COMPOSITE INDEX COLUMN ORDER:
-- 1. Equality columns first (WHERE col = value)
-- 2. Range columns last  (WHERE col >= value)
-- 3. INCLUDE columns that appear in SELECT (avoids key lookup)
-- 4. Most selective column first among equality columns

-- Verify the index is being used
SELECT TOP 100
    AuditId, VendorId, AuditDate, Result
FROM AuditRecords WITH (INDEX = IX_AuditRecords_Category_Active_Date)
WHERE CategoryId = 3 AND IsActive = 1 AND AuditDate >= '2024-01-01';
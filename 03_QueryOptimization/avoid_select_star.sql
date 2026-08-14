-- Query Optimization: Avoid SELECT *
-- Use Case: Audit report query in a pharma system

-- BAD: SELECT * fetches all columns including BLOBs, unused fields
-- Forces SQL Server to read every column from every page
SELECT * FROM AuditRecords WHERE AuditDate >= '2024-01-01';

--GOOD: Select only required columns
SELECT
    AuditId,
    VendorId,
    AuditDate,
    AuditorName,
    Result
FROM AuditRecords
WHERE AuditDate >= '2024-01-01';

-- WHY SELECT * is harmful:
-- 1. Fetches columns you don't need (wastes I/O and memory)
-- 2. Breaks covering indexes (forces key lookups)
-- 3. Breaks code silently when columns are added/removed
-- 4. Prevents query plan caching efficiency

-- BAD: SELECT * in a JOIN — column name conflicts
SELECT *
FROM Vendors v
INNER JOIN AuditRecords a ON v.VendorId = a.VendorId;

-- GOOD: Explicit columns, no ambiguity
SELECT
    v.VendorId, v.VendorName,
    a.AuditId, a.AuditDate, a.Result
FROM Vendors v
INNER JOIN AuditRecords a ON v.VendorId = a.VendorId;
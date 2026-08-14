-- ROW_NUMBER() Window Function
-- Use Case: Get latest audit record per vendor

-- Without window function — complex correlated subquery
SELECT a.*
FROM AuditRecords a
WHERE a.AuditId = (
    SELECT TOP 1 AuditId
    FROM AuditRecords
    WHERE VendorId = a.VendorId
    ORDER BY AuditDate DESC
);

--With ROW_NUMBER() — clean and efficient
WITH RankedAudits AS (
    SELECT
        AuditId, VendorId, AuditDate, Result, AuditorName,
        ROW_NUMBER() OVER (
            PARTITION BY VendorId       -- Reset numbering per vendor
            ORDER BY AuditDate DESC     -- Latest first
        ) AS RowNum
    FROM AuditRecords
)
SELECT AuditId, VendorId, AuditDate, Result, AuditorName
FROM RankedAudits
WHERE RowNum = 1;   -- Only the latest per vendor

-- Use ROW_NUMBER for: deduplication, pagination, latest-per-group
-- Each row gets a unique number — no ties
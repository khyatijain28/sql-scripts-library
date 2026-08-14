-- Multiple CTEs in one query
-- Use Case: Vendor audit summary with compliance status

WITH ActiveVendors AS (
    SELECT VendorId, VendorName, CategoryId
    FROM Vendors
    WHERE IsActive = 1
),
AuditCounts AS (
    SELECT VendorId, COUNT(*) AS TotalAudits,
           SUM(CASE WHEN Result = 'Pass' THEN 1 ELSE 0 END) AS PassedAudits
    FROM AuditRecords
    GROUP BY VendorId
),
ComplianceStatus AS (
    SELECT av.VendorId, av.VendorName,
           ISNULL(ac.TotalAudits, 0) AS TotalAudits,
           ISNULL(ac.PassedAudits, 0) AS PassedAudits,
           CASE
               WHEN ac.TotalAudits IS NULL THEN 'Not Audited'
               WHEN ac.PassedAudits = ac.TotalAudits THEN 'Fully Compliant'
               WHEN ac.PassedAudits > 0 THEN 'Partially Compliant'
               ELSE 'Non-Compliant'
           END AS ComplianceStatus
    FROM ActiveVendors av
    LEFT JOIN AuditCounts ac ON av.VendorId = ac.VendorId
)
SELECT * FROM ComplianceStatus
ORDER BY ComplianceStatus, VendorName;

-- WHY: Chaining multiple CTEs keeps complex logic modular and testable.
-- Each CTE can be debugged independently by selecting from it alone.
-- RANK() vs DENSE_RANK() vs ROW_NUMBER()
-- Use Case: Vendor ranking by audit pass rate

WITH VendorPassRate AS (
    SELECT
        VendorId,
        COUNT(*) AS TotalAudits,
        SUM(CASE WHEN Result = 'Pass' THEN 1 ELSE 0 END) AS PassedAudits,
        CAST(
            SUM(CASE WHEN Result = 'Pass' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*) AS DECIMAL(5,2)
        ) AS PassRate
    FROM AuditRecords
    GROUP BY VendorId
)
SELECT
    VendorId,
    PassRate,
    ROW_NUMBER()  OVER (ORDER BY PassRate DESC) AS RowNum,
    -- Unique number, no gaps, no ties
    RANK()        OVER (ORDER BY PassRate DESC) AS RankNum,
    -- Ties get same rank, next rank skips (1,1,3)
    DENSE_RANK()  OVER (ORDER BY PassRate DESC) AS DenseRankNum
    -- Ties get same rank, no skipping (1,1,2)
FROM VendorPassRate;

-- WHEN TO USE WHICH:
-- ROW_NUMBER : Pagination, deduplication (must have unique result)
-- RANK       : Competition ranking (Olympic style — skip after tie)
-- DENSE_RANK : Category ranking (no gaps after tie)
-- Running Total and Moving Average
-- Use Case: Monthly vendor onboarding trend in pharma system

-- Running total of vendors onboarded per month
SELECT
    YEAR(CreatedDate)  AS Year,
    MONTH(CreatedDate) AS Month,
    COUNT(*)           AS NewVendors,
    SUM(COUNT(*)) OVER (
        ORDER BY YEAR(CreatedDate), MONTH(CreatedDate)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Vendors
GROUP BY YEAR(CreatedDate), MONTH(CreatedDate)
ORDER BY Year, Month;

-- 3-month moving average of audit pass rates
SELECT
    AuditMonth,
    PassRate,
    AVG(PassRate) OVER (
        ORDER BY AuditMonth
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW  -- Current + 2 previous months
    ) AS MovingAvg3Month
FROM (
    SELECT
        DATEFROMPARTS(YEAR(AuditDate), MONTH(AuditDate), 1) AS AuditMonth,
        CAST(
            SUM(CASE WHEN Result = 'Pass' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*) AS DECIMAL(5,2)
        ) AS PassRate
    FROM AuditRecords
    GROUP BY YEAR(AuditDate), MONTH(AuditDate)
) AS MonthlyStats
ORDER BY AuditMonth;

-- WHY: Window functions compute across a set of rows related to the
-- current row without collapsing them into a GROUP BY aggregate.
-- ROWS BETWEEN defines the window frame for the calculation.
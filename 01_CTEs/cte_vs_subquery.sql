-- CTE vs Subquery: Same result, better readability with CTE

-- Subquery approach (hard to read, hard to debug)
SELECT VendorId, VendorName, TotalOrders
FROM (
    SELECT v.VendorId, v.VendorName, COUNT(o.OrderId) AS TotalOrders
    FROM Vendors v
    LEFT JOIN Orders o ON v.VendorId = o.VendorId
    GROUP BY v.VendorId, v.VendorName
) AS VendorSummary
WHERE TotalOrders > 5;

-- CTE approach (readable, reusable, debuggable)
WITH VendorSummary AS (
    SELECT v.VendorId, v.VendorName, COUNT(o.OrderId) AS TotalOrders
    FROM Vendors v
    LEFT JOIN Orders o ON v.VendorId = o.VendorId
    GROUP BY v.VendorId, v.VendorName
)
SELECT VendorId, VendorName, TotalOrders
FROM VendorSummary
WHERE TotalOrders > 5;

-- WHY: CTEs improve readability and can be referenced multiple times
-- in the same query. Subqueries execute inline and can't be reused.
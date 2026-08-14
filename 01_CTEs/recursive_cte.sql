-- Recursive CTE: Employee Hierarchy Tree
WITH EmployeeHierarchy AS (
    SELECT EmployeeId, EmployeeName, ManagerId,
           0 AS Level,
           CAST(EmployeeName AS VARCHAR(500)) AS HierarchyPath
    FROM Employees
    WHERE ManagerId IS NULL

    UNION ALL

    SELECT e.EmployeeId, e.EmployeeName, e.ManagerId,
           eh.Level + 1,
           CAST(eh.HierarchyPath + ' > ' + e.EmployeeName AS VARCHAR(500))
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerId = eh.EmployeeId
)
SELECT EmployeeId,
       REPLICATE('    ', Level) + EmployeeName AS EmployeeName,
       Level, HierarchyPath
FROM EmployeeHierarchy
ORDER BY HierarchyPath;
-- WHY: Recursive CTEs replace cursors and self-joins for hierarchy data.
-- Default max recursion is 100. Use OPTION(MAXRECURSION N) to increase.
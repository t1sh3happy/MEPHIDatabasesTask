WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый терм: выбирать Ивана Иванова и его непосредственных подчиненных
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1  -- Иван Иванов

    UNION ALL

    -- Рекурсивный терм: выбирать подчиненных сотрудников
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)

SELECT
    eh.EmployeeID, 
    eh.Name AS EmployeeName, 
    eh.ManagerID, 
    d.DepartmentName, 
    r.RoleName,
    COALESCE(STRING_AGG(DISTINCT p.ProjectName, ', '), 'NULL') AS ProjectNames,
    COALESCE(STRING_AGG(DISTINCT t.TaskName, ', '), 'NULL') AS TaskNames
FROM 
    EmployeeHierarchy eh
LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Projects p ON eh.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON eh.EmployeeID = t.AssignedTo
GROUP BY 
    eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY 
    eh.Name;
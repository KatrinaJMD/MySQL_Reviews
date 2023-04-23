use alextheanalyst;

# FULL OUTER JOIN equivalent
SELECT *
FROM EmployeeDemographics
left Join WareHouseEmployeeDemographics
ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID
union 
SELECT *
FROM EmployeeDemographics
right Join WareHouseEmployeeDemographics
ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID;

# UNION (removes duplicates)
SELECT *
FROM EmployeeDemographics
union 
SELECT *
FROM WareHouseEmployeeDemographics
ORDER BY EmployeeID;

# UNION ALL (keeps duplicates)
SELECT *
FROM EmployeeDemographics
union all
SELECT *
FROM WareHouseEmployeeDemographics
ORDER BY EmployeeID;

# View tables
SELECT *
FROM EmployeeDemographics;

SELECT *
FROM WareHouseEmployeeDemographics
ORDER BY EmployeeID;

SELECT *
FROM EmployeeSalary;

# Why this UNION works: same datatypes (int, varchar, int)
SELECT EmployeeID, FirstName, Age
FROM EmployeeDemographics
union
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
ORDER BY EmployeeID;

# CASE STATEMENTS
SELECT FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN "Old"
    WHEN Age BETWEEN 27 AND 30 THEN "Young"
    ELSE "Baby"
    END "AgeGroup"
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

# JOIN STATEMENTS
SELECT *
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;

# NESTED CASE STATEMENTS
SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = "Salesman" THEN (Salary * 0.10)
    WHEN JobTitle = "Accountant" THEN (Salary * 0.05)
    WHEN JobTitle = "HR" THEN (Salary * 0.01)
    ELSE (Salary * 0.03)
    END "SalaryRaise",
CASE
	WHEN JobTitle = "Salesman" THEN Salary + (Salary * 0.10)
    WHEN JobTitle = "Accountant" THEN Salary + (Salary * 0.05)
    WHEN JobTitle = "HR" THEN Salary + (Salary * 0.01)
    ELSE Salary + (Salary * 0.03)
    END "SalaryAfterRaise"
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
ORDER BY Salary DESC;

# HAVING CLAUSE
SELECT JobTitle, COUNT(JobTitle) AS NoEmployees
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1
ORDER BY NoEmployees DESC;

SELECT JobTitle, AVG(Salary) AS AvgSalary
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AvgSalary > 45000
ORDER BY AvgSalary DESC;

# UPDATE and DELETE: UPDATES alters existing rows, while INSERT adds new rows
UPDATE EmployeeDemographics
SET EmployeeID = 1012
WHERE FirstName = "Holly" AND LastName = "Flax";

UPDATE EmployeeDemographics
SET Age = 31, Gender = "Female"
WHERE EmployeeID = 1012;

# DELETE FROM EmployeeDemographics
# WHERE EmployeeID = 1005;

# TIPS before Deleting :
# SELECT *
# FROM EmployeeDemographics
# WHERE EmployeeID = 1005;
# THEN, replace [SELECT *] by [DELETE] after reviewing the rows to be Deleted
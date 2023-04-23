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

# PARTITION BY
SELECT
	FirstName,
    LastName,
    Gender,
    Salary,
    COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.EmployeeID = sal.EmployeeID;

# CTE (COMMON TABLE EXPRESSION)
WITH CTE_Employee AS
(SELECT
	FirstName,
    LastName,
    Gender,
    Salary,
    COUNT(Gender) OVER (PARTITION by Gender) as TotalGender,
    AVG (Salary) OVER (PARTITION BY Gender) as AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000')
SELECT *
FROM CTE_Employee;

# TEMP (TEMPORARY) TABLES
DROP TABLE IF EXISTS temp_Employee;
CREATE TEMPORARY TABLE temp_Employee (
	EmployeeID INT,
    JobTitle VARCHAR(100),
    Salary INT);

INSERT INTO temp_Employee
VALUES (1001, 'HR', 45000);

INSERT INTO temp_Employee
SELECT *
FROM EmployeeSalary;

SELECT *
FROM temp_Employee;

DROP TABLE IF EXISTS tempo_Employee;
CREATE TEMPORARY TABLE tempo_Employee (
	JobTitle VARCHAR(50),
    EmployeesPerJob INT,
    AvgAge INT,
    AvgSalary INT);
    
INSERT INTO tempo_Employee
SELECT
	JobTitle,
	Count(JobTitle),
	AVG(Age),
    AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
ON emp.EmployeeID = sal.EmployeeID
group by JobTitle;

SELECT *
FROM tempo_Employee;

# STRING FUNCTIONS
DROP TABLE IF EXISTS EmployeeErrors;
CREATE TABLE EmployeeErrors (
	EmployeeID VARCHAR(50),
    FirstName VARCHAR(50),
    LastName VARCHAR(50));

INSERT INTO EmployeeErrors VALUES 
('1001  ', 'Jimbo', 'Halbert'),
('  1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired');

SELECT *
FROM EmployeeErrors;

# USING [TRIM, LTRIM, RTRIM]
# TRIM
SELECT
	EmployeeID,
    TRIM(employeeID) AS id_TRIM
FROM EmployeeErrors;

# LTRIM
SELECT
	EmployeeID,
    LTRIM(employeeID) AS id_LTRIM
FROM EmployeeErrors;

# RTRIM
SELECT
	EmployeeID,
    RTRIM(employeeID) AS id_RTRIM
FROM EmployeeErrors;

# USING REPLACE
SELECT
	LastName,
    REPLACE(LastName, '- Fired', '') AS LastNameFixed
FROM EmployeeErrors;

# USING SUBSTRING (Gender, LastName, Age, DateOfBirth)
SELECT
	Substring(err.FirstName,1,3) AS err_FirstName,
	Substring(dem.FirstName,1,3) AS dem_FirstName,
    Substring(err.LastName,1,3) AS err_LastName,
    Substring(dem.LastName,1,3) AS dem_LastName
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	ON Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	AND Substring(err.LastName,1,3) = Substring(dem.LastName,1,3);

# USING UPPER AND LOWER
SELECT
	FirstName,
    LOWER(FirstName) AS LowerCase
FROM EmployeeErrors;

SELECT
	Firstname,
    UPPER(FirstName) AS UpperCase
FROM EmployeeErrors;

# SUBQUERIES
SELECT
	EmployeeID,
    Salary,
    (SELECT AVG(Salary)
    FROM EmployeeSalary) AS AllAvgSalary
FROM EmployeeSalary;

# How to do it with PARTITION BY
SELECT
	EmployeeID,
    Salary,
    AVG(Salary) OVER () AS AllAvgSalary
FROM EmployeeSalary;

# Why GROUP BY doesn't work
SELECT
	EmployeeID,
    Salary,
    AVG(Salary) AS AllAvgSalary
FROM EmployeeSalary
GROUP BY EmployeeID, Salary
ORDER BY 1, 2;

# SUBQUERY in FROM
SELECT
	a.EmployeeID,
    AllAvgSalary
FROM 
	(SELECT
		EmployeeID,
        Salary,
        AVG(Salary) over () as AllAvgSalary
	 FROM EmployeeSalary) a
ORDER BY a.EmployeeID;

# SUBQUERY in WHERE
SELECT
	EmployeeID,
	JobTitle,
    Salary
FROM EmployeeSalary
WHERE EmployeeID
IN (SELECT EmployeeID 
	FROM EmployeeDemographics
	WHERE Age > 30);
    
# STORED PROCEDURE: without parameters
DROP PROCEDURE IF EXISTS proc_table;
DELIMITER $$
CREATE PROCEDURE proc_table()
BEGIN
DROP TEMPORARY TABLE IF EXISTS temp_table;
CREATE TEMPORARY TABLE temp_table (
	JobTitle VARCHAR(50),
	EmployeesPerJob INT,
	AvgAge INT,
	AvgSalary INT);
    
INSERT INTO temp_table
SELECT
	JobTitle,
	Count(JobTitle),
    Avg(Age),
    AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle;

SELECT *
FROM temp_table
ORDER BY AvgAge DESC;

END $$

CALL proc_table();



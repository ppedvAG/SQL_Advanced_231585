--Dynamisches SQL:
--Indem das SQL Statement als String-Variable angelegt wird, können wir variabel Spalten, Tabellen etc. angeben:

ALTER PROC sp_DynSQL @column varchar(50), @table varchar(50)
AS
DECLARE @sql varchar(255)
SET @sql = 'SELECT ['+ @column +'],
(SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '''+ @Table +''' AND COLUMN_Name = '''+ @Column +''')
FROM  ['+ @table +']'
EXEC (@sql) --Führt die sql variable aus

EXEC sp_DynSQL Freight, Orders
/*
SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees' AND COLUMN_Name = 'lastname'
*/

--INFORMATION_SCHEMA.TABLES/COLUMNS/VIEWS/ROUTINES zeigt Metadaten des jeweiligen Objekts:


SELECT lastname,
(SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees' AND COLUMN_Name = 'lastname')
FROM employees


SELECT * FROM INFORMATION_SCHEMA.VIEWS

SELECT * FROM INFORMATION_SCHEMA.ROUTINES

SELECT * FROM INFORMATION_SCHEMA.COLUMNS

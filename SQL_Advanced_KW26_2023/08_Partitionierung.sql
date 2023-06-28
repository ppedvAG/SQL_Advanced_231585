--Partitionierung Step by Step:


--1. Kandidaten finden; Spalte/Wert nach dem partitioniert werden soll; Grenzen überlegen

--2. Files und Filegroups erstellen


 ALTER DATABASE Northwind
 ADD FILEGROUP FilegroupName

 ALTER DATABASE Northwind
 ADD FILE 
	(NAME = NameFile,
	FILENAME = 'c:\usw...',
	SIZE = 100,
	AUTOGROWTH
	)
--Files und Filegroups alternativ über UI erstellen

CREATE TABLE Sales (
ID int identity PRIMARY KEY,
Datum date,
Summe decimal(10,2) )

INSERT INTO Sales
SELECT
CAST(getdate()-365*4 + (365*2*RAND() - 365) as date),
CAST(RAND() * 10 + 5  as decimal(10,2))
GO 10000

SELECT MIN(Datum), MAX(Datum) FROM Sales
--> Partitionen nach Geschäftsjahr erstellen für 2018, 2019 und 2020

/*

3. Partition Function erstellen

4. Partition Scheme erstellen

5. Partitionierung durchführen

*/

--Die Partition Function definiert die Grenzwerte unserer "Buckets"
--in diesem Fall "von links" bis zur ersten angegeben Grenze, Grenzwert mit inbegriffen:
CREATE PARTITION FUNCTION pf_Sales (date)
AS
RANGE LEFT FOR VALUES --oder RANGE RIGHT
	('20181231', '20191231', '20201231')

--Das Partition Scheme "nutzt" die zugehörige P.Funct. und weist den "Buckets" eine entsprechende Filegroup zu
CREATE PARTITION SCHEME ps_Sales
AS PARTITION pf_Sales
TO ('Sales2018', 'Sales2019', 'Sales2020', 'PRIMARY') --TO FILEGROUPS, Immer eine mehr als Buckets definiert sind (jeder Fall muss abgedeckt sein)

--Die Filegroups weisen im Anschluss die Daten ihrem jeweiligen File zu


--Falls Table noch nicht vorhanden war, neu erstellen mit Zusatz ON Partitionsscheme:
CREATE TABLE Partitionierungen (
id int,
Datum date)
ON ps_Sales (Datum)
--Eingefügte Daten werden im Anschluss automatisch auf die Partitionen verteilt



--Falls bereits vorhandener Table, müssen wir einen neuen Clustered Index erstellen, der zusätzlich das Partition Scheme verwendet:

ALTER TABLE [dbo].[Sales] DROP CONSTRAINT [PK__Sales__3214EC27158CCF84]
DROP INDEX [PK__Sales__3214EC27158CCF84] ON Sales

CREATE CLUSTERED INDEX CIX_Sales ON Sales (ID)
ON ps_Sales (Datum)

SELECT * FROM Sales

SELECT DISTINCT $PARTITION.pf_Sales(Datum), Datum FROM Sales --Zeigt zu jedem Datensatz die zugehörige Partitionsnummer an
WHERE Datum = '20210101'

INSERT INTO Sales 
VALUES ('20210101', 14) --Werte außerhalb der definierten Partitionen kommen in "Ausweich-Filegroup" (hier PRIMARY)


SELECT * FROM sys.dm_db_index_physical_stats (db_ID(), object_ID('Sales'), NULL, NULL, 'detailed')

SELECT * FROM sys.dm_db_index_usage_stats
ORDER BY user_seeks DESC



--Views "partitionieren":

--Idee: View aus mehreren Tables, die Tables sind "sortiert" bspw. nach Geschäftsjahren
DROP TABLE Sales2018
DROP TABLE Sales2019

CREATE TABLE Sales2018 (
ID int NOT NULL,
Datum date NOT NULL,
Summe decimal(10,2), 
Jahr int NOT NULL) 

CREATE TABLE Sales2019 (
ID int NOT NULL,
Datum date NOT NULL,
Summe decimal(10,2),
Jahr int NOT NULL) 

INSERT INTO Sales2018 
VALUES ('20180401', 20.21, 2018)

INSERT INTO Sales2019 
VALUES ('20190401', 20.21, 2019)

SELECT * FROM Sales2018
SELECT * FROM Sales2019

--Partitionierte View braucht zwingend CHECK Constraints, nach denen partitioniert werden soll:
ALTER TABLE Sales2018
ADD CONSTRAINT ch_Sales2018 CHECK (Jahr = 2018)

ALTER TABLE Sales2019
ADD CONSTRAINT ch_Sales2019 CHECK (Jahr = 2019)

ALTER TABLE Sales2018
--ALTER COLUMN Datum date NOT NULL
ADD PRIMARY KEY (ID, Jahr)

--View erstellen mit UNION ALL der zugehörigen Tables:
DROP VIEW v_Sales

CREATE VIEW v_Sales 
AS
SELECT * FROM dbo.Sales2018
UNION ALL
SELECT * FROM dbo.Sales2019


SELECT * FROM v_Sales

SELECT * FROM v_Sales
WHERE Jahr = 2018 -- BETWEEN '20180101' AND '20181231'
--Wenn alles richtig, wird nur der entsprechende Table gelesen, nachdem gefiltert wurde (Siehe Query Plan)


SELECT * FROM Sales2018
SELECT * FROM Sales2019

--Es kann auch direkt in die View INSERTED werden; durch die Partitionierung werden die Inserts in ihrem jeweiligen Table gemacht:
INSERT INTO v_Sales 
VALUES ('20181212', 111.12, 2018)
--Updateable View funktioniert nicht mit IDENTITY Spalte!

SET STATISTICS TIME, IO ON


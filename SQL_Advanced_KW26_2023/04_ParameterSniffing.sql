--Parameter Sniffing

CREATE TABLE Sniffing (
ID int identity,
Zeugs varchar(10) )

INSERT INTO Sniffing
VALUES ('A')
GO 10

INSERT INTO Sniffing
VALUES ('B')
GO 10

INSERT INTO Sniffing
VALUES ('C')
GO 10000

SELECT * FROM Sniffing
--Stark ungleiche Verteilung der Werte (10, 10, 10000)

CREATE PROC sp_Sniffing @Zeugs varchar(10)
AS
SELECT * FROM Sniffing
WHERE Zeugs = @Zeugs
--OPTION (OPTIMIZE FOR (@Zeugs = 'B'))

--Je nachdem welcher Wert das erste Mal übergeben wird, wird der Query Plan der Procedure optimiert für die Anzahl der Zeilen
--die beim ersten Mal ausgegeben werden:

EXEC sp_Sniffing A

EXEC sp_Sniffing C

--Problem: Bei starkem Ungleichgewicht ist der Plan sehr schlecht für andere Werte (zu wenig oder zu viele Ressourcen bereitgestellt)


--WITH RECOMPILE: Erzwingt Erstellung von neuem Ausführungsplan 

EXEC sp_Sniffing A WITH RECOMPILE

SELECT * FROM Sniffing



/*
INSERT INTO Customers2
SELECT * FROM customers2
GO 2

SELECT * FROM Customers2 c
JOIN Orders2 o ON c.CustomerID = o.CustomerID
*/

--Parallelism: Falls vorhanden (und eingestellt) können ab einem gewissen Kostenschwellenwert mehrere Cores gleichzeitig an einer 
--Abfrage arbeiten. Die Arbeitsteilung der einzelnen Threads ist aber u.U. sehr ungleich verteilt
--> Es muss immer auf den "langsamsten" Core gewartet werden

SELECT * FROM Customers2 OPTION(MAXDOP 8) --Gibt an wieviele Cores maximal verwendet werden dürfen; überschreibt Servereinstellung

SELECT DISTINCT * FROM Customers2 
WHERE Country LIKE '%[GFMAU]%'
AND CompanyName LIKE '%%' 
GROUP BY [CustomerID], [CompanyName], [ContactName], [ContactTitle], [Address], [City], 
[Region], [PostalCode], [Country], [Phone], [Fax], [neuespalte]




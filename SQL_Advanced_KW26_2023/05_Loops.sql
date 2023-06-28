--WHILE Schleifen

DECLARE @counter int = 1

WHILE @counter < 5
BEGIN
SELECT 'Hallo'
SET @counter += 1
END


--In Orders Spalte Freight in 10% Schritten erhöhen, dabei soll MAX(Freight) nicht über 1500
--oder AVG(freight) nicht über 110


WHILE (SELECT AVG(Freight) * 1.1 FROM Orders) < 110 AND (SELECT MAX(Freight) * 1.1 FROM Orders) < 1500 
BEGIN
UPDATE Orders
SET Freight = Freight * 1.1
END

SELECT MAX(Freight), AVG(Freight) FROM Orders
--Startwert 1007,64 & 78,2442


--GOTO springt im Skript zur zugehörigen Zeile
DECLARE @counter2 int = 1
Weitermachen2:

IF @counter2 <= 5
BEGIN
SELECT 'Hallo!'
SET @counter2 += 1 END
ELSE BEGIN GOTO Ende END

GOTO Weitermachen2
Ende:
SELECT 'Ende'


--BREAK & CONTINUE

DECLARE @counter3 int = 1

WHILE @counter3 < 5
BEGIN
SELECT 'Hallo'
SET @counter3 += 1
IF @counter3 = 3 BREAK --Springt aus der aktuellen Schleife raus
END
SELECT @Counter3


DECLARE @counter3 int = 1

WHILE @counter3 < 5
BEGIN
SET @counter3 += 1
IF @counter3 >= 3 CONTINUE --Springt zum  Anfang des Loops, ohne den Rest der Schleife auszuführen
SELECT 'Hallo'
END
SELECT @Counter3



--ROW_NUMBER mit "ID-Spalte" statt Cursor

DROP TABLE IF EXISTS #t
SELECT ROW_NUMBER() OVER(ORDER BY OrderID) as ID,
Orders.*
INTO #t
FROM Orders

DECLARE @counter4 int = 0
WHILE @counter4 <= (SELECT MAX(ID) FROM #t) 
BEGIN 
(SELECT OrderID FROM #t WHERE ID = @counter4)
SET @counter4 += 1
END


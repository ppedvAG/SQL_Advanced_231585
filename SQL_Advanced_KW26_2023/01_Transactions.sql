USE Northwind
GO

BEGIN TRAN 


SELECT @@TRANCOUNT
UPDATE Employees
SET LastName = 'abc'

ROLLBACK COMMIT

SELECT * FROM Employees

BEGIN TRAN 

SELECT @@TRANCOUNT
UPDATE Employees
SET LastName = 'abc'
WHERE EmployeeID IN (1,2,3,4,5)



-- SELECT * FROM sys.dm_db_index_physical_stats (db_ID(), OBJECT_ID('Customers'), NULL, NULL, 'DETAILED')

USE Northwind
CREATE TABLE LockingTest (
id int identity,
Zeugs varchar(10) )

ALTER TABLE LockingTest
ADD PRIMARY KEY(ID)


INSERT INTO LockingTest
VALUES ('abc')
GO 10000

BEGIN TRAN
SELECT @@TRANCOUNT
UPDATE LockingTest
SET Zeugs = 'xyz'
WHERE ID < 9800

ROLLBACK
--sog. LOCK ESCALATION hebt bspw Row Lock auf Table Lock an

--Mehr als ein Update in eine Transaction packen:

CREATE TABLE Accounts (
ID int identity PRIMARY KEY,
email varchar(50),
Balance decimal(20,2) )

--DROP TABLE Transactions
CREATE TABLE Transactions (
ID int identity PRIMARY KEY,
Datum datetime,
Account_ID_Emp int,
Account_ID_Abs int,
Summe decimal(20,2) )


INSERT INTO Accounts
VALUES ('test@test', 100), ('test2@test2', 50)

SELECT * FROM Accounts
SELECT * FROM Transactions
GO


ALTER PROCEDURE sp_Überweisungen @Summe decimal(20,2), @Empfänger int, @Absender int
AS

BEGIN TRAN
BEGIN TRY
INSERT INTO Transactions
VALUES (getdate(), @Empfänger, @Absender, @Summe)

UPDATE Accounts
SET Balance += @Summe
WHERE ID = @Empfänger

UPDATE Accounts
SET Balance -= @Summe
WHERE ID = @Absender

COMMIT
END TRY
BEGIN CATCH
RAISERROR (50001,1,1)
ROLLBACK
END CATCH

EXEC sp_Überweisungen 201, 2, 1

SELECT @@TRANCOUNT

ALTER TABLE Accounts
ADD CONSTRAINT c_AccountBalance CHECK (Balance >= 0)

--Problem: es wird alles commited was fehlerfrei gelaufen ist

--Idee: Error Handling einbauen mit TRY CATCH THROW/RAISERROR

--Try und catch immer als "Paar"; 

BEGIN TRY
SELECT * FROM Accounts
WHERE id = 3
END TRY

BEGIN CATCH

--Severity 11 - 18 "critical error": beendet das Skript; <11 wirft Fehler aber lässt weiterlaufen
THROW 50001, 'Error entdeckt', 3 --Severity IMMER 16
RAISERROR (50003, 25, 1 ) WITH Log --Severity >18 nur mit WITH log --> kommt in Logfile

END CATCH

SELECT * FROM sys.messages

EXEC sp_addmessage 50003, 10, 'Custom Message', 'Us_English'
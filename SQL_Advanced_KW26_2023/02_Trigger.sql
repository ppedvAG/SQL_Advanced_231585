/*
Es gibt Datenbanktrigger und Tabletrigger

2 Arten von Triggern, DDL & DML

Werden ausgelöst wenn das jeweilige Statement auf der DB oder eben auf der Tabelle abgefeuert wird

Die Triggerkondition muss mindestens 1 Statement umfassen
Was der Trigger macht, kann quasi alles sein

Trigger werden vom User ausgeführt der den Trigger auslöst (Rechte beachten!)

*/

--DML Trigger auf Table:
CREATE TRIGGER tg_AccountsUpdate ON Transactions
AFTER INSERT --INSTEAD OF oder FOR
AS
DECLARE @Summe decimal(20,2), @Empfänger int, @Absender int
--SET @Summe = (SELECT Summe FROM inserted)
SELECT @Summe = Summe , @Empfänger = Account_ID_Emp, @Absender = Account_ID_Abs FROM inserted

UPDATE Accounts
SET Balance += @Summe
WHERE ID = @Empfänger

UPDATE Accounts
SET Balance -= @Summe
WHERE ID = @Absender

/*
INSERT INTO Transactions
VALUES (getdate(), @Empfänger, @Absender, @Summe)
*/

CREATE PROCEDURE sp_Überweisungen2 @Summe decimal(20,2), @Empfänger int, @Absender int
AS

BEGIN TRAN
BEGIN TRY
INSERT INTO Transactions
VALUES (getdate(), @Empfänger, @Absender, @Summe)

COMMIT
END TRY
BEGIN CATCH
RAISERROR (50001,1,1)
ROLLBACK
END CATCH

EXEC sp_Überweisungen2 100, 1, 2

SELECT * FROM Accounts
SELECT * FROM Transactions

INSERT INTO Transactions
VALUES (getdate(), 1, 2, 50),
(getdate(), 1, 2, 100) --Problem: 2 Datensätze, aber nur 1 INSERT, daher Trigger nur für letzten Datensatz ausgelöst


INSERT INTO Transactions
VALUES (getdate(), 1, 2, 50)
INSERT INTO Transactions
VALUES (getdate(), 1, 2, 100)


--Trigger können enabled oder disabled werden

DISABLE TRIGGER tg_AccountsUPDATE ON Transactions
ENABLE TRIGGER tg_AccountsUPDATE ON Transactions


CREATE TRIGGER trg_DeleteBlock ON Transactions
INSTEAD OF DELETE
AS
SELECT 'NIX LÖSCHEN!'


DELETE FROM Transactions
WHERE ID = 4

CREATE TRIGGER trg_Transactions50 ON Transactions
INSTEAD OF INSERT
AS
DECLARE @Summe decimal(20,2), @Empfänger int, @Absender int
--SET @Summe = (SELECT Summe FROM inserted)
SELECT @Summe = Summe , @Empfänger = Account_ID_Emp, @Absender = Account_ID_Abs FROM inserted
INSERT INTO Transactions
VALUES (getdate(), @Empfänger, @Absender, @Summe + 50)

EXEC sp_Überweisungen2 50, 1, 2



--DDL Trigger:
ALTER TRIGGER trg_DropTable ON DATABASE
FOR ALTER_TABLE
AS
SELECT 'stop'


ALTER TABLE Customers
ADD neuespalte varchar(50)

SELECT * FROM Customers


--INSTEAD OF bei DDL?
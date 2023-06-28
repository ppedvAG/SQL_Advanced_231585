--Trigger der Inserts "sammelt" und zu späterem Zeitpunkt alle durchführt

--WAITFOR:

WAITFOR DELAY '00:00:05' --wartet X sek/min/stunden

WAITFOR TIME '15:30:00' --wartet bis Uhrzeit x 

SELECT 'habe gewartet'


CREATE TRIGGER
INSTEAD OF INSERT
AS

IF OBJECT_ID(##temp) IS NULL
SELECT * INTO ##temp
ELSE 
INSERT INTO ##temp


CREATE PROC ggg
AS
WAITFOR TIME '00 UHR'
DISABLE TRIGGER 
INSERT INTO tt
SELECT * FROM ##temp
ENABLE TRIGGER


SELECT * FROM sys.dm_tran_active_transactions
SELECT * FROM sys.dm_tran_locks
WHERE resource_type != 'DATABASE'

BEGIN TRAN

UPDATE Customers
SET Country = 'GGG'

ROLLBACK

EXEC sp_WHO2
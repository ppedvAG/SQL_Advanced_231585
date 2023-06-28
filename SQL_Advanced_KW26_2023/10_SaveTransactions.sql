--Transactions können Savepoints/Checkpoints haben

BEGIN TRANSACTION

SAVE TRANSACTION Checkpoint1
UPDATE Customers
SET City = 'Berlin'
WHERE Country = 'Germany'

SAVE TRANSACTION Checkpoint2
UPDATE Customers
SET City = 'Paris'
WHERE Country = 'France'

SAVE TRANSACTION Checkpoint3
UPDATE Customers
SET City = 'Madrid'
WHERE Country = 'Spain'


SELECT @@TRANCOUNT
ROLLBACK TRANSACTION Checkpoint3
COMMIT
SELECT * FROM Customers
WHERE Country IN ('Germany', 'France', 'Spain')
ORDER BY Country

--Einzelne Checkpoints können "gerollbacked" werden, alles was "danach" passiert ist, wurde rollbacked
--ROLLBACK TRANSACTION Checkpointxy verlässt NICHT die gesamte Transaction
--Erst ROLLBACK oder COMMIT verlassen das Transactionlevel
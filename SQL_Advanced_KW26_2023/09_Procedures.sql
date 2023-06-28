/*
Procedures können "ihr Ergebnis" in einer Variable ablegen und diese mit RETURN @Variable ausgeben
*/

CREATE PROC sp_Check @CustomerID varchar(10) 
AS
DECLARE @Output bit
IF
(SELECT Fax FROM Customers WHERE CustomerID = @CustomerID) IS NULL
SET @Output = 0
ELSE SET @Output = 1
RETURN @Output

--EXEC sp_Check ALFKI

--Um das Ergebnis weiter zu verwenden, rufen wir die Procedure auf und speichern deren RETURN Wert in einer neuen Variable:

DECLARE @return bit
EXEC @return = sp_Check
	@CustomerID = ALFKI
SELECT
CASE WHEN @return = 1 THEN 'Es gibt eine Faxnummer'
ELSE 'Es gibt keine Faxnummer'
END

--SELECT CustomerID, FAX FROM Customers


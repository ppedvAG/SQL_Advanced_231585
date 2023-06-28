SELECT SOUNDEX('Sonnenuhr') --erstellt einen String-Code anhand der Semantik der Wörter

SELECT DIFFERENCE('Sonne', 'Sonnenuhr') --Vergleicht die String-Codes (Soundex) und gibt einen int Wert von 1 bis 4 aus

SELECT DIFFERENCE('Sonne', 'Tonne') --4 = exakt gleich, 1 = kaum Ähnlichkeit

SELECT DIFFERENCE('kkk', 'Dienstfahrzeug')

--BeispieL: Strings dynamisch "zensieren":
SELECT Phone FROM Customers
SELECT STUFF(Phone, 5, LEN(Phone) - 4, REPLICATE('X', LEN(Phone) - 5)) FROM Customers

--nimmt Teil eines Strings
SELECT SUBSTRING(Companyname, 5, 5), CompanyName FROM Customers

--Ersetzt Teil eines Strings
SELECT REPLACE()

--PATINDEX verwendet LIKE-Schema und sucht nach diesem Schema in einem String; Erste gefundene Position wird als Ergebnis ausgegeben:
SELECT PATINDEX('%F%', Companyname), Companyname FROM Customers

SELECT Address FROM Customers

SELECT PATINDEX('%[0-9]%', Address) FROM Customers


--Straße von Hausnummer trennen in einer Spalte: (nicht vollständig, nur Ansatz)
SELECT SUBSTRING(Address, PATINDEX('%[0-9]%', Address), 
LEN(Address) - PATINDEX('%[0-9]%', Address)) FROM customers

SELECT LEFT(Address, LEN(Address) - PATINDEX('%[0-9]%', Address)) as Teil1,
RIGHT(Address, LEN(Address) - PATINDEX('%[0-9]%', Address)) as Teil2
FROM Customers

--ähnlich wie COALESCE:
SELECT ISNULL(Fax, 'n/a') FROM Customers

--Vergleicht Werte und returned NULL falls identisch:
SELECT NULLIF(1, 1), NULLIF(1, 0), NULLIF(5, 0)

--FORMAT für Datum, Währungen, Zahlen etc. (siehe MS Doku für vollständige Liste an möglichen Argumenten)_
SELECT CAST(FORMAT(OrderDate, 'dd.MM.yyyy') as date) FROM orders
--FORMAT Ausgabe immer als String!


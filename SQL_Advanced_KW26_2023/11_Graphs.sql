--Graph Tables: Bestehen aus Nodes (Entitäten) und Edges (Beziehungen)


CREATE TABLE Kunden (
KundenID int identity,
LastName varchar(50),
StadtID int)
AS NODE --NODE Table erstellen

CREATE TABLE Stadt (
StadtID int identity,
[Name] varchar(50) )
AS NODE

CREATE TABLE WohnenIn AS EDGE --EDGE Table erstellen

INSERT INTO Kunden --Nodes werden ganz normal befüllt
VALUES 
('Meier', 1),
('Huber', 2)

INSERT INTO Stadt
VALUES 
('München'),
('Berlin')

SELECT * FROM Stadt

INSERT INTO WohnenIn --In Edges werden die Beziehungen zwischen Datensätzen der zugehörigen Nodes angelegt
VALUES
(
(SELECT $node_id FROM Kunden WHERE KundenID = 1),
(SELECT $node_id FROM Stadt WHERE StadtID = 1)
),
(
(SELECT $node_id FROM Kunden WHERE KundenID = 2),
(SELECT $node_id FROM Stadt WHERE StadtID = 2)
)

SELECT * FROM WohnenIn

SELECT Kunden.KundenID, Kunden.LastName, Stadt.StadtID, Name FROM Kunden, WohnenIn, Stadt
WHERE MATCH (Kunden-(WohnenIn)->Stadt) 

CREATE TABLE Restaurants (
RestID int identity PRIMARY KEY NOT NULL,
[Name] varchar(50) NOT NULL,
)
AS NODE

CREATE TABLE Food (
ProdID int identity PRIMARY KEY NOT NULL,
Product varchar(50) NOT NULL,
Price decimal(5,2)
)
AS NODE

INSERT INTO Restaurants 
VALUES ('Rajmahal'),
('Gustl´s Hendlgrill'),
('Ristorante Sole'),
('The Sandwich Place')

INSERT INTO Food
VALUES ('Chicken Goa', 14.50),
('Halbes Hendl', 10.50),
('Pizza Regina', 11.00),
('Spaghetti Carbonara', 9.50),
('Penne Napoli', 9.00),
('Pommes groß', 5.00),
('Pommes klein', 3.50),
('Lamm Vindaloo', 15.50),
('Nam Brot', 2.00),
('Schweinshaxn', 14.00),
('Pulled Pork', 7.50)

CREATE TABLE Offered AS EDGE

INSERT INTO Offered -- Produkte zu Restaurants
VALUES
(
(SELECT $node_id FROM Restaurants WHERE RestID = 1),
(SELECT $node_id FROM Food WHERE ProdID = 1)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 1),
(SELECT $node_id FROM Food WHERE ProdID = 8)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 1),
(SELECT $node_id FROM Food WHERE ProdID = 9)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 2),
(SELECT $node_id FROM Food WHERE ProdID = 2)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 2),
(SELECT $node_id FROM Food WHERE ProdID = 6)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 2),
(SELECT $node_id FROM Food WHERE ProdID = 7)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 2),
(SELECT $node_id FROM Food WHERE ProdID = 10)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 3),
(SELECT $node_id FROM Food WHERE ProdID = 3)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 3),
(SELECT $node_id FROM Food WHERE ProdID = 4)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 3),
(SELECT $node_id FROM Food WHERE ProdID = 5)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 4),
(SELECT $node_id FROM Food WHERE ProdID = 11)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 4),
(SELECT $node_id FROM Food WHERE ProdID = 6)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 4),
(SELECT $node_id FROM Food WHERE ProdID = 7)
)

CREATE TABLE AngesiedeltIn AS EDGE

INSERT INTO AngesiedeltIn -- Produkte zu Restaurants
VALUES
(
(SELECT $node_id FROM Restaurants WHERE RestID = 1),
(SELECT $node_id FROM Stadt WHERE StadtId = 1)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 2),
(SELECT $node_id FROM Stadt WHERE StadtId = 1)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 3),
(SELECT $node_id FROM Stadt WHERE StadtId = 2)
),
(
(SELECT $node_id FROM Restaurants WHERE RestID = 4),
(SELECT $node_id FROM Stadt WHERE StadtId = 2)
)


--Ohne WHERE MATCH wird quasi ein CROSS JOIN der angesprochenen Tabellen gemacht

SELECT RestID, Name, ProdID, Product, Price FROM Restaurants, Offered, Food
WHERE MATCH (Restaurants-(Offered)->Food)

SELECT Restaurants.Name, Stadt.Name FROM Restaurants, Offered, Food, AngesiedeltIn, Stadt, WohnenIn, Kunden
WHERE MATCH (Food<-(Offered)-Restaurants-(AngesiedeltIn)->Stadt<-(WohnenIn)-Kunden)
AND ProdID = 6 AND Distanz < 10


--Siehe Shortest Path Function
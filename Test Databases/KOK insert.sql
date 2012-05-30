/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     11-5-2012 10:57:45							*/
/* Author:			Joppe Catsburg		                        */
/*==============================================================*/

--DELETE FROM medewerkerrol
--DELETE FROM medewerker
--DELETE FROM rol
--DELETE FROM standaarddagmenuproduct
--DELETE FROM standaarddagmenu
--DELETE FROM dagmenuproduct
--DELETE FROM dagmenu
--DELETE FROM productsamenstelling
--DELETE FROM artikel
--DELETE FROM productdieetcategorie
--DELETE FROM product
--DELETE FROM artikeleenheid
--DELETE FROM dieetcategorie
--DELETE FROM productcategorie
--DELETE FROM restaurant
--DELETE FROM plaats
--DELETE FROM bestelstatus
--DELETE FROM bestelling
--DELETE FROM bestellingproduct
--DELETE FROM eetvoorkeur 
--DELETE FROM eetvoorkeurproduct 
--GO

INSERT INTO plaats VALUES
('Utrecht'),
('Veenendaal');

GO

INSERT INTO restaurant VALUES
(1221, 'Utrecht'),
(1331, 'Veenendaal'),
(1441, 'Veenendaal');

GO

INSERT INTO productcategorie VALUES
('Vlees'),
('Salade'),
('Aardappelproducten'),
('Frituursnacks'),
('Belegde Broodjes');

GO

INSERT INTO dieetcategorie VALUES
('Vegetarisch'),
('Glutenvrij'),
('Suikervrij');

GO

INSERT INTO artikeleenheid VALUES
('Gram'),
('Stuk(s)'),
('Milliliter');

GO

INSERT INTO product VALUES
(1221, 'Kroket', NULL, 'Frituursnacks', 1.00, 1),
(1221, 'Broodje Kroket', NULL, 'Frituursnacks', 1.50, 1),
(1221, 'Frites', 'Portie frites', 'Aardappelproducten', 1.00, 0),
(1221, 'Broodje Kaas (Jong Belegen)', 'Zacht bolletje met plakjes kaas', 'Belegde Broodjes', 1.00, 1),
(1331, 'Kroket', 'Krokante frituursnack met heerlijk zachte vulling', 'Frituursnacks', 1.20, 1),
(1331, 'Frikandel', NULL, 'Frituursnacks', 1.20, 1),
(1331, 'Broodje Kipkerrie', 'Zachte witte bol met kipkerriesalade', 'Belegde Broodjes', 1.50, 1),
(1441, 'Caesar Salad', 'De beroemde caesar salad..', 'Salade', 3.00, 0),
(1441, 'Aardappelkroketjes', 'Portie krokante kroketjes gevuld met aardappelpuree', 'Aardappelproducten', 2.00, 1);

GO

INSERT INTO productdieetcategorie VALUES
(1441, 'Caesar Salad', 'Vegetarisch');

GO

INSERT INTO artikel VALUES
(1331, 'Kroket Van Dobben 200gr', 100, 'Stuk(s)',25),
(1331, 'Frikandel', 80, 'Stuk(s)',25),
(1331, 'Witte Bol', 50, 'Stuk(s)',25),
(1331, 'Kipkerrie Salade', 2000, 'Gram',25),
(1441, 'Aardappelkroketjes', 3000, 'Gram',25),
(1441, 'Parmezaanse kaas', 2000, 'Gram',25),
(1441, 'Croutons', 2000, 'Gram',25),
(1441, 'Sla', 2000, 'Gram',25),
(1221, 'Kroket', 100, 'Stuk(s)',25),
(1221, 'Witte Bol', 200, 'Stuk(s)',25),
(1221, 'Kaas voorgesneden plakken (Belegen)', 200, 'Stuk(s)',25),
(1221, 'Frites', 20000, 'Gram',25);

GO

INSERT INTO productsamenstelling VALUES
(1221, 'Kroket', 1221, 'Kroket', 1),
(1221, 'Broodje Kroket', 1221, 'Kroket', 1),
(1221, 'Broodje Kroket', 1221, 'Witte Bol', 1),
(1221, 'Frites', 1221, 'Frites', 200),
(1221, 'Broodje Kaas (Jong Belegen)', 1221, 'Witte Bol', 1),
(1221, 'Broodje Kaas (Jong Belegen)', 1221, 'Kaas voorgesneden plakken (Belegen)', 2),
(1331, 'Kroket', 1331, 'Kroket Van Dobben 200gr', 1),
(1331, 'Frikandel', 1331, 'Frikandel', 1),
(1331, 'Broodje Kipkerrie', 1331, 'Witte Bol', 1),
(1331, 'Broodje Kipkerrie', 1331, 'Kipkerrie Salade', 50),
(1441, 'Caesar Salad', 1441, 'Parmezaanse kaas', 30),
(1441, 'Caesar Salad', 1441, 'Sla', 200),
(1441, 'Caesar Salad', 1441, 'Croutons', 40),
(1441, 'Aardappelkroketjes', 1441, 'Aardappelkroketjes', 200);

GO

INSERT INTO dagmenu VALUES
(1221, '2012-6-20'),
(1441, '2012-6-17');

GO

INSERT INTO dagmenuproduct VALUES
(1221, '2012-6-20', 1221, 'Broodje Kroket'),
(1221, '2012-6-20', 1221, 'Frites'),
(1441, '2012-6-17', 1441, 'Caesar Salad'),
(1441, '2012-6-17', 1441, 'Aardappelkroketjes');

GO

INSERT INTO standaarddagmenu VALUES
(1331, 'Vette Hapdag');

GO

INSERT INTO standaarddagmenuproduct VALUES
(1331, 'Vette Hapdag', 1331, 'Frikandel'),
(1331, 'Vette Hapdag', 1331, 'Kroket');

GO

SET IDENTITY_INSERT medewerker ON

GO

INSERT INTO medewerker (medewerkerid, username, voornaam, tussenvoegsel, achternaam) VALUES 
(1, 'mw1', 'Joppe', NULL, 'Catsburg'),
(2, 'mw2', 'Ramses', NULL, 'Shaffy'),
(3, 'mw3', 'Gordon', NULL, 'Ramsey'),
(4, 'mw4', 'Klaus', NULL, 'Barbie'),
(5, 'mw5', 'Anthony', NULL, 'Hopkins'),
(6, 'mw6', 'Remy', NULL, 'Hansen');

GO

SET IDENTITY_INSERT medewerker OFF

GO

INSERT INTO rol VALUES
('Kok'),
('Medewerker'),
('Voorraadbeheerder'),
('Restaurantmanager'),
('Leverancierbeheerder'),
('Kassamedewerker'),
('Directie');

GO

INSERT INTO medewerkerrol VALUES
(1, 'Medewerker', 1221),
(1, 'Medewerker', 1441),
(2, 'Kok', 1221),
(3, 'Kok', 1441),
(3, 'Voorraadbeheerder', 1441),
(4, 'Restaurantmanager', 1221),
(5, 'Directie', 1221),
(6, 'Medewerker', 1331);

GO

INSERT INTO bestelstatus VALUES
('Besteld'),
('Gereed'),
('Voldaan');

GO

INSERT INTO bestelling (restaurantnummer, medewerkerid, statusnaam, momentvanplaatsing, gewenstafnamemoment, isbezorging, bezorglocatie)VALUES   
(1221,1,NULL, NULL,'2012-6-20 13:00','FALSE',null),
(1221,6,NULL, NULL,'2012-6-20 12:00','FALSE',null),
(1221,6,NULL, NULL,'2012-6-20 12:30','FALSE',null),
(1221,1,NULL, NULL,'2012-6-20 12:00','FALSE',null),
(1221,1,NULL, NULL,'2012-6-20 12:30','FALSE',null),
(1221,6,NULL, NULL,'2012-6-20 12:30','TRUE','lokaal D106'),
(1441,1,NULL, NULL,'2012-6-21 12:45','FALSE',null);

GO
INSERT INTO bestellingproduct VALUES
(1, 1221,'Broodje Kroket', NULL, 1),
(1, 1221,'Kroket', NULL, 1),
(2, 1221,'Broodje Kroket', NULL, 2),
(2, 1221,'Kroket', NULL, 1),
(3, 1221,'Broodje Kroket', NULL, 2),
(4, 1221,'Broodje Kroket', NULL, 1),
(5, 1221,'Broodje Kroket', NULL, 2),
(6, 1221,'Broodje Kroket', NULL, 25),
(7, 1441,'Aardappelkroketjes', NULL, 5);

GO
INSERT INTO eetvoorkeur VALUES
(1, '2012-6-20',1221),
(1, '2012-6-17',1441),
(6, '2012-6-20',1221);

GO
INSERT INTO eetvoorkeurproduct VALUES
('2012-6-20',1,1221,'Broodje Kroket'),
('2012-6-17',1,1441,'Caesar Salad'),
('2012-6-20',6,1221,'Frites');

GO
INSERT INTO kassaverkoop (restaurantnummer, medewerkerid, dag) VALUES
(1221,1,'2012-05-23T14:25:10'),
(1221,1,'2012-05-23T16:55:12'),
(1221,1,'2012-05-24T09:37:15'),
(1221,1,'2012-05-24T12:20:00'),
(1221,2,'2012-05-24T12:22:00');

GO
INSERT INTO kassaverkoopproduct VALUES
(1,1221,'Broodje Kroket',2.50,2),
(1,1221,'Frites',1.50,1),
(2,1221,'Broodje Kroket',2.25,1),
(3,1221,'Broodje Kroket',2.50,2),
(4,1221,'Kroket',2.50,1),
(5,1221,'Broodje Kroket',2.50,5);

GO
INSERT INTO kassaverkoop_historie VALUES
(999,1221,2,'2011-05-23T14:25:10'),
(998,1221,2,'2011-05-23T16:55:12'),
(997,1221,2,'2011-05-24T09:37:15'),
(996,1221,2,'2011-05-24T12:20:00'),
(995,1221,1,'2011-05-24T12:22:00');

GO
INSERT INTO kassaverkoopproduct_historie VALUES
(999,1221,'Broodje Kroket',1.50,2),
(999,1221,'Frites',0.50,1),
(998,1221,'Broodje Kroket',1.25,1),
(997,1221,'Broodje Kroket',1.50,2),
(996,1221,'Kroket',1.50,1),
(995,1221,'Broodje Kroket',1.50,5);

INSERT INTO bestelling_historie VALUES   
(999,1221,2,'voldaan', '2012-6-18 13:00','2012-6-19 13:00','FALSE',null),
(998,1221,2,'voldaan', '2012-6-18 12:00','2012-6-19 12:00','FALSE',null),
(997,1221,1,'voldaan', '2012-6-17 12:30','2012-6-19 12:30','FALSE',null);

GO
INSERT INTO bestellingproduct_historie VALUES
(999, 1221,'Broodje Kroket', 1.50, 3),
(999, 1221,'Kroket', 0.75, 3),
(998, 1221,'Broodje Kroket', 1.50, 2),
(998, 1221,'Kroket', 0.75, 2),
(997, 1221,'Broodje Kroket', 1.50, 5),
(997, 1221,'Kroket', 0.75, 5),
(997, 1221,'Frites', 1.75, 10);



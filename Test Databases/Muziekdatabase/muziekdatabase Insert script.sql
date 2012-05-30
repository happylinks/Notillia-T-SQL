-- COPYRIGHT HAN

/* Relationele databases en SQL

   Insert-script voor database Muziekscholen
   SQL Server 2008
*/
use muziekdatabase
go
DELETE FROM Bezettingsregel;
DELETE FROM Instrument;
UPDATE Stuk SET stuknrOrigineel = NULL;
DELETE FROM Stuk;
DELETE FROM Genre;
DELETE FROM Niveau;
DELETE FROM Componist;
DELETE FROM Muziekschool;

INSERT INTO Muziekschool VALUES (1, 'Muziekschool Amsterdam',   'Amsterdam');
INSERT INTO Muziekschool VALUES (2, 'Reijnders'' Muziekschool', 'Nijmegen');
INSERT INTO Muziekschool VALUES (3, 'Het Muziekpakhuis',        'Amsterdam');

INSERT INTO Componist VALUES ( 1, 'Charlie Parker', '12-dec-1904', NULL);
INSERT INTO Componist VALUES ( 2, 'Thom Guidi',     '05-jan-1946', 1);
INSERT INTO Componist VALUES ( 4, 'Rudolf Escher',  '08-jan-1912', NULL);
INSERT INTO Componist VALUES ( 5, 'Sofie Bergeijk', '12-jul-1960', 2);
INSERT INTO Componist VALUES ( 8, 'W.A. Mozart',    '27-jan-1756', NULL);
INSERT INTO Componist VALUES ( 9, 'Karl Schumann',  '10-oct-1935', 2);
INSERT INTO Componist VALUES (10, 'Jan van Maanen', '08-sep-1965', 1);

INSERT INTO Genre VALUES ('klassiek');
INSERT INTO Genre VALUES ('jazz');
INSERT INTO Genre VALUES ('pop');
INSERT INTO Genre VALUES ('techno');

INSERT INTO Niveau VALUES ('A', 'beginners');
INSERT INTO Niveau VALUES ('B', 'gevorderden');
INSERT INTO Niveau VALUES ('C', 'vergevorderden');

INSERT INTO Stuk VALUES ( 1,  1, 'Blue bird',       NULL, 'jazz',     NULL, 4.5,  1954);
INSERT INTO Stuk VALUES ( 2,  2, 'Blue bird',       1,    'jazz',     'B',  4,    1988);
INSERT INTO Stuk VALUES ( 3,  4, 'Air pur charmer', NULL, 'klassiek', 'B',  4.5,  1953);
INSERT INTO Stuk VALUES ( 5,  5, 'Lina',            NULL, 'klassiek', 'B',  5,    1979);
INSERT INTO Stuk VALUES ( 8,  8, 'Berceuse',        NULL, 'klassiek', NULL, 4,    1786);
INSERT INTO Stuk VALUES ( 9,  2, 'Cradle song',     8,    'klassiek', 'B',  3.5,  1990);
INSERT INTO Stuk VALUES (10,  8, 'Non piu andrai',  NULL, 'klassiek', NULL, NULL, 1791);
INSERT INTO Stuk VALUES (12,  9, 'I''ll never go',  10,   'pop',      'A',  6,    1996);
INSERT INTO Stuk VALUES (13, 10, 'Swinging Lina',   5,    'jazz',     'B',  8,    1997);
INSERT INTO Stuk VALUES (14,  5, 'Little Lina',     5,    'klassiek', 'A',  4.3,  1998);
INSERT INTO Stuk VALUES (15, 10, 'Blue sky',        1,    'jazz',     'A',  4,    1998);

/* Opmerking:
   Een enkel aanhalingsteken binnen string (zoals in muziekschool 2 en stuk 12) moet
   twee keer worden genoteerd; anders wordt het opgevat als einde-string teken.
*/

INSERT INTO Instrument VALUES ('piano',    ''       );
INSERT INTO Instrument VALUES ('fluit',    ''       );
INSERT INTO Instrument VALUES ('fluit',    'alt'    );
INSERT INTO Instrument VALUES ('saxofoon', 'alt'    );
INSERT INTO Instrument VALUES ('saxofoon', 'tenor'  );
INSERT INTO Instrument VALUES ('saxofoon', 'sopraan');
INSERT INTO Instrument VALUES ('gitaar',   ''       );
INSERT INTO Instrument VALUES ('viool',    ''       );
INSERT INTO Instrument VALUES ('viool',    'alt'    );
INSERT INTO Instrument VALUES ('drums',    ''       );

INSERT INTO Bezettingsregel VALUES ( 2, 'drums',    '',      1);
INSERT INTO Bezettingsregel VALUES ( 2, 'saxofoon', 'alt',   2);
INSERT INTO Bezettingsregel VALUES ( 2, 'saxofoon', 'tenor', 1);
INSERT INTO Bezettingsregel VALUES ( 2, 'piano',    '',      1);
INSERT INTO Bezettingsregel VALUES ( 3, 'fluit',    '',      1);
INSERT INTO Bezettingsregel VALUES ( 5, 'fluit',    '',      3);
INSERT INTO Bezettingsregel VALUES ( 9, 'fluit',    '',      1);
INSERT INTO Bezettingsregel VALUES ( 9, 'fluit',    'alt',   1);
INSERT INTO Bezettingsregel VALUES ( 9, 'piano',    '',      1);
INSERT INTO Bezettingsregel VALUES (12, 'piano',    '',      1);
INSERT INTO Bezettingsregel VALUES (12, 'fluit',    '',      2);
INSERT INTO Bezettingsregel VALUES (13, 'drums',    '',      1);
INSERT INTO Bezettingsregel VALUES (13, 'saxofoon', 'alt',   1);
INSERT INTO Bezettingsregel VALUES (13, 'saxofoon', 'tenor', 1);
INSERT INTO Bezettingsregel VALUES (13, 'fluit',    '',      2);
INSERT INTO Bezettingsregel VALUES (14, 'piano',    '',      1);
INSERT INTO Bezettingsregel VALUES (14, 'fluit',    '',      1);
INSERT INTO Bezettingsregel VALUES (15, 'saxofoon', 'alt',   2);
INSERT INTO Bezettingsregel VALUES (15, 'fluit',    'alt',   2);
INSERT INTO Bezettingsregel VALUES (15, 'piano',    '',      1);


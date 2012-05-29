CREATE SCHEMA Notillia; 
GO

--Domain(s):
CREATE VIEW Notillia.[Domains] AS
SELECT d.DOMAIN_CATALOG AS 'Database', d.DOMAIN_SCHEMA AS 'Schema', d.DOMAIN_NAME AS 'Domain_Name', d.DATA_TYPE AS 'Data_Type', 
	   d.CHARACTER_MAXIMUM_LENGTH AS 'Character_Maximum_Length', d.CHARACTER_OCTET_LENGTH AS 'Character_Octet_Length', 
	   d.NUMERIC_PRECISION AS 'Numeric_Precision', d.NUMERIC_PRECISION_RADIX AS 'Numeric_Precision_Radix', 
	   d.NUMERIC_SCALE AS 'Numeric_Scale', d.DATETIME_PRECISION 'Datetime_Precision', d.DOMAIN_DEFAULT AS 'Domain_Default'
FROM INFORMATION_SCHEMA.DOMAINS d
WHERE d.DOMAIN_SCHEMA != 'Notillia';
GO

CREATE TYPE Email FROM VARCHAR(128) NOT NULL;
GO

SELECT * FROM Notillia.Domains;
GO

--Table(s) && View(s):
CREATE VIEW Notillia.Tables AS 
SELECT t.TABLE_CATALOG AS 'Database', t.TABLE_SCHEMA AS 'Schema', t.TABLE_NAME AS 'Table_Name'
FROM INFORMATION_SCHEMA.TABLES t
WHERE t.TABLE_TYPE = 'BASE TABLE' AND t.TABLE_SCHEMA != 'Notillia' AND t.TABLE_NAME != 'sysdiagrams';
GO

CREATE VIEW Notillia.Views AS
SELECT v.TABLE_CATALOG AS 'Database', v.TABLE_SCHEMA AS 'Schema', v.TABLE_NAME AS 'View_Name'
FROM INFORMATION_SCHEMA.TABLES v
WHERE v.TABLE_TYPE = 'VIEW' AND v.TABLE_SCHEMA != 'Notillia' AND v.TABLE_NAME != 'sysdiagrams';
GO

SELECT * FROM Notillia.Tables;
SELECT * FROM Notillia.Views;
GO

--Column(s):
CREATE VIEW Notillia.Columns AS
SELECT c.TABLE_CATALOG AS 'Database', c.TABLE_SCHEMA AS 'Schema', c.TABLE_NAME AS 'Table_Name', 
	   c.COLUMN_NAME AS 'Column_Name', c.ORDINAL_POSITION AS 'Ordinal_Position', c.COLUMN_DEFAULT AS 'Column_Default', 
	   c.IS_NULLABLE AS 'IS_NULLable', c.DATA_TYPE AS 'Data_Type', c.CHARACTER_MAXIMUM_LENGTH AS 'Character_Maximum_Length', 
	   c.CHARACTER_OCTET_LENGTH AS 'Character_Octec_Length', c.NUMERIC_PRECISION AS 'Numeric_Precision',
	   c.NUMERIC_PRECISION_RADIX AS 'Numeric_Precision_Radix', c.NUMERIC_SCALE AS 'Numeric_Scale', 
	   c.DATETIME_PRECISION AS 'DateTime_Precision', DOMAIN_CATALOG AS 'Domain_Catalog', c.DOMAIN_SCHEMA AS 'Domain_Schema', 
	   c.DOMAIN_NAME AS 'Domain_Name'
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_SCHEMA != 'Notillia' AND c.TABLE_NAME != 'sysdiagrams';
GO

SELECT * FROM Notillia.Columns;
GO

--Constraint(s)
CREATE VIEW Notillia.PrimaryKeys AS
SELECT c.CONSTRAINT_CATALOG AS 'Database', c.CONSTRAINT_SCHEMA AS 'Schema', c.CONSTRAINT_NAME AS 'Constraint_Name', 
       c.TABLE_NAME AS 'Table_Name'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS c
WHERE c.CONSTRAINT_SCHEMA != 'Notillia' AND c.TABLE_SCHEMA != 'Notillia' AND 
	  c.CONSTRAINT_TYPE = 'PRIMARY KEY' AND c.CONSTRAINT_SCHEMA = c.TABLE_SCHEMA AND
	  c.CONSTRAINT_CATALOG = c.TABLE_CATALOG AND c.TABLE_NAME != 'sysdiagrams';
GO

CREATE VIEW Notillia.Uniques AS
SELECT c.CONSTRAINT_CATALOG AS 'Database', c.CONSTRAINT_SCHEMA AS 'Schema', c.CONSTRAINT_NAME AS 'Constraint_Name', 
	   c.TABLE_NAME AS 'Table_Name'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS c
WHERE c.CONSTRAINT_SCHEMA != 'Notillia' AND c.TABLE_SCHEMA != 'Notillia' AND 
	  c.CONSTRAINT_TYPE = 'UNIQUE' AND c.TABLE_NAME != 'sysdiagrams';
GO

CREATE VIEW Notillia.ForeignKeys AS
SELECT c.CONSTRAINT_CATALOG AS 'Database', c.CONSTRAINT_SCHEMA AS 'Schema', pk.TABLE_NAME AS 'Master_Table', 
	   fk.TABLE_NAME AS 'Child_Table', c.CONSTRAINT_NAME AS 'Constraint_Name', 
	   c.UPDATE_RULE AS 'Update_Rule', c.DELETE_RULE AS 'Delete_Rule'
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS c
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS fk ON c.CONSTRAINT_NAME = fk.CONSTRAINT_NAME
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ON c.UNIQUE_CONSTRAINT_NAME = pk.CONSTRAINT_NAME
WHERE c.UNIQUE_CONSTRAINT_SCHEMA != 'Notillia' AND pk.TABLE_NAME != 'sysdiagrams' AND fk.TABLE_NAME != 'sysdiagrams';
GO

SELECT * FROM Notillia.PrimaryKeys;
SELECT * FROM Notillia.Uniques;
SELECT * FROM Notillia.ForeignKeys;
GO

--Constraints Columns
--PK's EN Unique's
CREATE VIEW Notillia.ConstraintColumns AS
SELECT DB_NAME() AS 'Database', s.name AS 'Schema', t.name AS 'Table_Name', i.name AS 'Constraint_Name', ic.column_id, ac.name AS 'Column_Name', ic.index_column_id AS 'Index_Column_Id'
FROM sys.tables t
	INNER JOIN sys.indexes i ON t.object_id = i.object_id
	INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
	INNER JOIN sys.all_columns ac ON t.object_id = ac.object_id and ic.column_id = ac.column_id
	INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.name != 'sysdiagrams' and s.name != 'Notillia' and t.type='u'
--ORDER BY Constraint_Name.name, ic.index_column_id ASC
GO

--FK's
CREATE VIEW Notillia.ForeignKeyColumns AS
SELECT SCHEMA_NAME(fk.schema_id) AS 'Schema', fk.name AS 'Constraint_Name',
	   OBJECT_NAME(fk.parent_object_id) AS 'Child_Table', COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS 'Child_Column', 
	   OBJECT_NAME (fk.referenced_object_id) AS 'Master_Table', COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS 'Master_Column',
	   DB_NAME() AS 'Database'
FROM sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE SCHEMA_NAME(fk.schema_id) != 'Notillia'
GO

SELECT * FROM Notillia.ConstraintColumns;
SELECT * FROM Notillia.ForeignKeyColumns;
GO
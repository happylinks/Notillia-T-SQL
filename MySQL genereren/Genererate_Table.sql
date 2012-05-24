USE muziekdatabase
go
EXEC generateMySql
go

/*==============================================================
MSSQL database to MYSQL DDL script converter 

Views needs to be generated before executing this script
	
@Author Bas van der Zandt & Jeroen Verseput (Foreign Keys)
@Version 1.0										
==============================================================*/

/*==============================================================*/
/* SP: the starting point for generating the MySql script												*/
/*==============================================================*/

ALTER PROC generateMySQL

@outputPath VARCHAR(MAX) = 'C:',
@fileName VARCHAR(MAX) = 'mySql.sql'
AS BEGIN
DECLARE @generated VARCHAR(MAX) = '' ;
DECLARE @outputFolder VARCHAR(128) = 'MySQL';

DECLARE @error BIT = 0 ;

EXEC Notillia.procCreateFolderWithCMD @FolderName = @outputFolder, @Location = @outputPath, @Return = @error OUTPUT
	
 DECLARE @CreateDatabase NVARCHAR(MAX); SET @CreateDatabase = '';
SELECT @CreateDatabase += sub.Clause
FROM (SELECT CASE t.[Schema] WHEN 'dbo' THEN '' ELSE t.[Schema] + '.' END + t.[Database] AS 'Clause' FROM Notillia.Tables t UNION
SELECT CASE v.[Schema] WHEN 'dbo' THEN '' ELSE v.[Schema] + '.' END + v.[Database] AS 'Clause' FROM Notillia.Views v) sub

SET @generated += 'CREATE DATABASE `' +  @CreateDatabase + '`; ' + CHAR(10) + 'USE DATABASE `' + @CreateDatabase + '`;' + CHAR(10)
SET @generated += Notillia.generateCreateTable();
SET @generated += Notillia.createMysqlFkFile();
PRINT @generated

DECLARE @outputFilePath VARCHAR(MAX) = @outputPath + '\' + @outputFolder;

EXECUTE Notillia.procWriteStringToFile @generated, @outputFilePath , @fileName 
   	
 END

GO
/*==============================================================
 UDF: Generate 'create table' statements including the
columns with the correct data types and primary and alternative keys
@return varchar(max) All the create table statements in a long
					String seperated with line breaks
==============================================================*/
CREATE FUNCTION Notillia.generateCreateTable()
RETURNS varchar(MAX)
AS BEGIN
  DECLARE @tableOutput VARCHAR(max)
 
   SET @tableOutput = (SELECT 'CREATE TABLE `' + t.Table_Name + '`( '
    + CHAR(10) + Notillia.getColumnsFromTable(t.Table_Name) + CHAR(10) + Notillia.getTableConstraints(t.table_name) + CHAR(10) + '); ' + CHAR(10)
   FROM Notillia.Tables t 
   FOR XML PATH(''))
   
   RETURN @tableOutput
END    
go

/*==============================================================
 UDF: Generate columns with the correct datatypes from the specified
 table
 @param varchar(max) @tablename The table to get the columns from
 @return varchar(max) the columns with datatypes, seperated by
					comma's in a long string
==============================================================*/
CREATE FUNCTION Notillia.getColumnsFromTable(@tableName VARCHAR(max))
RETURNS VARCHAR(max)
AS BEGIN
   	
DECLARE @output VARCHAR(max);
   	
SET @output = (SELECT ' `' + c.Column_Name + '` ' + notillia.convertDataType(@tablename, c.Column_Name) + ',' + CHAR(10)
FROM Notillia.Columns c
WHERE Table_Name = @tablename
FOR XML PATH(''))

 RETURN @output
 END
 go
 
 /*==============================================================
 UDF:Convert the datatype of the specified column and the specified
 table
 @param varchar(max) @tablename The table of the column
 @param varchar(max) @columnName The column of the table
 @return varchar(max) The converted datatype
==============================================================*/
 ALTER FUNCTION Notillia.convertDataType(@tableName VARCHAR(MAX), @columnName VARCHAR(max))
 RETURNS VARCHAR(max) AS BEGIN
 
 DECLARE @output VARCHAR(max);
 
SET @output = (SELECT CASE Data_type
 WHEN 'varchar' THEN 'VARCHAR' + '(' + CAST(Character_Maximum_Length AS VARCHAR(max)) + ')'
 WHEN 'nvarchar' THEN 'VARCHAR' + '(' + CAST(Character_Maximum_Length AS VARCHAR(max)) + ')' + ' CHARSET utf8' 
 WHEN 'numeric' THEN 'NUMERIC' + '(' + CAST(Numeric_Precision AS VARCHAR(max)) +  ', ' + CAST(numeric_scale AS VARCHAR(max)) + ')'
 WHEN 'char' THEN 'CHAR' + '(' + CAST(Character_Maximum_Length AS VARCHAR(max)) + ')'
 WHEN 'datetime' THEN 'DATETIME'
 ELSE  Data_Type + '-- datatype may not be converted correctly'
 END + Notillia.generateDefaults(@columnName) + CASE IS_NULLABLE WHEN 'NO' THEN ' NOT NULL' ELSE ' NULL' END
 FROM Notillia.COLUMNS 
 WHERE Table_Name = @tableName AND Column_Name = @columnName
 FOR XML PATH(''))

 RETURN @output

 END
 go
 
/*==============================================================
 UDF: get all the columns with a primary key in the specified
 table
 
@param varchar(max) @tableName The table to get the PK's from
@return varchar(max) All the PK columns seperated by comma's
==============================================================*/
CREATE FUNCTION Notillia.getPrimaryKeyColumns(@tablename varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
DECLARE @output VARCHAR(max);

SET @output =(SELECT '`' + c.Column_Name + '`' + ', '
FROM Notillia.ConstraintColumns c INNER JOIN Notillia.PrimaryKeys pk ON c.Constraint_Name = pk.Constraint_Name
WHERE c.Table_Name = @tablename
ORDER BY c.Constraint_Name, index_column_id ASC
FOR XML PATH(''))

RETURN LEFT(@output,LEN(@output) - 1);
   END
   
GO

/*==============================================================
 UDF: Generate primary key constraints for the specified table
 @param varchar(max) @tableName The specified table
 @return varchar(max) The constraint rule for the specified table
==============================================================*/
CREATE FUNCTION Notillia.generatePrimaryKeys(@tableName varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
   DECLARE	@output varchar(MAX)
   
 SET @output =	(SELECT 'CONSTRAINT ' + Constraint_Name + ' PRIMARY KEY (' + notillia.getPrimaryKeyColumns(table_name)  + ')'
FROM Notillia.PrimaryKeys 
WHERE Table_Name = @tableName
FOR XML PATH('')
)
 RETURN @output  	
   END
   
GO

/*==============================================================
 UDF: get all the columns with an alternative key in the specified
 table
 
@param varchar(max) @tableName The table to get the AK's from
@return varchar(max) All the AK columns seperated by comma's
==============================================================*/
CREATE FUNCTION Notillia.getAlternativeKeyColumns(@tablename varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
DECLARE @output VARCHAR(max);

SET @output =(SELECT '`' + c.Column_Name + '`' + ', '
FROM Notillia.ConstraintColumns c INNER JOIN Notillia.Uniques pk ON c.Constraint_Name = pk.Constraint_Name
WHERE c.Table_Name = @tablename
ORDER BY c.Constraint_Name, index_column_id ASC
FOR XML PATH(''))



RETURN LEFT(@output,LEN(@output) - 1);	

END
GO

/*==============================================================
 UDF: Generate alternative key constraints for the specified table
 @param varchar(max) @tableName The specified table
 @return varchar(max) The constraint rule for the specified table
==============================================================*/
CREATE FUNCTION Notillia.generateAlternativeKeys(@tableName varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
   DECLARE	@output varchar(MAX)
   
 SET @output =	(SELECT 'CONSTRAINT ' + Constraint_Name + ' UNIQUE (' + notillia.getAlternativeKeyColumns(table_name)  + ')'
FROM Notillia.Uniques 
WHERE Table_Name = @tableName
FOR XML PATH('')
)

DECLARE @Return VARCHAR(MAX); SET @Return = '';
IF(@output IS NOT NULL) BEGIN
	SET @Return = @output;	
END
RETURN @Return;
END
   
GO

CREATE FUNCTION Notillia.getTableConstraints(@tableName VARCHAR(max))
RETURNS VARCHAR(MAX)
AS BEGIN

DECLARE @Output VARCHAR(MAX) = '';
DECLARE @AKkey VARCHAR(MAX) = ''

set @Output += notillia.generatePrimaryKeys(@tableName) ;

set @AKkey += notillia.generateAlternativeKeys(@tableName);

IF(@AKkey <> '') BEGIN
SET @Output += ', ' + CHAR(10) + @AKkey;
END

RETURN @Output;
END
GO

CREATE FUNCTION Notillia.generateDefaults(@ColumnName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS BEGIN
DECLARE @output NVARCHAR(MAX)

SET @output = (select ' DEFAULT ' +  RIGHT(LEFT(column_default , LEN(column_default) - 1), LEN(column_default) - 2)
from notillia.columns
WHERE column_Name = @ColumnName
for XML PATH(''))

RETURN @output
END
GO


/* WORK IN PROGRESS
CREATE FUNCTION generateIdentity(@columnName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS BEGIN

DECLARE @output NVARCHAR(MAX)

SET @output = (select ' AUTO-INCREMENT '
from Notillia.Columns
where (columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
AND Column_Name = @columnName)

RETURN @output
END
GO
*/


/*==============================================================*/
/* UDF: Notillia.fnGetMasterColumnsForForeignKey                */
/*		Creates a string with all Master columns. Separated     */
/*		by: ','.					    						*/
/*==============================================================*/

CREATE FUNCTION Notillia.fnGetMasterColumnsForForeignKey (@Schema VARCHAR(MAX), @Constraint_Name VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN
	DECLARE @Return VARCHAR(MAX); SET @Return = '';
	SELECT @Return += '`' + Master_Column + '`,' 
	FROM Notillia.ForeignKeyColumns fkc 
	WHERE fkc.Constraint_Name = @Constraint_Name AND fkc.[Schema] = @Schema
	ORDER BY fkc.Master_Column, fkc.Child_Column DESC
	SET @Return = LEFT(@Return, LEN(@Return) - 1);
	RETURN @Return;
END
GO

/*==============================================================*/
/* UDF: Notillia.fnGetChildColumnsForForeignKey                 */
/*		Creates a string with all Child columns. Separated      */
/*		by: ','.												*/
/*==============================================================*/
CREATE FUNCTION Notillia.fnGetChildColumnsForForeignKey (@Schema VARCHAR(MAX), @Constraint_Name VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN
	DECLARE @Return VARCHAR(MAX); SET @Return = '';
	SELECT @Return += '`' + Child_Column + '`,' 
	FROM Notillia.ForeignKeyColumns fkc 
	WHERE fkc.Constraint_Name = @Constraint_Name AND fkc.[Schema] = @Schema
	ORDER BY fkc.Master_Column, fkc.Child_Column DESC
	SET @Return = LEFT(@Return, LEN(@Return) - 1);
	RETURN @Return;
END
GO

/*==============================================================*/
/* PROC: Notillia.createMysqlFkFile                             */
/* Returns alter table statements with foreign keys and cascading */			    						*/
/*==============================================================*/

CREATE FUNCTION Notillia.createMysqlFkFile()
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @String NVARCHAR(MAX); SET @String = '';
	SELECT	@String += 'ALTER TABLE `' + FK.Master_Table + '`' + CHAR(10) + 
				CHAR(9) + ' ADD CONSTRAINT ' + FK.Constraint_Name + ' FOREING KEY (' + Notillia.fnGetMasterColumnsForForeignKey (FK.[Schema], FK.Constraint_Name) + ') ' + CHAR(10) + 
					CHAR(9) + CHAR(9) + 'REFERENCES `' + FK.Child_Table + '` (' + Notillia.fnGetChildColumnsForForeignKey (FK.[Schema], FK.Constraint_Name) + ')' + CHAR(10) + 
						CHAR(9) + CHAR(9) + CHAR(9) + ' ON CASCADE ' + FK.Update_Rule + CHAR(10) + 
						CHAR(9) + CHAR(9) + CHAR(9) + ' ON DELETE	' + FK.Delete_Rule + CHAR(10) + CHAR(10)
					FROM Notillia.Foreignkeys FK
	RETURN @String;
END
GO


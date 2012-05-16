USE muziekdatabase

EXEC generateMySql

/*==============================================================*/
/* SP: the starting point for generating the MySql script												*/
/*==============================================================*/

ALTER PROC generateMySQL
AS BEGIN

PRINT dbo.generateAlternativeKeys('Instrument')
	
 DECLARE @CreateDatabase VARCHAR(MAX); SET @CreateDatabase = '';
SELECT @CreateDatabase += sub.Clause
FROM (SELECT CASE t.[Schema] WHEN 'dbo' THEN '' ELSE t.[Schema] + '.' END + t.[Database] AS 'Clause' FROM Notillia.Tables t UNION
SELECT CASE v.[Schema] WHEN 'dbo' THEN '' ELSE v.[Schema] + '.' END + v.[Database] AS 'Clause' FROM Notillia.Views v) sub

PRINT 'CREATE DATABASE `' +  @CreateDatabase + '`; ' + CHAR(10) + 'USE DATABASE `' + @CreateDatabase + '`;' + CHAR(10)

PRINT dbo.generateCreateTable(); 
   	
 END


/*==============================================================
 UDF: Generate 'create table' statements including the
columns with the correct data types and primary and alternative keys
@return varchar(max) All the create table statements in a long
					String seperated with line breaks
==============================================================*/
ALTER FUNCTION generateCreateTable()
RETURNS varchar(MAX)
AS BEGIN
  DECLARE @tableOutput VARCHAR(max)
 
   SET @tableOutput = (SELECT 'CREATE TABLE `' + t.Table_Name + '`( '
    + CHAR(10) + dbo.getColumnsFromTable(t.Table_Name) + CHAR(10) + dbo.generatePrimaryKeys(t.table_name)+
     CHAR(10) + dbo.generateAlternativeKeys(T.table_name) + CHAR(10) + '); ' + CHAR(10)
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
ALTER FUNCTION getColumnsFromTable(@tableName VARCHAR(max))
RETURNS VARCHAR(max)
AS BEGIN
   	
DECLARE @output VARCHAR(max);
   	
SET @output = (SELECT ' `' + c.Column_Name + '` ' + dbo.convertDataType(@tablename, c.Column_Name) + ',' + CHAR(10)
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
 ALTER FUNCTION convertDataType(@tableName VARCHAR(MAX), @columnName VARCHAR(max))
 RETURNS VARCHAR(max) AS BEGIN
 
 DECLARE @output VARCHAR(max);
 
SET @output = (SELECT CASE Data_type
 WHEN 'varchar' THEN 'VARCHAR' + '(' + CAST(Character_Maximum_Length AS VARCHAR(max)) + ')'
 WHEN 'nvarchar' THEN 'VARCHAR' + '(' + CAST(Character_Maximum_Length AS VARCHAR(max)) + ')' + ' CHARSET utf8' 
 WHEN 'numeric' THEN 'NUMERIC' + '(' + CAST(Numeric_Precision AS VARCHAR(max)) +  ', ' + CAST(numeric_scale AS VARCHAR(max)) + ')'
 WHEN 'char' THEN 'CHAR' + '(' + CAST(Character_Maximum_Length AS VARCHAR(max)) + ')'
 WHEN 'datetime' THEN 'DATETIME'
 ELSE  Data_Type + ' datatype niet bekend!'
 END + CASE IS_NULLable WHEN 'NO' THEN ' NOT NULL' ELSE ' NULL' END
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
ALTER FUNCTION getPrimaryKeyColumns(@tablename varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
DECLARE @output VARCHAR(max);

SET @output =(SELECT '`' + c.Column_Name + '`' + ', '
FROM Notillia.ConstraintColumns c INNER JOIN Notillia.PrimaryKeys pk ON c.Constraint_Name = pk.Constraint_Name
WHERE c.Table_Name = @tablename FOR XML PATH(''))

RETURN LEFT(@output,LEN(@output) - 1);
   END
   
GO

/*==============================================================
 UDF: Generate primary key constraints for the specified table
 @param varchar(max) @tableName The specified table
 @return varchar(max) The constraint rule for the specified table
==============================================================*/
CREATE FUNCTION generatePrimaryKeys(@tableName varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
   DECLARE	@output varchar(MAX)
   
 SET @output =	(SELECT 'CONSTRAINT ' + Constraint_Name + ' PRIMARY KEY (' + dbo.getPrimaryKeyColumns(table_name)  + ')'
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
ALTER FUNCTION getAlternativeKeyColumns(@tablename varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
DECLARE @output VARCHAR(max);

SET @output =(SELECT '`' + c.Column_Name + '`' + ', '
FROM Notillia.ConstraintColumns c INNER JOIN Notillia.Uniques pk ON c.Constraint_Name = pk.Constraint_Name
WHERE c.Table_Name = @tablename FOR XML PATH(''))



RETURN LEFT(@output,LEN(@output) - 1);	

END
GO

/*==============================================================
 UDF: Generate alternative key constraints for the specified table
 @param varchar(max) @tableName The specified table
 @return varchar(max) The constraint rule for the specified table
==============================================================*/
ALTER FUNCTION generateAlternativeKeys(@tableName varchar(MAX))
RETURNS varchar(MAX)
AS BEGIN
   DECLARE	@output varchar(MAX)
   
 SET @output =	(SELECT 'CONSTRAINT ' + Constraint_Name + ' UNIQUE (' + dbo.getAlternativeKeyColumns(table_name)  + ')'
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

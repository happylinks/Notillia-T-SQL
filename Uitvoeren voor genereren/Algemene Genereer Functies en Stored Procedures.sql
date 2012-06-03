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

--CMD_SHELL
CREATE PROCEDURE Notillia.procEnableXP_CMDShell AS BEGIN
	EXECUTE sp_configure 'show advanced options', 1;
	RECONFIGURE;
	
	EXECUTE sp_configure 'xp_cmdshell', 1;
	RECONFIGURE;
END
GO

CREATE PROCEDURE Notillia.procDisableXP_CMDShell AS BEGIN
	EXECUTE sp_configure 'xp_cmdshell', 0;
	RECONFIGURE;
	
	EXECUTE sp_configure 'show advanced options', 0;
	RECONFIGURE
END
GO

/**
*	The procedure procExecuteCMDShell executes an cmd commmando. 
*	@Commando	The commando to execute.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procExecuteCMDShell (@Commando VARCHAR(8000), @return BIT OUTPUT) AS BEGIN
	EXECUTE Notillia.procEnableXP_CMDShell;
	SET @Commando = Notillia.foPrepareCMDContent(@Commando);
	EXECUTE @return = MASTER.dbo.xp_cmdshell @Commando;
	EXECUTE Notillia.procDisableXP_CMDShell;
	
	RETURN @return;
END
GO

/**
*	The procedure procCreateFolderWithCMD creates an folder.
*	@Location the location to create the folder.
*	@Location the location to save.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procCreateFolderWithCMD(@FolderName VARCHAR(128), @Location VARCHAR(255), @Return BIT OUTPUT) AS BEGIN
	SET @Location = Notillia.foPrepareLocation(@Location);
	
	DECLARE @Commando VARCHAR(8000);
	SET @Commando = 'mkdir ' + @Location + @FolderName;
	
	EXECUTE Notillia.procExecuteCMDShell @Commando = @Commando, @return = @return OUTPUT;
	
	RETURN @Return;
END
GO
	
/**
*	The procedure procCreateFileWithCMD creates an file with specific content.
*	@Content the content of the file.
*	@Location the location to save.
*	@FileName the name of the file to create.
*	@Extension the file's extension.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procCreateFileWithCMD(@Content NVARCHAR(MAX), @Location VARCHAR(255), @FileName VARCHAR(255), @Extension VARCHAR(6), @Return BIT OUTPUT) AS BEGIN
	SET @Content = Notillia.foEscapeString(@Content);
	SET @Location = Notillia.foPrepareLocation(@Location);
	
	DECLARE @Commando VARCHAR(8000);
	SET @Commando = 'echo ' + @Content + ' > ' + @Location + @FileName + @Extension;
	
	EXECUTE Notillia.procExecuteCMDShell @Commando = @Commando, @Return = @Return OUTPUT;
	
	RETURN @Return;
END
GO

/**
*	The function ReadFileWithCMD tries to read a file useing cmd.
*	@Location	The location to find the file.
*	@Filename	The file's filename.
*	@Extension	The file's extension.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procReadFileWithCMD(@Location VARCHAR(255), @FileName VARCHAR(255), @Extension VARCHAR(6), @Return NVARCHAR(MAX)) AS BEGIN
	SET @Location = Notillia.foPrepareLocation(@Location);
	
	DECLARE @Commando VARCHAR(MAX);
	SET @Commando = 'type ' + @Location + @FileName + @Extension;
	
	EXECUTE Notillia.procExecuteCMDShell @Commando = @Commando, @Return = @Return OUTPUT;
	
	RETURN @Return;
END
GO

/**
*	The function Escape Strign escapes Characters.
*	@String		The string to escape.
*	@return		An escaped string.
**/
CREATE FUNCTION Notillia.foEscapeString(@String NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(@String, '\', '\\'),
										            '%', '/%'),
										            '_', '\_'),
										            '[', '\{');
END
GO

/**
*	The function prepare location prepares an specific location on the harddisk to save on.
*	@Location	The location to prepare.
*	@Return		The prepared location.
**/
CREATE FUNCTION Notillia.foPrepareLocation(@Location VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN
	SET @Location = REPLACE(@Location, '/', '\');
	
	IF ((SUBSTRING(@Location, LEN(@Location), 1)) != '\') BEGIN
		SET @Location += '\';		
	END
	
	RETURN @Location
END
GO

/**
*	The function prepareCMDContent prepares the content of a cmd statement. By escaping > and < values.
*	@Content	The string to escape.
*	@Return		The escaped string.
*/
CREATE FUNCTION Notillia.foPrepareCMDContent(@Content NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS BEGIN
	SET @Content = REPLACE(@Content,'<','^<');
	SET @Content = REPLACE(@Content,'>','^>');
	RETURN @Content;
END
GO

--Security Settings Functions
--OLE
CREATE PROCEDURE Notillia.procEnableOLEAutomationProcedures AS BEGIN
	EXECUTE sp_configure 'show advanced options', 1;
	RECONFIGURE;
	
	EXECUTE sp_configure 'Ole Automation Procedures', 1;
	RECONFIGURE;
END
GO

CREATE PROCEDURE Notillia.procDisableOLEAutomationProcedures AS BEGIN
	EXECUTE sp_configure 'Ole Automation Procedures', 0;
	RECONFIGURE;
	
	EXECUTE master.dbo.sp_configure 'show advanced options', 0;
	RECONFIGURE;
END
GO

/*
*	The procedure procWriteStringToFile tries to write an string to a file.
*	@String		The string to save.
*	@Path		The path to save the string on.
*	@Filename	The file to save the string in.
*/
CREATE PROCEDURE Notillia.procWriteStringToFile(@String NVARCHAR(MAX), @Path NVARCHAR(255), @Filename NVARCHAR(100)) AS BEGIN
DECLARE  @objFileSystem INT
        ,@objTextStream INT,
         @objErrorObject INT,
		 @strErrorMessage NVARCHAR(1000),
	     @Command NVARCHAR(1000),
	     @hr INT,
		 @fileAndPath NVARCHAR(80);

SET NOCOUNT ON;

EXECUTE Notillia.procEnableOLEAutomationProcedures;

SELECT @strErrorMessage='opening the File System Object';
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT;

SELECT @FileAndPath=@path+'\'+@filename;
IF @HR=0 SELECT @objErrorObject=@objFileSystem , @strErrorMessage='Creating file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem   , 'CreateTextFile'
	, @objTextStream OUT, @FileAndPath,2,False

IF @HR=0 SELECT @objErrorObject=@objTextStream, 
	@strErrorMessage='writing to the file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Write', Null, @String

IF @HR=0 SELECT @objErrorObject=@objTextStream, @strErrorMessage='closing the file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'

IF @hr<>0 BEGIN
	DECLARE 
		@Source NVARCHAR(255),
		@Description NVARCHAR(255),
		@Helpfile NVARCHAR(255),
		@HelpID INT
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
	SELECT @strErrorMessage='Error whilst '
			+COALESCE(@strErrorMessage,'doing something')
			+', '+COALESCE(@Description,'')
	RAISERROR (@strErrorMessage,16,1)
END
EXECUTE  sp_OADestroy @objTextStream
EXECUTE sp_OADestroy @objTextStream

EXECUTE Notillia.procDisableOLEAutomationProcedures;
END

GO


CREATE PROCEDURE Notillia.parseTag @output_in NVARCHAR(max), @template_name NVARCHAR(25), @database_name NVARCHAR(50), @schema_name NVARCHAR(50), @table_name NVARCHAR(50), @count INT, @output_out NVARCHAR(max) OUTPUT, @count_check INT OUTPUT
AS
BEGIN
		DECLARE @tag_name NVARCHAR(25);
		DECLARE @tag_tag NVARCHAR(40);
		DECLARE @tag_source NVARCHAR(max);
		DECLARE @tag_query NVARCHAR(max);
		DECLARE @tag_beforeResult NVARCHAR(max);
		DECLARE @tag_afterResult NVARCHAR(max);
		SET @output_out = @output_in;
		DECLARE ReplaceValue_tags CURSOR FOR 
			SELECT name, tag, source, query, beforeResult, afterResult FROM Notillia.Tags WHERE template_name = @template_name ORDER BY template_name, name ASC
		OPEN ReplaceValue_tags
		FETCH NEXT FROM ReplaceValue_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query,@tag_beforeResult,@tag_afterResult
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @tag_query = REPLACE(@tag_query, '{{DatabaseName}}', @database_name);
			SET @tag_query = REPLACE(@tag_query, '{{SchemaName}}', @schema_name);
			SET @tag_query = REPLACE(@tag_query, '{{TableName}}', @table_name);

			-- Check if the tag is found with an tag value.
			DECLARE @checkTagValue INT = CHARINDEX(LEFT(@tag_tag, LEN(@tag_tag) -2) + '=', @output_out);
			DECLARE @fullTag VARCHAR(max);
			IF @checkTagValue <> 0
				BEGIN
					DECLARE @tagValue VARCHAR(max);
					DECLARE @firstPart VARCHAR(max);
					SET @firstPart = SUBSTRING(@output_out, (@checkTagValue + LEN(@tag_tag) -1), LEN(@output_out));
					SET @tagValue = SUBSTRING(@firstPart, 0, CHARINDEX('}}', @firstPart));
					SET @fullTag = CAST((SUBSTRING(@tag_tag, 0, LEN(@tag_tag) - 1)) as NVARCHAR(255)) + '=' + @tagValue + '}}';
					SET @tag_query = REPLACE(@tag_query, '{{ParameterTag}}', ISNULL(@tagValue, ''));
				END
		
			DECLARE @tag_result NVARCHAR(MAX) = '';
			DECLARE @ParamDefinition nvarchar(500);
			DECLARE @query NVARCHAR(max);

			SET @query =  @tag_beforeResult +'
				DECLARE @ReplaceValue_1 NVARCHAR(max);
				DECLARE @ReplaceValue_2 NVARCHAR(max);
				DECLARE @ReplaceValue_3 NVARCHAR(max);
				DECLARE @ReplaceValue_4 NVARCHAR(max);
				DECLARE @ReplaceValue_5 NVARCHAR(max);
				DECLARE @ReplaceValue_6 NVARCHAR(max);
				DECLARE @tag_source NVARCHAR(max) = '''+REPLACE(@tag_source, '''', '''''')+''';
				DECLARE ReplaceValue_dbresults CURSOR FOR ' + @tag_query + '
				OPEN ReplaceValue_dbresults
				FETCH NEXT FROM ReplaceValue_dbresults INTO @ReplaceValue_1,@ReplaceValue_2,@ReplaceValue_3,@ReplaceValue_4,@ReplaceValue_5,@ReplaceValue_6
				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @tag_temp NVARCHAR(max) = @tag_source;
					SET @tag_temp = REPLACE(@tag_temp,''{{ReplaceValue_1}}'',ISNULL(@ReplaceValue_1, ''''));
					SET @tag_temp = REPLACE(@tag_temp,''{{ReplaceValue_2}}'',ISNULL(@ReplaceValue_2, ''''));
					SET @tag_temp = REPLACE(@tag_temp,''{{ReplaceValue_3}}'',ISNULL(@ReplaceValue_3, ''''));
					SET @tag_temp = REPLACE(@tag_temp,''{{ReplaceValue_4}}'',ISNULL(@ReplaceValue_4, ''''));
					SET @tag_temp = REPLACE(@tag_temp,''{{ReplaceValue_5}}'',ISNULL(@ReplaceValue_5, ''''));
					SET @tag_temp = REPLACE(@tag_temp,''{{ReplaceValue_6}}'',ISNULL(@ReplaceValue_6, ''''));
					SET @tag_result += @tag_temp;
					
					FETCH NEXT FROM ReplaceValue_dbresults INTO @ReplaceValue_1,@ReplaceValue_2,@ReplaceValue_3,@ReplaceValue_4,@ReplaceValue_5,@ReplaceValue_6
				END
				CLOSE ReplaceValue_dbresults
				DEALLOCATE ReplaceValue_dbresults
				' + @tag_afterResult
			SET @ParamDefinition = N'@tag_result nvarchar(max) OUTPUT';
			EXEC sp_executesql @query, @ParamDefinition, @tag_result = @tag_result OUTPUT

			SET @output_out = REPLACE(@output_out, '{{TableName}}', @table_name);
			DECLARE @backup_input_out NVARCHAR(max) = @output_out;
			IF @checkTagValue <> 0
				BEGIN
					SET @output_out =  REPLACE(@output_out, @fullTag, ISNULL(@tag_result, ''));
				END
			ELSE
				BEGIN
					SET @output_out =  REPLACE(@output_out,@tag_tag, ISNULL(@tag_result, ''));
				END

			-- If the content havent been changed means this tag isnt found in the template.
			IF @output_out != @backup_input_out
				BEGIN
					SET @count_check = 0;
				END
			ELSE 
				BEGIN
					SET @count_check = @count + 1;
				END

			FETCH NEXT FROM ReplaceValue_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query,@tag_beforeResult,@tag_afterResult
		END
		CLOSE ReplaceValue_tags;
		DEALLOCATE ReplaceValue_tags;
END
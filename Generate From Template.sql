-- DROP TABLE Notillia.Tags;
-- DROP TABLE Notillia.Templates;
--Database(s) and schema(s):
USE muziekdatabase;
GO


BEGIN TRY
	/**
	  *	Template table with all the templates for the CRUD application
	  */
	CREATE TABLE Notillia.Templates(
		name		varchar(25)		not null,
		description varchar(120)	not null,
		source		text			not null,
		path		varchar(50)		not null,
		constraint PK_templates primary key  (name),
	);
	/**
	  *	Tag table, contains all the replacement tags for an certain template.
	  */
	CREATE TABLE Notillia.Tags(
		template_name varchar(25)	not null,
		name		varchar(25)		not null,
		description varchar(120)	not null,
		tag			varchar(40)		not null,
		source		text			not null,
		query		varchar(max)	not null,
		constraint PK_tags primary key  (template_name,name),
		constraint FK_template foreign key(template_name) REFERENCES Notillia.Templates(name) ON UPDATE NO ACTION ON DELETE NO ACTION
	);
END TRY
BEGIN CATCH
	RAISERROR ('Tabellen bestaan al!', 16, 1);
END CATCH

/**  -----------------------------------------------------------------
  *			TEST DATA
  */ -----------------------------------------------------------------
INSERT INTO Notillia.Templates
VALUES (
		'test',
		'Testing templating',
		'/BLABLA TEMPLATE {{columnoptions}} BLABLA TEMPLATE/',
		''
		);
INSERT INTO Notillia.Tags
VALUES (
		'test',
		'columnoptions',
		'Option tags for each column',
		'{{columnoptions}}',
		'<option value="{{notillia_2}}">{{notillia_1}}</option>',
		'SELECT Column_Name,Table_Name,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}'''
);

/**  -----------------------------------------------------------------
  *			END OF TEST DATA
  */ -----------------------------------------------------------------


DECLARE @table_name VARCHAR(50)
DECLARE notillia_tables CURSOR FOR 
	SELECT table_name FROM Notillia.Tables

OPEN notillia_tables 
FETCH NEXT FROM notillia_tables INTO @table_name 

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @template_name VARCHAR(25)
	DECLARE @template_source VARCHAR(max)
	DECLARE @template_path VARCHAR(50)
	DECLARE notillia_templates CURSOR FOR 
		SELECT name, source, path FROM Notillia.Templates
	OPEN notillia_templates
	FETCH NEXT FROM notillia_templates INTO @template_name,@template_source,@template_path
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @template_output NVARCHAR(max)
		DECLARE @tag_name VARCHAR(25)
		DECLARE @tag_tag VARCHAR(40)
		DECLARE @tag_source VARCHAR(max)
		DECLARE @tag_query NVARCHAR(max)
		DECLARE notillia_tags CURSOR FOR 
			SELECT name, tag, source, query FROM Notillia.Tags WHERE template_name = @template_name
		OPEN notillia_tags
		FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @template_content NVARCHAR(MAX) = '';
			DECLARE @ParamDefinition nvarchar(500);
			SET @tag_query = REPLACE(@tag_query,'{{TableName}}',@table_name);
			DECLARE @query NVARCHAR(max);
			SET @query = '
				DECLARE @notillia_1 VARCHAR(max)
				DECLARE @notillia_2 VARCHAR(max)
				DECLARE @notillia_3 VARCHAR(max)
				DECLARE @notillia_4 VARCHAR(max)
				DECLARE @notillia_5 VARCHAR(max)
				DECLARE notillia_dbresults CURSOR FOR ' + @tag_query + '
				OPEN notillia_dbresults
				FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5
				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @tag_output VARCHAR(max) = '''+@tag_source+'''
					SET @tag_output = REPLACE(@tag_output,''{{notillia_1}}'',@notillia_1);
					SET @tag_output = REPLACE(@tag_output,''{{notillia_2}}'',@notillia_2);
					SET @tag_output = REPLACE(@tag_output,''{{notillia_3}}'',@notillia_3);
					SET @tag_output = REPLACE(@tag_output,''{{notillia_4}}'',@notillia_4);
					SET @tag_output = REPLACE(@tag_output,''{{notillia_5}}'',@notillia_5);
					SET @tag_result = @tag_result + @tag_output;
					
					FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5
				END
				CLOSE notillia_dbresults
				DEALLOCATE notillia_dbresults'
			SET @ParamDefinition = N'@tag_result nvarchar(max) OUTPUT';
			EXEC sp_executesql @query, @ParamDefinition, @tag_result = @template_content OUTPUT
			
			SET @template_output = REPLACE(@template_source,@tag_tag,@template_content);
			PRINT @template_output;
			
			FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		END
		CLOSE notillia_tags
		DEALLOCATE notillia_tags
		
		FETCH NEXT FROM notillia_templates INTO @template_name,@template_source,@template_path
	END
	CLOSE notillia_templates
	DEALLOCATE notillia_templates
	
	FETCH NEXT FROM notillia_tables INTO @table_name
END

CLOSE notillia_tables
DEALLOCATE notillia_tables
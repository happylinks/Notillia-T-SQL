--Database(s) and schema(s):
USE muziekdatabase;
GO

DECLARE @driveLetter VARCHAR(2) = 'C:';
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
	DECLARE @template_fileName VARCHAR(255)
	DECLARE notillia_templates CURSOR FOR 
		SELECT name, source, path, filename FROM Notillia.Templates
	OPEN notillia_templates
	FETCH NEXT FROM notillia_templates INTO @template_name, @template_source, @template_path, @template_fileName
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
			-- General rule: {{TableName}} becomes the name of the Table in any layout.
			SET @template_output = REPLACE(@template_output, '{{TableName}}', @table_name);

			/*
			*	Prepare and make the file (path) to write the template to the file system.
			*/
			DECLARE @fileName VARCHAR(255) = REPLACE(@template_fileName, '{{TableName}}', @table_name);
			DECLARE @filePath VARCHAR(255) = REPLACE(@template_path, '{{TableName}}', @table_name);
			DECLARE @fullFilePath VARCHAR(255) = @driveLetter + '\' + @filePath;
			DECLARE @CreateFolderResult BIT;


			EXEC Notillia.procCreateFolderWithCMD @filePath, @driveLetter, @CreateFolderResult OUTPUT;
			
			
			-- Write file to Disk
			EXEC Notillia.procWriteStringToFile @template_output, @fullFilePath, @fileName;
			
			FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		END
		CLOSE notillia_tags
		DEALLOCATE notillia_tags
		
		FETCH NEXT FROM notillia_templates INTO @template_name,@template_source,@template_path,@template_fileName
	END
	CLOSE notillia_templates
	DEALLOCATE notillia_templates
	
	FETCH NEXT FROM notillia_tables INTO @table_name
END

CLOSE notillia_tables
DEALLOCATE notillia_tables
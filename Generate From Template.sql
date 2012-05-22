--Database(s) and schema(s):
USE muziekdatabase;
GO

DECLARE @driveLetter NVARCHAR(2) = 'C:';
DECLARE @template_output NVARCHAR(max);
DECLARE @table_name NVARCHAR(50);
DECLARE notillia_tables CURSOR FOR 
	SELECT table_name FROM Notillia.Tables

OPEN notillia_tables 
FETCH NEXT FROM notillia_tables INTO @table_name 

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @template_name NVARCHAR(25);
	DECLARE @template_source NVARCHAR(max);
	DECLARE @template_path NVARCHAR(50);
	DECLARE @template_fileName NVARCHAR(255);
	DECLARE notillia_templates CURSOR FOR 
		SELECT name, source, path, filename FROM Notillia.Templates
	OPEN notillia_templates
	FETCH NEXT FROM notillia_templates INTO @template_name, @template_source, @template_path, @template_fileName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- General rule: {{TableName}} becomes the name of the Table in any layout.
		SET @template_output = REPLACE(@template_output, '{{TableName}}', @table_name);

		DECLARE @tag_name NVARCHAR(25);
		DECLARE @tag_tag NVARCHAR(40);
		DECLARE @tag_source NVARCHAR(max);
		DECLARE @tag_query NVARCHAR(max);
		DECLARE notillia_tags CURSOR FOR 
			SELECT name, tag, source, query FROM Notillia.Tags WHERE template_name = @template_name
		OPEN notillia_tags
		FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @template_source = REPLACE(@template_source, '{{TableName}}', @table_name);
			EXEC Notillia.parseTag @tag_name, @tag_tag, @tag_source, @tag_query, @template_source, @template_name, @table_name, @output_out = @template_source OUTPUT


			-- SET @template_output =  REPLACE(@template_source,@tag_tag,@tag_result);
			
			FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		END
		CLOSE notillia_tags;
		DEALLOCATE notillia_tags;

		


		/*
		*	Prepare and make the file (path) to write the template to the file system.
		*/
		DECLARE @fileName NVARCHAR(255) = REPLACE(@template_fileName, '{{TableName}}', @table_name);
		DECLARE @filePath NVARCHAR(255) = REPLACE(@template_path, '{{TableName}}', @table_name);
		DECLARE @fullFilePath NVARCHAR(255) = @driveLetter + '\' + @filePath;
		DECLARE @CreateFolderResult BIT;


		EXEC Notillia.procCreateFolderWithCMD @filePath, @driveLetter, @CreateFolderResult OUTPUT;
			
			
		-- Write file to Disk
		-- EXEC Notillia.procWriteStringToFile @template_output, @fullFilePath, @fileName;
		PRINT @template_source;
		
		FETCH NEXT FROM notillia_templates INTO @template_name,@template_source,@template_path,@template_fileName
	END
	CLOSE notillia_templates;
	DEALLOCATE notillia_templates;
	
	FETCH NEXT FROM notillia_tables INTO @table_name
END

CLOSE notillia_tables;
DEALLOCATE notillia_tables;
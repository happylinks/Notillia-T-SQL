
DECLARE @driveLetter NVARCHAR(2) = 'C:';
DECLARE @database_name NVARCHAR(50) = 'muziekdatabase';
DECLARE @schema_name NVARCHAR(50) = 'dbo';
DECLARE @template_output NVARCHAR(max);
DECLARE @table_name NVARCHAR(50);
DECLARE notillia_tables CURSOR FOR 
	SELECT table_name FROM Notillia.Tables nt WHERE nt.[Schema] = @schema_name AND nt.[Database] = @database_name

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

		SET @template_output = REPLACE(@template_source, '{{TableName}}', @table_name);
		SET @template_output = REPLACE(@template_source, '{{DatabaseName}}', @database_name);
		DECLARE @i INT = 0;
		WHILE(CHARINDEX('{{', @template_output) <> 0 AND @i < (SELECT COUNT(1) FROM Notillia.Tags))
		BEGIN
			EXEC Notillia.parseTag @template_output, @template_name, @database_name, @schema_name, @table_name, @i, @output_out = @template_output OUTPUT, @count_check = @i OUTPUT
		END
			

		/*
		*	Prepare and make the file (path) to write the template to the file system.
		*/
		DECLARE @fileName NVARCHAR(255) = REPLACE(@template_fileName, '{{TableName}}', @table_name);
		DECLARE @filePath NVARCHAR(255) = REPLACE(@template_path, '{{TableName}}', @table_name);
		DECLARE @fullFilePath NVARCHAR(255) = @driveLetter + '\' + @filePath;
		DECLARE @CreateFolderResult BIT;


		EXEC Notillia.procCreateFolderWithCMD @filePath, @driveLetter, @CreateFolderResult OUTPUT;
			
			
		-- Write file to Disk
		EXEC Notillia.procWriteStringToFile @template_output, @fullFilePath, @fileName;
		
		FETCH NEXT FROM notillia_templates INTO @template_name,@template_source,@template_path,@template_fileName
	END
	CLOSE notillia_templates;
	DEALLOCATE notillia_templates;
	
	FETCH NEXT FROM notillia_tables INTO @table_name
END

CLOSE notillia_tables;
DEALLOCATE notillia_tables;
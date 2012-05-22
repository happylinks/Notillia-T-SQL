--Database(s) and schema(s):
USE muziekdatabase;

GO

DROP PROCEDURE Notillia.parseTag;

GO

CREATE PROCEDURE Notillia.parseTag @output_in NVARCHAR(max), @template_name NVARCHAR(25), @table_name NVARCHAR(50), @count INT, @output_out NVARCHAR(max) OUTPUT, @count_check INT OUTPUT
AS
BEGIN
		DECLARE @tag_name NVARCHAR(25);
		DECLARE @tag_tag NVARCHAR(40);
		DECLARE @tag_source NVARCHAR(max);
		DECLARE @tag_query NVARCHAR(max);
		SET @output_out = @output_in;
		DECLARE notillia_tags CURSOR FOR 
			SELECT name, tag, source, query FROM Notillia.Tags WHERE template_name = @template_name ORDER BY id ASC
		OPEN notillia_tags
		FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		WHILE @@FETCH_STATUS = 0
		BEGIN
	
		DECLARE @tag_result NVARCHAR(MAX) = '';
		DECLARE @ParamDefinition nvarchar(500);
		DECLARE @query NVARCHAR(max);

		SET @tag_query = REPLACE(@tag_query, '{{TableName}}', @table_name);

		SET @query = '
			DECLARE @notillia_1 NVARCHAR(max);
			DECLARE @notillia_2 NVARCHAR(max);
			DECLARE @notillia_3 NVARCHAR(max);
			DECLARE @notillia_4 NVARCHAR(max);
			DECLARE @notillia_5 NVARCHAR(max);
			DECLARE @notillia_6 NVARCHAR(max);
			DECLARE @tag_source NVARCHAR(max) = '''+@tag_source+''';
			DECLARE notillia_dbresults CURSOR FOR ' + @tag_query + '
			OPEN notillia_dbresults
			FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5,@notillia_6
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @tag_temp NVARCHAR(max) = @tag_source;
				SET @tag_temp = REPLACE(@tag_temp,''{{notillia_1}}'',ISNULL(@notillia_1, ''''));
				SET @tag_temp = REPLACE(@tag_temp,''{{notillia_2}}'',ISNULL(@notillia_2, ''''));
				SET @tag_temp = REPLACE(@tag_temp,''{{notillia_3}}'',ISNULL(@notillia_3, ''''));
				SET @tag_temp = REPLACE(@tag_temp,''{{notillia_4}}'',ISNULL(@notillia_4, ''''));
				SET @tag_temp = REPLACE(@tag_temp,''{{notillia_5}}'',ISNULL(@notillia_5, ''''));
				SET @tag_temp = REPLACE(@tag_temp,''{{notillia_6}}'',ISNULL(@notillia_6, ''''));
				SET @tag_result += @tag_temp + CHAR(13);
					
				FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5,@notillia_6
			END
			CLOSE notillia_dbresults
			DEALLOCATE notillia_dbresults'
		SET @ParamDefinition = N'@tag_result nvarchar(max) OUTPUT';
		EXEC sp_executesql @query, @ParamDefinition, @tag_result = @tag_result OUTPUT

		DECLARE @backup_input_out NVARCHAR(max) = @output_out;
		SET @output_out =  REPLACE(@output_out,@tag_tag,ISNULL(@tag_result, ''));

		-- If the content havent been changed means this tag isnt found in the template.
		IF @output_out != @backup_input_out
			BEGIN
				SET @count_check = 0;
			END
		ELSE 
			BEGIN
				SET @count_check = @count + 1;
			END

		FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query
		END
		CLOSE notillia_tags;
		DEALLOCATE notillia_tags;
END
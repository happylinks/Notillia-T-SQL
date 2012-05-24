--Database(s) and schema(s):
USE muziekdatabase;

GO

DROP PROCEDURE Notillia.parseTag;

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
		DECLARE notillia_tags CURSOR FOR 
			SELECT name, tag, source, query, beforeResult, afterResult FROM Notillia.Tags WHERE template_name = @template_name ORDER BY id ASC
		OPEN notillia_tags
		FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query,@tag_beforeResult,@tag_afterResult
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
				DECLARE @notillia_1 NVARCHAR(max);
				DECLARE @notillia_2 NVARCHAR(max);
				DECLARE @notillia_3 NVARCHAR(max);
				DECLARE @notillia_4 NVARCHAR(max);
				DECLARE @notillia_5 NVARCHAR(max);
				DECLARE @notillia_6 NVARCHAR(max);
				DECLARE @tag_source NVARCHAR(max) = '''+REPLACE(@tag_source, '''', '''''')+''';
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
					SET @tag_result += @tag_temp;
					
					FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5,@notillia_6
				END
				CLOSE notillia_dbresults
				DEALLOCATE notillia_dbresults
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

			FETCH NEXT FROM notillia_tags INTO @tag_name,@tag_tag,@tag_source,@tag_query,@tag_beforeResult,@tag_afterResult
		END
		CLOSE notillia_tags;
		DEALLOCATE notillia_tags;
END
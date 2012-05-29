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
			SELECT name, tag, source, query, beforeResult, afterResult FROM ReplaceValue.Tags WHERE template_name = @template_name ORDER BY id ASC
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
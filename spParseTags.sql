--Database(s) and schema(s):
USE muziekdatabase;

GO

DROP PROCEDURE Notillia.parseTag;

GO

CREATE PROCEDURE Notillia.parseTag @tag_name NVARCHAR(25), @tag_tag NVARCHAR(40), @tag_source NVARCHAR(max), @tag_query NVARCHAR(max), @output_in NVARCHAR(max), @template_name NVARCHAR(25), @table_name NVARCHAR(50), @output_out NVARCHAR(max) OUTPUT
AS
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
			DECLARE @tag_output NVARCHAR(max) = '''+@tag_source+''';
			DECLARE notillia_dbresults CURSOR FOR ' + @tag_query + '
			OPEN notillia_dbresults
			FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @tag_output = REPLACE(@tag_output,''{{notillia_1}}'',@notillia_1);
				SET @tag_output = REPLACE(@tag_output,''{{notillia_2}}'',@notillia_2);
				SET @tag_output = REPLACE(@tag_output,''{{notillia_3}}'',@notillia_3);
				SET @tag_output = REPLACE(@tag_output,''{{notillia_4}}'',@notillia_4);
				SET @tag_output = REPLACE(@tag_output,''{{notillia_5}}'',@notillia_5);
				SET @tag_result = @tag_result + @tag_output;
				PRINT @notillia_1;
					
				FETCH NEXT FROM notillia_dbresults INTO @notillia_1,@notillia_2,@notillia_3,@notillia_4,@notillia_5
			END
			CLOSE notillia_dbresults
			DEALLOCATE notillia_dbresults'
		SET @ParamDefinition = N'@tag_result nvarchar(max) OUTPUT';
		EXEC sp_executesql @query, @ParamDefinition, @tag_result = @tag_result OUTPUT
		
		SET @output_out =  REPLACE(@output_in,@tag_tag,@tag_result);

		-- Recursive opzet
		PRINT @output_out;

		IF CHARINDEX('{{', @output_out) <> 0
 			BEGIN
				PRINT 'hoi';
				DECLARE @tag2_name NVARCHAR(25);
				DECLARE @tag2_tag NVARCHAR(40);
				DECLARE @tag2_source NVARCHAR(max);
				DECLARE @tag2_query NVARCHAR(max);
				DECLARE @i INT = 1;
				WHILE (SELECT COUNT(1) FROM Notillia.Tags WHERE template_name = @template_name) >= @i
					BEGIN
						SELECT @tag2_name = name, @tag2_tag = tag, @tag2_source = source, @tag2_query = query FROM Notillia.Tags WHERE template_name = @template_name AND id = @i;
						DECLARE @temp_out NVARCHAR(max);
						EXEC Notillia.parseTag @tag2_name, @tag2_tag, @tag2_source, @tag2_query, @output_out, @template_name, @table_name, @output_out = @temp_out OUTPUT
						SET @output_out += @temp_out;
						SET @i += 1;
					END
			END
END
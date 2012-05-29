--Database
USE muziekdatabase;
GO

/**
*	The function ReadfileAsTableWithOLE tries to read an file and return it.
*	@Path The path where the file is located.
*	@Filename the name of the file te read.
*	@Return an table with LineNo and line column(s) which have to rows of the file.
**/
CREATE FUNCTION Notillia.foReadfileAsTableWithOLE (
@Path VARCHAR(255), 
@Filename VARCHAR(100)) 
RETURNS @File TABLE (
	[LineNo] INT IDENTITY(1,1), 
	line VARCHAR(8000)
) AS BEGIN

DECLARE  @objFileSystem INT, @objTextStream INT, @objErrorObject INT, @strErrorMessage VARCHAR(1000), 
		 @Command VARCHAR(1000), @hr INT, @String VARCHAR(8000), @YesOrNo INT

SELECT @strErrorMessage='opening the File System Object'
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT

IF @HR=0 SELECT @objErrorObject=@objFileSystem, @strErrorMessage='Opening file "'+@path+'\'+@filename+'"',@command=@path+'\'+@filename

IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem  , 'OpenTextFile', @objTextStream OUT, @command,1,false,0--for reading, FormatASCII

WHILE @hr=0 BEGIN
	IF @HR=0 SELECT @objErrorObject=@objTextStream, 
		@strErrorMessage='finding out if there is more to read in "'+@filename+'"'
	IF @HR=0 EXECUTE @hr = sp_OAGetProperty @objTextStream, 'AtEndOfStream', @YesOrNo OUTPUT

	IF @YesOrNo<>0  break
	IF @HR=0 SELECT @objErrorObject=@objTextStream, 
		@strErrorMessage='reading from the output file "'+@filename+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Readline', @String OUTPUT
	INSERT INTO @file(line) SELECT @String
	END

IF @HR=0 SELECT @objErrorObject=@objTextStream, 
	@strErrorMessage='closing the output file "'+@filename+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'


IF @hr<>0 BEGIN
	DECLARE @Source VARCHAR(255),
		    @Description VARCHAR(255),
		    @Helpfile VARCHAR(255),
		    @HelpID INT
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
	SELECT @strErrorMessage='Error whilst '
			+COALESCE(@strErrorMessage,'doing something')
			+', '+COALESCE(@Description,'')
	INSERT INTO @File(line) SELECT @strErrorMessage
	END
EXECUTE  sp_OADestroy @objTextStream
	-- Fill the table variable with the rows for your result set
	
	RETURN 
END
GO

/**
*	The function foReadfileAsStringWithOLE Calls the foReadfileAsTableWithOLE function but returns is as a string.
*	@Path		The location where we can find the file.
*	@Filename	The file to read.
*	@Return		The table in string form you were looking for.
**/
CREATE FUNCTION Notillia.foReadfileAsTableWithOLEAsString (@Path VARCHAR(255), @Filename VARCHAR(100)) RETURNS NVARCHAR(MAX) AS BEGIN
	DECLARE @Return NVARCHAR(MAX); SET @Return = '';
	SELECT @Return += line FROM Notillia.foReadfileAsTableWithOLE(@Path, @Filename);
	RETURN @Return;
END
GO

--Test
--DECLARE @String NVARCHAR(MAX); SET @String = '';
--SELECT @String += line FROM Notillia.foReadfileAsTableWithOLE('C:\', 'kaas.php');
--PRINT @String;

--PRINT Notillia.foReadfileAsStringWithOLE('C:\', 'kaas.php')
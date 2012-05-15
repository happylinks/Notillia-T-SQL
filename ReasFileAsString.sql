--Database
USE muziekdatabase;
GO

/**
*	The function foReadfileAsStringWithOLE tries to read an file from a certain pad.
*	@Path		The path to look for the file.
*	@Filename	The file's name to open.
*	@Return		The file in string form.
*/
CREATE FUNCTION Notillia.foReadfileAsStringWithOLE (@Path VARCHAR(255), @Filename VARCHAR(100))
RETURNS VARCHAR(MAX) AS BEGIN
DECLARE  @objFileSystem INT
        ,@objTextStream INT,
		@objErrorObject INT,
		@strErrorMessage VARCHAR(1000),
	    @Command VARCHAR(1000),
		@Chunk VARCHAR(8000),
		@String VARCHAR(max),
	    @hr INT,
		@YesOrNo INT;

SELECT @String = '';
SELECT @strErrorMessage='opening the File System Object';
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT;

IF @HR=0 SELECT @objErrorObject=@objFileSystem, @strErrorMessage='Opening file "'+@path+'\'+@filename+'"',@command=@path+'\'+@filename

IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem  , 'OpenTextFile'
	, @objTextStream OUT, @command,1,false,0--for reading, FormatASCII

WHILE @hr=0 BEGIN
	IF @HR=0 SELECT @objErrorObject=@objTextStream, 
		@strErrorMessage='finding out if there is more to read in "'+@filename+'"'
	IF @HR=0 EXECUTE @hr = sp_OAGetProperty @objTextStream, 'AtEndOfStream', @YesOrNo OUTPUT

	IF @YesOrNo<>0  BREAK
	IF @HR=0 SELECT @objErrorObject=@objTextStream, 
		@strErrorMessage='reading from the output file "'+@filename+'"'
	IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Read', @chunk OUTPUT,4000
	SELECT @String=@string+@chunk
END
IF @HR=0 SELECT @objErrorObject=@objTextStream, 
	@strErrorMessage='closing the output file "'+@filename+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'

IF @hr<>0 BEGIN
	DECLARE 
		@Source VARCHAR(255),
		@Description Varchar(255),
		@Helpfile Varchar(255),
		@HelpID int
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
	SELECT @strErrorMessage='Error whilst '
			+coalesce(@strErrorMessage,'doing something')
			+', '+coalesce(@Description,'')
	SELECT @String=@strErrorMessage	
END
EXECUTE  sp_OADestroy @objTextStream
	
	RETURN @string
END
GO

--Test
--SELECT Notillia.foReadfileAsStringWithOLE('C:\', 'kaas.php');
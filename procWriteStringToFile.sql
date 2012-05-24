USE muziekdatabase;
GO

/*
*	The procedure procWriteStringToFile tries to write an string to a file.
*	@String		The string to save.
*	@Path		The path to save the string on.
*	@Filename	The file to save the string in.
*/
ALTER PROCEDURE Notillia.procWriteStringToFile(@String NVARCHAR(MAX), @Path NVARCHAR(255), @Filename NVARCHAR(100)) AS BEGIN
DECLARE  @objFileSystem INT
        ,@objTextStream INT,
         @objErrorObject INT,
		 @strErrorMessage NVARCHAR(1000),
	     @Command NVARCHAR(1000),
	     @hr INT,
		 @fileAndPath NVARCHAR(80);

SET NOCOUNT ON;

EXECUTE Notillia.procEnableOLEAutomationProcedures;

SELECT @strErrorMessage='opening the File System Object';
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT;

SELECT @FileAndPath=@path+'\'+@filename;
IF @HR=0 SELECT @objErrorObject=@objFileSystem , @strErrorMessage='Creating file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem   , 'CreateTextFile'
	, @objTextStream OUT, @FileAndPath,2,True

IF @HR=0 SELECT @objErrorObject=@objTextStream, 
	@strErrorMessage='writing to the file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Write', Null, @String

IF @HR=0 SELECT @objErrorObject=@objTextStream, @strErrorMessage='closing the file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'

IF @hr<>0 BEGIN
	DECLARE 
		@Source NVARCHAR(255),
		@Description NVARCHAR(255),
		@Helpfile NVARCHAR(255),
		@HelpID INT
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
	SELECT @strErrorMessage='Error whilst '
			+COALESCE(@strErrorMessage,'doing something')
			+', '+COALESCE(@Description,'')
	RAISERROR (@strErrorMessage,16,1)
END
EXECUTE  sp_OADestroy @objTextStream
EXECUTE sp_OADestroy @objTextStream

EXECUTE Notillia.procDisableOLEAutomationProcedures;
END

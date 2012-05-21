USE muziekdatabase;
GO

/*
*	The procedure procWriteStringToFile tries to write an string to a file.
*	@String		The string to save.
*	@Path		The path to save the string on.
*	@Filename	The file to save the string in.
*/
CREATE PROCEDURE Notillia.procWriteStringToFile(@String VARCHAR(MAX), @Path VARCHAR(255), @Filename VARCHAR(100)) AS BEGIN
DECLARE  @objFileSystem INT
        ,@objTextStream INT,
         @objErrorObject INT,
		 @strErrorMessage VARCHAR(1000),
	     @Command VARCHAR(1000),
	     @hr INT,
		 @fileAndPath VARCHAR(80);

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
		@Source VARCHAR(255),
		@Description VARCHAR(255),
		@Helpfile VARCHAR(255),
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

--Database;
USE muziekdatabase;
GO

/*
*	The function procFileDetails gets details of a specific file.
*	@Filename	the file to get details off.
*/

CREATE PROCEDURE Notillia.procFileDetails @Filename VARCHAR(100) AS BEGIN
DECLARE @hr INT,         --the HRESULT returned from 
        @objFileSystem INT,              --the FileSystem object
        @objFile INT,            --the File object
        @ErrorObject INT,        --the error object
        @ErrorMessage VARCHAR(255),--the potential error message
        @Path VARCHAR(100),--
        @ShortPath VARCHAR(100),
        @Type VARCHAR(100),
        @DateCreated datetime,
        @DateLastAccessed datetime,
        @DateLastModified datetime,
        @Attributes INT,
        @size INT

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON

SELECT @hr=0,@errorMessage='opening the file system object '
EXEC @hr = sp_OACreate 'Scripting.FileSystemObject', @objFileSystem OUT

IF @hr=0 SELECT @errorMessage='accessing the file ''' + @Filename+'''', @ErrorObject=@objFileSystem
IF @hr=0 EXEC @hr = sp_OAMethod @objFileSystem, 'GetFile',  @objFile OUT,@Filename
IF @hr=0 SELECT @errorMessage='getting the attributes of ''' + @Filename+'''', @ErrorObject=@objFile
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'Path', @path OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'ShortPath', @ShortPath OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'Type', @Type OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'DateCreated', @DateCreated OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'DateLastAccessed', @DateLastAccessed OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'DateLastModified', @DateLastModified OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'Attributes', @Attributes OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty @objFile, 'size', @size OUT

IF @hr<>0 BEGIN
	DECLARE 
		@Source VARCHAR(255),
        @Description VARCHAR(255),
        @Helpfile VARCHAR(255),
        @HelpID INT
       
       EXECUTE sp_OAGetErrorInfo  @errorObject, @source output,@Description output, @Helpfile output,@HelpID output

       SELECT @ErrorMessage='Error whilst ' + @Errormessage+', ' +@Description
       RAISERROR (@ErrorMessage,16,1)
       END
EXEC sp_OADestroy @objFileSystem
EXEC sp_OADestroy @objFile
SELECT [Path]=  @Path,
       [ShortPath]=    @ShortPath,
       [Type]= @Type,
       [DateCreated]=  @DateCreated ,
       [DateLastAccessed]=     @DateLastAccessed,
       [DateLastModified]=     @DateLastModified,
       [Attributes]=   @Attributes,
       [size]= @size
RETURN @hr

SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT OFF

END
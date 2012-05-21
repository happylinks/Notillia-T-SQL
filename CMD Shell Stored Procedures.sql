--Database
USE muziekdatabase;
GO

/**
*	The procedure procExecuteCMDShell executes an cmd commmando. 
*	@Commando	The commando to execute.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procExecuteCMDShell (@Commando VARCHAR(8000), @return BIT OUTPUT) AS BEGIN
	EXECUTE Notillia.procEnableXP_CMDShell;
	SET @Commando = Notillia.foPrepareCMDContent(@Commando);
	EXECUTE @return = MASTER.dbo.xp_cmdshell @Commando;
	EXECUTE Notillia.procDisableXP_CMDShell;
	
	RETURN @return;
END
GO

/**
*	The procedure procCreateFolderWithCMD creates an folder.
*	@Location the location to create the folder.
*	@Location the location to save.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procCreateFolderWithCMD(@FolderName VARCHAR(128), @Location VARCHAR(255), @Return BIT OUTPUT) AS BEGIN
	SET @Location = Notillia.foPrepareLocation(@Location);
	
	DECLARE @Commando VARCHAR(8000);
	SET @Commando = 'mkdir ' + @Location + @FolderName;
	
	EXECUTE Notillia.procExecuteCMDShell @Commando = @Commando, @return = @return OUTPUT;
	
	RETURN @Return;
END
GO
	
/**
*	The procedure procCreateFileWithCMD creates an file with specific content.
*	@Content the content of the file.
*	@Location the location to save.
*	@FileName the name of the file to create.
*	@Extension the file's extension.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procCreateFileWithCMD(@Content NVARCHAR(MAX), @Location VARCHAR(255), @FileName VARCHAR(255), @Extension VARCHAR(6), @Return BIT OUTPUT) AS BEGIN
	SET @Content = Notillia.foEscapeString(@Content);
	SET @Location = Notillia.foPrepareLocation(@Location);
	
	DECLARE @Commando VARCHAR(8000);
	SET @Commando = 'echo ' + @Content + ' > ' + @Location + @FileName + @Extension;
	
	EXECUTE Notillia.procExecuteCMDShell @Commando = @Commando, @Return = @Return OUTPUT;
	
	RETURN @Return;
END
GO

/**
*	The function ReadFileWithCMD tries to read a file useing cmd.
*	@Location	The location to find the file.
*	@Filename	The file's filename.
*	@Extension	The file's extension.
*	@Return		0 = failed, 1 = succeeded.
**/
CREATE PROCEDURE Notillia.procReadFileWithCMD(@Location VARCHAR(255), @FileName VARCHAR(255), @Extension VARCHAR(6), @Return NVARCHAR(MAX)) AS BEGIN
	SET @Location = Notillia.foPrepareLocation(@Location);
	
	DECLARE @Commando VARCHAR(MAX);
	SET @Commando = 'type ' + @Location + @FileName + @Extension;
	
	EXECUTE Notillia.procExecuteCMDShell @Commando = @Commando, @Return = @Return OUTPUT;
	
	RETURN @Return;
END

--EXECUTE Notillia.procCreateFileWithCMD @Content = 'Kaas', @Location = '/', @FileName = 'Kaas', @Extension = '.txt', @Return = 0;
--EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'Kaas', @Location = 'C:\', @return = 0;
--EXECUTE Notillia.procReadFileWithCMD @Location = 'C:\', @FileName = 'Kaas', @Extension = '.php', @Return = 0
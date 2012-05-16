--Database
USE muziekdatabase;
GO

--Mainloop
CREATE PROCEDURE Notillia.procStartGeneration AS BEGIN
	EXECUTE Notillia.procGenerateMySQL;
	EXECUTE Notillia.procGeneratePHPWebApplication;
END
GO

EXECUTE Notillia.procStartGeneration;
GO

--CREATE PROCEDURE Notillia.procGenerateMySQL AS BEGIN
--	PRINT 'Some MYSQL Code.';
--END
--GO

ALTER PROCEDURE Notillia.procGeneratePHPWebApplication AS BEGIN
	DECLARE @ProjectName VARCHAR(MAX); SELECT @ProjectName = Notillia.foGetProjectName();
	EXECUTE Notillia.procGenerateProjectFolders @ProjectName = @ProjectName, @Location = 'C:\';
END
GO

/**
*	The function foGetProjectName returns the databasename of the current project.
**/
CREATE FUNCTION Notillia.foGetProjectName() RETURNS VARCHAR(MAX) AS BEGIN
	DECLARE @ProjectName VARCHAR(MAX); SET @ProjectName = '';
	IF EXISTS (SELECT 1 FROM Notillia.Tables t WHERE t.[Schema] = 'dbo') BEGIN
		SELECT TOP 1 @ProjectName = t.[Database] FROM Notillia.Tables t WHERE t.[Schema] = 'dbo';
	END ELSE BEGIN
		SELECT TOP 1 @ProjectName = t.[Database] FROM Notillia.Tables t
 	END
	RETURN @ProjectName
END
GO

/**
*	The procedure procGenerateProjectFolders will generate the start folder(s).
*	@ProjectName	The name of the project, will be the root folder.
*	@Location		The location to save the folder(s).
**/
CREATE PROCEDURE Notillia.procGenerateProjectFolders(@ProjectName VARCHAR(MAX), @Location VARCHAR(MAX)) AS BEGIN
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = @ProjectName, @Location = @Location, @Return = 0;
	
	DECLARE @RootFolderPath VARCHAR(MAX); SET @RootFolderPath = @Location + @ProjectName + '\';
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'app', @Location = @RootFolderPath, @Return = 0;
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'config', @Location = @RootFolderPath, @Return = 0;
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'tmp', @Location = @RootFolderPath, @Return = 0;
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'lib', @Location = @RootFolderPath, @Return = 0;
	
	DECLARE @AppFolderPath VARCHAR(MAX); SET @AppFolderPath = @RootFolderPath + 'app\';
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'Controllers', @Location = @AppFolderPath, @Return = 0; 
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'Views', @Location = @AppFolderPath, @Return = 0; 
	EXECUTE Notillia.procCreateFolderWithCMD @FolderName = 'webroot', @Location = @AppFolderPath, @Return = 0; 
END
GO

CREATE TABLE Notillia.Folders (
	Name		VARCHAR(64)		NOT NULL,
	[Master]	VARCHAR(64)		NOT NULL,
	
	CONSTRAINT PK_NOTILLIA_FOLDERS PRIMARY KEY (Name, [Master])		
);
GO

CREATE TABLE Notillia.FrameworkTextFiles (
	Name			VARCHAR(128)	NOT NULL,
	Extension		VARCHAR(9)		NOT NULL,
	FolderName		VARCHAR(64)		NOT NULL,
	FolderMaster	VARCHAR(64)		NOT NULL,
	TextFile		TEXT			NOT NULL,
	
	CONSTRAINT PK_NOTILLIA_FRAMEWORKTEXTFILES PRIMARY KEY (Name, Extension, FolderName, FolderMaster),
	CONSTRAINT FK_NOTILLIA_FRAMEWORKTEXTFILES_FOLDERS FOREIGN KEY (FolderName, FolderMaster)
		REFERENCES Notillia.Folders (Name, [Master]) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE TABLE Notillia.FrameworkMediaFiles (
	Name			VARCHAR(128)	NOT NULL,
	Extension		VARCHAR(9)		NOT NULL,
	FolderName		VARCHAR(64)		NOT NULL,
	FolderMaster	VARCHAR(64)		NOT NULL,
	MediaFile		VARBINARY(MAX)	NOT NULL,				
	
	CONSTRAINT PK_NOTILLIA_FRAMEWORKMEDIAFILES PRIMARY KEY (Name, Extension, FolderName, FolderMaster),
	CONSTRAINT FK_NOTILLIA_FRAMEWORKMEDIAFILES_FOLDERS FOREIGN KEY (FolderName, FolderMaster)
		REFERENCES Notillia.Folders (Name, [Master]) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

CREATE TABLE Notillia.GenerateTextFiles (
	Name			VARCHAR(128)	NOT NULL,
	Extension		VARCHAR(9)		NOT NULL,
	FolderName		VARCHAR(64)		NOT NULL,
	FolderMaster	VARCHAR(64)		NOT NULL,
	TextFile		TEXT			NOT NULL,
	
	CONSTRAINT PK_NOTILLIA_GENERATETEXTFILES PRIMARY KEY (Name, Extension, FolderName, FolderMaster),
	CONSTRAINT FK_NOTILLIA_GENERATETEXTFILES_FOLDERS FOREIGN KEY (FolderName, FolderMaster)
		REFERENCES Notillia.Folders (Name, [Master]) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

INSERT INTO Notillia.Folders (Name, [Master]) 
VALUES ('{#PROJECTNAME#}', ''),
	   ('app', '{#PROJECTNAME#}'),
	   ('config', '{#PROJECTNAME#}'),
	   ('tmp', '{#PROJECTNAME#}'),
	   ('lib', '{#PROJECTNAME#}'),
	   ('Controllers', 'app'),
	   ('Views', 'app'),
	   ('webroot', 'app'),
	   ('css', 'webroot'),
	   ('img', 'webroot'),
	   ('js', 'webroot'),
	   ('less', 'webroot')
	   
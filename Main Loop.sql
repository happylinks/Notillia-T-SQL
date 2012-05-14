--Database
USE muziekdatabase;
GO

--Mainloop
CREATE PROCEDURE Notillia.procStartGeneration AS BEGIN
	EXECUTE Notillia.procGenerateMySQL;
	EXECUTE Notillia.procGeneratePHPWebApplication;
END
GO

EXECUTE Notillia.procStartGeneration

--CREATE PROCEDURE Notillia.procGenerateMySQL AS BEGIN
--	PRINT 'Some MYSQL Code.';
--END
--GO

--CREATE PROCEDURE Notillia.procGeneratePHPWebApplication AS BEGIN
--	PRINT 'Some PHP Webapplication.';
--END
--GO
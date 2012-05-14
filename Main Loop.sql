--Database
USE muziekdatabase;
GO

--Mainloop
CREATE PROCEDURE startGeneration AS BEGIN
	EXECUTE Notillia.GenerateMySQL;
	EXECUTE Notillia.GeneratePHPWebApplication;
END
GO

--CREATE PROCEDURE Notillia.GenerateMySQL AS BEGIN
--	PRINT 'Some MYSQL Code.';
--END
--GO

--CREATE PROCEDURE Notillia.GeneratePHPWebApplication AS BEGIN
--	PRINT 'Some PHP Webapplication.';
--END
--GO
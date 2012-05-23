USE muziekdatabase;
GO

--Create Databases
DECLARE @CreateDatabase VARCHAR(MAX); SET @CreateDatabase = '';
SELECT @CreateDatabase += 'CREATE DATABASE ' + sub.Clause + ';' + CHAR(10)
FROM (SELECT CASE t.[Schema] WHEN 'dbo' THEN '' ELSE t.[Schema] + '.' END + t.[Database] AS 'Clause' FROM Notillia.Tables t UNION
	  SELECT CASE v.[Schema] WHEN 'dbo' THEN '' ELSE v.[Schema] + '.' END + v.[Database] AS 'Clause' FROM Notillia.Views v) sub

PRINT @CreateDatabase;
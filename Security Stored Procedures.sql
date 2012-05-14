--Database
USE muziekdatabase;
GO

--Security Settings Functions
--OLE
CREATE PROCEDURE Notillia.procEnableOLEAutomationProcedures AS BEGIN
	EXECUTE sp_configure 'show advanced options', 1;
	RECONFIGURE;
	
	EXECUTE sp_configure 'Ole Automation Procedures', 1;
	RECONFIGURE;
END
GO

CREATE PROCEDURE Notillia.procDisableOLEAutomationProcedures AS BEGIN
	EXECUTE sp_configure 'Ole Automation Procedures', 0;
	RECONFIGURE;
	
	EXECUTE master.dbo.sp_configure 'show advanced options', 0;
	RECONFIGURE;
END
GO

--CMD_SHELL
CREATE PROCEDURE Notillia.procEnableXP_CMDShell AS BEGIN
	EXECUTE sp_configure 'show advanced options', 1;
	RECONFIGURE;
	
	EXECUTE sp_configure 'xp_cmdshell', 1;
	RECONFIGURE;
END
GO

CREATE PROCEDURE Notillia.procDisableXP_CMDShell AS BEGIN
	EXECUTE sp_configure 'xp_cmdshell', 0;
	RECONFIGURE;
	
	EXECUTE sp_configure 'show advanced options', 0;
	RECONFIGURE
END
GO

--Tests
--EXECUTE Notillia.EnableOLEAutomationProcedures;
--EXECUTE Notillia.DisableOLEAutomationProcedures;

--EXECUTE Notillia.EnableXP_CMDShell;
--EXECUTE Notillia.DisableXP_CMDShell;
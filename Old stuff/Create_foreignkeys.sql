
/*==============================================================*/
/* UDF: Notillia.fnGetMasterColumnsForForeignKey                */
/*		Creates a string with all Master columns. Separated     */
/*		by: ','.					    						*/
/*==============================================================*/

CREATE FUNCTION Notillia.fnGetMasterColumnsForForeignKey (@Schema VARCHAR(MAX), @Constraint_Name VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN
	DECLARE @Return VARCHAR(MAX); SET @Return = '';
	SELECT @Return += '`' + Master_Column + '`,' 
	FROM Notillia.ForeignKeyColumns fkc 
	WHERE fkc.Constraint_Name = @Constraint_Name AND fkc.[Schema] = @Schema
	ORDER BY fkc.Master_Column, fkc.Child_Column DESC
	SET @Return = LEFT(@Return, LEN(@Return) - 1);
	RETURN @Return;
END
GO

/*==============================================================*/
/* UDF: Notillia.fnGetChildColumnsForForeignKey                 */
/*		Creates a string with all Child columns. Separated      */
/*		by: ','.												*/
/*==============================================================*/
CREATE FUNCTION Notillia.fnGetChildColumnsForForeignKey (@Schema VARCHAR(MAX), @Constraint_Name VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN
	DECLARE @Return VARCHAR(MAX); SET @Return = '';
	SELECT @Return += '`' + Child_Column + '`,' 
	FROM Notillia.ForeignKeyColumns fkc 
	WHERE fkc.Constraint_Name = @Constraint_Name AND fkc.[Schema] = @Schema
	ORDER BY fkc.Master_Column, fkc.Child_Column DESC
	SET @Return = LEFT(@Return, LEN(@Return) - 1);
	RETURN @Return;
END
GO

/*==============================================================*/
/* PROC: Notillia.createMysqlFkFile                             */
/*		Creates a MySQL Foreign key file and writes it to the   */
/*		C:\ directory				    						*/
/*==============================================================*/

ALTER PROCEDURE Notillia.createMysqlFkFile
AS
BEGIN
	DECLARE @String VARCHAR(MAX); SET @String = '';
	SELECT	@String += 'ALTER TABLE `' + FK.Master_Table + '`' + CHAR(10) + 
				CHAR(9) + ' ADD CONSTRAINT ' + FK.Constraint_Name + ' FOREING KEY (' + Notillia.fnGetMasterColumnsForForeignKey (FK.[Schema], FK.Constraint_Name) + ') ' + CHAR(10) + 
					CHAR(9) + CHAR(9) + 'REFERENCES `' + FK.Child_Table + '` (' + Notillia.fnGetChildColumnsForForeignKey (FK.[Schema], FK.Constraint_Name) + ')' + CHAR(10) + 
						CHAR(9) + CHAR(9) + CHAR(9) + ' ON UPDATE ' + FK.Update_Rule + CHAR(10) + 
						CHAR(9) + CHAR(9) + CHAR(9) + ' ON DELETE	' + FK.Delete_Rule + CHAR(10) +
						';' + CHAR(10) + CHAR(10)
					FROM Notillia.Foreignkeys FK
	PRINT @String;
	EXECUTE Notillia.procWriteStringToFile @String,'C:\','fk.sql'
END
GO


/*==============================================================*/
EXECUTE Notillia.createMysqlFkFile
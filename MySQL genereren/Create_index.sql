CREATE PROCEDURE Notillia.createIndexFk
AS
BEGIN

DECLARE @index VARCHAR(2000)
SET @index = ''

SELECT @index += 'CREATE INDEX FK_' + sub.[table] + '_' + sub.[column] + CHAR(10)+
					CHAR(9) + 'ON ' + sub.[table] + ' (' + sub.[column] + ');' + CHAR(10) + CHAR(10)
	FROM (	SELECT Master_Table AS 'table',Master_Column AS 'column' FROM Notillia.ForeignKeyColumns
				GROUP BY Master_Table,Master_Column
				UNION
			SELECT Child_Table AS 'table',Child_Column AS 'column' FROM Notillia.ForeignKeyColumns
				GROUP BY Child_Table,Child_Column ) sub
	WHERE EXISTS(	SELECT ncc.Table_Name, ncc.Column_Name FROM Notillia.ConstraintColumns ncc
						INNER JOIN Notillia.PrimaryKeys npk
							ON ncc.Constraint_Name = npk.Constraint_Name
						WHERE ncc.Column_Name = sub.[column] AND ncc.Table_Name = sub.[table])

PRINT(@index)
END

EXECUTE Notillia.createIndexFk
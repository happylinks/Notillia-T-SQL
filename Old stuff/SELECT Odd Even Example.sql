USE muziekdatabase;
GO

--SELECT * FROM Notillia.Columns;
--SELECT * FROM Notillia.ConstraintColumns;
--SELECT * FROM Notillia.Domains;
--SELECT * FROM Notillia.ForeignKeyColumns;
--SELECT * FROM Notillia.ForeignKeys;
--SELECT * FROM Notillia.PrimaryKeys;
--SELECT * FROM Notillia.Tables;
--SELECT * FROM Notillia.Uniques;
--SELECT * FROM Notillia.Views;

--<tr>
--	<th><span class="tiptop" title="integer">stuknr</span></th><td name="stuknr"></td>
--	<th><span class="tiptop" title="integer">componistId</span></th><td name="componistId"></td>
--</tr>
--<tr>
--	<th><span class="tiptop" title="string">titel</span></th><td name="titel"></td>
--	<th><span class="tiptop" title="integer">stuknrOrigineel</span></th><td name="stuknrOrigineel"></td>
--</tr>
--<tr>
--	<th><span class="tiptop" title="string">genrenaam</span></th><td name="genrenaam"></td>
--	<th><span class="tiptop" title="char">niveaucode</span></th><td name="niveaucode"></td>
--</tr>
--<tr>
--	<th><span class="tiptop" title="integer">speelduur</span></th><td name="speelduur"></td>
--	<th><span class="tiptop" title="integer">jaartal</span></th><td name="jaartal"></td>
--</tr>

SELECT CASE d.RowNumber % 2 
			WHEN 1 THEN '<tr><th><span class="tiptop" title="' + d.Data_Type + '">' + d.Column_Name + '</span></th><td name="' + d.Column_Name + '"></td>'
			WHEN 0 THEN '<th><span class="tiptop" title="' + d.Data_Type + '">' + d.Column_Name + '</span></th><td name="' + d.Column_Name + '"></td></tr>' ELSE 'ERROR' END
		AS 'Case', 1, 1, 1, 1, 1
FROM( SELECT c.Column_Name, c.Data_Type, ROW_NUMBER() OVER(ORDER BY c.[Schema], c.[Database], c.[Table_Name], c.[Column_Name] DESC) AS 'RowNumber'
	  FROM Notillia.Columns c
	  WHERE c.[Schema] = 'dbo' AND c.[Database] = 'muziekdatabase' AND c.Table_Name = 'Stuk'
) d
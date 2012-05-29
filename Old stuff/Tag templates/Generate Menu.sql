USE muziekdatabase;
GO

--<li><a href="<?php echo WWW_BASE_PATH ?>stuk/">Stuk</a></li>

SELECT '<li><a href="<?php echo WWW_BASE_PATH ?>' + t.Table_Name + '/">' + t.Table_Name + '</a></li>'
FROM Notillia.Tables t
WHERE t.Table_Name IN (SELECT TOP 5 fk.Master_Table FROM Notillia.ForeignKeys fk GROUP BY fk.Master_Table ORDER BY COUNT(fk.Master_Table) DESC, fk.Master_Table ASC)
UNION ALL
SELECT '<li><a href="<?php echo WWW_BASE_PATH ?>' + t.Table_Name + '/">' + t.Table_Name + '</a></li>'
FROM Notillia.Tables t
WHERE t.Table_Name NOT IN (SELECT TOP 5 fk.Master_Table FROM Notillia.ForeignKeys fk GROUP BY fk.Master_Table ORDER BY COUNT(fk.Master_Table) DESC, fk.Master_Table ASC)


/**  -----------------------------------------------------------------
  *			Template Data
  */ -----------------------------------------------------------------
DELETE FROM Notillia.Tags;
DELETE FROM Notillia.Templates;

INSERT INTO Notillia.Templates
VALUES (
		'test',
		'Testing templating',
		'/BLABLA TEMPLATE {{columnoptions}} BLABLA TEMPLATE/',
		'app\Views\{{TableName}}',
		'index.html'
		),
		(
		'controllerTest',
		'Testing templating',
		'/BLABLA TEMPLATE {{columnoptions}} BLABLA TEMPLATE/',
		'app\Controller',
		'{{TableName}}.php'
		);
INSERT INTO Notillia.Tags
VALUES (
		'test',
		'columnoptions',
		'Option tags for each column',
		'{{columnoptions}}',
		'<option value="{{notillia_2}}">{{notillia_1}}</option>',
		'SELECT Column_Name,Table_Name,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}'''
		),
		(
		'controllerTest',
		'columnoptions',
		'Option tags for each column',
		'{{columnoptions}}',
		'<option value="{{notillia_2}}">{{notillia_1}}</option>',
		'SELECT Column_Name,Table_Name,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}'''
		);

/**  -----------------------------------------------------------------
  *			END OF TEST DATA



  HIERNA GENEREREN UITVOEREN EN KIJKEN DAT ER MAPPEN UITKOMEN.
  */ -----------------------------------------------------------------

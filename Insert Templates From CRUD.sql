--Database(s) and schema(s):
USE muziekdatabase;
GO

DROP TABLE Notillia.Tags;
DROP TABLE Notillia.Templates;


/**
	*	Template table with all the templates for the CRUD application
	*/
CREATE TABLE Notillia.Templates(
	name		varchar(25)		not null,
	description varchar(120)	not null,
	source		text			not null,
	path		varchar(255)	not null,
	filename	varchar(50)		not null,
	constraint PK_templates primary key  (name),
);
/**
	*	Tag table, contains all the replacement tags for an certain template.
	*/
CREATE TABLE Notillia.Tags(
	id				bigint			not null	IDENTITY(1,1),
	template_name	varchar(25)		not null,
	name			varchar(25)		not null,
	description		varchar(120)	not null,
	tag				varchar(40)		not null,
	source			text			not null,
	query			varchar(max)	not null,
	beforeResult	varchar(max)	null,
	afterResult		varchar(max)	null,
	constraint PK_tags primary key  (template_name,name),
	constraint FK_template foreign key(template_name) REFERENCES Notillia.Templates(name) ON UPDATE NO ACTION ON DELETE NO ACTION
);


/*
 * Delete all current information
 */
DELETE FROM Notillia.Tags;
DELETE FROM Notillia.Templates;

-- SET IDENTITY_INSERT Notillia.Tags ON

/*
 * Insert all templates and information.
 * You can use {{TableName}} in path or filename to represent the current name.
 */
INSERT INTO Notillia.Templates
VALUES (
		'HTML Table Layout',
		'Contains the view (HTML) layout of each table.',
		'Hier komt de table header voor grid:
		{{TableHeader}}

		Hier komt Detail view:
		{{DetailColumns}}
		
		Hier komen alle Control groups:
		{{ControlGroups}}

		Hier komen alle children tabs:
		{{ChildrenTabs}}

		Hier komt een child(ren):
		{{child}}

		',
		'app\Views\{{TableName}}',
		'index.html'
		/*
		),
		(
		'PHP Table Controller',
		'Contains all the SQL logic and serves data to the view.',
		'',
		'app\Controller',
		'{{TableName}}.php'
		*/
		);

INSERT INTO Notillia.Tags
	(template_name, name, description, tag, source, query, beforeResult, afterResult) 
VALUES (
		'HTML Table Layout',
		'TableHeader',
		'Give all columns including datatypes in an table header format.',
		'{{TableHeader}}',
		'<th contraint="{{notillia_3}}" name="{{notillia_1}}"><span class="tiptop" title="{{notillia_2}}">{{notillia_1}}</span></th>',
		'SELECT NC.Column_Name, NC.Data_Type,
		(SELECT ''pk'' FROM Notillia.ConstraintColumns NCC
		INNER JOIN Notillia.PrimaryKeys NP
		ON NP.Constraint_Name = NCC.Constraint_Name
		WHERE NP.Table_Name = NC.Table_Name
		AND NCC.Column_Name = NC.Column_Name), 1, 1, 1
		FROM Notillia.Columns NC
		WHERE NC.table_name = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'DetailColumns',
		'Detail view voor alle kolommen.',
		'{{DetailColumns}}',
		'{{notillia_1}}',
		'SELECT CASE d.RowNumber % 2 
			WHEN 1 THEN ''<tr><th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td>''
			WHEN 0 THEN ''<th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td></tr>'' ELSE ''ERROR'' END
			AS ''Case'', 1, 1, 1, 1, 1
			FROM( SELECT c.Column_Name, c.Data_Type, ROW_NUMBER() OVER(ORDER BY c.[Schema], c.[Database], c.[Table_Name], c.[Column_Name] DESC) AS ''RowNumber''
				  FROM Notillia.Columns c
				  WHERE c.[Schema] = ''dbo'' AND c.[Database] = ''muziekdatabase'' AND c.Table_Name = ''{{TableName}}''
			) d ', '', ''
		),
		(
		'HTML Table Layout',
		'ChildrenTabs',
		'Create tabs for each child.',
		'{{ChildrenTabs}}',
		'<li name="{{notillia_1}}"><a href="#">{{notillia_1}}</a></li>',
		'SELECT Child_Table,1,1,1,1,1 FROM Notillia.ForeignKeyColumns WHERE Master_Table = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'ControlGroups',
		'Create control groups (Forms) for each column.',
		'{{ControlGroups}}',
		'<div class="control-group">
			<label for="stuknr" class="control-label">
				<span class="tipleft" title="{{notillia_2}}">{{notillia_1}}</span></label>
				<div class="controls">
				<input class="required" type="{{notillia_2}}" id="input_{{notillia_1}}" name="{{notillia_1}}" value=""/>
			</div>
		 </div>',
		'SELECT Column_Name,Data_Type,1,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'Child',
		'Create an GRID and detail view for each Child.',
		'{{child}}',
		'',
		'SELECT NFK.Child_Table,1,1,1,1,1
		 FROM Notillia.ForeignKeys NFK
		 INNER JOIN Notillia.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.Master_Table = ''{{TableName}}''', '', ''
		);
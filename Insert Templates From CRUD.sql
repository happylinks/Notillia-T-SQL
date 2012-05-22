--Database(s) and schema(s):
USE muziekdatabase;
GO


BEGIN TRY
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
		template_name varchar(25)	not null,
		name		varchar(25)		not null,
		description varchar(120)	not null,
		tag			varchar(40)		not null,
		source		text			not null,
		query		varchar(max)	not null,
		constraint PK_tags primary key  (template_name,name),
		constraint FK_template foreign key(template_name) REFERENCES Notillia.Templates(name) ON UPDATE NO ACTION ON DELETE NO ACTION
	);
END TRY
BEGIN CATCH
	RAISERROR ('Tabellen bestaan al!', 16, 1);
END CATCH

/*
 * Delete all current information
 */
DELETE FROM Notillia.Tags;
DELETE FROM Notillia.Templates;

/*
 * Insert all templates and information.
 * You can use {{TableName}} in path or filename to represent the current name.
 */
INSERT INTO Notillia.Templates
VALUES (
		'HTML Table Layout',
		'Contains the view (HTML) layout of each table.',
		'<table class="table table-striped table-bordered grid master" name="grid" data:page="1" data:maxpage="1">
							<thead>
								<tr>
									{{TableHeader}}
								</tr>
							</thead>
							<tbody>
								<tr name="">
								</tr>
							</tbody>
						</table>',
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
VALUES (
		'HTML Table Layout',
		'TableHeader',
		'Give all columns including datatypes in an table header format.',
		'{{TableHeader}}',
		'<th name="{{notillia_1}}"><span class="tiptop" title="{{notillia_2}}">{{notillia_1}}</span></th>',
		'SELECT Column_Name,Data_Type,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}'''
		),
		(
		'HTML Table Layout',
		'ChildrenTabs',
		'Create tabs for each child.',
		'{{ChildrenTabs}}',
		'<li name="{{notillia_1}}"><a href="#">{{notillia_1}}</a></li>',
		'SELECT Child_Table,1,1,1,1 FROM Notillia.ForeignKeyColumns WHERE Master_Table = ''{{TableName}}'''
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
				<input class="required {{notillia_2}}" type="text" id="input_{{notillia_1}}" name="{{notillia_1}}" value=""/>
			</div>
		 </div>',
		'SELECT Column_Name,Data_Type,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}'''
		/*),
		(
		'controllerTest',
		'columnoptions',
		'Option tags for each column',
		'{{columnoptions}}',
		'<option value="{{notillia_2}}">{{notillia_1}}</option>',
		'SELECT Column_Name,Table_Name,1,1,1 FROM Notillia.Columns WHERE table_name = ''{{TableName}}'''
		*/
		);
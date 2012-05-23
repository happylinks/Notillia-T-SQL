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

		Hier children:
		{{children}}

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
		'{{notillia_1}}',
		'SELECT 
		''<div class=''''control-group''''>
		<label for='''''' + c.Column_Name + '''''' class=''''control-label''''><span class=''''tipleft'''' title='''''' + c.Data_Type + ''''''>'' + c.Column_Name + ''</span></label>
		<div class=''''controls''''>'' + CHAR(10) + 
		CASE c.IS_NULLable WHEN ''YES'' 
		THEN ''<div class="input-append">
		<input class='''''' + c.Data_Type + '''''' type=''''text'''' name='''''' + c.Column_Name + '''''' value='''''''' style="width:174px;" class=''''hasnull''''/>
		<span class="addon-on"><input class=''''null tiptop'''' title=''''NULL'''' type="checkbox" name="null_'' + c.Column_Name + ''" checked=''''true''''/></span>
		</div>'' + CHAR(10)
		ELSE ''<input class='''''' + c.Data_Type + '''''' type=''''text'''' name='''''' + c.Column_Name + '''''' value='''''''' />'' + CHAR(10) END +
		''</div>'' + CHAR(10) + ''</div>'' + CHAR(10), 1, 1, 1, 1, 1
		FROM Notillia.Columns c
		WHERE c.[Schema] = ''dbo'' AND c.[Database] = ''muziekdatabase'' AND c.Table_Name = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'Child',
		'Create an GRID and detail view for each Child.',
		'{{children}}',
		'<!-- CHILD -->
			<div name="stuk" class="item child grid">
				<div class="head">
					<h2>{{notillia_1}}</h2><h6>{{ChildForeignKey={{notillia_1}}}}</h6>
					<span class="buttons">
						<!-- GENERATE BUTTONS HERE-->
							<a name="save" class="btn btn-mini btn-success tip" title="Save"><i class="icon icon-ok icon-white"></i></a>
							<a name="cancel" class="btn btn-mini btn-danger tip" title="Cancel"><i class="icon icon-remove icon-white"></i></a>
							&nbsp;&nbsp; 
							<a name="add" class="btn btn-mini btn-success tip" title="Add"><i class="icon icon-plus icon-white"></i></a>
							<a name="edit" class="btn btn-mini btn-warning tip" title="Edit"><i class="icon icon-edit icon-white"></i></a>
							<a name="del"class="btn btn-mini btn-danger tip" title="Delete"><i class="icon icon-trash icon-white"></i></a>
							&nbsp;&nbsp; 
							<a name="search" class="btn btn-mini tip" title="Search"><i class="icon icon-search"></i></a>
							<a name="tableoptions" class="btn btn-mini tip" title="Table Options"><i class="icon icon-filter"></i></a>
							<a name="generateExcel" class="btn btn-mini tip" title="Generate Excel"><li class="icon icon-file"></li></a>
							<a name="switchview" class="btn btn-mini tip" title="Switch View"><i class="icon icon-th-list"></i></a>
						<!--/GENERATE BUTTONS HERE-->
					</span>
					<span class="inline-search">
						<form class="search pull-right dropdown">
							<div class="controls input-prepend input-append inline-search">
								<input type="text" placeholder="Search"/>
								<select class="span2" name="fields">
									<option value="all">All</option>
								</select>
								<button class="btn btn-success">
									<i class="icon icon-search"></i>
								</button>
							</div>
						</form> 
					</span>
					<span class="tableoptions">
						<form class="pull-right">
							<div class="input-prepend">
			                	<span class="add-on">Limit</span><input type="text" size="16" id="prependedInput" class="input-mini" value="10">
			              	</div>
			              	<a class="btn btn-primary" type="submit">Set</a>
			            </form>
					</span>
				</div>
				<br/>
				<div class="row-fluid">
					<div class="span12">
						<table class="table table-striped table-bordered grid child" name="grid" data:page="1" data:maxpage="1">
							<thead>
								<tr>
									{{ChildTableHeader={{notillia_1}}}}
								</tr>
							</thead>
							<tbody>
								<tr name="">
								</tr>
							</tbody>
						</table>
						<table class="table detail child" name="detail">
							<tbody>
									{{DetailColumns={{notillia_1}}}}
							</tbody>
						</table>
						<div class="pagination" style="text-align:right;">
							<ul>
								<li name="backward"><a>&nbsp;<i class="icon icon-step-backward"></i></a></li>
								<li name="left"><a>&nbsp;<i class="icon icon-chevron-left"></i></a></li>
								<li name="text"></li>
								<li name="right"><a>&nbsp;<i class="icon icon-chevron-right"></i></a></li>
								<li name="forward"><a>&nbsp;<i class="icon icon-step-forward"></i></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!--/CHILD -->',
		'SELECT NFK.Child_Table,1,1,1,1,1
		 FROM Notillia.ForeignKeys NFK
		 INNER JOIN Notillia.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.Master_Table = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'ChildForeignKey',
		'Create an simple list of foreign keys that tells how the child is connected to the master.',
		'{{ChildForeignKey}}',
		'{{notillia_1}}, ',
		'SELECT Master_Column,1,1,1,1,1 FROM Notillia.ForeignKeyColumns WHERE Child_Table = ''{{ParameterTag}}'' AND Master_Table = ''{{TableName}}''', 
		'', 
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -2));
			END
		'),
		(
		'HTML Table Layout',
		'ChildTableHeader',
		'Give all columns including datatypes in an table header format of a child.',
		'{{ChildTableHeader}}',
		'<th contraint="{{notillia_3}}" name="{{notillia_1}}"><span class="tiptop" title="{{notillia_2}}">{{notillia_1}}</span></th>',
		'SELECT NC.Column_Name, NC.Data_Type,
		(SELECT ''pk'' FROM Notillia.ConstraintColumns NCC
		INNER JOIN Notillia.PrimaryKeys NP
		ON NP.Constraint_Name = NCC.Constraint_Name
		WHERE NP.Table_Name = NC.Table_Name
		AND NCC.Column_Name = NC.Column_Name), 1, 1, 1
		FROM Notillia.Columns NC
		WHERE NC.table_name = ''{{ParameterTag}}''', '', ''
		),
		(
		'HTML Table Layout',
		'ChildDetailColumns',
		'Detail view voor alle kolommen in een child.',
		'{{ChildDetailColumns}}',
		'{{notillia_1}}',
		'SELECT CASE d.RowNumber % 2 
			WHEN 1 THEN ''<tr><th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td>''
			WHEN 0 THEN ''<th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td></tr>'' ELSE ''ERROR'' END
			AS ''Case'', 1, 1, 1, 1, 1
			FROM( SELECT c.Column_Name, c.Data_Type, ROW_NUMBER() OVER(ORDER BY c.[Schema], c.[Database], c.[Table_Name], c.[Column_Name] DESC) AS ''RowNumber''
				  FROM Notillia.Columns c
				  WHERE c.[Schema] = ''dbo'' AND c.[Database] = ''muziekdatabase'' AND c.Table_Name = ''{{ParameterTag}}''
			) d ', '', ''
		);
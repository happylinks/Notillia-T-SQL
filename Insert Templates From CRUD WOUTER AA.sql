--Database(s) and schema(s):
USE muziekdatabase;
GO

--DROP TABLE Notillia.Tags;
--DROP TABLE Notillia.Templates;
--GO

DECLARE @PHPController NVARCHAR(MAX) = '
<?php
class {{TableName}}Controller extends WebpageController{

	public function __construct() {
		parent::__construct();
	}

	public function actionIndex() {
		$this -> loadView( ''{{TableName}}/index'' );
	}

	public function actionRecord() {
		if ( isset( $_POST ) ) {
			$page = ( isset( $_POST[''page''] ) && is_numeric( $_POST[''page''] ) ) ? $_POST[''page''] : 1;
			$limit = ( isset( $_POST[''limit''] ) && is_numeric( $_POST[''limit''] ) ) ? $_POST[''limit''] : DefaultLimit;
			$offset = ( $page-1 )*$limit;
			$data = array();

			$query = "SELECT {{AllColumns}}, (SELECT COUNT(1) FROM `{{TableName}}`) as ''notillia.totalrecords''
			FROM `{{TableName}}` ";

			switch ( @$_POST[''navigation''] ) {
				case -2:
					$query .= "ORDER BY {{AllPkColumns}} ASC";
					$offset = 0;
					break;
				case -1:
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE {{PKSmallerClause}} ORDER BY  {{AllPkColumns}} DESC";
						$data = $this -> createPKColumnArray( $_POST[''where''] );
						$offset = 1;
					}
					break;
				case 1:
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE {{PKBiggerClause}} ORDER BY  {{AllPkColumns}} ASC";
						$data = $this -> createPKColumnArray( $_POST[''where''] );
						$offset = 1;
					}
					break;
				case 2:
					$query .= "ORDER BY {{AllPkColumns}} DESC ";
					$offset = 0;
					break;
				default:
					// Invalid number specified
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE {{PKEqualClause}} ORDER BY  {{AllPKColumns}} ASC";
						$data = $this -> createPKColumnArray( $_POST[''where''] );
					}
					break;
			}
			$query .= " LIMIT :limit OFFSET :offset";

			$result = $this -> DB -> select( $query, $data, $limit, $offset );

			$this -> setVar( ''data'', $this -> giveJSONRecordData( $result, $limit ) );
		} else {
			$this -> setVar( ''data'', false );
		}
		$this -> loadView( ''json'' );
	}

	public function actionChildGrid() {
		if ( isset( $_POST ) ) {
			$page = ( isset( $_POST[''page''] ) && is_numeric( $_POST[''page''] ) ) ? $_POST[''page''] : 1;
			$limit = ( isset( $_POST[''limit''] ) && is_numeric( $_POST[''limit''] ) ) ? $_POST[''limit''] : DefaultLimit;
			$offset = ( $page-1 )*$limit;
			$child = @$_POST[''child''];
			$data = array();
			switch ( $child ) {
				case ''stuk'':
					$query = "SELECT s2.`stuknr`, s2.`componistId`, s2.`titel`, s2.`stuknrOrigineel`, s2.`genrenaam`, s2.`niveaucode`, s2.`speelduur`, s2.`jaartal`, (
					SELECT COUNT(*) FROM (
					SELECT 1
					FROM `Stuk` s3
					INNER JOIN `Stuk` s4 ON s3.`stukNrOrigineel` = s4.`stuknr`
					";
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE s4.`stuknr` = :column_stuknrOrigineel ";
						$data = $this -> createFKColumnArray( $_POST[''where''], $child );
					}
					$query .= "
					GROUP BY s4.`stuknr`
					) AS subQuery
					) AS ''notillia.totalrecords''
					FROM `Stuk` s
					INNER JOIN `Stuk` s2
					ON s.`stukNrOrigineel` = s2.`stuknr`";
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE s2.`stuknr` = :column_stuknrOrigineel ";
						$data = $this -> createFKColumnArray( $_POST[''where''], $child );
					}
					$query .= "GROUP BY s2.`Stuknr`
					LIMIT :limit
					OFFSET :offset";
					break;
				case ''bezettingsregel'':
					$query = "SELECT b.`stuknr`, b.`instrumentnaam`, b.`toonhoogte`, b.`aantal`, (
					SELECT COUNT(*)
					FROM(
					SELECT 1
					FROM `Bezettingsregel` b
					INNER JOIN `Stuk` s
					ON b.`stuknr` = s.`stuknr`";
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE s.`stuknr` = :column_stuknr ";
						$data = $this -> createFKColumnArray( $_POST[''where''], $child );
					}
					$query .= "GROUP BY b.`stuknr`,b.`instrumentnaam`,b.`toonhoogte`
					) AS subQuery
					) AS ''notillia.totalrecords''
					FROM `Bezettingsregel` b
					INNER JOIN `Stuk` s
					ON b.`stuknr` = s.`stuknr`";
					if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
						$query .= "WHERE s.`stuknr` = :column_stuknr ";
						$data = $this -> createFKColumnArray( $_POST[''where''], $child );
					}
					$query .= "GROUP BY b.`stuknr`,b.`instrumentnaam`,b.`toonhoogte`
					ORDER BY b.`stuknr`,b.`instrumentnaam`,b.`toonhoogte` ASC
					LIMIT :limit
					OFFSET :offset";
					break;
				default:
					// give JSON and abort function call
					$this -> setVar( ''data'', false );
					$this -> loadView( ''json'' );
					return false;
					break;
			}
			$result = $this -> DB -> select( $query, $data, $limit, $offset );

			$this -> setVar( ''data'', $this -> giveJSONRecordData( $result, $limit ) );
		} else {
			$this -> setVar( ''data'', false );
		}
		$this -> loadView( ''json'' );
	}

	/**
	 * Function that processes the raw SQL data to a JSON message for the client.
	 * Also cuts of the total records of the table, and sends it a seperate variable.
	 *
	 * @param Array   $result SQL array from PDO
	 */
	private function giveJSONRecordData( $result, $limit ) {
		if ( !empty( $result ) ) {
			if ( isset( $result[0] ) && is_array( $result[0] ) ) {
				foreach ( $result as $row ) {
					if ( is_array( $row ) ) {
						$totalrecords = $row[''notillia.totalrecords''];
						unset( $row[''notillia.totalrecords''] );
					}
					$return[] = $row;
				}
			}else { //If one row.
				$totalrecords = $result[''notillia.totalrecords''];
				unset( $result[''notillia.totalrecords''] );
				$return[0] = $result;
			}

			$maxpage = ceil( $totalrecords/$limit );
			$return[''maxpage''] = $maxpage;
			return $return;
		}else {
			return false;
		}
	}

	/**
	 * Action is called by Ajax /insert. Inserts a new record in this table.
	 */
	public function actionInsert() {
		if ( {{CheckPostAllColumns}}) {
			$data = $this -> createColumnArray( $_POST );
			$query = "INSERT INTO `{{TableName}}` ({{AllColumns}}) VALUES
			(:column_stuknr, :column_componistId, :column_titel, :column_stuknrOrigineel, :column_genrenaam, :column_niveaucode, :column_speelduur, :column_jaartal)";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, ''Record is inserted.'' );
			} else {
				$this -> giveJSONmessage( false, $statement[2] );
			}
		} else {
			$this -> giveJSONmessage( false, ''Parameters are incorrect.'' );
		}
		$this -> loadView( ''json'' );
	}

	/**
	 * Action is called by Ajax /update. Updates a record with parameters (old(only primary keys), new)
	 */
	public function actionUpdate() {
		if ( isset( $_POST[''old''][''stuknr''] ) &&
				/* All columns of the table. */
				isset( $_POST[''new''][''stuknr''] ) && isset( $_POST[''new''][''componistId''] ) && isset( $_POST[''new''][''titel''] ) && isset( $_POST[''new''][''stuknrOrigineel''] ) && isset( $_POST[''new''][''genrenaam''] ) && isset( $_POST[''new''][''niveaucode''] ) && isset( $_POST[''new''][''speelduur''] ) && isset( $_POST[''new''][''jaartal''] ) ) {
			$data_old = $this -> addArrayPrefix( $this -> createPKColumnArray( $_POST[''old''] ), ''old_'' );
			$data_new = $this -> addArrayPrefix( $this -> createColumnArray( $_POST[''new''] ), ''new_'' );
			$data = array_merge( $data_old, $data_new );

			$query = "UPDATE `{{TableName}}`
			SET `stuknr` = :new_column_stuknr,
			`componistId` = :new_column_componistId,
			`titel` = :new_column_titel,
			`stuknrOrigineel` = :new_column_stuknrOrigineel,
			`genrenaam` = :new_column_genrenaam,
			`niveaucode` = :new_column_niveaucode,
			`speelduur` = :new_column_speelduur,
			`jaartal` = :new_column_jaartal
			WHERE `stuknr` = :old_column_stuknr";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, ''Record is updated.'' );
			} else {
				$this -> giveJSONmessage( false, $statement[2] );
			}
		} else {
			$this -> giveJSONmessage( false, ''Parameters are incorrect.'' );
		}
		$this -> loadView( ''json'' );
	}

	/**
	 * Action is called by Ajax /delete. Deletes a record in the database.
	 */
	public function actionDelete() {
		if ( {{CheckPostAllPKColumns}}) {
			$data = $this -> createPKColumnArray( $_POST );
			$query = "DELETE FROM `{{TableName}}`
			WHERE {{AllPKColumnsWIthColumn_Prefix}}";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, ''Record is deleted.'' );
			} else {
				$this -> giveJSONmessage( false, $statement[2] );
			}
		} else {
			$this -> giveJSONmessage( false, ''Parameters are incorrect.'' );
		}
		$this -> loadView( ''json'' );
	}

	/**
	 * Create an column array for the PDO.
	 *
	 * @param Array   $data Array that contains the data
	 * @return Array       Array with column prefix and filtered array.
	 */
	private function createColumnArray( $data ) {
		$return = array();
		{{createColumnArray}}
		return $return;
	}

	/**
	 * Create an Primary key column array for the PDO.
	 *
	 * @param Array   $data Array that contains the data
	 * @return Array       Array with column prefix and filtered array.
	 */
	private function createPKColumnArray( $data ) {
		$return = array();
		{{createPKColumnArray}}
		return $return;
	}

	/**
	 * Create an Foreign key column array for the PDO.
	 *
	 * @param Array   $data Array that contains the data
	 * @return Array       Array with column prefix and filtered array.
	 */
	private function createFKColumnArray( $data, $child ) {
		$return = array();
		switch ( $child ) {
			case ''stuk'':
				$return[''column_stuknrOrigineel''] = @$data[''stuknrOrigineel''];
				break;
			case ''bezettingsregel'':
				$return[''column_stuknr''] = @$data[''stuknr''];
				break;
		}
		return $return;
	}

	/**
	 * Give a message that will indicate if the process is succeeded.
	 *
	 * @param boolean $code    succeeded
	 * @param String  $message Message to be displayed.
	 */
	private function giveJSONmessage( $code, $message ) {
		$this -> setVar( ''data'', array( ''code'' => (int)$code,
				''message'' => $message ) );
	}
}
?>';

/**
	*	Template table with all the templates for the CRUD application
	*/
--CREATE TABLE Notillia.Templates(
--	name		varchar(64)		not null,
--	description varchar(120)	not null,
--	source		text			not null,
--	path		varchar(255)	not null,
--	filename	varchar(50)		not null,
--	constraint PK_templates primary key  (name),
--);
--GO

--/**
--	*	Tag table, contains all the replacement tags for an certain template.
--	*/
--CREATE TABLE Notillia.Tags(
--	id				bigint			not null	IDENTITY(1,1),
--	template_name	varchar(64)		not null,
--	name			varchar(64)		not null,
--	description		varchar(120)	not null,
--	tag				varchar(40)		not null,
--	source			text			not null,
--	query			varchar(max)	not null,
--	beforeResult	varchar(max)	null,
--	afterResult		varchar(max)	null,
--	constraint PK_tags primary key  (template_name,name),
--	constraint FK_template foreign key(template_name) REFERENCES Notillia.Templates(name) ON UPDATE NO ACTION ON DELETE NO ACTION
--);
--GO

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
		),
		(
		'PHP Controller Layout',
		'Contains the controller (PHP) layout of each table.',
		@PHPController,
		'app\Controllers',
		'{{TableName}}.php'
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
				  WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''
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
		WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''', '', ''
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
				  WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''
			) d ', '', ''
		),
		(
		'PHP Controller Layout',
		'AllColumns',
		'All columns for a table',
		'{{AllColumns}}',
		'`{{notillia_1}}`, ',
		'SELECT c.Column_Name, 1, 1, 1, 1, 1
		 FROM Notillia.Columns c
		 WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -2));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk Columns',
		'All pk columns for a table',
		'{{AllPkColumns}}',
		'`{{notillia_1}}`, ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
		 FROM Notillia.ConstraintColumns cc
			LEFT JOIN Notillia.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -2));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk columns smaller',
		'All pk columns smaller',
		'{{PKSmallerClause}}',
		'{{notillia_1}}',
		'SELECT ''`'' + cc.Column_Name + ''` <= :column_'' + cc.Column_Name + '' AND '', 1, 1, 1, 1, 1
		 FROM Notillia.ConstraintColumns cc
			LEFT JOIN Notillia.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}'' 
		 ORDER BY cc.index_column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -5));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk columns bigger',
		'All pk columns bigger',
		'{{PKBiggerClause}}',
		'{{notillia_1}}',
		'SELECT ''`'' + cc.Column_Name + ''` >= :column_'' + cc.Column_Name + '' AND '', 1, 1, 1, 1, 1
		 FROM Notillia.ConstraintColumns cc
			LEFT JOIN Notillia.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}'' 
		 ORDER BY cc.index_column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -5));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk columns equal',
		'All pk columns equal',
		'{{PKEqualClause}}',
		'{{notillia_1}}',
		'SELECT ''`'' + cc.Column_Name + ''` = :column_'' + cc.Column_Name + '' AND '', 1, 1, 1, 1, 1
		 FROM Notillia.ConstraintColumns cc
			LEFT JOIN Notillia.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}'' 
		 ORDER BY cc.index_column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -5));
			END'
		),
		(
		'PHP Controller Layout',
		'All columns POST check',
		'All columns POST check',
		'{{CheckPostAllColumns}}',
		'{{notillia_1}}',
		'SELECT ''isset( $_POST['''''' + c.Column_Name + '''''']) && '', 1, 1, 1, 1, 1
		 FROM Notillia.Columns c
		 WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'AllColumsWithColumn_Prefix',
		'AllColumsWithColumn_Prefix',
		'{{AllColumnsWIthColumn_Prefix}}',
		'{{notillia_1}}',
		'SELECT '':column_'' + c.Column_Name + '', '', 1, 1, 1, 1, 1
	     FROM Notillia.Columns c
		 WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -0));
			END'
		),
		(
		'PHP Controller Layout',
		'All PK columns POST check',
		'All PK columns POST check',
		'{{CheckPostAllPKColumns}}',
		'{{notillia_1}}',
		'SELECT ''isset( $_POST['''''' + cc.Column_Name + ''''''] ) && '', 1, 1, 1, 1, 1 
		 FROM Notillia.ConstraintColumns cc
			INNER JOIN Notillia.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Schema] = pk.[Schema] AND cc.[Table_Name] = pk.[Table_Name] AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
	     ORDER BY cc.column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'AllPKColumsWithColumn_Prefix',
		'AllPKColumsWithColumn_Prefix',
		'{{AllPKColumnsWIthColumn_Prefix}}',
		'`{{notillia_1}}` = :column_{{notillia_1}} AND ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
	     FROM Notillia.ConstraintColumns cc
			INNER JOIN Notillia.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Schema] = pk.[Schema] AND cc.[Table_Name] = pk.[Table_Name] AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
	     ORDER BY cc.column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -5));
			END'
		),
		(
		'PHP Controller Layout',
		'createColumnArray',
		'createColumnArray',
		'{{createColumnArray}}',
		'{{notillia_1}}',
		'SELECT CASE c.IS_NULLable
			WHEN ''YES'' THEN ''if( isset( $data[''''null_'' + c.Column_Name + ''''''] ) && $data[''''null_'' + c.Column_Name + ''''''] == ''''true'''') {'' + CHAR(10) +
								''$return[''''column_'' + c.Column_Name + ''''''] = null;'' + CHAR(10) +
							''} else { '' + CHAR(10) +
								''$return[''''column_'' + c.Column_Name + ''''''] = @$data['''''' + c.Column_Name + ''''''];'' + CHAR(10) + 
							''}''
			ELSE ''$return['''''' + c.Column_Name + ''''''] = @$data['''''' + c.Column_Name + ''''''];'' END, 1, 1, 1, 1, 1
		FROM Notillia.Columns c
		WHERE c.[Database] = ''{{DatabaseName}}'' AND c.[Schema] = ''{{SchemaName}}'' AND c.Table_Name = ''{{TableName}}''
		ORDER BY c.Ordinal_Position ASC',
		'',
		''
		),
		(
		'PHP Controller Layout',
		'createPKColumnArray',
		'createPKColumnArray',
		'{{createPKColumnArray}}',
		'$return[''{{notillia_1}}''] = @$data[''{{notillia_1}}''];',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
		 FROM Notillia.ConstraintColumns cc
			INNER JOIN Notillia.PrimaryKeys pk ON cc.[Database] = pk.[Database] AND cc.[Schema] = pk.[Schema] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
		 ORDER BY cc.Index_Column_Id',
		'',
		''
		)

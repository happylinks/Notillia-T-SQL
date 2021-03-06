IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES t WHERE t.TABLE_NAME = 'Tags' AND t.TABLE_SCHEMA = 'ReplaceValue') BEGIN
	DROP TABLE ReplaceValue.Tags;
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES t WHERE t.TABLE_NAME = 'Templates' AND t.TABLE_SCHEMA = 'ReplaceValue') BEGIN
	DROP TABLE ReplaceValue.Templates;
END

/**
*	Template table with all the templates for the CRUD application
*/
CREATE TABLE ReplaceValue.Templates(
	name		varchar(128)		not null,
	description varchar(120)	not null,
	source		text			not null,
	path		varchar(255)	not null,
	filename	varchar(50)		not null,
	constraint PK_templates primary key  (name),
);
GO

/**
*	Tag table, contains all the replacement tags for an certain template.
*/
CREATE TABLE ReplaceValue.Tags(
	id				bigint			not null IDENTITY(1,1),
	template_name	varchar(128)		not null,
	name			varchar(128)		not null,
	description		varchar(128)	not null,
	tag				varchar(64)		not null,
	source			text			not null,
	query			varchar(max)	not null,
	beforeResult	varchar(max)	null,
	afterResult		varchar(max)	null,
	constraint PK_tags primary key  (template_name,name),
	constraint FK_template foreign key(template_name) REFERENCES ReplaceValue.Templates(name) ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

-- DE PHP CONTROLLER TEMPLATE
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

			$query = "SELECT {{AllColumns}}, (SELECT COUNT(1) FROM `{{TableName}}`) as ''ReplaceValue.totalrecords''
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
				{{children}}
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

	public function actionCsv($tablename){
		$tablename = htmlentities($tablename);
		$csv = new csvWriter();
		$result = $this -> DB -> select("SELECT {{AllColumns}} FROM `{{TableName}}` LIMIT :limit OFFSET :offset",array(''limit''=>DefaultLimit,''offset''=>1));
		$data = array();
		$headers = array();
		foreach($result[0] as $key=>$value){
			$headers[] = $key;
		}
		$data[] = $headers;
		foreach($result as $row){
			$array = array();
			foreach($row as $value){
				$array[] = $value;
			}
			$data[] = $array;
		}
		$csv->outputCSV($data);
		$this -> loadView( ''csv'' );
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
						$totalrecords = $row[''ReplaceValue.totalrecords''];
						unset( $row[''ReplaceValue.totalrecords''] );
					}
					$return[] = $row;
				}
			}else { //If one row.
				$totalrecords = @$result[''ReplaceValue.totalrecords''];
				unset( $result[''ReplaceValue.totalrecords''] );
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
		if ( {{CheckPostAllColumns}} ) {
			$data = $this -> createColumnArray( $_POST );
			$query = "INSERT INTO `{{TableName}}` ({{AllColumns}}) VALUES
			({{AllColumnsWithColumn_Prefix}})";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, ''Record is inserted.'' );
			} else {
				$this -> giveJSONmessage( false, @$statement[''message''] );
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
		if ( {{createUpdatePkOldClause}} ) && {{createUpdateNewClause}}) {
			$data_old = $this -> addArrayPrefix( $this -> createPKColumnArray( $_POST[''old''] ), ''old_'' );
			$data_new = $this -> addArrayPrefix( $this -> createColumnArray( $_POST[''new''] ), ''new_'' );
			$data = array_merge( $data_old, $data_new );

			$query = "UPDATE `{{TableName}}` 
					  SET {{createUpdateSetNewClause}}
					  WHERE {{createUpdateSetPKWhereClause}}";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, ''Record is updated.'' );
			} else {
				$this -> giveJSONmessage( false, @$statement[''message''] );
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
				$this -> giveJSONmessage( false, @$statement[''message''] );
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
			{{createFKColumnArrayTables}}
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

--DE HTML VIEW TEMPLATE
DECLARE @template NVARCHAR(max) = '
<?php include("app/views/header.php"); ?>
  <div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container-fluid">
        <a class="btn btn-navbar">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a>
        <a href="<?php echo WWW_BASE_PATH ?>" class="brand">{{DatabaseName}}</a>
      </div>
    </div>
  </div>
  <div class="container-fluid">
    <div class="row-fluid">
      <div class="span2">
        <div class="sidebar-nav">
          <ul class="nav nav-list well">
            <li class="nav-header">Tables</li>
            {{Menu}}
            <!--<li class="nav-header">Views</li>-->
            
          </ul>
          </div>
        </div>
<?php $thispath = WWW_BASE_PATH."{{TableName}}/"; ?>
<script>var controllername = "{{TableName}}"; var basepath = "<?php echo WWW_BASE_PATH; ?>";</script>
<div class="span9" id="ReplaceValue_body">
	<div class="row-fluid">
		<div class="tableparent">
			<!-- MASTER -->
			<div name="{{TableName}}" class="item master grid">
				<div class="head">
					<h2>{{TableName}}</h2>
					<span class="buttons">
						<a name="save" class="btn btn-mini btn-success tip" title="Save"><i class="icon icon-ok icon-white"></i></a>
						<a name="cancel" class="btn btn-mini btn-danger tip" title="Cancel"><i class="icon icon-remove icon-white"></i></a>
						&nbsp;&nbsp; 
						<a name="add" class="btn btn-mini btn-success tip" title="Add"><i class="icon icon-plus icon-white"></i></a>
						<a name="edit" class="btn btn-mini btn-warning tip" title="Edit"><i class="icon icon-edit icon-white"></i></a>
						<a name="del"class="btn btn-mini btn-danger tip" title="Delete"><i class="icon icon-trash icon-white"></i></a>
						&nbsp;&nbsp;
						<a name="generateExcel" class="btn btn-mini tip" title="Generate Excel"><li class="icon icon-file"></li></a>
						<a name="switchview" class="btn btn-mini tip" title="Switch View"><i class="icon icon-th-list"></i></a>
					</span>
				</div>
				<br/>
				<div class="body row-fluid">
					<div class="span12">
						<table class="table table-striped table-bordered grid master" name="grid" data:page="1" data:maxpage="1">
							<thead>
								<tr>
									{{TableHeader}}
								</tr>
							</thead>
							<tbody>
								<tr name="">
								</tr>
							</tbody>
						</table>
						<table class="table detail master" name="detail">
							<tbody>
								{{DetailColumns}}
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
			<!--/MASTER -->
			<!-- TABS -->
			<ul class="nav nav-tabs childtabs">
				{{ChildrenTabs}}
			</ul>
			<!--/TABS -->
			{{children}}
		</div>
	</div>
</div>
<!-- GENERATE MASTER MODALS HERE FOR "{{TableName}}" -->
	<!-- GENERATE ADD MODAL HERE -->
	<div class="modal master fade add" name="{{TableName}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">x</a>
			<h3>Add {{TableName}}</h3>
		</div>
		<div class="modal-body">
			<form id="add-form" class="form-horizontal">
				<div class="forminputs" style="margin:0 auto;width:70%;">
					{{ControlGroups}}
				</div>
			</form>
		</div>
		<div class="modal-footer">
			<a name="cancel" class="btn" data-dismiss="modal">Cancel</a>
			<a name="add" class="btn btn-primary">Save</a>
		</div>
	</div>
	<!--/GENERATE ADD MODAL HERE -->
	<!-- GENERATE EDIT MODAL HERE -->
	<div class="modal master fade edit" name="{{TableName}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">x</a>
			<h3>Edit {{TableName}}</h3>
		</div>
		<div class="modal-body">
			<form id="edit-form" class="form-horizontal">
				<div class="forminputs" style="margin:0 auto;width:70%;">
					{{ControlGroups}}
				</div>
			</form>
		</div>
		<div class="modal-footer">
			<a name="cancel" class="btn" data-dismiss="modal">Cancel</a>
			<a name="edit" class="btn btn-primary">Save</a>
		</div>
	</div>
	<!--/GENERATE EDIT MODAL HERE -->
	<!-- GENERATE DELETE MODAL HERE -->
	<div class="modal master del fade" name="{{TableName}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">x</a>
			<h3>Delete {{TableName}}</h3>
		</div>
		<div class="modal-body">
			Are you sure you want to delete these row(s)?
		</div>
		<div class="modal-footer">
			<a name="cancel" class="btn" data-dismiss="modal">Cancel</a>
			<a name="del" class="btn btn-danger">Delete</a>
		</div>
	</div>
	<!--/GENERATE DELETE MODAL HERE -->
<!--/GENERATE MASTER MODALS HERE FOR "{{TableName}}"-->
{{ChildModals}}
<?php include("app/views/footer.php"); ?>
';

/*
 * Insert all templates and information.
 * You can use {{TableName}} in path or filename to represent the current name.
 */
INSERT INTO ReplaceValue.Templates
VALUES (
		'HTML Table Layout',
		'Contains the view (HTML) layout of each table.',
		@template,
		'app\Views\{{TableName}}',
		'index.php'
		),
		(
		'PHP Controller Layout',
		'Contains the controller (PHP) layout of each table.',
		@PHPController,
		'app\Controllers',
		'{{TableName}}.php'
		);

INSERT INTO ReplaceValue.Tags
	(template_name, name, description, tag, source, query, beforeResult, afterResult) 
VALUES (
		'HTML Table Layout',
		'TableHeader',
		'Give all columns including datatypes in an table header format.',
		'{{TableHeader}}',
		'<th constraint="{{ReplaceValue_3}}" name="{{ReplaceValue_1}}"><span class="tiptop" title="{{ReplaceValue_2}}">{{ReplaceValue_1}}</span></th>',
		'SELECT c.Column_Name, c.Data_Type,
		(SELECT ''pk'' FROM ReplaceValue.ConstraintColumns cc
		INNER JOIN ReplaceValue.PrimaryKeys pk
		ON pk.Constraint_Name = cc.Constraint_Name
		WHERE pk.Table_Name = c.Table_Name
		AND cc.Column_Name = c.Column_Name), 1, 1, 1
		FROM ReplaceValue.Columns c
		WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.[Table_Name] = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'DetailColumns',
		'Detail view voor alle kolommen.',
		'{{DetailColumns}}',
		'{{ReplaceValue_1}}',
		'SELECT CASE d.RowNumber % 2 
			WHEN 1 THEN ''<tr><th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td>''
			WHEN 0 THEN ''<th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td></tr>'' ELSE ''ERROR'' END
			AS ''Case'', 1, 1, 1, 1, 1
			FROM( SELECT c.Column_Name, c.Data_Type, ROW_NUMBER() OVER(ORDER BY c.[Schema], c.[Database], c.[Table_Name], c.[Column_Name] DESC) AS ''RowNumber''
				  FROM ReplaceValue.Columns c
				  WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.[Table_Name] = ''{{TableName}}''
			) d ', '', ''
		),
		(
		'HTML Table Layout',
		'ChildrenTabs',
		'Create tabs for each child.',
		'{{ChildrenTabs}}',
		'<li name="{{ReplaceValue_1}}"><a href="#">{{ReplaceValue_1}}</a></li>',
		'SELECT fc.Child_Table,1,1,1,1,1 
		 FROM ReplaceValue.ForeignKeyColumns fc 
		 WHERE fc.[Schema] = ''{{SchemaName}}'' AND fc.[Database] = ''{{DatabaseName}}'' AND fc.[Master_Table] = ''{{TableName}}''
		 GROUP BY fc.Child_Table', '', ''
		),
		(
		'HTML Table Layout',
		'ControlGroups',
		'Create control groups (Forms) for each column.',
		'{{ControlGroups}}',
		'{{ReplaceValue_1}}',
		'SELECT 
		''<div class="control-group">
		<label for="'' + c.Column_Name + ''" class="control-label"><span class="tipleft" title="'' + c.Data_Type + ''">'' + c.Column_Name + ''</span></label>
		<div class="controls">'' + CHAR(10) + 
		CASE c.IS_NULLable WHEN ''YES'' 
		THEN ''<div class="input-append">
		<input class="'' + c.Data_Type + ''" type="text" name="'' + c.Column_Name + ''" value="" style="width:174px;" class="hasnull"/>
		<span class="addon-on"><input class="null tiptop" title="NULL" type="checkbox" name="null_'' + c.Column_Name + ''" checked="true"/></span>
		</div>'' + CHAR(10)
		ELSE ''<input class="'' + c.Data_Type + ''" type="text" name="'' + c.Column_Name + ''" value="" />'' + CHAR(10) END +
		''</div>'' + CHAR(10) + ''</div>'' + CHAR(10), 1, 1, 1, 1, 1
		FROM ReplaceValue.Columns c
		WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.[Table_Name] = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'Child',
		'Create an GRID and detail view for each Child.',
		'{{children}}',
		'<!-- CHILD -->
			<div name="{{ReplaceValue_1}}" class="item child grid">
				<div class="head">
					<h2>{{ReplaceValue_1}}</h2><h6>{{ChildForeignKey={{ReplaceValue_1}}}}</h6>
					<span class="buttons">
						<!-- GENERATE BUTTONS HERE-->
							<a name="save" class="btn btn-mini btn-success tip" title="Save"><i class="icon icon-ok icon-white"></i></a>
							<a name="cancel" class="btn btn-mini btn-danger tip" title="Cancel"><i class="icon icon-remove icon-white"></i></a>
							&nbsp;&nbsp; 
							<a name="add" class="btn btn-mini btn-success tip" title="Add"><i class="icon icon-plus icon-white"></i></a>
							<a name="edit" class="btn btn-mini btn-warning tip" title="Edit"><i class="icon icon-edit icon-white"></i></a>
							<a name="del"class="btn btn-mini btn-danger tip" title="Delete"><i class="icon icon-trash icon-white"></i></a>
							&nbsp;&nbsp; 
							<a name="tomaster"class="btn btn-mini tip" title="Switch to Master"><i class="icon icon-fire"></i></a>
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
									{{ChildTableHeader={{ReplaceValue_1}}}}
								</tr>
							</thead>
							<tbody>
								<tr name="">
								</tr>
							</tbody>
						</table>
						<table class="table detail child" name="detail">
							<tbody>
									{{DetailColumns={{ReplaceValue_1}}}}
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
		'SELECT fk.Child_Table,1,1,1,1,1
		 FROM ReplaceValue.ForeignKeys fk
		 INNER JOIN ReplaceValue.ForeignKeyColumns fkc
		 ON fkc.Constraint_Name = fk.Constraint_Name
		 WHERE fk.[Schema] = ''{{SchemaName}}'' AND fk.[Database] = ''{{DatabaseName}}'' AND fk.[Master_Table] = ''{{TableName}}''
		 GROUP BY fk.Master_Table, fk.Child_Table', '', ''
		),
		(
		'HTML Table Layout',
		'ChildForeignKey',
		'Create an simple list of foreign keys that tells how the child is connected to the master.',
		'{{ChildForeignKey}}',
		'{{ReplaceValue_1}}, ',
		'SELECT fkc.Master_Column,1,1,1,1,1 
		 FROM ReplaceValue.ForeignKeyColumns fkc
		 WHERE fkc.[Schema] = ''{{SchemaName}}'' AND fkc.[Database] = ''{{DatabaseName}}'' AND fkc.[Child_Table] = ''{{ParameterTag}}'' AND fkc.[Master_Table] = ''{{TableName}}''', 
		'', 
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) - 0));
			END
		'),
		(
		'HTML Table Layout',
		'ChildTableHeader',
		'Give all columns including datatypes in an table header format of a child.',
		'{{ChildTableHeader}}',
		'<th constraint="{{ReplaceValue_3}}" name="{{ReplaceValue_1}}"><span class="tiptop" title="{{ReplaceValue_2}}">{{ReplaceValue_1}}</span></th>',
		'SELECT c.Column_Name, c.Data_Type,
		(SELECT ''fk'' FROM ReplaceValue.ForeignKeys NFK
		 INNER JOIN ReplaceValue.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.Child_table = c.Table_Name AND
		       NFK.Master_table = ''{{TableName}}'' AND
			   NFKC.Child_Column = c.Column_name), 1, 1, 1
		FROM ReplaceValue.Columns c
		WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.[Table_Name] = ''{{ParameterTag}}''', '', ''
		),
		(
		'HTML Table Layout',
		'ChildDetailColumns',
		'Detail view for all columns child.',
		'{{ChildDetailColumns}}',
		'{{ReplaceValue_1}}',
		'SELECT CASE d.RowNumber % 2 
			WHEN 1 THEN ''<tr><th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td>''
			WHEN 0 THEN ''<th><span class="tiptop" title="'' + d.Data_Type + ''">'' + d.Column_Name + ''</span></th><td name="'' + d.Column_Name + ''"></td></tr>'' ELSE ''ERROR'' END
			AS ''Case'', 1, 1, 1, 1, 1
			FROM( SELECT c.Column_Name, c.Data_Type, ROW_NUMBER() OVER(ORDER BY c.[Schema], c.[Database], c.[Table_Name], c.[Column_Name] DESC) AS ''RowNumber''
				  FROM ReplaceValue.Columns c
				  WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{ParameterTag}}''
			) d ', '', ''
		),
		(
		'HTML Table Layout',
		'ChildModals',
		'Create Create/Update/Delte modals for every Child.',
		'{{ChildModals}}',
		'<!-- GENERATE MODALS HERE FOR "{{ReplaceValue_1}}" -->
		<!-- GENERATE ADD MODAL HERE -->
		<div class="modal child fade add" name="{{ReplaceValue_1}}">
			<div class="modal-header">
				<a class="close" data-dismiss="modal">x</a>
				<h3>Add {{ReplaceValue_1}}</h3>
			</div>
			<div class="modal-body">
				<form id="add-form" class="form-horizontal">
					<div class="forminputs" style="margin:0 auto;width:70%;">
						<!-- GENERATE CONTROLGROUPS HERE -->
						{{ChildControlGroup={{ReplaceValue_1}}}}
						<!--/GENERATE CONTROLGROUPS HERE -->
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<a name="cancel" class="btn" data-dismiss="modal">Cancel</a>
				<a name="add" class="btn btn-primary">Save</a>
			</div>
		</div>
		<!--/GENERATE ADD MODAL HERE -->
		<!-- GENERATE EDIT MODAL HERE -->
		<div class="modal child fade edit" name="{{ReplaceValue_1}}">
			<div class="modal-header">
				<a class="close" data-dismiss="modal">x</a>
				<h3>Edit {{ReplaceValue_1}}</h3>
			</div>
			<div class="modal-body">
				<form id="edit-form" class="form-horizontal">
					<div class="forminputs" style="margin:0 auto;width:70%;">
						<!-- GENERATE CONTROLGROUPS HERE -->
						{{ChildControlGroup={{ReplaceValue_1}}}}
						<!--/GENERATE CONTROLGROUPS HERE -->
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<a name="cancel" class="btn" data-dismiss="modal">Cancel</a>
				<a name="edit" class="btn btn-primary">Save</a>
			</div>
		</div>
		<!--/GENERATE EDIT MODAL HERE -->
		<!-- GENERATE DELETE MODAL HERE -->
		<div class="modal child fade del" name="{{ReplaceValue_1}}">
			<div class="modal-header">
				<a class="close" data-dismiss="modal">x</a>
				<h3>Delete {{ReplaceValue_1}}</h3>
			</div>
			<div class="modal-body">
				Are you sure you want to delete these row(s)?
			</div>
			<div class="modal-footer">
				<a name="cancel" class="btn" data-dismiss="modal">Cancel</a>
				<a name="del" class="btn btn-danger">Delete</a>
			</div>
		</div>
		<!--/GENERATE DELETE MODAL HERE -->
	<!--/GENERATE MODALS HERE FOR "{{ReplaceValue_1}}"-->',
	'SELECT NFK.Child_Table,1,1,1,1,1
		 FROM ReplaceValue.ForeignKeys NFK
		 INNER JOIN ReplaceValue.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.Master_Table = ''{{TableName}}''', '', ''
		),
		(
		'HTML Table Layout',
		'ChildControlGroup',
		'Create control groups (Forms) for each column for each child.',
		'{{ChildControlGroup}}',
		'{{ReplaceValue_1}}',
		'SELECT 
		''<div class="control-group" style="'' + ISNULL((SELECT ''display:none;'' FROM ReplaceValue.ForeignKeys NFK
		 INNER JOIN ReplaceValue.ForeignKeyColumns NFKC ON NFKC.Constraint_Name = NFK.Constraint_Name WHERE NFKC.Child_Column = c.Column_Name AND NFKC.Child_Table = ''{{ParameterTag}}'' AND NFKC.Master_Table = ''{{TableName}}''), '''') + ''">
		<label for="'' + c.Column_Name + ''" class="control-label"><span class="tipleft" title="'' + c.Data_Type + ''">'' + c.Column_Name + ''</span></label>
		<div class="controls">'' + CHAR(10) + 
		CASE c.IS_NULLable WHEN ''YES'' 
		THEN ''<div class="input-append">
		<input class="'' + c.Data_Type + ''" type="text" name="'' + c.Column_Name + '' " value="" style="width:174px;" class="hasnull"/>
		<span class="addon-on"><input class="null tiptop" title="NULL" type="checkbox" name="null_'' + c.Column_Name + ''" checked=''''true''''/></span>
		</div>'' + CHAR(10)
		ELSE ''<input class="'' + c.Data_Type + ''" type="text" name="'' + c.Column_Name + ''" value="" />'' + CHAR(10) END +
		''</div>'' + CHAR(10) + ''</div>'' + CHAR(10), 1, 1, 1, 1, 1
		FROM ReplaceValue.Columns c
		WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{ParameterTag}}''', '', ''
		),
		(
		'HTML Table Layout',
		'Menu',
		'Create an menu with all the tables.',
		'{{Menu}}',
		'<li><a href="<?php echo WWW_BASE_PATH ?>{{ReplaceValue_1}}/">{{ReplaceValue_1}}</a></li>',
		'SELECT t.Table_Name, 1, 1, 1, 1, 1
		FROM ReplaceValue.Tables t
		WHERE t.Table_Name IN (SELECT TOP 5 fk.Master_Table FROM ReplaceValue.ForeignKeys fk GROUP BY fk.Master_Table ORDER BY COUNT(fk.Master_Table) DESC, fk.Master_Table ASC)
		UNION ALL
		SELECT t.Table_Name, 1, 1, 1, 1, 1
		FROM ReplaceValue.Tables t
		WHERE t.Table_Name NOT IN (SELECT TOP 5 fk.Master_Table FROM ReplaceValue.ForeignKeys fk GROUP BY fk.Master_Table ORDER BY COUNT(fk.Master_Table) DESC, fk.Master_Table ASC)
		AND  t.[Schema] = ''{{SchemaName}}'' AND t.[Database] = ''{{DatabaseName}}''', '', ''
		),
		(
		'PHP Controller Layout',
		'AllColumns',
		'All columns for a table',
		'{{AllColumns}}',
		'`{{ReplaceValue_1}}`, ',
		'SELECT c.Column_Name, 1, 1, 1, 1, 1
		 FROM ReplaceValue.Columns c
		 WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -0));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk Columns',
		'All pk columns for a table',
		'{{AllPkColumns}}',
		'`{{ReplaceValue_1}}`, ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
		 FROM ReplaceValue.ConstraintColumns cc
			LEFT JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -0));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk columns smaller',
		'All pk columns smaller',
		'{{PKSmallerClause}}',
		'{{ReplaceValue_1}}',
		'SELECT ''`'' + cc.Column_Name + ''` <= :column_'' + cc.Column_Name + '' AND '', 1, 1, 1, 1, 1
		 FROM ReplaceValue.ConstraintColumns cc
			LEFT JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}'' 
		 ORDER BY cc.index_column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk columns bigger',
		'All pk columns bigger',
		'{{PKBiggerClause}}',
		'{{ReplaceValue_1}}',
		'SELECT ''`'' + cc.Column_Name + ''` >= :column_'' + cc.Column_Name + '' AND '', 1, 1, 1, 1, 1
		 FROM ReplaceValue.ConstraintColumns cc
			LEFT JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}'' 
		 ORDER BY cc.index_column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'All Pk columns equal',
		'All pk columns equal',
		'{{PKEqualClause}}',
		'{{ReplaceValue_1}}',
		'SELECT ''`'' + cc.Column_Name + ''` = :column_'' + cc.Column_Name + '' AND '', 1, 1, 1, 1, 1
		 FROM ReplaceValue.ConstraintColumns cc
			LEFT JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{TableName}}'' 
		 ORDER BY cc.index_column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'All columns POST check',
		'All columns POST check',
		'{{CheckPostAllColumns}}',
		'{{ReplaceValue_1}}',
		'SELECT ''isset( $_POST['''''' + c.Column_Name + '''''']) && '', 1, 1, 1, 1, 1
		 FROM ReplaceValue.Columns c
		 WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{TableName}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) - 1));
			END'
		),
		(
		'PHP Controller Layout',
		'AllColumsWithColumn_Prefix',
		'AllColumsWithColumn_Prefix',
		'{{AllColumnsWithColumn_Prefix}}',
		'{{ReplaceValue_1}}',
		'SELECT '':column_'' + c.Column_Name + '', '', 1, 1, 1, 1, 1
	     FROM ReplaceValue.Columns c
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
		'{{ReplaceValue_1}}',
		'SELECT ''isset( $_POST['''''' + cc.Column_Name + ''''''] ) && '', 1, 1, 1, 1, 1 
		 FROM ReplaceValue.ConstraintColumns cc
			INNER JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Schema] = pk.[Schema] AND cc.[Table_Name] = pk.[Table_Name] AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
	     ORDER BY cc.column_id ASC',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -1));
			END'
		),
		(
		'PHP Controller Layout',
		'AllPKColumsWithColumn_Prefix',
		'AllPKColumsWithColumn_Prefix',
		'{{AllPKColumnsWIthColumn_Prefix}}',
		'`{{ReplaceValue_1}}` = :column_{{ReplaceValue_1}} AND ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
	     FROM ReplaceValue.ConstraintColumns cc
			INNER JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Schema] = pk.[Schema] AND cc.[Table_Name] = pk.[Table_Name] AND cc.Constraint_Name = pk.Constraint_Name
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
		'createColumnArray',
		'createColumnArray',
		'{{createColumnArray}}',
		'{{ReplaceValue_1}}',
		'SELECT CASE c.IS_NULLable
			WHEN ''YES'' THEN ''if( isset( $data[''''null_'' + c.Column_Name + ''''''] ) && $data[''''null_'' + c.Column_Name + ''''''] == ''''true'''') {'' + CHAR(10) +
								''$return[''''column_'' + c.Column_Name + ''''''] = null;'' + CHAR(10) +
							''} else { '' + CHAR(10) +
								''$return[''''column_'' + c.Column_Name + ''''''] = @$data['''''' + c.Column_Name + ''''''];'' + CHAR(10) + 
							''}''
			ELSE ''$return[''''column_'' + c.Column_Name + ''''''] = @$data['''''' + c.Column_Name + ''''''];'' END, 1, 1, 1, 1, 1
		FROM ReplaceValue.Columns c
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
		'$return[''column_{{ReplaceValue_1}}''] = @$data[''{{ReplaceValue_1}}''];',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
		 FROM ReplaceValue.ConstraintColumns cc
			INNER JOIN ReplaceValue.PrimaryKeys pk ON cc.[Database] = pk.[Database] AND cc.[Schema] = pk.[Schema] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
		 ORDER BY cc.Index_Column_Id',
		'',
		''
		),
		(
		'PHP Controller Layout',
		'createFKColumnArrayTables',
		'createFKColumnArrayTables',
		'{{createFKColumnArrayTables}}',
		'case ''{{ReplaceValue_1}}'':
			{{createFKColumnArrayTableReturn={{ReplaceValue_1}}}}
			break;',
		'SELECT fk.Child_Table, 1, 1, 1, 1, 1
		 FROM ReplaceValue.ForeignKeys fk
		 WHERE fk.[Database] = ''{{DatabaseName}}'' AND fk.[Schema] = ''{{SchemaName}}'' AND fk.Master_Table = ''{{TableName}}''',
		'',
		''
		),
		(
		'PHP Controller Layout',
		'createFKColumnArrayTableColumns',
		'createFKColumnArrayTableColumns',
		'{{createFKColumnArrayTableReturn}}',
		'{{ReplaceValue_1}}',
		'SELECT CASE c.IS_NULLable 
			WHEN ''YES'' THEN ''if( isset( $data[''''null_'' + c.Column_Name + ''''''] ) && $data[''''null_'' + c.Column_Name + ''''''] == ''''true'''') {'' + CHAR(10) +
								''$return[''''column_'' + c.Column_Name + ''''''] = null;'' + CHAR(10) +
							''} else {'' + CHAR(10) +
								''$return[''''column_'' + c.Column_Name + ''''''] = @$data['''''' + c.Column_Name + ''''''];'' + CHAR(10) +
							''}''
			ELSE ''$return[''''column_'' + c.Column_Name + ''''''] = @$data['''''' + c.Column_Name + ''''''];'' END, 1, 1, 1, 1, 1
		FROM ReplaceValue.Columns c
		WHERE c.[Database] = ''{{DatabaseName}}'' AND c.[Schema] = ''dbo'' AND c.Table_Name = ''{{TableName}}'' 
			  AND EXISTS (SELECT 1 FROM ReplaceValue.ForeignKeyColumns fkc 
						  WHERE fkc.[Database] = ''{{DatabaseName}}'' AND fkc.[Schema] = ''{{SchemaName}}'' AND 
								fkc.Master_Table = c.Table_Name AND fkc.Child_Column = c.Column_Name AND
								fkc.Child_Table = ''{{ParameterTag}}'')',
		'',
		''
		),
		(
		'PHP Controller Layout',
		'createUpdatePkOldClause',
		'createUpdatePkOldClause',
		'{{createUpdatePkOldClause}}',
		'isset( $_POST[''old''][''{{ReplaceValue_1}}''] ) && ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1 
		 FROM ReplaceValue.ConstraintColumns cc
		    INNER JOIN ReplaceValue.PrimaryKeys pk ON cc.[Database] = pk.[Database] AND cc.[Schema] = pk.[Schema] AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
		 ORDER BY cc.Index_Column_Id',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'createUpdateNewClause',
		'createUpdateNewClause',
		'{{createUpdateNewClause}}',
		'isset( $_POST[''new''][''{{ReplaceValue_1}}''] ) && ',
		'SELECT c.Column_Name, 1, 1, 1, 1, 1 
		 FROM ReplaceValue.Columns c
		 WHERE c.[Database] = ''{{DatabaseName}}'' AND c.[Schema] = ''{{SchemaName}}'' AND c.Table_Name = ''{{TableName}}''
		 ORDER BY c.Ordinal_Position',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -1));
			END'
		),
		(
		'PHP Controller Layout',
		'createUpdateSetNewClause',
		'createUpdateSetNewClause',
		'{{createUpdateSetNewClause}}',
		'`{{ReplaceValue_1}}` = :new_column_{{ReplaceValue_1}}, ',
		'SELECT c.Column_Name, 1, 1, 1, 1, 1 
		 FROM ReplaceValue.Columns c
		 WHERE c.[Database] = ''{{DatabaseName}}'' AND c.[Schema] = ''{{SchemaName}}'' AND c.Table_Name = ''{{TableName}}''
		 ORDER BY c.Ordinal_Position',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -0));
			END'
		),
		(
		'PHP Controller Layout',
		'createUpdateSetPKWhereClause',
		'createUpdateSetPKWhereClause',
		'{{createUpdateSetPKWhereClause}}',
		'`{{ReplaceValue_1}}` = :old_column_{{ReplaceValue_1}} AND ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
		FROM ReplaceValue.ConstraintColumns cc
		INNER JOIN ReplaceValue.PrimaryKeys pk ON cc.[Database] = pk.[Database] AND cc.[Schema] = pk.[Schema] AND cc.Constraint_Name = pk.Constraint_Name
		WHERE cc.[Database] = ''{{DatabaseName}}'' AND cc.[Schema] = ''{{SchemaName}}'' AND cc.Table_Name = ''{{TableName}}''
		ORDER BY cc.Index_Column_Id',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'children',
		'children',
		'{{children}}',
		'case ''{{ReplaceValue_1}}'':
		$query = "SELECT {{ChildSelectAllColumns={{ReplaceValue_1}}}}, (
		SELECT COUNT(*) FROM (
		SELECT 1
		FROM `{{TableName}}` master
		INNER JOIN `{{ReplaceValue_1}}` child ON {{ChildMasterRelation={{ReplaceValue_1}}}}
		";
		if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
			$query .= "WHERE {{ChildMasterWhereClause={{ReplaceValue_1}}}} ";
			$data = $this -> createFKColumnArray( $_POST[''where''], $child );
		}
		$query .= "
		GROUP BY {{ChildOrderBy={{ReplaceValue_1}}}}
		) AS subQuery
		) AS ''ReplaceValue.totalrecords''
		FROM `{{TableName}}` master
		INNER JOIN `{{ReplaceValue_1}}` child
		ON {{ChildMasterRelation={{ReplaceValue_1}}}}";
		if ( isset( $_POST[''where''] ) && is_array( $_POST[''where''] ) ) {
			$query .= "WHERE {{ChildMasterWhereClause={{ReplaceValue_1}}}} ";
			$data = $this -> createFKColumnArray( $_POST[''where''], $child );
		}
		$query .= "GROUP BY {{ChildOrderBy={{ReplaceValue_1}}}}
		LIMIT :limit
		OFFSET :offset";
		break;',
		'SELECT NFK.Child_Table,1,1,1,1,1
		 FROM ReplaceValue.ForeignKeys NFK
		 INNER JOIN ReplaceValue.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.[Database] = ''{{DatabaseName}}'' AND NFK.[Schema] = ''{{SchemaName}}'' AND NFK.Master_Table = ''{{TableName}}''
		 GROUP BY NFK.Child_Table',
		'',
		''
		),
		(
		'PHP Controller Layout',
		'ChildSelectAllColumns',
		'ChildSelectAllColumns',
		'{{ChildSelectAllColumns}}',
		'child.`{{ReplaceValue_1}}`, ',
		'SELECT c.Column_Name, 1, 1, 1, 1, 1
		 FROM ReplaceValue.Columns c
		 WHERE c.[Schema] = ''{{SchemaName}}'' AND c.[Database] = ''{{DatabaseName}}'' AND c.Table_Name = ''{{ParameterTag}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -0));
			END'
		),
		(
		'PHP Controller Layout',
		'ChildMasterRelation',
		'ChildMasterRelation',
		'{{ChildMasterRelation}}',
		'master.`{{ReplaceValue_1}}` = child.`{{ReplaceValue_2}}` AND ',
		'SELECT NFKC.Master_Column, NFKC.Child_Column, 1, 1, 1, 1
		 FROM ReplaceValue.ForeignKeys NFK
		 INNER JOIN ReplaceValue.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.[Database] = ''{{DatabaseName}}'' AND NFK.[Schema] = ''{{SchemaName}}'' AND NFK.Master_Table = ''{{TableName}}'' AND NFK.Child_Table = ''{{ParameterTag}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'ChildMasterWhereClause',
		'ChildMasterWhereClause',
		'{{ChildMasterWhereClause}}',
		'master.`{{ReplaceValue_1}}` = :column_{{ReplaceValue_2}} AND ',
		'SELECT NFKC.Master_Column, NFKC.Child_Column, 1, 1, 1, 1
		 FROM ReplaceValue.ForeignKeys NFK
		 INNER JOIN ReplaceValue.ForeignKeyColumns NFKC
		 ON NFKC.Constraint_Name = NFK.Constraint_Name
		 WHERE NFK.[Database] = ''{{DatabaseName}}'' AND NFK.[Schema] = ''{{SchemaName}}'' AND NFK.Master_Table = ''{{TableName}}'' AND NFK.Child_Table = ''{{ParameterTag}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -3));
			END'
		),
		(
		'PHP Controller Layout',
		'ChildOrderBy',
		'ChildOrderBy',
		'{{ChildOrderBy}}',
		'child.`{{ReplaceValue_1}}`, ',
		'SELECT cc.Column_Name, 1, 1, 1, 1, 1
		 FROM ReplaceValue.ConstraintColumns cc
			LEFT JOIN ReplaceValue.PrimaryKeys pk ON cc.[Schema] = pk.[Schema] AND cc.[Database] = pk.[Database] AND cc.Table_Name = pk.Table_Name AND cc.Constraint_Name = pk.Constraint_Name
		 WHERE pk.[Schema] = ''{{SchemaName}}'' AND pk.[Database] = ''{{DatabaseName}}'' AND pk.Table_Name = ''{{ParameterTag}}''',
		'',
		'IF LEN(@tag_result) > 0
			BEGIN
				SET @tag_result = SUBSTRING(@tag_result, 0, (LEN(@tag_result) -0));
			END');
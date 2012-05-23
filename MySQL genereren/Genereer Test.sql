USE muziekdatabase;
GO

DECLARE @String NVARCHAR(MAX); SET @String = '
<?php include(''app/views/header.php''); ?>
<?php $thispath = WWW_BASE_PATH.''{{table.name}}/''; ?>
<script>var controllername = ''{{table.name}}''; var basepath = ''<?php echo WWW_BASE_PATH; ?>'';</script>
<div class="span9" id=''notillia_body''>
	<div class=''row-fluid''>
		<div class=''tableparent''>
			<!-- MASTER -->
			<div name=''{{table.name}}'' class="item master grid">
				<div class=''head''>
					<h2>Stuk</h2>
					<span class=''buttons''>
							<a name=''save'' class=''btn btn-mini btn-success tip'' title=''Save''><i class=''icon icon-ok icon-white''></i></a>
							<a name=''cancel'' class=''btn btn-mini btn-danger tip'' title=''Cancel''><i class=''icon icon-remove icon-white''></i></a>
							&nbsp;&nbsp; 
							<a name=''add'' class=''btn btn-mini btn-success tip'' title=''Add''><i class=''icon icon-plus icon-white''></i></a>
							<a name=''edit'' class=''btn btn-mini btn-warning tip'' title=''Edit''><i class=''icon icon-edit icon-white''></i></a>
							<a name=''del''class=''btn btn-mini btn-danger tip'' title=''Delete''><i class=''icon icon-trash icon-white''></i></a>
							&nbsp;&nbsp; 
							<a name=''search'' class=''btn btn-mini tip'' title=''Search''><i class=''icon icon-search''></i></a>
							<a name=''tableoptions'' class=''btn btn-mini tip'' title=''Table Options''><i class=''icon icon-filter''></i></a>
							<a name=''generateExcel'' class=''btn btn-mini tip'' title=''Generate Excel''><li class=''icon icon-file''></li></a>
							<a name=''switchview'' class=''btn btn-mini tip'' title=''Switch View''><i class=''icon icon-th-list''></i></a>
					</span>
					<span class=''inline-search''>
						<form class="search pull-right dropdown">
							<div class=''controls input-prepend input-append inline-search''>
								<input type="text" placeholder="Search"/>
								<select class=''span2'' name="fields">
									<option value="all">All</option>
									{{#table.columns}}<option value="{{name}}">{{name}}</option>{{/table.columns}}
								</select>
								<button class=''btn btn-success''>
									<i class=''icon icon-search''></i>
								</button>
							</div>
						</form> 
					</span>
					<span class=''tableoptions''>
						<form class="pull-right">
							<div class="input-prepend">
			                	<span class="add-on">Limit</span><input type="text" size="16" id="prependedInput" class="input-mini" value=''10''>
			              	</div>
			              	<a class="btn btn-primary" type="submit">Set</a>
			            </form>
					</span>
				</div>
				<br/>
				<div class="body row-fluid">
					<div class="span12">
						<table class="table table-striped table-bordered grid master" name=''grid'' data:page=''1'' data:maxpage=''1''>
							<thead>
								<tr>
									{{#table.columns}}<th name=''{{name}}''><span class=''tiptop'' title=''{{datatype}}''>{{name}}</span></th>{{/table.columns}}
								</tr>
							</thead>
							<tbody>
								<tr name=''''>
								</tr>
							</tbody>
						</table>
						<table class="table detail master" name=''detail''>
							<tbody>
								<tr>
								{{#table.columns}}<th><span class=''tiptop'' title=''{{datatype}}''>{{name}}</span></th><td name=''{{datatype}}''></td>{{/table.columns}}
								</tr>
							</tbody>
						</table>
						<div class="pagination" style=''text-align:right;''>
							<ul>
								<li name=''backward''><a>&nbsp;<i class=''icon icon-step-backward''></i></a></li>
								<li name=''left''><a>&nbsp;<i class=''icon icon-chevron-left''></i></a></li>
								<li name=''text''></li>
								<li name=''right''><a>&nbsp;<i class=''icon icon-chevron-right''></i></a></li>
								<li name=''forward''><a>&nbsp;<i class=''icon icon-step-forward''></i></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!--/MASTER -->
			<!-- TABS -->
			<ul class="nav nav-tabs childtabs">
				{{#table.children}}
				<li name=''{{name}}''><a href=''#''>{{name}}</a></li>
				{{/table.children}}
			</ul>
			<!--/TABS -->
			{{#table.children}}
			<div name=''{{name}}'' class=''item child grid''>
				<div class=''head''>
					<h2>{{name}}</h2><h6>{{foreignkey}}</h6>
					<span class=''buttons''>
						<!-- GENERATE BUTTONS HERE-->
							<a name=''save'' class=''btn btn-mini btn-success tip'' title=''Save''><i class=''icon icon-ok icon-white''></i></a>
							<a name=''cancel'' class=''btn btn-mini btn-danger tip'' title=''Cancel''><i class=''icon icon-remove icon-white''></i></a>
							&nbsp;&nbsp; 
							<a name=''add'' class=''btn btn-mini btn-success tip'' title=''Add''><i class=''icon icon-plus icon-white''></i></a>
							<a name=''edit'' class=''btn btn-mini btn-warning tip'' title=''Edit''><i class=''icon icon-edit icon-white''></i></a>
							<a name=''del''class=''btn btn-mini btn-danger tip'' title=''Delete''><i class=''icon icon-trash icon-white''></i></a>
							&nbsp;&nbsp; 
							<a name=''search'' class=''btn btn-mini tip'' title=''Search''><i class=''icon icon-search''></i></a>
							<a name=''tableoptions'' class=''btn btn-mini tip'' title=''Table Options''><i class=''icon icon-filter''></i></a>
							<a name=''generateExcel'' class=''btn btn-mini tip'' title=''Generate Excel''><li class=''icon icon-file''></li></a>
							<a name=''switchview'' class=''btn btn-mini tip'' title=''Switch View''><i class=''icon icon-th-list''></i></a>
						<!--/GENERATE BUTTONS HERE-->
					</span>
					<span class=''inline-search''>
						<form class="search pull-right dropdown">
							<div class=''controls input-prepend input-append inline-search''>
								<input type="text" placeholder="Search"/>
								<select class=''span2'' name="fields">
									<option value="all">All</option>
									{{#table.children.columns}}
									<option value="{{name}}">{{name}}</option>
									{{/table.children.columns}}
								</select>
								<button class=''btn btn-success''>
									<i class=''icon icon-search''></i>
								</button>
							</div>
						</form> 
					</span>
					<span class=''tableoptions''>
						<form class="pull-right">
							<div class="input-prepend">
			                	<span class="add-on">Limit</span><input type="text" size="16" id="prependedInput" class="input-mini" value=''10''>
			              	</div>
			              	<a class="btn btn-primary" type="submit">Set</a>
			            </form>
					</span>
				</div>
				<br/>
				<div class="row-fluid">
					<div class="span12">
						<table class="table table-striped table-bordered grid child" name=''grid'' data:page=''1'' data:maxpage=''1''>
							<thead>
								<tr>
									{{#table.children.columns}}
									<th name=''{{name}}''><span class=''tiptop'' title=''{{datatype}}''>{{name}}</span></th>
									{{/table.children.columns}}
								</tr>
							</thead>
							<tbody>
								<tr name=''''>
								</tr>
							</tbody>
						</table>
						<table class="table detail child" name=''detail''>
							<tbody>
								{{#table.children.columns}}
									<th><span class=''tiptop'' title=''{{datatype}}''>{{name}}</span></th>
									<td name=''{{datatype}}''></td>
								{{/table.children.columns}}
							</tbody>
						</table>
						<div class="pagination" style=''text-align:right;''>
							<ul>
								<li name=''backward''><a>&nbsp;<i class=''icon icon-step-backward''></i></a></li>
								<li name=''left''><a>&nbsp;<i class=''icon icon-chevron-left''></i></a></li>
								<li name=''text''></li>
								<li name=''right''><a>&nbsp;<i class=''icon icon-chevron-right''></i></a></li>
								<li name=''forward''><a>&nbsp;<i class=''icon icon-step-forward''></i></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			{{/table.children}}
		</div>
	</div>
</div>
{{#table.children}}
<!-- GENERATE MODALS HERE FOR ''Stuk'' -->
	<!-- GENERATE ADD MODAL HERE -->
	<div class="modal fade" id="add_{{name}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Add {{name}}</h3>
		</div>
		<div class="modal-body">
			<form id=''add-form'' class=''form-horizontal''>
				<div class=''forminputs'' style=''margin:0 auto;width:70%;''>
					{{#table.children.columns}}
					<div class=''control-group''>
						<label for=''{{name}}'' class=''control-label''><span class=''tipleft'' title=''{{datatype}}''>{{name}}</span></label>
						<div class=''controls''>
							<input class=''{{required}} {{datatype}}'' type=''text'' id=''input_{{name}}'' name=''{{name}}'' value=''''/>
						</div>
					</div>
					{{/table.children.columns}}
				</div>
			</form>
		</div>
		<div class="modal-footer">
			<a name=''cancel'' class="btn" data-dismiss="modal">Cancel</a>
			<a name=''add'' class="btn btn-primary">Save</a>
		</div>
	</div>
	<!--/GENERATE ADD MODAL HERE -->
	<!-- GENERATE EDIT MODAL HERE -->
	<div class="modal fade" id="edit_{{name}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Edit {{name}}</h3>
		</div>
		<div class="modal-body">
			<form id=''edit-form'' class=''form-horizontal''>
				<div class=''forminputs'' style=''margin:0 auto;width:70%;''>
					{{#table.children.columns}}
					<div class=''control-group''>
						<label for=''{{name}}'' class=''control-label''><span class=''tipleft'' title=''{{datatype}}''>{{name}}</span></label>
						<div class=''controls''>
							<input class=''{{required}} {{datatype}}'' type=''text'' id=''input_{{name}}'' name=''{{name}}'' value=''''/>
						</div>
					</div>
					{{/table.children.columns}}
				</div>
			</form>
		</div>
		<div class="modal-footer">
			<a name=''cancel'' class="btn" data-dismiss="modal">Cancel</a>
			<a name=''edit'' class="btn btn-primary">Save</a>
		</div>
	</div>
	<!--/GENERATE EDIT MODAL HERE -->
	<!-- GENERATE DELETE MODAL HERE -->
	<div class="modal fade" id="del_stuk">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Delete {{name}}</h3>
		</div>
		<div class="modal-body">
			Are you sure you want to delete these row(s)?
		</div>
		<div class="modal-footer">
			<a name=''cancel'' class="btn" data-dismiss="modal">Cancel</a>
			<a name=''del'' class="btn btn-danger">Delete</a>
		</div>
	</div>
	<!--/GENERATE DELETE MODAL HERE -->
<!--/GENERATE MODALS HERE FOR ''Stuk''-->
<?php include(''app/views/footer.php''); ?> ';

SET @String = REPLACE(@String, '{{table.name}}', 'stuk');

DECLARE @var1 VARCHAR(MAX) = '';
SELECT @var1 += '<option value="' + c.Column_Name + '">' + c.Column_Name + '</option>' + CHAR(10) FROM Notillia.Columns c WHERE [schema] = 'dbo' AND Table_Name = 'stuk';
SET @String = REPLACE(@String, '{{#table.columns}}<option value="{{name}}">{{name}}</option>{{/table.columns}}', @var1);

DECLARE @var2 VARCHAR(MAX) = '';
SELECT @var2 += '<th name=''' + c.Column_Name + '''><span class=''tiptop'' title=''' + c.Data_Type + '''>''' + c.Column_Name + '</span></th>' + CHAR(10) FROM Notillia.Columns c WHERE [schema] = 'dbo' AND Table_Name = 'stuk'; 
SET @String = REPLACE (@String, '{{#table.columns}}<th name=''{{name}}''><span class=''tiptop'' title=''{{datatype}}''>{{name}}</span></th>{{/table.columns}}', @var2);

DECLARE @var3 VARCHAR(MAX) = '';
SELECT @var3 += '<th><span class=''tiptop'' title=''' + c.Data_Type + '''>' + c.Column_Name + '</span><th>' + CHAR(10) + '<td name = ''' + c.Data_Type + '''></td>' + CHAR(10) FROM Notillia.Columns c WHERE [schema] = 'dbo' AND Table_Name = 'stuk'; 
SET @String = REPLACE(@String, '{{#table.columns}}<th><span class=''tiptop'' title=''{{datatype}}''>{{name}}</span></th><td name=''{{datatype}}''></td>{{/table.columns}}', @var3);



PRINT LEN(@String);
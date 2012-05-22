<?php include("app/views/header.php"); ?>
<?php $thispath = WWW_BASE_PATH."{{TableName}}/"; ?>
<script>var controllername = "{{TableName}}"; var basepath = "<?php echo WWW_BASE_PATH; ?>";</script>
<div class="span9" id="notillia_body">
	<div class="row-fluid">
		<div class="tableparent">
			<!-- MASTER -->
			<div name="stuk" class="item master grid">
				<div class="head">
					<h2>{{TableName}}</h2>
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
								<tr>
									<th><span class="tiptop" title="integer">stuknr</span></th>
									<td name="stuknr"></td>
									<th><span class="tiptop" title="integer">componistId</span></th>
									<td name="componistId"></td>
								</tr>
								<tr>
									<th><span class="tiptop" title="string">titel</span></th>
									<td name="titel"></td>
									<th><span class="tiptop" title="integer">stuknrOrigineel</span></th>
									<td name="stuknrOrigineel"></td>
								</tr>
								<tr>
									<th><span class="tiptop" title="string">genrenaam</span></th>
									<td name="genrenaam"></td>
									<th><span class="tiptop" title="char">niveaucode</span></th>
									<td name="niveaucode"></td>
								</tr>
								<tr>
									<th><span class="tiptop" title="integer">speelduur</span></th>
									<td name="speelduur"></td>
									<th><span class="tiptop" title="integer">jaartal</span></th>
									<td name="jaartal"></td>
								</tr>
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
			{{#child}}
			<!-- CHILD -->
			<div name="stuk" class="item child grid">
				<div class="head">
					<h2>{{ChildTablename}}</h2><h6>{{ChildForeignKey}}</h6>
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
									{{ChildTableHeader}}
								</tr>
							</thead>
							<tbody>
								<tr name="">
								</tr>
							</tbody>
						</table>
						<table class="table detail child" name="detail">
							<tbody>
								<tr>
									<th><span class="tiptop" title="integer">stuknr</span></th>
									<td name="stuknr"></td>
									<th><span class="tiptop" title="integer">componistId</span></th>
									<td name="componistId"></td>
								</tr>
								<tr>
									<th><span class="tiptop" title="string">titel</span></th>
									<td name="titel"></td>
									<th><span class="tiptop" title="integer">stuknrOrigineel</span></th>
									<td name="stuknrOrigineel"></td>
								</tr>
								<tr>
									<th><span class="tiptop" title="string">genrenaam</span></th>
									<td name="genrenaam"></td>
									<th><span class="tiptop" title="char">niveaucode</span></th>
									<td name="niveaucode"></td>
								</tr>
								<tr>
									<th><span class="tiptop" title="integer">speelduur</span></th>
									<td name="speelduur"></td>
									<th><span class="tiptop" title="integer">jaartal</span></th>
									<td name="jaartal"></td>
								</tr>
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
			<!--/CHILD -->
			{{/child}}
		</div>
	</div>
</div>
<!-- GENERATE MODALS HERE FOR "Stuk" -->
	<!-- GENERATE ADD MODAL HERE -->
	<div class="modal fade" id="add_{{TableName}}" name="{{TableName}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Add {{TableName}}</h3>
		</div>
		<div class="modal-body">
			<form id="add-form" class="form-horizontal">
				<div class="forminputs" style="margin:0 auto;width:70%;">
					<!-- GENERATE CONTROLGROUPS HERE -->
					{{ControlGroups}}
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
	<div class="modal fade" id="edit_{{TableName}}" name="{{TableName}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Edit {{TableName}}</h3>
		</div>
		<div class="modal-body">
			<form id="edit-form" class="form-horizontal">
				<div class="forminputs" style="margin:0 auto;width:70%;">
					<!-- GENERATE CONTROLGROUPS HERE -->
					{{ControlGroups}}
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
	<div class="modal fade" id="del_{{TableName}}" name="{{TableName}}">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
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
<!--/GENERATE MODALS HERE FOR "Stuk"-->
<!-- GENERATE MODALS HERE FOR "Bezettingsregel" -->
	<!-- GENERATE ADD MODAL HERE -->
	<div class="modal fade" id="add_bezettingsregel">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Add Bezettingsregel</h3>
		</div>
		<div class="modal-body">
			<form id="add-form" class="form-horizontal">
				<div class="forminputs" style="margin:0 auto;width:70%;">
					<!-- GENERATE CONTROLGROUPS HERE -->
					<div class="control-group">
						<label for="stuknr" class="control-label"><span class="tipleft" title="integer">stuknr</span></label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- REQUIRED INT -->
							<input class="required integer" type="text" id="input_stuknr" name="stuknr" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
					<div class="control-group">
						<label for="instrumentnaam" class="control-label"><span class="tipleft" title="string">instrumentnaam</span></label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- REQUIRED STRING -->
							<input class="required" type="text" id="input_instrumentnaam" name="instrumentnaam" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
					<div class="control-group">
						<label for="toonhoogte" class="control-label"><span class="tipleft" title="string">toonhoogte</span></label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- REQUIRED STRING -->
							<input class="required" type="text" id="input_toonhoogte" name="toonhoogte" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
					<div class="control-group">
						<label for="aantal" class="control-label"><span class="tipleft" title="integer">aantal</span></label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- INTEGER -->
							<input class="integer" type="text" id="input_aantal" name="aantal" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
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
	<div class="modal fade" id="edit_bezettingsregel">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Edit Bezettingsregel</h3>
		</div>
		<div class="modal-body">
			<form id="edit-form" class="form-horizontal">
				<div class="forminputs" style="margin:0 auto;width:70%;">
					<!-- GENERATE CONTROLGROUPS HERE -->
					<div class="control-group">
						<label for="stuknr" class="control-label">stuknr</label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- REQUIRED INT -->
							<input class="required integer" type="text" id="input_stuknr" name="stuknr" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
					<div class="control-group">
						<label for="instrumentnaam" class="control-label">instrumentnaam</label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- REQUIRED -->
							<input class="required" type="text" id="input_instrumentnaam" name="instrumentnaam" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
					<div class="control-group">
						<label for="toonhoogte" class="control-label">toonhoogte</label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- REQUIRED -->
							<input class="required" type="text" id="input_toonhoogte" name="toonhoogte" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
					<div class="control-group">
						<label for="aantal" class="control-label">aantal</label>
						<div class="controls">
							<!-- GENERATE INPUT HERE --><!-- INT -->
							<input class="integer" type="text" id="input_aantal" name="aantal" value=""/>
							<!--/GENERATE INPUT HERE -->
						</div>
					</div>
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
	<div class="modal fade" id="del_bezettingsregel">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Delete Bezettingsregel</h3>
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
<!--/GENERATE MODALS HERE FOR "Bezettingsregel"-->
<?php include("app/views/footer.php"); ?>
$(function() {
    
    handleTableRows();
    handleSearch();
    handleTableOptions();
    handleTooltips();
    handleDatePicker();
    handleNullInput();

    $modal_add = $('#add');
    $modal_edit = $('#edit');
    $modal_del = $('#del');

    handleAddModal();
    handleEditModal();
    handleDeleteModal();

    if(viewname == 'detail'){
        handleDetailView();
    }

    $('.combobox').combobox(); //Special twitter-bootstrap combobox.

    $buttons = $('span.buttons a');
    $buttons.click(function() {
        $table = $(this).parents('div.tableparent').find('table');//Table corresponding to buttons.
        type = $(this).attr('name');//Name of button
        $selected = $('.selected');//Selected rows.
        selectlength = $selected.length;
        switch (type) { //Switch on buttonname.
        case 'add':
            switch (viewname) {
            case 'detail':

                break;
            case 'grid':
                emptyInputs($modal_add);
                $modal_add.modal();
                break;
            }
            break;
        case 'edit':
            switch (viewname) {
            case 'detail':
                //TODO
                /*oldvalues = {};
                $table.find('td').each(function() {
                    oldvalues[$(this).attr('name')] = $(this).text();
                    $(this).html("<input type='text' value='" + $(this).text() + "' name='" + $(this).attr('name') + "'/>");
                });
                $savebutton = $("span.buttons a[name='save']").fadeIn().css('display', 'inline-block');
                $cancelbutton = $("span.buttons a[name='cancel']").fadeIn().css('display', 'inline-block');
                $savebutton.click(function() {
                    newvalues = getInputs($table);
                    updateDBRow(controllername, oldvalues, newvalues);
                    setTimeout("redirect('detail/" + currentid + "');", 2000);
                });
                $cancelbutton.click(function() {
                    redirect('detail/' + currentid);
                });*/
                break;
            case 'grid':
                switch (true) {
                case (selectlength == 0):
                    noty({
                        'text': 'Please select a row to edit.',
                        'type': 'information'
                    });
                    break;
                case (selectlength > 1):
                    noty({
                        'text': "You can't edit multiple rows yet.",
                        'type': 'information'
                    });
                    break;
                case (selectlength == 1):
                    oldvalues = getValuesFromRow($selected);
                    emptyInputs($modal_edit);
                    fillInputs($modal_edit, oldvalues);
                    $modal_edit.modal();
                    break;
                }
                break;
            }
            break;
        case 'delete':
            switch (viewname) {
            case 'detail':
                //TODO
                break;
            case 'grid':
                if (selectlength > 0) {
                    $modal_del.modal();
                } else {
                    noty({
                        'text': 'Please select a row to delete.',
                        'type': 'information'
                    });
                }
                break;
            }
            break;
        case 'generateExcel':

            break;
        case 'switchview':
            switch (viewname) {
            case 'detail':
                redirect("grid");
                break;
            case 'grid':
                if (selectlength == 1) {
                    id = $selected.attr('name');
                    redirect("detail/" + id);
                } else if (selectlength == 0) {
                    noty({
                        'text': 'Please select a row.',
                        'type': 'information'
                    });
                } else {
                    id = $selected.first().attr('name');
                    redirect("detail/" + id);
                }
                break;
            }
            break;
        }
    });
});

function handleDetailView(){
    $form = $('form.validate');
    $savebutton = $("span.buttons a[name='save']").fadeIn().css('display', 'inline-block');
    $savebutton.click(function(){
        if($form.validate().form()){
            console.log($form);
            inputvalues = getInputs($form);
            console.log(inputvalues);
            //insertDBRow(controllername, inputvalues);
            //setTimeout("redirect('grid');", 2000);
        }
    });
    $cancelbutton = $("span.buttons a[name='cancel']").fadeIn().css('display', 'inline-block');
    $cancelbutton.click(function(){
        setTimeout("redirect('grid');", 2000);
    });
}
/**
 * @namespace Modalhandlers
 */
/**
 * Handle the add-modal.
 */
function handleAddModal(){
    $form = $("#add-form", $modal_add);
    //Onsubmit
    $('a.submit',$modal_add).click(function(){
        if($form.validate().form()){//Check if form is validated
            inputvalues = getInputs($modal_add);
            if(insertDBRow(controllername, inputvalues)) {
                insertTableRow($table, inputvalues);
                handleTableRows();
            }
            $modal_add.modal('hide');
        }
    });
}
/**
 * Handle the edit-modal.
 */
function handleEditModal(){
    $form = $("#edit-form", $modal_edit);
    //Onsubmit
    $('a.submit', $modal_edit).click(function(){
        if($form.validate().form()){//Check if form is validated
            newvalues = getInputs($modal_edit);
            if(updateDBRow(controllername, oldvalues, newvalues)) {
               updateTableRow($selected, newvalues); 
            }
            $modal_edit.modal('hide');
        }
    });
}
/**
 * Handle the delete-modal.
 */
function handleDeleteModal(){
    //Onconfirm
    $("a.submit", $modal_del).click(function() {
        data = [];
        //Get selected rows and delete all.
        $('.selected', $table).each(function(i) {
            data[i] = {};
            $('td', this).each(function() {//Add all td's to a array.
                name = $(this).attr('name');
                value = $(this).text();
                data[i][name] = value;
            });
            if(deleteDBRow(controllername, data[i])) {
                $(this).remove();
            }
        });
        $modal_del.modal('hide');
    });
}
/**
 * @namespace  Usefull functions
 */
/**
 * If input, that can be NULL, is selected, the NULL-checkbox is set to false.
 */
function handleNullInput(){
	$('.hasnull').focus(function() {
	    name = $(this).attr('name');
	    $("input[name='null_" + name + "']").attr('checked', false);
	});
	$('.hasnull').change(function(){
		name = $(this).attr('name');
		$("input[name='null_" + name + "']").attr('checked', false);
	});
	$('.null').click(function() {
	    name = $(this).attr('name');
	    name = name.substring(5);
	    $("input[name='" + name + "']").val('');
	});
}
/**
 * Check if browser isn't goddarn IE, if not loads beautifull datepicker.
 */
function handleDatePicker(){
	if (!$.browser.msie || (parseInt($.browser.version, 10) >= 8)) {
        $('.date').datepicker();
    }
}
/**
 * Make table-rows multi-selectable and handle double-click to detailview.
 */
function handleTableRows(){
	$('.gridtable tr').multiSelect();
	$('.gridtable tr').dblclick(function() {
	    redirect('detail/' + $(this).attr('name'));
	});
}
/**
 * Load tooltip-handlers.
 */
function handleTooltips() {
    $('.tip').tooltip({
        placement: 'bottom'
    });
    $('.tiptop').tooltip();
    $('.tipleft').tooltip({
        placement: 'left'
    });
}
/**
 * Hard-redirect to a page.
 * @param  {string} subpage Page to redirect to.
 */
function redirect(subpage) {
    window.location.href = basepath + controllername + "/" + subpage;
}
/**
 * Load click-handler for search-button.
 */
function handleSearch() {
    $('a[name="search"]').live('click', function() {
        $('span.inline-search', $(this).parent().parent()).fadeToggle();
    });
}
/**
 * Load click-handler for tableoptions-button.
 */
function handleTableOptions() {
    $('a[name="tableoptions"]').live('click', function() {
        $('span.tableoptions', $(this).parent().parent()).fadeToggle();
    });
}
/**
 * Get values from a html-table-row.
 * @param  {jquery obj} row A jQuery reference to a table-row.
 * @return {string[]}     Array of rowvalues.
 */
function getValuesFromRow(row) {
    values = {};
    $('td', row).each(function() {
        name = $(this).attr('name');
        value = $(this).text();
        values[name] = value;
    });
    return values;
}
/**
 * Set inputvalues from a jquery object.
 * @param  {jquery obj} object A jquery reference.
 * @param  {string[]} values Array of formvalues.
 */
function fillInputs(object, values) {
    $('input', object).each(function() {
    	name = $(this).attr('name');
    	if(values[name] == 'NULL' || values[name] == ''){
    		$(this).val('');
    		$("input[name='null_"+name+"']").attr('checked', true);
    	}else{
			$(this).val(values[name]);
			$("input[name='null_"+name+"']").attr('checked', false);
    	}
    });
}
/**
 * Empty all the inputs from a jquery object.
 * @param  {jquery obj} object jQuery reference to object which to empty the inputs from.
 */
function emptyInputs(object){
    $('input', object).each(function() {
        $(this).val('');
    });
}
/**
 * Get inputvalues from a jquery object.
 * @param  {jquery obj} object A jquery reference.
 * @return {string[]}       Array of formvalues.
 */
function getInputs(object) {
    values = {};
    $('input', object).each(function() {
    	if($(this).attr('type') == 'checkbox'){
    		if($(this).attr('checked')){
    			values[$(this).attr('name')] = true;		
    		}else{
    			values[$(this).attr('name')] = false;
    		}
    	}else{
        	values[$(this).attr('name')] = $(this).val();
    	}
    });
    return values;
}
/**
 * Update a row in a html-table.
 * @param  {jquery obj} row         The jquery reference for the table-row.
 * @param  {string[]} inputvalues Array of new rowvalues.
 */

function updateTableRow(row, inputvalues) {
    $('td', row).each(function(){
    	if(inputvalues['null_'+$(this).attr('name')] == true){
    		text = '<i>NULL</i>';
    	}else{
    		text = inputvalues[$(this).attr('name')];
    	}
        $(this).html(text);
    });
}
/**
 * Insert a row in a html-table from values.
 * @param  {jquery obj} table The jquery reference for the Table.
 * @param  {string[]} inputvalues Array of new rowvalues.
 */

function insertTableRow(table, inputvalues) {
    $tr = $('<tr></tr>');
    columns = [];
    _.each($('th',table),function(th){
    	columns.push($(th).text());
    });
    _.each(inputvalues, function(value, key) {
    	if($.inArray(key,columns) != -1){
    		$td = $('<td></td>');
	        $td.text(value);
	        $td.attr('name', key);
	        $tr.append($td);
    	}
    });
    table.prepend($tr);
}
/**
 * @namespace Database Operations
 */
/**
 * Update a DBRow: Sends an ajax-request to the backend to update one database row.
 * @param  {string} controller Name of controller.
 * @param  {string[]} oldvalues  Array of old rowvalues.
 * @param  {string[]} newvalues  Array of new rowvalues.
 */

function updateDBRow(controller, oldvalues, newvalues) {
    return $.ajax({
        url: basepath + controller + '/update',
        type: 'post',
        data: {
            'old': oldvalues,
            'new': newvalues
        },
        success: function(data) {
        	//Show message for succeeded request.
            noty({
                'text': data.message,
                'type': (data.code) ? 'success' : 'error'
            });
            return (data.code) ? true : false;
        },
        error: function(data) {
        	//Show message for failed request.
            noty({
                'text': "Uh oh, Request error.",
                'type': 'error'
            });
            return false;
        }
    });
}
/**
 * Insert a DBRow: Sends an ajax-request to the backend to insert one database row.
 * @param  {string} controller Name of controller.
 * @param  {string[]} values  Array of rowvalues.
 */
function insertDBRow(controller, values) {
    return $.ajax({
        url: basepath + controller + '/insert',
        type: 'post',
        data: values,
        success: function(data) {
        	//Show message for succeeded request.
            noty({
                'text': data.message,
                'type': (data.code) ? 'success' : 'error'
            });
            return (data.code) ? true : false;
        },
        error: function(data) {
        	//Show message for failed request.
            noty({
                'text': "Uh oh, Request error.",
                'type': 'error'
            });
            return false;
        }
    });
}
/**
 * Delete a DBRow: Sends an ajax-request to the backend to delete one database row.
 * @param  {string} controller Name of controller.
 * @param  {string[]} values  Array of rowvalues.
 */
function deleteDBRow(controller, values) {
    return $.ajax({
        url: basepath + controller + '/delete',
        type: 'post',
        data: values,
        success: function(data) {
        	//Show message for succeeded request.
            noty({
                'text': data.message,
                'type': (data.code) ? 'success' : 'error'
            });
            return (data.code) ? true : false;
        },
        error: function(data) {
        	//Show message for failed request.
            noty({
                'text': "Uh oh, Request error.",
                'type': 'error'
            });
            return false;
        }
    });
}
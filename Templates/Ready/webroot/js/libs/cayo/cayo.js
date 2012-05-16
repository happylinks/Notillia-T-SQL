define('cayo',[
  'jquery',
  'underscore',
  'backbone',
  'bootstrap',
  'tableselect',
  'noty'
], function(
  $, 
  _, 
  Backbone
  )
{
	var cayo = {
		/**
		 * Add the buttonsTemplate to selected jQuery element.
		 * @param {jquery object} object A jQuery element.
		 */
		addButtons: function(object){
			object.html(buttonsTemplate);
		},
		/**
		 * Add the paginationTemplate to selected jQuery element.
		 * @param {jquery object} object A jQuery element.
		 */
		addPagination: function(object){
			object.html(paginationTemplate);
		},
		/**
		 * Generate a modal.
		 * @param  {string} type Type of modal. Values: add,edit,del.
		 * @param  {string} name Name of table.
		 * @param  {string[]} columns Array of columns in row.
		 * @return {jquery object}      jquery object of the modal.
		 */
		generateModal: function(type, name, row) {
			switch (type) {
			case 'add':
				var controlgroups = [], inputs = [];
				_.each(row, function(value, key) {
					input = _.template(defaultinputTemplate,{'name':key,'value':''});
					controlgroup = _.template(controlgroupTemplate,{'name':key,'input':input});
					controlgroups.push(controlgroup);
					inputs.push(input);
				});
				return $(_.template(addmodalTemplate,{'name':name,'controlgroups':controlgroups}));
			break;
			case 'edit':
				var controlgroups = [], inputs = [];
				_.each(row, function(value, key) {
					input = _.template(defaultinputTemplate,{'name':key,'value':value});
					controlgroup = _.template(controlgroupTemplate,{'name':key,'input':input});
					controlgroups.push(controlgroup);
					inputs.push(input);
				});
				return $(_.template(editmodalTemplate,{'name':name,'controlgroups':controlgroups}));
			break;
			case 'del':
			break;
			}
		},
		/**
		 * Generate a new table row with values.
		 * @param  {string[]} values array with values.
		 * @return {jquery object}        the row.
		 */
		generateNewRow: function(values){
			tr = $('<tr>');
		    _.each(values, function(value, key) {
		      td = $('<td>').attr('name', key);
		      td = td.text(value);
		      tr.append(td);
		    });
		    return tr;
		},
		/**
		 * Post add data to tablecontroller.
		 * @param {string} name   name of table.
		 * @param {string[]} values array of data to be submitted.
		 * @param {jquery object} modal  modal to be closed after data is saved.
		 */
		DataPost: function(name, values, method, modal) {
			$.ajax({
			    type: 'POST',
			    url: ''+name+'/'+method,
			    data: values,
			    success: function(message) {
			      type = (message.code) ? 'success' : 'danger';
			      noty({"text": message.message,'type':type});
			      if(modal != undefined){
			      	modal.modal('hide');
			      }
			    }
			});
		},
		/**
		 * Get inputvalues from form in a modal.
		 * @param  {jquery object} modal The modal.
		 * @return {string[]}       array of values from form.
		 */
		getValuesFromModalForm: function(modal) {
			formvalues = {};
		    $('input',modal).each(function(){
		    	formvalues[$(this).attr('name')] = $(this).val();
		    });
		    return formvalues;
		},
		generateCSV: function(name){
			$.ajax({
			    type: 'GET',
			    url: ''+name+'/GetCsv',
			    //data: data,
			    success: function(data) {
			    }
			});
		}
	};
	return cayo;
});
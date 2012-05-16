define([
  'jquery',
  'underscore',
  'backbone',
  'cayo',
  'text!templates/table/grid.html',
  'bootstrap',
  'tableselect',
  'noty'
], function(
  $, 
  _, 
  Backbone,
  cayo,
  gridTemplate
  )
{
  var tablename = 'Bezettingsregel';
  var gridBezettingsregelView = Backbone.View.extend({
    el: $("#notillia_body"),
    render: function(){
      var el = this.el;
      $.ajax({
          url: tablename+'/GetData',
          method: 'get',
          data: {},
          success: function(data) {
            var rows = data;
            var data = { rows: rows, name: tablename, _: _};
            var compiledGrid = _.template( gridTemplate, data);
            
            el.html(compiledGrid);

            //Elements
            var buttons = cayo.addButtons($('span.buttons',el));
            var pagination = cayo.addPagination($('div.pagination',el));
            $('.tip',el).tooltip({placement:'bottom'});
            $('.tiptop',el).tooltip();
            $('.gridtable tr',el).multiSelect();
            $('a[name="search"]',el).live('click',function (){
              $('span.inline-search',$(this).parent().parent()).fadeToggle();
            });

            //Click events
            $('a',buttons).click(function(){
              switch($(this).attr('name')){
                case 'add':
                  modal = cayo.generateModal('add',tablename,rows[0]);
                  modal.modal();
                  $(".modal-footer a[name='save']",modal).click(function(){
                    formvalues = cayo.getValuesFromModalForm(modal);
                    cayo.DataPost(tablename,formvalues,'AddData',modal);
                    newrow = cayo.generateNewRow(formvalues);
                    $('.gridtable',el).append(newrow);
                    $('.gridtable tr',el).multiSelect();
                  });
                break;
                case 'delete':
                  data = [];
                  $('.selected',el).each(function(i){
                    data[i] = {};
                    $('td',this).each(function(){
                      name = $(this).attr('name');
                      value = $(this).text();
                      data[i][name] = value;
                    });
                    cayo.DataPost(tablename,data[i],'DeleteData');
                    $(this).remove();
                  });
                break;
                case 'edit':
                  //Check if user selected only one row.
                  selected = $('.selected',el);
                  if($('.selected',el).length > 1){
                    noty({"text": "You can't edit more then one row, for now.",'type':'information'});
                  }else if($('.selected',el).length == 0){
                    noty({"text": "Please select a row to edit.",'type':'information'});
                  }else{
                    //Grab values of selected row.
                    oldvalues = {};
                    $('td',selected).each(function(){
                      name = $(this).attr('name');
                      value = $(this).text();
                      oldvalues[name] = value;
                    });

                    //Create modal with inputs and values.
                    modal = cayo.generateModal('edit',tablename,oldvalues);
                    modal.modal();

                    //Buttonevent for saving the new values.
                    $(".modal-footer a[name='edit']",modal).click(function(){
                      newvalues = {};
                      
                      //Get new values from modalform.
                      $('input',modal).each(function(){
                        newvalues[$(this).attr('name')] = $(this).val();
                      });
                      
                      //Post the update data.
                      cayo.DataPost('Stuk',{'old':oldvalues,'new':newvalues},'UpdateData',modal);

                      //Edit the tablerow.
                      $('td',selected).each(function(){
                        key = $(this).attr('name');
                        $(this).text(newvalues[key]);
                      });
                    });
                  }
                break;
              }
            });
          }
        });
    }
  });
  return new gridBezettingsregelView;
});
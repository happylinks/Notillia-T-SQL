$(function() {
    handleTabs();

    processGrid($('.master table.grid'));

    handleButtonBar();
    handleTooltips();
    handlePagination();
});

function handlePagination() {
    $('div.pagination ul li').click(function() {
        pagination_name = $(this).attr('name')
        $item = $(this).parents('.item');
        $table = $item.find('table');
        table_type = $table.attr('name');
        table_name = $item.attr('name');
        item_type = false;

        if ($item.hasClass('master')) {
            item_type = 'master';
        }
        if ($item.hasClass('child')) {
            item_type = 'child';
        }

        switch (table_type) {
        case 'grid':
            switch (pagination_name) {
            case 'backward':
                switch (item_type) {
                case 'master':
                    page = parseInt($table.attr('data:page'));
                    if(page!=1){
                        processGrid($table, '', 1);
                    }
                    break;
                case 'child':
                    page = parseInt($table.attr('data:page'));
                    if(page!=1){
                        child = $(this).parents('div.item').attr('name');
                        processChildrenGrid($table, '', 1, '', child);
                    }
                    break;
                }
                break;
            case 'left':
                switch (item_type) {
                case 'master':
                    page = parseInt($table.attr('data:page'));
                    maxpage = parseInt($table.attr('data:maxpage'));
                    newpage = (page <= 1) ? 1 : page-1;
                    if(newpage != page){
                        processGrid($table, '', newpage);
                        $table.attr('data:page',newpage);
                    }
                    break;
                case 'child':
                    page = parseInt($table.attr('data:page'));
                    maxpage = parseInt($table.attr('data:maxpage'));
                    newpage = (page <= 1) ? 1 : page-1;
                    if(page != newpage){
                        child = $(this).parents('div.item').attr('name');
                        processChildrenGrid($table, '', newpage, '', child);
                        $table.attr('data:page',newpage);
                    }
                    break;
                }
                break;
            case 'right':
                switch (item_type) {
                case 'master':
                    page = parseInt($table.attr('data:page'));
                    maxpage = parseInt($table.attr('data:maxpage'));
                    page = (page < 1) ? 1 : page+1;
                    if(page <= maxpage){
                        processGrid($table, '', page);
                        $table.attr('data:page',page);
                    }
                    break;
                case 'child':
                    page = parseInt($table.attr('data:page'));
                    maxpage = parseInt($table.attr('data:maxpage'));
                    page = (page < 1) ? 1 : page+1;
                    if(page <= maxpage){
                        child = $(this).parents('div.item').attr('name');
                        processChildrenGrid($table, '', page, '', child);
                        $table.attr('data:page',page);
                    }
                    break;
                }
                break;
            case 'forward':
                switch (item_type) {
                case 'master':
                    maxpage = parseInt($table.attr('data:maxpage'));
                    $table.attr('data:page',maxpage);
                    processGrid($table, '', maxpage);
                    break;
                case 'child':
                    page = parseInt($table.attr('data:page'));
                    maxpage = parseInt($table.attr('data:maxpage'));
                    if(page != maxpage){
                        $table.attr('data:page',maxpage);
                        child = $(this).parents('div.item').attr('name');
                        processChildrenGrid($table, '', maxpage, '', child);
                    }
                    break;
                }
                break;
            }
            break;
        case 'detail':
            switch (pagination_name) {
            case 'backward':
                break;
            case 'left':
                break;
            case 'right':
                break;
            case 'forward':
                break;
            }
            break;
        }
    });
}

function switchView(item) {
    tablename = item.attr('name');
    $('table', item).toggle();
    $visibletable = $('table:visible', item);
    type = $visibletable.attr('name');

    switch (type) {
    case 'detail':
        selected = $('tr.selected');
        if (selected.length == 1) {
            values = getValuesFromRow(selected);
            processDetail($visibletable, values);
        }else{
            noty({
                'text': "Selected too many or too few rows.",
                'type': 'error'
            });
        }
        break;
    case 'grid':
        processGrid($visibletable);
        break;
    }
}
/**
 * getGrid and fillGrid
 * @param  {jquery obj} table  jQuery reference to table.
 * @param  {string} limit  SQL Limit
 * @param  {string} offset SQL Offset
 * @param  {string[]} where  Array for SQL Where
 */

function processGrid(table, limit, page, where) {
    tablename = table.parents('.item').attr('name');
    getGrid(tablename, limit, page, where, function(data) {
        table.attr('data:maxpage',data['maxpage']);
        maxpage = data['maxpage'];
        delete(data['maxpage']);
        fillGrid(table, data);
        $item = table.parents('.item');
        page = table.attr('data:page');
        $(".pagination li[name='text']",$item).html('<a>'+page+' of '+maxpage+'</a>');
    });
}

function processChildrenGrid(table, limit, page, where, child) {
    tablename = $('table.master').parents('.item').attr('name');
    getChildrenGrid(tablename, limit, page, where, child, function(data) {
        table.attr('data:maxpage',data['maxpage']);
        maxpage = data['maxpage'];
        delete(data['maxpage']);
        fillGrid(table, data);
        $item = table.parents('.item');
        page = table.attr('data:page');
        console.log(page,maxpage);
        $(".pagination li[name='text']",$item).html('<a>'+page+' of '+maxpage+'</a>');
    });
}
/**
 * getDetail and fillDetail
 * @param  {jquery obj} table  jQuery reference to table.
 * @param  {string[]} where  Array for SQL Where
 */

function processDetail(table, where) {
    tablename = table.parents('.item').attr('name');
    getDetail(tablename, where, function(data){
        fillDetail(table, data);
    });
}

/**
 * @namespace  REST functions
 */
/**
 * Get a grid-table from database using ajax.
 * @param  {string} tablename Name of table.
 * @param  {string} limit     SQL Limit
 * @param  {string} offset    SQL Offset
 * @param  {string[]} where     Array for SQL Where
 * @return {json}           Result dataset.
 */

function getGrid(tablename, limit, page, where, callback) {
    $.ajax({
        url: basepath + tablename + '/grid',
        type: 'POST',
        data: {
            'limit': limit,
            'page': page,
            'where': where
        },
        success: function(data) {
            if (data.code == 0) {
                noty({
                    'text': data.message,
                    'type': 'error'
                });
                return false;
            } else {
                callback(data);
            }
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
 * Get a grid-table from database using ajax.
 * @param  {string} mastertable Name of mastertable.
 * @param  {string} limit     SQL Limit
 * @param  {string} offset    SQL Offset
 * @param  {string[]} where     Array for SQL Where
 * @return {json}           Result dataset.
 */

function getChildrenGrid(mastertable, limit, page, where, child, callback) {
    $.ajax({
        url: basepath + mastertable + '/childgrid',
        type: 'POST',
        data: {
            'limit': limit,
            'page': page,
            'where': where,
            'child': child
        },
        success: function(data) {
            if (data.code == 0) {
                noty({
                    'text': data.message,
                    'type': 'error'
                });
                return false;
            } else {
                callback(data);
            }
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
 * Get a row from a table from database using ajax.
 * @param  {string} tablename Name of table.
 * @param  {string[]} where     Array for SQL Where
 * @return {json}           Result row.
 */

function getDetail(tablename, where, callback) {
    $.ajax({
        url: basepath + tablename + '/detail',
        type: 'post',
        data: {
            'tablename': tablename,
            'where': where
        },
        success: function(data) {
            callback(data);
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
 * @namespace Data functions
 */

/**
 * Fill a grid-table with values.
 * @param  {jquery obj} table jQuery reference of table.
 * @param  {object[]} data  Array of Objects with tablevalues.
 * @example
 * data = [
 *          {'stuknr':'1','instrumentnaam':'gitaar','toonhoogte':'','aantal':'5'},
 *          {'stuknr':'2','instrumentnaam':'viool','toonhoogte':'alt','aantal':'7'}
 *        ];
 */

function fillGrid(table, data) {
    table.find("tr:gt(0)").remove();
    if (data != undefined) {
        for(counter in data){
            row = data[counter];
            $tr = $("<tr></tr>");
            for (column in row) {
                if ($("th[name='" + column + "']", table).is(':visible')) {
                    $td = $("<td></td>");
                    $td.attr('name', column).text(row[column]);
                    $td.appendTo($tr);
                }
            }
            $tr.appendTo(table);
        }
    }
    $('tr',table).multiSelect();
}

/**
 * Fill a detail-table with values.
 * @param  {jquery obj} table jQuery reference of table.
 * @param  {object} data  Array of strings.
 * @example
 * data = {
        'stuknr': '1',
        'titel': 'Lisa',
        'genrenaam': 'Jazz',
        'speelduur': 5,
        'componistId': 4,
        'stuknrOrigineel': '',
        'niveaucode': 'A',
        'jaartal': '1942'
    };
 */

function fillDetail(table, data) {
    $('td', table).each(function() {
        name = $(this).attr('name');
        $(this).text(data[name]);
    });
}

/**
 * @namespace  Click events
 */

/**
 * Handles the click-event of the childtabs.
 */

function handleTabs() {
    $('.childtabs li').click(function() {
        $("div.child").hide();
        tablename = $(this).attr('name');
        div = $("div.child[name='" + tablename + "']");
        div.show();
        $(this).parent().children().removeClass('active');
        $(this).addClass('active');
        processChildrenGrid($('table.grid', div), '', '', '', $(this).attr('name'));
    });
}

/**
 * Handles the buttonbar events.
 */

function handleButtonBar() {
    $buttons = $('.buttons a');
    $buttons.click(function() {
        $item = $(this).parents('div.item');
        tablename = $item.attr('name');
        $tables = $item.find('table'); //Tables corresponding to buttons.
        type = $(this).attr('name'); //Name of button
        switch (type) { //Switch on buttonname.
        case 'add':
            $('#add_' + tablename).modal();
            break;
        case 'edit':
            $('#edit_' + tablename).modal();
            break;
        case 'del':
            $('#del_' + tablename).modal();
            break;
        case 'switchview':
            switchView($item);
            break;
        }
    });
}
/**
 * @namespace  Usefull functions
 */

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
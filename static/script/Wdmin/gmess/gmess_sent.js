
DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function($, util, fancyBox, dataTables, Spinner) {

    $(function() {
        var dt = $('.dTable').dataTable(DataTableConfig).api();
    });

});
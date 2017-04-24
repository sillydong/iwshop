
DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function($, util, fancyBox, dataTables) {
    $(function() {
        window.util = util;
        var dt;
        $('#orderlist').load('?/Wdmin/ajaxLoadOrderlist/page=0&status=all&cid=' + $('#cid').val(), function(r) {
            if (r === '0') {
                util.listEmptyTip();
            } else {
                dt = $('.dTable').dataTable(DataTableConfig).api();
                $('.pd-list-viewExp,.od-list-pdinfo').fancybox();
            }
        });
    });
});
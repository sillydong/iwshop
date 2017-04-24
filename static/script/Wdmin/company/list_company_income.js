
DataTableConfig.order = [[0, 'desc']];
requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function($, util, fancyBox, dataTables) {
    $(function() {
        var dt = $('.dTable').dataTable(DataTableConfig).api();
        if ($('#iscom').val() === '1') {
            var pdcount = 0;
            var incomesum0 = 0;
            var incomesum1 = 0;
            $('.income-pdcount').each(function() {
                pdcount += parseInt($(this).html());
            });
            $('.income-float0').each(function() {
                incomesum0 += parseFloat($(this).attr('data-amount'));
            });
            $('.income-float1').each(function() {
                incomesum1 += parseFloat($(this).attr('data-amount'));
            });
            $('#com-orders-pd-count').html(pdcount);
            $('#com-income-count0').html('&yen;' + incomesum0);
            $('#com-income-count1').html('&yen;' + incomesum1);
            $('#com-income-count2').html('&yen;' + (incomesum0 + incomesum1));
            $('#com-orders-count').html($('.dTable tbody tr').length);
        }
    });
});
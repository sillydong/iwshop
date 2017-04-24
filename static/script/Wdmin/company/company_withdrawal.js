
DataTableConfig.order = [[3, 'desc']];
requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function($, util, fancyBox, dataTables) {
    $(function() {
        util.loadCompanyStatNums();
        var dt = $('.dTable').dataTable(DataTableConfig).api();
        $('.company-wd-btn').click(function() {
            if (confirm('你确认 ' + $(this).attr('data-name') + ' 金额为' + $(this).attr('data-amount') + '的账单已结算?')) {
                var id = $(this).attr('data-id');
                if (id > 0) {
                    $.post(shoproot + '?/Company/payCompanyBills/', {
                        id: id
                    }, function(r) {
                        if (r > 0) {
                            util.Alert('操作成功', false, function() {
                                util.loadCompanyStatNums();
                                location.reload();
                            });
                        } else {
                            util.Alert('操作失败');
                        }
                    });
                }
            }
        });

        var pdcount = 0;
        var incomesum = 0;
        $('.pd-count').each(function() {
            pdcount += parseInt($(this).attr('data-amount'));
        });
        $('.pd-amount').each(function() {
            incomesum += parseFloat($(this).attr('data-amount'));
        });
        $('#com-orders-pd-count').html(pdcount);
        var incomesumv = incomesum.toFixed(2);
        $('#com-income-count').html('&yen;' + incomesumv);
    });
});
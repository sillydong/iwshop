/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

DataTableConfig.order = [[3, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function ($, util, fancyBox, dataTables) {
    $(function () {
        var dt = $('.dTable').dataTable(DataTableConfig).api();
        // 结算统计
        var incomesum = 0;
        $('.bill_amounts').each(function () {
            incomesum += parseFloat($(this).attr('data-amount'));
        });
        var incomesumv = incomesum.toFixed(2);
        $('#com-income-count').html('&yen;' + incomesumv);
    });
});
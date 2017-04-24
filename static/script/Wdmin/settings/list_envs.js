/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'datatables'], function ($, util, dataTables) {
    $(function () {

        var dt = $('.dTable').dataTable(DataTableConfig).api();

        $('.envs_del').click(function () {
            if (confirm('你确认要删除么')) {
                var node = $(this);
                $.post('?/wSettings/delteEnvs/', {
                    id: $(this).attr('data-id')
                }, function (res) {
                    if (res > 0) {
                        util.Alert('删除成功');
                        dt.row(node.parents('tr')).remove().draw();
                    } else {
                        util.Alert('操作失败!', true);
                    }
                });
            }
        });

    });
});
/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function ($, util, fancyBox, dataTables) {
    $(function () {

        var dt = $('.dTable').dataTable(DataTableConfig).api();

        fnFancyBox('.add-level,#add-level', function () {
            $('#saveBtn').click(function () {
                var data = $('#settingFrom').serializeArray();
                var id = $(this).attr('data-id');
                $.post('?/wSettings/ajaxAlterEnvs/', {
                    id: id ? id : 0,
                    data: data
                }, function (r) {
                    if (r > 0) {
                        location.reload();
                        util.Alert('修改成功');
                    } else {
                        util.Alert('修改失败', true);
                    }
                    $.fancybox.close();
                });
            });
        });

        $('.envs_del').click(function () {
            if (confirm('你确认要删除么')) {
                var node = $(this);
                $.post('?/wSettings/deleteEnvsRob/', {
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
        
        $('.envs_clear').click(function () {
            if (confirm('你确认要清除领取数据么')) {
                var node = $(this);
                $.post('?/wSettings/clearEnvsRobRecord/', {
                    eid: $(this).attr('data-id')
                }, function (res) {
                    if (res > 0) {
                        util.Alert('清除成功');
                    } else {
                        util.Alert('操作失败!', true);
                    }
                });
            }
        });

    });
});
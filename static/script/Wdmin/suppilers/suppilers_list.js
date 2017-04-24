/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'bootstrap', 'supplier'], function ($, util, fancyBox, bootstrap, supplier) {

    var suppId = false;
    var delBtn = false;

    util.dataTableLis();

    $('#modal_modi_supplier .btn-primary').click(function () {
        var btn = $(this);
        var name = $('#supp_name').val();
        var data = $('#supplier-info').serializeJson();
        if (name !== '') {
            btn.html('处理中');
            supplier.modiSupplier(suppId, data, function (r) {
                if (r.ret_code === 0) {
                    $('#modal_modi_supplier').modal('hide');
                    location.reload();
                    delBtn.parents('tr').remove();
                    if (suppId > 0) {
                        util.Alert('保存成功');
                    } else {
                        util.Alert('添加成功');
                    }
                } else {
                    util.Alert('操作失败', true);
                }
            });
            btn.html('保存');
        }
    });

    $('#modal_modi_supplier').on('show.bs.modal', function (event) {
        delBtn = $(event.relatedTarget);
        suppId = parseInt(delBtn.data('id'));
        if (suppId > 0) {
            supplier.getInfo(suppId, function (r) {
                if (r.ret_code === 0) {
                    $("input[name='supp_name']").val(r.ret_msg.supp_name);
                    $("input[name='supp_phone']").val(r.ret_msg.supp_phone);
                    $("input[name='supp_stime']").val(r.ret_msg.supp_stime);
                    $("input[name='supp_sprice']").val(r.ret_msg.supp_sprice);
                    $("input[name='supp_sarea']").val(r.ret_msg.supp_sarea);
                    $("textarea[name='supp_desc']").val(r.ret_msg.supp_desc);
                } else {
                    util.Alert('加载信息失败', true);
                }
            });
        } else {
            $('#supp_name').val('');
            $('#supp_phone').val('');
        }
    });

    $('#modal_dele_supplier .btn-danger').click(function () {
        var btn = $(this);
        btn.html('删除中');
        supplier.deleteSupplier(suppId, function (r) {
            $('#modal_dele_supplier').modal('hide');
            if (r.ret_code === 0) {
                delBtn.parents('tr').remove();
                util.Alert('删除成功');
            } else {
                util.Alert('删除失败', true);
            }
        });
        btn.html('删除');
    });

    $('#modal_dele_supplier').on('show.bs.modal', function (event) {
        delBtn = $(event.relatedTarget);
        suppId = parseInt(delBtn.data('id'));
    });

});
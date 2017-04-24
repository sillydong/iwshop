/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'bootstrap', 'ztree', 'ztree_loader', 'Spinner'], function ($, util, fancyBox, bootstrap, ztree, treeLoader, Spinner) {

    var suppId = false;
    var delBtn = false;
    var loading = false;

    util.dataTableLis();

    (function () {

        $('.fancybox-skin').css('background', '#fff');
        var inlist = $('#rlist');

        // 初始化目录树
        treeLoader.init('#zlist', '?/vProduct/ajaxGetCategroys/r=' + (new Date()).getTime());

        // 目录树点击回调函数
        treeLoader.setting.callback.onClick = function (event, treeId, treeNode) {
            inlist.html('');
            Spinner.spin(inlist.get(0));
            $.get('?/FancyPage/ajaxPdBlocks/id=' + treeNode.dataId, function (html) {
                inlist.html(html);
                $('.pdBlock').bind('click', pdBlockLis);
            });
        };

        // 商品块 点击监听
        function pdBlockLis() {
            $(this).toggleClass('selected');
            $(this).find('.sel').toggleClass('hov');
        }

    })();

    /**
     * 确认添加规则
     */
    $('#modal_product_select .btn-primary').click(function () {
        var btn = $(this);
        var list = [];
        $('.pdBlock.selected').each(function () {
            if ($.inArray(+$(this).data('id'), list) < 0) {
                list.push(+$(this).data('id'));
            }
        });
        if (!loading) {
            btn.html('处理中');
            // [HttpPost]
            $.post('?/wCredit/add/', {
                ids: list.join(',')
            }, function (r) {
                btn.html('添加');
                if (r.ret_code === 0) {
                    $('#modal_product_select').modal('hide');
                    location.reload();
                    util.Alert('添加成功');
                } else {
                    util.Alert('操作失败', true);
                }
            });
        }
    });

    $('#modal_modi_supplier .btn-primary').click(function () {
        var btn = $(this);
        var name = $('#supp_name').val();
        var phone = $('#supp_phone').val();
        if (name !== '') {
            btn.html('处理中');
            supplier.modiSupplier(suppId, name, phone, function (r) {
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

    /**
     * 删除规则点击
     */
    $('#modal_credit_exchange_delete .btn-danger').click(function () {
        var btn = $(this);
        btn.html('删除中');
        // [HttpPost]
        $.post('?/wCredit/delete/', {
            id: suppId
        }, function (r) {
            btn.html('删除');
            $('#modal_credit_exchange_delete').modal('hide');
            if (r.ret_code === 0) {
                delBtn.parents('tr').remove();
                util.Alert('删除成功');
            } else {
                util.Alert('删除失败', true);
            }
        });
    });

    /**
     * 删除规则
     */
    $('#modal_credit_exchange_delete').on('show.bs.modal', function (event) {
        delBtn = $(event.relatedTarget);
        suppId = parseInt(delBtn.data('id'));
    });

    /**
     * 编辑规则
     */
    $('#modal_credit_exchange_modify').on('show.bs.modal', function (event) {
        delBtn = $(event.relatedTarget);
        suppId = parseInt(delBtn.data('id'));
        $('#edit-credits').val(delBtn.data('credit'));
    });

    /**
     * 编辑规则点击
     */
    $('#modal_credit_exchange_modify .btn-primary').click(function () {
        var amount = $.trim($('#edit-credits').val());
        if (isNaN(amount)) {
            return util.Alert('请输入正确的数字', true);
        }
        var btn = $(this);
        btn.html('处理中');
        // [HttpPost]
        $.post('?/wCredit/modify/', {
            id: suppId,
            amount: amount
        }, function (r) {
            btn.html('保存');
            $('#modal_credit_exchange_modify').modal('hide');
            if (r.ret_code === 0) {
                location.reload();
                util.Alert('保存成功');
            } else {
                util.Alert('保存失败', true);
            }
        });
    });

});
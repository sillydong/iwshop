
/**
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function ($, util, fancyBox, dataTables) {

    util.dataTableLis();

    $('.pd-reversebtn,.reverseAll').bind('click', function () {
        var pid = $(this).attr('data-product-id');
        var tipStr = pid > 0 ? '你确认要还原这个商品吗' : '你确认要还原所有已删除的商品吗';
        if (confirm(tipStr)) {
            var nParent = $(this).parents('tr');
            $.post('?/wProduct/productReverse', {
                pid: $(this).attr('data-product-id')
            }, function (r) {
                if (parseInt(r) > 0) {
                    if (pid > 0) {
                        util.Alert('还原成功');
                        nParent.remove();
                    } else {
                        util.Alert('操作成功');
                        location.reload();
                    }
                } else {
                    util.Alert('还原失败');
                }
            });
        }
    });

    $('.pd-deletebtn,.deleteAll').bind('click', function () {
        var pid = $(this).attr('data-product-id');
        var tipStr = pid > 0 ? '你确认要彻底删除这个商品吗' : '你确认要彻底删除回收站里的商品吗';
        if (confirm(tipStr)) {
            var nParent = $(this).parents('tr');
            $.post('?/wProduct/removeProduct', {
                pid: $(this).attr('data-product-id')
            }, function (r) {
                if (parseInt(r) > 0) {
                    if (pid > 0) {
                        util.Alert('删除成功');
                        nParent.remove();
                    } else {
                        util.Alert('操作成功');
                        location.reload();
                    }
                } else {
                    util.Alert('删除失败');
                }
            });
        }
    });

});
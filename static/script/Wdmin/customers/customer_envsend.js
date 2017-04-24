/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['util', 'fancyBox', 'datatables', 'Spinner', 'jUploader', 'ztree', 'ztree_loader', 'datetimepicker'], function (util, fancyBox, dataTables, Spinner, jUploader, ztree, treeLoader) {

    $.datetimepicker.setLocale('zh');

    $('#dt').datetimepicker({
        format: 'Y-m-d H:i:s'
    });

    var relId = $('#pids').val();

    // 类型选择变化监听
    $('#envsTarget').on('change', function () {
        var hash = $(this).find('option:selected').attr('data-hash');
        $('.typeHash').addClass('hidden');
        $('#' + hash).removeClass('hidden');
    });

    // 3> 选择产品
    fnFancyBox('#sGmess', function () {
        $('.fancybox-skin').css('background', '#fff');

        // 目录树点击回调函数
        treeLoader.setting.callback.onClick = function (event, treeId, treeNode) {
            $('#pds-pdright #inlists').html('');
            Spinner.spin($('#pds-pdright #inlists').get(0));
            $.get('?/WdminAjax/ajax_customer_select_in/id=' + treeNode.dataId, function (html) {
                $('#pds-pdright #inlists').html(html);
                $('.pdBlock').bind('click', pdBlockLis);
                $('#okSProduct').bind('click', okSProduct);
            });
        };

        // 初始化目录树
        treeLoader.init('#pds-catLeft', '?/Uc/getAllGroup/r=' + (new Date()).getTime(), function () {

        });

    });

    /**
     * 商品块 点击监听
     * @returns {undefined}
     */
    function pdBlockLis() {
        $(this).toggleClass('selected');
        $(this).find('.sel').toggleClass('hov');
    }

    /**
     * 商品选择Fancybox回调
     * @returns {undefined}
     */
    function okSProduct() {
        var blocks = $('.pdBlock.selected').clone();
        blocks.removeClass('selected').find('.sel').remove();
        $('#ProductItem').prepend(blocks);
        pdBlockAdjust();
        $.fancybox.close();
    }

    /**
     * 商品选择自适应调整
     * @returns {undefined}
     */
    function pdBlockAdjust() {
        // 删除监听
        var allBlocks = $('#ProductItem .pdBlock');
        var Relid = [];
        allBlocks.hover(function () {
            var i = $('<i class="pd-image-delete"> </i>');
            i.bind('click', function () {
                $(this).parent().fadeOut(function () {
                    $(this).remove();
                    pdBlockAdjust();
                });
            });
            $(this).append(i);
        }, function () {
            $(this).find('.pd-image-delete').remove();
        });
        // 计算relId
        allBlocks.each(function (i, node) {
            $(this).find('.sel').remove();
            Relid.push($(this).attr('data-id'));
        });
        // 赋值
        relId = Relid.join(',');
        // 选择计数
        $('#spdCount').removeClass('hidden').html('已选择' + $('#ProductItem .pdBlock').length + '个产品');
        // 隐藏提示
        $('#spdTip').hide();
    }

    pdBlockAdjust();

    $('#saveBtn').click(function () {
        $('.gmess-sending').show();
        Spinner.spin($('.gmess-sending').get(0));
        $.post('?/wEnvs/send/', {
            envsTarget: $('#envsTarget').val(),
            envsGroup: $('#envsGroup').val(),
            envsIds: relId,
            envsId: $('#envsId').val(),
            envsCount: $('#count').val(),
            envsDt: $('#dt').val()
        }, function (r) {
            if (r > 0) {
                util.Alert('红包发放成功');
            } else {
                util.Alert('操作失败', true);
            }
            Spinner.stop();
            $('.gmess-sending').hide();
        });
    });

});
/* global shoproot */

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

var relId = false;

requirejs(['util', 'fancyBox', 'datatables', 'Spinner', 'jUploader', 'ztree', 'ztree_loader', 'datetimepicker'], function (util, fancyBox, dataTables, Spinner, jUploader, ztree, treeLoader, datetimepicker) {

    $.datetimepicker.setLocale('zh');

    $('#exp').datetimepicker({
        format: 'Y-m-d H:i:s'
    });

    // init
    $('#' + $('#bn-type option:selected').attr('data-hash')).removeClass('hidden');
    relId = parseInt($('#relid').val());

    // 对应调整
    if ($('#relType').val() !== '') {
        switch (parseInt($('#relType').val())) {
            case 0:
                break;
            case 1:
                pdBlockAdjust();
                break;
            case 2:
                gmBlockAdjust();
        }
    }

    // 类型选择变化监听
    $('#bn-type').on('change', function () {
        var hash = $(this).find('option:selected').attr('data-hash');

        var relType = $("#bn-type option:selected").val();
        $('#bn-type').val(relType);

        $('.typeHash').addClass('hidden');
        $('#' + hash).removeClass('hidden');
    });

    // 位置选择变化监听
    $('#bn-position').on('change', function () {
        var position = $("#bn-position option:selected").val();
        if (position == '5' || position == 5) {
            $('#tip').html('首页中间广告展示区域：左侧图对应要显示的图片 建议尺寸380&times;412；右侧图对应要显示的图片 建议尺寸380&times;206');
        } else {
            $('#tip').html('滚动图对应要显示的图片 建议尺寸600&times;290');
        }
        $('#bn-position').val(position);
    });


    // 1> 选择分类
    $('#pd-cat-select').on('change', function () {
        relId = parseInt($(this).val());
    });

    // 2> 选择图文素材
    fnFancyBox('#sGmess', function () {
        $('.gmBlock').bind('click', function () {
            relId = parseInt($(this).attr('data-id'));
            var block = $(this).clone();
            block.find('.sel').remove();
            block.find('.title').width($('#sGmess').width() - 28);
            block.find('.desc').width($('#sGmess').width() - 28);
            block.find('img').width($('#sGmess').width() - 28).height(($('#sGmess').width() - 28) / 1.8125);
            $('#GmessItem').empty().append(block).css({
                marginTop: '10px'
            });
            $('#gmessTip').hide();
            $.fancybox.close();
        });
    });

    // 3> 选择产品
    fnFancyBox('#sProduct', function () {
        $('.fancybox-skin').css('background', '#fff');

        // 目录树点击回调函数
        treeLoader.setting.callback.onClick = function (event, treeId, treeNode) {
            $('#pds-pdright').html('');
            Spinner.spin($('#pds-pdright').get(0));
            $.get('?/FancyPage/ajaxPdBlocks/id=' + treeNode.dataId, function (html) {
                $('#pds-pdright').html(html);
                $('.pdBlock').bind('click', pdBlockLis);
                $('#okSProduct').bind('click', okSProduct);
            });
        };

        // 初始化目录树
        treeLoader.init('#pds-catLeft', '?/vProduct/ajaxGetCategroys/r=' + (new Date()).getTime(), function () {

        });

    });

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
     * 图文选择自适应调整
     * @returns {undefined}
     */
    function gmBlockAdjust() {
        var block = $('.gmBlock').eq(0);
        block.find('.sel').remove();
        block.find('.title').width($('#sGmess').width() - 28);
        block.find('.desc').width($('#sGmess').width() - 28);
        block.find('img').width($('#sGmess').width() - 28).height(($('#sGmess').width() - 28) / 1.8125);
        $('#GmessItem').css({
            marginTop: '10px'
        });
        $('#gmessTip').hide();
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

    /**
     * 商品块 点击监听
     * @returns {undefined}
     */
    function pdBlockLis() {
        $(this).toggleClass('selected');
        $(this).find('.sel').toggleClass('hov');
    }

    $('#delete').click(function () {
        if (confirm('你确认要删除吗')) {
            var tR = $(this).parent().parent();
            var id = $(this).attr('data-id');
            if (id > 0) {
                // [HttpPost]
                $.post('?/WdminAjax/ajaxDeleteBanner/', {
                    id: (-1) * id
                }, function (res) {
                    if (res > 0) {
                        util.Alert('删除成功');
                        location.href = $('#http_referer').val();
                    } else {
                        util.Alert('删除失败', true);
                    }
                });
            }
        }
    });

    $.jUploader({
        button: 'alter_categroy_image',
        action: '?/wImages/ImageUpload/',
        onComplete: function (fileName, response) {
            if (response.ret_code == 0) {
                $('#banner_image').val(response.ret_msg);
                $('#catimage').attr('src', response.ret_msg).fadeIn(function () {
                    $('#loading').height(0);
                    Spinner.stop();
                });
                $('#cat_none_pic').hide();
            } else {
                util.Alert('上传图片失败');
            }
        },
        onUpload: function () {
            $('#catimage').attr('src', '').hide();
            $('#loading').height(100);
            Spinner.spin($('#loading').get(0));
        }
    });

    $('#save').click(function () {
        var id = parseInt($(this).attr('data-id') === '' ? 0 : $(this).attr('data-id'));
        var name = $('#cat_name').val();
        var sort = $('#cat_order').val();
        var img = $('#banner_image').val();
        var type = parseInt($('#bn-type').val());
        var position = $('#bn-position').val();
        var href = $('#link_address').val();
        if (type === 3) {
            relId = parseInt($('#pd-cat-select2').val());
        } else if (type === 0) {
            relId = parseInt($('#pd-cat-select').val());
        }
        if (name === '') {
            util.Alert('请输入滚动图名称');
            return false;
        }
        // [HttpPost]
        $.post('?/WdminAjax/modiBanner/', {
            name: name,
            sort: sort,
            relId: relId,
            img: img,
            id: id,
            pos: position,
            type: type,
            href: href,
            exp: $('#exp').val()
        }, function (res) {
            if (res > 0) {
                if (id === '') {
                    $('#save').attr('data-id', res);
                }
                util.Alert('保存成功');
            } else {
                util.Alert('保存失败', true);
            }
        });
    });

});
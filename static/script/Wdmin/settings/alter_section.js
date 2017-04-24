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
requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner', 'jUploader', 'ztree', 'ztree_loader', 'datetimepicker', 'bootstrap'], function ($, util, fancyBox, dataTables, Spinner, jUploader, ztree, treeLoader, bootstrap) {

    //var relId = $('#pids').val(); //delete by mu 2016-01-26

    $.datetimepicker.setLocale('zh');

    $('#dt1').datetimepicker({
        format: 'Y-m-d H:i:s'
    });
    $('#dt2').datetimepicker({
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
        $('#relType').val(relType);

        if (relType == 4 || relType == '4') {
            $('#corrPic').addClass('hidden');
        } else {
            $('#corrPic').removeClass('hidden');
        }
        $('.typeHash').addClass('hidden');
        $('#' + hash).removeClass('hidden');
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

    //(function () {
    //
    //    $('.fancybox-skin').css('background', '#fff');
    //    var inlist = $('#rlist');
    //
    //    // 目录树点击回调函数
    //    treeLoader.onclick(function (event, treeId, treeNode) {
    //        inlist.html('');
    //        Spinner.spin(inlist.get(0));
    //        $.get('?/FancyPage/ajaxPdBlocks/id=' + treeNode.dataId, function (html) {
    //            inlist.html(html);
    //            $('.pdBlock').bind('click', pdBlockLis);
    //        });
    //    });
    //
    //    // 初始化目录树
    //    treeLoader.init('#zlist', '?/vProduct/ajaxGetCategroys/r=' + (new Date()).getTime());
    //
    //    // 商品块 点击监听
    //    function pdBlockLis() {
    //        $(this).toggleClass('selected');
    //        $(this).find('.sel').toggleClass('hov');
    //    }
    //
    //})();

    ///**
    // * 确认商品选择
    // */
    //$('#modal_product_select .btn-primary').click(function () {
    //    var blocks = $('.pdBlock.selected').clone();
    //    blocks.removeClass('selected').find('.sel').remove();
    //    $('#ProductItem').prepend(blocks);
    //    pdBlockAdjust();
    //    $('#modal_product_select').modal('hide');
    //});

    ///**
    // * 商品选择自适应调整
    // * @returns {undefined}
    // */
    //function pdBlockAdjust() {
    //    // 删除监听
    //    var allBlocks = $('#ProductItem .pdBlock');
    //    var Relid = [];
    //    allBlocks.hover(function () {
    //        var i = $('<i class="pd-image-delete"> </i>');
    //        i.bind('click', function () {
    //            $(this).parent().fadeOut(function () {
    //                $(this).remove();
    //                pdBlockAdjust();
    //            });
    //        });
    //        $(this).append(i);
    //    }, function () {
    //        $(this).find('.pd-image-delete').remove();
    //    });
    //    // 计算relId
    //    allBlocks.each(function (i, node) {
    //        $(this).find('.sel').remove();
    //        Relid.push($(this).attr('data-id'));
    //    });
    //    // 赋值
    //    relId = Relid.join(',');
    //    // 选择计数
    //    $('#spdCount').removeClass('hidden').html('已选择' + $('#ProductItem .pdBlock').length + '个产品');
    //    // 隐藏提示
    //    $('#spdTip').hide();
    //}
    //
    //pdBlockAdjust();

    // 图片上传
    $.jUploader({
        button: 'upload_banner',
        action: '?/wImages/ImageUpload/',
        onComplete: function (fileName, response) {
            if (response.ret_code == 0) {
                $('#banner').val(response.ret_msg);
                $('#loading').height(0);
                $('#catimage').attr('src', response.ret_msg).fadeIn(function () {
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

    $('#saveBtn').click(function () {
        var banner = $('#banner').val();
        var id = $(this).attr('data-id');
        var relType = parseInt($('#relType').val());
        if (relType === 4) {
            relId = $('#link_ad').val(); //获取广告链接
        }

        if ($('#name').val() === '') {
            return util.Alert('请输入板块名称', true);
        }

        $.post('?/wSettings/alterSection/', {
            banner: banner,
            name: $('#name').val(),
            pid: relId,
            id: id,
            relType: relType,
            relId: $('#pd-cat-select').val(),
            ftime: $('#dt1').val(),
            ttime: $('#dt2').val(),
            bsort: +$('#bsort').val()
        }, function (r) {
            if (r > 0) {
                if (id > 0) {
                    $('#saveBtn').attr('data-id', r);
                    util.Alert('保存成功');
                } else {
                    util.Alert('添加成功');
                    window.setTimeout(function () {
                        location.href = '?/WdminPage/settings_section';
                    }, 2000);
                }
            } else {
                util.Alert('操作失败', true);
            }
        });
    });

    //删除广告图片
    $('#delete_banner').click(function () {
        $('#banner').val('');
        $('#catimage').attr('src', '');
        $('#catimage').after("<div style='line-height: 100px;color:#777;' class='align-center' id='cat_none_pic'>无图片</div>");

    });


});
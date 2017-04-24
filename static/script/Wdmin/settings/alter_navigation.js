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

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner', 'jUploader', 'ztree', 'ztree_loader', 'datetimepicker', 'bootstrap'], function ($, util, fancyBox, dataTables, Spinner, jUploader, ztree, treeLoader, bootstrap) {

    var relId = $('#pids').val();
    var navType = -1;

    $.datetimepicker.setLocale('zh');

    $('#dt1').datetimepicker({
        format: 'Y-m-d H:i:s'
    });
    $('#dt2').datetimepicker({
        format: 'Y-m-d H:i:s'
    });

    (function () {
        $('.fancybox-skin').css('background', '#fff');
        var inlist = $('#rlist');

        // 目录树点击回调函数
        treeLoader.onclick(function (event, treeId, treeNode) {
            inlist.html('');
            Spinner.spin(inlist.get(0));
            $.get('?/FancyPage/ajaxPdBlocks/id=' + treeNode.dataId, function (html) {
                inlist.html(html);
                $('.pdBlock').bind('click', pdBlockLis);
            });
        });

        // 初始化目录树
        treeLoader.init('#zlist', '?/vProduct/ajaxGetCategroys/r=' + (new Date()).getTime());

        // 商品块 点击监听
        function pdBlockLis() {
            $(this).toggleClass('selected');
            $(this).find('.sel').toggleClass('hov');
        };

    })();

    /**
     * 确认商品选择
     */
    $('#modal_product_select .btn-primary').click(function () {
        var blocks = $('.pdBlock.selected').clone();
        blocks.removeClass('selected').find('.sel').remove();
        $('#ProductItem').prepend(blocks);
        pdBlockAdjust();
        $('#modal_product_select').modal('hide');
    });

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

    // 图片上传
    $.jUploader({
        button: 'upload_banner',
        action: '?/wImages/ImageUpload/',
        onComplete: function (filenav_name, response) {
            if (response.ret_code == 0) {
                $('#nav_ico').val(response.ret_msg);
                $('#loading').height(0);
                $('#catimage').attr('src', response.ret_msg).fadeIn(function () {
                    Spinner.stop();
                });
                $('#cat_none_pic').hide();
            } else {
                alert('上传图片失败，请联系技术支持');
            }
        },
        onUpload: function () {
            $('#catimage').attr('src', '').hide();
            $('#loading').height(100);
            Spinner.spin($('#loading').get(0));
        }
    });

    $('#saveBtn').click(function () {
        var nav_ico = $('#nav_ico').val();
        var id = $(this).attr('data-id');

        if ($('#nav_name').val() === '') {
            return util.Alert('请输入导航名称', true);
        }

        $.post('?/wSettings/alterNavigation/', {
            nav_ico: nav_ico,
            nav_name: $('#nav_name').val(),
            id: id,
            nav_type: navType,
            nav_content: navType == 0 ? $('#menu-url-ed').val() : $('#pd-cat-select option:selected').val(),
            relId: $('#pd-cat-select').val(),
            sort: $('#sort').val()
        }, function (r) {
            if (r > 0) {
                if (id > 0) {
                    $('#saveBtn').attr('data-id', r);
                    util.Alert('保存成功');
                } else {
                    util.Alert('添加成功');
                    window.setTimeout(function () {
                        location.href = '?/WdminPage/settings_navigation';
                    }, 2000);
                }
            } else {
                util.Alert('操作失败', true);
            }
        });
    });

    $('#rad1').unbind('click').on('click', function () {
        $('.acts').hide();
        $('#act1').show();
        navType = 1;
    });

    $('#rad2').unbind('click').on('click', function () {
        $('.acts').hide();
        $('#act2').show();
        navType = 0;
    });

});
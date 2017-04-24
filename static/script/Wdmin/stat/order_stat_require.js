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
requirejs(['jquery','jqPaginator','fancyBox', 'Spinner', 'ztree', 'ztree_loader'], function ($,jqPaginator ,fancyBox, Spinner, ztree, treeLoader) {

    var openids = [];
    openids[0] = [];
    openids[1] = [];
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
                $('#okSProduct').bind('click', pdBlockAdjust);
            });
        };

        // 初始化目录树
        treeLoader.init('#pds-catLeft', '?/vProduct/ajaxGetCategroys/r=' + (new Date()).getTime(), function () {

        });

    });

    /**
     * 商品选择自适应调整
     * @returns {undefined}
     */
    function pdBlockAdjust() {
        var Relid = [];
        var Relname =[];
        // 计算relId
        $('.pdBlock.selected').each(function () {
            //$(this).find('.sel').remove();
            Relid.push($(this).attr('data-id'));
            Relname.push($(this).attr('data-name'));
        });
        // 赋值
        relId = Relid.join(',');
        relName = Relname.join(',');
        if( relId !='' && relId != null){
            $('#product').val(relId);
            //alert(relUID);
        }
        if( relName !='' && relName != null){
            $('#selectProducts').val(relName);
            //alert(relProduct);
        }

        $.fancybox.close();

    }

    /**
     * 商品块 点击监听
     * @returns {undefined}
     */
    function pdBlockLis() {
        $(this).toggleClass('selected');
        $(this).find('.sel').toggleClass('hov');
    }


    var custype = 0;
    fnFancyBox('#add-notifyer', function () {
        fnFancyLis(1);
    });

    /**
     *
     * @param {type} type
     * @returns {undefined}
     */
    function fnFancyLis(type) {
        custype = type;
        $('.ztree li').eq(0).click();
        $('.fancybox-skin').css('background', '#fff');
        // 目录树点击回调函数
        treeLoader.setting.callback.onClick = function (event, treeId, treeNode) {
            $('#pds-pdright #inlists').html('');
            Spinner.spin($('#pds-pdright #inlists').get(0));
            $.get('?/WdminAjax/ajax_customer_select_in/id=' + treeNode.dataId, function (html) {
                $('#pds-pdright #inlists').html(html);
                $('.pdBlock').bind('click', userBlockLis);
                $('#okSProduct').bind('click', confirmCurtomer);
            });
        };
        // 初始化目录树
        treeLoader.init('#pds-catLeft', '?/Uc/getAllGroup/r=' + (new Date()).getTime(), function () {
            $('.ztree li').eq(0).click();
        });
    }


    function confirmCurtomer() {
        var list = [];
        var Reluid = [];
        var Productuid = [];
        $('.pdBlock.selected').each(function () {
                Reluid.push($(this).attr('data-id'));
                Productuid.push($(this).attr('data-name'));
        });
        var relUID = Reluid.join(',');
        var relProduct = Productuid.join(',');
        if( relUID !='' && relUID != null){
            $('#uid').val(relUID);
        }
        if( relProduct !='' && relProduct != null){
            $('#selectUsers').val(relProduct);
        }

        $.fancybox.close();
    }

    /**
     * 商品块 点击监听
     * @returns {undefined}
     */
    function userBlockLis() {
        $(this).toggleClass('selected');
        $(this).find('.sel').toggleClass('hov');
    }



});
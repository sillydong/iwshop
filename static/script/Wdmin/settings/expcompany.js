/* global hov */

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['util', 'fancyBox', 'datatables', 'Spinner', 'jUploader', 'ztree', 'ztree_loader', 'baiduTemplate'], function (util, fancyBox, dataTables, Spinner, jUploader, ztree, treeLoader, baiduTemplate) {

    var hov = $('#expcompany').val();
    var openids = [];
    openids[0] = [];
    openids[1] = [];

    if (hov !== '') {
        $('.expitem').each(function () {
            if (hov.indexOf($(this).attr('data-k')) !== -1) {
                $(this).addClass('hov');
            }
        });
    }

    $('.expitem').click(function () {
        $(this).toggleClass('hov');
    });

    /**
     * 获取openid列表
     * @param {type} Wrap
     * @returns {Array}
     */
    function fnGetopenids(Wrap) {
        var openid = [];
        $(Wrap + ' .usrItem').each(function () {
            if ($(this).attr('data-openid') !== '' && $(this).attr('data-openid') !== undefined) {
                openid.push($(this).attr('data-openid'));
            }
        });
        return openid;
    }

    openids[0] = fnGetopenids('#couriers');
    openids[1] = fnGetopenids('#notifyer');

    $('#saveBtn').click(function () {
        hov = [];
        $('.expitem.hov').each(function () {
            hov.push($(this).attr('data-k'));
        });
        var exps = [];
        $('#couriers .usrItem').each(function () {
            if (!$(this).hasClass('add')) {
                exps.push($(this).attr('data-openid'));
            }
        });
        var notys = [];
        $('#notifyer .usrItem').each(function () {
            if (!$(this).hasClass('add')) {
                notys.push($(this).attr('data-openid'));
            }
        });
        // [HttpPost]
        $.post('?/wSettings/updateSettings/', {
            data: [
                {
                    name: 'expcompany',
                    value: hov.join(',')
                },
                {
                    name: 'order_notify_openid',
                    value: notys.join(',')
                },
                {
                    name: 'order_express_openid',
                    value: exps.join(',')
                }
            ]
        }, function (r) {
            if (r > 0) {
                util.Alert('保存成功');
            } else {
                util.Alert('保存失败', true);
            }
        });
    });
    var custype = 0;
    fnFancyBox('#add-notifyer', function () {
        fnFancyLis(1);
    });
    fnFancyBox('#add-couriers', function () {
        fnFancyLis(0);
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
                $('.pdBlock').bind('click', pdBlockLis);
                $('#okSProduct').bind('click', confirmCurtomer);
            });
        };
        // 初始化目录树
        treeLoader.init('#pds-catLeft', '?/Uc/getAllGroup/r=' + (new Date()).getTime(), function () {
            $('.ztree li').eq(0).click();
        });
    }

    /**
     * fnRemoveUsr
     * @returns {undefined}
     */
    function fnRemoveUsr() {
        $('.usrItem b').unbind('click').bind('click', function () {
            var type = +$(this).parents('.fv2Right').attr('data-type');
            var openid = $(this).parents('.usrItem').attr('data-openid');
            for (var i in openids[type]) {
                if (openids[type][i] === openid) {
                    $(this).parents('.usrItem').remove();
                    delete openids[type][i];
                }
            }
        });
    }

    function confirmCurtomer() {
        var list = [];
        $('.pdBlock.selected').each(function () {
            if ($.inArray($(this).attr('data-openid'), openids[custype]) === -1) {
                list.push({
                    src: $(this).find('img').attr('src'),
                    uname: $(this).find('.title').html(),
                    openid: $(this).attr('data-openid')
                });
                openids[custype].push($(this).attr('data-openid'));
            }
        });
        var html = baidu.template('t:usrlist', {
            list: list
        });
        if (custype === 0) {
            $('#couriers').prepend(html);
        } else {
            $('#notifyer').prepend(html);
        }
        fnRemoveUsr();
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

    fnRemoveUsr();

});
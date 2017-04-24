/* global shoproot */

/**
 * 常用工具函数
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
define(['jquery'], function ($) {

    var util = {};

    util.log = function (v) {
        console.log(v);
    };

    util.bottomNavSwitch = function (link) {
        $('.bottom_nav div.hover').removeClass('hover');
        $(".bottom_nav div[data-href='" + link + "']").addClass('hover');
    };

    util.fnTouchEndRedirect = function (node, func) {
        $(node).bind('touchstart mousedown', function (event) {
            util.touchNode = $(this);
            $('.hover', $(node).parent()).removeClass('hover');
            $(this).addClass('hover');
            $(this).attr('touchStartTime', (new Date()).getTime());
        });
        $(node).bind('touchend mouseup', function (event) {
            var endTime = (new Date()).getTime();
            if (endTime - parseInt($(this).attr('touchStartTime')) < 70) {
                // 触摸间隔低于70ms，判断为点击，否则忽略
                var href = util.touchNode.attr('href') || util.touchNode.attr('data-href');
                if (href && href !== '') {
                    if (func !== undefined) {
                        func(href, $(this));
                    }
                }
            }
            endTime = null;
            // 取消设备默认点击反馈
            event.preventDefault();
        });
    };

    /**
     * 废弃
     * @param node
     * @param func
     */
    util.fnTouchEnd = function (node, func) {
        $(node).bind('touchend mouseup', function (event) {
            if (func !== undefined) {
                func($(this));
            }
            // 取消设备默认点击反馈
            event.preventDefault();
        });
    };

    /**
     * resize绑定函数
     * @param func
     * @param node
     */
    util.onresize = function (func, node) {
        node = node || window;
        node.onresize = func;
        func();
    };

    util.q = function (str) {
        return document.querySelector(str);
    };

    util.searchListen = function () {
        $('.search-w-box').bind('submit', function () {
            var form = this;
            var inp = $('input[type=search]', form);
            if (inp.val() === '') {
                return;
            } else {
                var target = inp.attr('targ');
                target = encodeURIComponent(target + '&searchkey=' + inp.val());
                location.href = shoproot + '?/vSearch/rd/href=' + target + '&searchkey=' + encodeURI(inp.val());
            }
            return false;
        });
    };

    /**
     * 获取配置
     * @param {type} callback
     * @returns {undefined}
     */
    util.getconfig = function (callback) {
        $.post(shoproot + '?/Order/ajaxGetSettings/', {}, callback);
    };

    /**
     * 获取运费模板
     * @param {type} callback
     * @returns {undefined}
     */
    util.getExpTemplate = function (callback) {
        $.post(shoproot + '?/Order/ajaxGetExpTemplate/', {}, callback);
    };

    /**
     * 获取日期字符串
     * 获取AddDayCount天后的日期
     * @param AddDayCount
     * @returns {string}
     */
    util.getDateStr = function (AddDayCount) {
        var a = new Array("日", "一", "二", "三", "四", "五", "六");
        var dd = new Date();
        dd.setDate(dd.getDate() + AddDayCount);//获取AddDayCount天后的日期
        var y = dd.getFullYear();
        var m = dd.getMonth() + 1;//获取当前月份的日期
        var d = dd.getDate();
        return y + "-" + m + "-" + d + " (星期" + a[dd.getDay()] + ')';
    };

    return util;
});
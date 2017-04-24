'use strict';

/* global angular */

var services = angular.module('Util.services', []);

function _process_error() {

}

services.factory('Util', ['$http', function ($http) {
    return {
        /**
         * Alert
         * @param {type} message
         * @param {type} warn
         * @param {type} callback
         * @returns {undefined}
         */
        alert: function (message, warn, callback) {
            warn = warn || false;
            if (warn === true) {
                warn = 'error'
            } else if (warn === false) {
                warn = 'success'
            }
            Lobibox.notify(warn, {
                soundPath: '//cdn.iwshop.org/public/sounds/',
                sound: false,
                position: 'top center',
                size: 'mini',
                delay: 5000,
                msg: message,
                delayIndicator: false
            });
        },
        /**
         * Alert
         * @param message
         * @param warn
         * @param callback
         * @constructor
         */
        Alert: function (message, warn, callback) {
            warn = warn || false;
            if (warn === true) {
                warn = 'error'
            } else if (warn === false) {
                warn = 'success'
            }
            Lobibox.notify(warn, {
                soundPath: '//cdn.iwshop.org/public/sounds/',
                sound: false,
                position: 'top center',
                size: 'mini',
                delay: 5000,
                msg: message,
                delayIndicator: false
            });
        },
        /**
         * 分页插件
         * @param {type} total
         * @param {type} func
         * @returns {undefined}
         */
        initPaginator: function (total, func) {
            $(".pagination").jqPaginator({
                totalPages: total,
                onPageChange: func
            });
        },
        /**
         * loading开始
         * @returns {boolean}
         */
        loading: function (status) {
            if (status === undefined) {
                status = true;
            }
            if (!status) {
                return $('.__LOADING__').hide();
            }
            if ($('.__LOADING__').length > 0) {
                $('.__LOADING__').eq(0).show();
                return false;
            }
            var blocksize = 70;
            var imgsize = 40;
            var block = $('<div class="__LOADING__"><img src="static/images/icon/iconfont-loading.png" /></div>');
            block.css({
                height: blocksize,
                width: blocksize,
                borderRadius: '5px',
                background: 'rgba(0,0,0,0.3)',
                position: 'fixed',
                cursor: 'progress',
                zIndex: 9999
            });
            block.find('img').css({
                width: imgsize,
                marginTop: (blocksize - imgsize) / 2,
                marginLeft: (blocksize - imgsize) / 2,
                '-webkit-animation-name': 'rotate',
                '-webkit-animation-duration': '1.3s',
                '-webkit-animation-iteration-count': 'infinite',
                '-webkit-animation-timing-function': 'linear'
            });
            $(window).bind('resize', function () {
                block.css({
                    left: ($(window).width() - blocksize) / 2,
                    top: ($(window).height() - blocksize) / 2,
                });
            }).resize();
            $('body').append(block);
            return true;
        },
        /**
         * 获取系统日志
         * @param p
         * @returns {*}
         */
        getSystemLogs: function (p) {
            return $http.get('?/wSystem/getSystemLogs/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        }
    };
}]);
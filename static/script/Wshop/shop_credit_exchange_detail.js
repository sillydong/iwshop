/**
 * Created by muqing on 2016-02-01.
 */
/* global address_item_click, CryptoJS, wx, WeixinJSBridge, shoproot, addrsignPackage, address_save, o */

/**
 * 购物车
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

// order id 生成标记
window.orderId = false;
// 支付完成标记
window.payed = false;
// 收货地址加载标记
window.addressloaded = false;
// 收货地址
window.expressData = {};
// lock
window.orderCreateLock = false;
// 初始运费
window.yunfeiInitial = 6.95;

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner', 'Cart', 'mobiscroll'], function (util, $, Spinner, Cart, mobiscroll) {


        var o = {};

        o.cartData = '';

        // localStorage对象
        o.Storage = window.localStorage;

        // 系统设置
        o.settings = {};

        // 加载购物车数据
        o.loadCartData = function () {
            // 加载收货地址缓存数据
            localStorageAddrCache();

        };


        /**
         * localStorage 地址缓存
         * @returns {undefined}
         */
        function localStorageAddrCache() {
            if (o.Storage && o.Storage.getItem('addr-set') === "1" && o.Storage.getItem('orderAddress')) {
                expressData = JSON.parse(o.Storage.getItem('orderAddress'));
                if (typeof expressData.provinceName != 'undefined') {
                    // 收货地址加载标记
                    window.addressloaded = true;
                    // 显示收货地址
                    addressShow();
                } else {
                    expressData = {};
                }
            }else{
                alert('缓存地址加载异常');
            }
        }

        /**
         * 原始数据测试
         * @returns {undefined}
         */
        function loadTestAddrData() {
            var res = {
                provinceName: '广东',
                cityName: '广州市',
                countryName: '天河区',
                detailInfo: '新燕花园三期1201 ',
                postalCode: 510006,
                telNumber: 18565518404,
                userName: '陈永才'
            };
            res.Address = res.provinceName + res.cityName + res.countryName + res.detailInfo;
            res.errMsg = 'openAddress:ok';
            addAddressCallback(res);
        }

        window.loadTestAddrData = loadTestAddrData;

        /**
         * 获取收货地址回调函数
         * @param {type} res
         * @returns {undefined}
         */
        function addAddressCallback(res) {

            if (res.errMsg === 'openAddress:ok') {
                window.expressData = res;
                expressData.Address = expressData.provinceName + expressData.cityName + expressData.countryName + expressData.detailInfo;
                res.Address = expressData.Address;
                
                // 缓存到Storage
                o.Storage.setItem('addr-set', '1');
                o.Storage.setItem('orderAddress', JSON.stringify(res));
                // 收货地址加载标记
                window.addressloaded = true;
                addressShow();
                // 地址变动 重新计算订单总额
                o.countAmount();
            } else {
                $('#wrp-btn').html('授权失败');
            }
        }

        /**
         * 显示收货地址数据
         */
        function addressShow() {
            $('#wrp-btn').remove();
            $('#express-name').html(expressData.userName);
            $('#express-person-phone').html(expressData.telNumber);
            $('#express-address').html(expressData.Address);
        }

        // 传出全局
        window.addAddressCallback = addAddressCallback;

        /**
         * 获取收货地址
         * @returns {undefined}
         */
        function fnSelectAddr() {
            if ($('#addrOn').val() === '1') {
                wx.openAddress({
                    success: function (res) {
                        // 用户成功拉出地址 
                        addAddressCallback(res);
                    },
                });
            } else {
                alert("授权失败");
                // 授权失败
            }
        }

        /**
         * 选择收货地址
         */
        $('#express_address').click(fnSelectAddr);

        /**
         * 确定兑换
         */
        $('#credit-exchange-btn').click(function () {
            var pid = $('#pid').val();
            var cre = $('#credit').val();

            // 判断收货地址是否已经获取
            if (!addressloaded) {
                fnSelectAddr();
                return false;
            }

            if (false === window.addressloaded && typeof wx !== "undefined") {
                wx.openAddress({
                    success: function (res) {
                     // 用户成功拉出地址 
                       addAddressCallback(res);
                    },
                });
                return false;
            }

            if (pid > 0) {

                if (confirm('您确定要以' + cre + '积分兑换此商品吗')) {
                    // [HttpPost]
                    $.post('?/Uc/credit_exchange_confirm/', {
                        pid     : pid,
                        addrData: JSON.stringify(expressData)
                    }, function (r) {
                        if (r.ret_code === 0) {
                            alert('兑换成功');
                            location.href = '?/Uc/home/';
                        } else {
                            alert('兑换失败，您的积分不足');
                        }
                    });
                }
            }else{
                alert('兑换商品不存在，请选择其他商品');
            }
        });

        util.onresize(
            function () {
                // 输入框调整
                $('#remark').width($(window).width() - 100);
            }
        );


        util.getconfig(function (f) {

            o.settings = f;

            // 加载运费模板
            util.getExpTemplate(function (f1) {
                o.ExpFeeTemplate = f1;
                // 加载购物车数据
                o.loadCartData();
            });

            fnLoadExptimeSelector();

        });

        /**
         * 配送时间选择器
         */
        function fnLoadExptimeSelector() {

            if (o.settings && o.settings['dispatch_day_zone'] && o.settings['dispatch_day'] && o.settings['dispatch_day'] != '' && o.settings['dispatch_day'] >= 0) {

                var wheelLeft = [];

                // 循环生成左侧日期
                for (var i = 0; i <= o.settings['dispatch_day']; i++) {
                    wheelLeft.push(util.getDateStr(i));
                }

                $('#input-exptime').mobiscroll().scroller({
                    theme: 'ios',
                    lang: 'zh',
                    display: 'bottom',
                    mode: 'scroller',
                    height: 35,
                    wheels: [[
                        {
                            values: wheelLeft
                        },
                        {
                            values: o.settings['dispatch_day_zone'].split(',')
                        }
                    ]],
                    onSelect: function (text) {
                        $('#exptime').val(text);
                        $('#input-exptime-label').html(text);
                    }
                });

            }

        }

    });

});

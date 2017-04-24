/* global wx */

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */


require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner'], function (util, $, Spinner) {
        
        $('.userHead').addClass('active');

        $('.reqAmountBtn').click(function () {
            $('.reqAmountBtn.hov').removeClass('hov');
            $(this).addClass('hov');
        });

        $('.reqAmountBtn').eq(0).click();

        $('#wechat-payment-btn').click(function () {
            var reqAmount = parseFloat($('.reqAmountBtn.hov').attr('data-val'));
            var reqRemain = parseFloat($('#reqAmountTotal').attr('data-amount'));
            if (reqAmount > reqRemain) {
                reqAmount = reqRemain;
            }
            $('#wechat-payment-btn').addClass('disable').html('正在生成订单...');
            // 发起付款
            $.post(shoproot + "?/Order/ajaxGetBizPackageReq/", {
                orderId: $('#orderId').val(),
                amount: reqAmount
            }, function (bizPackage) {
                $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
                // 订单映射
                bizPackage.success = function () {
                    alert('付款成功, 谢谢支持');
                    location.href = shoproot + '?/Uc/home/';
                };
                // 发起微信支付
                wx.chooseWXPay(bizPackage);
            });
        });

    });

});
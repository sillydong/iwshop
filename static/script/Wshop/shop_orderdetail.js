/* global wx, shoproot, parseFloat */

/**
 * 订单信息查看
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner'], function (util, $,Spinner) {
    
        // 加载快递配送信息
        if ($('#expresscode').val() !== '' && $('#express-dt').length > 0) {
            Spinner.spin($("#loading-wrap").get(0), 200);
                        
            $.post('?/Order/ajaxGetExpressDetails', {
                com: $('#expresscom').val(),
                nu: $('#expresscode').val()
            }, function (res) {
                res = res.replace(/\d{4}-0?/g, '');
                $('#express-dt').html(res);
                $('#loading-wrap').remove();
                Spinner.stop();
            });
        }

        function fnComfirmOrder() {
            var orderId = parseInt($(this).data('id'));
            if (orderId > 0) {
                if (confirm('你确认收到货品了吗?')) {
                    $.post('?/Order/confirmExpress', {orderId: orderId}, function (res) {
                        res = parseInt(res);
                        if (res > 0) {
                            alert('确认收货成功！');
                            if ($('#expresscode')) {
                                window.location.reload();
                            }
                        } else {
                            alert('确认收货失败！');
                        }
                    });
                }
            }
        }

        function fnComfirmExpressed() {
            var orderId = parseInt($(this).data('id'));
            if (orderId > 0) {
                if (confirm('你确认物品已经送达?')) {
                    $.post('?/Order/confirmExpress', {orderId: orderId}, function (res) {
                        res = parseInt(res);
                        if (res > 0) {
                            alert('配送确认成功！');
                            if ($('#expresscode')) {
                                // window.location.reload();
                            }
                        } else {
                            alert('配送确认失败！');
                        }
                    });
                }
            }
        }

        $('#express-confirm').bind('click', fnComfirmExpressed);
        $('#order-confirm').bind('click', fnComfirmOrder);

    });

});
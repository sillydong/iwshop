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

    require(['util', 'jquery'], function (util, $) {

        $('.productList').click(function () {
            var pid = $(this).data('id');
            var cre = $(this).data('credit');
            if (pid > 0) {
                // [HttpPost]
                $.post('?/Uc/credit_exchange_check/', {
                    pid: pid
                }, function (r) {
                    if (r.ret_code === 0) {
                        location.href = '?/Uc/credit_exchange_detail/pid='+pid+'&credit='+cre;
                        //if (confirm('您确定要以' + cre + '积分兑换此商品吗')) {
                        //    // [HttpPost]
                        //    $.post('?/Uc/credit_exchange_confirm/', {
                        //        pid: pid
                        //    }, function (r) {
                        //        if (r.ret_code === 0) {
                        //            alert('兑换成功');
                        //            // location.href = '?/Uc/home';
                        //        } else {
                        //            alert('对不起，您的积分不足');
                        //        }
                        //    });
                        //}
                    } else {
                        alert('对不起，您的积分不足');
                    }
                });
            }
        });

    });
});
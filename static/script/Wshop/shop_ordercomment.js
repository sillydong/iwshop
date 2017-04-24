/* global wx, shoproot, parseFloat */

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

        var loading = false;
        var stars = 4;

        $('.starItem').click(function () {
            stars = +$(this).attr('data-id');
            $('.starItem.fill').removeClass('fill');
            for (var i = 0; i < stars + 1; i++) {
                $('.starItem').eq(i).addClass('fill');
            }
        });

        $('#odsubmit').click(function () {
            var orderId = +$('#order_id').val();
            var commentText = $('#commentText').val();
            if (!loading && orderId > 0) {
                loading = true;
                $.post('?/Order/addComment/', {
                    orderId: orderId,
                    commentText: commentText,
                    stars: stars
                }, function (r) {
                    if (r.ret_code === 0) {
                        alert('评价成功');
                        history.go(-1);
                    } else {
                        alert('评价失败，系统错误');
                    }
                });
            }
        });

    });

});
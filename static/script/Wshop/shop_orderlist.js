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

        var currentOrderpage = 0;
        var orderLoading = false;
        var orderLoadingLock = false;
        var totalheight;

        // orderlist列表页面
        if ($('#uc-orderlist').length > 0) {
            // init list
            loadOrderList(currentOrderpage);
            // onscroll bottom
            $(window).scroll(function () {
                totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()) + 150;
                if ($(document).height() <= totalheight && !orderLoading) {
                    //加载数据
                    loadOrderList(++currentOrderpage);
                }
            });
        }

        $('.uc-order-sort').unbind('click').click(function () {
            currentOrderpage = -1;
            orderLoading = false;
            orderLoadingLock = false;
            $('#status').val($(this).attr('data-status'));
            $('.uc-order-sort.hover').removeClass('hover');
            $(this).addClass('hover');
            loadOrderList(currentOrderpage);
        });

        // Ajax load Order list 
        function loadOrderList(page) {
            if (!orderLoadingLock) {
                page = parseInt(page);
                if (page === -1) {
                    page = 0;
                    $("#uc-orderlist").html('');
                }
                // request uri
                orderLoading = true;
                $('#list-loading').show();
                // [HttpGet]
                $.get('?/Uc/ajaxOrderlist/page=' + page + '&status=' + $('#status').val(), function (HTML) {
                    orderLoading = false;
                    if (HTML === '' && page === 0) {
                        // 什么都没有
                        $("#uc-orderlist").append('<div class="emptyTip">暂无数据</div>');
                    } else if (HTML !== '') {
                        if (page === 0) {
                            $("#uc-orderlist").html(HTML);
                        } else {
                            $("#uc-orderlist").append(HTML);
                        }
                    } else {
                        orderLoadingLock = true;
                    }
                    $('#list-loading').hide();
                    fnWxpayListen();
                });
            }
        }

        var wxpayLoading = false;
        var wxpayButton = null;

        /**
         * 订单重新支付监听
         */
        function fnWxpayListen() {
            $('.wepay_button').unbind('click').bind('click', function () {
                wxpayButton = $(this);
                var orderId = parseInt($(this).data('id'));
                if (orderId > 0 && !wxpayLoading) {
                    wxpayButton.html('支付发起中');
                    wxpayLoading = true;
                    // [HttpPost]
                    $.ajax({
                        url: shoproot + '?/Order/ajaxGetBizPackage/',
                        dataType: 'json',
                        cache: false,
                        type: 'POST',
                        data: {
                            orderId: orderId
                        },
                        success: function (bizPackage) {
                            if (bizPackage.package !== 'prepay_id=') {
                                // 支付操作成功
                                bizPackage.success = wepayCallback;
                                // 支付操作取消
                                bizPackage.cancel = wepayCancel;
                                // 支付操作出错
                                bizPackage.fail = wepayError;
                                // 发起微信支付
                                wx.chooseWXPay(bizPackage);
                                // 按钮恢复
                                wxpayButton.html('立即支付');
                                // ajaxlock
                                wxpayLoading = false;
                            } else {
                                wepayError();
                            }
                        },
                        error: wepayError
                    });
                }
            });
        }

        /**
         * 微信支付手动取消
         */
        function wepayCancel() {
            // 按钮恢复
            wxpayButton.html('立即支付');
            // ajaxlock
            wxpayLoading = false;
        }

        /**
         * 微信支付失败
         * @todo 错误上报
         */
        function wepayError() {
            alert('微信支付发起失败');
            // 按钮恢复
            wxpayButton.html('立即支付');
            // ajaxlock
            wxpayLoading = false;
        }

        /**
         * 微信支付回调
         * @param {type} res
         * @returns {undefined}
         */
        function wepayCallback(res) {
            location.reload();
        }

    });

});
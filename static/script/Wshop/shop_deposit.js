$(function () {
    $('#next').click(function () {
        var amount = parseFloat($('#deposit_amount').val());
        if (amount > 0) {

            // 创建充值订单
            $.post('?/Uc/createDepositOrder/', {
                    amount: amount
                }, function (r) {
                    if (r.ret_code == 0) {

                        $.ajax({
                            url: '?/Order/ajaxGetBizPackage/',
                            dataType: 'json',
                            cache: false,
                            type: 'POST',
                            data: {
                                orderId: r.ret_msg
                            },
                            success: function (bizPackage) {
                                // 支付操作成功
                                bizPackage.success = wepayCallback;
                                // 支付操作取消
                                bizPackage.cancel = wepayCancel;
                                // 支付操作出错
                                bizPackage.fail = wepayError;
                                // 发起微信支付
                                wx.chooseWXPay(bizPackage);
                            }
                        });

                    } else {
                        alert('订单创建失败');
                    }
                }
            );

        } else {
            alert('请输入大于0的金额');
        }
    })

    /**
     * 微信支付手动取消
     */
    function wepayCancel() {

    }

    /**
     * 微信支付失败
     */
    function wepayError() {
        alert('微信支付发起失败');
    }

    /**
     * 微信支付回调
     * @param {type} res
     * @returns {undefined}
     */
    function wepayCallback(res) {
        alert('支付成功');
        location.href = '?/Uc/home/';
    }

});
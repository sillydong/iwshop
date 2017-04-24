/* global angular */

var app = angular.module('ngApp', ['Order.services', 'Util.services']);

app.controller('orderRefundController', function ($scope, Order, Util) {

    // 订单统计数据
    $scope.statdata;
    // 订单列表
    $scope.orderList;
    // 搜索类型
    $scope.search_type = 0;
    // 列表参数
    $scope.params = {
        page: 0,
        page_size: 30,
        status: 'canceled',
        serial_number: '',
        audit: 1
    };
    var loading = false;
    // 操作订单Id
    $scope.order_id = 0;
    // 操作按钮
    $scope.btn;
    // 分页总数
    $scope.listcount = 0;
    // 列表类型
    $scope.listtype = 0;
    // 初始化
    $scope.init = false;
    // 快递单号
    $scope.express_code = '';
    // 支付方式
    $scope.paymethod = [
        '微信支付',
        '支付宝',
        '货到付款'
    ]
    // 退款方式
    $scope.refund_type = 0;
	// 退款操作人
    $scope.dowhois = 'root2';
    // 退款方式
    $scope.refund_type_arr = ['原路返回', '人工处理'];
    // 退款时间
    $scope.refund_datas = [];
    // 退款金额
    $scope.refunding_amount = 0;

    // 拉取订单统计数据
    Order.getOrderStatnums().success(function (r) {
        $scope.statdata = r;
    });

    /**
     * 初始化分页
     * @returns {undefined}
     */
    function fnInitPager() {
        if ($scope.listcount > 0) {
            Util.initPaginator(Math.ceil($scope.listcount / $scope.params.page_size), fnOnPageChange);
        } else {
            $('.navbar-fixed-bottom').hide();
        }
    }

    $.datetimepicker.setLocale('zh');

    // 日期选择器
    $('#stime').datetimepicker({
        format: 'Y-m-d'
    });
    $('#etime').datetimepicker({
        format: 'Y-m-d'
    });

    /**
     * 导出按钮
     */
    $('#confirm-export').click(function () {
        var stime = $('#stime').val();
        var etime = $('#etime').val();
        var otype = $('#otype').val();
        if (stime !== '' && etime !== '') {
            $('#modal_export_orders').modal('hide');
            window.open('?/wOrder/order_exports/stime=' + stime + '&etime=' + etime + '&otype=' + otype);
        } else {
            Util.alert('请选择时间');
        }
    });

    /**
     * 分页变化
     * @param {type} page
     * @param {type} type
     * @returns {undefined}
     */
    function fnOnPageChange(page, type) {
        if ($scope.init) {
            $('body').animate({scrollTop: '0'}, 200);
            $scope.params.page = page - 1;
            fnGetList();
        }
    }

    /**
     * 获取订单列表
     */
    function fnGetList() {
        Util.loading();
        if ($scope.listtype == 0) {
            Order.getList($scope.params).success(function (r) {
                Util.loading(false);
                $scope.listcount = r.ret_msg.count;
                $scope.orderList = r.ret_msg.list;
                if (!$scope.init) {
                    fnInitPager();
                    $scope.init = true;
                }
            });
        } else {
            $.post('?/wOrder/get_refund_record/', $scope.params, function (r) {
                Util.loading(false);
                $scope.listcount = r.ret_msg.count;
                $scope.refundList = r.ret_msg.list;
                $scope.$apply();
                if (!$scope.init) {
                    fnInitPager();
                    $scope.init = true;
                }
            });
        }
    }

    // 输入框变化
    $scope.inputChange = function (e) {
        var input = $(e.currentTarget);
        var value = parseInt(input.val());
        if (value >= 0) {
            input.val(value);
        } else {
            input.val('');
        }
        if (value > input.data('count')) {
            Util.alert('请输入正确的数量', true);
            input.val('');
        }
        fnCountRefunds();
    };

    function fnCountRefunds() {
        $scope.refund_datas.length = 0;
        $scope.refunding_amount = 0;
        $('.refund-input').each(function () {
            var value = parseInt($(this).val());
            if (value <= $(this).data('count') && value > 0) {
                $scope.refunding_amount += (parseFloat($(this).data('price')) * value);
                $scope.refund_datas.push({
                    id: parseInt($(this).data('id')),
                    count: value,
                    phid: parseInt($(this).data('phid')),
                    pdid: parseInt($(this).data('pdid'))
                });
            }
        });
        $scope.refunding_amount = $scope.refunding_amount.toFixed(2);
    }

    // 退款操作
    $scope.orderRefund = function (e) {
        var btn = $(e.currentTarget);
        if ($scope.refunding_amount > $scope.refund_amount || $scope.refunding_amount == 0) {
            return Util.alert('退款金额错误，请核对可退款金额', true);
        }
        if (($scope.orderInfo.wepay_method == 1 && $scope.refund_type == 0) || confirm('确认要退款吗')) {
            btn.html('处理中');
            $.post('?/wOrder/refund/', {
                refund_type: $scope.refund_type,
                order_id: $scope.order_id,
                paymethod: $scope.orderInfo.wepay_method,
                refund_amount: $scope.refunding_amount,
                refund_datas: $scope.refund_datas
            }, function (r) {
                if ($scope.orderInfo.wepay_method == 1) {
                    btn.html('去支付宝');
                } else {
                    btn.html('确认退款');
                }
                if (r.ret_code === 0) {
                    if ($scope.orderInfo.wepay_method == 1 && $scope.refund_type == 0) {
                        // 支付宝
                        Util.alert('请在打开的窗口中处理');
                        $('#alipaysubmit').remove();
                        $('body').append(r.ret_msg);
                        $('#alipaysubmit').hide();
                    } else {
                        fnGetList();
                        $('#modal_order_view').modal('hide');
                        Util.alert('退款处理成功');
                    }
                } else {
                    Util.alert('操作失败:' + r.ret_msg, true);
                }
            });
        }
    };

    // 查看订单
    $('#modal_order_view').on('show.bs.modal', function (event) {
        $scope.btn = $(event.relatedTarget);
        $scope.order_id = parseInt($scope.btn.data('id'));
        $scope.express_code = '';
        Order.getInfo({
            id: $scope.order_id
        }).success(function (r) {
            $scope.orderInfo = r.ret_msg;
            // 可退款金额
            $scope.refund_amount = ($scope.orderInfo.order_amount - $scope.orderInfo.order_refund_amount).toFixed(2);
            if ($scope.refund_amount < 0) {
                $scope.refund_amount = 0;
            }
            // $scope.refunding_amount = $scope.refund_amount;
        });
    });

    // 查看物流
    $('#modal_order_viewexpress').on('show.bs.modal', function (event) {
        $scope.btn = $(event.relatedTarget);
        $scope.order_id = parseInt($scope.btn.data('id'));
        Order.getInfo({
            id: $scope.order_id
        }).success(function (r) {
            $scope.orderInfo = r.ret_msg;
        });
        $.post('?/wOrder/ajaxLoadOrderExpress/', {
            com: $scope.btn.data('com'),
            code: $scope.btn.data('code')
        }, function (r) {
            $('#modal_order_viewexpress').find('.modal-body').html(r);
        });
    });

    // 删除订单
    $('#modal_order_delete').on('show.bs.modal', function (event) {
        $scope.btn = $(event.relatedTarget);
        $scope.order_id = parseInt($scope.btn.data('order_id'));
    });

    // 删除订单确认
    $('#modal_order_delete .btn-danger').click(function () {
        var btn = $(this);
        btn.parents('tr').remove();
        if (!loading) {
            loading = true;
            btn.html('删除中');
            // 删除订单
            Order.deleteOrder({
                order_id: $scope.order_id
            }).success(function (r) {
                $('#modal_order_delete').modal('hide');
                loading = false;
                btn.html('删除');
                if (r.ret_code === 0) {
                    $scope.btn.parents('tr').remove();
                    Util.alert('删除成功');
                } else {
                    Util.alert('删除失败', true);
                }
            });
        }
    });

    $('#list-reload').click(fnGetList);

    // 订单状态选项
    $('#order-status a').click(function () {
        $scope.params.status = $(this).data('type');
        if ('record' === $scope.params.status) {
            $scope.listtype = 1;
        } else {
            $scope.listtype = 0;
        }
        $scope.$apply();
        $('#order-status-label').html($(this).html());
        $scope.params.page = 0;
        fnGetList();
    });

    // 搜索类型选项
    $('#search-type a').click(function () {
        $scope.search_type = +$(this).data('type');
        $('#search-type-label').html($(this).html());
    });

    // 搜索框回车
    $('#search-key').bind('keyup', function (e) {
        if (e.keyCode === 13) {
            $('#search-button').click();
        }
    });

    // 搜索按钮
    $('#search-button').click(function () {
        $scope.params.serial_number = '';
		
		$scope.params.phone = '';
		$scope.params.uname = '';
        switch ($scope.search_type) {
            case 0:
                $scope.params.serial_number = $('#search-key').val();
                break;
            case 1:
                $scope.params.phone = $('#search-key').val();
                break;
            case 2:
                $scope.params.uname = $('#search-key').val();
        }
        fnGetList();
    });

    $scope.orderConfirm = function () {
        if (confirm('你确认买家已经收到货了吗')) {
            Order.confirmOrder({
                orderId: $scope.order_id
            }).success(function (r) {
                if (r > 0) {
                    $('#modal_order_view').modal('hide');
                    $('#modal_order_viewexpress').modal('hide');
                    Util.alert('确认收货成功！');
                    // 刷新列表
                    fnGetList();
                } else {
                    Util.alert('确认收货失败！', true);
                }
            });
        }
    }

    // 确认收货
    $('#order-confirm-btn').click(function () {
        if (confirm('你确认买家已经收到货了吗')) {
            Order.confirmOrder({
                orderId: $scope.order_id
            }).success(function (r) {
                if (r > 0) {
                    $('#modal_order_view').modal('hide');
                    Util.alert('确认收货成功！');
                    // 刷新列表
                    fnGetList();
                } else {
                    Util.alert('确认收货失败！', true);
                }
            });
        }
    });

    // 订单发货
    $('#order-express-btn').click(function () {
        if (loading) {
            return false;
        }
        if ($scope.express_code === '') {
            return Util.alert('请输入正确的快递单号');
        }
        Order.expressSend({
            orderId: $scope.order_id,
            expressCode: $scope.express_code,
            expressCompany: $scope.express_company,
            expressStaff: $scope.express_staff
        }).success(function (r) {
            $('#modal_order_view').modal('hide');
            loading = false;
            if (r.ret_code === 0) {
                Util.alert('发货成功');
                // 刷新列表
                fnGetList();
            } else {
                Util.alert('发货失败', true);
            }
        });
    });

    // 获取快递公司列表
    Order.getExpressCompanys().success(function (r) {
        $scope.express_company = r.ret_msg[0].code;
        $scope.express_companys = r.ret_msg;
    });

    $scope.express_staff = '';

    // 获取快递人员列表
    Order.getExpressStaffs().success(function (r) {
        $scope.express_staffs = r.ret_msg;
    });

    fnGetList();
});
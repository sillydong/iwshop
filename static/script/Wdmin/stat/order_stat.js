/* global angular */

var app = angular.module('ngApp', ['Order.services', 'Util.services']);

app.controller('statController', function ($scope, Order, Util) {

    // 订单统计数据
    $scope.statdata;
    // 订单列表
    $scope.orderList;
    // 搜索类型
    $scope.search_type = 0;
    // 列表参数
    //加adid或者supplier_id
    $scope.params = {
        page: 0,
        page_size: 40,
        status: 'all',
        serial_number: '',
        stime:'',
        etime:'',
        product:'',
        uid:0
    };
    var loading = false;
    // 操作订单Id
    $scope.order_id = 0;
    // 操作按钮
    $scope.btn;
    // 分页总数
    $scope.listcount = 0;
    // 初始化
    $scope.init = false;
    // 快递单号
    $scope.express_code = '';

    // 拉取订单统计数据
    //Order.getOrderStatnums().success(function (r) {
    //    $scope.statdata = r;
    //});

    $scope.$watch('listcount', function (newValue, oldValue) {
        if (newValue > 0) {
            fnInitPager();
            $scope.init = true;
        }
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
    //$('#confirm-export').click(function () {
    //    var stime = $('#stime').val();
    //    var etime = $('#etime').val();
    //    var otype = $('#otype').val();
    //    if (stime !== '' && etime !== '') {
    //        $('#modal_export_orders').modal('hide');
    //        window.open('?/wOrder/order_exports/stime=' + stime + '&etime=' + etime + '&otype=' + otype);
    //    } else {
    //        Util.alert('请选择时间');
    //    }
    //});

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

    function fnGetList() {
        Util.loading();
        Order.getStatList($scope.params).success(function (r) {
            Util.loading(false);
            $scope.listcount = r.ret_msg.count;
            $scope.orderList = r.ret_msg.list;
            $('#com-orders-pd-count').html(r.ret_msg.count);
            $('#com-orders-pd-count1').html(r.ret_msg.count1);
            $('#com-income-count').html('&yen;' + r.ret_msg.amount);

        });
    }

    // 查看订单
    $('#modal_order_view').on('show.bs.modal', function (event) {
        $scope.btn = $(event.relatedTarget);
        $scope.order_id = parseInt($scope.btn.data('id'));
        $scope.express_code = '';
        Order.getInfo({
            id: $scope.order_id
        }).success(function (r) {
            $scope.orderInfo = r.ret_msg;
        });
    });


    $('#list-reload').click(fnGetList);

    // 订单状态选项
    $('#order-status a').click(function () {
        $scope.params.status = $(this).data('type');
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

        $scope.params.uid = $('#uid').val();
        $scope.params.stime = $('#stime').val();
        $scope.params.etime = $('#etime').val();
        $scope.params.product = $('#product').val();

        fnGetList();
    });


    fnGetList();

});
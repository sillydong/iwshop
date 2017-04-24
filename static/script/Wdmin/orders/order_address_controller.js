/* global angular */

var app = angular.module('ngApp', ['Order.services', 'Util.services']);

app.controller('orderAddressController', function ($scope, Order, Util) {

    // 订单列表
    $scope.orderList;
    // 搜索类型
    $scope.search_type = 0;
    // 列表参数
    $scope.params = {
        page: 0,
        page_size: 30,
        serial_number: ''
    };
    // 操作订单Id
    $scope.order_id = 0;
    // 操作按钮
    $scope.btn;
    // 分页总数
    $scope.listcount = 0;
    // 初始化
    $scope.init = false;
    // 搜索标签
    $scope.listsort = '全部';
    // 是否配送记录列表,modal判断用
    $scope.isExprecord = true;

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
        Order.getOrderAddresses($scope.params).success(function (r) {
            Util.loading(false);
            $scope.orderList = r;
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

    /**
     * 配送人员筛选
     */
    $scope.sortOpenid = function (e) {
        var openid = $(e.target).data('openid');
        $scope.listsort = $(e.target).html();
        $scope.params.openid = openid;
        $scope.init = false;
        fnGetList();
    };

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

    fnGetList();
});
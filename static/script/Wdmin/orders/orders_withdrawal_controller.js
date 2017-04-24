/* global angular */

var app = angular.module('ngApp', ['Order.services', 'Util.services']);

app.filter('cvWithStatus', ['$sce', function ($sce) {
    "use strict";
    return function (type) {
        switch (type) {
            case 'wait':
                return '等待';
            case 'pass':
                return '通过';
            case 'reject':
                return '拒绝';
        }
    };
}]);

app.controller('orderWithdrawalController', function ($scope, Order, Util, $http) {

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
        status: 'all',
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
    // 初始化
    $scope.init = false;

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
        $.post('?/wWithdrawal/getList', $scope.params, function (r) {
            Util.loading(false);
            $scope.listcount = r.count;
            $scope.list = r.list;
            $scope.$apply();
            if (!$scope.init) {
                fnInitPager();
                $scope.init = true;
            }
        });
    }

    /**
     * 审核操作
     * @param type
     */
    $scope.withdrawalCheck = function (type) {
        // [httpPost]
        Util.loading();
        $.post('?/wWithdrawal/audit/', {
            id: $scope.wid,
            type: type
        }, function (r) {
            Util.loading(false);
            if (r.ret_code == 0) {
                // 审核操作成功，刷新列表
                fnGetList();
                Util.alert('操作成功！');
                $('#modal_withdrawal_audit').modal('hide');
            } else {
                Util.alert('操作失败！', true);
            }
        });
    }

    // 查看信息
    $('#modal_withdrawal_audit').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        $scope.wid = parseInt(btn.data('id'));
        for (var i in $scope.list) {
            if ($scope.list[i].id == $scope.wid) {
                $scope.withs = $scope.list[i];
                console.log($scope.withs);
                break;
            }
        }
        $scope.$apply();
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

    fnGetList();
});
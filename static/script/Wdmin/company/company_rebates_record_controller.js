/* global angular */

var app = angular.module('ngApp', ['Order.services', 'mRebate.services', 'Util.services']);

app.filter('cvRebateType', ['$sce', function ($sce) {
    "use strict";
    return function (type) {
        switch (type) {
            case 'amount':
                return '固定金额';
            case 'percent':
                return '订单比例';
        }
    };
}]);

app.filter('cvStatusType', ['$sce', function ($sce) {
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

app.controller('companyRebateRecordController', function ($scope, Order, mRebate, Util) {

    // 订单统计数据
    $scope.statdata;
    // 订单列表
    $scope.orderList = [];
    // 搜索类型
    $scope.search_type = 0;
    // 列表参数
    $scope.params = {
        page: 0,
        page_size: 30
    };
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
    // loading
    $scope.loading = false;

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
        mRebate.getList($scope.params).success(function (r) {
            Util.loading(false);
            $scope.listcount = r.ret_msg.count;
            $scope.orderList = r.ret_msg.list;
        });
    }

    $scope.fnGetList = fnGetList;

    // 查看信息
    $('#modal_company_rebate_audit').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        $scope.rebate_id = parseInt(btn.data('id'));
        for (var i in $scope.orderList) {
            if ($scope.orderList[i].id == $scope.rebate_id) {
                $scope.rebate = $scope.orderList[i];
                break;
            }
        }
        $scope.$apply();
    });

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
        fnGetList();
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

    // 返佣审核操作
    $scope.rebateCheck = function (type) {
        Util.loading();
        $scope.loading = true;
        mRebate.rebateCheck({
            type: type,
            id: $scope.rebate_id
        }).success(function (ret) {
            Util.loading(false);
            $scope.loading = false;
            if (ret.ret_code == 0) {
                fnGetList();
                $('#modal_company_rebate_audit').modal('hide');
                Util.alert('操作成功');
            } else {
                Util.alert('操作失败'.ret.ret_msg);
            }
        });
    }

    fnGetList();
});
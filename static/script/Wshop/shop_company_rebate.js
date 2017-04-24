/* global angular */

var app = angular.module('ngApp', []);

app.controller('companyRebatesController', function ($scope, $http) {

    $scope.mode = 0;

    $scope.wait_amount = 0;

    // 获取未结算佣金数据
    $http.get('?/Company/getRebateList/', {
        params: {
            status: 'wait'
        }
    }).success(function (res) {
        $scope.rebate_list = res.list;
        $scope.wait_amount = res.total;
    });

    // 获取已结算佣金数据
    $http.get('?/Company/getRebateList/', {
        params: {
            status: 'pass'
        }
    }).success(function (res) {
        $scope.rebated_list = res.list;
        $scope.pass_amount = res.total;
    });

});
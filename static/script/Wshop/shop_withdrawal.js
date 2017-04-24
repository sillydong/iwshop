/* global angular */

var app = angular.module('ngApp', []);

app.controller('withdrawalController', function ($scope, $http) {

    $scope.f = {};

    $scope.submit = function () {
        $http.post('?/Uc/submitWithdrawal', $.param($scope.f), {
            headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
        }).success(function (ret) {
            if (ret.ret_code == 0) {
                alert('提交成功');
                location.href = '?/Uc/home/';
            } else {
                alert(ret.ret_msg);
            }
        });
    }

});

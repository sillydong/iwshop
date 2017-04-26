/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services']);

app.controller('userCreditRecordController', function ($scope, User, Util) {
    $scope.params = {
        page: 0,
        pagesize: 30,
    };
    $scope.init = false;

    function fnGetList() {
        User.getUserCreditRecord($scope.params).success(function (r) {
            $scope.creditRecords = r.ret_msg.list;
            $scope.listcount = r.ret_msg.total;
            if (!$scope.init) {
                fnInitPager();
                $scope.init = true;
            }
        });
    }

    function fnInitPager() {
        if ($scope.listcount > 0) {
            Util.initPaginator(Math.ceil($scope.listcount / $scope.params.pagesize), function (page) {
                $('body').animate({scrollTop: '0'}, 200);
                $scope.params.page = page - 1;
                fnGetList();
            });
        } else {
            $('.navbar-fixed-bottom').hide();
        }
    }

    fnGetList();
});

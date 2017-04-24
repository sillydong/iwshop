/* global angular */

var app = angular.module('ngApp', []);

app.controller('companyHomeController', function ($scope, $http) {

    $http.get('?/Company/getCustomerList/').success(function (res) {
        $scope.userlist = res;
    });

});
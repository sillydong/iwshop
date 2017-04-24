/* global angular */

var app = angular.module('ngApp', []);

app.controller('companyAgentsController', function ($scope, $http) {

    $http.get('?/Company/getCompanyList/').success(function (res) {
        $scope.userlist = res;
    });

});
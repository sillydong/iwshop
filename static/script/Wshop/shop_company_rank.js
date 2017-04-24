/* global angular */

var app = angular.module('ngApp', []);

app.controller('companyRankController', function ($scope, $http) {

    $http.get('?/Company/getRankList/').success(function (res) {
        $scope.ranklist = res;
    });

});

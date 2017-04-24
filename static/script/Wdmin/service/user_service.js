'use strict';

/* global angular */

var services = angular.module('User.services', []);

services.factory('User', ['$http', function ($http) {
    return {
        /**
         * 获取分组列表
         * @param {type} p
         * @returns {undefined}
         */
        getUserLevel: function () {
            return $http.get('?/wUser/getUserLevel/', {}).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取分组详情
         * @param {type} id
         * @returns {unresolved}
         */
        getLevelInfo: function (id) {
            return $http.get('?/wUser/getUserLevelInfo/', {
                params: {id: id}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 删除分组
         * @param {type} p
         * @returns {unresolved}
         */
        deleteLevel: function (p) {
            return $http.post('?/wUser/deleteLevel/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 编辑分组
         * @param {type} p
         * @returns {unresolved}
         */
        alterUserLevelInfo: function (p) {
            return $http.post('?/wUser/alterUserLevelInfo/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取用户列表
         * @param p
         * @returns {*}
         */
        getList: function (p) {
            return $http.get('?/wUser/getUserList/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 删除用户
         * @param p
         * @returns {*}
         */
        deleteUser: function (p) {
            return $http.post('?/wUser/deleteUser/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取用户信息
         * @param p
         * @returns {*}
         */
        getUserInfo: function (p) {
            return $http.get('?/wUser/getUserInfo/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 编辑用户信息
         * @param p
         * @returns {*}
         */
        alterUser: function (p) {
            return $http.post('?/wUser/alterUser/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        }
    };
}]);
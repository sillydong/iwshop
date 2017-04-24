'use strict';

/* global angular */

var services = angular.module('mRebate.services', []);

services.factory('mRebate', ['$http', function ($http) {

    return {
        /**
         * 获取规则列表
         * @param p
         * @returns {*}
         */
        getList: function (p) {
            return $http.get('?/wRebate/getRebateList/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 编辑返佣规则
         * @param p
         * @returns {*}
         */
        alterRuleInfo: function (p) {
            return $http.post('?/wRebate/alterRuleInfo/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 删除返佣规则
         * @param p
         * @returns {*}
         */
        deleteRule: function (p) {
            return $http.post('?/wRebate/deleteRule/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 返佣审核操作
         * @param p
         * @returns {*}
         */
        rebateCheck: function (p) {
            return $http.post('?/wRebate/rebateCheck/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        }
    }

}]);
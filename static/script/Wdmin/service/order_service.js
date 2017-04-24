'use strict';

/* global angular */

var services = angular.module('Order.services', []);

services.factory('Order', ['$http', function ($http) {
    return {
        /**
         * 获取商品信息
         * @param {object} p
         * @returns {undefined}
         */
        getInfo: function (p) {
            return $http.get('?/wOrder/getOrderInfo/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取商品列表
         * @param {object} p
         * @returns {unresolved}
         */
        getList: function (p) {
            return $http.get('?/wOrder/getOrderList/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取销售统计列表
         * @param {object} p
         * @returns {unresolved}
         */
        getStatList: function (p) {
            return $http.get('?/wOrder/getStatList/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取订单统计
         * @returns {unresolved}
         */
        getOrderStatnums: function (p) {
            return $http.get('?/wOrder/ajaxGetOrderStatnums/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 删除订单
         * @param {object} p
         * @returns {unresolved}
         */
        deleteOrder: function (p) {
            return $http.post('?/wOrder/deleteOrder/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 快递发货
         * @param {object} p
         * @returns {unresolved}
         */
        expressSend: function (p) {
            return $http.post('?/wOrder/expressSend/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取快递公司列表
         * @param {object} p
         * @returns {unresolved}
         */
        getExpressCompanys: function (p) {
            return $http.get('?/wOrder/getExpressCompanys/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取快递人员列表
         * @param {object} p
         * @returns {unresolved}
         */
        getExpressStaffs: function (p) {
            return $http.get('?/wOrder/getExpressStaff/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取历史快递人员列表
         * @param {object} p
         * @returns {unresolved}
         */
        getExpressStaffHistory: function (p) {
            return $http.get('?/wOrder/getExpressStaffHistroy/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 手动确认收货
         * @param {object} p
         * @returns {unresolved}
         */
        confirmOrder: function (p) {
            return $http.post('?/Order/confirmExpress/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 手动确认收货
         * @param {object} p
         * @returns {unresolved}
         */
        payOrder: function (p) {
            return $http.post('?/wOrder/orderPayed/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取配送记录
         * @param {object} p
         * @returns {unresolved}
         */
        getExpressRecord: function (p) {
            return $http.get('?/wOrder/getExpressRecords/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 获取订单历史配送地址
         * @param p
         * @returns {*}
         */
        getOrderAddresses: function (p) {
            return $http.get('?/wOrder/getOrderAddresses/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        }
    };
}]);
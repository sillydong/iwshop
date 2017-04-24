var services = angular.module('Gmess.services', []);

services.factory('Gmess', ['$http', function ($http) {
    'use strict';
    return {
        /**
         * @param p
         * @returns {*}
         */
        deleteGmess: function (p) {
            return $http.post('?/wGmess/ajaxDelByMsgId/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * @param p
         * @returns {*}
         */
        getList: function (p) {
            return $http.get('?/wGmess/getGmessList/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * @returns {*}
         */
        getCloudCateGory: function () {
            return $http.get('?/wGmess/getCloudCategorys/', {
                params: {}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * apistore搜索素材
         * @param p
         * @returns {*}
         */
        getCloudList: function (p) {
            return $http.post('?/wGmess/getCloudList/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * @param p
         * @returns {*}
         */
        cloneGmess: function(p){
            return $http.post('?/wGmess/cloneGmess/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 发送群发
         * @param p
         * @returns {*}
         */
        sendGmess: function(p){
            return $http.post('?/wGmess/sendGemss/', $.param(p), {
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        }
    }
}]);
'use strict';

/* global angular */

var services = angular.module('FeedBack.services', []);

services.factory('FeedBack', ['$http', function ($http) {
    return {
        /**
         * 获取用户反馈列表
         * @param p
         * @returns {*}
         */
        getFeedBacks: function(p){
            return $http.get('?/wFeedBack/getList/', {
                params: p
            }).error(function (ret) {
                _process_error(ret);
            });
        },
        /**
         * 删除用户反馈
         * @param id
         */
        deleteFeedback: function(id){
            return $http.post('?/wFeedBack/deleteFeedBack/', $.param({
                id: id
            }), {headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
            }).error(function (ret) {
                _process_error(ret);
            });
        }
    };
}]);
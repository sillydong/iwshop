/* global angular */

var app = angular.module('ngApp', ['FeedBack.services', 'Util.services']);

app.controller('userFeedbackController', function ($scope, FeedBack, Util) {

    $scope.params = {
        page: 0,
        pagesize: 30
    };
    $scope.init = false;

    $scope.deleteFeedback = function(e){
        var node = e.currentTarget;
        if(confirm('你确定要删除这个反馈吗?')){
            FeedBack.deleteFeedback($(node).data('id')).success(function(r){
                if (r.ret_code === 0) {
                    Util.alert('删除成功');
                    $(node).parents('tr').remove();
                } else {
                    Util.alert('加载信息失败', true);
                }
            });
        }
    };

    function fnGetList() {
        FeedBack.getFeedBacks($scope.params).success(function (r) {
            $scope.feedBacks = r.ret_msg.list;
            $scope.listcount = r.ret_msg.total;
            if(!$scope.init){
                fnInitPager();
                $scope.init = true;
            }
        });
    }

    /**
     * 初始化分页
     * @returns {undefined}
     */
    function fnInitPager() {
        if ($scope.listcount > 0) {
            Util.initPaginator(Math.ceil($scope.listcount / $scope.params.pagesize), function(page){
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
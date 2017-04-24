/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services', 'Company.services']);

app.controller('companyLevelController', function ($scope, User, Util, Company) {

    function fnGetList() {
        Company.getCompanyLevelAll().success(function (r) {
            $scope.levelList = r.list;
        });
    }

    fnGetList();

    // 模态框点击
    $('#modal_user_level_alter').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        var id = parseInt(btn.data('id'));
        var isEdit = btn.data('isedit');
        if (id >= 0 && isEdit > 0) {
            Company.getCompanyLevelInfo({
                id: id
            }).success(function (r) {
                if (r.ret_code === 0) {
                    $scope.level = r.ret_msg;
                } else {
                    Util.alert('加载信息失败', true);
                }
            });
        } else {
            $scope.level = {
                id: -1
            };
            $scope.$apply();
        }
    });

    $('#modal_user_level_delete').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        $scope.id = parseInt(btn.data('id'));
        $scope.deleteRow = btn.parents('tr');
    });

    $('#modal_user_level_delete .btn-danger').click(function () {
        Company.deleteLevel({
            id: $scope.id
        }).success(function (r) {
            if (r.ret_code === 0) {
                $('#modal_user_level_delete').modal('hide');
                Util.alert('删除成功');
                $scope.deleteRow.remove();
            } else {
                Util.alert('加载信息失败', true);
            }
        });
    });

    $('#save_level').click(function () {
        var btn = $(this);
        btn.html('处理中');
        Company.alterLevelInfo($scope.level).success(function (r) {
            if (r.ret_code === 0) {
                $('#modal_user_level_alter').modal('hide');
                fnGetList();
                Util.alert('保存成功');
            } else {
                Util.alert('操作失败', true);
            }
        });
        btn.html('保存');
    });

});
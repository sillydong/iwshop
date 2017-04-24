/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services', 'Company.services', 'mRebate.services']);

app.filter('cvRebateType', ['$sce', function ($sce) {
    // 店铺类型
    "use strict";
    return function (type) {
        switch (type) {
            case 'amount':
                return '固定金额';
            case 'percent':
                return '订单比例';
        }
    };
}]);

app.controller('companyRebateController', function ($scope, User, Util, Company, mRebate) {

    $scope.rule = {};

    function fnGetList() {
        Company.getRebateRules().success(function (r) {
            $scope.rebate_rules = r;
        });
    }

    Company.getCompanyLevelAll().success(function (r) {
        $scope.levelList = r.list;
    });

    fnGetList();

    // 模态框点击
    $('#modal_company_rule_alter').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        var id = parseInt(btn.data('id'));
        if (id >= 0) {
            for (var i in $scope.rebate_rules) {
                if ($scope.rebate_rules[i].id == id) {
                    $scope.rule = $scope.rebate_rules[i];
                    $scope.rule.rebate_level = parseInt($scope.rule.rebate_level);
                    break;
                }
            }
            $scope.$apply();
        } else {
            $scope.rule = {
                id: 0
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
        mRebate.deleteRule({
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

    $('#save_rebate_rule').click(function () {
        var btn = $(this);
        btn.html('处理中');
        // 获取组名
        for (var i in $scope.levelList) {
            if ($scope.rule.level_id == $scope.levelList[i].id) {
                $scope.rule.level_name = $scope.levelList[i].level_name;
            }
        }
        mRebate.alterRuleInfo($scope.rule).success(function (r) {
            if (r.ret_code === 0) {
                $('#modal_company_rule_alter').modal('hide');
                fnGetList();
                Util.alert('保存成功');
            } else {
                Util.alert('操作失败', true);
            }
        });
        btn.html('保存');
    });

});
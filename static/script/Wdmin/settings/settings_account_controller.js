/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services']);

app.controller('accountController', function ($scope, User, Util) {

    $scope.init = false;

    $scope.content = '';

    $scope.title = '';

    $scope.params = {
        page: 0
    };

    $scope.account = {};

    $('#modal_modify_account').on('show.bs.modal', function (e) {
        var btn = $(e.relatedTarget);
        $scope.id = btn.data('id');
        if ($scope.id > 0) {
            $.post('?/wSettings/getAccount/', {
                id: $scope.id
            }, function (r) {
                $scope.account = r.ret_msg;
                $scope.$apply();
                fnCheckAuthItem();
            });
        } else {
            $scope.account = {
                id: 0,
                admin_auth: ''
            };
            $scope.$apply();
            fnCheckAuthItem();
        }
    });

    function fnCheckAuthItem() {
        $('.expitem').each(function () {
            if ($scope.account.admin_auth.indexOf($(this).data('auth')) > -1) {
                $(this).addClass('hov');
            } else {
                $(this).removeClass('hov');
            }
        });
    }

    $scope.saveAccount = function () {
        if ($scope.account.admin_name === '' || $scope.account.admin_name === undefined) {
            return Util.alert('请输入正确的用户名!', true);
        }
        if ($scope.account.admin_account === '' || $scope.account.admin_account === undefined) {
            return Util.alert('请输入正确的用户账号!', true);
        }
        var auth = [];
        $('.expitem.hov').each(function (i, node) {
            auth.push($(node).attr('data-auth'));
        });
        // [HttpPost]
        $.post('?/wSettings/addAuth/', {
            id: $scope.account.id,
            name: $scope.account.admin_name,
            acc: $scope.account.admin_account,
            pwd: $scope.account.admin_password_new,
            auth: auth.join(',')
        }, function (r) {
            if (r.ret_code === 0) {
                fnGetList();
                $('#modal_modify_account').modal('hide');
                Util.alert('操作成功');
            } else {
                Util.alert('操作失败!', true);
            }
        });
    }

    $scope.deleteAccount = function (e) {
        var node = $(e.currentTarget);
        if (confirm('你确定要删除吗')) {
            $.post('?/wSettings/deleteAuth/', {
                id: node.data('id')
            }, function (r) {
                if (r.ret_code === 0) {
                    fnGetList();
                    Util.alert('删除成功');
                } else {
                    Util.alert('删除失败', true);
                }
            });
        }
    }

    $('.expitem').click(function () {
        $(this).toggleClass('hov');
    });

    function fnGetList() {
        Util.loading();
        $.post('?/wSettings/getAccounts/', $scope.params, function (r) {
            Util.loading(false);
            $scope.levelList = r.ret_msg;
            $scope.$apply();
        });
    }

    fnGetList();

});
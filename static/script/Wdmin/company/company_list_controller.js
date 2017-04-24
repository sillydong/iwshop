/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services', 'Company.services']);

app.controller('accountController', function ($scope, User, Util, Company) {

    $scope.init = false;

    $scope.content = '';

    $scope.title = '';

    $scope.params = {
        page: 0,
        pagesize: 20,
        verifed: 1
    };

    $scope.account = {};

    $scope.company = null;

    /**
     * 未审核代理数量
     * @type {number}
     */
    $scope.unverifed = 0;

    /**
     * 已审核代理数量
     * @type {number}
     */
    $scope.verifed = 0;

    Company.getCompanyLevelAll().success(function (r) {
        $scope.levelList = r.list;
    });

    var uep = UM.getEditor('ueditorp', {
        autoHeight: false,
        initialFrameHeight: Math.ceil($(window).height() * 0.5),
        autoHeightEnabled: false
    });

    $scope.editor_title = '编辑代理协议';

    $('#modal_modify_text').on('show.bs.modal', function (e) {
        $.ajax({
            url: '/html/agent_agreement.html?v=' + Math.random(),
            cache: false,
            success: function (r) {
                uep.setContent(r);
            },
            error: function () {
                uep.setContent('');
            }
        });
    });

    $scope.saveText = function () {
        $.post('?/wCompany/setCompanyAgreement/', {
            content: uep.getContent()
        }, function (r) {
            if (r.ret_code == 0) {
                Util.alert('保存成功');
            } else {
                Util.alert('保存失败, /html目录是否不可写?', true);
            }
        });
    };

    $('#modal_modify_company').on('show.bs.modal', function (e) {
        var btn = $(e.relatedTarget);
        $scope.id = btn.data('id');
        if ($scope.id > 0) {
            Company.getInfo({
                id: $scope.id
            }).success(function (r) {
                $scope.company = r.ret_msg;
                if ($scope.params.verifed == 0) {
                    // 如果是审核列表中拉取信息
                    $scope.company.verifed = 1;
                }
            });
        } else {
            $scope.company = {
                id: 0,
                utype: 0,
                verifed: 1
            };
            $scope.$apply();
        }
    });

    /**
     * 删除代理账号
     * @param e
     */
    $scope.deleteAccount = function (e) {
        var node = $(e.currentTarget);
        if (confirm('你确定要删除吗')) {
            $.post('?/wCompany/deleteCompany/', {
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
    };

    /**
     * 编辑代理信息
     */
    $scope.saveCompany = function () {
        if ($scope.company) {
            Company.modify($scope.company).success(function (r) {
                if (r.ret_code === 0) {
                    fnGetList();
                    $('#modal_modify_company').modal('hide');
                    if ($scope.company.id == 0) {
                        Util.alert('添加成功');
                    } else {
                        if ($scope.params.verifed == 0) {
                            Util.alert('已审核');
                        } else {
                            Util.alert('保存成功');
                        }
                    }
                } else {
                    Util.alert('保存失败', true);
                }
            });
        }
    };

    function fnGetList() {
        Util.loading();
        Company.getList($scope.params).success(function (r) {
            Util.loading(false);
            $scope.com_list = r.list;
            if (!$scope.init) {
                Util.initPaginator(Math.ceil(r.total / $scope.params.pagesize), function (page) {
                    if ($scope.init) {
                        $(window).scrollTop(0);
                        $scope.params.page = page - 1;
                        fnGetList();
                    }
                });
                $scope.init = true;
            }
        });
    }

    /**
     * 同意申请
     * @param e
     */
    $scope.confirmReq = function (e) {
        var node = $(e.currentTarget);
        if (confirm('确定通过审核？')) {
            var id = node.data('id');
            if (id > 0) {
                $.get('?/Company/companyReqPass/id=' + id, function (r) {
                    if (r > 0) {
                        util.Alert('操作成功');
                        dt.row(node.parents('tr')).remove().draw();
                    } else {
                        util.Alert('操作失败');
                    }
                });
            }
        }
    };

    /**
     * 拒绝申请
     * @param e
     */
    $scope.denyReq = function (e) {
        var node = $(e.currentTarget);
        if (confirm('确定拒绝该申请？')) {
            var id = node.data('id');
            if (id > 0) {
                Company.companyReqDeny({
                    id: id
                }).success(function (r) {
                    if (r.ret_code == 0) {
                        fnGetList();
                        Util.alert('操作成功');
                    } else {
                        Util.alert('操作失败');
                    }
                });
            } else {
                Util.alert('操作失败');
            }
        }
    };

    /**
     * 切换列表类型
     * @param verifed
     */
    $scope.switchList = function (verifed) {
        $scope.params.page = 0;
        $scope.params.verifed = verifed;
        $scope.init = false;
        fnGetList();
    };

    Company.getUnVerifedCount().success(function (r) {
        $scope.unverifed = r.ret_msg;
    });

    Company.getVerifedCount().success(function (r) {
        $scope.verifed = r.ret_msg;
    });

    fnGetList();


});
/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services']);

app.controller('userListController', function ($scope, User, Util) {

    $scope.params = {
        page: 0,
        pagesize: 30,
        gid: $('#groudId').val()
    };

    $scope.init = false;

    $scope.sexs = [
        {id: 'm', name: '男'},
        {id: 'f', name: '女'}
    ];

    $scope.sexStr = {
        m: '男',
        f: '女'
    };

    $scope.user = {
        client_nickname: '',
        client_sex: 'm',
        client_id: 0
    };

    // 导出参数
    $scope.export = {
        start: '',
        end: ''
    };

    $.datetimepicker.setLocale('zh');

    // 日期选择器
    $('#stime').datetimepicker({
        format: 'Y-m-d'
    });
    $('#etime').datetimepicker({
        format: 'Y-m-d'
    });

    $scope.search_type = 0;

    $scope.exportUsers = function () {
        if ($scope.export.start != '' && $scope.export.end != '') {
            $('#modal_export_orders').modal('hide');
            window.open('?/wUser/user_exports/stime=' + $scope.export.start + '&etime=' + $scope.export.end + '&otype=' + $scope.export.group);
        } else {
            Util.alert('请选择时间');
        }
    }

    $scope.modifyUser = function (e) {
        var btn = $(e.currentTarget);
        if ($scope.user.client_name !== '') {
            btn.html('处理中');
            User.alterUser($scope.user).success(function (r) {
                if (r.ret_code === 0) {
                    $('#modal_modify_user').modal('hide');
                    fnGetList();
                    if ($scope.clientId > 0) {
                        Util.alert('保存成功');
                    } else {
                        Util.alert('添加成功');
                    }
                } else {
                    Util.alert('操作失败', true);
                }
            });
            btn.html('保存');
        } else {
            Util.alert('请填写正确的信息', true);
        }
    };

    $('#modal_modify_user').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        $scope.clientId = parseInt(btn.data('id'));
        if ($scope.clientId > 0) {
            User.getUserInfo({
                id: $scope.clientId
            }).success(function (r) {
                $scope.user = r.ret_msg;
            });
        } else {
            $scope.user = null;
            $scope.user = {
                client_nickname: '',
                client_sex: 'm',
                client_id: 0
            }
            $scope.$apply();
        }
    });

    $scope.deleteUser = function (e) {
        var node = e.currentTarget;
        if (confirm('你确定要删除这个用户吗?')) {
            User.deleteUser({
                id: $(node).data('id')
            }).success(function (r) {
                if (r.ret_code === 0) {
                    Util.alert('删除成功');
                    $(node).parents('tr').remove();
                } else {
                    Util.alert('加载信息失败', true);
                }
            });
        }
    };

    User.getUserLevel().success(function (r) {
        $scope.userLevel = r.ret_msg;
        $scope.userLevelStr = [];
        for (var i in r.ret_msg) {
            $scope.userLevelStr[+r.ret_msg[i].id] = r.ret_msg[i].level_name;
        }
        $scope.userLevelStr[0] = '默认分组';
    });

    // 搜索类型选项
    $('#search-type a').click(function () {
        $scope.search_type = +$(this).data('type');
        $('#search-type-label').html($(this).html());
    });

    // 搜索框回车
    $('#search-key').bind('keyup', function (e) {
        if (e.keyCode === 13) {
            $('#search-button').click();
        }
    });

    // 搜索按钮
    $('#search-button').click(function () {
        $scope.init = false;
        $scope.params.phone = '';
        $scope.params.uname = '';
		$scope.params.cardno = '';
        switch ($scope.search_type) {
            case 0:
                $scope.params.phone = $('#search-key').val();
                break;
            case 1:
                $scope.params.uname = $('#search-key').val();
                break;
			case 2:
                $scope.params.cardno = $('#search-key').val();
                break;
        }
        fnGetList();
    });

    function fnGetList() {
        Util.loading();
        User.getList($scope.params).success(function (r) {
            Util.loading(false);
            var json = r.list;
            // 处理数据
            for (var i in json) {
                if (json[i].client_name === null) {
                    json[i].client_name = '未知';
                }
                if (json[i].client_province === null) {
                    json[i].client_province = '未知'
                    json[i].client_city = ''
                }
                if (json[i].levelname === null) {
                    json[i].levelname = '未知';
                }
                if (json[i].client_phone == '') {
                    json[i].client_phone = '未录入';
                }
                if (json[i].client_head === '' || json[i].client_head === null) {
                    json[i].client_head = 'static/images/login/profle_1.png';
                }
                if (/http:\/\/wx\.qlogo\.cn\//.test(json[i].client_head)) {
                    json[i].client_head += '/64';
                }
                json[i].client_level = parseInt(json[i].client_level);
            }
            $scope.userlist = json;
            $scope.listcount = r.total;
            if (!$scope.init) {
                $scope.init = true;
                fnInitPager();
            }
        });
    }

    /**
     * 初始化分页
     * @returns {x}
     */
    function fnInitPager() {
        var page = 1;
        if ($scope.listcount > 0) {
            page = Math.ceil($scope.listcount / $scope.params.pagesize);
        }
        Util.initPaginator(page, function (page) {
            $('body').animate({scrollTop: '0'}, 200);
            $scope.params.page = page - 1;
            fnGetList();
        });
    }

    fnGetList();

});
/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services', 'Gmess.services']);

app.controller('gmessListController', function ($scope, User, Util, Gmess) {

    $scope.params = {
        page: 0,
        pagesize: 20
    };

    /**
     * 列表模式
     * @type {number}
     */
    $scope.listmode = 0;

    /**
     * 列表数量
     * @type {number}
     */
    $scope.listcount = 0;

    /**
     * 是否已经加载列表
     * @type {boolean}
     */
    $scope.init = false;

    /**
     * 分类列表
     * @type {Array}
     */
    $scope.gmessCategory = [];

    /**
     * 分类编号
     * @type {number}
     */
    $scope.gmessCategoryId = 0;

    /**
     * 下载中
     * @type {boolean}
     */
    $scope.downloading = false;

    /**
     * 云素材列表
     * @type {Array}
     */
    $scope.gmessCloudList = [];

    /**
     * 本地素材列表
     * @type {Array}
     */
    $scope.gmessList = [];

    /**
     * 当前选中素材id
     * @type {{id: boolean}}
     */
    $scope.gmess = {
        id: false
    };

    Gmess.getCloudCateGory().success(function (r) {
        $scope.gmessCategory = r;
    });

    $scope.$watch('listmode', function () {
        if ($scope.init) {
            $scope.init = false;
            $scope.params.page = 0;
            fnGetList();
        }
    });

    $scope.$watch('gmessCategoryId', function () {
        if ($scope.init) {
            $scope.init = false;
            $scope.params.page = 0;
            fnGetCloudList();
        }
    });

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
            if ($scope.init) {
                fnGetList();
            }
        });
    }

    /**
     * 删除素材
     * @param gmessId
     */
    $scope.deleteGmess = function (gmessId) {
        if (confirm('要删除这个素材吗？和这个素材相关的文章将失效')) {
            Util.loading();
            Gmess.deleteGmess({
                msgid: parseInt(gmessId)
            }).success(function (r) {
                Util.loading(false);
                if (r.status > 0) {
                    fnGetLocalList();
                    Util.Alert('删除成功！');
                } else {
                    Util.Alert('删除失败！', true);
                }
            });
        }
    }

    // 搜索框回车
    $('#search-key').bind('keyup', function (e) {
        if (e.keyCode === 13) {
            $('#search-button').click();
        }
    });

    // 搜索按钮
    $('#search-button').click(function () {
        if ($('#search-key').val() != '') {
            $scope.init = false;
            $scope.params.key = $('#search-key').val();
            $scope.params.page = 0;
            fnGetList();
        }
    });

    function fnGetList() {
        if ($scope.listmode == 0) {
            fnGetLocalList();
        } else {
            fnGetCloudList();
        }
    }

    /**
     * 本地素材列表
     */
    function fnGetLocalList() {
        Util.loading();
        Gmess.getList({
            page: $scope.params.page,
            key: $scope.params.key
        }).success(function (r) {
            Util.loading(false);
            $scope.gmessList = r.list;
            $scope.listcount = r.count;
            if (!$scope.init) {
                fnInitPager();
                $scope.init = true;
            }
        });
    }

    /**
     * 云素材列表
     */
    function fnGetCloudList() {
        Util.loading();
        Gmess.getCloudList({
            id: $scope.gmessCategoryId,
            page: $scope.params.page,
            key: $scope.params.key
        }).success(function (r) {
            Util.loading(false);
            $scope.gmessCloudList = r;
            $scope.listcount = $scope.gmessCloudList.allNum;
            if (!$scope.init) {
                fnInitPager();
                $scope.init = true;
            }
        });
    }

    /**
     * 克隆文章
     * @param gmess
     */
    $scope.download = function (gmess) {
        if ($scope.downloading) {
            return false;
        }
        if ($scope.gmess.id != false) {
            $scope.downloading = true;
            Gmess.cloneGmess($scope.gmess).success(function (r) {
                $scope.downloading = false;
                if (r.ret_code == 0) {
                    Util.alert('素材下载成功');
                    $('#modal_gmess_clone').modal('hide');
                } else {
                    Util.alert('下载失败，系统异常', true);
                }
            });
        } else {
            Util.alert('系统异常', true);
        }
    };

    /**
     * 发送素材消息
     */
    $scope.sendGmess = function (mediaId) {
        if (mediaId == null) {
            return Util.alert("操作失败, 该文章的mediaId为空, 请编辑并保存再操作");
        }
        if (confirm("你确定要群发这条消息吗, 一旦发布不可撤回")) {
            Util.loading();
            Gmess.sendGmess({
                mediaid: mediaId
            }).success(function (ret) {
                Util.loading(false);
                if (ret.ret_code == 0) {
                    Util.alert("群发成功!");
                } else {
                    Util.alert(ret.ret_msg, true);
                }
            });
        }
    }

    $('#modal_gmess_clone').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        var id = btn.data('id');
        $scope.downloading = false;
        for (var i in $scope.gmessCloudList.contentlist) {
            if ($scope.gmessCloudList.contentlist[i].id == id) {
                $scope.gmess = $scope.gmessCloudList.contentlist[i];
                $scope.$apply();
            }
        }
    });

    fnGetList();

});
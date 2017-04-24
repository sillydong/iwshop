/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function ($, util, fancyBox, dataTables) {
    $(function () {

        var dt = $('.dTable').dataTable(DataTableConfig).api();
        var authList = $('.admin-auth-list');//管理员权限td节点
        var enAuth = [];//权限集合(英文)
        var zhAuth = [];//权限集合(中文)
        var adminAccount = [];//已有管理员账号集合;
        var isDiff = false;//账号是否重复,true:无重复 || false:有重复
        var operateType = 0;//操作类型,1:添加 || 0:编辑
        var accountReg = /^([\u4E00-\uFA29]|[\uE7C7-\uE7F3]|[a-zA-Z0-9])*$/;//账号正则判断(中文,字母,数字,英文不区分大小写)
        var isFlag = false;//判断账号是否匹配正则

        /**
         * 编辑或添加账号通用httppost
         * @param {type} flag
         * @param {type} cid
         * @param {type} acc
         * @param {type} pwd
         * @param {type} auth
         * @returns {undefined}
         */
        function authPost(flag, cid, acc, pwd, auth) {
            flag = flag || false;
            if (flag) {
                $.post('?/wSettings/addAuth/', {
                    id: cid > 0 ? cid : '',
                    acc: acc,
                    pwd: pwd,
                    auth: auth
                }, function (res) {
                    if (res > 0) {
                        $.fancybox.close();
                        location.reload();
                        util.Alert('操作成功');
                    } else {
                        util.Alert('操作失败!', true);
                    }
                });
            } else {
                util.Alert('账号格式错误!', true);
            }

        }

        //权限英文替换为中文
        $.each(authList, function (i, node) {

            enAuth = $(node).text().split(',');

            $.each(enAuth, function (index, item) {
                if (item == 'stat')
                    zhAuth.push('报表');
                else if (item == 'orde')
                    zhAuth.push('订单');
                else if (item == 'prod')
                    zhAuth.push('商品');
                else if (item == 'gmes')
                    zhAuth.push('消息');
                else if (item == 'user')
                    zhAuth.push('会员');
                else if (item == 'comp')
                    zhAuth.push('代理');
                else if (item == 'sett')
                    zhAuth.push('设置');
            });

            $(node).after('<td>' + zhAuth.join(',') + '</td>');
            zhAuth.length = 0;//重置权限集合(中文)

        });

        //已有管理员账号集合
        $('.sorting_1').each(function (i, node) {
            adminAccount.push($(node).text());
        });

        //添加操作
        $('#add-level').click(function () {
            operateType = 1;
        });
        //编辑操作
        $('.add-level').click(function () {
            operateType = 0;
        });

        //添加权限 || 编辑权限 (模态框)
        fnFancyBox('#add-level,.add-level', function () {

//            $('.expprovince label').unbind('click').click(function () {
//                $(this).parent().find('input').click();
//            });

            $('.expitem').click(function () {
                $(this).toggleClass('hov');
            });

            //账号输入框失去焦点事件
            $('#acc').on('blur', function () {

                var newAccount = $(this).val();//新账号
                $.each(adminAccount, function (i, val) {
                    newAccount == val ? isDiff = false : isDiff = true;
                });

            });

            $('#acc').on({
                keyup: function () {
                    accountReg.test($(this).val()) ? isFlag = true : isFlag = false;
                },
                blur: function () {
                    var newAccount = $(this).val();//新账号
                    $.each(adminAccount, function (i, val) {
                        newAccount == val ? isDiff = false : isDiff = true;
                    });
                }
            });

            //保存按钮点击
            $('#al-com-save').unbind('click').click(function () {

                var auth = [];//允许权限集合

//                $('#authList input').each(function () {
//                    if ($(this).get(0).checked) {
//                        auth.push($(this).val());
//                    }
//                });

                $('.expitem.hov').each(function (i, node) {
                    auth.push($(node).attr('data-auth'));
                });

                var cid = parseInt($(this).attr('data-id'));

                if (operateType) {//添加操作
                    //检测新账号是否和已有账号重复
                    if (isDiff) {
                        authPost(isFlag, cid, $('#acc').val(), $('#pwd').val(), auth.join(','));
                    } else {
                        util.Alert('操作失败,账号名重复或为空!', true);
                    }
                } else {//编辑操作
                    authPost(isFlag, cid, $('#acc').val(), $('#pwd').val(), auth.join(','));
                }

            });

        });

        $('.envs_del').click(function () {
            if (confirm('你确认要删除么')) {
                var node = $(this);
                $.post('?/wSettings/deleteAuth/', {
                    id: $(this).attr('data-id')
                }, function (res) {
                    if (res > 0) {
                        util.Alert('删除成功');
                        dt.row(node.parents('tr')).remove().draw();
                    } else {
                        util.Alert('操作失败!', true);
                    }
                });
            }
        });

    });
});
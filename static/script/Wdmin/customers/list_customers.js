
DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function($, util, fancyBox, dataTables, Spinner) {
    $(function() {

        dt = false;

        // 加载完毕隐藏loading
        window.frameOnload = function() {
            window.setTimeout(function() {
                Spinner.stop();
                $('#iframe_loading').fadeOut();
            }, 500);
        };

        /**
         * 左侧分组名称点击，加载对应列表
         */
        $('.list-user-group-item').click(function(e) {
            var target = e.target || e.toElement;
            // 跳过编辑按钮
            if (!$(target).hasClass('del')) {
                $('.list-user-group-item.selected').removeClass('selected');
                $(this).addClass('selected');
                ajaxLoadUserList($(this).attr('data-id'));
            }
        }).hover(function() {
            $(this).find('.del').show();
        }, function() {
            $(this).find('.del').hide();
        });

        /**
         * 编辑分组名
         * @returns {undefined}
         */
        fnFancyBox('.list-user-group-item .del', function() {
            $('#save_btn').on('click', function() {
                $(this).html('处理中...');
                // HttpPost
                $.post('?/WdminAjax/ajaxAlterUserGroup/', {
                    id: $('#gid').val(),
                    name: $('#gname').val()
                }, function(res) {
                    if (res.errcode === 0) {
                        util.Alert('保存成功');
                        $.fancybox.close();
                    } else {
                        util.Alert('操作失败!', true);
                        $(this).html('保存');
                    }
                });
            });
        });

        fnFancyBox('#addGroup', function() {
            $('#save_btn').on('click', function() {
                $(this).html('提交中...');
                // HttpPost
                $.post('?/WdminAjax/ajaxAddUserGroup/', {
                    name: $('#gname').val()
                }, function(res) {
                    if (res.errcode === undefined) {
                        util.Alert('添加成功');
                        $.fancybox.close();
                        location.reload();
                    } else {
                        util.Alert('操作失败!', true);
                        $(this).html('提交');
                    }
                });
            });
        });

        /**
         * 加载用户列表
         * @param {type} gid
         * @returns {undefined}
         */
        function ajaxLoadUserList(gid) {
            $('#iframe_customer').attr('src', '?/WdminPage/iframe_list_customer/gid=' + gid);
        }

        /**
         * 注册resize函数
         */
        util.onresize(function() {
            $('#categroys').css('height', $(window).height());
            $('#iframe_customer').css('height', $(window).height());
        });

        ajaxLoadUserList('');

    });
});
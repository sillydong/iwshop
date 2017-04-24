
DataTableConfig.order = [[0, 'desc']];
requirejs(['jquery', 'util', 'fancyBox', 'datatables'], function($, util, fancyBox, dataTables) {
    $(function() {
        $('#abscenter').css('marginTop', ($(window).height() - $('#abscenter').height()) / 2);
        fnFancyBox('#alter_info', function() {
            $('#al-com-save').unbind('click').click(function() {
                var cid = parseInt($(this).attr('data-id'));
                if (cid > 0) {
                    var data = $('#form_alter_company').serializeArray();
                    $.post(shoproot + '?/Company/ajaxAlterCompanyInfo/', {
                        id: cid,
                        data: data
                    }, function(res) {
                        if (res > 0) {
                            util.Alert('修改成功');
                            $.fancybox.close();
                        } else {
                            util.Alert('修改失败', true);
                        }
                    });
                }
            });
        });
    });
});
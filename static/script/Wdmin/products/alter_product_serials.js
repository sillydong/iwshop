
requirejs(['jquery', 'datatables', 'fancyBox', 'util', 'Spinner'], function($, dataTable, fancyBox, util, Spinner) {
    $(function() {

        fnFancyBox('#add_category_btn', function() {
            $('#add_cate_btn').click(function() {
                $.post('?/vProduct/ajaxAlterSerial/', {
                    id: 0,
                    name: $('#cat_name_f').val()
                }, function(r) {
                    if (parseInt(r) > 0) {
                        util.Alert('保存成功！');
                        location.reload();
                    } else {
                        util.Alert('保存失败！');
                    }
                    $.fancybox.close();
                });
            });
        });

        $('body').css('overflow', 'hidden');
        util.dataTableLis('#serialTable', true);

        // 监听iframe onload事件，关闭loading动画层
        $('#iframe_alterserial').on('load', function() {
            window.setTimeout(function() {
                Spinner.stop();
                $('#iframe_loading').fadeOut();
            }, 500);
        });

        $('.alt-serial-item').click(function() {
            if ($(this).attr('data-id') !== '1') {
                $('#iframe_loading').show();
                Spinner.spin($('#iframe_loading').get(0));
                $('#iframe_alterserial').attr('src', shoproot + '?/WdminPage/iframe_alter_serial/id=' + $(this).attr('data-id'));
            }
        });

        $('.alt-serial-item').eq(1).click();

        util.onresize(function() {
            $('#categroys').css('height', $(window).height());
            $('#iframe_alterserial').css('height', $(window).height() - 3);
        });
    });
});
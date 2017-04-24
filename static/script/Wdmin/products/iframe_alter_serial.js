
/* global shoproot */

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'ztree', 'ztree_loader', 'ueditor', 'jUploader'], function($, Util, fancyBox, dataTables, ztree, treeLoader, umeditor, jUploader) {


    $(function() {

        uep = UM.getEditor('ueditorp');

        uep.ready(function() {
            uep.setHeight(220);
            uep.setWidth('100%');
            ueploaded = true;
        });

        // del
        $('#del-cate').click(function() {
            if (confirm('你确定要删除这个分类吗')) {
                $.post('?/vProduct/ajaxDeleteSerial/', {
                    id: $('#sid').val()
                }, function(r) {
                    r = parseInt(r);
                    if (r > 0) {
                        Util.Alert('删除成功！', false, function() {
                            window.parent.location.reload();
                        });
                    } else {
                        Util.Alert('删除失败！');
                    }
                });
            }
        });

        // alter
        $('#save-cate').click(function() {
            $.post('?/vProduct/ajaxAlterSerial/', {
                id: $('#sid').val(),
                data: $('form#alter_serial').serializeArray()
            }, function(r) {
                r = parseInt(r);
                if (r > 0) {
                    Util.Alert('保存成功！');
                } else {
                    Util.Alert('保存失败！');
                }
            });
        });

        $.jUploader({
            button: 'alter_categroy_image',
            action: shoproot + '?/WdminAjax/BannerImageUpload/dir=images_serial',
            onComplete: function(fileName, response) {
                if (response.s > 0) {
                    $('#cat_image_src').val(response.img);
                    $('#catimage').attr('src',response.link);
                    $('#cat_none_pic').hide();
                } else {
                    Util.Alert('上传图片失败，请联系技术支持');
                }
            }
        });
    });
});
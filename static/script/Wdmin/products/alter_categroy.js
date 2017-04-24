/* global shoproot */

/**
 * 编辑分类
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'jUploader'], function ($, Util, fancyBox, jUploader) {
    $(function () {

        $("#pd-cat-select").find("option[value='" + $('#cat_parent').val() + "']").get(0).selected = true;

        $('#del-cate').click(function () {
            if (confirm('你确定要删除这个分类吗')) {
                $.post('?/wProduct/ajaxDelCategroy/', {
                    id: $('#cat_id').val()
                }, function (r) {
                    r = parseInt(r);
                    if (r > 0) {
                        alert('删除成功');
                        window.parent.fnDelSelectCat();
                        window.parent.location.reload();
                    }
                });
            }
        });

        // alter
        $('#save-cate').click(function () {
            var data = $('#catForm').serializeArray();
            $.post('?/wProduct/ajaxAlterCategroy/', {
                id: $('#cat_id').val(),
                data: data
            }, function (r) {
                r = parseInt(r);
                if (r > 0) {
                    Util.Alert('保存成功');
                    window.parent.fnReloadTree();
                } else {
                    Util.Alert('保存失败');
                }
            });
        });

        $.jUploader({
            button: 'alter_categroy_image',
            action: '?/wImages/ImageUpload/',
            onComplete: function (fileName, response) {
                if (response.ret_code == 0) {
                    $('#cat_image_src').val(response.ret_msg);
                    $('#catimage').attr('src', response.ret_msg).show();
                    $('#cat_none_pic').hide();
                    Util.Alert('上传图片成功');
                } else {
                    Util.Alert('上传图片失败');
                }
            }
        });
    });
});
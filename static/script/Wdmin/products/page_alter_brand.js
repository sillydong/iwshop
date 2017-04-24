/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'ztree', 'ztree_loader', 'ueditor', 'jUploader'], function ($, Util, fancyBox, dataTables, ztree, treeLoader, umeditor, jUploader) {
    $(function () {

        //$("#pd-cat-select").find("option[value='" + $('#cat_parent').val() + "']").get(0).selected = true;

        $('#del-cate').click(function () {
            if (confirm('你确定要删除这个品牌吗')) {
                $.post('?/wBrands/del/', {
                    id: $('#brandid').val()
                }, function (r) {
                    r = parseInt(r);
                    if (r > 0) {
                        Util.Alert('删除成功');
                        window.parent.fnDelSelectCat();
                        window.parent.location.reload();
                    }
                });
            }
        });

        // alter
        $('#save-cate').click(function () {
            var data = $('#catForm').serializeArray();
            $.post('?/wBrands/set/', {
                id: $('#brandid').val(),
                data: data
            }, function (r) {
                r = parseInt(r);
                if (parseInt(r) > 0) {
                    Util.Alert('保存成功');
                    window.parent.fnReloadTree();
                } else {
                    Util.Alert('保存失败', true);
                }
            });
        });

        $.jUploader({
            button: 'alter_categroy_image1',
            action: '/?/wImages/ImageUpload/',
            onComplete: function (fileName, response) {
                if (response.ret_code == 0) {
                    $('#brand_img1').val(response.ret_msg);
                    $('#catimage1').attr('src', response.ret_msg).show();
                    $('#cat_none_pic1').hide();
                    Util.Alert('上传图片成功');
                } else {
                    Util.Alert('上传图片失败');
                }
            }
        });

        $.jUploader({
            button: 'alter_categroy_image2',
            action: '/?/wImages/ImageUpload/',
            onComplete: function (fileName, response) {
                if (response.ret_code == 0) {
                    $('#brand_img2').val(response.ret_msg);
                    $('#catimage2').attr('src', response.ret_msg).show();
                    $('#cat_none_pic2').hide();
                    Util.Alert('上传图片成功');
                } else {
                    Util.Alert('上传图片失败');
                }
            }
        });

    });
});
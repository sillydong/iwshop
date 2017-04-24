/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'Spinner', 'jUploader'], function ($, util, fancyBox, Spinner, jUploader) {

    var gmessId = 0;

    $('#setting_tab a').click(function (e) {
        e.preventDefault()
    });

    $('#saveBtn').click(function () {
        var data = $('#settingFrom').serializeArray();
        $.post('?/wSettings/updateSettings/', {
            data: data
        }, function (r) {
            if (r > 0) {
                util.Alert('保存成功');
            } else {
                util.Alert('保存失败', true);
            }
        });
    });

    // 2> 选择图文素材
    fnFancyBox('#sGmess', function () {
        $('.gmBlock').bind('click', function () {
            $('#welcomegmess').val(parseInt($(this).attr('data-id')));
            var block = $(this).clone();
            block.find('.sel').remove();
            block.find('.title').width($('#sGmess').width() - 28);
            block.find('.desc').width($('#sGmess').width() - 28);
            block.find('img').width($('#sGmess').width() - 28).height(($('#sGmess').width() - 28) / 1.8125);
            $('#GmessItem').empty().append(block).css({
                marginTop: '10px'
            });
            $('#gmessTip').hide();
            $.fancybox.close();
        });
    });

    /**
     * 图文选择自适应调整
     * @returns {undefined}
     */
    function gmBlockAdjust() {
        var block = $('.gmBlock').eq(0);
        block.find('.sel').remove();
        block.find('.title').width($('#sGmess').width() - 28);
        block.find('.desc').width($('#sGmess').width() - 28);
        block.find('img').width($('#sGmess').width() - 28).height(($('#sGmess').width() - 28) / 1.8125);
        $('#GmessItem').css({
            marginTop: '10px'
        });
        $('#gmessTip').hide();
    }

    /**
     * 清除抢红包记录
     */
    $('#clearRecord').click(function () {
        $.post('?/wSettings/clearEnvsRobRecord/', {}, function () {
            util.Alert('记录已清空');
        });
    });

    // 公众号图标上传
    $.jUploader({
        button: 'upload_icon',
        action: '?/wImages/ImageUpload/',
        onComplete: function (fileName, response) {
            if (response.ret_code == 0) {
                $('#icon').val(response.ret_msg);
                $('#icon-loading').height(0);
                $('#iconimage').attr('src', response.ret_msg).fadeIn(function () {
                    Spinner.stop();
                });
                $('#icon_none_pic').hide();
                util.Alert('上传图片成功');
            } else {
                util.Alert('上传图片失败');
            }
        },
        onUpload: function () {
            $('#iconimage').attr('src', '').hide();
            $('#icon-loading').height(100);
            Spinner.spin($('#icon-loading').get(0));
        }
    });

    // 公众号二维码上传
    $.jUploader({
        button: 'upload_qrcode',
        action: '?/wImages/ImageUpload/',
        onComplete: function (fileName, response) {
            if (response.ret_code == 0) {
                $('#qrcode').val(response.ret_msg);
                $('#qrcode-loading').height(0);
                $('#qrcodeimage').attr('src', response.ret_msg).fadeIn(function () {
                    Spinner.stop();
                });
                $('#icon_none_pic').hide();
                util.Alert('上传图片成功');
            } else {
                util.Alert('上传图片失败');
            }
        },
        onUpload: function () {
            $('#qrcodeimage').attr('src', '').hide();
            $('#qrcode-loading').height(100);
            Spinner.spin($('#qrcode-loading').get(0));
        }
    });

    // 公众号二维码上传
    $.jUploader({
        button: 'upload_uc_bg',
        action: '?/wImages/ImageUpload/',
        onComplete: function (fileName, response) {
            if (response.ret_code == 0) {
                $('#ucenter_background_image').val(response.ret_msg);
                $('#uc-bg-loading').height(0);
                $('#uc-bg-image').attr('src', response.ret_msg).fadeIn(function () {
                    Spinner.stop();
                });
                $('#uc_none_pic').hide();
                util.Alert('上传图片成功');
            } else {
                util.Alert('上传图片失败');
            }
        },
        onUpload: function () {
            $('#uc-bg-image').attr('src', '').hide();
            $('#uc-bg-loading').height(100);
            Spinner.spin($('#uc-bg-loading').get(0));
        }
    });

    gmBlockAdjust();

});
/**
 * 个人中心首页
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner'], function (util, $, Spinner) {

        var qrcodeLoaded = false;

        $('#companyQrcode').click(function (node) {
            $('#wrapper').show();
            if (!qrcodeLoaded) {
                Spinner.spin($('#wrapper').get(0));
                // [HttpPost]
                $.post('?/Company/companyQrcode/', {}, function (url) {
                    Spinner.stop();
                    $('#wrapper').append('<img src="' + url + '" /><p>长按二维码，点击保存图片</p>');
                    $('#wrapper img').on('load', function () {
                        $(this).animate({
                            marginTop: ($(window).height() - 250) / 2 - 35
                        }, 500);
                    });
                });
                qrcodeLoaded = true;
            }
            $('#wrapper .close').click(function () {
                $('#wrapper').hide();
            });
        });

    });
});
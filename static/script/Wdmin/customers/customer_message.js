/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */


DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function($, util, fancyBox, dataTables, Spinner) {

    // 加载完毕隐藏loading
    window.frameOnload = function() {
        window.setTimeout(function() {
            Spinner.stop();
            $('#iframe_loading').fadeOut();
        }, 500);
    };

    $('.umslist').on('click', function() {
        $('.umslist.selected').removeClass('selected');
        $(this).addClass('selected');
        $('#iframe_loading').show();
        Spinner.spin($('#iframe_loading').get(0));
        var openid = $(this).attr('data-openid');
        var msgid = $(this).attr('data-id');
        $('#iframe_msgsession').get(0).contentWindow.location.replace(shoproot + '?/WdminPage/message_session/openid=' + openid);
    });
    
    $('.umslist').eq(0).click();

    util.onresize(function() {
        $('#categroys').css('height', $(window).height());
        $('#iframe_msgsession').css('height', $(window).height());
    });
});
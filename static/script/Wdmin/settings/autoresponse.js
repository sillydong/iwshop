/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function($, util, fancyBox, dataTables, Spinner) {


    itemClickListen();

    $('.list-user-group-item').eq(0).click();

    // 一级添加
    // 添加顶级菜单
    $('#topAdd').on('click', function() {
        $('#addmenu1_t').click();
    });

    fnFancyBox('#addmenu1_t', function() {
        $('#menu-name-sm').focus();
        $('#add_menu_btn').unbind('click').on('click', function() {
            if ($('#menu-name-sm').val() !== '') {
                $.post('?/WdminAjax/addAutoReplys/', {key: $('#menu-name-sm').val()}, function(id) {
                    $('#alist').prepend('<div data-id="' + id + '" class="list-user-group-item Elipsis">' + $('#menu-name-sm').val() + '</div>');
                    itemClickListen();
                    $('.list-user-group-item').eq(0).click();
                    $.fancybox.close();
                });
            } else {
                util.Alert('请输入名称', true);
            }
        });
    });

    function itemClickListen() {
        $('.list-user-group-item').unbind('click').on('click', function() {
            $('#iframe_loading').show();
            Spinner.spin($('#iframe_loading').get(0));
            var id = parseInt($(this).attr('data-id'));
            $('#ntright').attr('src', shoproot + '?/WdminPage/iframe_alter_autoresponse/id=' + id);
            $('.list-user-group-item.selected').removeClass('selected');
            $(this).addClass('selected');
        });
    }

    $('#ntright').on('load', function() {
        $('#iframe_loading').hide();
        Spinner.stop();
    });

    /**
     * 注册resize函数
     */
    util.onresize(function() {
        $('#alist').css('height', $(window).height() - 122);
        $('#ntright').css('height', $(window).height() - 124);
    });

});
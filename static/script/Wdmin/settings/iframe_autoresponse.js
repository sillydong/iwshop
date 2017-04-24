/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

var uep;
requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner', 'ueditor'], function($, util, fancyBox, dataTables, Spinner, ueditor) {


    var reltype = parseInt($('#reltype').val());
    var rel = parseInt($('#rel').val());
    $('#rad1').unbind('click').on('click', function() {
        $('.acts').hide();
        $('.acts').eq(0).show();
        reltype = 0;
    });
    $('#rad2').unbind('click').on('click', function() {
        $('.acts').hide();
        $('.acts').eq(1).show();
        if (uep !== undefined) {
            uep.setWidth($('#gmess-title').width());
        }
        reltype = 1;
    });
    if (reltype === 0) {
        $('#rad1').click();
    } else {
        $('#rad2').click();
    }

    $('#save_btn').on('click', function() {
        var postData = {
            data: {
                id: $(this).attr('data-id'),
                key: $('#au-key').val(),
                message: $('#au-message').val(),
                rel: rel,
                reltype: reltype,
                gmess: {
                    id: rel,
                    desc: $('#gmess-desc').val(),
                    title: $('#gmess-title').val(),
                    catimg: $('#gmess-catimg').val(),
                    content: uep.getContent()
                }
            }
        };
        $.post('?/WdminAjax/setAutoReplys/', postData, function(R) {
            if (R >= 0) {
                util.Alert('保存成功');
            } else {
                util.Alert('保存失败，系统错误', true);
            }
        });
    });
    $('#delete_btn').on('click', function() {
        if (confirm('你确认要删除吗')) {
            $.post('?/WdminAjax/deleteAutoReplys/', {
                id: $(this).attr('data-id')
            }, function(R) {
                if (R > 0) {
                    util.Alert('删除成功');
                    parent.window.location.reload();
                } else {
                    util.Alert('删除失败，系统错误', true);
                }
            });
        }
    });
    uep = UM.getEditor('ueditorp');
    uep.ready(function() {
        uep.setWidth($('#gmess-title').width());
    });
});
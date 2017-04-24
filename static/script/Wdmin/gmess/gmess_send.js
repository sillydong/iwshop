
/* global shoproot, DataTableConfig */

sending = false;

gmessId = 0;

DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function($, util, fancyBox, dataTables, Spinner) {

    var domain = location.origin + location.pathname;

    $(function() {

        $('body').css('overflow-x', 'hidden');
        $('#thumbUp').hover(function() {
            if (!$(this).hasClass('ove')) {
                $(this).addClass('hover');
            }
        }, function() {
            if (!$(this).hasClass('ove')) {
                $(this).removeClass('hover');
            }
        });

        fnFancyBox('#save_gmess_btn,#thumbUp', function() {
            $('.gmBlock').bind('click', function() {
                var block = $(this).clone();
                gmessId = parseInt(block.attr('data-id'));
                $('.appmsg_title a').eq(0).html(block.find('.title').html());
                $('#appmsimg-preview').attr('src', block.find('img').attr('src')).show();
                $('#thumbUp').eq(0).addClass('ove');
                $('.appmsg_desc').eq(0).html(block.find('.desc').html());
                window.thumbURI = domain + block.find('img').attr('src');
                $.fancybox.close();
            });
        });

        $('#send_gmess_btn').click(function() {
            if (gmessId > 0) {
                var method = '';
                var openid = getSelectedOpenids();
                var openidLength = openid.length;
                if ($('#gsend-target').val() === '0') {
                    if (openidLength !== parseInt($('#openidCount').val())) {
                        method = 'openid';
                    } else {
                        method = 'all';
                        openid = '';
                    }
                } else {
                    method = 'group';
                }
                if ($('#gsend-way').val() === 'sendGmessNWay') {
                    // 高级群发接口
                    if (!sending) {
                        sending = true;
                        $('.gmess-sending').show();
                        Spinner.spin($('.gmess-sending').get(0));
                        $.post(shoproot + '?/Gmess/' + $('#gsend-way').val(), {
                            id: gmessId,
                            method: method,
                            groupid: $('#gsend-target').val() === '1' ? $('#gsend-group').val() : '',
                            openid: openid,
                            total: parseInt($('#openidCount').val())
                        }, function(res) {
                            if (res === '0') {
                                util.Alert('群发成功！');
                            } else {
                                util.Alert('群发失败，请联系技术支持！', true);
                            }
                            $('.gmess-sending').hide();
                            Spinner.stop();
                            sending = false;
                        });
                    }
                } else {
                    // 客服消息接口
                    var openid = getSelectedOpenids();
                    if (!sending) {
                        sending = true;
                        $('.gmess-sending').show();
                        Spinner.spin($('.gmess-sending').get(0));
                        if ($('#stoken').val() !== '') {
                            var request_uri = 'https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=' + $('#stoken').val();
                            var successCount = 0;
                            var postData = {
                                touser: '',
                                msgtype: 'news',
                                news: {
                                    articles: [
                                        {
                                            title: $('.appmsg_title a').eq(0).html(),
                                            description: $('.appmsg_desc').eq(0).html(),
                                            url: domain + '?/Gmess/view/id=' + gmessId,
                                            picurl: thumbURI
                                        }
                                    ]
                                }
                            };
                            function _send(i) {
                                // 参数
                                postData.touser = openid[i];
                                $.post(shoproot + '_proxy/post.php', {
                                    url: request_uri,
                                    postdata: postData,
                                    mod: 1
                                }, function(res) {
                                    if (0 === parseInt(res.errcode)) {
                                        // 群发到达
                                        successCount++;
                                    }
                                    groupSendProcessing(((i++) / openidLength) * 100);
                                    if (openidLength === i) {
                                        groupSendProcessing(100);
                                        $.post('?/WdminAjax/UploadGroupSendStatData/', {
                                            msgid: gmessId,
                                            success: successCount,
                                            total: openidLength
                                        }, function(R) {
                                            if (R > 0) {
                                                util.Alert('群发成功！');
                                            } else {
                                                util.Alert('群发失败，请联系技术支持！', true);
                                            }
                                            $('#send_gmess_btn').html('开始群发');
                                            $('.gmess-sending').hide();
                                            Spinner.stop();
                                            sending = false;
                                        });
                                    } else {
                                        _send(i);
                                    }
                                });
                            }
                            _send(0);
                        }
                    }
                }
            } else {
                util.Alert('请先选择素材！', true);
                $('#thumbUp').click();
            }
        });

        $('#gsend-target').on('change', function() {
            if ($(this).val() === '1') {
                $('#gmessUserList .divlist').hide();
                $('#gmessUserList .divblock').removeClass('hidden').addClass('lock');
                $('#gsend-group').parents('.gmess-area').removeClass('hidden');
            } else {
                $('#gmessUserList .divlist').show();
                $('.dTableX1 tr').each(function() {
                    if ($(this).find('input').get(0).checked === false) {
                        $(this).click();
                    }
                });
                $('.checkAll').get(0).checked = true;
                $('#gmessUserList .divblock').addClass('hidden').removeClass('lock');
                $('#gsend-group').parents('.gmess-area').addClass('hidden');
            }
        });

        $('#gsend-way').on('change', function() {
            if ($(this).val() === 'sendGmessNWay') {
                $('#gsend-target').parents('.gmess-area').removeClass('hidden');
                if ($('#gsend-target').val() === '1') {
                    $('#gsend-group').parents('.gmess-area').removeClass('hidden');
                }
            } else {
                $('#gsend-target').parents('.gmess-area').addClass('hidden');
                $('#gsend-group').parents('.gmess-area').addClass('hidden');
                $('#gmessUserList .divblock').addClass('hidden').removeClass('lock');
                $('#gsend-group').parents('.gmess-area').addClass('hidden');
            }
        });

        $('#gmessUserList .divlist').load(shoproot + '?/WdminPage/ajax_gmess_user_list/', function() {
            DataTableMuli = true;
            util.dataTableLis('.dTableX1', true);
            $('#gmessUserList .divblock').addClass('hidden');
            $('#gmessUserList .divlist').removeClass('hidden');
            $('#gmessUserList').height($(window).height() - 150);
            $('.checkAll').click();
            Spinner.stop();
        });

        util.onresize(function() {
            $('#gmessUserList').height($(window).height() - 150);
        });

        Spinner.spin($('#gmessUserList .divblock').get(0));

        function getSelectedOpenids() {
            var openid = [];
            $('.gmess-user-checks:checked').each(function() {
                openid.push($(this).attr('data-openid'));
            });
            return openid;
        }

    });

});

/**
 * 发送进度提示
 * @param {type} percent
 * @returns {Boolean}
 */
function groupSendProcessing(percent) {
    if (percent > 100) {
        return false;
    }
    $('#send_gmess_btn').html('发送中 ' + parseFloat(percent).toFixed(2) + '%');
}
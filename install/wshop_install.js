/*
 * Copyright (C) 2014 koodo@qq.com.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */

// jquery validation 
// @see http://www.w3cschool.cc/jquery/jquery-plugin-validate.html

var lock = false;

var envpass = false;

var sept = 0;

$(function () {
    $('form').eq(0).show();
    $('input').eq(0).focus();
    var vali = {
        errorPlacement: function (error, element) {
            element.parent().parent().find('.gs-tip1').eq(0).html(error);
        }
    };
    var docroot = location.pathname.substr(0, location.pathname.lastIndexOf('/') + 1).replace('install/', '');
    $('#f-domain').val(location.origin + '/');
    $('#docroot').val(docroot);

    // 检查环境
    $('#install-btn0').click(function () {
        if (!envpass) {
            Alert('正在检测系统环境，请稍等...');
            envs_check({}, function (r) {
                $('#__alert__').remove();
                if (r.retcode === 0) {
                    envpass = true;
                    var json = r.retmsg;
                    for (var i in r.retmsg) {
                        if (!r.retmsg[i]) {
                            envpass = false;
                            $('#' + i).removeClass('ok');
                            $('#' + i).addClass('no');
                        } else {
                            $('#' + i).addClass('ok');
                            $('#' + i).removeClass('no');
                        }
                    }
                    $('#env-version b').html(' (' + json.version + ')');
                    if (!envpass) {
                        $('#install-btn0').html('重新检测');
                    } else {
                        // 通过检测
                        $('#install-btn0').html('下一步');
                    }
                } else {
                    handelError(r.retmsg);
                }
            });
        } else {
            // 环境检测下一步
            goSept(++sept);
        }
    });

    // 第一步
    $('#install-btn1').click(function () {
        var node = $(this);
        if ($('#sept1').validate(vali).form()) {
            var f1 = $('#sept1').serializeObject();
            node.html("验证中...");
            vali_db(f1, function (r) {
                node.html("下一步");
                if (r.retcode === 0) {
                    goSept(++sept);
                    Alert('数据库连接成功！');
                } else {
                    handelError(r.retmsg);
                }
            });
        }
    });
    // 第二步
    $('#install-btn2').click(function () {
        var node = $(this);
        if ($('#sept2').validate(vali).form()) {
            var f1 = $('#sept1').serializeObject();
            var f2 = $('#sept2').serializeObject();
            var f = extend({}, [f1, f2]);
            delete f[0];
            delete f[1];
            // 导入数据库
            node.html("验证中...");
            install_dbtable(f, function (r) {
                if (r.retcode === 0) {
                    Alert('数据库导入成功！');
                    // 写入config文件
                    install_config(f, function (val, r) {
                        if (val) {
                            location.href = docroot + '?/Wdmin/login/';
                        }
                    });
                } else {
                    handelError(r.retmsg);
                }
            });

        }
    });

    $('#install-goback').click(function () {
        goSept(--sept);
    });

    $('#install-btn3').click(function () {
        $('#sept2').hide();
        $('#sept1').show();
        $(this).hide();
        $('#install-btn1').css('display', 'inline-block');
        $('#install-btn2').hide();
    });
    $(window).bind('resize', resize).resize();
});

function extend(des, src, override) {
    if (src instanceof Array) {
        for (var i = 0, len = src.length; i < len; i++)
            extend(des, src[i], override);
    }
    for (var i in src) {
        if (override || !(i in des)) {
            des[i] = src[i];
        }
    }
    return des;
}

jQuery.prototype.serializeObject = function () {
    var obj = new Object();
    $.each(this.serializeArray(), function (index, param) {
        if (!(param.name in obj)) {
            obj[param.name] = param.value;
        }
    });
    return obj;
};

// 检查系统环境
function envs_check(param, _func) {
    hideError();
    param.a = 'env_check';
    $.post('ajax_installer.php', param, function (r) {
        _func(r);
    });
}

// 检查数据库连接
function vali_db(param, _func) {
    hideError();
    param.a = 'db_valid';
    $.post('ajax_installer.php', param, function (r) {
        _func(r);
    });
}

// 进行数据库导入
function install_dbtable(param, _func) {
    hideError();
    param.a = 'db_install';
    $.post('ajax_installer.php', param, function (r) {
        _func(r);
    });
}

// 安装配置文件
function install_config(param, _func) {
    hideError();
    param.a = 'config_install';
    $.post('ajax_installer.php', param, function (r) {
        _func(r);
    });
}

function resize() {
    $('#center').animate({
        marginTop: ($(window).height() - $('#center').height()) / 2
    }, 200);
}

/**
 * 处理错误信息
 * @param msg
 */
function handelError(msg) {
    $('#errorinfo').html(msg + '<br>如需帮助，请加QQ群： 470442221').show();
    resize();
}

function hideError() {
    $('#errorinfo').hide();
}

/**
 * 跳转步骤
 * @param sept
 */
function goSept(sept) {
    $('.septs').hide();
    $('#sept' + sept.toString()).show();
    $('#sept' + sept.toString()).find('input').eq(0).focus();
    $('.button').hide();
    $('#install-btn' + sept.toString()).css('display', 'inline-block');
    if (sept > 0) {
        $('#install-goback').css('display', 'inline-block');
    } else {
        $('#install-goback').hide();
    }
    resize();
}
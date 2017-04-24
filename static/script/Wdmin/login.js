var loading = false;

var shoproot = location.pathname.substr(0, location.pathname.lastIndexOf('/') + 1);

//Spinner 配置项
var Spinner = new Spinner({
    lines: 11, // The number of lines to draw
    length: 7, // The length of each line
    width: 2, // The line thickness
    radius: 9, // The radius of the inner circle
    corners: 0.9, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#44b549', // #rgb or #rrggbb or array of colors
    speed: 1.2, // Rounds per second
    trail: 25, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: true, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: 'auto', // Top position relative to parent
    left: 'auto' // Left position relative to parent
});

$(function () {

    if (parent !== undefined && parent.location.href !== location.href) {
        parent.location.href = location.href;
    }

    if ($('#pd-form-username').val() === '') {
        $('#pd-form-username').focus();
    } else {
        $('#pd-form-password').focus();
    }
    // 登录按钮点击
    $('#login-btn').click(loginCheck);

    // 密码输入框回车
    $('input.form-control').keyup(function (e) {
        if (e.keyCode === 13) {
            $('#login-btn').click();
        }
    });

    $('.inputField input').focus(function () {
        $(this).parent().addClass('focus');
    }).blur(function () {
        $(this).parent().removeClass('focus');
    });

    $('.login-form').addClass('loginShow');

});

/**
 * 登陆验证函数
 * @returns {undefined}
 */
function loginCheck() {
    if ($('#pd-form-username').val() !== '' && $('#pd-form-password').val() !== '') {
        if (!loading) {
            loading = true;
            $('#loading').show();
            Spinner.spin($('#loading').get(0));
            $('.login-gbtn').html('正在登录...');
            $.post(shoproot + '?/Wdmin/checkLogin/', {
                admin_acc: $('#pd-form-username').val(),
                admin_pwd: $('#pd-form-password').val()
            }, function (res) {
                $('#loading').hide();
                Spinner.stop();
                loading = false;
                if (parseInt(res.status) === 1) {
                    Alert('登录成功，正在跳转...');
                    $('.login-gbtn').html('登录成功');
                    location.href = shoproot + '?/Wdmin/';
                } else {
                    $('.login-gbtn').html('登录');
                    Alert('登录失败，用户名或者密码错误！', true);
                }
            });
        }
    }
}

/**
 * 顶部alert提示
 * @param {type} message
 * @param {type} warn
 * @param {type} callback
 * @returns {undefined}
 */
function Alert(message, warn, callback) {
    warn = warn || false;
    var node = $('<div id="__alert__"></div>');
    if (warn) {
        node.addClass('warn');
    } else {
        node.removeClass('warn');
    }
    node.html(message);
    $('body').append(node);
    node.css('left', ($('body').width() - node[0].clientWidth) / 2 + 'px').slideDown();
    window.setTimeout(function () {
        node.slideUp(300, function () {
            if (typeof callback === 'function') {
                callback();
            }
            $('#__alert__').remove();
        });
    }, 3000);
}
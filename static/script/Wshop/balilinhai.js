var shoproot = location.pathname.substr(0, location.pathname.lastIndexOf('/') + 1);

$(function () {
    $('#signin-btn').click(signinCheck);
    $('#sendCode-btn').click(sendCode);
    $('#signup-btn').click(signupCheck);
});

/**
 * 登录验证函数
 */
function signinCheck() {
    var account = $('#signin-form-account').val(),
        password = $('#signin-form-password').val();
    if (account !== '' && password !== '') {
        $.post(shoproot + '?/Wdmin/loginUser/', {
            account: parseInt(account),
            password: password
        }, function (res) {
            if (parseInt(res.status) === 1) {
                Alert('登录成功');
                window.location = 'http://test.shop.youdianx.com/#!/my';
            }
            else {
                Alert('登录失败，请检查您的手机号和密码', true);
            }
        });
    }
}

/**
 * 发送验证码函数
 */
function sendCode() {
    var phone = $('#signup-form-phone').val();
    if (phone !== '') {
        $.post(shoproot + '?/Wdmin/sendCode/', {
            phone: parseInt(phone)
        }, function (res) {
            if (parseInt(res.status) === 1) {
                Alert('验证码已发送，请查收');
            }
            else {
                Alert(res.msg, true);
            }
        });
    }
}

/**
 * 注册账号函数
 */
function signupCheck() {
    var phone = $('#signup-form-phone').val(),
        code = $('#signup-form-code').val(),
        password = $('#signup-form-password').val();
    $.post(shoproot + '?/Wdmin/registerUser/', {
        phone: parseInt(phone),
        code: code,
        password: password
    }, function (res) {
        if (parseInt(res.status) === 1) {
            Alert('注册成功');
            window.location = '{$docroot}?/Uc/balilinhai_signin';
        }
        else {
            Alert(res.msg, true);
        }
    });
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
    var node = $('<div id="__alert__" class="text-center bg-primary"></div>');
    if (warn) {
        node.addClass('warn');
    } else {
        node.removeClass('warn');
    }
    node.html(message);
    $('.content').append(node);
    node.css('left', ($('.content').width() - node[0].clientWidth) / 2 + 'px').slideDown();
    window.setTimeout(function () {
        node.slideUp(300, function () {
            if (typeof callback === 'function') {
                callback();
            }
            $('#__alert__').remove();
        });
    }, 3000);
}
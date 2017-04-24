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

var shoproot = location.pathname.substr(0, location.pathname.lastIndexOf('/') + 1);

// 默认card Index
var defaultCard = 0;

var tHeight = 42;

/**
 * 高度计算标准值
 */
var stdHeight = document.documentElement.clientHeight;

/**
 * 当前iframe导航页面名
 * @type String|nav
 */
var currentSubnav = '';

/**
 * 当前iframe页面名
 * @type Boolean|page
 */
var currentURI = false;

var imgsize = 40;

// jq lis
$(function () {

    $('.navItem').on('click', function () {
        var n = $(this);
        $('#' + n.attr('rel')).find('a').eq(0).click();
    });

    $('.cap-nav-item').on('click', function () {

        var nThis = $(this);

        var nP = $('#' + nThis.parent().attr('id').replace('subnav', 'navitem'));

        var page = nThis.data('page');

        var href = nThis.data('href');

        if (!nThis.parent().hasClass('up')) {
            $('.subnavs.up').slideUp(200).removeClass('up');
            nThis.parent().addClass('up');
            nThis.parent().slideDown(200, load);
        } else {
            load();
        }

        function load() {
            $('#iframe_loading').show();
            $('.navItem.hover').removeClass('hover');
            nP.addClass('hover');
            $('.subnavs a.hov').removeClass('hov');
            nThis.addClass('hov');
            // 跳转页面
            if (href != '' && href != undefined) {
                currentURI = href;
            } else {
                currentURI = '?/WdminPage/' + page;
            }
            $('#right_iframe').get(0).contentWindow.location.replace(currentURI);
        }

    });

    // 是否在首页，某些情况需要区分登陆页和首页
    if ($('.wdmin-main').length > 0) {
        $('.navItem:eq(' + defaultCard + ')').addClass('hover').click();
        // 在首页 自动确认订单
        $.get('?/Order/confirmExpress/rec=1');
    }

    // 第一级iframeonload清除loading动画
    $('#right_iframe').on('load', function () {
        $('#iframe_loading').fadeOut();
    });

    // resize
    window.onresize = __resize__;
    __resize__();
});

/**
 * window resizing lis
 * @returns {undefined}
 */
function __resize__() {
    stdHeight = document.documentElement.clientHeight;
    $('#rightWrapper').css('height', stdHeight - tHeight + 'px');
    $('#leftNav,#main-mid').css('height', stdHeight - tHeight + 'px');
    $('#right_iframe').css('height', stdHeight - tHeight + 'px');
    $('#iframe_loading').find('img').css({
        display: 'block',
        width: imgsize,
        marginLeft: ($('#main-mid').width() - imgsize) / 2,
        marginTop: ($('#main-mid').height() - imgsize) / 2,
        '-webkit-animation-name': 'rotate',
        '-webkit-animation-duration': '1.1s',
        '-webkit-animation-iteration-count': 'infinite',
        '-webkit-animation-timing-function': 'linear'
    });
}

/**
 * 刷新iframe页面
 * @returns {undefined}
 */
function reloadPage() {
    $('#iframe_loading').show();
    $('#right_iframe').get(0).contentWindow.location.replace(currentURI + ($('#right_iframe').attr('src').indexOf("?") !== -1 ? "/?" : "&") + (new Date()).getTime());
}

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
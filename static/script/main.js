
var suload = false;
var storage = window.localStorage;
var shoproot = location.pathname.substr(0, location.pathname.lastIndexOf('/') + 1);
var isSupportTouch = "ontouchend" in document ? true : false;
var plistShowType = 'hoz';
var priceHashId = 0;

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

$(function() {
    // window resize listener
    $(window).bind('resize', function() {
        $('.nav-round').each(function() {
            $(this).height($(this).width());
        });
        $('.sliderTip').each(function() {
            $(this).css('left', ($(this).parent().width() - this.clientWidth) / 2);
        });
    }).resize();
    
    if ($('#slider').length > 0 && $('.slider').length > 1) {
        // slider
        window.currentTab = 0;
        $('#slider').bind({
            'touchstart mousedown': function(event) {
                // touch start
                // event.preventDefault();
                if (event.originalEvent.touches)
                    event = event.originalEvent.touches[0];
                window.touchStartX = event.clientX;
                window.touchStartY = event.clientY;
                window.touchStartOffsetX = parseInt($('.slider').eq(0).css('marginLeft'));
                window.touchEndOffsetX = 0;
                window.touchTabLength = $('.slider').length - 1;
            },
            'touchmove mousemove': function(event) {
                // touch move
                if (window.touchStartX && window.touchStartY) {
                    event.preventDefault();
                    if (event.originalEvent.touches)
                        event = event.originalEvent.touches[0];
                    touchX = event.clientX;
                    touchY = event.clientY;
                    touchEndOffsetX = touchStartOffsetX - (touchStartX - touchX);
                    // movement
                    $('.slider').eq(0).css('marginLeft', touchEndOffsetX + 'px');
                }
            },
            'touchend touchcancel mouseup': function(event) {
                // event.preventDefault();
                if (Math.abs(touchX - touchStartX) < 10) {
                    // 横向太低
                    goSlider(0);
                } else {
                    var right = (touchX - touchStartX) > 0;
                    goSlider(right);
                }
                // gc
                touchStartY = null;
                touchStartX = null;
            }
        });
    }

    var touchStarget = null;

    // 链接点击效果
    $('[data-swclass]').each(function(index, node) {
        var swclass = $(node).attr('data-swclass');
        var link = $(node).attr('data-link');
        $(node).bind({
            'touchstart mousedown': function(event) {
                if (event.originalEvent.touches)
                    event = event.originalEvent.touches[0];
                $(node).addClass(swclass);
                touchStarget = event.target;
            },
            'touchend mouseup': function(event) {
                $(node).removeClass(swclass);
                if (event.originalEvent.touches)
                    event = event.originalEvent.touches[0];
                if (event.target === touchStarget) {
                    if (link) {
                        if (/javascript/.test(link)) {
                            link = link.replace('javascript:', '');
                            eval(link);
                        } else {
                            location.href = link;
                        }
                    }
                }
                event.preventDefault();
            }
        });
    });

    // 搜索栏聚焦清空
    $('.search-w-input').on('focus', function() {
        $(this).val('');
    });

    // 数量选择按钮
    $('.productCountMinus').bind({
        'touchend touchcancel mouseup': function(event) {
            event.preventDefault();
            var node = $(this).parent().find('.productCountNumi');
            node.val(parseInt(node.val()) === 1 ? 1 : node.val() - 1);
        }
    });

    $('.productCountPlus').bind({
        'touchend touchcancel mouseup': function(event) {
            event.preventDefault();
            var node = $(this).parent().find('.productCountNumi');
            node.val(parseInt(node.val()) + 1);
        }
    });

    $('#plistDp').click(function() {
        if (plistShowType === 'hoz') {
            plistShowType = '';
        } else {
            plistShowType = 'hoz';
        }
        $('.productListWrap').toggleClass('hoz');
        $('.serialCaption').toggleClass('hoz');
        $(this).toggleClass('h');
        $('.productList .photo').each(function() {
            $(this).height($(this).width());
            $(this).parent().toggleClass('clearfix');
        });
        $('.productList .title').each(function() {
            $(this).toggleClass('Elipsis');
        });
    });

    fnTouchEndRedirect('a');
});

// resizer
function resize() {
    $('.nav-round').each(function() {
        $(this).height($(this).width());
    });
    $('.sliderTip').each(function() {
        $(this).css('left', ($(this).parent().width() - this.clientWidth) / 2);
    });
    var w = $('.productIW').width();
    $('.productIW').height(w);
}

// slider transmate
function goSlider(Right) {
    Right = Right === 0 ? 0 : (Right === true ? -1 : 1);
    currentTab += Right;
    currentTab = currentTab < 0 ? 0 : currentTab > touchTabLength ? touchTabLength : currentTab;
    var sliderWidth = $('.slider').eq(0).width();
    var finalOffsetX = -currentTab * sliderWidth;
    $('.slider').eq(0).animate({'marginLeft': finalOffsetX + 'px'});
    $('.sliderTipItems.current').removeClass('current');
    $('.sliderTipItems').eq(currentTab).addClass('current');
}

Object.onew = function(o) {
    var F = function(o) {
    };
    F.prototype = o;
    return new F;
};

// processing animation block
var Processing = Object.onew({
    start: function() {
        var node = $("<div class='processing'></div>");
        node.css({top: (($(body).height() - node.height()) / 2), left: (($(body).width() - node.width()) / 2)});
        $('body').append("<div class='processing'></div>");
    },
    finish: function() {
        $('.processing').remove();
    }
});

/**
 * loading animate
 * @type @exp;Object@call;onew
 */
var Loading = Object.onew({
    start: function(id, noheight) {
        if (!noheight) {
            if ($(id).attr('data-minheight')) {
                $(id).css('min-height', $(id).attr('data-minheight'));
            } else {
                $(id).css('min-height', '150px');
            }
        }
        Spinner.spin($(id).get(0));
    },
    finish: function(id, noheight) {
        if (!noheight) {
            $(id).css('min-height', '0');
        }
        Spinner.spin().stop();
    }
});

var Tiping = Object.onew({
    flas: function(content) {
        var width = 120;
        var height = 110;
        var node = $("<div class='_Tiping'>" + content + "</div>");
        $('body').append(node);
        node.css({
            left: ($(window).width() - width) / 2,
            top: ($(window).height() - height) / 2,
            width: width,
            height: height,
            lineHeight: height + 60 + 'px'
        });
        $('._Tiping').fadeOut(3000, function() {
            $('._Tiping').remove();
        });
    }
});

// 购物车对象
var Cart = Object.onew({
    cart: {},
    init: function() {
        var _d = storage.getItem('cart');
        if (_d) {
            this.cart = eval('(' + storage.getItem('cart') + ')');
        } else {
            this.cart = {};
        }
    },
    add: function(productId, count, priceHashId) {
        eval("var ext = this.cart.p" + productId + "m" + priceHashId);
        var cmd = ext ? ' +=' : ' =';
        eval("this.cart.p" + productId + "m" + priceHashId + cmd + count);
        this.save();
    },
    del: function(productId, priceHashId) {
        eval("delete this.cart.p" + productId + "m" + priceHashId);
        this.save();
    },
    clear: function() {
        this.cart = {};
        storage.setItem('cart', '{}');
        storage.removeItem('tmporder');
        storage.removeItem('carthash');
    },
    save: function() {
        storage.setItem('cart', $.toJSON(this.cart));
    },
    set: function(mhash, count) {
        eval("this.cart." + mhash + "=" + count);
        this.save();
    }
});

Cart.init();
/**
 * 订单操作对象
 * @type @exp;Object@call;onew
 */
var Orders = Object.onew({
    /**
     * 确认收货
     * @returns {boolean}
     */
    confirmExpress: function(orderId) {
        orderId = parseInt(orderId);
        if (orderId > 0) {
            if (confirm('你确认收到货品了吗?')) {
                $.post('?/Order/confirmExpress', {orderId: orderId}, function(res) {
                    res = parseInt(res);
                    if (res > 0) {
                        $('#orderitem' + orderId).slideUp();
                        if ($('#expresscode')) {
                            window.location.reload();
                        }
                    } else {
                        alert('确认收货失败！');
                        bugNotify('确认收货失败！');
                    }
                });
            }
        }
    },
    /**
     * 取消订单
     * @returns {boolean}
     */
    cancelOrder: function(orderId, node) {
        orderId = parseInt(orderId);
        if (orderId > 0) {
            if (confirm('你确认要取消订单吗?')) {
                $.post('?/Order/cancelOrder', {
                    orderId: orderId
                }, function(res) {
                    if (res === "1") {
                        $(node).parent().parent().slideUp();
                    } else {
                        alert('订单取消失败！');
                        bugNotify(orderId + '订单取消失败！服务器返回' + res);
                    }
                });
            }
        }
    },
    /**
     * 微信支付
     * @returns {undefined}
     */
    wepay: function(orderId) {
        orderId = parseInt(orderId);
        if (orderId > 0) {

        }
    },
    /**
     * 
     * @param {type} 评价
     * @returns {undefined}
     */
    comment: function(orderId) {
        orderId = parseInt(orderId);
        if (orderId > 0) {

        }
    }
});

/**
 * 关注公众号提示
 * @returns {undefined}
 */
function addContact() {

}

// Ajax load product list 
function loadProductList(page) {
    if (!loadingLock) {
        // params
        var searchKey = $('#searchBox').val();
        // request uri
        var _url = '?/vProduct/ajaxProductList/page=' + parseInt(page)
                + '&searchKey=' + encodeURI(searchKey)
                + '&cat=' + $('#cat').val()
                + '&orderby=' + $('#orderby').val()
                + '&stype=' + plistShowType
                + '&serial=' + $('#serial').val()
                + '&level=' + $('#level').val();
        listLoading = true;
        $('.emptyTip').html('');
        $('#buttomLoading').show();
        $.get(_url, function(HTML) {
            $('#buttomLoading').hide();
            if (HTML === '0' && searchKey === '') {
                /**
                 * 没有数据
                 * <div class="emptyTip">暂无数据</div>
                 */
                if (!suload) {
                    $("#product_list").removeClass('clearfix').append('<div class="emptyTip">暂无数据</div>');
                } else {
                    // not
                }
                loadingLock = true;
            } else if (HTML !== '0') {
                suload = true;
                HTML = $(HTML);
                var patch = $('.patch', HTML);
                patch.parent().addClass('rm');
                $('#product_list .pdBlock').last().append(patch);
                $("#product_list").append(HTML);
                $('.rm').remove();
                $('.productIW').height($('.productIW').width());
                $('.productList .photo').each(function() {
                    $(this).height($(this).width());
                });
            }
            listLoading = false;
            searchKey = null;
            _url = null;
        });
    }
}

/**
 * log var
 * @param {type} va
 * @returns {undefined}
 */
function debug(va) {
    console.log(va);
}

function hGoback() {
    if (window.history.length > 0) {
        window.history.go(-1);
    } else {
        window.href = shoproot;
    }
}

function hGohome() {
    window.location.href = shoproot;
}

function catListOnload() {

    $('.footer').hide();
    serial_id = $('#serial_id').val();
    cat = $('#cat').val() > 0 ? $("#cat").val() : $('.viewCatTopItem').eq(0).attr('data-catid');

    fnTouchEnd('.viewCatTopItem', function(event) {
        if (cat !== $(this).attr('data-catid')) {
            cat = $(this).attr('data-catid');
            fnLoadCatlist(cat, serial_id);
            $('.viewCatTopItem.hover').removeClass('hover');
            $(this).addClass('hover');
            event.stopPropagation();
        }
    });

    // 默认load第一个分类的列表
    $('.viewCatTopItem[data-catid="' + cat + '"]').eq(0).addClass('hover');
    fnLoadCatlist(cat, serial_id);


    // 调整圆图标宽高
    $('.subcat_item').each(function() {
        $(this).css({
            'height': $(this).width() + 25 + 'px'
        });
    });

    function fnLoadCatlist(cat) {
        $('#viewCatRight').append('<div id="whiteWrap"></div>');
        $('#whiteWrap').height($(window).height() - 110);
        Loading.start('#whiteWrap', true);
        $('#viewCatRight').load(shoproot + '?/vProduct/ajaxCatList/id=' + cat + '&serial_id=' + serial_id,
                function() {
                    // 调整圆图标宽高
                    $('.subcat_item img').each(function() {
                        $(this).css({
                            'height': $(this).width() + 'px'
                        });
                    });
                });
    }

    function resize() {
        // 调整高度
        $('#viewCatLeft').height($('#viewCat').height());
        $('#viewCatRight').height($(window).height() - 110);
    }
    resize();
}

/**
 * 简化touchend事件监听
 * @param {type} query
 * @param {type} callback
 * @returns {undefined}
 */
function fnTouchEnd(query, callback) {
    $(query).bind('touchend mouseup', callback);
}

/**
 * 点击跳转
 * @param {type} node
 * @returns {undefined}
 */
function fnTouchEndRedirect(node) {
    $(node).bind('touchstart mousedown', function(event) {
        $(this).addClass('hover');
        if (event.originalEvent.touches)
            event = event.originalEvent.touches[0];
        window.touchpoint = event.target;
    });
    $(node).bind('touchend mouseup', function(event) {
        $(this).removeClass('hover');
        if (event.originalEvent.touches)
            event = event.originalEvent.touches[0];
        if (event !== undefined) {
            if (event.target === window.touchpoint) {
                if ($(this).attr('data-href')) {
                    location.href = $(this).attr('data-href');
                    $(this).attr('data-href', '');
                }
            }
        }
    });
}

function isLogin() {
    return $.cookie('uid') && $.cookie('uctoken');
}

function UcloginLoad() {
    $('#login-btn').click(function() {
        if ($('#acc').val() !== '' && $('#acc').val() !== '') {
            $.post(shoproot + '?/Uc/AjaxLogin', {
                account: $('#acc').val(),
                password: $('#pwd').val()
            }, function(r) {
                if (r === '1') {
                    if ($('#referer').val() !== '' && $('#referer').val() !== location.href) {
                        location.href = $('#referer').val();
                    } else {
                        location.href = shoproot + '?/Uc/home/';
                    }
                } else {
                    alert('登陆失败');
                }
            });
        }
    });
}

function UcRegLoad() {
    $('#reg-btn').click(function() {
        if ($('#login-wrap').validate({
            errorPlacement: function(error, element) {
                element.focus();
                $('.login-tip').html('请输入' + element.attr('placeholder'));
            }}).form()) {
            var data = $('#login-wrap').serializeArray();
            $.post(shoproot + '?/Uc/AjaxReg', {
                data: data,
                openid: $('#openid').val()
            }, function(r) {
                switch (r) {
                    case '1' :
                        alert('注册成功');
                        if ($('#referer').val() !== '') {
                            location.href = $('#referer').val();
                        } else {
                            location.href = shoproot + '?/Uc/home/';
                        }
                        break;
                    case '2' :
                        alert('该手机号已存在');
                        break;
                    case '3' :
                        alert('该用户名已存在');
                        break;
                    case '4' :
                        alert('该邮箱已存在');
                        break;
                    case '0' :
                        alert('注册失败');
                        break;
                }
            });
        }
    });
}

function edtAddOnload() {
    $('#addr-add-btn1').click(function() {
        $('#addr-add').show();
        $('#addr-select').hide();
    });
    $('#addr-add-btn-back').click(function() {
        $('#addr-add').hide();
        $('#addr-select').show();
    });
    $('#addr-add-btn').click(address_save);
}

function address_item_click() {
    $('#wrp-btn').remove();
    $('#express-name').html($(this).attr('data-name'));
    $('#express-person-phone').html($(this).attr('data-tel'));
    $('#express-address').html($(this).attr('data-address'));
    expressData.userName = $(this).attr('data-name');
    expressData.telNumber = $(this).attr('data-tel');
    expressData.addressPostalCode = '';
    expressData.Address = $(this).attr('data-address');
    addressloaded = true;
    $('#addrPick').fadeOut();
}

function address_save() {
    if ($('#dt-name').val() !== '' && $('#dt-address').val() !== '' && $('#dt-tel').val() !== '') {
        $.post(shoproot + '?/Uc/ajaxAddAddress/', {
            name: $('#dt-name').val(),
            addr: $('#dt-address').val(),
            tel: $('#dt-tel').val()
        }, function(r) {
            if (parseInt(r) > 0) {
                $('#addr-add').hide();
                $('#addr-select').show();
                $('#addr-select').prepend('<div class="addrw" data-id="' + r + '" data-name="' + $('#dt-name').val() + '" data-tel="' + $('#dt-tel').val() + '" data-address="' + $('#dt-address').val() + '"><div class="cot clearfix"><span class="l">' + $('#dt-name').val() + '</span><span class="r">' + $('#dt-tel').val() + '</span></div><div class="add">' + $('#dt-address').val() + '</div></div>');
                $('.addrw').unbind('click').click(address_item_click);
            } else {
                alert('添加失败');
            }
        });
    }
}

function ComRegLoad() {
    $('#reg-btn').click(function() {
        var node = this;
        if ($('#login-wrap').validate({
            errorPlacement: function(error, element) {
                element.focus();
                alert('请输入' + element.attr('placeholder'));
            }}).form()) {
            var name = $('#set-form-name').val();
            var phone = $('#set-form-phone').val();
            var ids = $('#set-form-id').val();
            var email = $('#set-form-email').val();
            if (name !== '' && phone !== '' && ids !== '') {
                node.innerHTML = '提交中';
                $.post(shoproot + '?/Company/addCompany/', {
                    name: name,
                    phone: phone,
                    email: email,
                    ids: ids,
                    openid: $('#openid').val()
                }, function(r) {
                    if (parseInt(r) === 1) {
                        alert('您的申请已提交，请耐心等待系统审核。');
                        location.href = shoproot + '?/Uc/home/';
                    } else {
                        node.innerHTML = '提交申请';
                        alert('提交失败');
                    }
                });
            }
        }
    });
}
//代理资料修改页面
function ComInfoEdit() {
    $('#edit-btn').click(function() {
        var node = this;
        if ($('#login-wrap').validate({
            errorPlacement: function(error, element) {
                element.focus();
                $('.login-tip').html('请输入' + element.attr('placeholder'));
            }}).form()) {
            var name = $('#set-form-name').val();
            var phone = $('#set-form-phone').val();
            var ids = $('#set-form-id').val();
            var email = $('#set-form-email').val();
            var bname = $('#set-form-bankname').val();
            var bacc = $('#set-form-bankacc').val();
            var aliacc = $('#set-form-aliacc').val();
            if (name !== '' && phone !== '' && ids !== '') {
                node.innerHTML = '提交中';
                $.post(shoproot + '?/Company/companyInfoEdit/', {
                    name: name,
                    phone: phone,
                    email: email,
                    ids: ids,
                    openid: $('#openid').val(),
                    bname: bname,
                    bacc: bacc,
                    aliacc: aliacc
                }, function(r) {
                    if (parseInt(r) === 1) {
                        alert('修改成功~');
                        location.href = shoproot + '?/Uc/home/';
                    } else {
                        node.innerHTML = '修改资料';
                        alert('提交失败');
                    }
                });
            }
        }
    });
}

function UcLikeLoad() {
    loadingLock = false;
    // 初始化加载列表
    if ($('#likes_list').length > 0) {
        window.pdPageNo = 0;
        window.listLoading = false;
        // init list
        loadLikeList(pdPageNo);
        // onscroll bottom
        $(window).scroll(function() {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()) + 150;
            if ($(document).height() <= totalheight && !listLoading) {
                //加载数据
                loadLikeList(++pdPageNo);
            }
        });
    }
}

// Ajax load product list 
function loadLikeList(page) {
    if (!loadingLock) {
        // request uri
        var _url = '?/Uc/ajaxLikeList/page=' + parseInt(page);
        listLoading = true;
        $('.emptyTip').html('');
        $('#Loading').show();
        $.get(_url, function(HTML) {
            $('#Loading').hide();
            if (HTML === '0') {
                /**
                 * 没有数据
                 * <div class="emptyTip">暂无数据</div>
                 */
                if (!suload) {
                    $("#loadLikeList").removeClass('clearfix').append('<div class="emptyTip">暂无数据</div>');
                } else {
                    // not
                }
                loadingLock = true;
            } else if (HTML !== '0') {
                suload = true;
                $("#likes_list").append(HTML);
                $('.productIW').height($('.productIW').width());
                $('.productList .photo').each(function() {
                    $(this).height($(this).width());
                });
            }
            listLoading = false;
            searchKey = null;
            _url = null;
        });
    }
}
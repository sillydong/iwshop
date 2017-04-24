/* global wx, shoproot, parseFloat */

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

var priceHashId = 0;
var priceHashStock = 0;

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner', 'Cart', 'Tiping', 'touchSlider'], function (util, $, Spinner, Cart, Tiping, touchSlider) {

        // 预加载小图标
        var i = new Image();
        i.src = 'static/images/icon/iconfont-iconfontroundcheck-50x.png';
        i.src = 'static/images/icon/iconfont-iconfontroundcheck-100x.png';

        /**
         * 商品介绍是否已经加载标记
         * @type Boolean
         */
        var contentLoaded = false;

        /**
         * 商品编号
         * @type type
         */
        var productId = parseInt($('#iproductId').val());

        (function () {
            /**
             * touchslider resizer
             */
            $('.touchslider-viewport').css({
                height: $(window).width(),
                overflow: 'hidden'
            });
            $('.touchslider-nav-item').eq(0).addClass('touchslider-nav-item-current');
            // 设置正方形宽高
            $('.touchslider-item img').width($(window).width()).height($(window).width());
            $(".touchslider").touchSlider({
                autoplay: true
            });
        })();


        (function () {
            /**
             * 微信图片预览接口
             */
            var imageList = [];

            $('.touchslider-item img').each(function () {
                imageList.push($(this).attr('src'));
            });

            $('.touchslider-viewport').on('click', function () {
                wx.previewImage({
                    current: '', // 当前显示的图片链接
                    urls: imageList // 需要预览的图片链接列表
                });
            });
        })();

        /**
         * 添加至购物车
         * @param {type} redirect
         * @param {int} prom
         * @returns {undefined}
         */
        function addToCart(redirect, prom) {
            var productId = parseInt($('#iproductId').val());
            //if (parseInt(prom) === 1 && redirect) {
            //    location = 'wxpay.php?id=p' + productId + 'm' + priceHashId;
            //} else {
                if (priceHashId > 0 && priceHashStock <= 0) {
                    Tiping.flas('库存不足，不能购买');
                } else {
                    Cart.add(productId, priceHashId, 1);
                    refreshCartCount();
                    Tiping.flas('已加入购物车');
                    if (redirect) {
                        location = 'wxpay.php';
                    }
                }
            //}
        }

        $('#pd-dsc1 .pd-spec-sx').click(fnDscTouch);

        $('#pd-dsc2 .pd-spec-sx').click(fnDscTouch2);

        /**
         * 商品价格表点击
         * @returns {undefined}
         */
        function fnDscTouch() {
            var node = $(this);
            $('#pd-dsc2 .pd-spec-sx.hover').removeClass('hover');
            $('#pd-dsc2 .pd-spec-sx.enable').removeClass('enable');
            $('#pd-dsc1 .pd-spec-sx.hover').removeClass('hover');
            // global
            detId = node.attr('data-det-id');
            var Havs = fnGetHav(detId);
            node.addClass('hover');
            if ($('#pd-dsc2').length === 0) {
                // 一维价格表
                showPriceHash(detId, 0);
            } else {
                // 二维价格表
                $.each(Havs, function (i, value) {
                    $('#pd-dsc2 .pd-spec-sx[data-det-id=' + value + ']').addClass('enable');
                });
                $('#pd-dsc2 .pd-spec-sx.enable').eq(0).click();
            }
        }

        // 初始化点击
        if ($('#pd-dsc1').length > 0) {
            $('#pd-dsc1 .pd-spec-sx').eq(0).click();
        }

        /**
         * 商品价格表点击
         * @returns {undefined}
         */
        function fnDscTouch2() {
            var node = $(this);
            if (node.hasClass('enable')) {
                $('#pd-dsc2 .pd-spec-sx.hover').removeClass('hover');
                node.addClass('hover');
                showPriceHash(detId, node.attr('data-det-id'));
            }
        }

        /**
         * 显示价格映射
         * @param {type} detId1
         * @param {type} detId2
         * @returns {undefined}
         */
        function showPriceHash(detId1, detId2) {
            var priceHash = $('.spec-hashs[value=' + detId1 + '-' + detId2 + ']');
            var stock = +priceHash.data('stock');
            if (stock > 0) {
                // 显示库存
                $('#product_stock_wrap')
                    .removeClass('hidden')
                    .find('#pd-stock')
                    .html(stock + '件');
                // 显示按钮
                $('.button').removeClass('disable');
            } else {
                // 隐藏按钮
                $('.button').addClass('disable');
                $('#product_stock_wrap').addClass('hidden');
            }
            // 最终价
            $('#pd-sale-price').html('&yen;' + parseFloat(priceHash.data('price')).toFixed(2));
            // 市场价
            if (priceHash.data('market-price') > 0) {
                $('#pd-market-price').html('&yen;' + parseFloat(priceHash.data('market-price')).toFixed(2));
            } else {
                $('#pd-market-price').html('&yen;' + parseFloat($('#mprice').val()).toFixed(2));
            }
            // 价格表id
            priceHashId = parseInt(priceHash.attr('data-id'));
            priceHashStock = stock;
            priceHash = null;
        }

        function fnGetHav(detId) {
            var r = [];
            var nH = $('.spec-hashs[value^=' + detId + '-]');
            nH.each(function () {
                r.push(parseInt($(this).val().replace(detId + '-', '')));
            });
            return r;
        }

        // 数量选择按钮
        $('.productCountMinus').bind({
            'touchend touchcancel mouseup': function (event) {
                event.preventDefault();
                var node = $(this).parent().find('.productCountNumi');
                node.val(parseInt(node.val()) === 1 ? 1 : node.val() - 1);
            }
        });

        $('.productCountPlus').bind({
            'touchend touchcancel mouseup': function (event) {
                event.preventDefault();
                var node = $(this).parent().find('.productCountNumi');
                node.val(parseInt(node.val()) + 1);
            }
        });

        $(window).scroll(function () {
            var totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()) - 5;
            if ($(window).height() <= totalheight && !contentLoaded) {
                $('#vpd-content').html('');
                Spinner.spin($('#vpd-content').get(0));
                contentLoaded = true;
                // ajax 加载商品详情
                $.ajax({
                    url: 'html/products/' + $('#iproductId').val() + '.html',
                    success: function (data) {
                        Spinner.stop();
                        $('#vpd-content').html(data);
                        $('#vpd-detail-header').show();
                        $('.notload').removeClass('notload');
                        $('#vpd-content').fadeIn();
                        // 调整图片
                        $('#vpd-content img').each(function () {
                            $(this).on('load', function () {
                                if ($(this).width() >= document.body.clientWidth) {
                                    $(this).css('display', 'block');
                                }
                                $(this).height('auto');
                            });
                        });
                        $('#vpd-content').find('div').width('auto');
                    },
                    error: function () {
                        // 如果html文件没有生成，直接读取数据库内容
                        $('#vpd-content').load('?/vProduct/ajaxGetContent/id=' + $('#iproductId').val(), function () {
                            Spinner.stop();
                            $('#vpd-detail-header').show();
                            $('.notload').removeClass('notload');
                            $('#vpd-content').fadeIn();
                            // 调整图片
                            $('#vpd-content img').each(function () {
                                $(this).on('load', function () {
                                    if ($(this).width() >= document.body.clientWidth) {
                                        $(this).css('display', 'block');
                                    }
                                    $(this).height('auto');
                                });
                            });
                            $('#vpd-content').find('div').width('auto');
                        });
                    }
                });

            }
        });

        /**
         * 加入购物车按钮
         */
        $('#buy-button,#addcart-button').click(function () {
            var node = $(this);
            if (node.hasClass('disable')) {
                return false;
            } else {
                if (node.attr('data-add') === '1') {
                    addToCart(false, node.attr('data-prom'));
                } else if (node.attr('data-add') === '0') {
                    addToCart(true, node.attr('data-prom'));
                }
            }
            node = null;
        });

        util.onresize(function () {
            $('.pd-box-inner img').each(function (i, node) {
                $(node).height($(node).width());
            });
        });

        /**
         * 更新购物车数量
         * @returns {undefined}
         */
        function refreshCartCount() {
            Cart.count(function(count){
                $('#toCart i').html(count);
            });
        }

        /**
         * 检查收藏
         */
        $.get('?/vProduct/checkLike/id=' + productId, function (r) {
            if (r.ret_code === 0) {
                $('.uc-add-like').addClass('fill');
            }
        });

        // 加入收藏按钮点击
        $('.uc-add-like').click(function () {
            var node = $(this);
            var pid = parseInt($('#iproductId').val());
            if (node.hasClass('fill')) {
                pid = (-1) * pid;
            }
            $.post('?/vProduct/ajaxAlterProductLike/', {id: pid}, function (r) {
                if (r > 0) {
                    if (!node.hasClass('fill')) {
                        Tiping.flas('收藏成功');
                    }
                    node.toggleClass('fill');
                }
            });
        });

        refreshCartCount();

    });

});
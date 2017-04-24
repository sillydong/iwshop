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

require(['config'], function(config) {

    require(['util', 'jquery', 'Spinner', 'Cart', 'Tiping'], function(util, $, Spinner, Cart, Tiping) {

        var suload = false;
        var plistShowType = 'hoz';
        var dontload = true;
        var loadingLock = false;

        // 初始化加载列表
        if ($('#product_list').length > 0 && $('#orderDetailsWrapper').length !== 1) {
            window.pdPageNo = 0;
            window.listLoading = false;
            // init list
            loadProductList(pdPageNo);
            // onscroll bottom
//            $(window).scroll(function() {
//                totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()) + 150;
//                if ($(document).height() <= totalheight && !listLoading) {
//                    //加载数据
//                    loadProductList(++pdPageNo);
//                }
//            });
        }

        // subnav
        util.fnTouchEnd('.subnav', function(node) {
            loadingLock = false;
            var orderby = node.attr('orderby');
            $('.active').removeClass('active');
            window.pdPageNo = 0;
            var priceB = node.find('b._priceB');
            node.addClass('active');
            node.find('b._priceB').toggleClass('up');
            if (priceB.length !== 0) {
                orderby += priceB.hasClass('up') ? " DESC" : " ASC";
            } else {
                orderby += " DESC";
            }
            loadProductList(0);
            $('#orderby').val(orderby);
            $('#product_list').html("");
        });

        if ($('#orderby').val() === '`sale_count`') {
        } else {
            $('.subnav').eq(0).addClass('active');
        }

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
                        + '&brand=' + $('#brand').val()
                        + '&level=' + $('#level').val()
                        + '&in=' + $('#in').val();
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
                            // 加载同级推荐列表
                            $("#product_list").removeClass('clearfix').append('<div class="emptyTip">暂无数据</div>');
                        } else {
                            // not
                            if ($('#cat').val() > 0) {
                                $('#categorySugg').load('?/vProduct/categorySugg/id=' + $('#cat').val());
                            }
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
                        $('.productList img').each(function() {
                            $(this).height($(this).width());
                        });
                        $('.subcat_item').each(function(i, node) {
                            $(node).find('img').each(function() {
                                $(this).height($(this).width());
                            });
                        });
                    }
                    listLoading = false;
                    searchKey = null;
                    _url = null;
                });
            }
        }
        
        util.searchListen();

    });
});
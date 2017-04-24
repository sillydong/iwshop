/* global shoproot, DataTableConfig */

requirejs(['jquery', 'util', 'fancyBox', 'Spinner', 'baiduTemplate', 'jqPaginator'], function ($, util, fancyBox, Spinner, baiduTemplate, jqPaginator) {
    $(function () {

        parent !== undefined && parent.iframe_hide !== undefined && parent.iframe_hide();

        var param = {page: 0, page_size: 20, key: '', product_cat: $('#cat').val()};

        var listype = +$('#listype').val();

        var listUri = listype === 0 ? '?/wProduct/ajax_product_list/' : '?/wProduct/ajax_product_list_stock/';

        var init = false;

        fnAjaxLoadPds(param.page);

        /**
         * 加载商品列表
         * @returns {undefined}
         */
        function fnAjaxLoadPds() {
            // [HttpPost]
            $.post(listUri, param, function (json) {
                if (json.ret_code === 0) {
                    var html = baidu.template('t:pd_list', {
                        list: json.ret_msg.data
                    });
                    $('.dTable tbody').empty().html(html);
                    util.dataTableLis();
                    $('.pd-switchonline').click(switchonline);
                    // 删除按钮监听
                    $('.pd-del-btn').unbind('click').click(function () {
                        var tR = $(this).parent().parent();
                        if (confirm('你确定要删除这个产品吗')) {
                            $.post('?/WdminAjax/deleteProduct/', {
                                id: parseInt($(this).attr('data-product-id'))
                            }, function (res) {
                                if (parseInt(res) > 0) {
                                    tR.fadeOut('normal');
                                    util.Alert('商品已加入回收站');
                                } else {
                                    util.Alert('删除失败', true);
                                }
                            });
                        }
                    });
                    if (!init) {
                        if (json.ret_msg.count > 0) {
                            // 初始化分页插件
                            $(".pagination-sm").jqPaginator({
                                totalPages: Math.ceil(json.ret_msg.count / param.page_size),
                                onPageChange: function (page, type) {
                                    if (init) {
                                        $('body').animate({scrollTop: '0'}, 200);
                                        param.page = page - 1;
                                        fnAjaxLoadPds();
                                    }
                                }
                            });
                        }
                    }
                    init = true;
                    util.imageError();
                }
            });
        }

        if (listype === 1) {
            $('.pd-altbtn').click(function () {
                var pdid = +$(this).attr('data-product-id');
            });
        }

        $('#refresh_static').click(function () {
            $.get('?/wProduct/generateStaticDesc/', function (r) {
                if (r.ret_code === 0) {
                    util.Alert('刷新成功');
                } else {
                    util.Alert('刷新失败，/html/products/目录不可写', true);
                }
            });
        });

        /**
         * 上下架操作
         * @returns {undefined}
         */
        function switchonline() {
            var node = $(this);
            var onLineStr = ['上架', '下架'];
            var isOnline = parseInt(node.attr('data-product-online')) === 1;
            var productId = node.attr('data-product-id');
            var pImg = $('#pdlist-image' + productId);
            pImg.parent().css({
                width: pImg.width(),
                height: pImg.width() + 10
            });
            pImg.hide();
            Spinner.spin(pImg.parent().get(0));
            // [HttpPost]
            $.post('?/wProduct/switchOnline/', {
                productId: productId,
                isOnline: isOnline ? 0 : 1
            }, function (res) {
                pImg.show();
                Spinner.stop();
                if (res > 0) {
                    util.Alert('商品已' + onLineStr[Number(isOnline)]);
                    node.attr('data-product-online', isOnline ? 0 : 1);
                    node.html(onLineStr[Number(!isOnline)]).toggleClass('tip');
                } else {
                    util.Alert('系统错误', true);
                }
            });
        }

        util.keyEnter('.searchbox', function (key) {
            param.key = key;
            util.removeEmptyTip();
            fnAjaxLoadPds();
        });

        fnFancyBox('.pd-qrcodebtn');

    });
});
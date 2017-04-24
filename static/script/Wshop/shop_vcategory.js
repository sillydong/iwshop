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

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner', 'Cart', 'Slider', 'Tiping'], function (util, $, Spinner, Cart, Slider, Tiping) {

        // 不显示底部导航
        $('.footer').show();

        // 对应系列id
        var serial_id = $('#serial_id').val();

        // 对应分类id
        var cat = $('#cat').val() !== '' && parseInt($('#cat').val()) !== 0 ? parseInt($("#cat").val()) : parseInt($('.viewCatTopItem').eq(0).attr('data-catid'));

        // 左侧按钮点击
        $('.viewCatTopItem').bind({
            'touchend touchcancel mouseup': function (event) {
                var node = $(this);
                event.preventDefault();
                if (cat !== node.attr('data-catid')) {
                    cat = node.attr('data-catid');
                    fnLoadCatlist(cat, serial_id);
                    $('.viewCatTopItem.hov').removeClass('hov');
                    node.addClass('hov');
                }
            }});

        // window resizer
        $(window).bind('resize', function () {
            // 调整高度
            $('#viewCatRight').height($(window).height() - $('.search-w-box').height() - 35);
            $('#viewCatLeft').height($(window).height() - $('.search-w-box').height() - 20);
            $('#whiteWrap').height($('#viewCatRight').height() + 35);
            // 调整圆图标宽高
            $('.subcat_item').each(function () {
                $(this).css({
                    'height': $(this).width() + 25 + 'px'
                });
            });
        }).resize();

        // 默认load第一个分类的列表
        $('.viewCatTopItem[data-catid="' + cat + '"]').eq(0).addClass('hov');
        fnLoadCatlist(cat, serial_id);

        /**
         * 左列表加载函数
         * @param {type} cat
         * @returns {undefined}
         */
        function fnLoadCatlist(cat) {
            if ($('#whiteWrap').length === 0) {
                $('#viewCatRight').append('<div id="whiteWrap"></div>');
            }
            $('#whiteWrap').height($('#viewCatRight').height() + 35);
            Spinner.spin($('#whiteWrap').get(0));
            $('#viewCatRight').load('?/vProduct/ajaxCatList/id=' + cat + '&serial_id=' + serial_id,
                    function () {
                        // 调整圆图标宽高
                        $('.subcat_item img').each(function () {
                            $(this).css({
                                'height': $(this).width() + 'px'
                            });
                        });
                        $('.subcatBrand').width(($('#viewCatRight').width() / 2) - 15);
                    });
        }

        util.searchListen();

    });
});
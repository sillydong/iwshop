/**
 * 图片slider展示
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

define(['jquery', 'Spinner'], function ($, Spinner) {

    var o = {};
    /*
     * i.sliderTipItems.current 索引下标
     * 页面加载_index = 0
     * 每次touch结束后,将当前.current索引赋值给_index
     */
    var _index = 0;
    //定时器
    var _bannerTimer = '';
    //轮播函数
    var timer = function () {
        showImg(_index);
        _index++;
        if (_index === o.touchTabLength)
            _index = 0;
    };

    /**
     * 通过transform控制图片滚动展示
     * @param {Number} index
     * @returns {undefined}
     */
    function showImg(index) {
        var bannerWidth = $('.sliderX').width();
        o.slideNode.css({
            transitionDuration: '500ms',
            transform: 'translateX(' + (-bannerWidth * index) + 'px)'
        }, 5000);
        $('.sliderTip i').removeClass('current').eq(index).addClass('current');
    }

    /**
     * 开启定时器
     * @returns {undefined}
     */
    function timerStart() {
        _bannerTimer = setInterval(timer, 5000);
    }

    /**
     * 关闭定时器
     * @returns {undefined}
     */
    function timerStop() {
        clearInterval(_bannerTimer);
    }

    o.slide = function (node) {

        $('.sliderTip').each(function () {
            $(this).css('left', ($(this).parent().width() - this.clientWidth) / 2);
        });

        // slider宽度
        o.tileWidth = $('body').width();
        // slider高度
        o.tileHeight = $('#slider').height();
        // 变化节点
        o.slideNode = $('#slideFrame');
        // 设置宽高自适应body
        o.slideNode.width(100000).height(o.tileHeight);
        // slider 图片个数
        o.touchTabLength = $('.sliderX').length;

        $('.sliderLoading').height(o.tileHeight);

        Spinner.spin($('.sliderLoading').get(0));

        // 图片加载失败自动删除，不显示白块
        $('#sliderX img').bind("error", function () {
            $(this).remove();
        });

        $('.sliderX').width(o.tileWidth);

        if ($('#slider') && o.touchTabLength >= 0) {
            $('.sliderX img').each(function () {
                $(this).css({width: o.tileWidth});
                $(this).on('load', function () {
                    $(this).css({
                        width: o.tileWidth,
                        marginTop: ((o.tileHeight - $(this).height()) / 2) + 'px'
                    });
                    $('.sliderLoading').hide();
                    Spinner.stop();
                });
                if ($(this).height() > 0) {
                    // 如果图片已经load过，是不会触发图片的load事件，所以要处理多一次
                    $(this).css({
                        marginTop: ((o.tileHeight - $(this).height()) / 2) + 'px'
                    });
                    $('.sliderLoading').hide();
                    Spinner.stop();
                }
            });

            // slider 1+多图
            o.currentTab = 0;
            o.touchX = 0;
            o.touchStartOffsetX = 0;
            o.touchStartX = false;
            o.touchStartY = false;
            if (o.touchTabLength >= 2) {
                //开启轮播定时器
                timerStart();
                // touchTabLength >= 2
                $('#slider').bind({
                    // touch开始
                    'touchstart mousedown': function (event) {
                        //关闭轮播定时器
                        timerStop();
                        o.slideNode.css({
                            transitionDuration: '0'
                        });
                        if (event.originalEvent.touches)
                            event = event.originalEvent.touches[0];
                        o.touchStartX = event.clientX;
                        o.touchStartY = event.clientY;
                        o.touchEndOffsetX = 0;
                    },
                    // touch移动
                    'touchmove mousemove': function (event) {
                        // touch move
                        if (o.touchStartX && o.touchStartY) {

                            event.preventDefault();
                            if (event.originalEvent.touches)
                                event = event.originalEvent.touches[0];
                            o.touchX = event.clientX;
                            o.touchY = event.clientY;
                            o.touchEndOffsetX = o.touchStartOffsetX - (o.touchStartX - o.touchX) * 0.9;
                            // movement
                            o.slideNode.css('transform', 'translateX(' + o.touchEndOffsetX + 'px)');
                        }
                    },
                    // touch结束
                    'touchend touchcancel mouseup': function (event) {
                        // touch end
                        if (o.touchX > 0) {
                            fnSlide(Math.abs(o.touchX - o.touchStartX) >= o.tileWidth * 0.40 ? (o.touchX - o.touchStartX) > 0 : 0);
                        }
                        o.touchStartX = false;
                        o.touchStartY = false;
                        // 阻止冒泡
                        event.stopPropagation();
                        //开启轮播定时器
                        _index = $('.sliderTip i.current').index();
                        timerStart();
                    }
                });
            }
        }

    };

    return o;

    function fnSlide(Right) {

        Right = Right === 0 ? 0 : (Right === true ? -1 : 1);
        o.currentTab += Right;
        o.currentTab = o.currentTab < 0 ? 0 : o.currentTab > (o.touchTabLength - 1) ? (o.touchTabLength - 1) : o.currentTab;
        o.touchStartOffsetX = -o.currentTab * (o.tileWidth);
        o.slideNode.css({
            transitionDuration: '200ms',
            transform: 'translateX(' + o.touchStartOffsetX + 'px)'
        });
        // o.slideNode.css('transform', 'translateX(' + o.touchStartOffsetX + 'px)');
        $('.sliderTipItems.current').removeClass('current');
        $('.sliderTipItems').eq(o.currentTab).addClass('current');
    }
});
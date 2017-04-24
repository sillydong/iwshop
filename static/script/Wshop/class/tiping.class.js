/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

define(['jquery'], function($) {
    var o = {
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
    };
    return o;
});


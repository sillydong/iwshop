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
        listen: function() {
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
        }
    };
    return o;
});


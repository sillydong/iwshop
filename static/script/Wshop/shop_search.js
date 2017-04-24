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

    require(['util', 'jquery', 'Spinner', 'Cart', 'Slider', 'Tiping'], function(util, $, Spinner, Cart, Slider, Tiping) {

        util.fnTouchEnd('#wechat-payment-btn', function() {
            searchdo($('.search-w-box')[0]);
        });

        util.fnTouchEndRedirect('a', function(link) {
            location.href = link;
        });

    });
});

/**
 * 搜索函数
 * @param {type} form
 * @returns {undefined}
 */
function searchdo(form) {
    var inp = $('input[type=search]', form);
    if (inp.val() === '')
        return;
    var target = inp.attr('targ');
    target = encodeURI(target + '&searchkey=' + inp.val());
    window.location.href = 'http://' + document.domain +
            (window.location.port ? ':' + window.location.port : '') + window.location.pathname + '?/' + target;
}
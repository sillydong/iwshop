/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

$(function () {
    $('#img-content img').height('auto');
    $('img').each(function () {
        if ($(this).attr('data-src') != '') {
            $(this).attr('src', $(this).attr('data-src'));
        }
    });
});
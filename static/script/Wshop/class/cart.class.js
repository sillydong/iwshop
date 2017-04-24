/**
 * iWshop购物车
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
define(['jquery'], function ($) {
    return {
        /**
         * 添加商品
         * @param productId
         * @param spec_id
         * @param count
         */
        add: function (productId, spec_id, count) {
            $.post(shoproot + '?/UserCart/set/', {
                product_id: productId,
                spec_id: spec_id,
                count: count
            });
        },
        /**
         * 从购物车中删除商品
         * @param productId
         * @param spec_id
         */
        del: function (productId, spec_id) {
            $.post(shoproot + '?/UserCart/del/', {
                product_id: productId,
                spec_id: spec_id,
                all: true
            });
        },
        /**
         * 获取购物车商品总数量
         * @param func
         */
        count: function (func) {
            $.get(shoproot + '?/UserCart/count/', func);
        },
        /**
         * 清空购物车
         */
        clear: function (func) {
            $.post(shoproot + '?/UserCart/clear/', {}, func);
        },
        /**
         * deprecated
         */
        save: function () {
            return true;
        },
        /**
         * 设置定值购物车数量
         * @param productId
         * @param spec_id
         * @param count
         */
        set: function (productId, spec_id, count, func) {
            $.post(shoproot + '?/UserCart/set/', {
                product_id: productId,
                spec_id: spec_id,
                count: count,
                fixed: true
            }, func);
        },
        /**
         * 获取购物车数据
         * @param func
         */
        get: function(func){
            $.post(shoproot + '?/UserCart/get/', {}, func);
        }
    };
});
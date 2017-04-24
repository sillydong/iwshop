
define(['jquery'], function ($) {

    return {
        /**
         * 删除商户
         * @param {type} id
         * @param {type} func
         * @returns {undefined}
         */
        deleteSupplier: function (id, func) {
            if (id > 0) {
                $.post('?/wSupplier/delete/', {
                    id: id
                }, func);
            } else {
                func(false);
            }
        },
        /**
         * 编辑商户
         * @param {int} id
         * @param {object} data
         * @returns {undefined}
         */
        modiSupplier: function (id, data, func) {
            $.post('?/wSupplier/modi/', {
                id: id,
                data: data
            }, func);
        },
        /**
         * 获取商户信息
         * @param {type} id
         * @param {type} func
         * @returns {undefined}
         */
        getInfo: function (id, func) {
            $.get('?/wSupplier/get/id=' + id, func);
        }
    };

    var supplier = {};

});
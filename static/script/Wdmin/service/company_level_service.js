
define(['jquery'], function ($) {

    return {
        /**
         * 编辑代理等级
         * @param {int} id
         * @param {object} data
         * @returns {undefined}
         */
        modiCompanyLevel: function (id, data, func) {
            $.post('?/wCompanyLevel/modi/', {
                id: id,
                data: data
            }, func);
        },
        /**
         * 获取代理等级信息
         * @param {type} id
         * @param {type} func
         * @returns {undefined}
         */
        getInfo: function (id, func) {
            $.get('?/wCompanyLevel/get/id=' + id, func);
        }
    };

    var companyLevel = {};

});

DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'datatables','baiduTemplate', 'jqPaginator'], function($, util, dataTables,baiduTemplate,jqPaginator) {
    $(function() {
        var dt = $('.dTable').dataTable(DataTableConfig).api();

        var param = {page: 0, page_size: 20, key: ''};
        var listUri = '?/WdminPage/ajax_orders_comment/';

        var init = false;

        fnAjaxLoadComment(param.page);

        /**
         * 加载订单评价列表
         * @returns {undefined}
         */
        function fnAjaxLoadComment() {
            // [HttpPost]
            $.post(listUri, param, function (json) {
                if (json.ret_code === 0) {
                    var html = baidu.template('t:pd_list', {
                        list: json.ret_msg.data
                    });
                    $('.dTable tbody').empty().html(html);
                    util.dataTableLis();
                    //$('.pd-switchonline').click(switchonline);

                    if (!init) {
                        $(".pagination-sm").jqPaginator({
                            totalPages: Math.ceil(json.ret_msg.count / param.page_size),
                            onPageChange: function (page, type) {
                                if (init) {
                                    $('body').animate({scrollTop: '0'}, 200);
                                    param.page = page - 1;
                                    fnAjaxLoadComment();
                                }
                            }
                        });
                    }
                    init = true;
                    util.imageError();
                }
            });
        }


    });
});
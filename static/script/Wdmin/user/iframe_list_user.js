
requirejs(['jquery', 'util', 'datatables', 'pagination', 'baiduTemplate'], function ($, util, dataTables, pagination, baiduTemplate) {

    var param = {
        gid: $('#gid').val(),
        page: 0,
        pagesize: 50
    };

    if (parent.frameOnload !== undefined) {
        parent.frameOnload();
    }

    $.get('?/wUser/getUserCount/', function (r) {
        var total = +r.ret_msg;
        //分页初始化
        $('.pagination-sm').twbsPagination({
            first: '首页',
            prev: '前页',
            next: '后页',
            last: '尾页',
            totalPages: Math.ceil(total / param.pagesize),
            visiblepages: 6,
            onPageClick: function (event, page) {
                $('body').animate({
                    scrollTop: 0
                }, 200);
                param.page = page - 1;
                fnLoadList();
            }
        });
    });

    /**
     * 加载列表
     * @returns {void}
     */
    function fnLoadList() {
        var params = $.param(param);
        // [HttpGet]
        $.get('?/wUser/ajax_list_customer/' + params, function (json) {
            // 处理数据
            for(var i in json){
                if(json[i].client_name === null){
                    json[i].client_name = '未知';
                }
                if(json[i].client_province === null){
                    json[i].client_province = '未知'
                    json[i].client_city = ''
                }
                if(json[i].levelname === null){
                    json[i].levelname = '未知';
                }
                if(json[i].client_head === '' || json[i].client_head === null){
                    json[i].client_head = 'static/images/login/profle_1.png';
                }
                if(/http:\/\/wx\.qlogo\.cn\//.test(json[i].client_head)){
                    json[i].client_head += '/64';
                }
            }
            var html = baidu.template('t:ct_list', {
                list: json,
                shoproot: shoproot
            });
            $('.dTable tbody').empty().html(html);
            util.dataTableLis();
        });
    }

    fnLoadList();

});

var iframe_hide;

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'ztree', 'ztree_loader', 'Spinner'], function ($, util, fancyBox, dataTables, ztree, treeLoader, Spinner) {

    util.loadProductStatNums();

    iframe_hide = function () {
        Spinner.stop();
        $('#iframe_loading').fadeOut();
    };

    // 加载完毕隐藏loading
    $('#iframe_listproduct').on('load', iframe_hide);

    $('body').css('overflow', 'hidden');

    // 目录树点击回调函数
    treeLoader.setting.callback.onClick = function (event, treeId, treeNode) {
        $('#iframe_loading').show();
        Spinner.spin($('#iframe_loading').get(0));
        $('#iframe_listproduct').attr('src', '?/WdminPage/list_product_instock_in/cat=' + treeNode.dataId);
    };

    // 初始化目录树
    treeLoader.init('#_ztree', '?/wProduct/ajaxGetCategroys/r=' + (new Date()).getTime(), function () {
        $('.fix_bottom').show();
    });

    util.onresize(function () {
        $('#categroys').css('height', $(window).height());
        $('#iframe_listproduct').css('height', $(window).height());
    });

});
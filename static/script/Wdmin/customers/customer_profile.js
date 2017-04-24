
DataTableConfig.order = [[0, 'desc']];

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function($, util, fancyBox, dataTables, Spinner) {

    // 加载完毕隐藏loading
    window.frameOnload = function() {
        window.setTimeout(function() {
            Spinner.stop();
            $('#iframe_loading').fadeOut();
        }, 500);
    };
    
    Spinner.spin($('#iframe_loading').get(0));

    util.onresize(function() {
        $('#us-profile-left').height($(window).height() - 43);
        $('#iframe_customer_orders').height($(window).height());
    });
});
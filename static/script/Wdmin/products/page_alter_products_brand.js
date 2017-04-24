/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */


requirejs(['jquery', 'util', 'fancyBox', 'ztree', 'ztree_loader'], function($, util, fancyBox, ztree, treeLoader) {
    $(function() {
        // full height
        window.treeLoader = treeLoader;
        $('body').css('overflow', 'hidden');

        // 监听iframe onload事件，关闭loading动画层
        $('#iframe_altercat').on('load', function() {
            window.setTimeout(function() {
                $('#iframe_loading').fadeOut();
            }, 500);
        });

        // 目录树点击回调函数
        treeLoader.setting.callback.onClick = function(event, treeId, treeNode) {
            // 启动loading
            $('#iframe_loading').show();
            $('#iframe_altercat').attr('src', '?/WdminPage/alter_brand/id=' + treeNode.dataId);
        };

        // 初始化目录树
        treeLoader.init('#_ztree', '?/wBrands/gets/r=' + (new Date()).getTime(), function() {
            $('.fix_bottom').show();
        });

        fnFancyBox('#add_category_btn', function() {
            $('#brand_name').focus();
            // [HttpPost]
            $('#add_cate_btn').click(function() {
                var brand_name = $('#brand_name').val();
                var brand_cat = parseInt($('#pd-cat-select').val());
                if (brand_name !== '') {
                    $.post('?/Brands/create/', {
                        brand_name: brand_name,
                        brand_cat: brand_cat
                    }, function(r) {
                        if (parseInt(r) > 0) {
                            // 如果选择的是根节点，nParent不为null
                            treeLoader.zTreeObj.addNodes(null, {
                                name: brand_name,
                                dataId: parseInt(r)
                            });
                            $.fancybox.close();
                        } else {
                            util.Alert('品牌添加失败！系统错误', true);
                        }
                    });
                } else {
                    util.Alert('请输入品牌名称', true);
                }
            });
        });
    });

    util.onresize(function() {
        $('#categroys').css('height', $(window).height() - 43);
        $('#iframe_altercat').css('height', $(window).height());
    });
});

function fnDelSelectCat() {
    var node = treeLoader.zTreeObj.getSelectedNodes();
    treeLoader.zTreeObj.removeNode(node[0]);
}

/**
 * 重新加载左侧分类树
 * @todo 重新加载之后刷新选中
 * @returns {undefined}
 */
function fnReloadTree() {
    treeLoader.zTreeObj.destroy();
    treeLoader.init('#_ztree', '?/Brands/gets/r=' + (new Date()).getTime(), function() {
        $('.fix_bottom').show();
    });
}
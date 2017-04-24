requirejs(['jquery', 'util', 'fancyBox', 'ztree_loader', 'Spinner'], function ($, util, fancyBox, treeLoader, Spinner) {

    // full height
    window.treeLoader = treeLoader;
    $('body').css('overflow', 'hidden');

    // 监听iframe onload事件，关闭loading动画层
    $('#iframe_altercat').on('load', function () {
        $('#iframe_loading').fadeOut();
    });

    // 目录树点击回调函数
    treeLoader.setting.callback.onClick = function (event, treeId, treeNode) {
        if (treeNode.dataId > 0) {
            $('#iframe_loading').show();
            Spinner.spin($('#iframe_loading').get(0));
            $('#iframe_altercat').attr('src', '?/WdminPage/alter_category/id=' + treeNode.dataId);
        }
    };

    // 初始化目录树
    treeLoader.init('#_ztree', '?/wProduct/ajaxGetCategroys/r=' + (new Date()).getTime(), function () {
        $('.fix_bottom').show();
    });

    fnFancyBox('#add_category_btn', function () {
        $('#cat_name_f').focus();
        var snode = treeLoader.zTreeObj.getSelectedNodes();
        // 自动选中父级
        if (snode[0] !== undefined && snode[0].dataId > 0) {
            var n = $("#pd-cat-select").find("option[value='" + snode[0].dataId + "']");
            if (n.length > 0)
                n.get(0).selected = true;
        }
        // [HttpPost]
        $('#add_cate_btn').click(function () {
            var catname = $('#cat_name_f').val();
            var pid = parseInt($('#pd-cat-select').val());
            if (catname !== '') {
                $.post('?/wProduct/ajaxAddCategroy/', {
                    catname: catname,
                    pid: pid
                }, function (r) {
                    if (parseInt(r) > 0) {
                        // 如果选择的是根节点，nParent不为null
                        var nParent = pid > 0 ? snode[0] : null;
                        treeLoader.zTreeObj.addNodes(nParent, {
                            name: catname + '(0)',
                            dataId: parseInt(r)
                        });
                        $.fancybox.close();
                    } else {
                        util.Alert('分类添加失败！系统错误', true);
                    }
                });
            } else {
                util.Alert('请输入分类名称', true);
            }
        });
    });

    util.onresize(function () {
        $('#categroys').css('height', $(window).height() - 60);
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
    treeLoader.init('#_ztree', '?/vProduct/ajaxGetCategroys/r=' + (new Date()).getTime(), function () {
        $('.fix_bottom').show();
    });
}
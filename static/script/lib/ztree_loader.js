
define(['jquery', 'ztree'], function ($, ztree) {

    var treeLoader = {};

    treeLoader.zTreeObj = null;

    treeLoader.setting = {
        view: {
            showLine: true,
            nameIsHTML: true
        },
        callback: {
            // treeNode点击事件
            onClick: function (event, treeId, treeNode) {
                console.log(1);
            }
        }
    };

    treeLoader.onclick = function (func) {
        treeLoader.setting.callback.onClick = func;
    };

    treeLoader.init = function (_TreeDiv, requestURI, _callback) {
        $.get(requestURI, function (zNodes) {
            zNodes = eval("(" + zNodes + ")");
            treeLoader.zTreeObj = $.fn.zTree.init($(_TreeDiv), treeLoader.setting, zNodes);
            var nodes = treeLoader.zTreeObj.getNodes();
            if (nodes.length > 0) {
                treeLoader.zTreeObj.selectNode(nodes[0]);
                treeLoader.setting.callback.onClick(null, null, nodes[0]);
            }
            if (typeof _callback !== "undefined") {
                _callback();
            }
        });
    };

    return treeLoader;

});
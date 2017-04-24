{include file="../__header.tpl"}
<link rel="stylesheet" type="text/css" href="static/css/bootstrap/bootstrap.css"/>
<link href="static/css/base_pagination.css" type="text/css" rel="Stylesheet" />
<i id="scriptTag">page_iframe_list_products</i>
<input type="hidden" id="cat" value="{$cat}" />
<input type="hidden" id="listype" value="0" />
<div id="list" style="margin-bottom: 50px;">
    <div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
        <div class="search-w-box"><input type="text" class="searchbox" placeholder="输入搜索内容" /></div>
        <div class="button-set" style="margin-top: 13px;margin-right: 13px;">
            <a class="btn btn-success" href="?/WdminPage/iframe_alter_product/mod=add&catid={$cat}">添加商品</a>
            <a class="btn btn-primary" href="javascript:;" id='refresh_static'>刷新缓存</a>
            <a class="btn btn-default" href="javascript:;" onclick='location.reload()'>刷新</a>
        </div>
    </div>
    <table class="dTable">
        <thead>
            <tr>
                <th class="hidden"> </th>
                <th> </th>
                <th style="width:320px">产品名称</th>
                <th>编号</th>
                <th>单位</th>
                <th>价格</th>
                <th>浏览</th>
                <th style='width:145px;'>操作</th>
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>
</div>

<!-- 模板开始，可以使用script（type设置为text/html）来存放模板片段，并且用id标示 -->
    <script id="t:pd_list" type="text/html">
        {literal}
        <%for(var i=0;i<list.length;i++){%>
            <tr class="defTr font12">
                <td class="hidden"><%=list[i].product_id%></td>
                <td>
                    <img class="pdlist-image" height="50" width="50" src="<%=list[i].catimg%>" />
                </td>
                <td><%=list[i].product_name.substring(0,30)%></td>
                <td><%=list[i].product_code%></td>
                <td><%=list[i].product_unit%></td>
                <td class="prices font12">&yen;<%=list[i].sale_prices%></td>
                <td><%=list[i].product_readi%></td>
                <th>
                    <a class="pd-altbtn" href="?/WdminPage/iframe_alter_product/mod=edit&id=<%=list[i].product_id%>" data-product-id="<%=list[i].product_id%>">编辑</a>&nbsp;
                    <a class="pd-altbtn pd-switchonline <%if(list[i].product_online == 1){%>tip<%}%>" href="javascript:;" data-product-id="<%=list[i].product_id%>" data-product-online="<%=list[i].product_online%>"><%if(list[i].product_online == 1){%>下架<%}else{%>上架<%}%></a>&nbsp;
                    <a class="pd-altbtn pd-del-btn del" href="javascript:;" data-product-id="<%=list[i].product_id%>">删除</a>
                </th>
            </tr>
            <%}%>
        {/literal}
    </script>
    <!-- 模板结束 -->

    <div class="fix_bottom textRight fixed">
        <div id="pager-bottom"><ul style="margin-top: 7px" class="pagination-sm pagination"></ul></div>
    </div>

    {include file="../__footer.tpl"}
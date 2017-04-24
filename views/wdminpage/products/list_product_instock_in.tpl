{include file="../__header.tpl"}
<link href="/static/css/base_pagination.css" type="text/css" rel="Stylesheet" />
<i id="scriptTag">page_iframe_list_products</i>
<input type="hidden" id="cat" value="{$cat}" />
<input type="hidden" id="listype" value="1" />
<div id="list"{if !$iscom} style="margin-bottom: 50px;"{/if}>
    <div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
        <div class="search-w-box"><input type="text" class="searchbox" placeholder="输入搜索内容" /></div>
        <div class="button-set">
            <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
            <a class="button" href="?/WdminPage/iframe_alter_product/mod=add&catid={$cat}">添加商品</a>
        </div>
    </div>
    <table class="dTable">
        <thead>
            <tr>
                <th class="hidden"> </th>
                <th> </th>
                <th style="width:320px">产品名称</th>
                {if !$iscom}<th>编号</th>{/if}
                <th>库存</th>
                <th>规格</th>
                <th style='width:52px;'>操作</th>
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>
</div>

<!-- 模板1开始，可以使用script（type设置为text/html）来存放模板片段，并且用id标示 -->
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
                <td class="font12"><%=list[i].product_stock%></td>
                <td><%=list[i].spec_count%></td>
                <th>
                    <a class="pd-altbtn" href="javascript:;" data-product-id="<%=list[i].product_id%>">编辑</a>&nbsp;
                </th>
            </tr>
            <%}%>
        {/literal}
    </script>
    <!-- 模板1结束 -->

    {if !$iscom}
        <div class="fix_bottom textRight fixed">
            <div id="pager-bottom"><ul class="pagination-sm"></ul></div>
                {*        <a class="wd-btn primary" id="add_cate_product" style="width:150px" href="?/WdminPage/iframe_alter_product/mod=add&catid={$cat}">添加产品</a>*}
        </div>
    {/if}
    {include file="../__footer.tpl"} 
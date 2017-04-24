{include file='../__header.tpl'}
<link href="static/css/base_pagination.css" type="text/css" rel="Stylesheet" />
<i id="scriptTag">page_orders_comment</i>
<table class='dTable'>
    <thead>
        <tr>
            <th>姓名</th>
            <th>电话</th>
            <th>订单编号</th>
            <th>评级</th>
            <th>状态</th>
            <th>评论时间</th>
            <th style='padding-right: 10px;'>评论</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>

    </tbody>
</table>

<!-- 模板1开始，可以使用script（type设置为text/html）来存放模板片段，并且用id标示 -->
<script id="t:pd_list" type="text/html">
    {literal}
        <%for(var i=0;i<list.length;i++){%>
        <tr class="defTr font12">
            <td><%=list[i].user_name%></td>
            <td><%=list[i].tel_number%></td>
            <td><%=list[i].serial_number%></td>
            <td><%=list[i].starts%>星</td>
            <td class="text-success">未回复/已回复</td>
            <td><%=list[i].mtime%></td>
            <td style='padding-right: 10px;'><%=list[i].content%></td>
            <td><a class="text-success" data-toggle="modal" ng-show="true" data-target="#modal_order_comment" data-id="75" href="#">回复</a></td>

            <!--
            <th>
                <a class="pd-qrcodebtn fancybox.ajax" data-fancybox-type="ajax" href="?/WdminPage/product_share_qrcode/id=<%=list[i].product_id%>" data-product-id="<%=list[i].product_id%>">二维码</a>&nbsp;
                <a class="pd-altbtn" href="?/WdminPage/iframe_alter_product/mod=edit&id=<%=list[i].product_id%>" data-product-id="<%=list[i].product_id%>">编辑</a>&nbsp;
                <a class="pd-altbtn pd-switchonline <%if(list[i].product_online == 1){%>tip<%}%>" href="javascript:;" data-product-id="<%=list[i].product_id%>" data-product-online="<%=list[i].product_online%>"><%if(list[i].product_online == 1){%>下架<%}else{%>上架<%}%></a>&nbsp;
                <a class="pd-altbtn pd-del-btn del" href="javascript:;" data-product-id="<%=list[i].product_id%>">删除</a>
            </th>
            -->

        </tr>
        <%}%>
    {/literal}
</script>
<!-- 模板1结束 -->


<div class="fix_bottom textRight fixed">
    <div id="pager-bottom"><ul class="pagination-sm pagination"></ul></div>
</div>


{include file='../__footer.tpl'} 
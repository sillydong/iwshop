{include file='../__header.tpl'}
<i id="scriptTag">page_deleted_products</i>
<div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
    <div class="search-w-box"><input type="text" class="searchbox" placeholder="输入搜索内容" /></div>
    <div class="button-set" style="margin-top: 13px;margin-right: 13px;">
        <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
        <a class="button red deleteAll" href="javascript:;" data-product-id="0">全部删除</a>
        <a class="button reverseAll" href="javascript:;" data-product-id="0">全部还原</a>
    </div>
</div>
<table class="dTable">
    <thead>
        <tr>
            <th>略缩图</th>
            <th style='width:300px'>产品名称</th>
            <th>产品价格</th>
            <th>产品风格</th>
            <th>浏览次数</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=oi from=$list}
            <tr class="defTr font12">
                <td>
                    <img class='pdlist-image' src="{$oi.catimg}" />
                </td>
                <td>{$oi.product_name|truncate:35:"..."}</td>
                <td class="prices">&yen;{$oi.sale_prices}</td>
                <td>{$oi.serial_name}</td>
                <td>{$oi.product_readi}</td>
                <th>
                    <a class="pd-reversebtn" href="javascript:;" data-product-id="{$oi.product_id}">还原</a> / <a class="pd-deletebtn del" href="javascript:;" data-product-id="{$oi.product_id}">删除</a>
                </th>
            </tr>
        {/foreach}
    </tbody>
</table>
{include file='../__footer.tpl'} 

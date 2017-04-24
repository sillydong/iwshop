{include file='../__header.tpl'}
<link href="static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet" />
<i id="scriptTag">static/script/Wdmin/credit/credit_exchange.js</i>
<div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
    <div class="button-set" style="margin-right: 13px;margin-top: 13px;">
        <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
        <a class="button" data-toggle="modal" data-target="#modal_product_select" data-id="0">添加</a>
    </div>
</div>
<table class="dTable">
    <thead>
        <tr>
            <th>商品编号</th>
            <th>商品名称</th>
            <th>积分值</th>
            <th style='width:100px;'>操作</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$list item=pd}
            <tr>
                <td>{$pd.product_id}</td>
                <td>{$pd.product_name}</td>
                <td>{$pd.product_credits}</td>
                <td>
                    <a href="#" data-toggle="modal" data-target="#modal_credit_exchange_modify" data-credit="{$pd.product_credits}" data-id="{$pd.product_id}">编辑</a>
                    <a class="del" href="#" data-toggle="modal" data-target="#modal_credit_exchange_delete" data-id="{$pd.product_id}">删除</a>
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>

{include file='../modal/product/modal_product_select.html'}
{include file='../modal/credit/modal_credit_exchange_delete.html'}
{include file='../modal/credit/modal_credit_exchange_modify.html'}

{include file='../__footer.tpl'} 
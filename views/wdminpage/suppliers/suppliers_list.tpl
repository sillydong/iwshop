{include file='../__header.tpl'}
<link href="{$docroot}static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet" />
<i id="scriptTag">{$docroot}static/script/Wdmin/suppilers/suppilers_list.js</i>
<div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
    <div class="button-set" style="margin-top: 13px;margin-right: 13px;">
        <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
        <a class="button" data-toggle="modal" data-target="#modal_modi_supplier" data-id="0">添加商户</a>
    </div>
</div>
<table class="dTable">
    <thead>
        <tr>
            <th>编号</th>
            <th>商户名称</th>
            <th>商户电话</th>
            <th>供应商品</th>
            <th>营业时间</th>
            <th>起送金额</th>
            <th>配送范围</th>
            <th style='width:100px;'>操作</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$suppilers item=supp}
            <tr>
                <td>{$supp.id}</td>
                <td>{$supp.supp_name}</td>
                <td>{$supp.supp_phone}</td>
                <td>{$supp.pdcount}</td>
                <td>{$supp.supp_stime}</td>
                <td>{$supp.supp_sprice}</td>
                <td>{$supp.supp_sarea}</td>
                <td>
                    <a href="#" data-toggle="modal" data-target="#modal_modi_supplier" data-id="{$supp.id}">编辑</a>
                    <a class="del" href="#" data-toggle="modal" data-target="#modal_dele_supplier" data-id="{$supp.id}">删除</a>
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>

{include file='../modal/modal_modi_supplier.html'}
{include file='../modal/modal_dele_supplier.html'}

{include file='../__footer.tpl'} 
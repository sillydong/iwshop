{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/section.js</i>
<div id="list">
    <div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
        <div class="button-set" style="margin-top: 13px;margin-right: 13px;">
            <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
            <a class="button blue" id='add_cate_product' href="?/WdminPage/alter_section/">添加板块</a>
        </div>
    </div>
    <table class="dTable">
        <thead>
            <tr>
                <th style='width:300px'>板块名称</th>
                <th>对应商品编号</th>
                <th>排序</th>
                <th class="center">操作</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$section item=banner}
                <tr>
                    <td>{$banner.name}</td>
                    <td>{$banner.pid}</td>
                    <td>{$banner.bsort}</td>
                    <td class="center">
                        <a class="lsBtn" href="?/WdminPage/alter_section/id={$banner.id}">编辑</a>
                        <a class="lsBtn del banner_del" data-id="{$banner.id}" href="javascript:;">删除</a>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
<div class="fix_bottom" style="position: fixed">
</div>
{include file='../__footer.tpl'} 
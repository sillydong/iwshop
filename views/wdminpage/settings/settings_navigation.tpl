{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/navigation.js</i>
<div id="list">
    <div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
        <div class="button-set" style="margin-top: 13px;margin-right: 13px;">
            <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
            <a class="button blue" id='add_cate_product' href="?/WdminPage/alter_navigation/">添加导航</a>
        </div>
    </div>
    <table class="dTable">
        <thead>
            <tr>
                <th style='width:300px'>导航名称</th>
                <th>类型</th>
                <th>内容</th>
                <th>排序</th>
                <th class="center">操作</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$nav item=navitem}
                <tr>
                    <td>{$navitem.nav_name}</td>
                    <td>{if $navitem.nav_type == 1}产品分类{else}跳转网页{/if}</td>
                    <td>{$navitem.nav_content}</td>
                    <td>{$navitem.sort}</td>
                    <td class="center">
                        <a class="lsBtn" href="?/WdminPage/alter_navigation/id={$navitem.id}">编辑</a>
                        <a class="lsBtn del navigation_del" data-id="{$navitem.id}" href="javascript:;">删除</a>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
<div class="fix_bottom" style="position: fixed">
</div>
{include file='../__footer.tpl'} 
{include file='../__header.tpl'}

<i id="scriptTag">{$docroot}static/script/Wdmin/settings/list_envs.js</i>
<div id="list" style="margin-bottom: 40px;">
    <table class="dTable">
        <thead>
            <tr>
                <th style='width:300px'>红包名称</th>
                <th>满额</th>
                <th>减额</th>
                <th>商品</th>
                <th class="center">操作</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$envs item=banner}
                <tr>
                    <td>{$banner.name}</td>
                    <td>&yen;{$banner.req_amount}</td>
                    <td>&yen;{$banner.dis_amount}</td>
                    <td>{$banner.pid}</td>
                    <td class="center">
                        <a class="lsBtn" href="?/WdminPage/settings_alter_envs/id={$banner.id}">编辑</a>
                        <a class="lsBtn del envs_del" data-id="{$banner.id}" href="javascript:;">删除</a>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" style="width:150px" href="?/WdminPage/settings_alter_envs/">添加红包</a>
</div>

{include file='../__footer.tpl'} 
{include file='../__header.tpl'}

<i id="scriptTag">{$docroot}static/script/Wdmin/settings/envs_rob_list.js</i>
<div id="list" style="margin-bottom: 40px;">
    <table class="dTable">
        <thead>
            <tr>
                <th>活动名称</th>
                <th>回复关键字</th>
                <th>活动红包</th>
                <th>活动红包余量</th>
                <th>参与人数</th>
                <th class="center">操作</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$envs item=auth}
                <tr>
                    <td>{$auth.name}</td>
                    <td>{$auth.key}</td>
                    <td>{$auth.env.name}</td>
                    <td>{$auth.remains}</td>
                    <td>{$auth.invo}</td>
                    <td class="center">
                        <a class="lsBtn add-level fancybox.ajax" data-fancybox-type="ajax" href="{$docroot}?/WdminPage/settings_envs_robb/id={$auth.id}">编辑</a>
                        <a class="lsBtn del envs_del" data-id="{$auth.id}" href="javascript:;">删除</a>
                        <a class="lsBtn del envs_clear" data-id="{$auth.id}" href="javascript:;">清除</a>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax" id='add-level' style="width:150px" href="{$docroot}?/WdminPage/settings_envs_robb/mod=add">添加活动</a>
</div>

{include file='../__footer.tpl'} 
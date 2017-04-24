{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/banners.js</i>
<div id="list" style="margin-bottom: 40px;">
    <table class="dTable">
        <thead>
            <tr>
                <th>广告ID</th>
                <th style='width:300px'>横幅名称</th>
                <th>放置位置</th>
                <th>对应类型</th>
                <th>过期时间</th>
                <th>排序</th>
                <th class="center">操作</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$banners item=banner}
                <tr>
                    <td>{$banner.id}</td>
                    <td>{$banner.banner_name}</td>
                    <td>{$banner.pos}</td>
                    <td>{$banner.type}</td>
                    <td>{if $banner.exp neq '0000-00-00 00:00:00'}{$banner.exp}{else}永久{/if}</td>
                    <td>{$banner.sort}</td>
                    <td class="center">
                        <a class="lsBtn" href="?/WdminPage/settings_banner_edit/id={$banner.id}">编辑</a>
                        <a class="lsBtn del banner_del" data-id="{$banner.id}" href="javascript:;">删除</a>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" id='add_cate_product' style="width:150px" href="?/WdminPage/settings_banner_edit/">添加广告图</a>
</div>
{include file='../__footer.tpl'} 
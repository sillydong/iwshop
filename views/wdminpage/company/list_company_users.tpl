{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/company/list_company_users.js</i>
<table cellpadding=0 cellspacing=0 class="dTable" style="margin-bottom: 40px;">
    <thead>
        <tr>
            <th>编号</th>
            <th>头像</th>
            <th>姓名</th>
            <th>性别</th>
            <th>电话</th>
            <th>邮箱</th>
            <th>地区</th>
            <th>订单数量</th>
        </tr>
    </thead>
    <tbody>
        {strip}
            {section name=ls loop=$list}
                <tr {if $smarty.section.ls.index is odd by 1}class="odd"{/if}>
                    <td>#{$list[ls].client_id}</td>
                    <td>
                        <img class='ccl-head' 
                             src='{if $list[ls].client_head eq ''}{$docroot}static/images/icon/iconfont-weixin.png{else}{$list[ls].client_head}/0{/if}' />
                    </td>
                    <td>{$list[ls].client_name}</td>
                    <td>{$list[ls].client_sex}</td>
                    <td>{$list[ls].client_phone}</td>
                    <td>{$list[ls].client_email}</td>
                    <td>{$list[ls].client_address}</td>
                    <td>
                        {if $list[ls].order_count eq 0}
                            {$list[ls].order_count}
                        {else}
                            <a href="{$docroot}?/WdminPage/list_customer_orders/id={$list[ls].client_id}">{$list[ls].order_count} (查看)</a>
                        {/if}
                    </td>
                </tr>
            {/section}
        {/strip}
    </tbody>
</table>
<div class="fix_bottom fixed">
    <a class="wd-btn primary" style="width:150px" onclick="history.go(-1)" href="javascript:;">返回列表</a>
</div>
{include file='../__footer.tpl'} 
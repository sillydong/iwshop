<table cellpadding=0 cellspacing=0 class="dTable">
    <thead>
        <tr>
            <th class='hidden'>编号</th>
            <th>会员卡</th>
            <th>头像</th>
            <th>姓名</th>
            <th>性别</th>
            <th>电话</th>
            <th>邮箱</th>
            <th>地区</th>
            <th>订单数量</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        {strip}
            {section name=ls loop=$list}
                <tr {if $smarty.section.ls.index is odd by 1}class="odd"{/if}>
                    <td class="hidden">{$list[ls].cid}</td>
                    <td>{$list[ls].cardno}</td>
                    <td>
                        <img class='ccl-head' 
                             src='{if $list[ls].client_head eq ''}{$docroot}static/images/icon/iconfont-weixin.png{else}{$list[ls].client_head}/64{/if}' />
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
                            <a href="{$docroot}?/WdminPage/list_customer_orders/id={$list[ls].cid}">{$list[ls].order_count}</a>
                        {/if}
                    </td>
                    <td data-cid='{$list[ls].cid}'>
                        <a class="us-edit" data-fancybox-type="ajax" href="{$docroot}?/WdminPage/ajax_alter_customer/id={$list[ls].cid}">编辑</a>{*{if !$iscom} / <a class='us-del del' data-id='{$list[ls].cid}' href='javascript:;'>删除</a>{/if}*}
                    </td>
                </tr>
            {/section}
        {/strip}
    </tbody>
</table>
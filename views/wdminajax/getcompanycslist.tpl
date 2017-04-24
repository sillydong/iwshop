{if $olist == 0}
    <div class="pageNot">暂无数据</div>
{else}
    <table cellpadding=0 cellspacing=0 class="groupSentTable">
        <tr>
            <th colspan="1" width="80px" class="xleft">编号</th>
            <th colspan="1" width="80px" class="xleft">姓名</th>
            <th colspan="1" width="180px" class="xleft">电话</th>
            <th colspan="1" width="80px" class="center">推广商品数</th>
            <th colspan="1" width="80px" class="center">未结算金额</th>
            <th colspan="1" width="80px" class="center">银行账户</th>
            <th colspan="1" width="80px" class="center">操作</th>
        </tr>
        {section name=ci loop=$list}
            <tr {if $smarty.section.ci.index is odd by 1}class="odd"{/if} id="cps-{$list[ci].uid}">
                <td colspan="1" class="xleft">{$list[ci].uid}</td>
                <td colspan="1" class="xleft">{$list[ci].name}</td>
                <td colspan="1" class="xleft">{$list[ci].phone}</td>
                <td colspan="1" class="center">{$list[ci].count}</td>
                <td colspan="1" class="center">{$list[ci].sum}</td>
                <td colspan="1" class="center expressField">
                    {$list[ci].bank_account}
                    <br />
                    {$list[ci].bank_name}
                </td>
                <td colspan="1" class="center">
                    <a class="wd-btn primary small companyCash fancybox.ajax" data-fancybox-type="ajax" data-id="{$list[ci].uid}" href="{$docroot}?/WdminAjax/companyCash/id={$list[ci].uid}" style="min-width: 50px;margin: 0;">结算</a>
                </td>
            </tr>
        {/section}
    </table>
{/if}
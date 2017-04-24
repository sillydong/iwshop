{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/company/company_withdrawal.js</i>
<table cellpadding=0 cellspacing=0 class="dTable" style="margin-bottom: 40px;">
    <thead>
        <tr>
            <th>编号</th>
            <th>姓名</th>
            <th>电话</th>
            <th>收款银行</th>
            <th>收款账户</th>
            <th>收款姓名</th>
            <th>未结算金额</th>
            <th>销售数量</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        {strip}
            {foreach from=$wdlist item=cs}
                <tr>
                    <td>#{$cs.id}</td>
                    <td>{$cs.name}</td>
                    <td>{$cs.phone}</td>
                    <td>{$cs.bank_name}</td>
                    <td>{$cs.bank_account}</td>
                    <td>{$cs.bank_personname}</td>
                    <td class="prices font12 pd-amount" data-amount='{$cs.sum}'>&yen;{$cs.sum}</td>
                    <td class='pd-count' data-amount='{$cs.count}'>{$cs.count}件</td>
                    <td>
                        <a class="company-wd-btn" data-id="{$cs.id}" data-amount="&yen;{$cs.sum}" data-name="{$cs.name}" href="javascript:;">结算</a> / <a href="{$docroot}?/WdminPage/list_company_income/id={$cs.id}">收益</a> 
                    </td>
                </tr>
            {/foreach}
        {/strip}
    </tbody>
</table>
<div class="fix_bottom textLeft fixed">
    商品数量：<i class="digRed" id="com-orders-pd-count">?</i>&nbsp;
    未结算：<i class="digRed" id="com-income-count">?</i> 元
</div>
{include file='../__footer.tpl'} 
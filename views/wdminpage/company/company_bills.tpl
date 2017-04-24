{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/company/company_bills.js</i>
<input type="hidden" id="iscom" value="{$iscom}" />
<table cellpadding=0 cellspacing=0 class="dTable" style="margin-bottom: 40px;">
    <thead>
        <tr>
            <th>编号</th>
            <th>姓名</th>
            <th>电话</th>
            <th>收款银行</th>
            <th>收款账户</th>
            <th>收款姓名</th>
            <th>结算金额</th>
            <th>结算日期</th>
        </tr>
    </thead>
    <tbody>
        {strip}
            {foreach from=$bills item=cs}
                <tr>
                    <td>#{$cs.id}</td>
                    <td>{$cs.name}</td>
                    <td>{$cs.phone}</td>
                    <td>{$cs.bank_name}</td>
                    <td>{$cs.bank_account}</td>
                    <td>{$cs.bank_personname}</td>
                    <td class="prices font12 bill_amounts" data-amount='{$cs.bill_amount}'>&yen;{$cs.bill_amount}</td>
                    <td>{$cs.bill_time}</td>
                </tr>
            {/foreach}
        {/strip}
    </tbody>
</table>
<div class="fix_bottom textLeft fixed">
    已结算金额：<i class="digRed" id="com-income-count">?</i> 元
</div>
{include file='../__footer.tpl'} 
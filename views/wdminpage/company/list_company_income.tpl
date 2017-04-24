{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/company/list_company_income.js</i>
<input type="hidden" id="iscom" value="{if $iscom}1{/if}" />
<table cellpadding=0 cellspacing=0 class="dTable" {if !$iscom}style="margin-bottom: 40px;"{/if}>
    <thead>
        <tr>
            <th>订单编号</th>
            <th>订单金额</th>
            <th>预计收益</th>
            <th>客户姓名</th>
            <th>客户电话</th>
            <th>商品数量</th>
            <th>下单时间</th>
            <th>订单状态</th>
            <th>结算状态</th>
        </tr>
    </thead>
    <tbody>
        {strip}
            {foreach from=$companyIncome item=list}
                <tr>
                    <td>{$list.serial_number}</td>
                    <td class="prices font12">&yen;{$list.order_amount}</td>
                    <td class="prices font12 income-float{$list.is_seted}" data-amount="{$list.amount}">&yen;{$list.income}</td>
                    <td>{$list.address.user_name}</td>
                    <td>{$list.address.tel_number}</td>
                    <td class="income-pdcount">{$list.product_count} 件</td>
                    <td>{$list.order_time}</td>
                    <td class="orderstatus {$list.status}">{$list.statusX}</td>
                    <td class='com-incomestatus{$list.is_seted}'>{if $list.is_seted}已结算{else}未结算{/if}</td>
                </tr>
            {/foreach}
        {/strip}
    </tbody>
</table>
{if !$iscom}
    <div class="fix_bottom fixed">
        <a class="wd-btn primary" style="width:150px" onclick="history.go(-1)" href="javascript:;">返回列表</a>
    </div>
{else}
    <div class="fix_bottom textLeft fixed">
        订单数量：<i class="digRed" id="com-orders-count">?</i>&nbsp;
        销售商品数量：<i class="digRed" id="com-orders-pd-count">?</i>&nbsp;
        未结算收益：<i class="digRed" id="com-income-count0">?</i>&nbsp;
        已结算收益：<i class="digRed" id="com-income-count1">?</i>&nbsp;
        总收益：<i class="digRed" id="com-income-count2">?</i>
    </div>
{/if}
{include file='../__footer.tpl'} 
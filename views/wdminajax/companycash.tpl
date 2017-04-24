<div style="text-align: center;line-height: 35px;min-width: 200px;">
    {$list.bank_personname}
    <br />
    {$list.bank_name}
    <br />
    {$list.bank_account}
    <div>
        结算金额：
        &yen;{$list.amount}
    </div>
    <a class="wd-btn primary small" data-fancybox-type="ajax" onclick="companyScash('{$list.uid}');" href="javascript:;" style="min-width: 80px;margin: 0;">确认结算</a>
</div>
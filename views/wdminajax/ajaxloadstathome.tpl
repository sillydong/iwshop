<div class="stat-item-head">
    <span class="stat-item-1">今日浏览量：<b id="daytot"></b></span>
    <span class="stat-item-1">本月浏览量：<b id="montot"></b></span>
</div>
<div id="pageviewchart" style="height:200px"></div>
<div class="stat-item-head">
    <span class="stat-item-1">今日销售额 <b>&yen;{if $daysale.sum}{$daysale.sum}{else}0{/if}</b></span>
    <span class="stat-item-1">本月销售额 <b>&yen;{if $monthsale.sum}{$monthsale.sum}{else}0{/if}</b></span>
</div>
<div id="saletReachart" style="height:200px"></div>
<div class="stat-item-head">
    <span class="stat-item-1">总关注 <b>{if $wechatSubTotal}{$wechatSubTotal}{else}0{/if}</b></span>
    <span class="stat-item-1">今日新增 <b>{if $wechatSubDay}{$wechatSubDay}{else}0{/if}</b></span>
</div>
<div id="Wechatchart" style="height:200px"></div>
<input type="hidden" id="wechatCount" value="{$wecahtCount}" />
<input type="hidden" id="wechatDay" value="{$wecahtDay}" />
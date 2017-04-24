{include file='../__header.tpl'}
<i id="scriptTag">page_list_customer_orders</i>
<input type="hidden" id="cid" value="{$cid}" />
<div id="orderlist" class="clearfix" style="margin-bottom: 40px"></div>
<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" style="width:150px" onclick="history.go(-1)" href="javascript:;">返回列表</a>
</div>
{include file='../__footer.tpl'} 
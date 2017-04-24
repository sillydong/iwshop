{section name=oi loop=$orders}
    <div class="uc-orderitem" id="orderitem{$orders[oi].order_id}">
        <div class="uc-seral clearfix">
            <p class="order_serial">订单号：{$orders[oi].serial_number}</p>

            <p class="order_status">{$orders[oi].statusX}</p>
        </div>
        {section name=di loop=$orders[oi]['data']}
            <div class="clearfix items"
                 onclick="location = '{$docroot}?/Order/expressDetail/order_id={$orders[oi].order_id}';">
                <img class="ucoi-pic" height="60px" width="60px"
                     src="{$orders[oi]['data'][di].catimg}">

                <div class="ucoi-con">
                    <!-- 商品标题 -->
                    <span class="title" style='height:42px;'>{$orders[oi]['data'][di].product_name}</span>
                    <!-- 商品单价 -->
                    <span class="price"><span
                                class="dprice">&yen;{$orders[oi]['data'][di].product_discount_price}</span> x <span
                                class="dcount">{$orders[oi]['data'][di].product_count}</span></span>
                </div>
            </div>
        {/section}
        <div class="uc-summary clearfix" style='padding:8px 7px;text-align:right;'>
            <div class="sum">
				总计: <span class="dprice">&yen;{$orders[oi].order_amount}</span>
            </div>
            {if $orders[oi].status == "unpay"}
                {*未支付订单*}
                <a class="olbtn cancel" href="javascript:;" onclick="Orders.cancelOrder({$orders[oi].order_id}, this);">取消订单</a>
                <a class="olbtn wepay wepay_button" href="javascript:;" data-id="{$orders[oi].order_id}">立即支付</a>
            {else if $orders[oi].status == "payed"}
                {*已支付订单*}
                <a class="olbtn cancel" href="javascript:;" onclick="Orders.cancelOrder({$orders[oi].order_id}, this);">取消订单</a>
                <a class="olbtn wepay" href="?/Order/expressDetail/order_id={$orders[oi].order_id}">订单详情</a>
            {else if $orders[oi].status == "delivering"}
                {*快递中订单*}
                <a class="olbtn wepay" href="javascript:Orders.confirmExpress({$orders[oi].order_id});">确认收货</a>
                <a class="olbtn wepay" href="?/Order/expressDetail/order_id={$orders[oi].order_id}">订单详情</a>
            {else if $orders[oi].status == "received" and $orders[oi].is_commented eq 0}
                {*已收货订单*}
                <a class="olbtn express" href="?/Order/commentOrder/order_id={$orders[oi].order_id}">订单评价</a>
            {else if $orders[oi].status == "canceled"}
                {*已取消订单*}
                <a class="olbtn cancel" href="?/Order/expressDetail/order_id={$orders[oi].order_id}">订单详情</a>
            {else}
                {*已退款或其他状态订单*}
                <a class="olbtn cancel" href="?/Order/expressDetail/order_id={$orders[oi].order_id}">订单详情</a>
            {/if}
            {if $orders[oi].isreq}
                {*代付订单*}
                <a class="olbtn wepay" href="?/Order/reqPay/id={$orders[oi].order_id}">邀请页面</a>
            {/if}
        </div>
    </div>
{/section}

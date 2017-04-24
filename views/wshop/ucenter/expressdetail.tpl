<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>订单详情</title>
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="format-detection" content="telephone=no">
        <link href="static/css/wshop_uc.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
    </head>
    <body style='background: #f7f7f7;overflow-x:hidden;'>

        <input type="hidden" value="{$orderdetail.express_code}" id="expresscode" />

        <input type="hidden" value="{$orderdetail.express_com}" id="expresscom" />

        {include file="../../global/top_nav.tpl"}

        {include file="../../global/ad/global_top.tpl"}

        <div class="exp-item-info clearfix" style="margin-top:0;">
            <span class="order-status">{$orderdetail.statusX}</span>
            <span class="order-id">订单号：{$orderdetail.serial_number}</span>
        </div>

        <div class="exp-item-info" style="background:url({$docroot}static/images/icon/od-exp-bh.png) left top repeat-x #fff;padding:0;padding-top:15px;">
            <div style="padding:0 10px;">
                <div class="clearfix">
                    <span class="od-name">{$orderdetail.address.user_name}</span>
                    <span class="od-tel">{$orderdetail.address.tel_number}</span>
                </div>
                <div class="od-address">{$orderdetail.address.address}</div>
            </div>
            <div style="height:15px;background:url({$docroot}static/images/icon/od-exp-bh.png) left bottom repeat-x #fff;"></div>
        </div>

        {if $orderdetail.express_code neq '' and !$isExpstaff}
            <div class="exp-head">
                <div id="exp-comname">{$orderdetail.express_com1}</div>
                <div id="exp-code">运单编号：{$orderdetail.express_code}</div>
            </div>
        {/if}

        {if $orderdetail.express_code neq '' and !$isExpstaff}
            <div class="exp-item-info">
                <div class="exp-item-caption">物流跟踪</div>
                <ul id="express-dt"></ul>
                <div id="loading-wrap"></div>
            </div>
        {/if}

        <div class="exp-item-info">
            <div class="exp-item-caption">物品信息</div>
            {section name=pi loop=$productlist}
                <div class="clearfix items" onclick="location = '{$docroot}?/vProduct/view/id={$productlist[pi].product_id}/showwxpaytitle=1';">
                    <img class="ucoi-pic" src="{$productlist[pi].catimg}" />
                    <div class="ucoi-con">
                        <span class="title Elipsis">{$productlist[pi].product_name}</span>
                        <span class="spec">{$productlist[pi].spec1}{$productlist[pi].spec2}</span>
                        <span class="price"><span class="prices">&yen;{$productlist[pi].product_discount_price}</span> x <span class="dcount">{$productlist[pi].product_count}</span></span>
                    </div>
                </div>
            {/section}
        </div>

        <div class="exp-item-info">
            <div class="exp-item-caption">订单信息</div>
            <div class="exp-payinfo clearfix">
                <span class="left">订单编号：</span>
                <span class="right" style="color:#777;">{$orderdetail.serial_number}</span>
            </div>
            {if $orderdetail.wepay_serial neq ''}
                <div class="exp-payinfo clearfix">
                    <span class="left">支付编号：</span>
                    <span class="right" style="color:#777;">{$orderdetail.wepay_serial}</span>
                </div>
            {/if}
            <div class="exp-payinfo clearfix">
                <span class="left">订单总额(包括运费)：</span>
                <span class="right prices">&yen;{$orderdetail.order_amount}</span>
            </div>
            <div class="exp-payinfo clearfix">
                <span class="left">运费：</span>
                <span class="right prices">&yen;{$orderdetail.order_expfee}</span>
            </div>
            <div class="exp-payinfo clearfix">
                <span class="left">配送时间：</span>
                <span class="right">{$orderdetail.exptime}</span>
            </div>
            <div class="exp-payinfo clearfix">
                <span class="left">备注：</span>
                <span class="right">{$orderdetail.leword}</span>
            </div>
            {if $orderdetail.reci_tex > 0}
                <div class="exp-payinfo clearfix">
                    <span class="left">发票抬头：</span>
                    <span class="right">{$orderdetail.reci_head}</span>
                </div>
                <div class="exp-payinfo clearfix">
                    <span class="left">发票内容：</span>
                    <span class="right">{$orderdetail.reci_cont}</span>
                </div>
                <div class="exp-payinfo clearfix">
                    <span class="left">发票税额：</span>
                    <span class="right">{$orderdetail.reci_tex}</span>
                </div>
            {/if}
            <div id="expressapi-cop">
                {if $isExpstaff and $orderdetail.status == "delivering"}
                    <a id="express-confirm" class="button green" data-id="{$orderdetail.order_id}">确认送达</a>
                {/if}
                {if !$isExpstaff and $orderdetail.status == "delivering"}
                    <a id="order-confirm" class="button green" data-id="{$orderdetail.order_id}">确认收货</a>
                {/if}
            </div>
        </div>

        <script data-main="static/script/Wshop/shop_orderdetail.js?v={$config.cssversion}" src="static/script/require.min.js"></script>

        {if !$isExpstaff}
            {include file="../../global/footer.tpl"}
        {else}
            {include file="../../global/copyright.tpl"}
        {/if}

    </body>
</html>

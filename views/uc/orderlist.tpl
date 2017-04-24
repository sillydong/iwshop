<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>{$title} - {$settings.shopname}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <link href="static/css/wshop_uc.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <script type="text/javascript" src="static/script/jquery-2.1.1.min.js?v={$cssversion}"></script>
    <script type="text/javascript" src="static/script/main.js?v={$cssversion}"></script>
</head>
<body style='background: #f7f7f7;'>
<input type="hidden" value="{$status}" id="status"/>

{include file="../global/top_nav.tpl"}

{include file="../global/ad/global_top.tpl"}

<div class='clearfix' id='uc-order-sort-bar'>
    <div class='uc-order-sort {if $status eq ''}hover{/if}' data-status=""><b>全部</b></div>
    <div class='uc-order-sort {if $status eq 'unpay'}hover{/if}' data-status="unpay"><b>待付款</b></div>
    <div class='uc-order-sort {if $status eq 'payed'}hover{/if}' data-status="payed"><b>待发货</b></div>
    <div class='uc-order-sort {if $status eq 'delivering'}hover{/if}' data-status="delivering"><b>待收货</b></div>
    <div class='uc-order-sort {if $status eq 'received'}hover{/if}' data-status="received"><b>待评价</b></div>
</div>

<div id="uc-orderlist"></div>
<div id="list-loading" style="display: none;"><img src="{$docroot}static/images/icon/spinner-g-60.png" width="30"></div>

{include file="../global/footer.tpl"}

<!-- 微信JSSDK -->
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>

<script type="text/javascript">
    wx.config({
        debug: false,
        appId: '{$signPackage.appId}',
        timestamp: {$signPackage.timestamp},
        nonceStr: '{$signPackage.nonceStr}',
        signature: '{$signPackage.signature}',
        jsApiList: ['chooseWXPay']
    });
</script>

<script data-main="{$docroot}static/script/Wshop/shop_orderlist.js"
        src="/libs/jquery/require.min.js"></script>

</body>
</html>

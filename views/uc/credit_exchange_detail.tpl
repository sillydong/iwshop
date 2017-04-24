<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
    <title>{$title} - {$settings.shopname}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
    <meta name="format-detection" content="telephone=no" />
    <link href="{$docroot}static/css/wshop_credit_exchage_detail.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
    <link href="{$docroot}static/css/base_animate.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
    <link href="{$docroot}static/script/lib/mobiscroll/css/mobiscroll.custom-2.17.1.min.css" rel="stylesheet" type="text/css"/>
</head>
<body>

{include file="../global/top_nav.tpl"}

<div id="addrPick"></div>
<input type="hidden" id="pid" value="{$pid}" />
<input type="hidden" id="credit" value="{$credit}" />
<input type="hidden" id="addrOn" value="{if $config.wechatVerifyed and $config.useWechatAddr}1{else}0{/if}" />

<header class="Thead">收货信息</header>

<!-- 收货地址 -->
<div id="express-bar"></div>
<div id="express_address" href="javascript:;">
    <div id="wrp-btn">点击选择收货地址</div>
    <div class="express-person-info clearfix">
        <div class="express-person-name">
            <span id="express-name"></span><span id="express-person-phone"></span>
        </div>
    </div>
    <div class="express-address-info">
        <span id="express-address"></span>
    </div>
</div>

<header class="Thead">兑换商品</header>

<div id="orderDetailsWrapper" data-minheight="68px">
    <section class="cartListWrap clearfix" id="cartsec{$product.product_id}">
        <img alt="{$product.product_name}" width="100" height="100" src="{if $config.usecdn}{$config.imagesPrefix}product_hpic/{$product.catimg}_x120{else if $config.oss}{$product.catimg}{else}static/Thumbnail/?w=200&h=200&p={$config.productPicLink}{$product.catimg}{/if}" />
        <div class="cartListDesc">
            <p class="title">
                {$product.product_name}
            </p>
        </div>
    </section>
</div>


<!-- 订单信息 -->
<header class="Thead">使用积分</header>
<div id="orderSummay" class=''>
    <div>
        使用积分 : <b class="prices font13">{$credit}点积分</b>
    </div>
</div>

<!-- 确定兑换按钮 -->
<div class="button green"  id="credit-exchange-btn">确定兑换</div>
<!-- 微信JSSDK -->
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>

<!-- 微信JSSDK -->
<script type="text/javascript">
    wx.config({
        debug: false,
        appId: '{$signPackage.appId}',
        timestamp: {$signPackage.timestamp},
        nonceStr: '{$signPackage.nonceStr}',
        signature: '{$signPackage.signature}',
        jsApiList: ['chooseWXPay']
    });
    addrsignPackage = {$addrsignPackage};
</script>

<script data-main="{$docroot}static/script/Wshop/shop_credit_exchange_detail.js?v={$smarty.now}" src="static/script/lib/require.min.js"></script>

{include file="../global/copyright.tpl"}

</body>
</html>

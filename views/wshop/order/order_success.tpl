<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>{$title} - {$settings.shopname}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="format-detection" content="telephone=no">
        <link href="static/css/wshop_cart.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
    </head>
    <body style='background: #f2f2f2;'>
        <input type="hidden" value="{$status}" id="status" />

        {include file="../../global/top_nav.tpl"}

        <div id="order_success">
            <img src="static/images/icon/iconfont-success.png" height="60px" />
            <div class="desc">
                下单成功！<br/>
                分享到朋友圈并截图发给我们<br/>
                即可获得积分哦
            </div>
        </div>

        <div id="order_success_addr">
            <div class="expname">收货人：{$orderAddress.user_name}<span>{$orderAddress.tel_number}</span></div>
            <div>收货地址：{$orderAddress.address}</div>
            <div id="buttons">
                <a class="subtn" href="{$docroot}">返回首页</a>
                <a class="subtn" href="{$docroot}?/Uc/orderlist">我的订单</a>
            </div>
        </div>

        {include file="../../global/copyright.tpl"}

        <script type="text/javascript">
            $(function () {
                $('body').css('min-height', $(window).height() - 45);
            });
        </script>

    </body>
</html>
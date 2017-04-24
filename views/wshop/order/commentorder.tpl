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
        <link href="static/css/wshop_uc.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
    </head>
    <body style='background: #f7f7f7;'>

        <input type="hidden" value="{$order.order_id}" id="order_id" />

        {include file="../../global/top_nav.tpl"}

        {include file="../../global/ad/global_top.tpl"}

        <div id="odcomment">
            <div class="clearfix">
                {foreach from=$order.products item=pd}
                    <img class="pdimg" src="{$pd.catimg}" height="80px" width="80px" />
                {/foreach}
            </div>
            <div id="starlist" class="clearfix">
                <a class="starItem fill" data-id="0" href="javascript:;"></a>
                <a class="starItem fill" data-id="1" href="javascript:;"></a>
                <a class="starItem fill" data-id="2" href="javascript:;"></a>
                <a class="starItem fill" data-id="3" href="javascript:;"></a>
                <a class="starItem fill" data-id="4" href="javascript:;"></a>
            </div>
            <div id="commentField">
                <textarea id="commentText" placeholder="亲，请留下在购物过程中，您的建议和意见，我们将竭诚为你服务！你的支持是我们最大的荣幸，谢谢！"></textarea>
            </div>
        </div>

        <div id="odbuttons">
            <a class="btn" id="odsubmit" href="javascript:;">提交评价</a>
        </div>

        <script data-main="{$docroot}static/script/Wshop/shop_ordercomment.js" src="/libs/jquery/require.min.js"></script>

    </body>
</html>
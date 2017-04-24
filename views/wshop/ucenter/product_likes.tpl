<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>我的收藏 - {$settings.shopname}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="format-detection" content="telephone=no">
        <link href="static/css/wshop_uc.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <link href="static/css/wshop_vproductlist.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="static/script/jquery-2.1.1.min.js?v={$cssversion}"></script>
        <script type="text/javascript" src="static/script/main.js?v={$cssversion}"></script>
    </head>
    <body style='background: #f7f7f7;'>
        <input type="hidden" value="{$status}" id="status" />

        {include file="../../global/top_nav.tpl"}

        <div id="likes_list" class="clearfix"></div>
        <div id="Loading"></div>

        <script type="text/javascript">
            $(function() {
                UcLikeLoad();
            });
        </script>

        {include file="../../global/footer.tpl"}

    </body>
</html>
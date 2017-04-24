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
        <link href="{$docroot}static/css/wshop_vproductlist.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
    </head>
    <body>
        <input type="hidden" value="{$query.searchkey}" id="searchkey" />
        <input type="hidden" value="{$cat}" id="cat" />
        <input type="hidden" value="{$orderby}" id="orderby" />
        <input type="hidden" value="{$serial}" id="serial" />
        <input type="hidden" value="{$level}" id="level" />
        <input type="hidden" value="{$brand}" id="brand" />
        <input type="hidden" value="{$query.in}" id="in" />

        {include file="../global/top_nav.tpl"}
        
        {include file="../global/ad/global_top.tpl"}

        {include file="../global/search_box1.tpl"}

        {include file="../global/subnav1.tpl"}

        <div id="product_list" class="clearfix" style="margin-top: -1px;"></div>
        
        <div id="buttomLoading"></div>
        
        <script data-main="{$docroot}static/script/Wshop/shop_vproductlist.js?v={$cssversion}" src="/libs/jquery/require.min.js"></script>
        {include file="../global/footer.tpl"}
    </body>
</html>
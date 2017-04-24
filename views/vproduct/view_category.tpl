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
        <link href="{$docroot}static/css/wshop_view_category.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
    </head>
    <body style="overflow:hidden;padding:0;-webkit-overflow-scrolling: none;">
        
        <input type="hidden" value="{$Query.searchkey}" id="searchkey" />
        <input type="hidden" value="{$cat}" id="cat" />
        <input type="hidden" value="{$serial_id}" id="serial_id" />
        <input type="hidden" value="{$orderby}" id="orderby" />

        {include file="../global/search_box1.tpl"}

        <div class="clearfix" id="viewCat">
            <div id="viewCatLeft">
                <div class="viewCatTopItem Elipsis" data-catid="-1">一周新品</div>
                <div class="viewCatTopItem Elipsis" data-catid="-2">一周热搜</div>
                <div class="viewCatTopItem Elipsis" data-catid="-3">品牌专卖</div>
                {foreach from=$topcat item=tc}
                    <div class="viewCatTopItem Elipsis" data-catid="{$tc.cat_id}">{$tc.cat_name}</div>
                {/foreach}
            </div>
            <div id="viewCatRight"></div>
        </div>

        {include file="../global/nav_bottom.tpl"}

        <script data-main="{$docroot}static/script/Wshop/shop_vcategory.js?v={$cssversion}" src="/libs/jquery/require.min.js"></script>
    </body>
</html>

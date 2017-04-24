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

    {include file="../../global/top_nav.tpl"}

        <div id="product_list" class="clearfix" style="margin-top: -1px;">        
            <div class="clearfix pdBlock">
                {foreach from=$pds item=pd}
                    <section class="productListWrap hoz" onclick="location = '{$docroot}?/vProduct/view/id={$pd.product_id}&showwxpaytitle=1';">
                        <a class="productList">
                            <img class="photo" src="{if $config.usecdn}{$config.imagesPrefix}product_hpic/{$pd.catimg}_x200{else if $config.oss}{$pd.catimg}{else}static/Thumbnail/?w=200&h=200&p={$config.productPicLink}{$pd.catimg}{/if}" />           
                            <section>
                                <title class="title{if $stype eq 'hoz'} Elipsis{/if}">{$pd.product_name}</title>
                                <span class='prices'>&yen;{$pd.sale_prices}{if $pd.market_price neq ''}<i>&yen;{$pd.market_price}</i>{/if}</span>
                            </section>
                        </a>
                    </section>
                {/foreach}
            </div>

            <script data-main="{$docroot}static/script/Wshop/shop_vbrand.js?v={$cssversion}" src="/libs/jquery/require.min.js"></script>
            {include file="../../global/footer.tpl"}
    </body>
</html>
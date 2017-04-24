<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>积分兑换 - {$settings.shopname}</title>
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

        <script data-main="static/script/Wshop/shop_credit.js?v={$config.cssversion}" src="static/script/require.min.js"></script>

        {include file="../global/top_nav.tpl"}

        <div class="clearfix pdBlock">
            {foreach from=$list item=pd}
                {if $pd.product_name neq ''}
                    <section class="productListWrap hoz">
                        <a class="productList clearfix" href='javascript:;' data-id='{$pd.product_id}' data-credit="{$pd.product_credits}">
                            <img class="photo" src="{$pd.catimg}" />
                            <section>
                                <title class="title{if $stype eq 'hoz'} Elipsis{/if}">{$pd.product_name}</title>
                                <span class='credit-amount'>{$pd.product_credits}点积分</span>
                            </section>
                        </a>
                    </section>
                {/if}
            {/foreach}
        </div>

        {include file="../global/footer.tpl"}

    </body>
</html>
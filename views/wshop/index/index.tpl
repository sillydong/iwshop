<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
    <title>{$settings.shopname}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}static/css/wshop_home.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
</head>
<body>

{include file="global/nav_bottom.tpl"}

{include file="global/ad/global_top.tpl"}

{include file="global/search_box1.tpl"}

{if $topBanners|count > 0}
    <header class="index-header">
        <!-- slider -->
        {strip}
            <div id="slider" {if $topBanners|count > 1}style='height:auto' class='clearfix'{/if} style="border-bottom:1px solid #eee;">
                <div class="sliderLoading"></div>
                {if $topBanners|count > 1}
                    <div class="sliderTip">
                        {foreach from=$topBanners item=banner name=ii}
                            <i class="sliderTipItems {if $smarty.foreach.ii.index == 0}current{/if}"></i>
                        {/foreach}
                    </div>
                {/if}
                <div id="slideFrame">
                    {foreach from=$topBanners item=banner}
                        <div class="sliderX" {if $topBanners|count eq 1}style='float:left'{/if}>
                            <img class="sliderXImages" onclick="location.href = '{$banner.link}';"  src="{$banner.banner_image}" />
                        </div>
                    {/foreach}
                </div>
            </div>
        {/strip}
        <script type="text/javascript">document.querySelector('#slider').style.height = (document.documentElement.clientWidth * (290 / 600)) + 'px';</script>
        <!-- slider -->
    </header>
{/if}

{include file="wshop/index/index_navigation.tpl"}

{if $secAdv|count > 0}
    {foreach from=$secAdv item=sc1 name=sca1}
        <div class="floor">
            <h2 class="title">{$sc1.name}</h2>
            <div class="discount">
                {foreach from=$sc1.advs item=pd1 name=pds1}
                    {if $smarty.foreach.pds1.index == 0}
                        <a page_name="index" href="{$pd1.link}" class="half-floor">
                            <img class="sliderXImages" onclick="location.href = '{$pd1.link}';"  src="{$pd1.banner_image}"
                                 alt="{$pd1.banner_name}" width="100%" border="0">
                        </a>
                    {/if}
                    {if $smarty.foreach.pds1.index == 1}
                        <a page_name="index" href="{$pd1.link}" class="up-floor">
                            <img class="sliderXImages" onclick="location.href = '{$pd1.link}';"  src="{$pd1.banner_image}"
                                 alt="{$pd1.banner_name}" width="100%" border="0">
                        </a>
                    {/if}
                    {if $smarty.foreach.pds1.index == 2}
                        <a page_name="index" href="{$pd1.link}" class="down-floor">
                            <img class="sliderXImages" onclick="location.href = '{$pd1.link}';"  src="{if $config.oss}{$pd1.banner_image}{else}uploads/banner/{$pd1.banner_image}{/if}"
                                 alt="{$pd1.banner_name}" width="100%" border="0">
                        </a>
                    {/if}

                {/foreach}

            </div>
        </div>
    {/foreach}
{/if}

{foreach from=$Section item=sc name=sca}
    <section class="home-recom">
        <header><span>{$sc.name}</span></header>
        {if $sc.banner neq ''}<a class="banner" href="?/vProduct/view_list/cat={$sc.relid}"><img src="{$sc.banner}" /></a>{/if}
        <section class="clearfix">
            {foreach from=$sc.products item=pd name=pds}
                <a href="?/vProduct/view/id={$pd.product_id}" class="hplist">
                    <img src="{$pd.catimg}" />
                    <p class="Elipsis">{$pd.product_name}</p>
                    <i>&yen;{$pd.sell_price}</i>
                </a>
            {/foreach}
        </section>
    </section>
{/foreach}

<!-- serials -->
<script data-main="{$docroot}static/script/Wshop/shop_index.js" src="/libs/jquery/require.min.js"></script>

{include file="global/copyright.tpl"}

</body>
</html>

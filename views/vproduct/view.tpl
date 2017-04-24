<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>{$title} - {$settings.shopname}</title>
    <link href="favicon.ico" rel="Shortcut Icon"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="{$docroot}static/css/wshop_vproduct.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
</head>
<body>

{include file="../global/top_nav.tpl"}

{include file="../global/ad/global_top.tpl"}

<input type="hidden" value="{$comid|default:0}" id="comid"/>
<input type="hidden" value="{$productInfo.product_name}" id="sharetitle"/>
<input type="hidden" value="{$productid|default:0}" id="iproductId"/>
<input type="hidden" value="{$productInfo.market_price|string_format:"%.2f"}" id="mprice"/>

<!-- touchslider -->
{strip}
    <div class="touchslider" id="touchslider">
        <div class="touchslider-viewport">
            {section name=ii loop=$images}
                <div class="touchslider-item">
                    <img style="max-width: 100%;"
                         data-big="{if $config.usecdn}{$config.imagesPrefix}product_hpic/{$images[ii].image_path}{else if $config.oss}{$images[ii].image_path}{else}{$config.productPicLink}{$images[ii].image_path}{/if}"
                         src="{if $config.usecdn}{$config.imagesPrefix}product_hpic/{$images[ii].image_path}_x500{else if $config.oss}{$images[ii].image_path}{else}static/Thumbnail/?w=500&h=500&p={$config.productPicLink}{$images[ii].image_path}{/if}"/>
                </div>
            {/section}
        </div>
        <div class="touchslider-nav">
            {section name=ii loop=$images}
                <span class="touchslider-nav-item"></span>
            {/section}
        </div>
    </div>
    <script type="text/javascript">document.querySelector('#touchslider').style.height = document.documentElement.clientWidth + 'px';</script>
{/strip}
<!-- touchslider -->

<div id="container">
    {if $productInfo.product_online eq 1}
        <div class="uc-add-like{if $isLiked} fill{/if}">收藏</div>
        <p class="vpd-title" style='height:auto;'>
            {$productInfo.product_name}
        </p>
        <p class="vpd-subtitle">{$productInfo.product_subtitle}</p>
        <!-- 价格显示 -->
        {if $productInfo.product_prom eq 1}
            <dl class="pd-dsc clearfix">
                <dt>市场价：</dt>
                <dt id="pd-market-price"
                    class="prices marketPrice">&yen;{$productInfo.market_price|string_format:"%.2f"}</dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>零售价：</dt>
                <dt class="prices marketPrice"
                    id="pd-market-price2">&yen;{($productInfo.sell_price)|string_format:"%.2f"}</dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>秒杀价：</dt>
                <!---<dt class="prices" id="pd-sale-price">&yen;{($productInfo.sale_price*($productInfo.product_prom_discount/100))|string_format:"%.2f"}----->
                <dt class="prices" id="pd-sale-price">&yen;{($productInfo.market_price * ($productInfo.product_prom_discount / 100))|string_format:"%.2f"}
                </dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>截止时间：</dt>
                <dt>{$productInfo.product_prom_limitdate}</dt>
            </dl>
        {else}
            {if $productInfo.sale_price ne '0.00'}

                {if $productInfo.market_price > 0}
                    <dl class="pd-dsc clearfix">
                        <dt>市场价：</dt>
                        <dt id="pd-market-price"
                            class="prices marketPrice">&yen;{$productInfo.market_price|string_format:"%.2f"}</dt>
                    </dl>
                {/if}

                {if $discount eq 1}
                    <dl class="pd-dsc clearfix">
                        <dt>零售价：</dt>
                        <dt class="prices" id="pd-sale-price">
                            &yen;{($productInfo.sell_price * $discount)|string_format:"%.2f"}
                        </dt>
                    </dl>
                {else}
                    <dl class="pd-dsc clearfix">
                        <dt>零售价：</dt>
                       
                        <dt class="prices marketPrice"
                   		    id="pd-market-price2">&yen;{($productInfo.sell_price)|string_format:"%.2f"}</dt>
                    </dl>
                    <dl class="pd-dsc clearfix">
                        <dt>专享价：</dt>
                        <dt class="prices"
                            id="pd-sale-price">&yen;{($productInfo.sell_price * $discount)|string_format:"%.2f"}</dt>
                    </dl>
                {/if}

            {/if}
            {if $prominfo}
                <dl class="pd-dsc clearfix">
                    <dt>促销：</dt>
                    <dt class="prominfo">
                        <b>红包</b>满{$prominfo.req_amount}减{$prominfo.dis_amount}
                    </dt>
                </dl>
            {/if}
        {/if}

        <!-- 价格显示 -->
        {if $specsDistinct.a.spd1name neq ''}
            <div>
                {if $productInfo.product_prom eq 1}
                    {foreach from=$specs item=sp}
                        <input type='hidden' class='spec-hashs' data-stock="{$sp.instock}"
                               value='{$sp.spec_det_id1}-{$sp.spec_det_id2}'
                               data-price='{($sp.sale_price * ($productInfo.product_prom_discount / 100))|string_format:"%.2f"}'
                               data-market-price="{$sp.market_price}" data-id="{$sp.id}"/>
                    {/foreach}
                {else}
                    {foreach from=$specs item=sp}
                        <input type='hidden' class='spec-hashs' data-stock="{$sp.instock}"
                               value='{$sp.spec_det_id1}-{$sp.spec_det_id2}'
                               data-price='{($sp.sale_price * $discount)|string_format:"%.2f"}'
                               data-market-price="{$sp.market_price}" data-id="{$sp.id}"/>
                    {/foreach}
                {/if}
            </div>
            <dl class="pd-dsc clearfix" id="pd-dsc1" style='margin-top:8px;'>
                <dt class="left">{$specs[0].spd1name}：</dt>
                <dt>
                <div class='pd-spec-dets clearfix'>
                    {foreach from=$specsDistinct.a.sps item=sp name=sploop}
                        <div class='pd-spec-sx enable' href='javascript:;'
                             data-det-id='{$sp.spec_det_id1}'>{$sp.det_name1}</div>
                    {/foreach}
                </div>
                </dt>
            </dl>
        {/if}
        {if $specsDistinct.b.spd2name neq ''}
            <dl class="pd-dsc clearfix" id="pd-dsc2">
                <dt class="left">{$specs[0].spd2name}：</dt>
                <dt>
                <div class='pd-spec-dets clearfix'>
                    {foreach from=$specsDistinct.b.sps item=sp name=sploop}
                        <div class='pd-spec-sx enable' href='javascript:;'
                             data-det-id='{$sp.spec_det_id2}'>{$sp.det_name2}</div>
                    {/foreach}
                </div>
                </dt>
            </dl>
        {/if}

        <!-- 显示商家信息 -->
        {if $supplier}
            <dl class="pd-dsc clearfix">
                <dt>商家名称：</dt>
                <dt>{$supplier.supp_name} (<a href="tel:{$supplier.supp_phone}">{$supplier.supp_phone}</a>)</dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>配送范围：</dt>
                <dt>{$supplier.supp_sarea}</dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>营业时间：</dt>
                <dt>{$supplier.supp_stime}</dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>起送金额：</dt>
                <dt>{$supplier.supp_sprice}</dt>
            </dl>
            <dl class="pd-dsc clearfix">
                <dt>商家简介：</dt>
                <dt>{$supplier.supp_desc}</dt>
            </dl>
        {/if}

        <!-- 显示库存量 -->
        <dl class="pd-dsc clearfix hidden" id="product_stock_wrap">
            <dt>库存量：</dt>
            <dt id="pd-stock">{$productInfo.product_instocks}</dt>
        </dl>
    {else}
        <!-- 下架信息 -->
        <div id='productOffline'>对不起，该商品已下架</div>
    {/if}
</div>

{if $productInfo.product_online eq 1}
    <header class="Thead" id="vpd-detail-header">产品详情</header>
    <div id="vpd-content" class="notload">下拉加载详细介绍</div>
{/if}

<!-- 随便逛逛 -->
{if $slist}
    <header class="Thead">随便逛逛</header>
    <div id="pd-recoment">
        <div class='pd-box clearfix'>
            {foreach from=$slist item=sl}
                <a class="slist-item" href="{$docroot}?/vProduct/view/id={$sl.product_id}&showwxpaytitle=1">
                    <div class='pd-box-inner'>
                        <img src="{$sl.catimg}"
                             alt='{$sl.product_name}'/>
                        <p class='Elipsis'>{$sl.product_name}</p>
                        {*                                {if $sl.sale_prices ne '0.00'}
                        <span class="prices">&yen;{$sl.sale_prices * $entDiscount}</span>
                        {/if}*}
                    </div>
                </a>
            {/foreach}
        </div>
    </div>
{/if}

<!-- 加入购物车 -->
<div id="appCartWrap" class="clearfix">
    {if $productInfo.product_online eq 1}
        {if $productInfo.product_prom eq 0}<a class="button" id="addcart-button" data-prom="{$productInfo.product_prom}"
                                              data-add="1">加入购物车</a>{/if}
        <a class="button" id="buy-button" data-prom="{$productInfo.product_prom}" data-add="0"
           {if $productInfo.product_prom eq 1}style="width: 99%;"{/if}>立即购买</a>
    {else}
        <a class="button disable">已下架</a>
    {/if}
    <a id="toCart" href="?/Order/Cart/"><i>0</i></a>
</div>

{include file="../global/copyright.tpl"}
{*<script src="static/script/jquery-2.1.1.min.js"></script>*}
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
{strip}
    <script type="text/javascript">
        var productId = {$productid|default:0};
        var comId = parseInt({$comid|default:0});

        wx.config({
            debug: false,
            appId: '{$signPackage.appId}',
            timestamp: {if $signPackage.timestamp}{$signPackage.timestamp}{else}0{/if},
            nonceStr: '{$signPackage.nonceStr}',
            signature: '{$signPackage.signature}',
            jsApiList: ['previewImage', 'onMenuShareTimeline', 'onMenuShareAppMessage']
        });

        if (comId > 0) {
            var link = "http://" + window.location.host + "/?/vProduct/view/id=" + productId + "&showwxpaytitle=1&comid=" + comId;
        } else {
            var link = "http://" + window.location.host + "/?/vProduct/view/id=" + productId + "&showwxpaytitle=1";
        }

        wx.ready(function () {
            wx.onMenuShareTimeline({
                title: '{$productInfo.product_name}',
                link: '',
                imgUrl: '{$productInfo.catimg}',
                success: function () {

                }
            });
            wx.onMenuShareAppMessage({
                title: '{$productInfo.product_name}',
                desc: '{$productInfo.product_name}',
                link: link,
                imgUrl: '{$productInfo.catimg}',
                success: function () {

                }
            });
        });


    </script>
{/strip}
<script data-main="{$docroot}static/script/Wshop/shop_vproduct.js"
        src="/libs/jquery/require.min.js"></script>
</body>
</html>

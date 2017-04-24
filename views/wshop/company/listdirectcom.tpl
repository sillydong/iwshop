    <!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title> 下级合伙人- {$settings.shopname}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="format-detection" content="telephone=no">
        <link href="static/css/wshop_company_center.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
        <script type="text/javascript" src="static/script/main.js?v={$cssversion}"></script>
    </head>
    <body>
        <!-- <header class="bheader" id='comHead' style=''><span>直属合作人</span></header> -->
        <header class="Thead">直属合伙人 ( <b>{if $com_data['ucount']}{$com_data['ucount']}{else}0{/if}</b>位)</header>
        <div id="ulist">
            {foreach from=$com_data.ulist item=u}
                <section class="ulist clearfix">
                    <img src="{$u.client_head}/64" />
                    <div class="info">
                        <p>微信昵称：{if $u.client_nickname}<b>{$u.client_nickname}</b>{else}未知{/if} 真实姓名：<b>{$u.name}</b> 等级：<b>{$typename[$u.utype]}</b></p>
                        <p>加入日期：<b>{$u.jiondate}</b>  名下会员：{if $u.underucount}<b>{$u.underucount}</b>{else}0{/if} 人</p>
                    </div>
                    <div class="display:block;padding:5px;">
                    </div>
                </section>
            {/foreach}
        </div>
        {include file="../../global/footer.tpl"}
    </body>
</html>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>{$page.title}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="format-detection" content="telephone=no">
        <link href="{$docroot}static/css/wshop_gmess.css?{$cssversion}" type="text/css" rel="Stylesheet" />
        <link href="/favicon.ico" rel="Shortcut Icon" />
    </head>
    <body>
        <input type="hidden" id="msgid" value="{$page.id}" />
        <input type="hidden" id="share-img" value="{$page.catimg}" />
        <input type="hidden" id="share-desc" value="{$page.desc}" />
        <input type="hidden" id="share-title" value="{$page.title}" />
        <div id="wrapper">
            <div class="art-title">
				<h3>{$page.title}</h3>
				<div class="other">
					<span class="left">{$settings.shopname}</span>
                    <span class="right">{$page.createtime}</span>
				</div>
			</div>
            <div id="img-content">
				<img src="{$page.catimg}" class="topImage" />
            </div>
			<div id="img-content">
                {$page.content}
            </div>
            <div id='footer'>
                <p class='footer-p'>更多精彩内容，欢迎订阅本微信号</p>
                {if $settings.admin_setting_qrcode neq ''}
                    <img class='footer-logo' src="{$settings.admin_setting_qrcode}" />
                {elseif $settings.admin_setting_qrcode eq ''}
                    <img class='footer-logo' src='{$docroot}static/images/shop_qrcode.jpg' />
                {/if}
                <p class='footer-p'>长按二维码 - 识别图中二维码</p>
            </div>
        </div>
        <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
        <script type="text/javascript" src="{$docroot}static/script/Wshop/shop_gmess.js"></script>
    </body>
</html>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>会员登陆 - {$settings.shopname}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black" />
        <meta name="format-detection" content="telephone=no" />
        <link href="static/css/wshop_uc.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="static/script/jquery-2.1.1.min.js?v={$cssversion}"></script>
        <script type="text/javascript" src="static/script/main.js?v={$cssversion}"></script>
    </head>
    <body>
        {include file="../global/top_nav.tpl"}

        <div class="uc-headwrap" style='background-image: url(static/images/ucbag/bag{$bagRand}.jpg);'></div>

        <input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="referer" />
        <div id="login-wrap">
            <p class="field-ttip">手机号：</p>
            <div class="login-field clearfix">
                <i class="login-icon-account"></i>
                <div class="login-input">
                    <input type="text" id="acc" value="" tabindex="1" placeholder="手机号" autofocus required/>
                </div>
            </div>
            <p class="field-ttip">输入密码：</p>
            <div class="login-field clearfix">
                <i class="login-icon-password"></i>
                <div class="login-input">
                    <input type="password" id="pwd" value="" tabindex="2" placeholder="输入密码" required/>
                </div>
            </div>
        </div>
        <div id="login-com-wrap">
            <a class="button green" href="javascript:;" id="login-btn">马上登陆</a><br />
            <a class="reg-tip" href="{$docroot}?/Uc/balilinhai_signup/">还没有账号？现在注册</a>
        </div>
        {include file="../global/footer.tpl"}
        <script type="text/javascript">
            WeixinJSBridgeReady(UcloginLoad);
        </script>
    </body>
</html>
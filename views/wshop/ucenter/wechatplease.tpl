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
        <link href="static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="static/script/jquery-2.1.1.min.js?v={$cssversion}"></script>
    </head>
    <body>
        <div class="weui_msg">
            <div class="weui_icon_area"><i class="weui_icon_success weui_icon_msg"></i></div>
            <div class="weui_text_area">
                <h2 class="weui_msg_title">温馨提示</h2>
                <p class="weui_msg_desc">请在微信中访问</p>
            </div>
        </div>

        <script type="text/javascript">
            $(function(){
                $('#tip').height($(window).height()).css('line-height', $(window).height() + 'px');
            });
        </script>
    </body>
</html>
<!DOCTYPE HTML>
<html>

<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>我的零钱 - {$settings.shopname}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/wshop_uc_deposit.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
</head>

<body>

<div class="container">
    <div class="msg">
        <div class="weui_msg">
            <div class="weui_icon_area">
                <img src="static/images/icon/coins.png" alt="coins" class="msg-icon">
            </div>
            <div class="weui_text_area">
                <p class="weui_msg_desc">我的零钱</p>
                <h2>￥<span style="font-size: 35px">{$balance}</span></h2>
            </div>
            <div class="weui_opr_area">
                <p class="weui_btn_area">
                    <a href="javascript:;" onclick="location.href = '?/Uc/deposit';" class="weui_btn weui_btn_primary">充值</a>
                    <a href="javascript:;" onclick="location.href = '?/Uc/withdrawal';" class="weui_btn weui_btn_default">提现</a>
                    <a href="javascript:;" onclick="history.go(-1);" class="weui_btn weui_btn_default">返回</a>
                </p>
            </div>
        </div>
    </div>
</div>

</body>

</html>

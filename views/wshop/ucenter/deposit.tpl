<!DOCTYPE HTML>
<html>

<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>充值 - {$settings.shopname}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="static/css/weui/reset.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/wshop_uc_deposit.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
</head>

<body>

<div class="container">
    <div class="cell">
        <div class="bd">
            <div class="weui_cells weui_cells_form">
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">金额(￥)</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="number" pattern="[0-9]*" placeholder="请输入金额"
                               id="deposit_amount" value=""/>
                    </div>
                </div>
            </div>
            <div class="weui_btn_area">
                <a class="weui_btn weui_btn_primary" href="javascript:" id="next">下一步</a>
                <a href="javascript:;" onclick="history.go(-1);" class="weui_btn weui_btn_default">返回</a>
            </div>
        </div>
    </div>
</div>

<!-- 微信JSSDK -->
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>

<script type="text/javascript">
    wx.config({
        debug: false,
        appId: '{$signPackage.appId}',
        timestamp: {$signPackage.timestamp},
        nonceStr: '{$signPackage.nonceStr}',
        signature: '{$signPackage.signature}',
        jsApiList: ['chooseWXPay']
    });
</script>

<script type="text/javascript" src="static/script/Wshop/shop_deposit.js"></script>

</body>

</html>

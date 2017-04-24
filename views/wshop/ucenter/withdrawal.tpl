<!DOCTYPE HTML>
<html>

<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>提现 - {$settings.shopname}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="static/css/weui/reset.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/wshop_uc_deposit.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
</head>

<body>

<div class="container" ng-controller="withdrawalController" ng-app="ngApp" ng-cloak>
    <div class="cell">
        <div class="bd">
            <div class="weui_cells weui_cells_form">
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">银行名称</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="text" placeholder="请输入银行名称" ng-model="f.bankname"/>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">开户城市</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="text" placeholder="请输入开户城市" ng-model="f.city"/>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">开户区域</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="text" placeholder="请输入开户区域" ng-model="f.dist"/>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">开户支行</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="text" placeholder="请输入开户支行" ng-model="f.subbranch"/>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">银行卡号</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="text" placeholder="请输入银行卡号" ng-model="f.cardno"/>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">收款人</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="text" placeholder="请输入收款人" ng-model="f.username"/>
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd">
                        <label class="weui_label deposit-label">金额(￥)</label>
                    </div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="number" pattern="[0-9.]*" placeholder="可提现金额 &yen;{$balance}"  ng-model="f.amount"/>
                    </div>
                </div>
            </div>
            <div class="weui_btn_area">
                <a class="weui_btn weui_btn_primary" href="javascript:" ng-click="submit()">下一步</a>
                <a href="javascript:;" onclick="history.go(-1);" class="weui_btn weui_btn_default">返回</a>
            </div>
        </div>
    </div>
</div>

</body>

<script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/scripts/angularjs/angular.min.js"></script>
<script type="text/javascript" src="static/script/Wshop/shop_withdrawal.js"></script>

</html>

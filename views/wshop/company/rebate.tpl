<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>我的佣金 - {$settings.shopname}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}static/css/wshop_company_center.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="{$docroot}static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link rel="Stylesheet" type="text/css" href="/static/fontawesome/css/font-awesome.min.css"/>
</head>
<body ng-controller="companyRebatesController" ng-app="ngApp">

<div class="hd">
    <h1 class="page_title">我的佣金</h1>
</div>

{literal}
    <div class="weui_cells weui_cells_form" style="margin-top: 0">

        <div class="weui_tab" style="border-top: 1px solid #dedede">
            <div class="weui_navbar">
                <div class="weui_navbar_item" ng-class="{'weui_bar_item_on': mode == 0}" ng-click="mode = 0">
                    未结算佣金<i>（&yen;{{wait_amount}}）</i>
                </div>
                <div class="weui_navbar_item" ng-class="{'weui_bar_item_on': mode == 1}" ng-click="mode = 1">
                    已结算佣金<i>（&yen;{{pass_amount}}）</i>
                </div>
            </div>
            <div class="weui_tab_bd" ng-if="mode == 0">
                <section class="ulist clearfix" ng-repeat="user in rebate_list">
                    <img src="{{user.client_head}}/64"/>

                    <div class="info">
                        <p class="nickname">订单：<b>{{user.order_serial}}</b></p>

                        <p>时间：<b>{{user.rtime}}</b></p>
                    </div>
                    <div class="income-rank-amount ng-binding" ng-bind="'￥' + user.rebate_amount"></div>
                </section>
            </div>
            <div class="weui_tab_bd" ng-if="mode == 1">
                <section class="ulist clearfix" ng-repeat="user in rebated_list">
                    <img src="{{user.client_head}}/64"/>

                    <div class="info">
                        <p class="nickname">订单：<b>{{user.order_serial}}</b></p>

                        <p>时间：<b>{{user.rtime}}</b></p>
                    </div>
                    <div class="income-rank-amount ng-binding" ng-bind="'￥' + user.rebate_amount"></div>
                </section>
            </div>
        </div>
        <p class="weui_btn_area" style="margin: 15px;">
            <a href="?/Uc/withdrawal" class="weui_btn weui_btn_primary"><i class="fa fa-jpy" aria-hidden="true"></i> 申请提现</a>
            <a href="javascript:;" onclick="history.go(-1);" class="weui_btn weui_btn_default">返回</a>
        </p>
    </div>
{/literal}

{include file="../../global/copyright.tpl"}

<script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/scripts/angularjs/angular.min.js"></script>
<script type="text/javascript" src="static/script/Wshop/shop_company_rebate.js?v={$cssversion}"></script>

</body>
</html>

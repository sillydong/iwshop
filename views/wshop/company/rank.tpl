<!DOCTYPE HTML>
<html>

<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>收入排行 - {$settings.shopname}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}static/css/wshop_company_center.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="{$docroot}static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link rel="Stylesheet" type="text/css" href="/static/fontawesome/css/font-awesome.min.css"/>
</head>


<body ng-controller="companyRankController" ng-app="ngApp" ng-cloak>

<div class="hd">
    <h1 class="page_title">收入排行</h1>
</div>

{literal}
    <div class="weui_cells weui_cells_form" style="margin-top: 0">
        <section class="ulist clearfix" ng-repeat="user in ranklist" style="padding: 12px;">
            <div class="posr">
                <img src="{{user.uhead}}/132"/>
                <span class="rank-num" ng-bind="$index + 1"></span>
                <div class="info">
                    <p class="nickname">微信昵称：<b ng-bind="user.name"></b></p>
                    <p>加入日期：<span ng-bind="user.join_date"></span></p>
                </div>
                <div class="income-rank-amount" ng-bind="'￥' + user.income"></div>
            </div>
        </section>
    </div>
    <div class="weui_btn_area">
        <a href="javascript:;" style="background: #fff" onclick="history.go(-1);" class="weui_btn weui_btn_default">返回</a>
    </div>
{/literal} {include file="../../global/copyright.tpl"}

<script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/scripts/angularjs/angular.min.js"></script>
<script type="text/javascript" src="static/script/Wshop/shop_company_rank.js?v={$cssversion}"></script>

</body>

</html>

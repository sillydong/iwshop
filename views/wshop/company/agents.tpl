<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>我的代理 - {$settings.shopname}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}static/css/wshop_company_center.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="{$docroot}static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link rel="Stylesheet" type="text/css" href="/static/fontawesome/css/font-awesome.min.css"/>
</head>
<body ng-controller="companyAgentsController" ng-app="ngApp">

<div class="hd">
    <h1 class="page_title">我的代理</h1>
</div>

{literal}
    <div class="weui_cells weui_cells_form" style="margin-top: 0">
        <section class="ulist clearfix" ng-repeat="user in userlist">
            <img src="{{user.client_head}}/132"/>
            <div class="info">
                <p class="nickname">微信昵称：<b>{{user.client_nickname}}</b></p>
                <p>加入日期：<b>{{user.client_joindate}}</b></p>
            </div>
            <div class="display:block;padding:5px;">
            </div>
        </section>
    </div>
{/literal}

<div class="weui_btn_area">
    <a href="javascript:;" style="background: #fff" onclick="history.go(-1);" class="weui_btn weui_btn_default">返回</a>
</div>

{include file="../../global/copyright.tpl"}

<script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/scripts/angularjs/angular.min.js"></script>
<script type="text/javascript" src="static/script/Wshop/shop_company_agents.js"></script>

</body>
</html>

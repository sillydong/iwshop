<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>申请资料填写 - {$settings.shopname}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}static/css/wshop_companyreg.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="{$docroot}static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link rel="Stylesheet" type="text/css" href="/static/fontawesome/css/font-awesome.min.css"/>
    <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="{$docroot}static/script/main.js?v={$cssversion}"></script>
</head>
<body>

<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="referer"/>
<input type='hidden' value='{$head}' id='head'/>
<input type='hidden' value='{$sex}' id='sex'/>

<div class="hd">
    <h1 class="page_title">代理申请</h1>
</div>

<!-- from -->
<form id="login-wrap">
    <div class="weui_cells weui_cells_form" style="margin-top: 0">

        <div class="weui_cell">
            <div class="weui_cell_hd">
                <label class="weui_label">真实姓名</label>
            </div>
            <div class="weui_cell_bd weui_cell_primary">
                <input class="weui_input" id="set-form-name" placeholder="请填写真实姓名" />
            </div>
        </div>

        <div class="weui_cell">
            <div class="weui_cell_hd">
                <label class="weui_label">手机号</label>
            </div>
            <div class="weui_cell_bd weui_cell_primary">
                <input class="weui_input" type="tel" id="set-form-phone" placeholder="请填写手机号" />
            </div>
        </div>

        <div class="weui_cell">
            <div class="weui_cell_hd">
                <label class="weui_label">电子邮箱</label>
            </div>
            <div class="weui_cell_bd weui_cell_primary">
                <input class="weui_input" id="set-form-email" type="email" placeholder="请填写电子邮箱">
            </div>
        </div>

        {*<div class="weui_cell">*}
            {*<div class="weui_cell_hd">*}
                {*<label class="weui_label">身份证号</label>*}
            {*</div>*}
            {*<div class="weui_cell_bd weui_cell_primary">*}
                {*<input class="weui_input" id="set-form-id" type="text" placeholder="请填写身份证号">*}
            {*</div>*}
        {*</div>*}
    </div>
</form>
<div class="weui_btn_area">
    <a class="weui_btn weui_btn_primary" href="javascript:;" id="reg-btn"><i class="fa fa-send-o"></i> 提交申请</a>
    <a class="weui_btn weui_btn_default" style="background: #fff" href="?/Uc/home">返回</a>
</div>
{include file="../../global/copyright.tpl"}

<script data-main="static/script/Wshop/shop_companyreg.js?v={$cssversion}" src="static/script/require.min.js"></script>

</body>
</html>

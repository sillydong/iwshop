<!DOCTYPE html>
<html>
<head>
    <title>登录</title>
    <meta charset="utf-8"/>
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}favicon.ico" rel="Shortcut Icon"/>
    <link href="static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet"/>
    <link href="static/css/balilinhai_login.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
</head>
<body>

<div class="content"  style='background-image: url("{$docroot}static/images/backgrounds/login-bg.png")'>
    <form class="form" name="signin-form">
        <div class="input-group">
            <input type="text" id="signin-form-account" class="form-control" name="phone" placeholder="手机号">
        </div>
        <div class="input-group">
            <input type="password" id="signin-form-password" class="form-control" name="password" placeholder="密码">
        </div>
        <div class="btn-bottom">
            <a id="signin-btn" class="submit" href="javascript:void(0)">登录</a>
            <a href="{$docroot}?/Uc/balilinhai_signup">注册</a>
        </div>
    </form>
</div>

<script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="{$docroot}static/script/Wshop/balilinhai.js"></script>
</body>
</html>
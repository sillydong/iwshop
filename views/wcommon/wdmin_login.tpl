<script type="text/javascript">
    if (!+[1,]) {
        document.execCommand("Stop");
        location.href = '/html/noIe/';
    }
</script>
<!DOCTYPE html>
<html>
<head>
    <title>{$settings.shopname} - 管理后台</title>
    <meta charset="utf-8"/>
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="format-detection" content="telephone=no">
    <link href="{$docroot}favicon.ico" rel="Shortcut Icon"/>
    <link href="static/css/wshop_admin_login.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet"/>
</head>
<body class="loginBody">
<div id="login" class="clearfix" style="margin-top: 100px">
    <div class="login-form" id="login-frame" style="width: 500px;">
        <div id="loading" style="display:none;"></div>
        {if $settings.admin_setting_icon neq ''}
            <img src="{$settings.admin_setting_icon}" height="150px"/>
        {elseif $settings.admin_setting_icon eq ''}
            <img src="static/images/login/profle_1.png"/>
        {/if}

        <div class="text-left">

            <label>账号</label>

            <div class="input-group">
                <div class="input-group-addon"><span class="glyphicon glyphicon-user" aria-hidden="true"></span></div>
                <input type="text" class="form-control" id="pd-form-username" placeholder="请输入账号" autocomplete="off" />
            </div>

            <label>密码</label>

            <div class="input-group">
                <div class="input-group-addon"><span class="glyphicon glyphicon-lock" aria-hidden="true"></span></div>
                <input type="password" name="password" id="pd-form-password" class="form-control" placeholder="请输入密码" autocomplete="off" />
            </div>

        </div>

        <div class='login-item'>
            <a class="btn btn-success" href="javascript:;" id="login-btn">登录</a>
        </div>
        <div id="copyrights">{$settings.copyright}</div>
    </div>
</div>
<div style="display:none">{$settings.statcode}</div>
<script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="static/script/spin.min.js?v={$cssversion}"></script>
<script type="text/javascript" src="static/script/Wdmin/login.js?v={$cssversion}"></script>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="renderer" content="webkit">
    <title>{$settings.shopname} - 管理后台</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="{$docroot}favicon.ico" rel="Shortcut Icon"/>
    <link href="static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet"/>
    <link href="static/css/wshop_admin_index.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="/scripts/font-awesome.min.css" type="text/css" rel="Stylesheet"/>
    <script type="text/javascript" src="/scripts/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="/scripts/bootstrap/3.3.4/bootstrap.min.js"></script>
    <script type="text/javascript" src="{$docroot}static/script/Wdmin/wdmin.js?v={$cssversion}"></script>
</head>
<body class="wdmin-main" style="overflow:hidden;">
<!-- 管理控制台主页面 -->
<nav class="navbar navbar-default" id="navtop">
    <div class="container-lg">
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <div class="pull-left" style="line-height: 43px;color: #fff;padding-left: 10px;">{$settings.shopname} - 管理后台
                ({$today}) {$config.system_version}
            </div>
            <ul class="nav navbar-nav navbar-right">
                <!-- @see http://v3.bootcss.com/components/ -->
                <li class="topRightNavItem">
                    <a href="?/" target="_blank">商城首页</a>
                </li>
                <li class="topRightNavItem">
                    <a href="https://mp.weixin.qq.com/" target="_blank">微信公众平台</a>
                </li>
                <li class="topRightNavItem">
                    <a href="http://asw.iwshop.org/?/explore/category-1" target="_blank"><span
                                class="glyphicon glyphicon-fire" aria-hidden="true"></span>问题反馈</a>
                </li>
                <li class="topRightNavItem">
                    <a href="?/Wdmin/logOut/"><span class="glyphicon glyphicon-log-out" aria-hidden="true"></span>退出</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div id="wdmin-wrap">
    <div id="leftNav">{include file="./wdmin_navs.tpl"}</div>
    <div id="rightWrapper">
        <div id="main-mid">
            <div id="iframe_loading"><img src="static/images/icon/iconfont-loading-x64-green.png"/></div>
            <div id="__subnav__"></div>
            <iframe id="right_iframe" src="" width="100%" frameborder="0"></iframe>
        </div>
    </div>
</div>
</body>
</html>
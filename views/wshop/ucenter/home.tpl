<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv=Content-Type content="text/html;charset=utf-8"/>
    <title>个人中心 - {$settings.shopname}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="static/css/wshop_uc.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    <link href="static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    {*<link href="scripts/font-awesome.min.css" rel="Stylesheet" type="text/css" />底部广告去除*}
    <style>
        .weui_cell_hd {
            height: 25px;
            width: 25px;
            text-align: center;
            line-height: 25px;
        }

        .weui_cell_hd .fa{
            line-height: 25px;
        }

        .weui_cell_bd p {
            font-size: 14px;
            text-indent: 5px;
        }

        .weui_cell_ft {
            font-size: 12px;
        }

        .weui_cell_ft:after {
            top: 0 !important;
            border-width: 1px 1px 0 0 !important;
            border-color: #000 !important;
        }
    </style>
</head>
<body>

{include file="../../global/nav_bottom.tpl"}

{include file="../../global/ad/global_top.tpl"}

<div class="uc-headwrap" style='background-image: url({$settings.ucenter_background_image});'>
    <div class="uc-head">
        <a class="headwrap"><img src="{$userinfo.client_head}/132"/></a>
        <span class="uc-name">{$userinfo.client_nickname}</span>
        <span class="uc-addr">{$level.level_name} <b>#{$userinfo.client_id}</b></span>
    </div>
    <div class="comspreadstat clearfix">
        <span class="spread-item"
              onclick="location.href = '?/Uc/credit_exchange';"><b>{$userinfo.client_credit}</b>积分</span>
        <span class="spread-item"
              onclick="location.href = '?/Uc/balance';"><b>&yen;{$userinfo.client_money}</b>余额</span>
        <span class="spread-item" onclick="location.href = '?/Uc/envslist';"><b>{$count_envs}</b>红包</span>
        <span class="spread-item" onclick="location.href = '?/Uc/uc_likes';"><b>{$count_like}</b>收藏</span>
    </div>
</div>

<!-- home nav -->
<div class="uc-section" onclick="location.href = '?/Uc/orderlist';"><i
            class='dingdan'></i><b>查看全部订单</b>我的订单
</div>

<div class='uc-order-sec clearfix'>
    <a class='uc-order-btn fukuan' href="?/Uc/orderlist/status=unpay"><i></i>待付款<b class='prices'>{$count[0]}</b></a>
    <a class='uc-order-btn fahuo' href="?/Uc/orderlist/status=payed"><i></i>待发货<b class='prices'>{$count[1]}</b></a>
    <a class='uc-order-btn shouhuo' href="?/Uc/orderlist/status=delivering"><i></i>待收货<b class='prices'>{$count[2]}</b></a>
    <a class='uc-order-btn pinjia' href="?/Uc/orderlist/status=received"><i></i>待评价<b class='prices'>{$count[3]}</b></a>
    <a class='uc-order-btn tuikuan' href="?/Uc/orderlist/status=canceled"><i></i>退款/售后<b class='prices'>{$count[4]}</b></a>
</div>

{*判断代理功能是否打开*}
{if $companyOn eq 1}
    <div class="weui_cells weui_cells_access">
        {*判断是否为代理*}
        {if $userinfo.is_com eq 0}
            <a class="weui_cell" href="?/Company/companyRequest/">
                <div class="weui_cell_hd">
                    <i class="fa fa-send-o" style="color: #00b0f0" aria-hidden="true"></i>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p>成为代理</p>
                </div>
                <div class="weui_cell_ft">加入代理，共同成长</div>
            </a>
        {else}
            <a class="weui_cell" href="?/Company/home/">
                <div class="weui_cell_hd">
                    <i class="fa fa-user" aria-hidden="true"></i>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p>我的客户</p>
                </div>
                <div class="weui_cell_ft">客户：{$customer_count}人</div>
            </a>
            <a class="weui_cell" href="?/Company/agents/">
                <div class="weui_cell_hd">
                    <i class="fa fa-user" aria-hidden="true" style="color: #090"></i>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p>我的代理</p>
                </div>
                <div class="weui_cell_ft">代理：{$company_count}人</div>
            </a>
            <a class="weui_cell" href="?/Company/rebate/">
                <div class="weui_cell_hd">
                    <i class="fa fa-pie-chart" aria-hidden="true" style="color: #e4393c"></i>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p>我的佣金</p>
                </div>
                <div class="weui_cell_ft">总收益：&yen; {$income}</div>
            </a>
            <a class="weui_cell" href="?/Company/share/">
                <div class="weui_cell_hd">
                    <i class="fa fa-share-square-o" aria-hidden="true" style="font-size: 17px;"></i>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p>推广链接</p>
                </div>
                <div class="weui_cell_ft">一起来推广吧</div>
            </a>
            <a class="weui_cell" href="?/Company/rank/">
                <div class="weui_cell_hd">
                    <i class="fa fa-bar-chart" aria-hidden="true" style="font-size: 14px;"></i>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p>收入排行</p>
                </div>
                <div class="weui_cell_ft"></div>
            </a>
        {/if}
    </div>
{/if}

<div class="weui_cells weui_cells_access">
    <a class="weui_cell" href="?/Uc/uc_likes/">
        <div class="weui_cell_hd">
            <i class="fa fa-heart-o" aria-hidden="true"></i>
        </div>
        <div class="weui_cell_bd weui_cell_primary">
            <p>我的收藏</p>
        </div>
        <div class="weui_cell_ft">我喜欢，我收藏</div>
    </a>
    <a class="weui_cell" href="?/Uc/credit_exchange/">
        <div class="weui_cell_hd">
            <i class="fa fa-exchange" style="color: #090;" aria-hidden="true"></i>
        </div>
        <div class="weui_cell_bd weui_cell_primary">
            <p>积分兑换</p>
        </div>
        <div class="weui_cell_ft">您有{$userinfo.client_credit}积分可兑换</div>
    </a>
</div>

{include file="../../global/ad/uc_bottom.tpl"}

{include file="../../global/copyright.tpl"}

</body>
</html>

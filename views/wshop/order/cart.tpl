<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>{$title} - {$settings.shopname}</title>
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="format-detection" content="telephone=no" />
        <link href="{$docroot}static/css/wshop_cart.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <link href="{$docroot}static/css/base_animate.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="/scripts/crypto-md5.js"></script>
        <link href="{$docroot}static/script/lib/mobiscroll/css/mobiscroll.custom-2.17.1.min.css" rel="stylesheet" type="text/css"/>
        <link href="{$docroot}static/css/weui/weui.min.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
    </head>
    <body>

    {include file="../../global/top_nav.tpl"}

    {include file="../../global/ad/global_top.tpl"}

        <div id="addrPick"></div>
        <input type="hidden" id="promId" value="{$promId}" />
        <input type="hidden" id="promAva" value="{$promAva}" />
        <input type="hidden" id="payOn" value="{if !$config.order_nopayment}1{else}0{/if}" />
        <input type="hidden" id="addrOn" value="{if $config.wechatVerifyed && $config.useWechatAddr}1{else}0{/if}" />
        <input type="hidden" id="paycallorderurl" value="{$docroot}?/Order/ajaxCreateOrder" />

        <div class="weui_cells_title">收货信息</div>

        <!-- 收货地址 -->
        <div id="express-bar"></div>
        <div id="express_address" href="javascript:;">
            <div id="wrp-btn">点击选择收货地址</div>
            <div class="express-person-info clearfix">
                <div class="express-person-name">
                    <span id="express-name"></span><span id="express-person-phone"></span>
                </div>
            </div>
            <div class="express-address-info">
                <span id="express-address"></span>
            </div>
        </div>

        <div class="weui_cells_title">订单信息</div>

        <div id="orderDetailsWrapper" data-minheight="68px"></div>
         <div id="optinfo" class='hidden'>
            {if $envs|count > 0}
                <div class="weui_cells_title">红包折扣</div>
                <div id="userEnvsList">
                    {foreach from=$envs item=env}
                        <div id="uEnv-{$env.envid}" data-id="{$env.id}" class="envsItem" data-pid="{$env.pid}" data-req="{$env.req_amount}" data-dis="{$env.dis_amount}">
                            <span>{$env.name}({$env.pidx})</span>
                            <i></i>
                        </div>
                    {/foreach}
                    
                    
                </div>
            {/if}
          
            {if $settings.reci_open eq 1}
                <div class="weui_cells_title">发票信息</div>
                <div id="userReciInfo">
                    <div class='reciItem'>
                        <span style='border-bottom:none;'>是否开发票</span>
                        <i></i>
                    </div>
                    <div id='reciWrap'>
                        <div class="gs-text">
                            <input type="text" id="reci_head" placeholder="发票抬头" />
                        </div>
                        <div style="font-size: 12px;margin-top:10px;">发票内容：
                            {foreach from=$recis item=rec name=recn}
                                <input id='recis{$smarty.foreach.recn.index}' class='recis' name='reciopt[]' type='radio' value='{$rec}' {if $smarty.foreach.recn.index eq 0}checked{/if} /><label onclick='$("#recis{$smarty.foreach.recn.index}").click();'>{$rec}</label>
                            {/foreach}
                        </div>
                    </div>
                </div>
            {/if}
        </div>

        <div id="extra-field" style="display: none;">
            <div class="weui_cells_title">配送时间</div>

            <section class="orderopt" id="exptime-selector">
                <span class="label">配送时间</span>
                <span class="value" id="input-exptime-label">随时可以</span>
                <input type="text" id="input-exptime"/>
                <input type="hidden" id="exptime" value="随时可以"/>
            </section>

            <div class="weui_cells_title">订单备注</div>

            <div class="weui_cells weui_cells_form">
                <div class="weui_cell">
                    <div class="weui_cell_bd weui_cell_primary">
                        <textarea class="weui_textarea" placeholder="请输入订单备注" id="remark" rows="3"></textarea>
                        <div class="weui_textarea_counter"><span>0</span>/200</div>
                    </div>
                </div>
            </div>

            {if $userInfo.balance}
                <div class="weui_cells_title">使用余额</div>

                <div class="weui_cells weui_cells_form">
                    <div class="weui_cell weui_cell_switch">
                        <div class="weui_cell_hd weui_cell_primary" style="font-size: 12px">使用余额 &yen;{$userInfo.balance} 抵扣</div>
                        <div class="weui_cell_ft">
                            <input class="weui_switch" type="checkbox" id="cart-balance-check" />
                            <input type="hidden" value="{$userInfo.balance}" id="cart-balance-pay" />
                        </div>
                    </div>
                </div>
            {/if}

        </div>

        <!-- 订单总额 -->
        <div id="orderSummay" class='hidden'>
            {*<div>*}
                {*<input type="checkbox" id="cart-balance-check"/> 使用余额 <b id="cart-balance-pay">{$userInfo['balance']}</b>*}
            {*</div>*}
            <div>
                运费 : <b class="prices font13" id="order_expfee">&yen;0.00</b>
            </div>
            <div id="envsDisTip">
                红包 : <b class="prices font13" id="envs_amount">&yen;0.00</b>
            </div>
            <div id="reciTip">
                税费 : <b class="prices font13" id="reciTip_amount">&yen;0.00</b>
            </div>
            <div id="balanceTip">
                余额 : <b class="prices font13" id="balanceTip_amount">&yen;0.00</b>
            </div>
            <div>
                总价 : <b class="prices font13" id="order_amount_sig">&yen;0.00</b>
            </div>
            <div>
                总计 : <b class="prices" id="order_amount">&yen;0.00</b>
            </div>
        </div>

        {include file="../jstemplates/cart_list.php"}

        <!-- 微信支付按钮 -->
        <div class="button green" style='display: none' id="wechat-payment-btn"><b></b>微信安全支付</div>
        <!-- 微信JSSDK -->
        <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
        <!-- 微信JSSDK -->
        <script type="text/javascript">
            wx.config({
                debug: false,
                appId: '{$signPackage.appId}',
                timestamp: {$signPackage.timestamp},
                nonceStr: '{$signPackage.nonceStr}',
                signature: '{$signPackage.signature}',
                jsApiList: ['chooseWXPay','editAddress']
            });
            addrsignPackage = {$addrsignPackage};
        </script>

        <script data-main="{$docroot}static/script/Wshop/shop_cart.js?v={$smarty.now}" src="/libs/jquery/require.min.js"></script>

    
    
        {include file="../../global/copyright.tpl"}

    {include file="../../global/nav_bottom.tpl"}

    </body>
</html>

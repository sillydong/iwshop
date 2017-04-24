<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>代理信息修改 - {$settings.shopname}</title>
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="format-detection" content="telephone=no">
        <link href="{$docroot}static/css/wshop_companyreg.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <link href="{$docroot}static/css/weui/weui.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="{$docroot}static/script/jquery-2.1.1.min.js?v={$cssversion}"></script>
        <script type="text/javascript" src="{$docroot}static/script/main.js?v={$cssversion}"></script>
        <script type="text/javascript" charset="utf-8" src="{$docroot}static/script/validation/dist/jquery.validate.js"></script>
        <script type="text/javascript" charset="utf-8" src="{$docroot}static/script/validation/dist/lang-cn.js"></script>
    </head>
    <body>        
        <input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="referer" />
        <input type='hidden' value='{$openid}' id='openid' />

        <header class="bheader" id='comHead' style=''><span>资料修改</span></header>
        <header class="Thead">注意：银行卡（包括银行名称、账户和对应的收款人姓名）和支付宝请必须填写一项</header>

        <form id="login-wrap">
        <div class="weui_cells weui_cells_form">
            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">手机号</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" type="tel" id="set-form-phone" tabindex="1" value="{$cominfo.phone}" placeholder="请输入qq号">
                </div>
            </div>

            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">真实姓名</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="set-form-name" tabindex="2" value="{$cominfo.name}" placeholder="真实姓名">
                </div>
            </div>

            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">电子邮箱</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="set-form-email" tabindex="3" value="{$cominfo.email}"  placeholder="电子邮箱">
                </div>
            </div>

            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">身份证号</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="set-form-id" tabindex="4" value="{$cominfo.person_id}"  placeholder="身份证号">
                </div>
            </div>

            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">收款银行</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="set-form-bankname" tabindex="5" value="{$cominfo.bank_name}" placeholder="收款银行">
                </div>
            </div>

            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">收款账户</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="set-form-bankacc" tabindex="6" value="{$cominfo.bank_account}" placeholder="收款账户">
                </div>
            </div>

            <div class="weui_cell">
                <div class="weui_cell_hd">
                    <label class="weui_label">支付宝</label>
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <input class="weui_input" id="set-form-aliacc" tabindex="8" value="{$cominfo.alipay}" placeholder="支付宝账号">
                </div>
            </div>

        </div>
        </form>

        <div style="padding:10px 10px;">
            <a href="javascript:;" class="weui_btn weui_btn_primary" id="edit-btn">确认修改</a>
        </div>
        {include file="../global/footer.tpl"}
        <script type="text/javascript">
            WeixinJSBridgeReady(ComInfoEdit);
        </script>
    </body>
</html> 
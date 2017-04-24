{include file='../__header.tpl'}

<i id="scriptTag">{$docroot}static/script/Wdmin/settings/expcompany.js</i>

<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer" /> 
<div style="margin-bottom: 60px;padding: 10px 20px;">

    <input type="hidden" id="expcompany" value="{$settings.expcompany}" />

    <p class="Thead">设置配送处理人员</p>

    <div class="fv2Field clearfix" style="max-width: 100%;">
        <div class="fv2Right" id="couriers" style="margin-left: 0;" data-type="0">
            {foreach from=$exps_user item=usr}{if $usr.client_wechat_openid neq ''}<div class="usrItem" data-openid="{$usr.client_wechat_openid}"><b></b><img src="{$usr.client_head}/132" /><span class="Elipsis">{$usr.client_nickname}</span></div>{/if}{/foreach}
            <a class="usrItem add fancybox.ajax" id="add-couriers" href="{$docroot}?/WdminAjax/ajax_customer_select/" data-fancybox-type="ajax">
                <i></i>
                <span>点击添加</span>
            </a>
        </div>
    </div>

    <p class="Thead">设置订单通知人员</p>

    <div class="fv2Field clearfix" style="max-width: 100%;">
        <div class="fv2Right" id="notifyer" style="margin-left: 0;" data-type="1">
            {foreach from=$noti_user item=usr}{if $usr.client_wechat_openid neq ''}<div class="usrItem" data-openid="{$usr.client_wechat_openid}"><b></b><img src="{$usr.client_head}/132" /><span class="Elipsis">{$usr.client_nickname}</span></div>{/if}{/foreach}
            <a class="usrItem add fancybox.ajax" id="add-notifyer" href="{$docroot}?/WdminAjax/ajax_customer_select/" data-fancybox-type="ajax">
                <i></i>
                <span>点击添加</span>
            </a>
        </div>
    </div>

    <p class="Thead">设置常用快递公司 点击方块即可设置常用快递公司</p>

    <div class="fv2Field clearfix" style="max-width: 100%;">
        <div class="fv2Right" style="margin-left: 0;">
            <div class="clearfix">
                {foreach from=$exps item=exp key=k}
                    <a class="expitem" data-k="{$k}" href="javascript:;" style="margin-top:5px;padding: 8px;">{$exp}</a>
                {/foreach}
            </div>
        </div>
    </div>

</div>

<script id="t:usrlist" type="text/html">
    {literal}
        <%for(var i=0;i<list.length;i++){%>
            <div class="usrItem" data-openid="<%=list[i].openid%>"><b></b><img src="<%=list[i].src%>" /><span class="Elipsis"><%=list[i].uname%></span></div>
            <%}%>
        {/literal}
    </script>

<div class="fix_bottom fixed">
    <a class="wd-btn primary" id='saveBtn' style="width:150px" href="javascript:;">保存设置</a>
</div>

{include file='../__footer.tpl'}
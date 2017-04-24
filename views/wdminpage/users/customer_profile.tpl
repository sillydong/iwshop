{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/customers/customer_profile.js</i>
<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer" /> 
<div class="clearfix" style="background: #fafafa;">
    <div id="us-profile-left" style="width: 296px;">
        <div style='padding:22px;'>
            <div class="user-edit-headw">
                <img class="user-edit-head {if $c.client_head eq ''}default{/if}" src="{if $c.client_head eq ''}{$docroot}static/images/login/profle_1.png{else}{$c.client_head}/{/if}" />
            </div>
            <p><em>真实姓名：</em>{$c.client_name}</p>
            <p><em>电子邮箱：</em>{$c.client_email}</p>
            <p><em>联系电话：</em>{$c.client_phone}</p>
            <p><em>所在省市：</em>{$c.client_province}{$c.client_city}</p>
            <p><em>详细地址：</em>{$c.client_address}</p>
            <p><em>身份证号：</em>{$c.client_personid}</p>
            <p><em>注册日期：</em>{$c.client_joindate}</p>
            <p><em>所属代理：</em>{$c.company_name}</p>
            <p style="font-size:12px;line-height: 24px;"><em>openId：</em><br />{$c.client_wechat_openid}</p>
        </div>
    </div>
    <div id="us-profile-right">
        <iframe id="iframe_customer_orders" src="?/WdminPage/list_customer_orders/id={$c.client_id}" style="display: block;" width="100%" frameborder="0"></iframe>
    </div>
</div>
<div class="fix_bottom fixed">
    <a onclick="location.href = $('#http_referer').val();" class="wd-btn default">返回</a>
</div>
{include file='../__footer.tpl'} 
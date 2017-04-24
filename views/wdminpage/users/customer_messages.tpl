{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/customers/customer_message.js?v={$cssversion}</i>
<div class="clearfix">
    <div id="categroys" style="padding:0;width:250px;">
        <div style="margin-top:45px;">
            {foreach from=$msgs item=msg}
                <div data-openid="{$msg.openid}" data-id="{$msg.id}" class="list-user-group-item umslist Elipsis">
                    <span class="iw">
                        <img src="{if $msg.headimg}{$msg.headimg}/64{else}static/images/login/profle_1.png{/if}" srcset="{$msg.headimg}/128 2x" />
                        <i>{$msg.unread}</i>
                    </span>
                    <div class="r">
                        <span class="Elipsis">{if $msg.client_name}{$msg.client_name}{else}{$msg.openid}{/if}</span>
                        <p class="Elipsis">{$msg.undesc}</p>
                    </div>
                </div>
            {/foreach}
        </div>
    </div>
    <div id="cate_settings" style="margin-left:250px;">
        <div id="iframe_loading" style="top:0;"></div>
        <iframe id="iframe_msgsession" src="" style="display: block;" width="100%" frameborder="0"></iframe>
    </div>
</div>
{include file='../__footer.tpl'} 
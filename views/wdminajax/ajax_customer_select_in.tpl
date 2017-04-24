{foreach from=$list item=pd}
    <div class="pdBlock" data-id="{$pd.client_id}" data-openid="{$pd.client_wechat_openid}">
        <a class="sel"></a>
        <img height="100" width="100" src="{if $pd.client_head eq ''}{$docroot}static/images/login/profle_1.png{else}{$pd.client_head}/132{/if}" />
        <p class="title Elipsis" style="text-align: center;">{$pd.client_nickname}</p>
    </div>
{/foreach}
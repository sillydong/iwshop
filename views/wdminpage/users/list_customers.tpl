{include file='../__header.tpl'}
<i id="scriptTag">page_list_customers</i>
<div class="clearfix">
    <div id="categroys" style="padding:0;width:150px;">
        <div style="margin-top:45px;">
            {foreach from=$group item=g name=groupn}
                <div data-id="{$g.id}" class="list-user-group-item Elipsis{if $smarty.foreach.groupn.first} selected{/if}">
                    {$g.level_name}<em>({$g.count})</em>
                </div>
            {/foreach}
        </div>
    </div>
    <div id="cate_settings" style="margin-left:150px;">
        <iframe id="iframe_customer" src="" style="display: block;" width="100%" frameborder="0"></iframe>
    </div>
</div>
{include file='../__footer.tpl'} 
<div id="GmessSelect" class="clearfix">
    {foreach from=$gmess item=gm}
        <div class="gmBlock" data-id="{$gm.id}">
            <a class="sel hov"></a>
            <p class="title Elipsis">{$gm.title}</p>
            <img src="{$gm.catimg}" />
            <p class="desc Elipsis">{$gm.desc}</p>
        </div>
    {/foreach}
</div>
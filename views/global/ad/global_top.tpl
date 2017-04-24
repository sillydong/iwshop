{if $globalBanner}
    {foreach from=$globalBanner item=banner}
        <a href="{$banner.link}"><img class="gBanner" src="{$banner.banner_image}" /></a>
    {/foreach}
{/if}
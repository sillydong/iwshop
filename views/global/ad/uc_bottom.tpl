{if $ucBanners}
    {foreach from=$ucBanners item=banner}
        <a href="{$banner.link}"><img class="gBanner" src="{$banner.banner_image}" /></a>
    {/foreach}
{/if}
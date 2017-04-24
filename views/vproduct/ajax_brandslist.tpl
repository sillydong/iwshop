<div class="clearfix" style="padding:0 10px;padding-right: 0;margin-bottom: 6px;">
    {foreach from=$brands item=br}
        {if $br.brand_img2 neq ''}
            <a class="subcatBrand" href="?/Brands/vBrand/id={$br.id}"><img src="{if $config.oss}{$br.brand_img2}{else}{$config.shoproot}uploads/brands/{$br.brand_img2}{/if}" /></a>
        {/if}
    {/foreach} 
</div>
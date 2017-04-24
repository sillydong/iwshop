{if $brands}
    <div class="clearfix" style="margin-bottom: 6px;">
        {foreach from=$brands item=br}
            {if $br.brand_img2 neq ''}
                <a class="subcatBrand" href="?/Brands/vBrand/id={$br.id}"><img src="uploads/brands/{$br.brand_img2}"/></a>
            {/if}
        {/foreach}
    </div>
{/if}
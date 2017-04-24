<div style="margin: 0 10px;">
    {include file="./cat_brands_list.tpl"}
</div>
{foreach from=$products item=pd}
    <section class="productListWrap hoz" onclick="location = '{$docroot}?/vProduct/view/id={$pd.product_id}&showwxpaytitle=1';">
        <a class="productList{if $stype ne 'hoz'} clearfix{/if}">
            <img src="{if $config.usecdn}{$config.imagesPrefix}product_hpic/{$pd.catimg}_x200{else if $config.oss}{$pd.catimg}{else}static/Thumbnail/?w=200&h=200&p={$config.productPicLink}{$pd.catimg}{/if}" />           
            <section>
                <title class="title">{$pd.product_name}</title>
                <span class='prices'>&yen;{$pd.sale_prices}</span>
            </section>
        </a>
    </section>
{/foreach}
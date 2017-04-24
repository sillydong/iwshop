{strip}{if $pdloaded ne 0}
        <div class="clearfix" style="border-bottom: 1px solid #dedede;background: #fff;padding-bottom: 5px;">
            {foreach from=$categorys item=sc}
                {if $sc.cat_name ne '' and $sc.pd|@count neq 0}
                    <a class="subcat_item f1" href="#cat{$sc.cat_id}">
                        <img src='{$docroot}{$sc.cat_image}' />
                        <span class="block">{$sc.cat_name}</span>
                    </a>
                {/if}
            {/foreach}
        </div>
        {foreach from=$categorys item=cate}
            {if $cate.cat_name ne '' and $cate.pd|@count neq 0}
                <header class="serialCaption {$stype}" id="cat{$cate.cat_id}"><span>{$cate.cat_name}</span></header>
                <div class="clearfix pdBlock">
                    {foreach from=$cate.pd item=pd}
                        <section class="productListWrap {$stype} {if $cate.s}patch{/if}" onclick="location = '{$docroot}?/vProduct/view/id={$pd.product_id}&showwxpaytitle=1';">
                            <a class="productList{if $stype ne 'hoz'} clearfix{/if}">
                                <img class="photo" src="{if $config.oss}{$pd.catimg}{else}{$config.imagesPrefix}product_hpic/{$pd.catimg}_x200{/if}" />           
                                <section>
                                    <title class="title{if $stype eq 'hoz'} Elipsis{/if}">{$pd.product_name}</title>
                                    <span class='prices'>&yen;{$pd.sale_prices}{if $pd.market_price neq ''}<i>&yen;{$pd.market_price}</i>{/if}</span>
                                </section>
                            </a>
                        </section>
                    {/foreach}
                </div>
            {/if}
        {/foreach}
{else}0{/if}{/strip}
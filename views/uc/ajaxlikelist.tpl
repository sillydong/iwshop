{strip}{if $loaded > 0}<div class="clearfix pdBlock">
            {foreach from=$likeList item=pd}
                {if $pd.product_name neq ''}
                    <section class="productListWrap hoz">
                        <a class="productList clearfix" href='{$docroot}?/vProduct/view/id={$pd.product_id}&showwxpaytitle=1'>
                            <img class="photo" src="{$pd.catimg}" />
                            <section>
                                <title class="title{if $stype eq 'hoz'} Elipsis{/if}">{$pd.product_name}</title>
                                <span class='prices'>&yen;{$pd.sale_prices}</span>
                            </section>
                        </a>
                    </section>
                {/if}
            {/foreach}
        </div>
    {else}
        0
{/if}{/strip}
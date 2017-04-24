{foreach from=$products item=pd}
    <div class="pdBlock" data-id="{$pd.product_id}">
        <a class="sel"></a>
        <p class="title Elipsis">{$pd.product_name}</p>
        <img height="100" width="100" src="{$pd.catimg}" />
        <p class="prices Elipsis">{$pd.sale_prices}</p>
    </div>
{/foreach}

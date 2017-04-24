{section name=pi loop=$product_list}
    <section class="productListWrap" onclick="location = '?/vProduct/view/id={$product_list[pi].product_id}&showwxpaytitle=1';">
        <a class="productList clearfix">
            <div class="productIW" style="background-image: url('/static/product_hpic/{$product_list[pi].catimg}');"></div>
            <div class="productListDesc">
                <p class="title">{$product_list[pi].product_name}</p>
                <p class="prices">&yen; {$product_list[pi].sale_prices}</p>
            </div>
        </a>
    </section>
{/section}
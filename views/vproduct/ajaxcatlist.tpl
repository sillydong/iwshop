{*<div class="cat-prom">
<a href="/"><img src="{$docroot}static/images/slider/5474296eN70b1d952.jpg" /></a>
</div>*}
<!-- subcat -->
<div class="subcat_wrapp clearfix">
    {include file="./cat_brands_list.tpl"}
    <div class="clearfix">
        {foreach from=$subcat item=sc}
            {if $sc.child}
                <div class="subcat_caption"><span>{$sc.cat_name}</span></div>
                <div class="clearfix">
                    {foreach from=$sc.child item=child}
                        <a class="subcat_item" style="padding-bottom: 0"
                           href="{$docroot}?/vProduct/view_list/cat={$child.cat_id}">
                            <img src='{$child.cat_image}' />
                            <span class="Elipsis block font12">{$child.cat_name}</span>
                        </a>
                    {/foreach}
                </div>
            {else}
                <a class="subcat_item" style="padding-bottom: 0"
                   href="{$docroot}?/vProduct/view_list/cat={$sc.cat_id}">
                    <img src='{$sc.cat_image}' />
                    <span class="Elipsis block font12">{$sc.cat_name}</span>
                </a>
            {/if}
        {/foreach}
    </div>
</div>
<!-- subcat -->
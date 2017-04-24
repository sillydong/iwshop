{foreach from=$cats item=cat}
    <a class="catSugg Elipsis" href="?/vProduct/view_list/cat={$cat.cat_id}">{$cat.cat_name}</a>
{/foreach}
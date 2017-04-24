<form class="search-w-box" action='#' onsubmit='searchdo(this);
        return false;'>
    <input type="search" 
           name="search" 
           id="searchBox"
           targ="vProduct/view_list/cat={$cat}"
           class="search-w-input"
           value="{if $searchkey}{$searchkey}{/if}"
           placeholder="搜一搜，找到你想要的" />
{*    <a class="listTopArrow uchome search" href="javascript:;" onclick="location = '{$docroot}?/Uc/home';"></a>*}
</form>
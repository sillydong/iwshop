<div class="bottom_nav">
    <a class="nav_index {if $controller eq 'Index'}hover{/if}" href="{$docroot}"><i></i>首页</a>
    <a class="nav_search {if $controller eq 'vProduct'}hover{/if}" href="{$docroot}?/vProduct/view_category/"><i></i>分类</a>
    <a class="nav_shopcart {if $controller eq 'Order'}hover{/if}" href="{$docroot}?/Order/cart"><i></i>购物车</a>
    <a class="nav_me {if $controller eq 'Uc' or $controller eq 'Company'}hover{/if}" href="{$docroot}?/Uc/home"><i></i>我</a>
</div>
{strip}
    {ldelim}'data':[
    {foreach item=oi from=$list}
        [ "{$oi.product_id}"
        , "<div><img class='pdlist-image' id='pdlist-image{$oi.product_id}' src='{if $oi.catimg eq ''}{$docroot}static/images/icon/iconfont-pic.png{else}{$docroot}static/Thumbnail/?w=50&h=50&p=/uploads/product_hpic/{$oi.catimg}{/if}' /></div>"
        , "{$oi.product_name|truncate:40:'...'}"
        , "{$oi.cat_name}"
        {if !$iscom}, "{$oi.product_code}"{/if}
        , "{$oi.brand_name}"
        , "&yen;{$oi.sale_prices}"
        , "{$oi.product_readi}次"
        , "
        <a class='pd-qrcodebtn fancybox.ajax' data-fancybox-type='ajax' href='?/WdminPage/product_share_qrcode/id={$oi.product_id}' data-product-id='{$oi.product_id}'>二维码</a>&nbsp;
        <a class='pd-altbtn' href='?/WdminPage/iframe_alter_product/mod=edit&id={$oi.product_id}' data-product-id='{$oi.product_id}'>编辑</a>&nbsp;
        <a class='pd-altbtn pd-switchonline {if $oi.product_online eq 1}tip{/if}' href='javascript:;' data-product-id='{$oi.product_id}' data-product-online='{$oi.product_online}'>{if $oi.product_online eq 1}下架{else}上架{/if}</a>&nbsp;
        <a class='pd-altbtn pd-del-btn del' href='javascript:;' data-product-id='{$oi.product_id}'>删除</a>"
        ]{if !$oi@last},{/if}
    {/foreach}],
    'count':{$listCount}
{rdelim}{/strip}
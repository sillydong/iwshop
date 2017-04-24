{foreach item=oi from=$list}
    <tr class="defTr font12">
        <td class="hidden">{$oi.product_id}</td>
        <td>
            <img class='pdlist-image' height="50" width="50" src="{if $oi.catimg eq ''}{$docroot}static/images/icon/iconfont-pic.png{else}{$docroot}static/Thumbnail/?w=50&h=50&p={$config.productPicLink}{$oi.catimg}{/if}" />
        </td>
        <td>{$oi.product_name|truncate:150:"..."}</td>
        <td>{$oi.product_code}</td>
        <td>{$oi.brand_name}</td>
        <td class="prices font12">&yen;{$oi.sale_prices}</td>
        <td>{$oi.product_readi}</td>
        <th>
            <a class='pd-qrcodebtn fancybox.ajax' data-fancybox-type='ajax' href='?/WdminPage/product_share_qrcode/id={$oi.product_id}' data-product-id='{$oi.product_id}'>二维码</a>&nbsp;
            <a class='pd-altbtn' href='?/WdminPage/iframe_alter_product/mod=edit&id={$oi.product_id}' data-product-id='{$oi.product_id}'>编辑</a>&nbsp;
            <a href="javascript:;" onclick="parent.parent.window.open('?/vProduct/view/id={$oi.product_id}');">预览</a>
            <a class='pd-altbtn pd-switchonline {if $oi.product_online eq 1}tip{/if}' href='javascript:;' data-product-id='{$oi.product_id}' data-product-online='{$oi.product_online}'>{if $oi.product_online eq 1}下架{else}上架{/if}</a>&nbsp;
            <a class='pd-altbtn pd-del-btn del' href='javascript:;' data-product-id='{$oi.product_id}'>删除</a>
        </th>
    </tr>
{/foreach}
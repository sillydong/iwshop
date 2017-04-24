{foreach item=oi from=$list}
    <tr class="defTr font12">
        <td>
            <img class='pdlist-image' src="{if $oi.catimg eq ''}{$docroot}static/images/icon/iconfont-pic.png{else}{$docroot}static/Thumbnail/?w=50&h=50&p=/static/product_hpic/{$oi.catimg}{/if}" />
        </td>
        <td>{$oi.product_name|truncate:150:"..."}</td>
        <td class="prices">&yen;{$oi.sale_prices}</td>
        <td>{$oi.cat_name}</td>
        <td>{$oi.readi}</td>
        <td>{$oi.turned}</td>
        <td class="prices">{$oi.turnrate}%</td>
        {*        <td>
        <a href='{$oi.qrcode}' target="_blank" title='点击查看大图'><img class='pdlist-image' src='{$oi.qrcode}' /></a>
        </td>*}
        <td><a class='pd-qrcodebtn fancybox.ajax' data-fancybox-type='ajax' href='?/WdminPage/product_share_qrcode/id={$oi.product_id}' data-product-id='{$oi.product_id}'>推广二维码</a></th>
</tr>
{/foreach}
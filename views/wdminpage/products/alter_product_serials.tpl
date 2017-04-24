{include file='../__header.tpl'}
<i id="scriptTag">page_alter_product_serials</i>
<div class="clearfix">
    <div id="categroys" style='padding:0;width:229px;'>
        <table id='serialTable'>
            <tbody>
                {foreach from=$list item=l}
                    <tr>
                        <td>
                            <a class='font14 alt-serial-item' data-id='{$l.id}' href='javascript:;'>{$l.serial_name}</a>
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
        <div class="fix_bottom fixed" style="width:199px;">
            <a id="add_category_btn" class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax" 
               href="{$docroot}views/wdminpage/products/add_category.html">添加系列</a>
        </div>
    </div>
    <div id="cate_settings">
        <div id="iframe_loading" style="top:0;"></div>
        <iframe id="iframe_alterserial" src="" width="100%" frameborder="0"></iframe>
    </div>
</div>
{include file='../__footer.tpl'} 
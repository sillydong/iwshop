{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/products/page_alter_brand.js</i>
<div class="clearfix" style="padding:15px;padding-bottom: 45px;">
    <form style="padding:10px;" id="catForm">
        <input type="hidden" value="{$id}" id="brandid" />
        <input type="hidden" value="{$cat.brand_cat}" id="cat_parent" />
        <div style="width:30%;margin-bottom: 10px;">

            <div class="gs-label">品牌名称</div>
            <div class="gs-text">
                <input type="text" name="brand_name" id='cat_name' value="{$cat.brand_name}" />
            </div>

            <div class="gs-label">品牌排序</div>
            <div class="gs-text">
                <input type="text" name="sort" id='cat_order' value="{$cat.sort}" />
            </div>

            <div class="gs-label">对应分类</div>
            <select id="pd-cat-select" style="color:#666" name="brand_cat">
                <option value="0">默认</option>
                {foreach from=$categorys item=cat1}
                    <option value="{$cat1.dataId}" {if $cat.brand_cat eq $cat1.dataId}selected{/if} >{$cat1.name}</option>
                    {foreach from=$cat1.children item=cat2}
                        <option value="{$cat2.dataId}" {if $cat.brand_cat eq $cat2.dataId}selected{/if} >-- {$cat2.name}</option>
                        {foreach from=$cat2.children item=cat3}
                            <option value="{$cat3.dataId}" {if $cat.brand_cat eq $cat3.dataId}selected{/if} >---- {$cat3.name}</option>
                        {/foreach}
                    {/foreach}
                {/foreach}
            </select>

        </div>
                
        <br />
        
        <div class="gs-label">品牌Logo <b>建议使用300&times;170尺寸的图片</b></div>
        <div class="clearfix">
            <div class="alter-cat-img left" style="min-width: 30%;">
                <input type="hidden" value="{$cat.brand_img2}" id="brand_img2" name="brand_img2" />
                <img id="catimage2" src="{$cat.brand_img2}" />
                {if $cat.brand_img2 eq ''}
                    <div style='line-height: 100px;color:#777;' class='align-center' id="cat_none_pic2">无图片</div>
                {/if}
                <div class="align-center top10">
                    <a class="wd-btn primary" id="alter_categroy_image2" href="javascript:;">更换图片</a>
                </div>
            </div>
        </div>

    </form>
    <div class="fix_bottom fixed">
        <a class="wd-btn primary" id='save-cate'>保存</a>
        <a class="wd-btn delete" id="del-cate">删除</a>
    </div>
</div>
{include file='../__footer.tpl'} 
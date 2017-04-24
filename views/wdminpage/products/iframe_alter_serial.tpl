{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/products/iframe_alter_serial.js</i>
<div class="clearfix" style="padding:15px;padding-bottom: 45px;">
    <input type="hidden" value="{$serial.id}" id="sid" />
    <form style="padding:10px;" id='alter_serial'>
        <div class="fv2Field clearfix">
            <div class="fv2Left">
                <span>系列名称</span>
            </div>
            <div class="fv2Right">
                <input class='gs-input' type="text" name="serial_name" value="{$serial.serial_name}" />
                <div class='fv2Tip'>商品系列的名称</div>
            </div>
        </div>
        <div class="fv2Field clearfix">
            <div class="fv2Left">
                <span>序号</span>
            </div>
            <div class="fv2Right">
                <input class='gs-input' type="text" name="sort" value="{$serial.sort}" />
                <div class='fv2Tip'>排序序号，数字越大排序越前</div>
            </div>
        </div>
        <div class="fv2Field clearfix">
            <div class="fv2Left">
                <span>关联分类</span>
            </div>
            <div class="fv2Right">
                <select id="pd-cat-select" style="color:#666" name="relcat">
                    {foreach from=$categorys item=cat1}
                        <option value="{$cat1.dataId}" {if $serial.relcat eq $cat1.dataId}selected{/if}>{$cat1.name}</option>
                        {foreach from=$cat1.children item=cat2}
                            <option value="{$cat2.dataId}" {if $serial.relcat eq $cat2.dataId}selected{/if}>-- {$cat2.name}</option>
                            {foreach from=$cat2.children item=cat3}
                                <option value="{$cat3.dataId}" {if $serial.relcat eq $cat3.dataId}selected{/if}>---- {$cat3.name}</option>
                            {/foreach}
                        {/foreach}
                    {/foreach}
                </select>
                <div class='fv2Tip'>系列关联的最高级分类</div>
            </div>
        </div>
        <div class="fv2Field clearfix">
            <div class="fv2Left">
                <span>关联级别</span>
            </div>
            <div class="fv2Right">
                <input class='gs-input' type="text" name="relevel" value="{$serial.relevel}" />
                <div class='fv2Tip'>系列关联分类的层级</div>
            </div>
        </div>
        <div class="fv2Field clearfix" style="max-width: 70%;">
            <div class="fv2Left">
                <span>系列图片</span>
            </div>
            <div class="fv2Right">
                <div class="clearfix">
                    <div class="alter-cat-img left">
                        <input type="hidden" value="{$serial.serial_image}" name='serial_image' id="cat_image_src" />
                        <img id="catimage" src="{$docroot}uploads/banner/{$serial.serial_image}" />
                        {if $serial.serial_image eq ''}
                            <div style='line-height: 100px;color:#777;' class='align-center' id="cat_none_pic">无图片</div>
                        {/if}
                        <div class="align-center top10">
                            <a class="wd-btn primary" id="alter_categroy_image" href="javascript:;">更换图片</a>
                        </div>
                    </div>
                </div>
                <div class='fv2Tip'>建议使用200×200正方形图片</div>
            </div>
        </div>
    </form>
    <div class="fix_bottom fixed">
        <a class="wd-btn primary" id='save-cate'>保存</a>
        <a class="wd-btn delete" id="del-cate">删除</a>
    </div>
</div>
{include file='../__footer.tpl'} 
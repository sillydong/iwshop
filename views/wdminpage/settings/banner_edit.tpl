{include file='../__header.tpl'}
<link href="{$docroot}static/css/jquery.datetimepicker.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/banner_edit.js</i>
<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer" /> 
<input type="hidden" value="{$banner.relid}" id="relid" /> 
<input type="hidden" value="{$banner.reltype}" id="relType" /> 
<div class="clearfix" style="padding:10px 20px;padding-bottom: 65px;">
    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>滚动图名称</span>
        </div>
        <div class="fv2Right">
            <input class='gs-input' type="text" name="cat_name" id='cat_name' value="{$banner.banner_name}" />
            <div class='fv2Tip'>滚动图的名称</div>
        </div>
    </div>
    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>排序</span>
        </div>
        <div class="fv2Right">
            <input class='gs-input' type="text" name="cat_order" id='cat_order' value="{$banner.sort}" />
            <div class='fv2Tip'>数字越大排序越前</div>
        </div>
    </div>
    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>对应类型</span>
        </div>
        <div class="fv2Right">
            <select id="bn-type" style="color:#666">
                <option value="0" data-hash="hashCat" {if $banner.reltype eq 0}selected{/if}>产品分类</option>
                <option value="1" data-hash="hashProduct" {if $banner.reltype eq 1}selected{/if}>产品列表</option>
                <option value="2" data-hash="hashGmess" {if $banner.reltype eq 2}selected{/if}>图文消息</option>
                <option value="3" data-hash="hashLink" {if $banner.reltype eq 3}selected{/if}>超链接</option>
            </select>
            <div class='fv2Tip'>滚动图对应跳转的类型，可以是一到多个产品，也可以是某个产品分类，也可以是某个图文消息</div>
        </div>
    </div>

    <!-- 超链接 -->
    <div class="typeHash hidden" id="hashLink">
        <div class="fv2Field clearfix">
            <div class="fv2Left">
                <span>链接地址</span>
            </div>
            <div class="fv2Right">
                <input class='gs-input' type="text" name="link_address" id='link_address' value="{$banner.banner_href}" />
                <div class='fv2Tip'>滚动图链接的地址</div>
            </div>
        </div>
    </div>

    <!-- 图文对应 -->
    <div class="fv2Field typeHash clearfix hidden" id="hashGmess">
        <div class="fv2Left">
            <span>选择图文</span>
        </div>
        <div class="fv2Right">
            <a id="sGmess" href="?/WdminPage/ajax_gmess_list/" class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax" style="margin:0;width:100%;" data-id="">选择素材</a>
            <div id="GmessItem" class="clearfix">
                {if $gm}
                    <div class="gmBlock" data-id="{$gm.id}">
                        <a class="sel hov"></a>
                        <p class="title Elipsis">{$gm.title}</p>
                        <img src="{$docroot}uploads/gmess/{$gm.catimg}" />
                        <p class="desc Elipsis">{$gm.desc}</p>
                    </div>
                {/if}
            </div>
            <div class='fv2Tip' id="gmessTip">请点击选择图文素材</div>
        </div>
    </div>

    <!-- 商品对应 -->        
    <div class="fv2Field typeHash clearfix hidden" id="hashProduct" style="max-width:100%;">
        <div class="fv2Left">
            <span>选择产品</span>
        </div>
        <div class="fv2Right">
            <a id="sProduct" href="?/FancyPage/ajaxSelectProduct/" class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax" style="margin:0;width:389px;" data-id="">选择产品</a>
            <div class='fv2Tip hidden' id="spdCount">已选择100个产品</div>
            <div id="ProductItem" class="clearfix">
                {if $products}
                    {include file='../fancy/ajaxPdBlocks.tpl'}
                {/if}
            </div>
            <div class='fv2Tip' id="spdTip">请点击选择产品</div>
        </div>
    </div>

    <!-- 分类对应 -->
    <div class="fv2Field typeHash clearfix hidden" id="hashCat">
        <div class="fv2Left">
            <span>选择分类</span>
        </div>
        <div class="fv2Right">
            <select id="pd-cat-select" style="color:#666">
                {foreach from=$categorys item=cat1}
                    <option value="{$cat1.dataId}" {if $banner.relid eq $cat1.dataId}selected{/if}>{$cat1.name}</option>
                    {foreach from=$cat1.children item=cat2}
                        <option value="{$cat2.dataId}" {if $banner.relid eq $cat2.dataId}selected{/if}>-- {$cat2.name}</option>
                        {foreach from=$cat2.children item=cat3}
                            <option value="{$cat3.dataId}" {if $banner.relid eq $cat3.dataId}selected{/if}>---- {$cat3.name}</option>
                        {/foreach}
                    {/foreach}
                {/foreach}
            </select>
            <div class='fv2Tip'>滚动图对应的分类</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>对应位置</span>
        </div>
        <div class="fv2Right">
            <select id="bn-position" style="color:#666">
                <option value="0" {if $banner.banner_position eq 0}selected{/if}>首页顶部</option>
                <option value="1" {if $banner.banner_position eq 1}selected{/if}>首页尾部</option>
                <option value="2" {if $banner.banner_position eq 2}selected{/if}>个人中心</option>
                <option value="3" {if $banner.banner_position eq 3}selected{/if}>搜索板块</option>
                <option value="4" {if $banner.banner_position eq 4}selected{/if}>全站顶部</option>
                <option value="5" {if $banner.banner_position eq 5}selected{/if}>首页中间广告展示</option>
            </select>
            <div class='fv2Tip'>滚动图放置的位置</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>滚动图图片</span>
        </div>
        <div class="fv2Right">
            <div class="clearfix">
                <div class="alter-cat-img">
                    <input type="hidden" value="{$banner.banner_image}" id="banner_image" />
                    <div id="loading" style="transition-duration: .2s;"></div>
                    <img id="catimage" src="{$banner.banner_image}" />
                    {if $banner.banner_image eq ''}
                        <div style='line-height: 100px;color:#777;' class='align-center' id="cat_none_pic">无图片</div>
                    {/if}
                    <div class="align-center top10">
                        <a class="wd-btn primary" id="alter_categroy_image" href="javascript:;">更换图片</a>
                    </div>
                </div>
            </div>
            <div class='fv2Tip' id="tip">滚动图对应要显示的图片 建议尺寸600&times;290</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>过期时间</span>
        </div>
        <div class="fv2Right">
            <input class='gs-input' type="text" id='exp' value="{$banner.exp}" />
            <div class='fv2Tip'>设置广告过期时间，留空即为永久</div>
        </div>
    </div>

</div>
<div class="fix_bottom fixed">
    <a class="wd-btn primary" id='save' data-id='{$banner.id}' href="javascript:;">保存</a>
    {if $banner.id > 0}<a class="wd-btn delete" id='delete' data-id='{$banner.id}' href="javascript:;">删除</a>{/if}
    <a class="wd-btn default" href="javascript:;" onclick="location.href = $('#http_referer').val();">返回</a>
</div>

{include file='../__footer.tpl'} 
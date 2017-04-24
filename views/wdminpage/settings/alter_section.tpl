{include file='../__header.tpl'}
<link href="static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet" />
<link href="static/css/jquery.datetimepicker.css" type="text/css" rel="Stylesheet" />
<i id="scriptTag">static/script/Wdmin/settings/alter_section.js?v={$cssversion}</i>

<input type="hidden" value="{$sec.relid}" id="relid" />
<input type="hidden" value="{$sec.reltype}" id="relType" />


{include file='../modal/product/modal_product_select.html'}

<form style="padding:15px 20px;padding-bottom: 70px;" id="settingFrom">

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>板块名称</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" id="name" value="{$sec.name}" placeholder="请输入板块名称" autofocus/>
            <div class='fv2Tip'>板块名称，显示在板块顶部</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>对应类型</span>
        </div>
        <div class="fv2Right">
            <select id="bn-type" style="color:#666">
                <option value="0" data-hash="hashCat" {if $sec.reltype eq 0}selected{/if}>产品分类</option>
                <option value="1" data-hash="hashProduct" {if $sec.reltype eq 1}selected{/if}>产品列表</option>
                <!--<option value="2" data-hash="hashGmess" {if $sec.reltype eq 2}selected{/if}>图文消息</option>-->
                <!--<option value="3" data-hash="hashLink" {if $sec.reltype eq 3}selected{/if}>超链接</option>-->
                <option value="4" data-hash="advLink" {if $sec.reltype eq 4}selected{/if}>广告链接</option>
            </select>
            <div class='fv2Tip'>版块对应跳转的类型，可以是一到多个产品，也可以是某个产品分类，也可以是某个图文消息，也可以是某个定义的广告</div>
        </div>
    </div>

    <!--广告链接 -->
    <div class="typeHash hidden" id="advLink">
        <div class="fv2Field clearfix">
            <div class="fv2Left">
                <span>链接广告的ID</span>
            </div>
            <div class="fv2Right">
                <input class='gs-input' type="text" name="link_ad" id='link_ad' value="{$sec.pid}" />
                <div class='fv2Tip'>链接广告的ID,多个ID直接用,分割</div>
            </div>
        </div>
    </div>

    <!-- 超链接 暂不用 by mu 2016-01-26-->
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

    <!-- 图文对应 暂不用 by mu 2016-01-26-->
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

    <!-- 商品对应 启用by mu 2016-01-26-->
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

    <!-- 分类对应 暂不用 by mu 2016-01-26-->
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

    <!-- 排序 -->
    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>排序</span>
        </div>
        <div class="fv2Right">
            <input class='gs-input' type="text" name="bsort" id='bsort' onclick="this.select()" value="{$sec.bsort}" />
            <div class='fv2Tip'>数字越大排序越前</div>
        </div>
    </div>

    <div class="fv2Field clearfix" id="corrPic">
        <div class="fv2Left">
            <span>对应图片</span>
        </div>
        <div class="fv2Right">
            <div class="clearfix">
                <div class="alter-cat-img">
                    <input type="hidden" value="{$sec.banner}" id="banner" />
                    <div id="loading" style="transition-duration: .2s;"></div>
                    <img id="catimage" src="{$sec.banner}" />
                    {if $sec.banner eq ''}
                        <div style='line-height: 100px;color:#777;' class='align-center' id="cat_none_pic">无图片</div>
                    {/if}
                    <div class="align-center top10">
                        <a class="wd-btn primary" id="upload_banner" href="javascript:;">更换图片</a>
                        {if $sec.banner neq ''}
                        <a class="wd-btn primary" id="delete_banner" href="javascript:;">删除图片</a>
                        {/if}
                    </div>
                </div>
            </div>
            <div class='fv2Tip'>滚动图对应要显示的图片 建议尺寸600&times;290</div>
        </div>
    </div>

    <!-- 商品对应 delete by mu 2016-01-26
    <div class="fv2Field typeHash clearfix" id="hashProduct" style="max-width:100%;">
        <div class="fv2Left">
            <span>选择产品</span>
        </div>
        <div class="fv2Right">
            <a class="wd-btn primary" data-toggle="modal" data-target="#modal_product_select" style="margin:0;width:389px;" data-id="">选择产品</a>
            <div class='fv2Tip hidden' id="spdCount">已选择100个产品</div>
            <div id="ProductItem" class="clearfix">
            </div>
            <div class='fv2Tip' id="spdTip">请点击选择产品</div>
        </div>
    </div>
    -->

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>开放时间</span>
        </div>
        <div class="fv2Right">
            <div class="clearfix">
                <div style="width: 47%;float: left;">
                    <input type="text" class="gs-input" id="dt1" value="{$sec.ftime}" placeholer="点击设置开始时间" autofocus/>
                </div>
                <div style="width: 6%;float:left;text-align: center;line-height: 32px;text-indent: 3px;"> - </div>
                <div style="width: 47%;float: right;">
                    <input type="text" class="gs-input" id="dt2" value="{$sec.ttime}" placeholer="点击设置结束时间" autofocus/>
                </div>
            </div>
            <div class='fv2Tip'>板块名称，显示在板块顶部</div>
        </div>
    </div>

</form>

<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" id='saveBtn' data-id='{$sec.id}' href="javascript:;">{if $sec.id > 0}保存{else}添加{/if}</a>
    <a onclick="history.go(-1);" class="wd-btn default">返回</a>
</div>

{include file='../__footer.tpl'} 
{include file='../__header.tpl'}

<i id="scriptTag">{$docroot}static/script/Wdmin/settings/alter_envs.js</i>

<form style="padding:15px 20px;padding-bottom: 70px;" id="settingFrom">

    <input type="hidden" id="pids" value="{$env.pid}" />

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>红包名称</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" value="{$env.name}" id="name" autofocus/>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>满额</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" value="{$env.req_amount}" id="req" autofocus/>
            <div class='fv2Tip' id="spdTip">商品的满减条件</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>减额</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" value="{$env.dis_amount}" id="dis" autofocus/>
            <div class='fv2Tip' id="spdTip">商品达到满减条件之后，减去的金额</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>备注</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" value="{$env.remark}" id="remark" autofocus/>
            <div class='fv2Tip' id="spdTip">红包备注，外部不显示</div>
        </div>
    </div>

    <!-- 商品对应 -->        
    <div class="fv2Field typeHash clearfix" id="hashProduct" style="max-width:100%;">
        <div class="fv2Left">
            <span>对应商品</span>
        </div>
        <div class="fv2Right">
            <a id="sProduct" href="{$docroot}?/FancyPage/ajaxSelectProduct/" class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax" style="margin:0;width:389px;" data-id="">选择产品</a>
            <div class='fv2Tip hidden' id="spdCount">已选择100个产品</div>
            <div id="ProductItem" class="clearfix">
                {if $products}
                    {include file='../fancy/ajaxPdBlocks.tpl'}
                {/if}
            </div>
            <div class='fv2Tip' id="spdTip">请点击选择产品</div>
        </div>
    </div>

</form>

<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" id='saveBtn' style="width:150px" data-id="{$env.id}" href="javascript:;">保存设置</a>
</div>

{include file='../__footer.tpl'} 
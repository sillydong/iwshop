{include file='../__header.tpl'}
<link href="{$docroot}static/css/jquery.datetimepicker.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
<i id="scriptTag">{$docroot}static/script/Wdmin/customers/customer_envsend.js</i>
<div class='gmess-sending'></div>
<form style="padding:15px 20px;padding-bottom: 70px;" id="settingFrom">

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>发放对象</span>
        </div>
        <div class="fv2Right">
            <select id="envsTarget">
                <option value="0">全部用户</option>
                <option value="1" data-hash="hashGroup">分组用户</option>
                <option value="2" data-hash="hashPart">部分用户</option>
            </select>
            <div class='fv2Tip'>微店铺名称，显示在网页标题结尾</div>
        </div>
    </div>

    <div class="fv2Field typeHash clearfix hidden" id="hashGroup">
        <div class="fv2Left">
            <span>分组选择</span>
        </div>
        <div class="fv2Right">
            <select id="envsGroup">
                {foreach from=$group item=g name=groupn}
                    <option value="{$g.id}">{$g.level_name} ({$g.count})</option>
                {/foreach}
            </select>
            <div class='fv2Tip'>请选择发放的分组</div>
        </div>
    </div>

    <div class="fv2Field typeHash clearfix hidden" id="hashPart">
        <input type="hidden" value="{$settings.welcomegmess}" name="welcomegmess" id="welcomegmess" />
        <div class="fv2Left">
            <span>用户选择</span>
        </div>
        <div class="fv2Right">
            <a id="sGmess" href="{$docroot}?/WdminAjax/ajax_customer_select/" class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax" style="margin:0;width:100%;" data-id="">选择用户</a>
            <div id="GmessItem" class="clearfix">
                {if $gm}
                    <div class="gmBlock" data-id="{$gm.id}">
                        <a class="sel hov"></a>
                        <p class="title Elipsis">{$gm.title}</p>
                        <img src="uploads/gmess/{$gm.catimg}" />
                        <p class="desc Elipsis">{$gm.desc}</p>
                    </div>
                {/if}
            </div>
            <div id="ProductItem" class="clearfix" style="margin-top: 10px;">
                {if $products}
                    {include file='../fancy/ajaxPdBlocks.tpl'}
                {/if}
            </div>
            <div class='fv2Tip' id="gmessTip">请点击选择用户</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>红包选择</span>
        </div>
        <div class="fv2Right">
            <select id="envsId">
                {foreach from=$envs item=env}
                    <option value="{$env.id}">{$env.name} (满{$env.req_amount}减{$env.dis_amount})</option>
                {/foreach}
            </select>
            <div class='fv2Tip'>请选择发放的红包类型</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>发放数量</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" value="1" id="count" autofocus/>
            <div class='fv2Tip'>每位用户发放红包的数量</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>过期日期</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" value="" id="dt" autofocus/>
            <div class='fv2Tip'>红包过期日期，不包括当日</div>
        </div>
    </div>

</form>

<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" id='saveBtn' style="width:150px" href="javascript:;">开始发放</a>
</div>

{include file='../__footer.tpl'}
{include file='../__header.tpl'}

<i id="scriptTag">{$docroot}static/script/Wdmin/settings/expfee.js</i>

<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer"/>

<div style="margin-bottom: 40px;padding: 10px 20px;">

    <p class="Thead">设置运费模板</p>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>首重起点</span>
        </div>
        <div class="fv2Right">
            <input type="text" onclick="this.select();" placeholder="请填写运费首重起点" class="gs-input" id="expWeight1" value="{if $settings.exp_weight1 > 0}{$settings.exp_weight1}{else}0{/if}"/>
            <div class='fv2Tip'>单位：克</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>续重单位</span>
        </div>
        <div class="fv2Right">
            <input type="text" onclick="this.select();" placeholder="请填写运费续重单位" class="gs-input" id="expWeight2" value="{if $settings.exp_weight2 > 0}{$settings.exp_weight2}{else}0{/if}"/>
            <div class='fv2Tip'>单位：克</div>
        </div>
    </div>

    <div class="fv2Field clearfix" style="max-width: 600px">
        <div class="fv2Left">
            <span>运费表</span>
        </div>
        <div class="fv2Right">
            <a id="invoke" href="#expprovince"></a>
            <div id="exps">
                {foreach from=$datas item=data}
                    <div class="expfield">
                        <span>至</span>
                        <input type="text" class="gs-input inputprovince" value="{$data.province}" />
                        <span>首重</span>
                        <input type="text" class="gs-input inputffee" value="{$data.ffee}" onclick="this.select();"/>
                        <span>续重</span>
                        <input type="text" class="gs-input inputffeeadd" value="{$data.ffeeadd}" onclick="this.select();"/>
                        <span><a class="wd-btn delete" style="height: 29px;min-width:40px;" href="javascript:;" onclick="$(this).parent().parent().remove();">删</a></span>
                    </div>
                {/foreach}
            </div>
            <div class="expprovince" id="expprovince">
                <div id="in" class="clearfix"></div>
                <div class="center" style="margin-bottom: -10px;margin-top: 5px;">
                    <a class="wd-btn primary" id='saveBtnEx' style="width:150px" href="javascript:;">保存</a></div>
            </div>
            <a class="wd-btn primary" id='addBtn' style="width:150px;margin-left: 0;" href="javascript:;">添加一个选项</a>
            <div class="hidden">                    
                <div id="expfieldTmplate">
                    <span>至</span>
                    <input type="text" class="gs-input inputprovince" value="" />
                    <span>首重</span>
                    <input type="text" class="gs-input inputffee" value="0" onclick="this.select();"/>
                    <span>续重</span>
                    <input type="text" class="gs-input inputffeeadd" value="0" onclick="this.select();"/>
                    <span><a class="wd-btn delete" style="height: 29px;min-width: 40px;" href="javascript:;" onclick="$(this).parent().parent().remove();">删</a></span>
                </div>
            </div>
        </div>
    </div>

    <p class="Thead">设置配送时间</p>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>预约天数</span>
        </div>
        <div class="fv2Right">
            <input type="text" onclick="this.select();" placeholder="请填写天数" class="gs-input" id="dispatch_day" value="{if $settings.dispatch_day}{$settings.dispatch_day}{else}{/if}"/>
            <div class='fv2Tip'>购物车结算时,可预约配送时间的天数</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>预约时间段</span>
        </div>
        <div class="fv2Right">
            <input type="text" onclick="this.select();" placeholder="请填写预约时间段, 多个时间段以逗号(,)分隔" class="gs-input" id="dispatch_day_zone" value="{if $settings.dispatch_day_zone > 0}{$settings.dispatch_day_zone}{else}{/if}"/>
            <div class='fv2Tip'>购物车结算时,可预约配送时间的时间段,例如(19:00~21:00)</div>
        </div>
    </div>

</div>

<div class="fix_bottom fixed">
    <a class="wd-btn primary" id='saveBtn' style="width:150px" href="javascript:;">保存设置</a>
</div>

{include file='../__footer.tpl'} 
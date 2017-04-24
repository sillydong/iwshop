{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/base.js</i>

<form style="padding:15px 20px;padding-bottom: 70px;" id="settingFrom">

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>返佣级别</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" name="rebate_level" value="{$settings.rebate_level}" autofocus/>
            <div class='fv2Tip'>代理层级，设定多级分销，比如三级分销，设定为3</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>返佣参数</span>
        </div>
        <div class="fv2Right">
            <textarea class="mpdcont" style="height: 97.5%;min-height: 4.5em;" name="rebate_level_data">{$settings.rebate_level_data}</textarea>
            <div class='fv2Tip'>返佣参数，设定每一级返佣的金额比例，从高到低</div>
            <div class='fv2Tip' style="padding-top: 0">比如三级分销，从高到低设定为：0.15,0.12,0.10</div>
        </div>
    </div>

</form>


<div class="fix_bottom" style="position: fixed">
    <a class="wd-btn primary" id='saveBtn' style="width:150px" href="javascript:;">保存设置</a>
</div>

{include file='../__footer.tpl'}
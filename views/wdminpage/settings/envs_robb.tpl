<form style="padding:15px 20px;" id="settingFrom">

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>功能开启</span>
        </div>
        <div class="fv2Right">
            <select name="on">
                <option value="1" {if $env.on eq 1}selected{/if}>开启</option>
                <option value="0" {if $env.on eq 0}selected{/if}>关闭</option>
            </select>
            <div class='fv2Tip'>是否开启抢红包功能</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>活动名称</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" name="name" value="{$env.name}" autofocus/>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>相应关键字</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" name="key" value="{$env.key}" autofocus/>
            <div class='fv2Tip'>用户发送相应的关键字，才能赠送此红包。</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>红包余量</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="gs-input" name="remains" value="{$env.remains}" autofocus/>
            <div class='fv2Tip'>抢红包，剩余的红包数量</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>红包选择</span>
        </div>
        <div class="fv2Right">
            <select id="envsId" name="envsid">
                {foreach from=$envs item=envx}
                    <option value="{$envx.id}" {if $env.envsid eq $envx.id}selected{/if}>{$envx.name} (满{$envx.req_amount}减{$envx.dis_amount})</option>
                {/foreach}
            </select>
            <div class='fv2Tip'>请选择发放的红包类型</div>
        </div>
    </div>

    <div class='center'>
        <a class="wd-btn primary" id='saveBtn' data-id='{$env.id}' style="width:150px" href="javascript:;">保存设置</a>
    </div>

</form>

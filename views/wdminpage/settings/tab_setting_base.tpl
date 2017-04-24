<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>店铺名称</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="shopname" value="{$settings.shopname}" autofocus/>

        <div class='fv2Tip'>微店铺名称，显示在网页标题结尾</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>统计代码</span>
    </div>
    <div class="fv2Right">
        <textarea class="form-control" name="statcode" rows="5">{$settings.statcode}</textarea>

        <div class='fv2Tip'>统计代码，用于站点统计</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>版权标识</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="copyright" value="{$settings.copyright}"/>

        <div class='fv2Tip'>版权标识，显示在页面底部</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>关注自动红包</span>
    </div>
    <div class="fv2Right">
        <select id="envsId" name="auto_envs" class="form-control">
            <option value="0">不赠送</option>
            {foreach from=$envs item=env}
                <option value="{$env.id}" {if $settings.auto_envs eq $env.id}selected{/if}>{$env.name}
                    (满{$env.req_amount}减{$env.dis_amount})
                </option>
            {/foreach}
        </select>

        <div class='fv2Tip'>用户关注之后，自动赠送红包</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>开启代理</span>
    </div>
    <div class="fv2Right">
        <select id="companyId" name="company_on" class="form-control">
            <option value="0" {if $settings.company_on eq 0}selected{/if}>开启</option>
            <option value="1" {if $settings.company_on eq 1}selected{/if}>不开启</option>
        </select>
    </div>
</div>

<div class="fv2Field clearfix">
    <input type="hidden" value="{$settings.welcomegmess}" name="welcomegmess" id="welcomegmess"/>

    <div class="fv2Left">
        <span>关注自动消息</span>
    </div>
    <div class="fv2Right">
        <a id="sGmess" href="?/WdminPage/ajax_gmess_list/" class="btn btn-success fancybox.ajax"
           data-fancybox-type="ajax" style="margin:0;width:100%;" data-id="">选择素材</a>

        <div id="GmessItem" class="clearfix">
            {if $gm}
                <div class="gmBlock" data-id="{$gm.id}">
                    <a class="sel hov"></a>

                    <p class="title Elipsis">{$gm.title}</p>
                    <img src="{$gm.catimg}"/>

                    <p class="desc Elipsis">{$gm.desc}</p>
                </div>
            {/if}
        </div>
        <div class='fv2Tip' id="gmessTip">请点击选择图文素材</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>确认收货天数</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="order_confirm_day" value="{$settings.order_confirm_day}"/>

        <div class='fv2Tip'>发货状态订单自动确认收货 天数</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>订单自动回收</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="order_cancel_day" value="{$settings.order_cancel_day}"/>

        <div class='fv2Tip'>未支付状态订单自动回收 天数</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>公众号图标</span>
    </div>
    <div class="fv2Right">
        <div class="clearfix">
            <div class="alter-cat-img">
                <input type="hidden" value="{$settings.admin_setting_icon}" id="icon" name="admin_setting_icon"/>

                <div id="icon-loading" style="transition-duration: .2s;"></div>
                <img id="iconimage" src="{$settings.admin_setting_icon}"/>
                {if $settings.admin_setting_icon eq ''}
                    <div style='line-height: 100px;color:#777;' class='align-center' id="icon_none_pic">无图片</div>
                {/if}
                <div class="align-center top10">
                    <a class="btn btn-success" id="upload_icon" href="javascript:;">更换图片</a>
                </div>
            </div>
        </div>
        <div class='fv2Tip'>设置公众号小图标 jpg或png</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>公众号二维码</span>
    </div>
    <div class="fv2Right">
        <div class="clearfix">
            <div class="alter-cat-img">
                <input type="hidden" value="{$settings.admin_setting_qrcode}" id="qrcode" name='admin_setting_qrcode'/>

                <div id="qrcode-loading" style="transition-duration: .2s;"></div>
                <img id="qrcodeimage" src="{$settings.admin_setting_qrcode}"/>
                {if $settings.admin_setting_qrcode eq ''}
                    <div style='line-height: 100px;color:#777;' class='align-center' id="qrcode_none_pic">无图片</div>
                {/if}
                <div class="align-center top10">
                    <a class="btn btn-success" id="upload_qrcode" href="javascript:;">更换图片</a>
                </div>
            </div>
        </div>
        <div class='fv2Tip'>设置公众号二维码 jpg或png</div>
    </div>
</div>
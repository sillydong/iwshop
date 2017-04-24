<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>订单返积分</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="credit_order_amount" value="{$settings.credit_order_amount}"/>

        <div class='fv2Tip'>订单返回的积分数额, 每一元返回多少积分</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>积分抵现</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="credit_ex" value="{$settings.credit_ex}"/>

        <div class='fv2Tip'>每一点积分抵现多少元</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>签到积分</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="sign_credit"
               value="{if $settings.sign_credit > 0}{$settings.sign_credit}{else}0{/if}"/>

        <div class='fv2Tip'>签到之后获取的积分数额</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>签到间隔</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="sign_daylim" value="{$settings.sign_daylim}"/>

        <div class='fv2Tip'>用户签到时间间隔 单位：天</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>注册默认积分</span>
    </div>
    <div class="fv2Right">
        <input type="text" class="form-control" name="reg_credit_default" value="{$settings.reg_credit_default}"/>

        <div class='fv2Tip'>用户注册后获取的积分</div>
    </div>
</div>

<div class="fv2Field clearfix">
    <div class="fv2Left">
        <span>会员中心背景</span>
    </div>
    <div class="fv2Right">
        <div class="clearfix">
            <div class="alter-cat-img">
                <input type="hidden" value="{$settings.ucenter_background_image}" id="ucenter_background_image" name='ucenter_background_image'/>

                <div id="uc-bg-loading" style="transition-duration: .2s;"></div>
                <img id="uc-bg-image" src="{$settings.ucenter_background_image}"/>
                {if $settings.ucenter_background_image eq ''}
                    <div style='line-height: 100px;color:#777;' class='align-center' id="uc_none_pic">无图片</div>
                {/if}
                <div class="align-center top10">
                    <a class="btn btn-success" id="upload_uc_bg" href="javascript:;">更换图片</a>
                </div>
            </div>
        </div>
        <div class='fv2Tip'>设置会员中心背景图 jpg或png</div>
    </div>
</div>
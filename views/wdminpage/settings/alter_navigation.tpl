{include file='../__header.tpl'}
<link href="static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet"/>
<link href="{$docroot}static/css/jquery.datetimepicker.css?v={$cssversion}" type="text/css" rel="Stylesheet"/>
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/alter_navigation.js?v={$cssversion}</i>

<form style="padding:15px 20px;padding-bottom: 70px;" id="settingFrom">

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>导航名称</span>
        </div>
        <div class="fv2Right">
            <input type="text" class="form-control" id="nav_name" value="{$sec.nav_name}" placeholder="请输入导航名称"
                   autofocus/>
            <div class='fv2Tip'>导航名称，显示在导航底部</div>
        </div>
    </div>
    <!-- 导航类型 -->
    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>导航内容</span>
        </div>
        <div class="fv2Right">
            <div style="width:300px;margin-bottom: 20px;" id="radios">
                <input type="radio" id="rad1" name="actype" value=""
                       {if $sec.nav_type == 1 || $sec.nav_type ==''}checked{/if}/>
                <label style="margin-right:5px;" onclick="$('#rad1').click();">产品分类</label>
                <input type="radio" id="rad2" name="actype" value=""
                       {if $sec.nav_type == 0 && $sec.nav_type !='' }checked{/if}/>
                <label style="margin-right:5px;" onclick="$('#rad2').click();">跳转网页</label>
                <div id="act1" class="acts" style="{if $sec.nav_type == 0 && $sec.nav_type != ''}display:none;{/if}">
                    <p class="Thead">用户点击会跳转到指定分类商品结果页面</p>
                    <div style="width:400px;margin-bottom: 20px;">
                        <select id="pd-cat-select" style="color:#666" class="form-control">
                            {foreach from=$categorys item=cat1}
                                <option value="{$cat1.dataId}"
                                        {if $sec.nav_content eq $cat1.dataId}selected{/if}>{$cat1.name}</option>
                                {foreach from=$cat1.children item=cat2}
                                    <option value="{$cat2.dataId}" {if $sec.nav_content eq $cat2.dataId}selected{/if}>
                                        -- {$cat2.name}</option>
                                    {foreach from=$cat2.children item=cat3}
                                        <option value="{$cat3.dataId}"
                                                {if $sec.nav_content eq $cat3.dataId}selected{/if}>
                                            ---- {$cat3.name}</option>
                                    {/foreach}
                                {/foreach}
                            {/foreach}
                        </select>
                    </div>
                </div>
                <!-- 连接跳转 -->
                <div id="act2" class="acts" style="{if $sec.nav_type == 1 || $sec.nav_type == ''}display:none;{/if}">
                    <p class="Thead">用户点击该子菜单会跳到以下链接</p>
                    <div style="width:400px;margin-bottom: 20px;">
                        <div class="gs-text">
                            <input type="text" value="{$sec.nav_content}" id="menu-url-ed"
                                   placeholder="输入网址需完整加上'http://'或'https://'"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 排序 -->
    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>排序</span>
        </div>
        <div class="fv2Right">
            <input class="form-control" type="text" name="sort" id='sort' onclick="this.select()" value="{$sec.sort}"/>
            <div class='fv2Tip'>数字越大排序越前</div>
        </div>
    </div>

    <div class="fv2Field clearfix">
        <div class="fv2Left">
            <span>导航图标</span>
        </div>
        <div class="fv2Right">
            <div class="clearfix">
                <div class="alter-cat-img">
                    <input type="hidden" value="{$sec.nav_ico}" id="nav_ico"/>
                    <div id="loading" style="transition-duration: .2s;"></div>
                    <img id="catimage"
                         src="{$sec.nav_ico}"/>
                    {if $sec.nav_ico eq ''}
                        <div style='line-height: 100px;color:#777;' class='align-center' id="cat_none_pic">无图片</div>
                    {/if}
                    <div class="align-center top10">
                        <a class="btn btn-success" id="upload_banner" href="javascript:;">更换图片</a>
                    </div>
                </div>
            </div>
            <div class='fv2Tip'>首页导航对应的图标 建议尺寸80&times;80</div>
        </div>
    </div>
</form>

<div class="fix_bottom" style="position: fixed">
    <a class="btn btn-success" id='saveBtn' data-id='{$sec.id}' href="javascript:;">{if $sec.id > 0}保存{else}添加{/if}</a>
    <a onclick="history.go(-1);" class="btn btn-default">返回</a>
</div>

{include file='../__footer.tpl'} 
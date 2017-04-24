{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/autoresponse.js</i>
<div style="padding:10px 20px;">
    <p class="Thead">当用户对公众号发送指定消息时，可设置回复指定图文内容。</p>
    <div id="menuW" class="clearfix">
        <div class="l" style="width:180px;">
            <div class="tbar">
                自动回复
                <a class="add" id="topAdd" href="javascript:;"></a>
            </div>
            <div id="alist" style="overflow-y:auto;margin-top: -1px;margin-bottom: -1px;">
                {foreach from=$rs item=g name=groupn}
                    <div data-id="{$g.id}" class="list-user-group-item Elipsis{if $smarty.foreach.groupn.first} selected{/if}">{$g.key}</div>
                {/foreach}
            </div>
        </div>
        <div class="r" style="position:relative;margin-left:180px;">
            <div id="iframe_loading" style="display:none;"></div>
            <div class="tbar">设置动作</div>
            <iframe id="ntright" src="" style="display: block;padding:0;" width="100%" frameborder="0"></iframe>
        </div>
    </div>
</div>
<a id="addmenu1_t" style="display: none" href="#addmenu1"></a>
<div id="addmenu1">
    <div class="in">
        <div class="gs-label">输入名称</div>
        <div class="gs-text">
            <input type="text" value="" id="menu-name-sm" autofocus/>
        </div>
    </div>
    <div class="center">
        <a id="add_menu_btn"  href="javascript:;" class="wd-btn primary">确认</a>
    </div>
</div>
{include file='../__footer.tpl'} 
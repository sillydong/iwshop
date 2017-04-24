{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/gmess/gmess_send.js</i>
<input type='hidden' value='{$stoken}' id='stoken' />
<div style='margin-bottom: 40px;padding-top: 20px;padding-right: 20px;'>
    {if $ed}
        <input type="hidden" value="{$g.id}" id="gid" /> 
    {/if}
    <input type="hidden" value="{$mod}" id="mod" /> 
    <input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer" /> 
    <div class='gmess-sending'></div>
    <div class='clearfix'>
        <div style="float:right;">
            <div id="js_appmsg_preview" class="appmsg_content" style="margin-top: 30px;">
                <div id="appmsgItem1" data-fileid="" data-id="1" class="js_appmsg_item">
                    <h4 class="appmsg_title"><a href="javascript:;">{if $ed}{$g.title}{else}标题{/if}</a></h4>
                    <div class="appmsg_info">
                        <em class="appmsg_date"></em>
                    </div>
                    <a data-fancybox-type="ajax" class="fancybox.ajax appmsg_thumb_wrp pd-image-sec{if $ed and $g.catimg neq ''} ove0{/if}" id="thumbUp" 
                       href="{$docroot}?/WdminPage/ajax_gmess_list/">
                        <img class="js_appmsg_thumb appmsg_thumb" src="{if $ed}{$docroot}static/images_gmess/{$g.catimg}{/if}" id="appmsimg-preview" {if $ed and $g.catimg neq ''}{else}style="display: none;"{/if}>
                    </a>
                    <p class="appmsg_desc">{if $ed}{$g.desc}{/if}</p>
                </div>
                <div class="center">
                    <a id="save_gmess_btn" href="{$docroot}?/WdminPage/ajax_gmess_list/" class="wd-btn primary fancybox.ajax" data-fancybox-type="ajax"  style="margin-top: 10px;width:140px;" data-id="{$g.id}">选择素材</a>
                </div>
            </div>
        </div>
        <div style="margin-right: 347px;padding-left: 20px;">
            <div style='height:70px;'>
                <div class="gmess-area">
                    <div class="gs-label">群发接口</div>
                    <select id="gsend-way" style="padding:5px">
                        <option value="sendGmessSWay">客服消息接口</option>
                        <option value="sendGmessNWay">高级群发接口</option>
                    </select>
                </div>
                <div class="gmess-area hidden">
                    <div class="gs-label">群发对象</div>
                    <select id="gsend-target" style="padding:5px">
                        <option value="0">全部用户</option>
                        <option value="1">按分组选择</option>
                    </select>
                </div>
                <div class="gmess-area hidden">
                    <div class="gs-label">分组选择</div>
                    <select id="gsend-group" style="padding:5px">
                        {foreach from=$userGroup item=group}
                            <option value="{$group.id}">{$group.name}({$group.count})</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div id="gmessUserList">
                <div class='divblock'></div>
                <div class='divlist hidden'></div>
            </div>
        </div>
    </div>    
</div>
<div class="fix_bottom fixed">
    <a id="send_gmess_btn" href="javascript:;" class="wd-btn primary" data-id="{$g.id}" style="width:140px;">开始群发</a>
</div>
{include file='../__footer.tpl'} 
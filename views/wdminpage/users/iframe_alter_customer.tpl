{include file='../__header.tpl'}
<div id="iframe_loading" style="top:0;background: rgba(255,255,255,0.7);display: none;position: fixed;"></div>
<i id="scriptTag">{$docroot}static/script/Wdmin/customers/iframe_alter_customer.js</i>
<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer" /> 
<div style="padding:22px;" class="clearfix">
    <div class="user-edit-headw">
        <img class="user-edit-head {if $c.client_head eq ''}default{/if}" src="{if $c.client_head eq ''}{$docroot}static/images/login/profle_1.png{else}{$c.client_head}/{/if}" />
    </div>
    <form id="form_alter_customer" style="margin-right: 272px;">
        <div style="height: 70px;">
            <div style='float:left;width:32%;'>
                <div class="gs-label">微信昵称</div>
                <div class="gs-text" style="cursor: default;">
                    <input type="text" name="client_nickname" value="{$c.client_nickname}" readonly/>
                </div>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">真实姓名</div>
                <div class="gs-text">
                    <input type="text" onclick="this.select();" name="client_name" value="{$c.client_name}" autofocus/>
                </div>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">电话</div>
                <div class="gs-text">
                    <input type="text" onclick="this.select();" name="client_phone" value="{$c.client_phone}" />
                </div>
            </div>
        </div>
        <div style="height: 70px;">
            <div style='float:left;width:32%;'>
                <div class="gs-label">邮箱</div>
                <div class="gs-text">
                    <input type="text" onclick="this.select();" name="client_email" value="{$c.client_email}" />
                </div>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">性别</div>
                <select name='client_sex'>
                    <option value='m' {if $c.client_sex eq 'm'}selected{/if}>男</option>
                    <option value='f' {if $c.client_sex eq 'f'}selected{/if}>女</option>
                </select>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">身份证号码</div>
                <div class="gs-text">
                    <input type="text" onclick="this.select();" name="client_personid" value="{$c.client_personid}" />
                </div>
            </div>
        </div>
        <div style="height: 70px;">
            <div style='float:left;width:32%;'>
                <div class="gs-label">省份</div>
                <select name='client_province' id="client_province" data-sl="{$c.client_province}"></select>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">城市</div>
                <select name='client_city' id="client_city" data-st="{$c.client_city}"></select>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">详细地址</div>
                <div class="gs-text">
                    <input type="text" name="client_address" value="{$c.client_address}" />
                </div>
            </div>
        </div>
        <div style="height: 70px;">
            <div style='float:left;width:32%;'>
                <div class="gs-label">所属代理</div>
                <select name='client_comid'>
                    <option value="0">无</option>
                    {foreach from=$coms item=com}
                        <option value="{$com.id}" {if $c.client_comid eq $com.id}selected{/if}>{$com.name}</option>
                    {/foreach}
                </select>
            </div>
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">所属分组</div>
                <select name='client_groupid'>
                    {foreach from=$group item=g}
                        <option value="{$g.id}" {if $c.client_groupid eq $g.id}selected{/if}>{$g.name}</option>
                    {/foreach}
                </select>
            </div>            
            <div style='float:left;width:32%;margin-left: 2%;'>
                <div class="gs-label">会员等级</div>
                <select name='client_level'>
                    {foreach from=$lev item=g}
                        <option value="{$g.id}" {if $c.client_level eq $g.id}selected{/if}>{$g.level_name}</option>
                    {/foreach}
                </select>
            </div>
        </div>
        <div class="gs-label">备注</div>
        <span class="frm_textarea_box"><textarea class="js_desc frm_textarea" id="pd-form-desc" name="client_remark">{$c.client_remark}</textarea></span>
            {if $id eq 0}
                {*用户注册附加参数*}
            <input type='hidden' value='{$smarty.now|date_format:'%Y-%m-%d'}' name='client_joindate' />
            <input type='hidden' value='' name='client_wechat_openid' />
        {/if}
    </form>
    {*    <div class="center">
    <a class="wd-btn primary" style="width:150px" id="al-cus-save" data-id="{if $c.client_id > 0}{$c.client_id}{else}0{/if}" href="javascript:;">
    {if $mod eq 'add'}提交{else}保存{/if}
    </a>
    </div>*}
</div>
<div class="fix_bottom fixed">
    <a id="save_btn" data-id="{$id}" onclick="javascript:;" class="wd-btn primary">保存</a>
    {if $id ne 0}<a class="wd-btn delete" id="delete_btn" data-id="{$c.client_id}">删除</a>{/if}
    <a onclick="location.href = $('#http_referer').val();" class="wd-btn default">返回</a>
</div>
{include file='../__footer.tpl'} 
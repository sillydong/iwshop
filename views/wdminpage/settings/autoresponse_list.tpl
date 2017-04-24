{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/iframe_autoresponse.js</i>
<div class="clearfix" style="margin-bottom: 40px;">
    <div  style="padding:10px 20px;width:200px;float:left;">

        <input type="hidden" id="rel" value="{$a.rel}" /> 
        <input type="hidden" id="reltype" value="{$a.reltype}" /> 
        <input type="hidden" id="gmess-catimg" value="{$g.catimg}" /> 

        <p class="Thead">关键字名称</p>
        <!-- 关键字名称 -->
        <div style="margin-bottom: 20px;">
            <div class="gs-text">
                <input type="text" value="{$a.key}" id="au-key" autofocus/>
            </div>
        </div>
        <p class="Thead">菜单动作</p>

        <!-- 菜单动作 -->
        <div style="margin-bottom: 20px;" id="radios">
            <input type="radio" id="rad1" name="actype" value="" checked/>
            <label style="margin-right:5px;" onclick="$('#rad1').click()">发送信息</label>
            <input type="radio" id="rad2" name="actype" value="" />
            <label onclick="$('#rad2').click()">图文信息</label>
        </div>

    </div>
    <div style="margin-left:230px;" class="padding10">

        <!-- 文字消息内容 -->
        <div class="acts" style="width:300px;margin-bottom: 10px;display: none;">
            <p class="Thead">文字内容</p>
            <div>
                <textarea style="min-height:200px;" cols='4' class="mpdcont" id="au-message">{$a.message}</textarea>
            </div>
        </div>

        <!-- 图文消息内容 -->
        <div class="acts" style="margin-bottom: 10px;display: none;">
            <p class="Thead">图文标题</p>
            <!-- 关键字名称 -->
            <div style="margin-bottom: 20px;">
                <div class="gs-text">
                    <input type="text" value="{$g.title}" id="gmess-title" />
                </div>
            </div>
            <p class="Thead">图文摘要</p>
            <!-- 关键字名称 -->
            <div style="margin-bottom: 20px;">
                <span class="frm_textarea_box"><textarea class="js_desc frm_textarea" id="gmess-desc">{$g.desc}</textarea></span>
            </div>

            <p class="Thead">图文内容</p>

            <div style="margin-bottom: 20px;margin-right: 10px;">
                <script id="ueditorp" name="content" type="text/plain">{$g.content}</script>
            </div>
        </div>
    </div>
</div>
<div class="fix_bottom fixed">
    <a id="save_btn"  href="javascript:;" class="wd-btn primary" data-id="{$a.id}">保存</a>
    <a class="wd-btn delete" id="delete_btn" data-id="{$a.id}">删除</a>
</div>
{include file='../__footer.tpl'} 
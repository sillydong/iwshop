{include file='../__header_v2.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/gmess/gmess_edit.js</i>
<div style='margin-bottom: 57px;padding-top: 20px;padding-right: 20px;'>
    {if $ed}
        <input type="hidden" value="{$g.id}" id="gid"/>
    {/if}
    <input type="hidden" value="{if $ed}edit{else}add{/if}" id="mod"/>
    <input type="hidden" value="{$docroot}?/WdminPage/gmess_list/" id="http_referer"/>
    <div class='clearfix'>
        <div style="float:right;">
            <div id="js_appmsg_preview" class="appmsg_content">
                <div id="appmsgItem1" data-fileid="" data-id="1" class="js_appmsg_item">
                    <h4 class="appmsg_title"><a href="javascript:;">{if $ed}{$g.title}{else}标题{/if}</a></h4>
                    <div class="appmsg_info">
                        <em class="appmsg_date"></em>
                    </div>
                    <a class="appmsg_thumb_wrp pd-image-sec{if $ed and $g.catimg neq ''} ove0{/if}" id="thumbUp">
                        <img class="js_appmsg_thumb appmsg_thumb" src="{if $ed}{$g.catimg}{/if}" id="appmsimg-preview"
                             {if $ed and $g.catimg neq ''}{else}style="display: none;"{/if}>
                    </a>
                    <p class="appmsg_desc">{if $ed}{$g.desc}{/if}</p>
                </div>
                <p class='tTip'>建议尺寸：900像素 * 500像素</p>
            </div>
        </div>
        <form id="uploadForm" style="margin-right: 360px;">
            <a id="fileSubmit" style="display: none"></a>
            <input name="catimg" id="catimgpath" value="{if $ed}{$g.catimg}{/if}" type="hidden"/>
            <div style="margin-left: 22px;">
                <label class="control-label">图文标题</label>
                <input type="text" class="form-control" name="title" value='{if $ed}{$g.title}{/if}'
                       id="gs-form-title"/>
                <br />
                <label class="control-label">图文摘要 <i style="font-size: 12px;color: #888;">选填，如果不填写会默认抓取正文前54个字</i></label>
                <textarea class="form-control" id="gs-form-desc" name="desc" rows="4">{if $ed}{$g.desc}{/if}</textarea>
                <br />
                <label class="control-label">原文链接</label>
                <input type="text" class="form-control" name="content_source_url" value='{if $ed}{$g.content_source_url}{/if}'
                       id="content_source_url"/>
            </div>
            <br />
            <div id="editorContain">
                <label class="control-label">正文内容</label>
                <script id="ueditorp" name="content" type="text/plain"
                        style="width: 100%">{if $ed}{$g.content}{/if}</script>
                <br />
                <label class="control-label">媒体ID</label>
                <input type="text" class="form-control" name="title" value='{if $ed}{$g.media_id}{/if}'
                       readonly/>
            </div>
        </form>
    </div>
</div>
<div class="fix_bottom fixed" style="height: 59px">
    <a id="save_gmess_btn" href="javascript:;" class="btn btn-success" data-id="{$g.id}" style="width: 80px"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span>保存</a>
    {if $ed}<a class="btn btn-danger" id="del_gmess_btn" data-id="{$g.id}" style="width: 80px">删除</a>{/if}
    <a onclick="location.href = $('#http_referer').val();" class="btn btn-default" style="width: 80px">返回</a>
</div>
{include file='../__footer.tpl'} 
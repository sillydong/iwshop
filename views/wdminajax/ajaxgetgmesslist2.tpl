{strip}
    {section name=ls loop=$list}
        <div class="gmessItem" id="gsend-item{$list[ls].id}" style='width: 100%'>
            <div id="js_appmsg_preview" class="appmsg_content" style="margin-left:15px;">
                <div id="appmsgItem1" class="js_appmsg_item">
                    <input type='hidden' class='gmessURI' value='{$list[ls].href}' />
                    <input type='hidden' class='gmessTitle' value='{$list[ls].title}' />
                    <input type='hidden' class='gmessCat' value='{$list[ls].catimg}' />
                    <input type='hidden' class='gmessDesc' value='{$list[ls].desc}' />
                    <h4 class="appmsg_title"><a href="{$list[ls].href}" target="_blank">{$list[ls].title}</a></h4>
                    <div class="appmsg_info">
                        <em class="appmsg_date"></em>
                    </div>
                    <div class="appmsg_thumb_wrp" id="fileDragArea">
                        <img class="js_appmsg_thumb appmsg_thumb" src="{$list[ls].catimg}" id="appmsimg-preview">
                    </div>
                    <p class="appmsg_desc" style="height: 40px;overflow: hidden;">{$list[ls].desc}</p>
                    <div class="appmsg-bar">
                        <a class="bbtn gsend-chosbtn" data-msgid="{$list[ls].id}" href="javascript:;" style="width:100%;">选择</a>
                    </div>
                </div>
            </div>
        </div>
    {/section}
{/strip}
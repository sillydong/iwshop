<div style="width:500px;padding:15px;">
    <input type="hidden" id="spec_alter_id" value="{if !$add}{$spec.id}{/if}" />
    <div class="gs-label">规格名称</div>
    <div class="gs-text">
        <input type="text" value="{if !$add}{$spec.spec_name}{/if}" id="pd-spec-name" autofocus/>
    </div>    
    <div class="gs-label">规格备注</div>
    <div class="gs-text">
        <input type="text" value="{if !$add}{$spec.spec_remark}{/if}" id="pd-spec-remark" autofocus/>
    </div>
    <div class="gs-label">规格值 <a href="javascript:;" id="specdet-add" style="color:#44b549;">+添加</a></div>

    <div id="spes-warpp">
        {if $add}
            <div class="clearfix spes-items">
                <div style="float:left;width:55%;">
                    <div class="gs-text">
                        <input type="text" value="" class="spec-det" data-id="" placeholder="规格名称" autofocus/>
                    </div>
                </div>
                <div style="float:left;width:24%;margin-left:3%;">
                    <div class="gs-text">
                        <input type="text" value="0" class="spec-det-sort" placeholder="顺序" autofocus/>
                    </div>
                </div>
                <div style="float:left;width:15%;margin-left:2.5%;">
                    <a class="wd-btn delete spec-edit-del" href="javascript:;">删</a>
                </div>
            </div>
        {else}
            {foreach from=$spec.dets item=det}
                <div class="clearfix spes-items">
                    <div style="float:left;width:65%;">
                        <div class="gs-text">
                            <input type="text" value="{$det.det_name}" data-id="{$det.id}" class="spec-det" placeholder="规格名称" autofocus/>
                        </div>
                    </div>
                    <div style="float:left;width:14%;margin-left:3%;">
                        <div class="gs-text">
                            <input type="text" value="{$det.det_sort}" class="spec-det-sort" placeholder="顺序" autofocus/>
                        </div>
                    </div>
                    <div style="float:left;width:15%;margin-left:2.5%;">
                        <a class="wd-btn delete spec-edit-del" href="javascript:;">删</a>
                    </div>
                </div>
            {/foreach}
        {/if}
    </div>

    <div class="center top20">
        <a class="wd-btn primary" id='add_spec_btn_save' style="width:150px" href="javascript:;">保存</a>
    </div>
</div>
{strip}<div style="width:500px;min-height:300px;background:#fff;">
    <div style="width:150px;max-height:300px;float:left;overflow-y:auto;">
        <ul class="pd-spec-ajax-ul">
            {foreach from=$specs item=s name=sloop}
                <li data-id="{$s.id}">
                    <a href="javascript:;" class="spec-list-sp Elipsis {if $smarty.foreach.sloop.first}hover{/if}" id='spec-item-{$s.id}'>{$s.spec_name}{if $s.spec_remark}[{$s.spec_remark}]{/if}</a>
                </li>
            {/foreach}
        </ul>
    </div>
    <div style="margin-left: 149px;max-height:300px;border-left: 1px solid #dedede;box-shadow: -1px 0 2px rgba(0,0,0,0.1);overflow-y:auto;">
        {foreach from=$specs item=s name=scloop}
            <div data-id="{$s.id}" class='spec-det-list {if !$smarty.foreach.scloop.first}hidden{/if}' id="spec-det-list-{$s.id}">
                <table class="dTableX">
                    <thead>
                        <tr>
                            <th style="width:50px;padding-left: 0;"><input class="checkAll" type="checkbox" /></th>
                            <th>规格名称</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$s.dets item=dets}
                            <tr id='spec-{$s.id}-{$dets.id}' style='cursor: pointer;'>
                                <td style="width:50px;padding-left: 0;"><input class='pd-spec-checks' type="checkbox" data-spid='{$s.id}' data-id='{$dets.id}' data-name='{$dets.det_name}' /></td>
                                <td>{$dets.det_name}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        {/foreach}
    </div>
</div>
<div class='center' style='padding-top:10px;padding-bottom:8px;border-top:1px solid #dedede;'>
    <a id="confirm_spec_btn" onclick="javascript:;" class="wd-btn primary">确认选择</a>
</div>{/strip}
{include file='../__header.tpl'}
<i id="scriptTag">page_alter_product_specs</i>
<div class="clearfix" style="margin-bottom:42px;">
    <div id="DataTables_Table_0_filter" class="dataTables_filter clearfix">
        <div class="search-w-box"><input type="text" class="searchbox" placeholder="输入搜索内容" /></div>
        <div class="button-set" style="margin-top: 13px;margin-right: 13px;">
            <a class="button gray" href="javascript:;" onclick='location.reload()'>刷新</a>
            <a class="button spec-edit-btn fancybox.ajax" data-fancybox-type="ajax" href="{$docroot}?/WdminPage/ajax_alter_product_spec/">新增规格</a>
        </div>
    </div>
    <table class="dTable">
        <thead>
            <tr>
                <th>编号</th>
                <th>名称</th>
                <th>规格值</th>
                <th style='padding-right:10px;'>操作</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$specs item=s}
                <tr>
                    <td>#{$s.id}</td>
                    <td style="font-size:14px;">{$s.spec_name} <b class="spec-remark">{if $s.spec_remark ne ''}[{$s.spec_remark}]{/if}</td>
                    <td style='white-space: initial;'>
                        {foreach from=$s.dets item=dets}
                            <a class="spec-det-item" href="javascript:;" data-id="{$dets.id}">{$dets.det_name}</a>
                        {/foreach}
                    </td>
                    <td data-id="{$s.id}" style='padding-right:10px;'>
                        <a class="spec-edit-btn fancybox.ajax" data-fancybox-type="ajax" href="{$docroot}?/WdminPage/ajax_alter_product_spec/id={$s.id}">修改</a> / <a class="spec-del-btn del" href="javascript:;">删除</a>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
{include file='../__footer.tpl'} 
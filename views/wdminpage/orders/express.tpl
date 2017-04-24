{strip}
    {if $res.status eq 1 or $res.status eq 0 or $res.status eq -1}
        <div style='height:30px;line-height: 30px;text-align: center;color: #888;'>暂无记录、单号没有任何跟踪记录</div>
    {else}
        <div id="express-dt">
            <table class="ickd_return" style="width: 100%">
                <tbody>
                
                {foreach from=$res.data item=r name=rx}
                    <tr>
                        <td style="padding-left: 0">
                            {$r.time}
                        </td>
                        <td class='exp-status{if $smarty.foreach.rx.first} status-first{/if}{if $res.status eq 4 and $smarty.foreach.rx.last} status-check{else if $smarty.foreach.rx.last} status-last{/if}'>

                        </td>
                        <td style='padding-left: 0;white-space: normal'>
                            {$r.content}
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        </div>
    {/if}
{/strip}
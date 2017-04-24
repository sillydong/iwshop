<table cellpadding=0 cellspacing=0 class="groupSentTable">
    <tr>
        <th class="cover" style="">封面</th>
        <th class="title" colspan="2">标题</th>
        <th colspan="1" width="80px" class="center">发送</th>
        <th colspan="1" width="80px" class="center">到达</th>
        <th colspan="1" width="80px" class="center">到达率</th>
        <th colspan="1" width="80px" class="center">阅读</th>
        <th colspan="1" width="80px" class="center">转发</th>
        <th colspan="1" width="80px" class="center" style="padding-right:22px;">日期</th>
    </tr>
    {strip}
        {section name=ls loop=$list}
            <tr>
                <td class="cover"><img height="60px" width="60px" src="{$list[ls].catimg}" /></td>
                <td colspan="2" class="title">
                    <a href="{$list[ls].href}" target="_blank">{$list[ls].title}</a>
                </td>
                <td colspan="1" class="center">{$list[ls].send_count}</td>
                <td colspan="1" class="center">{$list[ls].receive_count}</td>
                <td colspan="1" class="center">{$list[ls].reach_rate}%</td>
                <td colspan="1" class="center">{$list[ls].read_count}</td>
                <td colspan="1" class="center">{$list[ls].share_count}</td>
                <td colspan="1" class="center" style="padding-right:22px;">{$list[ls].send_date}</td>
            </tr>
        {/section}
    {/strip}
</table>
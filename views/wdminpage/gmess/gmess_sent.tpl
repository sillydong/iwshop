{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/gmess/gmess_sent.js</i>
<table class="dTable">
    <thead>
        <tr>
            <th class='hidden'> </th>
            <th>编号</th>
            <th>封面</th>
            <th>标题</th>
            <th>接口类型</th>
            <th>发送人数</th>
            <th>实际到达</th>
            <th>到达率</th>
            <th>阅读</th>
            <th>转发</th>
            <th>日期</th>
        </tr>        
    </thead>
    <tbody>
        {section name=ls loop=$list}
            <tr>
                <td class='hidden'>{$list[ls].id}</td>
                <td>#{$list[ls].id}</td>
                <td>
                    <img class='pdlist-image' src='{$docroot}static/Thumbnail/?w=50&h=50&p={$docroot}/uploads/gmess/{$list[ls].catimg}' />
                </td>
                <td>
                    <a href="{$list[ls].href}" target="_blank">{$list[ls].title}</a>
                </td>
                <td>{$list[ls].send_type}</td>
                <td>{$list[ls].send_count}</td>
                <td>{$list[ls].receive_count}</td>
                <td>{$list[ls].reach_rate}%</td>
                <td>{$list[ls].read_count}</td>
                <td>{$list[ls].share_count}</td>
                <td>{$list[ls].send_date}</td>
            </tr>
        {/section}
    </tbody>
</table>
{include file='../__footer.tpl'} 
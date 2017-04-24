<table class="dTable">
    <thead>
        <tr>
            <th>略缩图</th>
            <th>产品编号</th>
            <th>产品名称</th>
            <th>产品价格</th>
            <th>点击量</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=oi from=$list}
            <tr class="defTr">
                <td>
                    <img width="45px" height="45px" style="vertical-align: middle;margin: 5px 0;" src="/static/product_hpic/{$oi.catimg}" />
                </td>
                <td>{$oi.product_id}</td>
                <td>{$oi.product_name}</td>
                <td class="prices">&yen;{$oi.sale_prices}</td>
                <td>{$oi.product_readi}</td>
                <th class="gray">
                    <a href="javascript:;">编辑</a> / <a href="javascript:;" class="del">删除</a>
                </th>
            </tr>
        {/foreach}
    </tbody>
</table>
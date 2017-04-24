<input id='openidCount' value='{$count}' type='hidden' />
<table class='dTableX1'>
    <thead>
        <tr>
            <th style="width:50px;padding-left: 0;"><input class="checkAll" type="checkbox" /></th>
            <th>头像</th>
            <th>姓名</th>
            <th>编号</th>
        </tr>
    </thead>
    <tbody>
        {strip}
            {section name=ls loop=$list}
                <tr {if $smarty.section.ls.index is odd by 1}class="odd"{/if}>
                    <td style="width:50px;padding-left: 0;"><input class='gmess-user-checks' type="checkbox" data-openid='{$list[ls].openid}' /></td>
                    <td>
                        <img class='ccl-head' 
                             src='{if $list[ls].client_head eq ''}{$docroot}static/images/icon/iconfont-weixin.png{else}{$list[ls].client_head}/64{/if}' />
                    </td>
                    <td >{$list[ls].client_name}</td>
                    <td>#{$list[ls].openid}</td>
                </tr>
            {/section}
        {/strip}
    </tbody>
</table>
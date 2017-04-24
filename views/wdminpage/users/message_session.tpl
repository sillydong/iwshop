{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/customers/message_session.js</i>
<div id="mess-session">
    {foreach from=$msgs item=msg name=msglist}
        {if $msg.msgtype eq 0}
            <div class="messG clearfix" data-id="{$msg.id}" data-time="{$msg.send_time}">
                <img src="{$head}" />
                <div class="messC">{$msg.msgcont}</div>
            </div>
        {else}
            <div class="messG self clearfix" data-id="{$msg.id}" data-time="{$msg.send_time}">
                <img src="static/images/login/getheadimg.jpg" />
                <div class="messC">{$msg.msgcont}</div>
            </div>
        {/if}
    {/foreach}
</div>
<div id="sendbox">
    <div id="tarea">
        <textarea rows="3" autofocus></textarea>
    </div>
    <div id="btnbar">
        <a id="sendbtn" href="javascript:;">发送</a>
    </div>
</div>
{include file='../__footer.tpl'}
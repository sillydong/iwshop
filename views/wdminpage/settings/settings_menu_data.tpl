{foreach from=$menu.button item=m}
    <div class="tMenus">
        <div class="menutop" data-name="{$m.name}" data-type="{$m.type}" data-url="{$m.url}" data-key="{$m.key}">
            <span class="n">{$m.name}</span>
            <a class="del" href="javascript:;"></a>
            <a class="sadd" href="javascript:;"></a>
        </div>
        <ul class="menusubs">
            {foreach from=$m.sub_button item=s}
                <li data-type="{$s.type}" data-name="{$s.name}" data-url="{$s.url}" data-key="{$s.key}">
                    <span class="n">{$s.name}</span>
                    <a class="del" href="javascript:;"></a>
                </li>
            {/foreach}
        </ul>
    </div>
{/foreach}
{if $navigation|count > 0}
    <section class="navigation-bar">
        <ul>
            {foreach from=$navigation item=nav}
                <li>
                    <a href="{$nav.nav_content}">
                        <img width="50px" height="50px" src='{$nav.nav_ico}' />
                        <h6>{$nav.nav_name}</h6>
                    </a>
                </li>
            {/foreach}
        </ul>
    </section>
{/if}
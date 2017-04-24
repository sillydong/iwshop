<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv=Content-Type content="text/html;charset=utf-8" />
        <title>我的推广 - {$settings.shopname}</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="format-detection" content="telephone=no">
        <link href="static/css/wshop_company_center.css?v={$cssversion}" type="text/css" rel="Stylesheet" />
        <script type="text/javascript" src="static/script/jquery-2.1.1.min.js?v={$cssversion}"></script>
        <script type="text/javascript" src="static/script/main.js?v={$cssversion}"></script>
    </head>
    <body>
        <input type="hidden" value="{$status}" id="status" />

        {include file="../global/top_nav.tpl"}
		<div class="comspreadstat clearfix">
			<span class="spread-item" style="width:50%;">荣誉等级<b>{$typenum[$comtype]}</b></span>
			<span class="spread-item" style="width:50%;">分佣率<b>{if $comR}{$comR* 100}%{else}0{/if}</b></span>
		</div>
        <div class="comspreadstat clearfix">
            <span class="spread-item" style="width:33.33%;">今日<b>&yen; {if $stat_data['incometod']}{$stat_data['incometod']}{else}0{/if}</b></span>
            <span class="spread-item" style="width:33.33%;">昨日<b>&yen; {if $stat_data['incometotyet']}{$stat_data['incometotyet']}{else}0{/if}</b></span>
            <span class="spread-item" style="width:33.33%;">本月<b>&yen; {if $stat_data['incometotmonth']}{$stat_data['incometotmonth']}{else}0{/if}</b></span>
        </div>
        <div class="comspreadstat clearfix">
            <span class="spread-item" style="width:33.33%;">已提现金额<b>&yen; {if $stat_data['incometotsetted']}{$stat_data['incometotsetted']}{else}0{/if}</b></span>
            <span class="spread-item" style="width:33.33%;">未提现金额<b>&yen; {if $stat_data['incometotunset']}{$stat_data['incometotunset']}{else}0{/if}</b></span>
            <span class="spread-item" style="width:33.33%;">总收益<b>&yen; {if $stat_data['incometot']}{$stat_data['incometot']}{else}0{/if}</b></span>
        </div>

        <header class="Thead">推广情况</header>
		<div class="comspreadstat clearfix">	
			<a href ="{$docroot}?/Company/listDirectMember/" class="spread-item" style="width:50%;">下级会员<b>{if $stat_data['ucount']}{$stat_data['ucount']}{else}0{/if} 人</b></a>
			<a href ="{$docroot}?/Company/listDirectCom/" class="spread-item" style="width:50%;">下级代理<b>{if $stat_data['comcount']}{$stat_data['comcount']}{else}0{/if} 人</b></a>
		</div>

        {include file="../global/footer.tpl"}

    </body>
</html>
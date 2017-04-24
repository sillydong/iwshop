{if $Auth.stat}
    <a href="javascript:;" class="navItem" id="navitem2" rel='subnav2'>
        <span class="glyphicon glyphicon-th-large" aria-hidden="true"></span><i class="label">报表中心</i>
    </a>
    <div class='subnavs clearfix' id='subnav2'>
        <a class='cap-nav-item' href='javascript:;' data-page="overview" data-nav="home">微店总览</a>
    </div>
{/if}

{if $Auth.orde}
    <a href="javascript:;" class="navItem" id="navitem4" rel='subnav4'>
        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span><i class='label'>订单管理</i>
    </a>
    <div class='subnavs clearfix' id='subnav4'>
        <a class='cap-nav-item' href='javascript:;' data-page="orders_manage" data-nav="orders">订单管理</a>
        <a class='cap-nav-item' href='javascript:;' data-page="orders_refund" data-nav="orders">退款审核</a>
        <a class='cap-nav-item' href='javascript:;' data-page="orders_withdrawal" data-nav="orders">提现审核</a>
        <a class='cap-nav-item' href='javascript:;' data-page="orders_history_address" data-nav="orders">收货地址</a>
        <a class='cap-nav-item' href='javascript:;' data-page="orders_express_record" data-nav="orders">配送记录</a>
        <a class='cap-nav-item' href='javascript:;' data-page="orders_comment" data-nav="orders">评价管理</a>
    </div>
{/if}

{if $Auth.prod}
    <a href="javascript:;" class="navItem" id="navitem5" rel='subnav5'>
        <span class="glyphicon glyphicon-folder-open" aria-hidden="true" style="font-size: 12px"></span><i
                class='label'>商品管理</i>
    </a>
    <div class='subnavs clearfix' id='subnav5'>
        <a id='__pdlist' class='cap-nav-item' href='javascript:;' data-page="list_products" data-nav="products">商品管理 <b
                    class="icount">(0)</b></a>
                    <a id='__stockmanage' class='cap-nav-item' href='javascript:;' data-page="list_product_instock" data-nav="products">库存管理 <b class="icount">(0)</b></a>
        <a id='__catlist' class='cap-nav-item' href='javascript:;' data-page="alter_products_category"
           data-nav="products">分类管理 <b class="icount">(0)</b></a>
        <a id='__specmanage' class='cap-nav-item' href='javascript:;' data-page="alter_product_specs"
           data-nav="products">规格管理 <b class="icount">(0)</b></a>
        <a class='cap-nav-item' href='javascript:;' data-page="alter_product_brand" data-nav="products">品牌管理 <b
                    class="icount">(0)</b></a>
        <a class='cap-nav-item' href='javascript:;' data-page="deleted_products" data-nav="products">回收站 <b
                    class="icount">(0)</b></a>
    </div>
{/if}

{if $Auth.user}
    <a href="javascript:;" class="navItem" id="navitem9" rel='subnav9'>
        <span class="glyphicon glyphicon-user" aria-hidden="true"></span><i class='label'>用户管理</i>
    </a>
    <div class='subnavs clearfix' id='subnav9'>
        <a id='__uslist' class='cap-nav-item' href='javascript:;' data-page="list_customers"
           data-nav="customers">用户列表</a>
        <a class='cap-nav-item' href='javascript:;' data-page="user_level" data-nav="customers">用户分组</a>
        <a class='cap-nav-item' href='javascript:;' data-page="user_balance_record" data-nav="customers">余额记录</a>
        <a class='cap-nav-item' href='javascript:;' data-page="user_credit_record" data-nav="customers">积分记录</a>
        <a class='cap-nav-item' href='javascript:;' data-page="user_feedbacks" data-nav="customers">用户反馈</a>
    </div>
{/if}

{if $Auth.gmes}
    <a href="javascript:;" class="navItem" id="navitem15" rel='subnav15'>
        <span class="glyphicon glyphicon-gift" aria-hidden="true"></span><i class='label'>营销中心</i>
    </a>
    <div class='subnavs clearfix' id='subnav15'>
        <a class='cap-nav-item' href='javascript:;' data-page="user_envsend" data-nav="customers">红包发放</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_envs" data-nav="customers">红包设置</a>
        <a class='cap-nav-item' href='javascript:;' data-page="envsRobList" data-nav="customers">限抢红包</a>
        <a class='cap-nav-item' href='javascript:;' data-page="credit_exchange" data-nav="settings">积分兑换</a>
                   <a class='cap-nav-item' href='javascript:;' data-page="discount_code_list" data-nav="settings">优惠码</a>
    </div>
{/if}

{if $Auth.gmes}
    <a href="javascript:;" class="navItem" id="navitem6" rel='subnav6'>
        <span class="glyphicon glyphicon-send" aria-hidden="true"></span><i class='label'>消息群发</i>
    </a>
    {*<div class='subnavs clearfix' id='subnav6'>
        <a class='cap-nav-item' href='javascript:;' data-page="gmess_list" data-nav="gmess">素材管理</a>

    </div>*}
	
	<div class='subnavs clearfix' id='subnav6'>
      <a id='__usmessage' class='cap-nav-item' href='javascript:;' data-page="customer_messages">会员消息</a>
        <a class='cap-nav-item' href='javascript:;' data-page="gmess_list" data-nav="gmess">素材管理</a>
        <a class='cap-nav-item' href='javascript:;' data-page="gmess_category" data-nav="gmess">素材分类</a>
        <a class='cap-nav-item' href='javascript:;' data-page="gmess_send" data-nav="gmess">消息群发</a>
        <a class='cap-nav-item' href='javascript:;' data-page="gmess_sent" data-nav="gmess">群发历史</a>
    </div>
	
	
	
	
{/if}

{if $Auth.comp}
    <a href="javascript:;" class="navItem" id="navitem8" rel='subnav8'>
        <span class="glyphicon glyphicon-yen" aria-hidden="true"></span><i class='label'>代理分销</i>
    </a>
    <div class='subnavs clearfix' id='subnav8'>
        <a id='__comlist' class='cap-nav-item' href='javascript:;' data-page="list_companys" data-nav="company">代理管理</a>
        <a class='cap-nav-item' href='javascript:;' data-page="company_level" data-nav="company">代理分组</a>
        <a class='cap-nav-item' href='javascript:;' data-page="company_tree" data-nav="company">代理结构</a>
        <a class='cap-nav-item' href='javascript:;' data-page="company_rebates" data-nav="company">返佣设定</a>
        <a class='cap-nav-item' href='javascript:;' data-page="company_rebates_record" data-nav="company">返佣结算</a>
    </div>
{/if}

{if $Auth.sett}
    <a href="javascript:;" class="navItem" id="navitem7" rel='subnav7'>
        <span class="glyphicon glyphicon-cog" aria-hidden="true" style="font-size: 16px"></span><i
                class='label'>店铺设置</i>
    </a>
    <div class='subnavs clearfix' id='subnav7'>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_base" data-nav="settings">基础设置</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_autoresponse" data-nav="setttings">自动回复</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_menu" data-nav="settings">自定菜单</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_banners" data-nav="settings">广告设置</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_section" data-nav="settings">首页板块</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_navigation" data-nav="settings">首页导航</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_expfee" data-nav="settings">运费模板</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_expcompany" data-nav="settings">快递设置</a>
        <a class='cap-nav-item' href='javascript:;' data-page="settings_auth" data-nav="settings">管理权限</a>
    </div>
{/if}

{if $Auth.sett}
    <a href="javascript:;" class="navItem" rel='subnav10'>
        <span class="glyphicon glyphicon-hdd" aria-hidden="true" style="font-size: 16px"></span>
               <i class='label'>系统维护</i>
    </a>
    <div class='subnavs clearfix' id='subnav10'>
        <a class='cap-nav-item' href='javascript:;' data-href="?/wSystem/logs/">系统日志</a>
    </div>
{/if}

<br/>
<br/>
<br/>
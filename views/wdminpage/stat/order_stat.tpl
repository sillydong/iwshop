{include file='../__header_v2.tpl'}
{assign var="script_name" value="order_stat"}

<link href="{$docroot}static/script/lib/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="Stylesheet" />
<link href="{$docroot}static/script/lib/umeditor/themes/default/css/umeditor.min.css" type="text/css" rel="Stylesheet" />
<link href="{$docroot}static/script/lib/fancyBox/source/jquery.fancybox.css" type="text/css" rel="Stylesheet" />
<script data-main="{$docroot}static/script/wdmin-frame.js?v={$cssversion}" src="/libs/jquery/require.min.js"></script>

<i id="scriptTag">static/script/Wdmin/stat/order_stat_require.js</i>

<div class="pd15" ng-controller="statController" ng-app="ngApp">
    {include file='../modal/product/modal_product_select.html'}
    {include file='../modal/stat/modal_order_view.html'}

    {*include file='../modal/stat/modal_lucky_record_delete.html'*}
    {*include file='../modal/stat/modal_lucky_record_modify.html'*}

    {literal}
        <div class="pheader clearfix" style="border: 1px solid transparent;border-color: #dedede;">
            <div style="padding-top: 5px"></div>
            <div class="pull-left">
                <div id="SummaryBoard" style="width:1000px">
                    <div class="row">
                        <form class="form-horizontal" role="form">
                            <div class="form-group">

                                <label for="ordersn" class="col-sm-2 control-label hidden"></label>
                                <div class="col-sm-4 hidden">
                                    <div class="input-group">
                                        <div class="input-group-btn">
                                            <button type="button" style="line-height: 20px;"
                                                    class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                                                    aria-haspopup="true" aria-expanded="false"><span
                                                        id="search-type-label">订单号</span><span class="caret"
                                                                                               style="margin-left: 5px;"></span>
                                            </button>
                                            <ul class="dropdown-menu small" id="search-type">
                                                <li><a href="#" data-type="0">订单号</a></li>
                                            </ul>
                                        </div>
                                        <input type="text" style="height: 32px;" class="form-control search-field" placeholder="请输入搜索内容"
                                               aria-describedby="sizing-addon3" id="search-key"/>

                                        <div class="input-group-btn">
                                            <button type="button" id="search-button" class="btn btn-default"><span
                                                        class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                                        </div>
                                    </div>
                                </div>

                                <!--
                                <label for="goods" class="col-sm-2 control-label">商品</label>
                                <div class="col-sm-2">
                                    <input type="text" placeholder="请选择商品信息" class="form-control" id="product" value="" />
                                </div>
                                -->
                                <input type="hidden" value="" id="product" />
                                <label for="goods" class="col-sm-2 control-label">选择产品</label>
                                <div class="col-sm-2">
                                    <div class="col-sm-2">
                                        <a id="sProduct" href="?/FancyPage/ajaxSelectProduct/" class="wd-btn primary fancybox.ajax"
                                           data-fancybox-type="ajax" style="margin: -15px;width: 146px;" data-id="">选择产品</a>
                                    </div>

                                </div>
                                <input type="hidden" value="" id="uid" />
                                <!--
                                <label for="uname" class="col-sm-2 control-label">用户</label>
                                <div class="col-sm-2">
                                    <input type="text" placeholder="请选择用户信息" class="form-control" id="uname" value="" />
                                </div>
                                -->
                                <label for="goods" class="col-sm-1 control-label">选择用户</label>
                                <div class="col-sm-2">
                                    <div class="col-sm-2">
                                        <a id="add-notifyer" href="?/WdminAjax/ajax_customer_select/" class="wd-btn primary fancybox.ajax"
                                           data-fancybox-type="ajax" style="margin: -15px;width: 146px;" data-id="">选择用户</a>
                                    </div>

                                </div>

                                <label for="goods" class="col-sm-1 control-label">已选产品</label>
                                <div class="col-sm-4">
                                    <input type="text" placeholder="" class="form-control" id="selectProducts" value="" />
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="stime" class="col-sm-2 control-label">开始时间</label>
                                <div class="col-sm-2">
                                    <input type="text" placeholder="点击选择时间" class="form-control" id="stime" value="" />
                                </div>
                                <label for="etime" class="col-sm-1 control-label">结束时间</label>
                                <div class="col-sm-2">
                                    <input type="text" placeholder="点击选择时间" class="form-control" id="etime" value="" />
                                </div>
                                <label for="status" class="col-sm-1 control-label hidden">状态</label>
                                <div class="col-sm-2  hidden">
                                    <div class="input-group-btn">
                                        <button type="button" style="line-height: 20px;" class="btn btn-default dropdown-toggle"
                                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span
                                                    id="order-status-label">全部</span><span class="caret"
                                                                                                              style="margin-left: 5px;"></span>
                                        </button>
                                        <ul class="dropdown-menu small" id="order-status">
                                            <li><a href="#" data-type="all">全部 </a></li>
                                            <li><a href="#" data-type="payed">已支付 </a></li>
                                            <li><a href="#" data-type="delivering">快递在途 </a></li>
                                            <li><a href="#" data-type="unpay">未支付 </a></li>
                                            <li><a href="#" data-type="canceled">已取消 </a></li>
                                            <li><a href="#" data-type="received">已完成 </a></li>
                                            <li><a href="#" data-type="closed">已关闭 </a></li>
                                            <li><a href="#" data-type="refunded">已退款 </a></li>
                                        </ul>
                                    </div>
                                </div>

                                <label for="goods" class="col-sm-1 control-label">已选用户</label>
                                <div class="col-sm-4">
                                    <input type="text" placeholder="" class="form-control" id="selectUsers" value="" />
                                </div>

                            </div>

                            <div class="form-group">
                                <div class="col-sm-offset-4 col-sm-10">
                                    <button id="query-button" onclick="$('#search-button').click();" type="button" class="btn btn-success">
                                        查询
                                    </button>
                                    <button type="button" class="btn btn-gray" id="list-reload" onclick="location.reload()">刷新</button>
                                </div>
                            </div>

                        </form>

                    </div>

                </div>
            </div>


        </div>
        <div style="padding-top: 5px"></div>
        <div class="panel panel-default" style="margin-bottom: 50px;">
            <table class="table table-hover table-bordered table-fixed">
                <thead>
                <tr>
                    <th width="125px">订单编号</th>
                    <th style="width: 50px;">姓名</th>
                    <th style="width: 92px;">电话</th>
                    <th>地区</th>
                    <th>订单金额</th>
                    <th>运费</th>
                    <th>商品数量</th>
                    <th>下单时间</th>
                    <th>状态</th>
                    <th width="92px">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in orderList">
                    <td class="breakTd">{{order.serial_number}}</td>
                    <td>{{order.address.user_name}}</td>
                    <td>{{order.address.tel_number}}</td>
                    <td class="breakTd">{{order.address.province}}{{order.address.city}}</td>
                    <td class="text-danger">&yen;{{order.order_amount}}</td>
                    <td class="text-danger">&yen;{{order.order_expfee}}</td>
                    <td>{{order.product_count}} 件</td>
                    <td>{{order.order_time}}</td>
                    <td class="orderstatus {{order.status}}">{{order.statusX}}</td>
                    <td>
                        <a class="text-success" data-toggle="modal" data-target="#modal_order_view"
                           data-id="{{order.order_id}}" href="#">查看</a>
                        <!--
                        <a class="text-success" data-toggle="modal"
                           data-id="{{order.order_id}}" href="?/wOrder/order_print/id={{order.order_id}}" target="_blank">打印</a></br>

                        <a class="text-success" data-toggle="modal"
                           data-id="{{order.order_id}}" href="?/wOrder/express_print/id={{order.order_id}}" target="_blank">快递单打印</a></br>

                        <a class="text-muted" data-toggle="modal" data-target="#modal_order_viewexpress"
                           data-com="{{order.express_com}}" data-code="{{order.express_code}}"
                           data-id="{{order.order_id}}" href="#">物流</a>
                        <a class="text-danger" data-toggle="modal" data-target="#modal_order_delete"
                           data-order_id="{{order.order_id}}" href="#">删除</a>
                          -->
                    </td>
                </tr>
                <tr ng-show="listcount == 0">
                    <td colspan="10" class="EmptyTd">暂无数据</td>
                </tr>
                </tbody>
            </table>
        </div>
    {/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/stat/{$script_name}.js"></script>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom">
        <div style="padding-top:10px" class="textLeft fixed">
            订单数量：<i class="digRed" id="com-orders-pd-count">?</i>&nbsp;
            商品数量：<i class="digRed" id="com-orders-pd-count1">?</i>件&nbsp;
            商品总金额：<i class="digRed" id="com-income-count">?</i> 元
        </div>
        <ul class="pagination-sm pagination"></ul>
    </div>
</div>


{include file='../__footer_v2.tpl'}


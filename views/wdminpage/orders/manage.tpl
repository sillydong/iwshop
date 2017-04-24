{include file='../__header_v2.tpl'}
{assign var="script_name" value="orders_manage_controller"}

<script type="text/javascript" src="/scripts/jquery.PrintArea.js"></script>

<div class="pd15" ng-controller="orderController" ng-app="ngApp">

    {include file='../modal/orders/modal_order_view.html'}
    {include file='../modal/orders/modal_order_delete.html'}
    {include file='../modal/orders/modal_order_modify.html'}
    {include file='../modal/orders/modal_export_orders.html'}
    {include file='../modal/orders/modal_order_view_express.html'}

    {literal}
        <div class="pheader clearfix">
            <div class="pull-left">
                <div id="SummaryBoard" style="width:350px">
                    <div class="row">
                        <div class="col-xs-9">
                            <div class="input-group">
                                <div class="input-group-btn">
                                    <button type="button" style="line-height: 20px;"
                                            class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                                            aria-haspopup="true" aria-expanded="false">
                                            <span id="search-type-label">订单号</span>
                                            
                                                <span class="caret" style="margin-left: 5px;"></span>
                                    </button>
                                    <ul class="dropdown-menu small" id="search-type">
                                        <li><a href="#" data-type="0">订单号</a></li>
                                        <li><a href="#" data-type="1">客户电话</a></li>
                                        <li><a href="#" data-type="2">客户姓名</a></li>
                                    </ul>
                                </div>
                                <input type="text" style="height: 32px;" class="form-control search-field"
                                       placeholder="请输入搜索内容"
                                       aria-describedby="sizing-addon3" id="search-key"/>

                                <div class="input-group-btn">
                                    <button type="button" id="search-button" class="btn btn-default"><span
                                                class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-3" style="padding-left: 0">
                            <div class="input-group-btn">
                                <button type="button" style="line-height: 20px;" class="btn btn-default dropdown-toggle"
                                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span
                                            id="order-status-label">全部 ({{statdata.all}})</span><span class="caret"
                                                                                                      style="margin-left: 5px;"></span>
                                </button>
                                <ul class="dropdown-menu small" id="order-status">
                                    <li><a href="#" data-type="all">全部 ({{statdata.all}})</a></li>
                                    <li><a href="#" data-type="payed">已支付 ({{statdata.payed}})</a></li>
                                    <li><a href="#" data-type="delivering">快递在途 ({{statdata.delivering}})</a></li>
                                    <li><a href="#" data-type="unpay">未支付 ({{statdata.unpay}})</a></li>
                                    <li><a href="#" data-type="canceled">已取消 ({{statdata.canceled}})</a></li>
                                    <li><a href="#" data-type="received">已完成 ({{statdata.received}})</a></li>
                                    <li><a href="#" data-type="closed">已关闭 ({{statdata.closed}})</a></li>
                                    <li><a href="#" data-type="refunded">已退款 ({{statdata.refunded}})</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pull-right">
                <div class="button-set">
                    <button type="button" class="btn btn-success" data-toggle="modal"
                            data-target="#modal_export_orders">
                        <span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span>导出
                    </button>
                    <button type="button" class="btn btn-default" id="list-reload" ng-click="fnGetList()">
                        <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>刷新
                    </button>
                </div>
            </div>
        </div>
        <div class="panel panel-default" style="margin-bottom: 60px;">
            <table class="table table-hover table-bordered table-fixed">
                <thead>
                <tr>
                    <th width="50px"></th>
                    <th width="130px">订单编号</th>
                    <th>姓名</th>
                    <th>电话</th>
                    <th>地区</th>
                    <th>订单金额</th>
                    <th>运费</th>
                    <th>商品数量</th>
                    <th>下单时间</th>
                    <th width="50px">状态</th>
                    <th width="92px">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in orderList" ng-if="listcount > 0">
                    <td class="text-center">
                        <img class="img-rounded" width="35px" height="35px"
                             ng-src="{{order.data.catimg}}"/>
                    </td>
                    <td class="breakTd" ng-bind="order.serial_number"></td>
                    <td ng-bind="order.address.user_name"></td>
                    <td ng-bind="order.address.tel_number"></td>
                    <td class="breakTd" ng-bind="::order.address.province + order.address.city"></td>
                    <td class="text-danger" ng-bind="::'&yen;'+order.order_amount"></td>
                    <td class="text-danger" ng-bind="::'&yen;'+order.order_expfee"></td>
                    <td ng-bind="::order.product_count + '件'"></td>
                    <td ng-bind="::order.order_time"></td>
                    <td class="orderstatus {{order.status}}" ng-bind="::order.statusX"></td>
                    <td>
                        <a class="text-success" data-toggle="modal" data-target="#modal_order_view"
                           data-id="{{order.order_id}}" href="#">查看</a>
                        <a class="text-muted" data-toggle="modal" data-target="#modal_order_viewexpress"
                           data-com="{{order.express_com}}" data-code="{{order.express_code}}"
                           data-id="{{order.order_id}}" href="#">物流</a>
                        <a class="text-danger" data-toggle="modal" data-target="#modal_order_delete"
                           data-order_id="{{order.order_id}}" href="#">删除</a>
                    </td>
                </tr>
                <tr ng-if="listcount == 0">
                    <td colspan="11" class="EmptyTd">暂无数据</td>
                </tr>
                </tbody>
            </table>
        </div>
    {/literal}

</div>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom">
        <ul class="pagination-sm pagination"></ul>
    </div>
</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/orders/{$script_name}.js"></script>

{include file='../__footer_v2.tpl'} 

{include file='../__header_v2.tpl'}
{assign var="script_name" value="orders_manage_refund_controller"}

<div class="pd15" ng-controller="orderRefundController" ng-app="ngApp">

    {include file='../modal/orders/modal_order_view_refund.html'}
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
                                    <button type="button" style="line-height: 20px;" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span id="search-type-label">订单号</span><span class="caret" style="margin-left: 5px;"></span></button>
                                    <ul class="dropdown-menu small" id="search-type">
                                        <li><a href="#" data-type="0">订单号</a></li>
                                        <li><a href="#" data-type="1">客户电话</a></li>
                                        <li><a href="#" data-type="2">客户姓名</a></li>
                                    </ul>
                                </div>
                                <input type="text" style="height: 32px;" class="form-control search-field" placeholder="请输入搜索内容" aria-describedby="sizing-addon3" id="search-key" />
                                <div class="input-group-btn">
                                    <button type="button" id="search-button" class="btn btn-default"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-3" style="padding-left: 0">
                            <div class="input-group-btn">
                                <button type="button" style="line-height: 20px;" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span id="order-status-label">待处理 ({{statdata.refunding}})</span><span class="caret" style="margin-left: 5px;"></span>
                                </button>
                                <ul class="dropdown-menu small" id="order-status">
                                    <li><a href="#" data-type="canceled">待处理 ({{statdata.refunding}})</a></li>
                                    <li><a href="#" data-type="refunded">已退款 ({{statdata.refunded}})</a></li>
                                    <li><a href="#" data-type="record">退款记录</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pull-right">
                <div class="button-set">
                    <button type="button" class="btn btn-success" data-toggle="modal" data-target="#modal_export_orders">
                        <span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span>导出
                    </button>
                    <button type="button" class="btn btn-default" id="list-reload" onclick="location.reload()">
                        <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>刷新
                    </button>
                </div>
            </div>
        </div>

        <div class="panel panel-default" style="margin-bottom: 50px;">
            <table ng-show="listtype==0" class="table table-hover table-bordered table-responsive" style="table-layout: fixed;">
                <thead>
                <tr>
                    <th width="124px">订单编号</th>
                    <th style="width: 50px;">姓名</th>
                    <th style="width: 92px;">电话</th>
                    <th width="70px">金额</th>
                    <th width="70px">已退</th>
                    <th width="50px">数量</th>
                    <th width="75px">快递公司</th>
                    <th width="120px">快递单号</th>
                    <th>下单时间</th>
                    <th>发货时间</th>
                    <th style="width: 68px;" class="text-center">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in orderList">
                    <td>{{order.serial_number}}</td>
                    <td>{{order.address.user_name}}</td>
                    <td>{{order.address.tel_number}}</td>
                    <td class="text-danger">&yen;{{order.order_amount}}</td>
                    <td class="text-danger">&yen;{{order.order_refund_amount}}</td>
                    <td>{{order.product_count}} 件</td>
                    <th>{{order.expressName}}</th>
                    <th>{{order.express_code}}</th>
                    <td style="white-space: normal">{{order.order_time}}</td>
                    <td style="white-space: normal">{{order.send_time}}</td>
                    <td>
                        <a class="text-success" data-toggle="modal" ng-show="{{order.status == 'canceled'}}" data-target="#modal_order_view" data-id="{{order.order_id}}" href="#">退款</a>
                        <a class="text-success" data-toggle="modal" ng-show="{{order.status == 'refunded'}}" data-target="#modal_order_view" data-id="{{order.order_id}}" href="#">详情</a>
                        <a class="text-muted" data-toggle="modal" data-target="#modal_order_viewexpress" data-com="{{order.express_com}}" data-code="{{order.express_code}}" data-id="{{order.order_id}}" href="#">物流</a>
                    </td>
                </tr>
                </tbody>
            </table>
            <table ng-show="listtype==1" class="table table-hover table-bordered table-responsive" style="table-layout: fixed;">
                <thead>
                <tr>
                    <th>订单编号</th>
                    <th>退款金额</th>
                    <th>退款类型</th>
                    <th>退款编号</th>
                    <th>原支付方式</th>
                    <th width="100px">操作人</th>
                    <th width="131px">退款时间</th>
                    <th width="50px" class="text-center">状态</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in refundList">
                    <td>{{order.serial_number}}</td>
                    <td class="text-danger">&yen;{{order.refund_amount}}</td>
                    <td>{{refund_type_arr[order.refund_type]}}</td>
                    <td>{{order.refund_serial}}</td>
                    <td>{{paymethod[order.payment_type]}}</td>
                    <td>{{order.dowhois}}</td>
                    <td>{{order.refund_time}}</td>
                    <td class="text-success">已退款</td>
                </tr>
                <tr ng-show="listcount == 0">
                    <td colspan="11" class="EmptyTd">暂无数据</td>
                </tr>
                </tbody>
            </table>
        </div>

    {/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/orders/{$script_name}.js"></script>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom"><ul class="pagination-sm pagination"></ul></div>
</div>

{include file='../__footer_v2.tpl'}
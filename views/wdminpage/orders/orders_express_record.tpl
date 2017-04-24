{include file='../__header_v2.tpl'}
{assign var="script_name" value="orders_express_record_controller"}

<div class="pd15" ng-controller="orderExpressRecordController" ng-app="ngApp">

    {include file='../modal/orders/modal_order_view.html'}

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
                                <button type="button" style="line-height: 20px;" class="btn btn-default dropdown-toggle"
                                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span
                                            id="order-status-label">{{listsort}} ({{listcount}})</span><span
                                            class="caret"
                                            style="margin-left: 5px;"></span>
                                </button>
                                <ul class="dropdown-menu small" id="order-status">
                                    <li><a href="#" data-openid="">全部</a></li>
                                    <li ng-repeat="staff in express_staffs"><a href="#" data-openid="{{staff.openid}}"
                                                                               ng-click="sortOpenid($event)">{{staff.name}}</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pull-right">
                <div class="button-set">
                    <button type="button" class="btn btn-gray" id="list-reload" onclick="location.reload()">刷新</button>
                </div>
            </div>
        </div>

        <div class="panel panel-default" style="margin-bottom: 50px;">
            <table class="table table-hover table-bordered table-responsive" style="table-layout: fixed;">
                <thead>
                <tr>
                    <th width="150px">订单编号</th>
                    <th>配送员</th>
                    <th>下单时间</th>
                    <th>调配时间</th>
                    <th>送达时间</th>
                    <th>配送时效</th>
                    <th width="50px" class="text-center">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in orderList">
                    <td>{{order.serial_number}}</td>
                    <td>{{order.client_name}}</td>
                    <td>{{order.order_time}}</td>
                    <td>{{order.send_time}}</td>
                    <td>{{order.confirm_time}}</td>
                    <td>{{order.costs}}</td>
                    <td class="text-center">
                        <a href="#" data-id="{{order.order_id}}" class="text-success" data-toggle="modal"
                           data-target="#modal_order_view">详情</a>
                    </td>
                </tr>
                <tr ng-show="listcount == 0">
                    <td colspan="8" class="EmptyTd">暂无数据</td>
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
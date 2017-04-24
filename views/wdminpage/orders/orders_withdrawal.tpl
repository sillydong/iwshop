{include file='../__header_v2.tpl'}
{assign var="script_name" value="orders_withdrawal_controller"}

<div class="pd15" ng-controller="orderWithdrawalController" ng-app="ngApp">

    {include file='../modal/orders/modal_withdrawal_audit.html'}

    {literal}
        <div class="pheader clearfix">
            <div class="pull-left">
                <div id="SummaryBoard" style="width:300px">
                    <div class="row">
                        <div class="col-xs-9">
                            <div class="input-group">
                                <div class="input-group-btn">
                                    <ul class="dropdown-menu small" id="search-type">
                                        <li><a href="#" data-type="0">订单号</a></li>
                                    </ul>
                                </div>
                                <input type="text" style="height: 32px;" class="form-control search-field"
                                       placeholder="请输入搜索内容" aria-describedby="sizing-addon3" id="search-key"/>

                                <div class="input-group-btn">
                                    <button type="button" id="search-button" class="btn btn-default"><span
                                                class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-3" style="padding-left: 0">
                            <div class="input-group-btn">
                                <button type="button" style="line-height: 20px;" class="btn btn-default dropdown-toggle"
                                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span id="order-status-label">全部<span class="caret"
                                                                          style="margin-left: 5px;"></span>
                                </button>
                                <ul class="dropdown-menu small" id="order-status">
                                    <li><a href="#" data-type="all">全部</a></li>
                                    <li><a href="#" data-type="wait">待处理</a></li>
                                    <li><a href="#" data-type="pass">已退款</a></li>
                                    <li><a href="#" data-type="reject">已拒绝</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pull-right">
                <div class="button-set">
                    <button type="button" class="btn btn-default" id="list-reload" onclick="location.reload()">
                        <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>刷新
                    </button>
                </div>
            </div>
        </div>
        <div class="panel panel-default" style="margin-bottom: 57px;">
            <table class="table table-hover table-bordered table-responsive" style="table-layout: fixed;">
                <thead>
                <tr>
                    <th width="120px">订单编号</th>
                    <th width="55px">姓名</th>
                    <th>电话</th>
                    <th width="75px">金额</th>
                    <th>银行</th>
                    <th>支行</th>
                    <th>开户城市</th>
                    <th width="155px">银行卡号</th>
                    <th width="55px" class="text-center">状态</th>
                    <th width="50px" class="text-center">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in list">
                    <td ng-bind="::order.serial"></td>
                    <td ng-bind="::order.username"></td>
                    <td ng-bind="::order.phone"></td>
                    <td><span class="label label-success" ng-bind=":: '&yen; ' + order.amount"></span></td>
                    <td ng-bind="::order.bankname"></td>
                    <td ng-bind="::order.subbranch"
                        style="word-wrap: break-word !important;line-height: 20px !important;white-space: initial !important;"></td>
                    <td ng-bind="::order.city + order.dist"
                        style="word-wrap: break-word !important;line-height: 20px !important;white-space: initial !important;"></td>
                    <td ng-bind="::order.cardno"></td>
                    <td class="text-center text-muted" ng-class="{'text-success': order.status == 'pass'}" ng-bind="::order.status | cvWithStatus"></td>
                    <td class="text-center">
                        <a href="#" data-id="{{order.id}}" ng-if="order.status == 'wait'" data-toggle="modal"
                           data-target="#modal_withdrawal_audit">审核</a>
                        <span ng-if="order.status != 'wait'">-</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    {/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/orders/{$script_name}.js"></script>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom">
        <ul class="pagination-sm pagination"></ul>
    </div>
</div>

{include file='../__footer_v2.tpl'}
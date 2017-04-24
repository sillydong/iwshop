{include file='../__header_v2.tpl'}

<div class="pd15" ng-controller="companyRebateRecordController" ng-app="ngApp">

    {include file='../modal/company/modal_company_rebate_audit.html'}

    {literal}
        <div class="pheader clearfix">
            <div class="pull-left">
                <div id="SummaryBoard" style="width:300px">
                    <div class="row">
                        <div class="col-xs-9">
                            <div class="input-group">
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
                                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span id="order-status-label">全部</span>
                                    <span class="caret" style="margin-left: 5px;"></span>
                                </button>
                                <ul class="dropdown-menu small" id="order-status">
                                    <li><a href="#" data-type="all">全部</a></li>
                                    <li><a href="#" data-type="wait">未审核</a></li>
                                    <li><a href="#" data-type="pass">已审核</a></li>
                                    <li><a href="#" data-type="reject">已拒绝</a></li>
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
                    <button type="button" class="btn btn-default" ng-click="fnGetList()"><i class="fa fa-refresh"></i> 刷新
                    </button>
                </div>
            </div>
        </div>
        <div class="panel panel-default" style="margin-bottom: 58px;" ng-show="orderList.length > 0">
            <table class="table table-hover table-bordered table-fixed">
                <thead>
                <tr>
                    <th>代理编号</th>
                    <th width="140px">订单编号</th>
                    <th>客户</th>
                    <th>代理</th>
                    <th>订单金额</th>
                    <th>返佣</th>
                    <th>点数</th>
                    <th>方式</th>
                    <th width="50px" class="text-center">级别</th>
                    <th width="132px">时间</th>
                    <th width="50px" class="text-center">状态</th>
                    <th width="50px" class="text-center">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in orderList">
                    <td><b ng-bind="::'#' + order.comid"></b></td>
                    <td class="Elipsis" ng-bind="::order.order_serial"></td>
                    <td ng-bind="::order.uname" class="Elipsis"></td>
                    <td ng-bind="::order.comname" class="Elipsis"></td>
                    <td><span class="label label-info" ng-bind="::'&yen; ' + order.order_amount"></span></td>
                    <td><span class="label label-danger" ng-bind="::'&yen; ' + order.rebate_amount"></span></td>
                    <td ng-bind="::order.rebate_rate"></td>
                    <td><span class="label label-success" ng-bind="::order.rebate_type | cvRebateType"></span></td>
                    <td class="text-center" ng-bind="::order.rebate_level"></td>
                    <td ng-bind="::order.rtime"></td>
                    <td class="text-center text-muted" ng-class="{'text-success': order.status == 'pass'}"
                        ng-bind="::order.status | cvStatusType"></td>
                    <td class="text-center">
                        <a href="#" ng-if="order.status=='wait'" data-id="{{order.id}}" data-toggle="modal"
                           data-target="#modal_company_rebate_audit">审核</a>
                        <span ng-if="order.status!='wait'">-</span>
                    </td>
                </tr>
                <tr ng-show="listcount == 0">
                    <td colspan="12" class="EmptyTd">暂无数据</td>
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

<script type="text/javascript"
        src="{$docroot}static/script/Wdmin/company/company_rebates_record_controller.js"></script>

{include file='../__footer_v2.tpl'}
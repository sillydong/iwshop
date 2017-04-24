{include file='../__header_v2.tpl'}
{assign var="script_name" value="order_address_controller"}

<div class="pd15" ng-controller="orderAddressController" ng-app="ngApp">

    {literal}
        <div class="pheader clearfix">
            <div class="pull-left">
                <div id="SummaryBoard" style="width:300px">
                    <div class="row">
                        <div class="col-xs-9">
                            <div class="input-group">
                                <input type="text" style="height: 32px;" class="form-control search-field"
                                       placeholder="请输入搜索内容" aria-describedby="sizing-addon3" id="search-key"/>

                                <div class="input-group-btn">
                                    <button type="button" id="search-button" class="btn btn-default"><span
                                                class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                                </div>
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
        <div class="panel panel-default" style="margin-bottom: 50px;">
            <table class="table table-hover table-bordered table-responsive">
                <thead>
                <tr>
                    <th width="150px">姓名</th>
                    <th>电话</th>
                    <th>邮编</th>
                    <th>地址</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="order in orderList">
                    <td>{{order.user_name}}</td>
                    <td>{{order.tel_number}}</td>
                    <td>{{order.postal_code}}</td>
                    <td>{{order.address}}</td>
                </tr>
                <tr ng-show="orderList.length == 0">
                    <td colspan="8" class="EmptyTd">暂无数据</td>
                </tr>
                </tbody>
            </table>
        </div>
    {/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/orders/{$script_name}.js"></script>

{include file='../__footer_v2.tpl'}
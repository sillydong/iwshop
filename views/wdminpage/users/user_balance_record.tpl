{include file='../__header_v2.tpl'}
{assign var="script_name" value="user_balance_record_controller"}
<div class="pd15" ng-controller="userBalanceRecordController" ng-app="ngApp">

    {literal}
        <table class="table table-hover table-bordered" style="margin-bottom: 50px;">
            <thead>
            <tr>
                <th width="50px">编号</th>
                <th width="150px">姓名</th>
                <th>电话</th>
                <th>类型</th>
                <th>额度</th>
                <th>说明</th>
                <th>变动日期</th>
            </tr>
            </thead>
            <tbody>
            <tr ng-repeat="msg in balanceRecords">
                <td ng-bind="::msg.id"></td>
                <td ng-bind="::msg.client_name"></td>
                <td ng-class="{'text-muted': msg.client_phone == '未录入'}" ng-bind="::msg.client_phone"></td>
                <td ng-bind="::msg.rtype"></td>
                <td ng-bind="msg.amount"></td>
                <td ng-bind="::msg.remark"></td>
                <td ng-bind="::msg.rtime"></td>
            </tr>
            </tbody>
        </table>
    {/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/user/{$script_name}.js"></script>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom">
        <ul class="pagination-sm pagination"></ul>
    </div>
</div>

{include file="../__footer_v2.tpl"}

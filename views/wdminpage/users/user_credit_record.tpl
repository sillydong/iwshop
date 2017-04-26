{include file='../__header_v2.tpl'}
{assign var="script_name" value="user_credit_record_controller"}
<!--  用户积分记录 -->
<div class="pd15" ng-controller="userCreditRecordController" ng-app="ngApp">
    {literal}
        <table class="table table-hover table-bordered" style="margin-bottom: 50px;">
            <thrad>
                <tr>
                    <th>编号</th>
                    <th>姓名</th>
                    <th>联系电话</th>
                    <th>额度</th>
                    <th>时间</th>
                    <th>关联事件</th>
                    <th>关联ID</th>
                    <th>说明</th>
                </tr>
            </thrad>
            <tbody>
            <tr ng-repeat="msg in creditRecords">
                <td>{{msg.id}}</td>
                <td>{{msg.client_name}}</td>
                <td>{{msg.client_phone}}</td>
                <td>{{msg.amount}}</td>
                <td>{{msg.dt}}</td>
                <td>{{msg.reltype}}</td>
                <td>{{msg.relid}}</td>
                <td>{{msg.remark}}</td>
            </tr>
            </tbody>
        </table>
    {/literal}
</div>
<script type="text/javascript" src="{$docroot}static/script/Wdmin/user/{$script_name}.js"></script>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom"><ul class="pagination-sm pagination"></ul></div>
</div>

{include file="../__footer_v2.tpl"}

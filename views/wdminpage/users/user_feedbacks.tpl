{include file='../__header_v2.tpl'}
{assign var="script_name" value="user_feedback_controller"}
<!-- 用户反馈与订单评价 -->
<div class="pd15" ng-controller="userFeedbackController" ng-app="ngApp">

    {include file='../modal/orders/modal_order_view.html'}

    {literal}

            <table class="table table-hover table-bordered" style="margin-bottom: 50px;">
                <thead>
                <tr>
                    <th>编号</th>
                    <th>姓名</th>
                    <th>电话</th>
                    <th>反馈内容</th>
                    <th style="width: 131px;">反馈时间</th>
                    <th style="width: 40px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="msg in feedBacks">
                    <td>{{msg.id}}</td>
                    <td>{{msg.client_name}}</td>
                    <td>{{msg.client_phone}}</td>
                    <td>{{msg.feedback}}</td>
                    <td>{{msg.ftime}}</td>
                    <td>
                        <a class="text-danger" data-id="{{msg.id}}" ng-click="deleteFeedback($event)" href="#">删除</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

    {/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/user/{$script_name}.js"></script>

<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom"><ul class="pagination-sm pagination"></ul></div>
</div>

{include file='../__footer_v2.tpl'}

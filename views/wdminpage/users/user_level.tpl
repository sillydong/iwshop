{include file='../__header_v2.tpl'}
{assign var="script_name" value="orders_manage_controller"}

<div class="pd15" ng-controller="userLevelController" ng-app="ngApp">

    {include file='../modal/user/modal_user_level_alter.html'}
    {include file='../modal/user/modal_user_level_delete.html'}

    {literal}

        <div class="pheader clearfix">
            <div class="pull-right">
                <div class="button-set">
                    <button type="button" data-toggle="modal" data-id="0" data-isEdit="0" data-target="#modal_user_level_alter" class="btn btn-success"><span style="top: 1px;right:3px;" class="glyphicon glyphicon-plus" aria-hidden="true"></span>添加</button>
                    <button type="button" class="btn btn-gray" onclick="location.reload()">刷新</button>
                </div>
            </div>
        </div>

        <div class="panel panel-default" style="margin-bottom: 50px;">
            <table class="table table-hover table-bordered">
                <thead>
                    <tr>
                        <th>编号</th>
                        <th>名称</th>
                        <th>积分要求</th>
                        <th>折扣（%）</th>
                        <th>积分返比（%）</th>
                        <th width="300px">备注</th>
                        <th width="70px">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="level in levelList">
                        <td>{{level.id}}</td>
                        <td>{{level.level_name}}</td>
                        <td>{{level.level_credit}}</td>
                        <td><span class="label label-info" ng-bind="::level.level_discount + '%'"></span></td>
                        <td><span class="label label-success" ng-bind="::level.level_credit_feed + '%'"></span></td>
                        <td class="text-muted" style="word-wrap: break-word !important; line-height: 20px !important;white-space: initial !important;" ng-bind="::level.remark"></td>
                        <td>
                            <a class="text-success" data-isedit="1" data-toggle="modal" data-target="#modal_user_level_alter" data-id="{{level.id}}" href="#">编辑</a>
                            <a class="text-danger" data-toggle="modal" data-target="#modal_user_level_delete" data-id="{{level.id}}" href="#">删除</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

    {/literal}

    <script type="text/javascript" src="{$docroot}static/script/Wdmin/user/user_level_controller.js"></script>

</div>

{include file='../__footer_v2.tpl'} 
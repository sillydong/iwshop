{include file='../__header_v2.tpl'}

<div class="pd15" ng-controller="companyRebateController" ng-app="ngApp">

    {include file='../modal/company/modal_company_rule_alter.html'}
    {include file='../modal/company/modal_company_level_delete.html'}

    {literal}

        <div class="pheader clearfix">
            <div class="pull-right">
                <div class="button-set">
                    <button type="button" data-toggle="modal" data-id="0" data-isEdit="0" data-target="#modal_company_rule_alter" class="btn btn-success"><span style="top: 1px;right:3px;" class="glyphicon glyphicon-plus" aria-hidden="true"></span>添加</button>
                    <button type="button" class="btn btn-gray" onclick="location.reload()">刷新</button>
                </div>
            </div>
        </div>

        <div class="panel panel-default" style="margin-bottom: 50px;">
            <table class="table table-hover table-bordered">
                <thead>
                <tr>
                    <th>规则名称</th>
                    <th>分组名称</th>
                    <th>层级</th>
                    <th>返佣方式</th>
                    <th>返佣点数</th>
                    <th>备注</th>
                    <th>添加时间</th>
                    <th style="width: 70px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="level in rebate_rules">
                    <td><span class="label label-success">{{level.rule_name}}</span></td>
                    <td><span class="label label-success">{{level.level_name}}</span></td>
                    <td><span class="label label-danger">{{level.rebate_level}} 级</span></td>
                    <td ng-bind="level.rebate_type | cvRebateType"></td>
                    <td><span class="label label-success">{{level.rebate_amount}}</span></td>
                    <td ng-bind="level.remark"></td>
                    <td ng-bind="::level.addtime"></td>
                    <td>
                        <a class="text-success" data-isedit="1" data-toggle="modal" data-target="#modal_company_rule_alter" data-id="{{level.id}}" href="#">编辑</a>
                        <a class="text-danger" data-toggle="modal" data-target="#modal_user_level_delete" data-id="{{level.id}}" href="#">删除</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

    {/literal}

    <script type="text/javascript" src="{$docroot}static/script/Wdmin/company/company_rebate_controller.js"></script>

</div>

{include file='../__footer_v2.tpl'}
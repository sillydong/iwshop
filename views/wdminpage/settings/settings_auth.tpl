{include file='../__header_v2.tpl'}
{assign var="script_name" value="settings_account_controller"}
<style type="text/css">
    td{
        padding: 0px 6px !important;
    }
</style>
<div class="pd15" ng-controller="accountController" ng-app="ngApp">

    {include file='../modal/account/modal_modify_account.html'}

    {literal}

    <div class="pheader clearfix">
        <div class="pull-right">
            <div class="button-set">
                <button type="button" class="btn btn-success" data-toggle="modal" data-id="0" data-target="#modal_modify_account">
                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>添加账号
                </button>
                <button type="button" class="btn btn-gray" id="list-reload" onclick="location.reload()">刷新</button>
            </div>
        </div>
    </div>

    <table class="table table-hover table-bordered" style="table-layout: fixed;">
        <thead>
        <tr>
            <th width="45px">编号</th>
            <th>姓名</th>
            <th>账号</th>
            <th width="300px">权限</th>
            <th>最近登陆</th>
            <th>最近登陆IP</th>
            <th style="width: 65px;">操作</th>
        </tr>
        </thead>
        <tbody>
        <tr ng-repeat="usr in levelList" class="usrlist">
            <td>{{usr.id}}</td>
            <td>{{usr.admin_name}}</td>
            <td>{{usr.admin_account}}</td>
            <td class="breakTd">
                <p style="margin: 7px 0;">{{usr.admin_authstr}}</p>
            </td>
            <td class="breakTd">{{usr.admin_last_login}}</td>
            <td>{{usr.admin_ip_address}}</td>
            <td>
                <a class="text-success" data-toggle="modal" data-target="#modal_modify_account" data-id="{{usr.id}}" href="#">编辑</a>
                <a class="text-danger" data-id="{{usr.id}}" ng-click="deleteAccount($event)" href="#">删除</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>

{/literal}

</div>

<script type="text/javascript" src="{$docroot}static/script/Wdmin/settings/{$script_name}.js"></script>

{include file='../__footer_v2.tpl'}

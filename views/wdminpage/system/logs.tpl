{include file='../__header_v2.tpl'}
{assign var="script_name" value="system_logs"}

<div class="pd15" ng-controller="systemLogController" ng-app="ngApp">

    {include file='../modal/company/modal_modify_company.html'}
    {include file='../modal/company/modal_delete_company.html'}
    {include file='../modal/settings/modal_modify_text.html'}

    {literal}

    <div class="pheader clearfix">
        <div class="pull-left">
        </div>
        <div class="pull-right">
            <div class="button-set">
                <button type="button" class="btn btn-default" id="list-reload" onclick="location.reload()">
                    <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>刷新
                </button>
            </div>
        </div>
    </div>

    <table class="table table-hover table-bordered" style="table-layout: fixed;margin-bottom:54px;">
        <thead>
        <tr>
            <th width="45px">编号</th>
            <th>错误信息</th>
            <th>发生url</th>
            <th width="135px">记录时间</th>
            <th width="110px">ip地址</th>
        </tr>
        </thead>
        <tbody>
        <tr ng-repeat="log in list" style="vertical-align: top">
            <td ng-bind="log.id"></td>
            <td style="word-wrap: break-word !important; line-height: 20px !important;white-space: initial !important;"
                ng-bind="log.log_info">
            </td>
            <td style="word-wrap: break-word !important; line-height: 20px !important;white-space: initial !important;"
                ng-bind="log.log_url"></td>
            <td ng-bind="log.log_time"></td>
            <td ng-bind="log.log_ip"></td>
        </tr>
        </tbody>
    </table>
</div>

{/literal}

<!-- 分页 -->
<div class="navbar-fixed-bottom bottombar">
    <div id="pager-bottom">
        <ul class="pagination-sm pagination"></ul>
    </div>
</div>
<!-- 分页 -->

<script type="text/javascript" src="{$docroot}static/script/Wdmin/system/{$script_name}.js"></script>

{include file='../__footer_v2.tpl'}

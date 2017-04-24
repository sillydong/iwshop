{include file='../__header_v2.tpl'}
{assign var="script_name" value="company_list_controller"}

<script type="text/javascript" src="{$docroot}static/script/lib/umeditor/umeditor.config.js"></script>
<script type="text/javascript" src="{$docroot}static/script/lib/umeditor/umeditor.min.js"></script>
<script type="text/javascript" src="{$docroot}static/script/lib/treeTable/jquery.treeTable.js"></script>

<div class="pd15" ng-controller="accountController" ng-app="ngApp">

    {include file='../modal/company/modal_modify_company.html'}
    {include file='../modal/company/modal_delete_company.html'}
    {include file='../modal/settings/modal_modify_text.html'}

    {literal}

    <div class="pheader clearfix">
        <div class="pull-left">
            <div id="SummaryBoard" style="width:350px">
                <div class="row">
                    <div class="col-xs-9">
                        <div class="input-group">
                            <div class="input-group-btn">
                                <button type="button" style="line-height: 20px;"
                                        class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                                        aria-haspopup="true" aria-expanded="false">
                                    <span id="search-type-label">姓名</span>
                                    <span class="caret" style="margin-left: 5px;"></span>
                                </button>
                                <ul class="dropdown-menu small" id="search-type">
                                    <li><a href="#" data-type="0">姓名</a></li>
                                    <li><a href="#" data-type="0">电话</a></li>
                                </ul>
                            </div>
                            <input type="text" style="height: 32px;border-left: 0;" class="form-control search-field"
                                   placeholder="请输入搜索内容"
                                   aria-describedby="sizing-addon3" id="search-key"/>

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
                <button type="button" class="btn btn-default" id="list-reload" ng-click="switchList(0);"
                        ng-show="params.verifed==1">
                    <span class="glyphicon glyphicon-saved" aria-hidden="true"></span>审核 <span
                            ng-bind="'(' + unverifed + ')'"></span>
                </button>
                <button type="button" class="btn btn-primary" id="list-reload" ng-click="switchList(1);"
                        ng-class="{'btn-success': 'params.verifed==1'}"
                        ng-show="params.verifed==0">
                    <span class="glyphicon glyphicon-saved" aria-hidden="true"></span>代理 <span
                            ng-bind="'(' + verifed + ')'"></span>
                </button>
                <button type="button" data-toggle="modal" class="btn btn-default" data-name="代理协议"
                        data-action="setAgreement" data-target="#modal_modify_text">
                    <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>协议
                </button>
                <button type="button" class="btn btn-default" id="list-reload" onclick="location.reload()">
                    <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>刷新
                </button>
            </div>
        </div>
    </div>

    <table id="treeTable1" class="table table-hover table-bordered" style="margin-bottom:55px;">
        <thead>
        <tr>
            <th>编号</th>
            <th>姓名</th>
            <th>组别</th>
            <th>邮箱</th>
            <th>电话</th>
            <th>客户</th>
            <th>成交</th>
            <th>本月收益</th>
            <th>总收益</th>
            <th>未结算</th>
            <th width="135px">加入时间</th>
            <th width="70px">操作</th>
        </tr>
        </thead>
        <tbody>
        <tr ng-repeat="usr in com_list" class="usrlist" id="{{usr.uid}}" pId="{{usr.parent}}" repeat-finish>
            <td><b ng-bind="::'#' + usr.uid"></b></td>
            <td ng-bind="::usr.name" class="Elipsis"></td>
            <td ng-bind="usr.level_name"></td>
            <td>{{usr.email}}</td>
            <td>{{usr.phone}}</td>
            <td>{{usr.fellow_count}}人</td>
            <td>{{usr.orderscount}}笔</td>
            <td class="text-danger">&yen;{{usr.income_month}}</td>
            <td class="text-danger">&yen;{{usr.income_total}}</td>
            <td class="text-danger">&yen;{{usr.income_unset}}</td>
            <td>{{usr.join_date}}</td>
            <td>
                <!-- 正式列表 -->
                <div ng-show="params.verifed==1">
                    <a class="text-success" data-toggle="modal" data-target="#modal_modify_company" data-id="{{usr.id}}"
                       href="#">编辑</a>
                    <a class="text-danger" data-id="{{usr.id}}" ng-click="deleteAccount($event)" href="#">删除</a>
                </div>
                <!-- 审核列表 -->
                <div ng-show="params.verifed==0">
                    <a class="text-success" data-id="{{usr.id}}" data-toggle="modal" data-target="#modal_modify_company"
                       href="#">通过</a>
                    <a class="text-danger" data-id="{{usr.id}}" ng-click="denyReq($event)" href="#">拒绝</a>
                </div>
            </td>
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

<script type="text/javascript" src="{$docroot}static/script/Wdmin/company/{$script_name}.js"></script>

{include file='../__footer_v2.tpl'}

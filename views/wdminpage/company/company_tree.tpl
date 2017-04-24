{include file='../__header_v2.tpl'}

<script src="/static/script/lib/treeTable/jquery.treeTable.js" type="text/javascript"></script>
<script type="text/javascript" src="{$docroot}static/script/Wdmin/company/company_tree_controller.js"></script>

<div class="pd15" ng-controller="companyTreeController" ng-app="ngApp">

    <div class="panel panel-default" style="margin-bottom: 50px;">

        <table id="treeTable1" class="table table-hover table-bordered">
            <thead>
            <tr>
                <th style="width:200px;">姓名</th>
                <th>编号</th>
                <th>邮箱</th>
                <th>电话</th>
                <th>余额</th>
                <th>会员</th>
                <th>总收入</th>
                <th>未结算</th>
                <th>加入时间</th>
            </tr>
            </thead>
        </table>

    </div>

</div>

{include file='../__footer_v2.tpl'}
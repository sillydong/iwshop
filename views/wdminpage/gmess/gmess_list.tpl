{include file='../__header_v2.tpl'}
<div class="pd15" ng-controller="gmessListController" ng-app="ngApp" style="margin-bottom: 45px;">

    <input type="hidden" id="groudId" value="{$gid}"/>

    {include file='../modal/gmess/modal_gmess_clone.html'}

    {literal}

    <div class="pheader clearfix">
        <div class="pull-left">
            <div id="SummaryBoard" style="width:250px">
                <div class="row">
                    <div class="col-xs-9">
                        <div class="input-group">
                            <input type="text" style="height: 30px;" class="form-control" placeholder="标题/作者/摘要"
                                   aria-describedby="sizing-addon3" id="search-key"/>

                            <div class="input-group-btn">
                                <button style="height: 30px;" type="button" id="search-button"
                                        class="btn btn-default"><span
                                            style="right: 1px;" class="glyphicon glyphicon-search"
                                            aria-hidden="true"></span></button>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-2" style="padding: 0" ng-show="listmode == 1">
                        <select class="form-control input-sm" ng-model="gmessCategoryId" style="width: 80px;"
                                ng-options="cate.id as cate.name for cate in gmessCategory"></select>
                    </div>
                </div>
            </div>
        </div>
        <div class="pull-right">
            <div class="button-set">
                <button type="button" class="btn btn-success" data-toggle="tooltip" data-placement="bottom"
                        title="点击新建一个图文消息" onclick="location.href = '?/wGmess/gmess_edit/'">新建
                </button>
                <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#modal_gmess_cloudsearch" ng-click="listmode = 1">
                    <span class="glyphicon glyphicon-cloud" aria-hidden="true"></span> 素材库
                </button>
                <button type="button" class="btn btn-success" data-toggle="modal"
                        data-target="#modal_gmess_cloudsearch" ng-click="listmode = 0">
                    <span class="glyphicon glyphicon-picture" aria-hidden="true"></span> 我的素材
                </button>
                <button type="button" class="btn btn-gray" onclick="location.reload()">刷新</button>
            </div>
        </div>
    </div>

    <div id="gmess-listing" ng-show="listcount > 0">
        <div class="row">
            <!-- 普通素材 -->
            <div class="col-xs-4 col-md-3 col-lg-3" ng-show="listmode == 0" ng-repeat="gmess in gmessList">
                <div class="gmessItems">
                    <a href="{{gmess.href}}" data-toggle="tooltip" data-placement="top" title="{{gmess.title}}"
                       target="_blank"><h1 ng-bind="gmess.title" class="Elipsis"></h1></a>

                    <h2>
                        <i ng-bind="gmess.createtime"></i>
                        <span class="text-muted" style="float: right" ng-bind="gmess.userName"></span>
                    </h2>

                    <div class="imageThumb" style="background-image: url({{gmess.catimg}});"></div>

                    <div class="row">
                        <div class="col-xs-4">
                            <a class="edit-btn" data-toggle="tooltip" data-placement="top" title="编辑"
                               href="?/wGmess/gmess_edit/id={{gmess.id}}"><span class="glyphicon glyphicon-pencil"
                                                                                aria-hidden="true"></span></a>
                        </div>
                        <div class="col-xs-4">
                            <a class="send-btn" ng-click="sendGmess(gmess.media_id)"
                               title="群发素材"
                               href="javascript:;"><span class="glyphicon glyphicon-send" aria-hidden="true"></a>
                        </div>
                        <div class="col-xs-4">
                            <a class="delete-btn" ng-click="deleteGmess(gmess.id)" data-toggle="tooltip"
                               data-placement="top"
                               title="删除"
                               href="javascript:;"><span class="glyphicon glyphicon-trash" aria-hidden="true"></a>
                        </div>
                    </div>

                </div>
            </div>
            <!-- 素材库 -->
            <div class="col-xs-4 col-md-3 col-lg-3" ng-show="listmode == 1"
                 ng-repeat="gmess in gmessCloudList.contentlist">
                <div class="gmessItems">
                    <a href="{{gmess.url}}" data-toggle="tooltip" data-placement="top" title="{{gmess.title}}"
                       target="_blank"><h1 ng-bind="gmess.title" class="Elipsis"></h1></a>

                    <h2>
                        <i ng-bind="gmess.date"></i>
                        <span class="text-muted" style="float: right" ng-bind="gmess.userName"></span>
                    </h2>

                    <div class="imageThumb" style="background-image: url({{gmess.contentImg}});"></div>

                    <div class="row">
                        <div class="col-xs-12">
                            <a class="import-btn" href="#" data-id="{{gmess.id}}" data-toggle="modal"
                               data-target="#modal_gmess_clone"><span class="glyphicon glyphicon-import"
                                                                      aria-hidden="true"></a>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div class="navbar-fixed-bottom bottombar">
        <div id="pager-bottom-left">
            共找到：<b ng-bind="listcount"></b>个素材 <span class="text-muted" ng-show="listmode == 1">数据来自SHOWAPI</span>
        </div>
        <div id="pager-bottom">
            <ul class="pagination-sm pagination"></ul>
        </div>
    </div>

</div>

{/literal}

</div>

<script type="text/javascript" src="static/script/Wdmin/gmess/gmess_list.js"></script>

{include file='../__footer_v2.tpl'}

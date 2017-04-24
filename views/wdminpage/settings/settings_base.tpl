{include file='../__header.tpl'}
<i id="scriptTag">{$docroot}static/script/Wdmin/settings/setting_base.js</i>
<link rel="stylesheet" type="text/css" href="{$docroot}static/css/bootstrap/bootstrap.css"/>
<style type="text/css">
    .tab-pane {
        padding: 15px 0;
    }

    .nav-tabs a {
        color: #000;
        padding: 7px 20px !important;
    }
</style>
<form style="padding:15px 20px;padding-bottom: 70px;" id="settingFrom">

    <div>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist" id="setting_tab">
            <li role="presentation" class="active">
                <a href="#base" aria-controls="base" role="tab" data-toggle="tab">基础设置</a>
            </li>
            <li role="presentation">
                <a href="#profile" aria-controls="profile" role="tab" data-toggle="tab">会员设置</a>
            </li>
            <li role="presentation">
                <a href="#reci" aria-controls="reci" role="tab" data-toggle="tab">发票设置</a>
            </li>
            {*<li role="presentation">*}
                {*<a href="#params" aria-controls="params" role="tab" data-toggle="tab">参数设置</a>*}
            {*</li>*}
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane fade in active" id="base">
                {include file='./tab_setting_base.tpl'}
            </div>
            <div role="tabpanel" class="tab-pane fade" id="profile">
                {include file='./tab_setting_user.tpl'}
            </div>
            <div role="tabpanel" class="tab-pane fade" id="reci">
                {include file='./tab_setting_reci.tpl'}
            </div>
            <div role="tabpanel" class="tab-pane fade" id="params">

            </div>
        </div>

    </div>

</form>


<div class="fix_bottom" style="position: fixed; height: 58px;">
    <a class="btn btn-success" id='saveBtn' style="width:150px" href="javascript:;">
        <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span>保存设置
    </a>
</div>

{include file='../__footer.tpl'} 
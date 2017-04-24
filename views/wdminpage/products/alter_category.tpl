{include file='../__header.tpl'}
<link rel="stylesheet" type="text/css" href="{$docroot}static/css/bootstrap/bootstrap.css"/>
<i id="scriptTag">page_alter_categroy</i>
<div class="clearfix" style="padding:15px;padding-bottom: 45px;">
    <form style="padding:10px;" id="catForm">
        <input type="hidden" value="{$id}" id="cat_id"/>
        <input type="hidden" value="{$cat.cat_parent}" id="cat_parent"/>

        <div style="width:35%;margin-bottom: 10px;">

            <div class="gs-label">分类名称</div>
            <input type="text" style="margin-bottom: 10px" class="form-control" name="cat_name" id='cat_name'
                   value="{$cat.cat_name}"/>

            <div class="gs-label">分类排序 <b>数字越大排序越前</b></div>
            <input type="text" style="margin-bottom: 10px" class="form-control" name="cat_order" id='cat_order'
                   value="{$cat.cat_order}"/>

            <div class="gs-label">上级分类 <b>不能选择下级目录或自己为自己父级</b></div>
            <select id="pd-cat-select" class="form-control" style="color:#666" name="cat_parent">
                <option value="0">顶级分类</option>
                {foreach from=$categorys item=cat1}
                    <option value="{$cat1.dataId}">{$cat1.name}</option>
                    {foreach from=$cat1.children item=cat2}
                        <option value="{$cat2.dataId}">-- {$cat2.name}</option>
                        {foreach from=$cat2.children item=cat3}
                            <option value="{$cat3.dataId}">---- {$cat3.name}</option>
                        {/foreach}
                    {/foreach}
                {/foreach}
            </select>

        </div>
        <div class="gs-label">分类图片 <b>建议使用200&#215;200正方形图片</b></div>
        <div class="clearfix">
            <div class="alter-cat-img left" style="min-width: 45%;">
                <input type="hidden" value="{$cat.cat_image}" id="cat_image_src" name="cat_image"/>
                <img id="catimage" {if $cat.cat_image eq ''}style="display:none"{/if} src="{$cat.cat_image}"/>
                {if $cat.cat_image eq ''}
                    <div style='line-height: 100px;color:#777;' class='align-center' id="cat_none_pic">无图片</div>
                {/if}
                <div class="align-center top10">
                    <a class="btn btn-success" id="alter_categroy_image">更换图片</a>
                </div>
            </div>
        </div>
    </form>
    <div class="fix_bottom fixed">
        <a class="btn btn-success" id='save-cate'><span class="
glyphicon glyphicon-floppy-disk" aria-hidden="true"></span>保存</a>
        <a class="btn btn-danger" id="del-cate"><span class="
glyphicon glyphicon-trash" aria-hidden="true"></span>删除</a>
    </div>
</div>
{include file='../__footer.tpl'} 
<div style="width: 250px;position: relative;padding:5px;"> 
    <div class="gs-label">分类名称</div>
    <div class="gs-text">
        <input type="text" name="cat_name" id="cat_name_f" value="" />
    </div>
    <div class="gs-label">上级分类</div>
    <select id="pd-cat-select" style="color:#666">
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
    <div class="align-center top10">
        <a class="wd-btn primary" id="add_cate_btn" href="javascript:;" style="margin-left: 0">添加</a>
    </div>
</div>
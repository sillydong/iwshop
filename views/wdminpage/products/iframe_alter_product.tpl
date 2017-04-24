{include file='../__header.tpl'}
<link rel="stylesheet" type="text/css" href="static/css/bootstrap/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="static/css/jquery.datetimepicker.css"/>
{if $ed}<input type="hidden" value="{$pd.product_id}" id="pid" />{/if}
<input type="hidden" value="{$mod}" id="mod"/>
<input type="hidden" value="{$smarty.server.HTTP_REFERER}" id="http_referer"/>
<i id="scriptTag">page_iframe_alter_product</i>
<form id="pd-baseinfo" class='pt58'>
    <div style="padding: 22px;" class="clearfix">

        <input id="pd-catimg" name="catimg" type="hidden" value="{$pd.catimg}"/>
        <input id="pd-serial-val" type="hidden" value="{$pd.product_serial}"/>
        <input id="pd-form-cat" type="hidden" value="{$cat}"/>
        {foreach from=$pd.images item=pdi}
            <input class="pd-images" type="hidden" value="{$pdi.image_path}" data-sort="{$pdi.image_sort}"/>
        {/foreach}

        <div class="clearfix">

            <div id="alterProductLeft">

                <!-- 商品名称 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品名称</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_name"
                               value="{if $ed}{$pd.product_name}{/if}" id="pd-form-title" autofocus/>
                    </div>
                </div>

                <!-- 商品简称 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品简称</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_subname" id="pd-form-subname"
                               value="{if $ed}{$pd.product_subname}{/if}"/>
                    </div>
                </div>

                <!-- 商品编号 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品编号</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_code" onclick="this.select();"
                               value="{if $ed}{$pd.product_code}{/if}" id="pd-form-code"/>
                    </div>
                </div>

                <!-- 商品简介 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品简介</span>
                    </div>
                    <div class="fv2Right">
                        <textarea name="product_subtitle" class="form-control" style="width: 100%"
                                  placeholder="请填写商品简介" rows="4">{if $ed > 0}{$pd.product_subtitle}{/if}</textarea>
                    </div>
                </div>

                <!-- 商品分类 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品分类</span>
                    </div>
                    <div class="fv2Right">
                        {strip}
                            <select class="form-control" id="pd-catselect" style="color:#000" name="product_cat">
                                {if $categorys|count > 0}
                                    {foreach from=$categorys item=cat1}
                                        <option value="{$cat1.dataId}"
                                                {if $cat1.hasChildren}disabled{/if}>{$cat1.name}</option>
                                        {foreach from=$cat1.children item=cat2}
                                            <option value="{$cat2.dataId}" {if $cat2.hasChildren}disabled{/if}>
                                                -- {$cat2.name}</option>
                                            {foreach from=$cat2.children item=cat3}
                                                <option value="{$cat3.dataId}" {if $cat3.hasChildren}disabled{/if}>
                                                    ---- {$cat3.name}</option>
                                                {foreach from=$cat3.children item=cat4}
                                                    <option value="{$cat4.dataId}" {if $cat4.hasChildren}disabled{/if}>
                                                        ------ {$cat4.name}</option>
                                                {/foreach}
                                            {/foreach}
                                        {/foreach}
                                    {/foreach}
                                {else}
                                    <option value="0">未分类</option>
                                {/if}
                            </select>
                        {/strip}
                    </div>
                </div>

                <!-- 商品品牌 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品品牌</span>
                    </div>
                    <div class="fv2Right">
                        <select class="form-control" id="pd-serial" name="product_brand">
                            <option value="0" {if $pd.product_brand eq 0}selected{/if}>默认</option>
                            {foreach from=$brands item=ser}
                                <option value="{$ser.id}"
                                        {if $pd.product_brand eq $ser.id}selected{/if}>{$ser.brand_name}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <!-- 商户名称 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商户名称</span>
                    </div>
                    <div class="fv2Right">
                        <select class="form-control" id="pd-suppliers" name="product_supplier">
                            <option value="0" {if $pd.suppiler eq 0}selected{/if}>无</option>
                            {foreach from=$suppliers item=supp}
                                <option value="{$supp.id}"
                                        {if $pd.product_supplier eq $supp.id}selected{/if}>{$supp.supp_name}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <!-- 商品价格 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品价格</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text"  class="form-control" name="sell_price" onclick="this.select();"
                               value="{if $ed}{$pd.sell_price}{else}0.00{/if}" 
                               id="pd-form-prices"/>
                               
                    </div>
                </div>

                <!-- 参考价格 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>参考价格</span>
                    </div>
                    <div class="fv2Right">
                        <input type="hidden" id="pd-form-discount" value="{if $ed}{$pd.discount}{else}100{/if}"/>
                        <input type="text" class="form-control" name="market_price" onclick="this.select();"
                               value="{if $ed and $pd.market_price}{$pd.market_price}{else}0.00{/if}"
                               id="market_price"/>
                    </div>
                </div>

                <!-- 商品重量 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品重量</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_weight" id="pd-form-weight"
                               value="{if $ed > 0}{$pd.product_weight}{else}0{/if}"/>

                        <div class='fv2Tip'>订单运费计算必备参数，0为默认包邮，单位：克</div>
                    </div>
                </div>

                <!-- 商品产地 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品产地</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_origin"
                               value="{if $ed > 0}{$pd.product_origin}{/if}"/>

                        <div class='fv2Tip'>产品原产地</div>
                    </div>
                </div>

                <!-- 储存条件 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>储存条件</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_storage"
                               value="{if $ed > 0}{$pd.product_storage}{/if}"/>

                        <div class='fv2Tip'>冰鲜、干燥、避光等</div>
                    </div>
                </div>

                <!-- 商品单位 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品单位</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_unit"
                               value="{if $ed > 0}{$pd.product_unit}{/if}"/>

                        <div class='fv2Tip'>99片/包等</div>
                    </div>
                </div>

                <!-- 商品供货价 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品供货价</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="supply_price"
                               value="{if $ed > 0}{$pd.supply_price}{/if}"/>

                        <div class='fv2Tip'>供货价（用于计算产品利润）</div>
                    </div>
                </div>

                <!-- 商品库存 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品库存</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_instocks"
                               value="{if $ed > 0}{$pd.product_instocks}{/if}"/>

                        <div class='fv2Tip'>如果该商品没有设置任何规格，则会使用此库存</div>
                    </div>
                </div>

                <!-- 积分奖励 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>积分奖励</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_credit" id="pd-form-credit"
                               value="{if $ed > 0}{$pd.product_credit}{else}0{/if}"/>

                        <div class='fv2Tip'>用户购买商品之后，奖励的积分数量</div>
                    </div>
                </div>

                <!-- 商品运费 -->
                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>固定运费</span>
                    </div>
                    <div class="fv2Right">
                        <input type="text" class="form-control" name="product_expfee" id="pd-expfee"
                               value="{if $ed and $pd.product_expfee > 0}{$pd.product_expfee}{else}0{/if}"/>

                        <div class='fv2Tip'>订单将以这个金额计算运费，默认为0</div>
                    </div>
                </div>

                <div class="fv2Field clearfix">
                    <div class="fv2Left">
                        <span>商品秒杀</span>
                    </div>
                    <div class="fv2Right">
                        <select class="form-control" id="pd-prom" name="product_prom">
                            <option value="0" {if $pd.product_prom eq 0}selected{/if}>不参与秒杀</option>
                            <option value="1" {if $pd.product_prom eq 1}selected{/if}>参与秒杀</option>
                        </select>

                        <div id="prom_option" class="{if $pd.product_prom eq 0}hidden{/if}" style="margin-top: 10px;">
                            <input type="text" class="form-control mt10" name="product_prom_limitdate"
                                   id="pd-form-msexp" value="{$pd.product_prom_limitdate}"/>

                            <div class='fv2Tip'>过期时间 例如：(2015-07-30 00:00)</div>
                            <input type="text" class="form-control mt10" name="product_prom_limitdays"
                                   id="pd-form-msdays" value="{$pd.product_prom_limitdays}"/>

                            <div class='fv2Tip'>用户秒杀间隔，单位：天</div>
                            <input type="text" class="form-control mt10" name="product_prom_limit" id="pd-form-mscount"
                                   value="{$pd.product_prom_limit}"/>

                            <div class='fv2Tip'>用户限购数量，单位：件</div>
                            <input type="text" class="form-control mt10" name="product_prom_discount"
                                   id="pd-form-discount" value="{$pd.product_prom_discount}"/>

                            <div class='fv2Tip'>秒杀折扣，必填选项，百分比（1-100）</div>
                        </div>
                    </div>
                </div>

            </div>

            <div id="alterProductRight">
                <div class="t1">商品首图</div>
                <!-- 商品大图 -->
                <a class="pd-image-sec" data-id="0" href="javascript:;"></a>
                <div class="t2">建议使用500&#215;500尺寸图片 <a id="catimgPv" href="">预览</a></div>
            </div>

        </div>

        <div class="fv2Field clearfix" style="max-width:100%;">
            <div class="fv2Left">
                <span>商品规格</span>
            </div>
            <div class="fv2Right">
                <div class="button-set l pt0">
                    <!-- 规格增加按钮 -->
                    <a class="button" id="pd-spec-add" href="javascript:;">添加</a>
                    <!-- 规格管理按钮 -->
                    <a class="button orange"
                       onclick="$('#__specmanage', parent.parent.document).get(0).click();">规格管理</a>
                </div>
                <table class="table table-bordered {if $pd.specs|count eq 0}hidden{/if}" id='pd-spec-frame'>
                    <thead>
                    <tr>
                        <th style="width: 180px;">规格</th>
                        <th style="width: 180px;">>规格</th>
                        <th>售价</th>
                        <th>市场价</th>
                        <th>库存</th>
                        <th style="width: 40px;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr class="specselect hidden" data-id="#">
                        <td>
                            <select class="spec1">
                                <option value="0">无规格</option>
                                {foreach from=$speclist item=spec}
                                    {foreach from=$spec.dets item=dets}
                                        <option value="{$dets.id}" data-spec="{$spec.id}"
                                                data-name="{$spec.spec_name}">{$spec.spec_name}({$dets.det_name})
                                        </option>
                                    {/foreach}
                                {/foreach}
                            </select>
                        </td>
                        <td>
                            <select class="spec2">
                                <option value="0">无规格</option>
                                {foreach from=$speclist item=spec}
                                    {foreach from=$spec.dets item=dets}
                                        <option value="{$dets.id}" data-spec="{$spec.id}"
                                                data-name="{$spec.spec_name}">{$spec.spec_name}({$dets.det_name})
                                        </option>
                                    {/foreach}
                                {/foreach}
                            </select>
                        </td>
                        <td><input type="text" onclick="this.select();" class="pd-spec-prices"
                                   value="{$specs.sale_price}"></td>
                        <td><input type="text" onclick="this.select();" class="pd-spec-market"
                                   value="{$specs.market_price}"></td>
                        <td><input type="text" onclick="this.select();" class="pd-spec-stock" value="{$specs.instock}">
                        </td>
                        <td><a class="btn-delete-spectr" href="javascript:;">删除</a></td>
                    </tr>
                    {foreach from=$pd.specs item=specs}
                        <tr class="specselect" data-id="{$specs.id}">
                            <td>
                                <select class="spec1">
                                    <option value="0">无规格</option>
                                    {foreach from=$speclist item=spec}
                                        {foreach from=$spec.dets item=dets}
                                            <option value="{$dets.id}" data-spec="{$spec.id}"
                                                    data-name="{$spec.spec_name}"
                                                    {if $specs.id1 eq $dets.id}selected{/if}>{$spec.spec_name}
                                                ({$dets.det_name})
                                            </option>
                                        {/foreach}
                                    {/foreach}
                                </select>
                            </td>
                            <td>
                                <select class="spec2">
                                    <option value="0">无规格</option>
                                    {foreach from=$speclist item=spec}
                                        {foreach from=$spec.dets item=dets}
                                            <option value="{$dets.id}" data-spec="{$spec.id}"
                                                    data-name="{$spec.spec_name}"
                                                    {if $specs.id2 eq $dets.id}selected{/if}>{$spec.spec_name}
                                                ({$dets.det_name})
                                            </option>
                                        {/foreach}
                                    {/foreach}
                                </select>
                            </td>
                            <td><input type="text" onclick="this.select();" class="pd-spec-prices"
                                       value="{$specs.sale_price}"></td>
                            <td><input type="text" onclick="this.select();" class="pd-spec-market"
                                       value="{$specs.market_price}"></td>
                            <td><input type="text" onclick="this.select();" class="pd-spec-stock"
                                       value="{$specs.instock}"></td>
                            <td><a class="btn-delete-spectr" href="javascript:;">删除</a></td>
                        </tr>
                        {*                            <tr>
                        <td>{$specs.name1}</td>
                        <td>{$specs.name2}</td>
                        <td><input type="text" onclick="this.select();" class="pd-spec-prices" data-id="{$specs.id1}-{$specs.id2}" value="{$specs.sale_price}"></td>
                        <td><input type="text" onclick="this.select();" class="pd-spec-market" data-id="{$specs.id1}-{$specs.id2}" value="{$specs.market_price}"></td>
                        <td>0</td>
                        </tr>*}
                    {/foreach}
                    </tbody>
                </table>
                <div class='fv2Tip'>请点击添加 新增一项规格</div>
            </div>
        </div>

        <div class="fv2Field clearfix" style="max-width:100%;">
            <div class="fv2Left">
                <span>商品图集</span>
            </div>
            <div class="fv2Right">
                <div id="pd-ilist" class="clearfix">
                    <a class="pd-image-sec ps20" data-id="1" href="javascript:;"></a>
                    <a class="pd-image-sec ps20" data-id="2" href="javascript:;"></a>
                    <a class="pd-image-sec ps20" data-id="3" href="javascript:;"></a>
                    <a class="pd-image-sec ps20" data-id="4" href="javascript:;"></a>
                    <a class="pd-image-sec ps20" data-id="5" href="javascript:;" style="margin-right: 0;"></a>
                </div>
                <div class='fv2Tip'>请进行图片选择</div>
            </div>
        </div>

        <div class="fv2Field clearfix" style="max-width:100%;">
            <div class="fv2Left">
                <span>详细介绍</span>
            </div>
            <div class="fv2Right">
                <script style='width:100%;' id="ueditorp" type="text/plain"
                        name="product_desc">{if $ed}{$pd.product_desc}{/if}</script>
            </div>
        </div>

    </div>

</form>
<div class="fix_top fixed" style="height: 55px;">
    <div class='button-set' style="margin-top: 13px;margin-right: 13px;">
        <a class='btn btn-success' id="save_product_btn" href="javascript:;">
            <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span>保存
        </a>
        {if $mod ne 'add'}
            <a class="btn btn-danger" data-product-id="{$pd.product_id}" style="margin-left: 5px;">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </a>
        {/if}
        <a onclick="location.href = $('#http_referer').val();" class="btn btn-default" style="margin-left: 5px;">返回</a>
    </div>
</div>
{include file='../__footer.tpl'} 
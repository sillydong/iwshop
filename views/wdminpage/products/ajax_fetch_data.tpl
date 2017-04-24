<div style="width: 250px;position: relative;padding:5px;"> 
    <div class="gs-label">商品信息种类</div>
    <div class="gs-text">
        <p>来自京东的商品信息</p>
        {foreach item=pd from=$product_info}
            <div class="fv2Field clearfix">
                <div class="fv2Left">
                    <span>商品名称</span>
                </div>
                <div class="fv2Right">
                    <input type="text" class="gs-input" value="{$pd.product_name}"/>
                </div>
            </div>  
            <div class="fv2Field clearfix">
                <div class="fv2Left">
                    <span>商品描述</span>
                </div>
                <div class="fv2Right">
                    <input type="text" class="gs-input"  value="{$pd.product_desc}"/>
                </div>
            </div> 
            <div class="fv2Field clearfix">
                <div class="fv2Left">
                    <span>商品价格</span>
                </div>
                <div class="fv2Right">
                    <input type="text" class="gs-input" value="{$pd.product_price}"/>
                </div>
            </div> 
        {/foreach}
    </div>
</div>
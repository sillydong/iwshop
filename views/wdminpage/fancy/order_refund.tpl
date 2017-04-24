<div style="width:550px;">
    <div class="orderwpa-top">
        <span class="orderwpa-amount" data-amount='{$data.order_amount}'>&yen;{$data.order_amount}</span>
        <span class="orderwpa-serial">
            订单状态：<span class="orderstatus {$data.status}">{$data.statusX}</span>
            <br />
            {if $data.status eq 'delivering' or $data.status eq 'received'}
                快递信息：{$data.expressName} &lt;<a href="javascript:;" title="点击查询" onclick="$.fancybox.close();
                        $('#od-exp-view{$data.order_id}').click();">{$data.express_code}</a>&gt;
                <br />
            {/if}
            下单时间：{$data.order_time}
            <br />
            订单编号：{$data.serial_number} 
            <br />
            微支付号：{$data.wepay_serial}
        </span>
    </div>
    <div class="clearfix">
        {section name=od loop=$data.products}
            <div class='orderwpa-pdlist'>
                <img width="60px" height="60px" src="{$docroot}static/Thumbnail/?w=100&h=100&p={$config.productPicLink}{$data.products[od].catimg}" />
                <div style="margin-left: 70px;height: 60px;line-height: 20px;">
                    <div style="height:42px;overflow:hidden;padding-right: 2px;">{$data.products[od].product_name}</div>
                    <div style="margin-top:3px;">
                        <i class="opprice">&yen;{$data.products[od].product_discount_price}</i> &times; 
                        <i id="order{$data.order_id}count" class="opcount">{$data.products[od].product_count}</i>
                    </div>
                </div>
            </div>
        {/section}
    </div>
    <div class="orderwpa-address clearfix">
        <p>姓名：{$data.address.user_name}</p>
        <p>电话：{$data.address.tel_number}</p>
        <p>地址：{$data.address.address}</p>
        <p>邮编：{$data.address.postal_code}</p>
        <p>备注：{$data.leword}</p>
    </div>
    <div style="text-align: center;padding-top:10px;" class='clearfix'>
        <input type="text" class="gs-input" id='despatchExpressCode' value="" style='float:left;width:70%;margin:0;padding:0;' placeholder="请填写退款金额"/>
        <a data-id='{$data.order_id}' class="olbtn" id='refundBtn' style='margin:0;height:28px;line-height:28px;' href='javascript:;' data-orderid="{$data.order_id}">确认退款</a>
    </div>
</div>
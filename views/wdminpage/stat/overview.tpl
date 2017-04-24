{include file='../__header.tpl'}
<link href="{$docroot}static/css/bootstrap/bootstrap.css" type="text/css" rel="Stylesheet"/>
<i id="scriptTag">{$docroot}static/script/Wdmin/stat/overview.js</i>
<style type="text/css">
    .nav-tabs > li > a {
        border-radius: 0;
    }
</style>

<div style="padding: 15px;">

    <input type="hidden" id="neworder_month" value="{$Datas.neworder_month}"/>
    <input type="hidden" id="valorder_month" value="{$Datas.valorder_month}"/>

    <div class="row">
        <div class="col-xs-6">
            <div class="panel panel-default">
                <div class="panel-heading">订单一览</div>
                <div id="order-percent2" style="height: 300px;"></div>
            </div>
        </div>
        <div class="col-xs-6">
            <div class="panel panel-default">
                <div class="panel-heading">产品销售占比</div>
                <div id="order-percent" style="height: 300px;"></div>
            </div>
        </div>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading">粉丝关注</div>
        <table class="ovw-table">
            <tr>
                <td>
                    <span>{$newFans.new_user}<b>人</b></span>
                    <span>新增关注</span>
                </td>
                <td>
                    <span>{$newFans.cancel_user}<b>人</b></span>
                    <span>取消关注</span>
                </td>
                <td>
                    <span>{$newFans.new_user - $newFans.cancel_user}<b>人</b></span>
                    <span>净增粉丝</span>
                </td>
                <td>
                    <span class="green"><i id="allfanscount">{$totalFans.cumulate_user}</i><b>人</b></span>
                    <span>总粉丝</span>
                </td>
            </tr>
            <tr>
                <td>
                    <span>{$Datas.newuser}<b>人</b></span>
                    <span>新增会员</span>
                </td>
                <td class="clickable" onclick="$('#__uslist:eq(0)', parent.document).get(0).click();">
                    <span><i id="usersum">{$Datas.alluser}</i><b>人</b></span>
                    <span>会员总数</span>
                </td>
                <td>
                    <span>{$Datas.newcoms}<b>人</b></span>
                    <span>新增代理</span>
                </td>
                <td class="clickable" onclick="$('#__comlist:eq(0)', parent.document).get(0).click();">
                    <span class="green"><i id="comsum">{$Datas.allcoms}</i><b>人</b></span>
                    <span>代理总数</span>
                </td>
            </tr>
        </table>
    </div>

    <div class="panel panel-default">
        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist" style="margin-top: -1px;margin-left: -1px;">
            <li role="presentation" class="active"><a href="#new_user" aria-controls="new_user" role="tab"
                                                      data-toggle="tab">新增粉丝({$newFans.new_user})</a></li>
            <li role="presentation"><a href="#cancel_user" aria-controls="cancel_user" role="tab" data-toggle="tab">取消关注({$newFans.cancel_user}
                    )</a></li>
            <li role="presentation"><a href="#pure_user" aria-controls="pure_user" role="tab"
                                       data-toggle="tab">净增粉丝({$newFans.new_user - $newFans.cancel_user})</a></li>
            <li role="presentation"><a href="#cumulate_user" aria-controls="cumulate_user" role="tab" data-toggle="tab">粉丝总数({$totalFans.cumulate_user}
                    )</a></li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="new_user">
                <div class="fansStatChart" style="height: 250px;padding-top: 10px;"></div>
            </div>
            <div role="tabpanel" class="tab-pane" id="cancel_user">
                <div class="fansStatChart" style="height: 250px;padding-top: 10px;"></div>
            </div>
            <div role="tabpanel" class="tab-pane" id="pure_user">
                <div class="fansStatChart" style="height: 250px;padding-top: 10px;"></div>
            </div>
            <div role="tabpanel" class="tab-pane" id="cumulate_user">
                <div class="fansStatChart" style="height: 250px;padding-top: 10px;"></div>
            </div>
        </div>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading">销售趋势</div>
        <table class="ovw-table">
            <tr>
                <td>
                    <span class="pricesx">&yen;{$Datas.saletoday}<b>元</b></span>
                    <span>今日成交</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.saleyestoday}<b>元</b></span>
                    <span>昨日成交</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.salemonth}<b>元</b></span>
                    <span>本月成交</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.saletotal}<b>元</b></span>
                    <span>历史成交</span>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="pricesx">&yen;{$Datas.pxsaletoday}<b>元</b></span>
                    <span>今日代理成交</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.pxsaleyestoday}<b>元</b></span>
                    <span>本周代理成交</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.pxsalemonth}<b>元</b></span>
                    <span>本月代理成交</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.pxsaletotal}<b>元</b></span>
                    <span>代理历史成交</span>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="green">{$Datas.neworder}<b>笔</b></span>
                    <span>今日新增订单</span>
                </td>
                <td>
                    <span>{$Datas.neworderyes}<b>笔</b></span>
                    <span>昨日新增订单</span>
                </td>
                <td>
                    <span class="green">{$Datas.neworderpayed}<b>笔</b></span>
                    <span>今日已付款订单</span>
                </td>
                <td>
                    <span>{$Datas.neworderpayedyes}<b>笔</b></span>
                    <span>昨日已付款订单</span>
                </td>
            </tr>
            <tr>
                <td class="clickable" onclick="$('#__odpaylist:eq(0)', parent.document).get(0).click();">
                    <span class="green"><i id="ordertoexp">{$Datas.orderpayed}</i><b>笔</b></span>
                    <span>未发货订单</span>
                </td>
                <td class="clickable" onclick="$('#__oddevlist:eq(0)', parent.document).get(0).click();">
                    <span class="green"><i id="orderdelivering">{$Datas.orderexped}</i><b>笔</b></span>
                    <span>已发货订单</span>
                </td>
                <td class="clickable" onclick="$('#__odcanlist:eq(0)', parent.document).get(0).click();">
                    <span class="pricesx">{$Datas.ordercanceled}<b>笔</b></span>
                    <span>退货申请</span>
                </td>
                <td class="clickable" onclick="$('#__odalllist:eq(0)', parent.document).get(0).click();">
                    <span>{$Datas.ordermonth}<b>笔</b></span>
                    <span>本月订单</span>
                </td>
            </tr>
            <tr>
                <td class="clickable" onclick="$('#__catlist:eq(0)', parent.document).get(0).click();">
                    <span>{$Datas.catotal}<b>个</b></span>
                    <span>商品分类</span>
                </td>
                <td class="clickable" onclick="$('#__pdlist:eq(0)', parent.document).get(0).click();">
                    <span>{$Datas.pdtotal}<b>种</b></span>
                    <span>商品总数</span>
                </td>
                <td>
                    <span>{$Datas.pdtotalavg}<b>次</b></span>
                    <span>平均商品浏览</span>
                </td>
                <td>
                    <span class="pricesx">&yen;{$Datas.pdpriceavg}<b>元</b></span>
                    <span>商品平均价格</span>
                </td>
            </tr>
        </table>
    </div>

    <div id="copyrights" class="text-center text-muted" style="font-size: 12px;color:#888;padding-bottom: 10px">{$settings.copyright}</div>

</div>

{include file='../__footer.tpl'} 
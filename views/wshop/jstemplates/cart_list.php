<!-- 模板开始，可以使用script（type设置为text/html）来存放模板片段，并且用id标示 -->
<script id="t:cart_list" type="text/html">
	{literal}
	<%for(var i=0;i < list.length;i++){%>

	<% var carts = list[i].cart_datas; %>

		<%for(var j=0;j < carts.length;j++){%>

		<section class="cartListWrap clearfix" id="cartsec<%=carts[j].product_id%>">
			<input type="hidden" value="<%=carts[j].envstr%>" id="pd-envs-<%=carts[j].product_id%>"
				   data-pid="<%=carts[j].product_id%>" class="pd-envstr" />
			<img alt="<%=carts[j].product_name%>" width="100" height="100" src="<%=carts[j].catimg%>" />
			<div class="cartListDesc">
				<p class="title">
					<%=carts[j].product_name%>
				</p>
				<p class="count">
						<span class="spec Elipsis"><%=carts[j].specname%></span>
						<span class="dprice prices"
							  data-expfee="{$product_list[i].product_expfee}"
							  data-price="<%=carts[j].sale_price%>"
							  data-weight="<%=carts[j].product_weight%>"
							  data-count="<%=carts[j].count%>">&yen; <%=carts[j].sale_price%>
						</span>
				</p>
				<dl class="pd-dsc clearfix">
					<dt class="productCount clearfix" data-pid="<%=carts[j].product_id%>" data-spid="<%=carts[j].spec_id%>">
						<a class="btn productCountMinus" href='javascript:;'></a>
						<span class="productCountNum">
							<input type='tel'
								   data-prom-limit="0"
								   value="<%=carts[j].count%>"
								   class="dcount productCountNumi" />
						</span>
						<a class="btn productCountPlus" href='javascript:;'></a>
					</dt>
				</dl>
				<a class="cartDelbtn" data-pdid="<%=carts[j].product_id%>" data-spid="<%=carts[j].spec_id%>"></a>
			</div>
		</section>

		<%}%>

	<%}%>
	{/literal}
</script>
<!-- 模板结束 -->
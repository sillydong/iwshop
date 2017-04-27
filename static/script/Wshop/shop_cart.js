/* global address_item_click, CryptoJS, wx, WeixinJSBridge, shoproot, addrsignPackage, address_save, o */

/**
 * 购物车
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

// order id 生成标记
window.orderId = false;
// 支付完成标记
window.payed = false;
// 收货地址加载标记
window.addressloaded = false;
// 收货地址
window.expressData = {};
// lock
window.orderCreateLock = false;
// 初始运费
window.yunfeiInitial = 6.95;

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner', 'Cart', 'mobiscroll', 'baiduTemplate'], function (util, $, Spinner, Cart, mobiscroll, baiduTemplate) {

        if ($('#promAva').val() < 1 && $('#promId').val() !== '') {
            alert('您已参与过秒杀活动');
            window.history.go(-1);
        }

        var o = {};

        /**
         * 购物车数据
         * @type {Array}
         */
        o.cartList = [];

        /**
         * 购物车数量
         * @type {number}
         */
        o.cartCount = 0;

        o.cartData = '';

        o.isProm = false;

        o.promCount = 1;

        // 促销商品Id
        o.promId = false;

        // 促销限数
        o.promLimit = false;

        // 使用的红包
        o.envsId = false;

        // 没有选择红包 询问
        o.envsAsked = false;

        // 是否有可用红包
        o.envsAva = false;

        o.envsReq = 0;

        o.envsDis = 0;

        // 是否开具发票
        o.isReci = false;

        // 发票税点
        o.ReciTex = 0;

        // 税点是否包括运费
        o.TexIncludeExp = false;

        // 税
        o.Tex = 0;

        // localStorage对象
        o.Storage = window.localStorage;

        // 运费总额
        o.ExpFee = 0;

        // 运费起点
        o.ExpFeeInitial = 0;

        // 运费模板
        o.ExpFeeTemplate = {};

        // 订单总额
        o.TotalFee = 0;

        // 订单实际额 不包括运费、优惠
        o.ActalFee = 0;

        // 系统设置
        o.settings = {};

        /**
         * 计算订单金额
         * @param {type} amount
         * @returns {undefined}
         */
        o.countAmount = function (amount) {
            $('#order_amount').html('&yen;' + (amount !== undefined ? amount : countOrderAmount()));
        };

        // 加载购物车数据
        o.loadCartData = function () {

            Spinner.spin($('#orderDetailsWrapper').get(0));
            Cart.get(function (result) {
                if (result.ret_code == 0) {
                    Spinner.stop();
                    var cartData = result.ret_msg;
                    if (cartData.total > 0) {
                        // 渲染列表数据
                        var html = baidu.template('t:cart_list', {
                            list: cartData.supps
                        });
                        // 购物车列表
                        o.cartList = cartData.supps;
                        o.cartCount = cartData.total;
                        // 渲染列表
                        $('#orderDetailsWrapper').html(html);
                        // 数量变化监听
                        fnPdCountChangerLis();
                        // 删除按钮
                        fnPdDeleteListen();
                        // 计算订单总额
                        o.countAmount();
                        // 限购数量
                        o.promLimit = parseInt($('.productCountNumi').eq(0).attr('data-prom-limit'));
                        // 红包检查
                        envsCheck();
                        $('#extra-field').show();
                    } else {
                        fnEmptyCartTip();
                    }
                } else {
                    fnEmptyCartTip();
                }
            });
        };

        function fnUpdateCartList() {
            Cart.get(function (result) {
                if (result.ret_code == 0) {
                    var cartData = result.ret_msg;
                    if (cartData.total > 0) {
                        o.cartList = cartData.supps;
                    }
                }
            });
        }

        util.getconfig(function (f) {

            o.settings = f;

            // 加载运费模板
            util.getExpTemplate(function (f1) {
                o.ExpFeeTemplate = f1;
                // 加载购物车数据
                o.loadCartData();
            });

            fnLoadExptimeSelector();

        });

        // 余额支付点击监听
        $('#cart-balance-check').click(function () {
            if (parseFloat($('#cart-balance-pay').val()) > 0) {
                // dep
                $('#order_amount').html('&yen;' + countOrderAmount(this.checked));
            }
        });

        /**
         * 购物车删除按钮点击
         */
        function fnPdDeleteListen() {
            $('.cartDelbtn').on('click', function () {
                if (confirm('是否要从购物车删除这件商品?')) {
                    delFromCart($(this).attr('data-pdid'), $(this).attr('data-spid'));
                }
				o.countAmount();
				envsCheck();
            });
        }

        // 数量变化监听
        function fnPdCountChangerLis() {

            // 数量直接赋值
            $('.productCountNumi').on('input', function () {
                var pds = fnGetPdIdsByNode(this);
                if (pds && $(this).val() > 0) {
                    Cart.set(pds[0], pds[1], $(this).val());
                    o.countAmount();
                } else {
                    $(this).val(1);
                    // 设置购物车错误 无法取得数据
                }
                pds = null;
				
                
				o.countAmount();
				envsCheck();
            });


			
            // 数量--
            // todo 合并数量加减操作
            $('.productCountMinus').bind({
                'touchend touchcancel mouseup': function (event) {
                    event.preventDefault();
                    var node = $(this).parent().find('.productCountNumi');
                    var pds = fnGetPdIdsByNode(this);
                    if (pds) {
                        if (parseInt(node.val()) <= 1) {
                            if (!o.isProm && confirm('是否要从购物车删除这件商品?')) {
                                delFromCart(pds[0], pds[1]);
                            }
                        } else {
                            node.val(parseInt(node.val()) === 1 ? 1 : node.val() - 1);
                            if (!o.isProm) {
                                Cart.set(pds[0], pds[1], +node.val(), fnUpdateCartList);
                            } else {
                                o.promCount = +node.val();
                            }
                        }
                        
                    } else {
                        // 设置购物车错误 无法取得数据
                    }
                    node = null;
                    pds = null;
					
                    
					o.countAmount();
					envsCheck();
                }
            });

            // 数量++
            // todo 合并数量加减操作
            $('.productCountPlus').bind({
                'touchend touchcancel mouseup': function (event) {
                    event.preventDefault();
                    var node = $(this).parent().find('.productCountNumi');
                    var pds = fnGetPdIdsByNode(this);
                    if (pds) {
                        if (o.isProm) {
                            if (parseInt(node.val()) < o.promLimit) {
                                node.val(parseInt(node.val()) + 1);
                                o.promCount = node.val();
                            }
                        } else {
                            node.val(parseInt(node.val()) + 1);
                            Cart.set(pds[0], pds[1], +node.val(), fnUpdateCartList);
                        }
                    } else {
                        // 设置购物车错误 无法取得数据
                    }
                    node = null;
                    o.countAmount();
                    envsCheck();
                }
            });
        }

        /**
         * 购物车操作,通过父节点获取product_id和spid
         */
        function fnGetPdIdsByNode(node) {
            var parent = $(node).parent();
            if (parent) {
                return [+parent.data('pid'), +parent.data('spid')];
            } else {
                return false;
            }
        }

        /**
         * 红包检查
		 if ($('.envsItem i').hasClass('checked') && !o.envsAva){
		 			$('.envsItem i').removeClass('checked');
		            setEnvs(false, 0, 0);
					o.countAmount();//修复红包使用选取额度不足取消选取
		 }
         * @returns {undefined}
         */
        function envsCheck() {
            $('.envsItem').each(function () {
                var envs = $(this);
                envs.addClass('hidden');
                o.envsAva = false;

				$('.pd-envstr').each(function () {
					if (envs.attr('data-pid').indexOf($(this).attr('data-pid')) !== -1 || envs.attr('data-pid') === '') {
						var tprice = $(this).parent().find('.dprice').attr('data-price') * $(this).parent().find('.productCountNumi').val();
						
						if (envs.attr('data-req') <= tprice) {
							envs.removeClass('hidden');
							o.envsAva = true;
						}
					}
				});
				//如果是全品类红包且订单金额满足要求
				if (envs.attr('data-pid') == '' && (o.ActalFee >= envs.attr('data-req'))){
					envs.removeClass('hidden');
					o.envsAva = true;
				}
            });
			
			if (o.envsAva == false){
				$('.envsItem i').removeClass('checked');
				setEnvs(false, 0, 0);
			}
			o.countAmount();
        }

        /**
         * toggle class
         */
        $('.envsItem i').bind({
            'touchend touchcancel mouseup': function (event) {
                event.preventDefault();
                if ($(this).hasClass('checked')) {
                    $('.envsItem i').removeClass('checked');
                    setEnvs(false, 0, 0);
                } else {
                    $('.envsItem i').removeClass('checked');
                    $(this).toggleClass('checked');
                    // 红包计入
                    var req = $(this).parent().attr('data-req');
                    var dis = $(this).parent().attr('data-dis');
                    var Id = $(this).parent().attr('data-id');
                    setEnvs(Id, req, dis);
                }
                o.countAmount();
            }
        });

        $('.reciItem i').bind({
            'touchend touchcancel mouseup': function (event) {
                event.preventDefault();
                $(this).toggleClass('checked');
                if ($(this).hasClass('checked')) {
                    o.isReci = true;
                    $('#reciWrap').show();
                } else {
                    o.isReci = false;
                    $('#reciWrap').hide();
                }
                o.countAmount();
            }
        });

        /**
         * 设置红包选项
         * @param {type} Id
         * @param {type} Req
         * @param {type} Dis
         * @returns {undefined}
         */
        function setEnvs(Id, Req, Dis) {
            o.envsId = Id;
            o.envsReq = Req || 0;
            o.envsDis = parseFloat(Dis) || 0;
        }

        /**
         * 删除订单商品
         * @param {type} productId
         * @param {type} spid
         * @returns {undefined}
         */
        function delFromCart(productId, spid) {
            Cart.del(productId, spid);
            $('#cartsec' + productId).remove();
            if (countOrderAmount() === 0) {
                fnEmptyCartTip();
                o.countAmount(0);
            } else {
                o.countAmount();
            }
        }

        /**
         * localStorage 地址缓存
         * @returns {undefined}
         */
        function localStorageAddrCache() {
            if (o.Storage && o.Storage.getItem('addr-set') === "1" && o.Storage.getItem('orderAddress')) {
                expressData = JSON.parse(o.Storage.getItem('orderAddress'));
                if (typeof expressData.provinceName != 'undefined') {
                    // 收货地址加载标记
                    window.addressloaded = true;
                    // 显示收货地址
                    addressShow();
                } else {
                    expressData = {};
                }
            }
        }

        /**
         * 原始数据测试
         * @returns {undefined}
         */
        function loadTestAddrData() {
            var res = {
                provinceName: '广东',
                cityName: '广州市',
                countryName: '天河区',
                detailInfo: '新燕花园三期1201',
                postalCode: 510006,
                telNumber: 18565518404,
                userName: '陈永才'
            };
            res.Address = res.provinceName + res.cityName + res.countryName + res.detailInfo;
            res.errMsg = 'openAddress:ok';
            addAddressCallback(res);
        }

        window.loadTestAddrData = loadTestAddrData;

        /**
         * 获取收货地址回调函数
         * @param {type} res
         * @returns {undefined}
         */
        function addAddressCallback(res) {
            if (res.errMsg === 'openAddress:ok') {
                window.expressData = res;
                expressData.Address = expressData.provinceName + expressData.cityName + expressData.countryName + expressData.detailInfo;
                res.Address = expressData.Address;
                
                // 缓存到Storage
                o.Storage.setItem('addr-set', '1');
                o.Storage.setItem('orderAddress', JSON.stringify(res));
                // 收货地址加载标记
                window.addressloaded = true;
                addressShow();
                // 地址变动 重新计算订单总额
                o.countAmount();
            } else {
                $('#wrp-btn').html('授权失败');
            }
        }

        /**
         * 显示收货地址数据
         */
        function addressShow() {
            $('#wrp-btn').remove();
            $('#express-name').html(expressData.userName);
            $('#express-person-phone').html(expressData.telNumber);
            $('#express-address').html(expressData.Address);
        }

        // 传出全局
        window.addAddressCallback = addAddressCallback;

        /**
         * 计算订单总额
         * @param {Boolean} balan_pay
         * @returns {Number}
         */
        function countOrderAmount(balance_pay) {

            // 余额支付
            balance_pay = balance_pay | false;

            /**
             * @param float ret 订单总金额
             * @param float tweight 订单商品总重量
             * @type Number|Number
             */
            var ret = 0, tweight = 0;

            // var city = expressData.addressCitySecondStageName;
            var prov = expressData.proviceFirstStageName;

            /**
             * 购物车中是否有0重量的商品
             * @type {boolean}
             */
            var isEmpExp = false;

            // 固定运费
            var expFixed = 0;

            if ($('.cartListDesc').length > 0) {
                $('.cartListDesc').each(function (lis, node) {
                    // 单价
                    var dprice = parseFloat($('.dprice', node).attr('data-price'));
                    // 数量
                    var dcount = parseInt($('.dcount', node).val());
                    // 固定运费
                    var expFix = parseInt($('.dprice', node).attr('data-expfee'));
                    // 重量
                    var weight = parseInt($('.dprice', node).attr('data-weight'));
                    // 计算商品总价 不包括运费
                    ret += (dprice * dcount);
                    if (expFix > 0) {
                        // 固定运费
                        expFixed += expFix;
                        return;
                    }
                    if (weight === 0) {
                        isEmpExp = true;
                    }
                    tweight += (weight * dcount);
                });
            } else {
                return 0;
            }

            // 购物车中有0重量的商品 整个订单包邮
            if (isEmpExp) {
                tweight = 0;
            }

            // 订单实际额 不包括运费、优惠
            o.ActalFee = ret;

            // 红包抵扣
            if (o.envsId !== false) {
                ret -= o.envsDis;
                if (ret < 0) {
                    ret = 0;
                }
                // 红包抵扣提示
                $('#envs_amount').html('-&yen;' + o.envsDis.toFixed(2));
                $('#envsDisTip').show();
            } else {
                $('#envsDisTip').hide();
            }

            // 总运费
            o.ExpFee = countExpFee(tweight, prov) + expFixed;

            o.ExpFee.toFixed(2);

            // 运费
            $('#order_expfee').html('&yen;' + o.ExpFee.toFixed(2));
            // 总价
            $('#order_amount_sig').html('&yen;' + ret.toFixed(2));

            // 计算发票税
            if (o.isReci) {
                if (o.TexIncludeExp) {
                    o.Tex = (ret + o.ExpFee) * o.ReciTex;
                } else {
                    o.Tex = (ret) * o.ReciTex;
                }
                $('#reciTip_amount').html('&yen;' + o.Tex.toFixed(2));
                $('#reciTip').show();
            } else {
                o.Tex = 0;
                $('#reciTip').hide();
            }

            // 订单总额
            o.TotalFee = ret + o.ExpFee + o.Tex;

            // 余额抵扣
            if (balance_pay) {
                var balance = parseFloat($('#cart-balance-pay').val());
                if (balance > o.TotalFee) {
                    $('#balanceTip_amount').html('&yen;-' + o.TotalFee);
                    o.TotalFee = 0;
                } else {
                    o.TotalFee -= balance;
                    $('#balanceTip_amount').html('&yen;-' + balance);
                }
                // 显示抵扣金额
                $('#balanceTip').show();
            } else {
                // 隐藏抵扣余额
                $('#balanceTip').hide();
            }

            $('#orderSummay, #optinfo, #wechat-payment-btn, #wechat-reqpay-btn').removeClass('hidden').show();

            return (o.TotalFee).toFixed(2);
        }

        /**
         * 计算运费
         * @param {type} tweight
         * @param {type} prov
         * @returns {undefined}
         */
        function countExpFee(tweight, prov) {

            if (tweight === 0) {
                return 0;
            }

            if (prov !== undefined) {
                prov = prov.replace('省', '');
                prov = prov.replace('市', '');
            } else {
                return 0;
            }

            var expTmp = expTmpCheck(prov, o.ExpFeeTemplate);

            if (expTmp === false || expTmp.ffee === undefined) {
                return 0;
            }

            o.ExpFeeInitial = parseFloat(expTmp.ffee);
            // 首重
            if (tweight <= o.settings.exp_weight1) {
                o.ExpFee = o.ExpFeeInitial;
            } else {
                // 续重
                tweight -= o.settings.exp_weight2;
                o.ExpFee = Math.ceil(tweight / 1000);
                o.ExpFee *= parseFloat(expTmp.ffeeadd);
                o.ExpFee += o.ExpFeeInitial;
            }

            return o.ExpFee;
        }

        /**
         * 运费字符串匹配
         * @param {type} prov
         * @param {type} ExpFeeTemplate
         */
        function expTmpCheck(prov, ExpFeeTemplate) {
            for (var p in ExpFeeTemplate) {
                var found = false;
                var ExpFs = ExpFeeTemplate[p].province.split('|');
                for (var k in ExpFs) {
                    if (ExpFs[k].indexOf(prov) !== -1 || prov.indexOf(ExpFs[k]) !== -1) {
                        found = true;
                        break;
                    }
                }
                if (found) {
                    return ExpFeeTemplate[p];
                }
            }
            return false;
        }

        // 购物车为空 提示
        function fnEmptyCartTip() {
            $('#order_expfee').html('&yen;0');
            $('#order_amount_sig').html('&yen;0');
             $('#order_amount').html('&yen;0');//$('#order_amount_sig').html('&yen;0');
            $('#orderDetailsWrapper').html('<div id="cartnothing" onclick="location=\'' + shoproot + '\'">购物车空空如也，去逛逛吧</div>');
            $('#orderSummay').hide();
            $('#optinfo').hide();
            $('#wechat-payment-btn').hide();
            $('#wechat-reqpay-btn').hide();
            $('.orderopt').hide();
            $('#extra-field').hide();
        }


		 /**
         * 修复获取收货地址
         * @returns {undefined}
         */
		function fnSelectAddr() {
			if ($('#addrOn').val() === '1') {
				wx.openAddress({
					success: function (res) {
						// 用户成功拉出地址 
						addAddressCallback(res);
					},
				});
			} else {
				// 授权失败
			}
		}

        /**
         * 发起微信支付
         * @returns {undefined}
         */
        function wepayCall() {

            if (o.envsAva && !o.envsAsked && !o.envsId) {
                confirm('您有红包可用哦，使用红包可享受优惠');
                o.envsAsked = true;
                return false;
            }

            if (o.Tex > 0 && $('#reci_head').val() === '') {
                alert('请填写发票抬头');
                return false;
            }

            // 判断收货地址是否已经获取
            if (!addressloaded) {
                fnSelectAddr();
                return false;
            }

            if (o.isProm) {
                o.cartData = '{"' + o.promId + '":' + o.promCount + '}';
            } else {
                o.cartData = o.Storage.getItem('cart');
            }

            if ($('#payOn').val() === '1') {
                // 微信支付开通
                if (false === window.addressloaded && typeof wx !== "undefined") {
                    wx.openAddress({
                        success: function (res) {
                            // 用户成功拉出地址 
                            addAddressCallback(res);
                        },
                    });
                    return false;
                }

                if (o.cartCount === 0 || o.cartList.length === 0) {
                    return false;
                }

                // 哈希订单内容，避免重复
                if (o.Storage.getItem('carthash') && CryptoJS.MD5(o.cartData + o.envsId).toString() === o.Storage.getItem('carthash').toString()) {
                    window.orderId = o.Storage.getItem('tmporder');
                } else {
                    o.Storage.removeItem('tmporder');
                    o.Storage.removeItem('carthash');
                    window.orderId = false;
                }

                $('#wechat-payment-btn').addClass('disable').html('支付发起中...');

                expressData.exptime = $('#exptime').val() !== '' ? $('#exptime').val() : '随时';

                var balancePay = 0;

                // 判断是否余额支付
                if ($('#cart-balance-check').get(0) && $('#cart-balance-check').get(0).checked) {
                    balancePay = 1
                }

                // 生成一个订单
                if (false === orderId) {
                    $.post($('#paycallorderurl').val(), {
                        addrData: JSON.stringify(expressData),
                        balancePay: balancePay,
                        expfee: o.ExpFee,
                        remark: $('#remark').val(),
                        exptime: $('#exptime').val(),
                        envsId: o.envsId,
                        reciHead: $('#reci_head').val(),
                        reciCont: $('.recis:checked').val(),
                        reciTex: o.Tex
                    }, function (r) {
                        if (r.ret_code === 0) {
                            orderGenhandle(r.ret_msg);
                        } else {
                            $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
                            alert('订单创建失败！' + r.ret_msg);
                        }
                    });
                } else {
                    orderGenhandle(orderId);
                }
            }

            // 订单生成回调
            function orderGenhandle(Id) {
                orderId = parseInt(Id) > 0 ? parseInt(Id) : false;
                fnSetCartHash();
                // 写入订单id缓存
                o.Storage.setItem('tmporder', orderId);
                // 如果订单总额为0.不需要支付
                if (o.TotalFee === 0 && o.ActalFee > 0) {
                    Cart.clear();
                    payed = true;
                    location.href = shoproot + '?/Uc/home';
                    $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
                } else {
                    if (orderId > 0 && false === window.payed) {
                        // [HttpPost]
                        $.ajax({
                            url: shoproot + '?/Order/ajaxGetBizPackage/',
                            dataType: 'json',
                            cache: false,
                            type: 'POST',
                            data: {
                                orderId: orderId
                            },
                            success: function (bizPackage) {
                                if (bizPackage.package !== 'prepay_id=') {
                                    // 支付操作成功
                                    bizPackage.success = wepayCallback;
                                    // 支付操作取消
                                    bizPackage.cancel = wepayCancel;
                                    // 支付操作出错
                                    bizPackage.fail = wepayError;
                                    // 发起微信支付
                                    wx.chooseWXPay(bizPackage);
                                    // 按钮恢复
                                    $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
                                } else {
                                    wepayError();
                                }
                            },
                            error: wepayError
                        });
                    }
                }

            }
        }

        /**
         * 货到付款，提交订单
         * @returns {undefined}
         */
        function nopayCall() {

            if (o.envsAva && !o.envsAsked && !o.envsId) {
                confirm('您有红包可用哦，使用红包可享受优惠');
                o.envsAsked = true;
                return false;
            }

            if (o.Tex > 0 && $('#reci_head').val() === '') {
                alert('请填写发票抬头');
                return false;
            }

            // 判断收货地址是否已经获取
            if (!addressloaded) {
                fnSelectAddr();
                return false;
            }

            if (o.isProm) {
                o.cartData = '{"' + o.promId + '":' + o.promCount + '}';
            } else {
                o.cartData = o.Storage.getItem('cart');
            }

            if ($('#payOn').val() === '1') {
                // 微信支付开通
                if (false === window.addressloaded && typeof wx !== "undefined") {
                    wx.openAddress({
                            success: function (res) {
                                // 用户成功拉出地址 
                                addAddressCallback(res);
                            },
                    });
                    return false;
                }

                if (o.cartCount === 0 || o.cartList.length === 0) {
                    return false;
                }

                // 哈希订单内容，避免重复
                if (o.Storage.getItem('carthash') && CryptoJS.MD5(JSON.stringify(o.cartList) + o.envsId).toString() === o.Storage.getItem('carthash').toString()) {
                    window.orderId = o.Storage.getItem('tmporder');
                } else {
                    o.Storage.removeItem('tmporder');
                    o.Storage.removeItem('carthash');
                    window.orderId = false;
                }

                $('#nopay-payment-btn').addClass('disable').html('订单提交中...');

                expressData.exptime = $('#exptime').val() !== '' ? $('#exptime').val() : '随时';

                // 生成一个订单
                if (false === orderId) {
                    $.post($('#paycallorderurl').val(), {
                        addrData: expressData.Address,
                        balancePay: $('#cart-balance-check')[0].checked ? 1 : 0,
                        expfee: o.ExpFee,
                        remark: $('#remark').val(),
                        exptime: $('#exptime').val(),
                        envsId: o.envsId,
                        reciHead: $('#reci_head').val(),
                        reciCont: $('.recis:checked').val(),
                        reciTex: o.Tex
                    }, function (r) {
                        if (r.ret_code === 0) {
                            nopayOrderGenhandle(r.ret_msg);
                        } else {
                            $('#nopay-payment-btn').removeClass('disable').html('货到付款');
                            alert('订单创建失败！' + r.ret_msg);
                        }
                    });
                } else {
                    nopayOrderGenhandle(orderId);
                }
            }

            // 订单生成回调
            function nopayOrderGenhandle(Id) {
                orderId = parseInt(Id) > 0 ? parseInt(Id) : false;
                fnSetCartHash();
                // 写入订单id缓存
                o.Storage.setItem('tmporder', orderId);
                // 货到付款订单.不需要支付
                Cart.clear();
                payed = true;
                location.href = shoproot + '?/Uc/home';
                $('#nopay-payment-btn').removeClass('disable').html('货到付款');
            }
        }

        function fnSetCartHash() {
            // 写入订单id缓存Key
            o.Storage.setItem('carthash', CryptoJS.MD5(JSON.stringify(o.cartList) + o.envsId));
        }

        /**
         * 微信支付手动取消
         */
        function wepayCancel() {
            // 按钮恢复
            $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
        }

        /**
         * 微信支付失败
         */
        function wepayError() {
            alert('微信支付发起失败');
            // 按钮恢复
            $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
        }

        /**
         * 微信支付回调
         * @param {type} res
         * @returns {undefined}
         */
        function wepayCallback(res) {
            Cart.clear();
            payed = true;
            location.href = shoproot + '?/Order/order_success/orderid=' + orderId;
            $('#wechat-payment-btn').removeClass('disable').html('微信安全支付');
        }

        /**
         * 选择收货地址
         */
        $('#express_address').click(fnSelectAddr);

        /**
         * 发起微信支付
         */
        $('#wechat-payment-btn').click(wepayCall);

        /**
         * 货到付款
         */
        $('#nopay-payment-btn').click(nopayCall);

        /**
         * 加载收货地址缓存数据
         */
        localStorageAddrCache();

        /**
         * window resize
         */
        util.onresize(
            function () {
                // 输入框调整
                $('#remark').width($(window).width() - 100);
            }
        );

        /**
         * 配送时间选择器
         */
        function fnLoadExptimeSelector() {

            if (o.settings && o.settings['dispatch_day_zone'] && o.settings['dispatch_day'] && o.settings['dispatch_day'] != '' && o.settings['dispatch_day'] >= 0) {

                var wheelLeft = [];

                // 循环生成左侧日期
                for (var i = 0; i <= o.settings['dispatch_day']; i++) {
                    wheelLeft.push(util.getDateStr(i));
                }

                $('#input-exptime').mobiscroll().scroller({
                    theme: 'ios',
                    lang: 'zh',
                    display: 'bottom',
                    mode: 'scroller',
                    height: 35,
                    wheels: [[
                        {
                            values: wheelLeft
                        },
                        {
                            values: o.settings['dispatch_day_zone'].split(',')
                        }
                    ]],
                    onSelect: function (text) {
                        $('#exptime').val(text);
                        $('#input-exptime-label').html(text);
                    }
                });

            }

        }

    });

});

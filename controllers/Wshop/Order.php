<?php

/**
 * 订单控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Order extends ControllerShop {

    /**
     * 构造函数
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
    }

    /**
     * 购物车
     */
    public function cart() {
        global $config;
        $this->loadModel('User');
        $this->loadModel('Envs');
        $this->loadModel('WechatSdk');
        $this->loadModel('JsSdk');
        $this->caching = false;
        //获取用户红包列表
        $envs = $this->Envs->getUserEnvs($this->getUid());
        $this->initSettings(true);
        if (Controller::inWechat()) {
            // 请求收货地址参数数据
            include_once(APP_PATH . "lib/wepaySdk/SignTool.php");
            $OauthURL        = $this->root . $config->wxpayroot . '?id=' . $_GET['id'];
            $FinalURL        = Util::getURI();
            $addrsignPackage = WechatSdk::getAddrShareSign($OauthURL, $FinalURL);
            $this->assign('addrsignPackage', $this->toJson($addrsignPackage));
        } else {
            $this->assign('addrsignPackage', '{}');
        }
        $signPackage = $this->JsSdk->GetSignPackage();
        $this->assign('recis', explode(',', $this->settings['reci_cont']));
        $this->assign('envs', $envs);
        $this->assign('signPackage', $signPackage);
        $this->assign('title', '购物车');
        $this->assign('promId', $_GET['id']);
        $this->assign('promAva', 0);
        $this->assign('userInfo', (array)$this->User->getUserInfo($this->getUID()));
        $this->show("wshop/order/cart.tpl");
    }

    /**
     * Ajax生成订单
     */
    public function ajaxCreateOrder() {
        $this->loadModel(['mOrder', 'User']);
        $openid   = $this->getOpenId();
        $cartData = $this->User->getCartDataSimple($openid);
        $addrData = $this->pPost('addrData');
        if (empty($openid)) {
            return $this->echoMsg(-1, 'OPENID 不能为空');
        }
        if (!$cartData || sizeof($cartData) == 0) {
            return $this->echoMsg(-1, '订单数据非法');
        }
        if (empty($addrData)) {
            return $this->echoMsg(-1, '地址数据非法');
        }
        try {
            $orderId = $this->mOrder->create($openid, $cartData, $addrData, [
                'remark' => addslashes($this->post('remark')),
                'exptime' => addslashes($this->post('exptime')),
                'balancePay' => addslashes($this->post('balancePay')) == 1,
                'expfee' => floatval($this->post('expfee')),
                'envsid' => intval($this->post('envsId')),
            ]);
            $this->echoMsg(0, intval($orderId));
        } catch (Exception $ex) {
            $this->log('order_create_error:' . $ex->getMessage());
            $this->echoMsg(-1, $ex->getMessage());
        }
    }

    /**
     * Ajax获取订单请求数据包
     * @param int $orderId
     */
    public function ajaxGetBizPackage() {
        global $config;
        $this->loadModel(['mOrder']);
        $orderId = $this->post('orderId');
        if (!empty($orderId)) {

            $openid = $this->getOpenId();
            // 随机字符串
            $nonceStr = $this->Util->createNoncestr();
            // 时间戳
            $timeStamp = strval(time());

            if (stristr($orderId, 'D_')) {
                // 充值订单
                $productName = '余额充值';
                // 流水号
                $serial_number = $orderId;
                // 获取订单信息
                $deposit = $this->Dao->select()->from(TABLE_DEPOSIT_ORDER)->where("deposit_serial = '$orderId'")->getOneRow();
                if (!$deposit) {
                    $this->echoJson([]);
                }
                $totalFee = floatval($deposit['amount']) * 100;
            } else {
                // 订单数据
                $ordrInfo = $this->mOrder->getOrderInfo($orderId, false);
                // 订单总额 = (金额 - 余额支付金额)
                $totalFee = (floatval($ordrInfo['order_amount']) - floatval($ordrInfo['order_balance'])) * 100;
                // 支付结果显示文字
                $products = $this->mOrder->getOrderProducts($orderId);
                if (sizeof($products) > 1) {
                    $productName = $products[0]['product_name'] . ' (多种商品)';
                } else {
                    $productName = $products[0]['product_name'];
                }
                // 流水号
                $serial_number = $ordrInfo['serial_number'];
            }

            $pack = array(
                'appid' => APPID,
                'body' => $productName,
                'mch_id' => PARTNER,
                'nonce_str' => $nonceStr,
                'notify_url' => $config->order_wxpay_notify,
                'spbill_create_ip' => Util::getIps(),
                'openid' => $openid,
                'out_trade_no' => $serial_number,
                'timeStamp' => $timeStamp,
                'total_fee' => $totalFee,
                'trade_type' => 'JSAPI'
            );

            $pack['sign'] = $this->Util->paySign($pack);

            $xml = $this->Util->toXML($pack);

            $ret = Curl::post('https://api.mch.weixin.qq.com/pay/unifiedorder', $xml);

            $postObj = json_decode(json_encode(simplexml_load_string($ret, 'SimpleXMLElement', LIBXML_NOCDATA)));

            if (empty($postObj->prepay_id) || $postObj->return_code == "FAIL") {

                // 支付发起错误 记录到logs
                $this->log('生成签名失败:' . $postObj->return_msg . ' ' . $xml);
                $this->log('请求参数:' . $xml);
                $this->log('返回结果:' . $ret);

                $this->echoJson(['package' => '']);

            } else {

                $packJs = array(
                    'appId' => APPID,
                    'timeStamp' => $timeStamp,
                    'nonceStr' => $nonceStr,
                    'package' => "prepay_id=" . $postObj->prepay_id,
                    'signType' => 'MD5'
                );

                $JsSign = $this->Util->paySign($packJs);

                unset($packJs['timeStamp']);

                $packJs['timestamp'] = $timeStamp;

                $packJs['paySign'] = $JsSign;

                $this->echoJson($packJs);

            }
        } else {
            $this->echoJson([]);
        }
    }

    /**
     * 订单详情
     * @param type $Query
     */
    public function expressDetail($Query) {
        header('Location: ?/Uc/expressDetail/order_id=' . $Query->order_id);
    }

    /**
     * 订单取消
     */
    public function cancelOrder() {
        $orderId = $_POST['orderId'];
        if (is_numeric($orderId)) {
            $orderId = intval($orderId);
            $ret     = $this->Dao->update(TABLE_ORDERS)->set([
                'status' => 'canceled'
            ])->where([
                'order_id' => $orderId
            ])->exec();
            echo $ret > 0 ? "1" : "0";
        } else {
            echo 0;
        }
    }

    /**
     * 订单确认收货确认收货
     * @return boolean
     */
    public function confirmExpress() {

        // 检查权限
        if (Controller::inWechat()) {
            $openid = $this->getOpenId();
            if (empty($openid)) {
                echo 0;
                return false;
            }
        } else {
            if (!$this->Auth->checkAuth()) {
                return false;
            } else {
                $openid = null;
            }
        }

        if (!$this->pPost('orderId')) {
            echo 0;
            return false;
        }

        $this->loadModel([
            'mOrder',
            'WechatSdk',
            'Express',
            'User'
        ]);

        $orderId = intval($this->pPost('orderId'));

        $orderInfo = $this->mOrder->getOrderInfo($orderId, false);

        if ($orderId > 0 && $orderInfo && $orderInfo['status'] != 'received') {

            $isExpressStaff = false;

            if (Controller::inWechat()) {
                if ($openid == $orderInfo['express_openid']) {
                    // 配送人员确认
                    $isExpressStaff = true;
                } else {
                    // 买家确认
                    if ($openid != $orderInfo['wepay_openid']) {
                        echo 0;
                        return false;
                    }
                }
            } else {
                // 后台操作
            }

            $this->Db->transtart();

            try {
                // 更新订单状态
                if ($this->mOrder->updateOrderInfo([
                    'status' => 'received',
                    'receive_time' => 'NOW()'
                ], $orderId)
                ) {
                    // 配送操作记录
                    if ($isExpressStaff) {
                        $this->Express->setExpressRecord($orderId, $openid, $orderInfo['send_time']);
                    }
                    // 订单赠送积分
                    $credit_order_amount = $this->getSetting('credit_order_amount');
                    if ($credit_order_amount > 0) {
                        $this->User->addCredit($orderInfo['client_id'], $orderInfo['order_amount'] * $credit_order_amount, 0, 0);
                    }
                    $this->Db->transcommit();
                    echo 1;
                }
            } catch (Exception $ex) {
                $this->Db->transrollback();
                $this->log('订单确认收货失败:' . $ex->getMessage());
                echo 0;
            }
        } else {
            echo 0;
        }
    }

    /**
     * @HttpPost only-方法1：http://api.ickd.cn/
     * 获取快递跟踪情况
     * @return <html>
     */
	 /*
    public function ajaxGetExpressDetails() {
        $typeCom = $_POST["com"]; //快递公司
        $typeNu  = $_POST["nu"];  //快递单号
        $url     = "http://api.ickd.cn/?id=105049&secret=c246f9fa42e4b2c1783ef50699aa2c4d&com=$typeCom&nu=$typeNu&type=html&encode=utf8";
        //优先使用curl模式发送数据
        $res = Curl::get($url);
        echo $res;
    }
	*/
	
	
	 /**
     * @HttpPost only-方法2：http://www.kuaidiapi.cn/
     * 获取快递跟踪情况
     * @return <html>
     */
	
	 public function ajaxGetExpressDetails() {
        $this->Smarty->caching = false;
  		$code    = $_POST["nu"];
		$com     = $_POST["com"];
        $url = "http://www.kuaidiapi.cn/rest/?uid=23350&key=7614261fa71a4948ad73795e88d958af&order=$code&id=$com";
        $this->Smarty->assign('res', json_decode(Curl::get($url), true));
        $this->show('./views/wdminpage/orders/express.tpl');
    }

    /**
     * ajax 订单退款处理
     */
    public function orderRefund() {
        $this->loadModel('mOrder');
        $orderId = intval($this->pPost('id'));
        // 退款金额
        $amount = floatval($this->pPost('amount'));
        // 退款结果
        $ret = $this->mOrder->orderRefund($orderId, $amount);
        // 可退款金额
        $rAmount = $this->mOrder->getUnRefunded($orderId);
        // 已退款金额
        $rAmounted = $this->mOrder->getRefunded($orderId);
        if ($ret !== false) {
            if (isset($ret->return_code) && (string)$ret->return_code === 'SUCCESS') {
                // 申请已提交 进一步处理订单
                if ($rAmount == $amount || $rAmount < 0.01) {
                    // 已经全部退款
                    $this->mOrder->updateOrderStatus($orderId, 'refunded', $rAmounted + $rAmount);
                } else {
                    // 部分退款
                    $this->mOrder->updateOrderStatus($orderId, 'canceled', $rAmounted + $amount);
                }
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
    }

    /**
     * 下单成功页面
     * 提示分享，返回首页，返回个人中心选项
     */
    public function order_success($Query) {
        $orderAddress = $this->Db->getOneRow("SELECT * FROM `orders_address` WHERE `order_id` = $Query->orderid;");
        $this->assign('orderAddress', $orderAddress);
        $this->assign('title', '下单成功');
        $this->show("./views/wshop/order/order_success.tpl");
    }

    /**
     * 订单评价
     * @param type $Query
     */
    public function commentOrder($Query) {
        $orderId = intval($Query->order_id);
        $openId  = $this->getOpenId();
        if ($orderId > 0 && !empty($openId)) {
            $this->Load->model('mOrder');
            if ($this->mOrder->checkOrderBelong($openId, $orderId)) {
                $orderData = $this->mOrder->GetOrderDetail($orderId);
                $this->assign('order', $orderData);
                $this->assign('title', '订单评价');
                $this->show("./views/wshop/order/commentorder.tpl");
            }
        }
    }

    /**
     * 订单评价
     */
    public function addComment() {
        $content = $this->pPost('commentText');
        $stars   = intval($this->pPost('stars'));
        $orderId = intval($this->pPost('orderId'));
        $openId  = $this->getOpenId();
        if ($orderId > 0 && !empty($openId)) {
            $this->loadModel('mOrder');
            if ($this->mOrder->checkOrderBelong($openId, $orderId)) {
                // 检查订单归属
                if ($this->mOrder->addComment($openId, $orderId, $content, $stars)) {
                    $this->echoMsg(0);
                } else {
                    $this->echoMsg(-1);
                }
            } else {
                $this->echoMsg(-1);
            }
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * 获取店铺设置
     */
    public function ajaxGetSettings() {
        $jsonA = array();
        // 获取快递首重，续重参数
        $datas = $this->Dao->select()
            ->from('wshop_settings')
            ->where("`key` IN ('exp_weight1', 'exp_weight2', 'dispatch_day_zone', 'dispatch_day')")
            ->exec();
        foreach ($datas as $da) {
            $jsonA[$da['key']] = $da['value'];
        }
        $this->echoJson($jsonA);
    }

    /**
     * 获取运费模板
     */
    public function ajaxGetExpTemplate() {
        $arr = $this->Dao->select()
            ->from('wshop_settings_expfee')
            ->exec();
        $this->echoJson($arr);
    }

}

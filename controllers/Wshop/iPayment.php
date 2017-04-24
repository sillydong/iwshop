<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 支付处理控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class iPayment extends ControllerShop {

    private $sourceStr;

    // 支付回调页面
    public function payment_notify() {
        //解决$GLOBAL限制导致无法获取xml数据
        $this->sourceStr = file_get_contents('php://input');
        // 读取数据
        $postObj = simplexml_load_string($this->sourceStr, 'SimpleXMLElement', LIBXML_NOCDATA);
        // 数据参考 systemtest/payment_notify.xml
        $this->log($this->sourceStr);
        if (!$postObj) {
            $this->log("支付回调处理失败，数据包解析失败");
        } else {

            // 对数据包进行签名验证
            $postArr = (array)$postObj;
            $sign    = $this->Util->paySign($postArr);

            if ($sign == $postObj->sign) {
                // order serial number
                $serial = $postObj->out_trade_no;
                // 是否充值订单
                if (stristr($serial, 'D_')) {
                    $this->deposit_callback($postObj);
                } else {
                    $this->order_callback($postObj);
                }
            }

        }
    }

    /**
     * 充值订单回调
     * @param $postObj
     */
    private function deposit_callback($postObj) {

        $serial = $postObj->out_trade_no;

        // 充值用户余额
        $this->loadModel([
            'mOrder',
            'User'
        ]);

        // 查找充值单
        $deposit = $this->Dao->select()
            ->from(TABLE_DEPOSIT_ORDER)
            ->where("deposit_serial = '$serial' AND deposit_status = 'wait'")
            ->getOneRow();

        if ($deposit) {

            // 充值金额
            $deposit['amount'] = floatval($deposit['amount']);

            // 用户UID
            $uid = $this->User->getUidByOpenId($postObj->openid);

            $this->Db->transtart();

            try {
                // 更新订单状态
                if ($this->Dao->update(TABLE_DEPOSIT_ORDER)->set(['deposit_status' => 'payed'])
                    ->where("deposit_serial = '$serial'")->exec()
                ) {
                    // 增加用户余额
                    $this->User->mantUserBalance($deposit['amount'], $uid);
                    $this->Db->transcommit();
                    // 执行钩子程序
                    (new HookDeposit($this))->deal([
                        'deposit_serial' => strval($serial),
                        'openid' => strval($postObj->openid),
                        'amount' => $deposit['amount']
                    ]);
                    // 返回success
                    echo "<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>";
                } else {
                    $this->Db->transrollback();
                    Util::log("充值订单处理失败, 更新订单状态失败!" . $this->sourceStr);
                }
            } catch (PDOException $ex) {
                $this->Db->transrollback();
                Util::log($ex->getMessage());
            }

        }
    }

    /**
     * 常规支付回调
     * @param $postObj
     */
    public function order_callback($postObj) {
        $serial = $postObj->out_trade_no;
        // 微信交易单号
        $transaction_id = $postObj->transaction_id;
        if (!empty($transaction_id)) {
            try {
                $this->loadModel([
                    'mOrder',
                    'User'
                ]);
                // 获取订单信息
                $orderInfo = $this->mOrder->getOrderInfoBySerialNumber($serial, false);
                $orderId   = intval($orderInfo['order_id']);
                if ($orderInfo && $orderInfo['status'] != 'payed' && empty($orderInfo['wepay_serial'])) {
                    // 更新订单信息
                    // 修改为已支付
                    if ($this->mOrder->updateOrder([
                        'wepay_serial' => $transaction_id,
                        'wepay_openid' => $postObj->openid,
                        'status' => OrderStatus::payed,
                        'wepayed' => 1
                    ], [
                        'serial_number' => $serial
                    ])
                    ) {
                        // 执行钩子程序
                        (new HookNewOrder($this))->deal([
                            'serial_number' => $serial,
                            'openid' => strval($postObj->openid),
                        ]);
                        // 商户订单通知
                        @$this->mOrder->comNewOrderNotify($orderId);
                        // 用户订单通知 模板消息
                        @$this->mOrder->userNewOrderNotify($orderId, $postObj->openid);
                        // 积分结算
                        @$this->mOrder->creditFinalEstimate($orderId);
                        // 减库存
                        @$this->mOrder->cutInstock($orderId);
                        // 返回success
                        echo "<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>";
                    } else {
                        $this->log("支付回调处理失败:" . $this->sourceStr);
                    }
                }
            } catch (Exception $ex) {
                $this->log($ex->getMessage());
            }
        }
    }

    /**
     * <xml>
     * <appid><![CDATA[wx254718bf59cf40b3]]></appid>
     * <bank_type><![CDATA[ABC_DEBIT]]></bank_type>
     * <cash_fee><![CDATA[5000]]></cash_fee>
     * <device_info><![CDATA[WEB]]></device_info>
     * <fee_type><![CDATA[CNY]]></fee_type>
     * <is_subscribe><![CDATA[N]]></is_subscribe>
     * <mch_id><![CDATA[1330272001]]></mch_id>
     * <nonce_str><![CDATA[CRITKWG4NALQUXU0]]></nonce_str>
     * <openid><![CDATA[oNlqfwiK77LZuopKFkBdRWsSp2jg]]></openid>
     * <out_trade_no><![CDATA[20160602095537170]]></out_trade_no>
     * <result_code><![CDATA[SUCCESS]]></result_code>
     * <return_code><![CDATA[SUCCESS]]></return_code>
     * <sign><![CDATA[594446F592C827AC55BCC378B9B71B7E]]></sign>
     * <time_end><![CDATA[20160602095549]]></time_end>
     * <total_fee>5000</total_fee>
     * <trade_type><![CDATA[NATIVE]]></trade_type>
     * <transaction_id><![CDATA[4007352001201606026643619519]]></transaction_id>
     * </xml>
     */

}
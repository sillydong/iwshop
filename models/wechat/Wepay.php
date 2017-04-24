<?php

/**
 * 微信支付类
 */
class Wepay {

    /**
     * 生成微信支付签名包
     * @param $openid
     * @param $serial
     * @param $productName
     * @param $notifyUrl
     * @param $totalFee
     * @return array|bool
     */
    public function createSignPackage($openid, $serial, $productName, $notifyUrl, $totalFee) {

        $nonceStr  = $this->createNoncestr();
        $timeStamp = strval(time());

        $pack = array(
            'appid' => APPID,
            'body' => $productName,
            'mch_id' => PARTNER,
            'nonce_str' => $nonceStr,
            'notify_url' => $notifyUrl,
            'spbill_create_ip' => Util::getIps(),
            'openid' => $openid,
            // 外部订单号 update1.0 使用订单序列号作为外部订单号
            'out_trade_no' => $serial,
            'timeStamp' => $timeStamp,
            'total_fee' => $totalFee * 100,
            'trade_type' => 'JSAPI'
        );

        $pack['sign'] = $this->paySign($pack);

        $xml = $this->toXML($pack);

        $ret = Curl::post('https://api.mch.weixin.qq.com/pay/unifiedorder', $xml);

        $postObj = json_decode(json_encode(simplexml_load_string($ret, 'SimpleXMLElement', LIBXML_NOCDATA)));

        if (empty($postObj->prepay_id) || $postObj->return_code == "FAIL") {

            // 支付发起错误 记录到logs
            Util::log('生成签名失败:' . $postObj->return_msg . ' ' . $xml);
            Util::log('请求参数:' . $xml);
            Util::log('返回结果:' . $ret);

            return false;

        } else {

            $packJs = array(
                'appId' => APPID,
                'timeStamp' => $timeStamp,
                'nonceStr' => $nonceStr,
                'package' => "prepay_id=" . $postObj->prepay_id,
                'signType' => 'MD5'
            );

            $JsSign = $this->paySign($packJs);

            unset($packJs['timeStamp']);

            $packJs['timestamp'] = $timeStamp;

            $packJs['paySign'] = $JsSign;

            return $packJs;

        }
    }

    /**
     * 生成随机字符串
     * @param int $length
     * @return string
     */
    private function createNoncestr($length = 16) {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        $str   = "";
        for ($i = 0; $i < $length; $i++) {
            $str .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
            //$str .= $chars[ mt_rand(0, strlen($chars) - 1) ];
        }
        return $str;
    }

    /**
     * 数组转换XML
     * @param array $arr
     * @return string
     */
    private function toXML($arr) {
        $xml = "<xml>";
        foreach ($arr as $key => $val) {
            if (is_numeric($val)) {
                $xml .= "<" . $key . ">" . $val . "</" . $key . ">";
            } else {
                $xml .= "<" . $key . "><![CDATA[" . $val . "]]></" . $key . ">";
            }
        }
        $xml .= "</xml>";
        return $xml;
    }

    /**
     * 生成签名
     * @param array $pack
     * @return string
     */
    public function paySign($pack) {
        ksort($pack);
        $string = $this->ToUrlParams($pack);
        $string = $string . "&key=" . PARTNERKEY;
        $string = md5($string);
        $result = strtoupper($string);
        return $result;
    }

    /**
     * 格式化参数格式化成url参数
     */
    public function ToUrlParams($arr) {
        $buff = "";
        foreach ($arr as $k => $v) {
            if ($k != "sign" && $v != "" && !is_array($v)) {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $buff = trim($buff, "&");
        return $buff;
    }

    /**
     * 发送红包接口
     * @param $openID
     * @param $amount
     */
    public function sendRedPack($openID, $amount) {

//        $postData = array(
//            "appid" => APPID,
//            "mch_id" => PARTNER,
//            "transaction_id" => $orderInfo['wepay_serial'],
//            "out_trade_no" => $config->out_trade_no_prefix . $orderId,
//            "out_refund_no" => $orderId . $refund_fee,
//            "total_fee" => $totalFee,
//            "refund_fee" => $refund_fee,
//            "op_user_id" => PARTNER,
//            "nonce_str" => $this->createNoncestr()
//        );
//
//        $sign = $this->createSign($postData);
//
//        $postData["sign"] = $sign;
//
//        $reqPar = $this->toXML($postData);
//
//        $r = Curl::postSSL($url, $reqPar, 50);
//
//        var_dump($r);

    }

}
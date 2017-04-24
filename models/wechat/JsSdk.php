<?php

class JsSdk {

    /**
     * 获取签名数据
     * @return array
     */
    public function getSignPackage($url = false) {
        $jsapiTicket = $this->getJsApiTicket();
        $url         = $url ? $url : "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
        $timestamp   = time();
        $nonceStr    = $this->createNonceStr();
        // 这里参数的顺序要按照 key 值 ASCII 码升序排序
        $string = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=$url";

        $signature = sha1($string);

        $signPackage = array(
            "appId" => APPID,
            "nonceStr" => $nonceStr,
            "timestamp" => $timestamp,
            "url" => $url,
            "signature" => $signature,
            "rawString" => $string
        );
        return $signPackage;
    }

    /**
     * 生成随机字符串
     * @param int $length
     * @return string
     */
    private function createNonceStr($length = 16) {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        $str   = "";
        for ($i = 0; $i < $length; $i++) {
            $str .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
        }
        return $str;
    }

    /**
     * 请求jsApiTicket
     * @return string
     */
    private function getJsApiTicket() {
        $file = APP_PATH . "tmp/jsapi_ticket.cache.php";
        if (!is_file($file)) {
            file_put_contents($file, '{"jsapi_ticket":"","expire_time":0}');
            $data               = new stdClass();
            $data->expire_time  = 0;
            $data->jsapi_ticket = '';
        } else {
            // jsapi_ticket 应该全局存储与更新，以下代码以写入到文件中做示例
            $data = json_decode(file_get_contents($file));
        }
        if ($data->expire_time < time() || empty($data->jsapi_ticket)) {
            $accessToken = WechatSdk::getServiceAccessToken();
            $url         = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=$accessToken&type=jsapi";
            $res         = json_decode(Curl::get($url));
            $ticket      = $res->ticket;
            if ($ticket) {
                $data->expire_time  = time() + 7000;
                $data->jsapi_ticket = $ticket;
                file_put_contents($file, json_encode($data));
            }
        } else {
            $ticket = $data->jsapi_ticket;
        }
        return $ticket;
    }

}

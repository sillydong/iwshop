<?php

/**
 * 微信消息发送
 * Class Messager
 */
class Messager {

    // send plain/text to user's wechat client
    public static function sendText($access_token, $openid, $content) {
        //{
        //    "touser":"OPENID",
        //    "msgtype":"text",
        //    "text":
        //    {
        //         "content":"Hello World"
        //    }
        //}
        $RequestUrl          = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=$access_token";
        $postData            = array();
        $postData['touser']  = (string)$openid;
        $postData['msgtype'] = 'text';
        $postData['text']    = array('content' => urlencode($content));
        $Result              = Curl::post($RequestUrl, urldecode(json_encode($postData)));
        return json_decode($Result, true);
    }

    /**
     * 发送微信模板消息
     * @param int $template_id
     * @param string $openid
     * @param array $data
     * @param string $url
     * @return array
     */
    public static function sendTemplateMessage($template_id, $openid, $data, $url = '') {
        $stoken = WechatSdk::getServiceAccessToken();
        foreach ($data as &$d) {
            $d = array(
                'value' => $d,
                'color' => '#173177'
            );
        }
        $PostData = array(
            "touser" => "$openid",
            "template_id" => "$template_id",
            "url" => "$url",
            "topcolor" => "#FF0000",
            "data" => $data
        );
        $Result   = Curl::post("https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=$stoken",
            str_replace('\/', '/', WechatSdk::decodeUnicode(json_encode($PostData))));
        $Result   = json_decode($Result, true);
        if ($Result['errmsg'] != 'ok') {
            Util::log("模板消息发送出错：" . json_encode($Result, JSON_UNESCAPED_UNICODE));
        }
        return $Result;
    }

}

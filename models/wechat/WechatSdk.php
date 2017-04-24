<?php

/**
 * 微信Sdk
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class WechatSdk {

    /**
     * 推广二维码 永久
     */
    const QR_LIMIT_SCENE = 'QR_LIMIT_SCENE';

    /**
     * 推广二维码 临时
     */
    const QR_SCENE = 'QR_SCENE';

    /**
     * 获取服务号access token
     * @return string
     */
    public static function getServiceAccessToken() {
        $mRedis = mRedis::get_instance();
        $mKey   = APPID . 'accesstoken';
        if ($mRedis) {
            $data = $mRedis->get($mKey);
            if (!$data) {
                $data = self::_getServiceAccessToken();
                if (!empty($data)) {
                    $mRedis->set($mKey, $data);
                    $mRedis->expire($mKey, 60);
                }
            }
            return $data;
        } else {
            return self::_getServiceAccessToken();
        }
    }

    /**
     * 获取accesstoken
     * @return null
     */
    public static function _getServiceAccessToken() {
        $url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" . APPID . "&secret=" . APPSECRET;
        $res = json_decode(Curl::get($url));
        if ($res && isset($res->access_token)) {
            return $res->access_token;
        } else {
            return null;
        }
    }

    /**
     * 获取推广二维码ticket
     * @param type $access_token
     * @param type $scene
     * @param type $ticketType
     * @return string
     */
    public static function getCQrcodeTicket($access_token, $scene, $ticketType = self::QR_LIMIT_SCENE) {

        // 临时的支持 0 ~ 4294967295 正整数
        // 永久仅支持 0 ~ 100000 正整数
        //POST => {"action_name": "QR_LIMIT_SCENE", "action_info": {"scene": {"scene_id": 123}}}
        //URL  => https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=TOKEN

        $RequestUrl = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=" . $access_token;

        $PostData = array(
            'action_name' => $ticketType,
            'action_info' => array('scene' => array('scene_id' => $scene))
        );

        if ($ticketType == self::QR_SCENE) {
            // 5分钟过期
            $PostData['expire_seconds'] = 300;
        }
        $PostData = json_encode($PostData);
        $Result   = Curl::post($RequestUrl, $PostData);
        $Result   = json_decode($Result, true);
        return $Result['ticket'];
    }

    //@获取推广图片
    public static function getCQrcodeImage($ticket) {
        return 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=' . urlencode($ticket);
    }

    /**
     * 获取用户授权凭证code
     * @param $redirect_uri
     * @param $scope
     * @return bool
     */
    public static function getAccessCode($redirect_uri, $scope) {
        $request_access_token_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" . APPID . "&redirect_uri=[REDIRECT_URI]&response_type=code&scope=[SCOPE]&state=STATE#wechat_redirect";
        if (empty($_GET['code'])) {
            // 未授权而且是拒绝
            if (!empty($_GET['state'])) {
                return FALSE;
            } else {
                // 未授权
                $redirect_uri = urlencode($redirect_uri);
                $RequestUrl   = str_replace("[REDIRECT_URI]", $redirect_uri, $request_access_token_url);
                $RequestUrl   = str_replace("[SCOPE]", $scope, $RequestUrl);
                // 获取授权
                header("location:" . $RequestUrl);
                exit(0);
            }
        } else {
            // 授权成功 返回 access_token 票据
            return $_GET['code'];
        }
    }

    /**
     * 获取微信用户信息
     * @param string $access_token
     * @param string $openid
     * @param boolean $union
     * @return mixed array
     */
    public static function getUserInfo($access_token, $openid, $union = false) {
        // 获取用户信息 scope 必须为 snsapi_userinfo
        //{
        //   "openid":" OPENID",
        //   " nickname": NICKNAME,
        //   "sex":"1",
        //   "province":"PROVINCE"
        //   "city":"CITY",
        //   "country":"COUNTRY",
        //    "headimgurl":    "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/46", 
        //   "privilege":[
        //    "PRIVILEGE1"
        //    "PRIVILEGE2"
        //    ]
        //}
        if ($openid != '') {
            // unionid 获取用户信息
            $url = $union ? "https://api.weixin.qq.com/cgi-bin/user/info?access_token=$access_token&openid=$openid&lang=zh_CN" : "https://api.weixin.qq.com/sns/userinfo?access_token=$access_token&openid=$openid&lang=zh_CN";
            // 缓存判断请求方式
            $cacheFile = dirname(__FILE__) . "/../tmp/wechat_userinfo/userinfo_$openid" . hash('md4', $url) . ".json";
            // 缓存文件判断
            if (is_file($cacheFile) && is_readable($cacheFile)) {
                $data = json_decode(file_get_contents($cacheFile));
            } else {
                $data = new stdClass();
            }
            if (!$data || $data->expire_time < time()) {
                // 过期或者文件不存在
                $userInfo = json_decode(Curl::get($url));
                if ($userInfo->nickname) {
                    // 缓存时间7000秒
                    $data->expire_time = time() + 7000;
                    $data->userinfo    = $userInfo;
                    $fp                = fopen($cacheFile, "w");
                    fwrite($fp, json_encode($data));
                    fclose($fp);
                } else {
                    $data->userinfo = $userInfo;
                }
            }
            return $data->userinfo;
        } else {
            return false;
        }
    }

    /**
     * 获取用户授权access token，使用code凭证
     * @param string $code
     * @return \stdClass
     */
    public static function getAccessToken($code) {
        // @return object{access_token,openid}
        //    {
        //       "access_token":"ACCESS_TOKEN",
        //       "expires_in":7200,
        //       "refresh_token":"REFRESH_TOKEN",
        //       "openid":"OPENID",
        //       "scope":"SCOPE"
        //    }
        $RequestUrl            = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" . APPID . "&secret=" . APPSECRET . "&code=" . $code . "&grant_type=authorization_code";
        $Result                = json_decode(Curl::get($RequestUrl), true);
        $_return               = new stdClass();
        $_return->access_token = $Result['access_token'];
        $_return->openid       = $Result['openid'];
        return $_return;
    }

    /**
     * 判断是否在微信环境，而且返回valid结果
     * @return boolean
     */
    public static function isWechat() {
        if (strpos($_SERVER['HTTP_USER_AGENT'], 'MicroMessenger') !== false) {
            return true;
        } else // wechat validate request
            if (isset($_GET["timestamp"]) && isset($_GET["signature"]) && isset($_GET["echostr"])) {
                $signature = $_GET["signature"];
                $timestamp = $_GET["timestamp"];
                $nonce     = $_GET["nonce"];
                $tmpArr    = array(
                    TOKEN,
                    $timestamp,
                    $nonce
                );
                sort($tmpArr, SORT_STRING);
                $tmpStr = implode($tmpArr);
                $tmpStr = sha1($tmpStr);
                if ($tmpStr == $signature) {
                    echo $_GET["echostr"];
                }
            }
        return false;
    }

    /**
     * 获取关注者列表 0 - 10000
     * @param type $access_token
     * @param type $nextOpenid
     * @return type
     */
    public static function getWechatSubscriberList($access_token, $nextOpenid = '') {
        return json_decode(Curl::get("https://api.weixin.qq.com/cgi-bin/user/get?access_token=$access_token&next_openid=$nextOpenid"), true);
    }

    /**
     * 获取自定义菜单
     * @param type $access_token
     * @return type
     */
    public static function getMenu() {
        $access_token = self::getServiceAccessToken();
        $ret          = Curl::get("https://api.weixin.qq.com/cgi-bin/menu/get?access_token=$access_token");
        if (!empty($ret)) {
            $res = json_decode($ret, true);
            return $res['menu'];
        }
        return null;
    }

    /**
     * 更新自定义菜单
     * @param type $access_token
     * @param type $jsonStr
     * @return type
     */
    public static function setMenu($jsonStr) {
        $access_token = self::getServiceAccessToken();
        $jsonStr      = str_replace('\"', '"', $jsonStr);
        return json_decode(Curl::post("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=$access_token", $jsonStr), true);
    }

    /**
     * 获取用户分组列表
     * @see http://mp.weixin.qq.com/wiki/0/56d992c605a97245eb7e617854b169fc.html
     * @return type
     */
    public static function getUserGroup($update = false) {
        $stoken = self::getServiceAccessToken();
        $res    = Curl::get("https://api.weixin.qq.com/cgi-bin/groups/get?access_token=$stoken");
        $res    = json_decode($res);
        if (!isset($res->errcode)) {
            return $res->groups;
        }
    }

    /**
     * 获取用户所在分组
     * @param type $openId
     * @return type
     */
    public static function getUserGroupId($openId) {
        $stoken   = self::getServiceAccessToken();
        $PostData = json_encode(array('openid' => $openId));
        $Result   = Curl::post("https://api.weixin.qq.com/cgi-bin/groups/getid?access_token=$stoken", $PostData);
        return $Result['groupid'];
    }

    /**
     * 上传图片到微信服务器
     * @param type $imagePath
     * @return mixed
     */
    public static function upLoadImage($imagePath) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array("media" => "@" . $imagePath);
        $Result   = Curl::post("https://api.weixin.qq.com/cgi-bin/media/uploadimg?access_token=$stoken", $PostData, true);
        $Result   = json_decode($Result, true);
        return $Result;
    }

    /**
     * 上传多媒体内容
     * @param type $imagePath
     * @param type $type
     * @return mixed
     */
    public static function upLoadMedia($imagePath, $type = 'image') {
        $stoken   = self::getServiceAccessToken();
        $PostData = array("media" => "@" . $imagePath);
        $Result   = Curl::post("http://file.api.weixin.qq.com/cgi-bin/media/upload?access_token=$stoken&type=$type", $PostData, true);
        $Result   = json_decode($Result, true);
        return $Result;
    }

    /**
     * 上传永久素材
     * @param type $thumb_media_id 图片ID
     * @param type $title 标题
     * @param type $content 内容
     * @param type $digest 摘要
     * @param int $show_cover_pic 显示图片在正文
     * @return type
     */
    public static function upLoadGmess($thumb_media_id, $title, $content, $digest, $show_cover_pic = 1) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array(
            'articles' => array(
                array(
                    'thumb_media_id' => $thumb_media_id,
                    'title' => $title,
                    'content' => $content,
                    'digest' => $digest,
                    "show_cover_pic" => $show_cover_pic
                )
            )
        );
        $Result   = Curl::post("https://api.weixin.qq.com/cgi-bin/media/uploadnews?access_token=$stoken", str_replace('\/', '/', self::decodeUnicode(json_encode($PostData))));
        return json_decode($Result, true);
    }

    /**
     * 发送群发消息，高级接口
     * @param type $mediaId
     * @param type $istoAll
     * @param type $groupId
     * @return type
     */
    public static function sendGmessAll($mediaId, $istoAll = false) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array(
            'filter' => array(
                "is_to_all" => $istoAll
            ),
            'mpnews' => array("media_id" => $mediaId),
            "msgtype" => "mpnews"
        );
        return Curl::post("https://api.weixin.qq.com/cgi-bin/message/mass/sendall?access_token=$stoken", json_encode($PostData));
    }

    /**
     * 高级群发接口 openid列表群发
     * @param type $mediaId
     * @param type $toUser
     * @return type
     */
    public static function sendGmessOpenId($mediaId, $toUser) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array(
            "touser" => $toUser,
            'mpnews' => array("media_id" => $mediaId),
            "msgtype" => "mpnews"
        );
        $Result   = Curl::post("https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token=$stoken", json_encode($PostData));
        return json_decode($Result, true);
    }

    /**
     * decode unicode
     * @param type $str
     * @return type
     */
    public static function decodeUnicode($str) {
        return preg_replace_callback('/\\\\u([0-9a-f]{4})/i', create_function('$matches', 'return mb_convert_encoding(pack("H*", $matches[1]), "UTF-8", "UCS-2BE");'), $str);
    }

    /**
     * 获取用户增减数据
     * @param type $begin_date
     * @param type $end_date
     * @param type $stoken
     * @return type
     */
    public static function getUserSummary($begin_date, $end_date, $stoken) {
        $PostData = array(
            "begin_date" => $begin_date,
            "end_date" => $end_date
        );
        $Result   = Curl::post("https://api.weixin.qq.com/datacube/getusersummary?access_token=$stoken", json_encode($PostData));
        return json_decode($Result, true);
    }

    /**
     * 获取累计用户数据
     * @param type $begin_date
     * @param type $end_date
     * @param type $stoken
     * @return type
     */
    public static function getUserCumulate($begin_date, $end_date, $stoken) {
        $PostData = array(
            "begin_date" => $begin_date,
            "end_date" => $end_date
        );
        $Result   = Curl::post("https://api.weixin.qq.com/datacube/getusercumulate?access_token=$stoken", json_encode($PostData));
        return json_decode($Result, true);
    }

    /**
     * 修改分组名
     * @param type $id
     * @param type $name
     * @return type
     */
    public static function alterUserGroup($id, $name) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array(
            "group" => array(
                "id" => (int)$id,
                "name" => $name
            )
        );
        $Result   = json_decode(Curl::post("https://api.weixin.qq.com/cgi-bin/groups/update?access_token=$stoken", str_replace('\/', '/', self::decodeUnicode(json_encode($PostData)))), true);
        if ($Result['errcode'] == 0) {
            WechatSdk::getUserGroup(true);
        }
        return $Result;
    }

    /**
     * 添加用户分组
     * @param type $id
     * @param type $name
     * @return type
     */
    public static function addUserGroup($name) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array("group" => array("name" => $name));
        $Result   = json_decode(Curl::post("https://api.weixin.qq.com/cgi-bin/groups/create?access_token=$stoken", str_replace('\/', '/', self::decodeUnicode(json_encode($PostData)))), true);
        if (!isset($Result['errcode'])) {
            WechatSdk::getUserGroup(true);
        }
        return $Result;
    }

    /**
     * 移动用户分组
     * @param type $openid
     * @param type $groupid
     * @return type
     */
    public static function moveUserGroup($openid, $groupid) {
        $stoken   = self::getServiceAccessToken();
        $PostData = array(
            "openid" => $openid,
            "to_groupid" => $groupid
        );
        $Result   = json_decode(Curl::post("https://api.weixin.qq.com/cgi-bin/groups/members/update?access_token=$stoken", json_encode($PostData)), true);
        return $Result;
    }

    /**
     * 获取收货地址签名
     * @param string $OauthURL 授权URL
     * @param string $FinalURL 当前请求URL
     */
    public static function getAddrShareSign($OauthURL, $FinalURL) {
        // Unix时间戳
        $timestamp = time();
        // 随机字符串
        $nonceStr = rand(100000, 999999);
        // 请求收货地址参数数据
        include_once(APP_PATH . "lib/wepaySdk/SignTool.php");
        $AccessCode = WechatSdk::getAccessCode($OauthURL, "snsapi_base");
        if ($AccessCode) {
            // 获取到accesstoken和openid
            $AResult = WechatSdk::getAccessToken($AccessCode);
            #$openId = $AResult->openid;
            $AccessToken = $AResult->access_token;
            $myaddr      = new SignTool();
            $myaddr->setParameter("accesstoken", $AccessToken);
            $myaddr->setParameter("appid", APPID);
            $myaddr->setParameter("noncestr", $nonceStr);
            $myaddr->setParameter("timestamp", $timestamp);
            $myaddr->setParameter("url", $FinalURL);
            $addrsign = $myaddr->genSha1Sign();
            // 收货地址接口Json包
            $addrsignPackage = array(
                "appId" => APPID,
                "scope" => "jsapi_address",
                "signType" => "sha1",
                "addrSign" => isset($addrsign) ? $addrsign : false,
                "timeStamp" => (string)$timestamp,
                "nonceStr" => (string)$nonceStr
            );
            return $addrsignPackage;
        }
    }

}

// HTML Helper
class Helper {

    public static function convPayMethod($method) {
        $arr = array(
            'cash' => '现金',
            'bankcard' => '银联',
            'vipcard' => '会员'
        );
        if (array_key_exists($method, $arr)) {
            return $arr[$method];
        }
    }

    /**
     * 获取微信服务器ip地址列表
     * @return array
     */
    public static function getWechatServerIps() {
        $stoken = WechatSdk::getServiceAccessToken();
        $result = Curl::get("https://api.weixin.qq.com/cgi-bin/getcallbackip?access_token=$stoken");
        $result = json_decode($result);
        if ($result) {
            return $result->ip_list;
        } else {
            return [];
        }
    }

    public static function StringInsert($str, $i, $substr) {
        $startstr = "";
        $laststr  = "";
        for ($j = 0; $j < $i; $j++) {
            $startstr .= $str[$j];
        }
        for ($j = $i; $j < strlen($str); $j++) {
            $laststr .= $str[$j];
        }
        $str = ($startstr . $substr . $laststr);
        return $str;
    }

    public static function tTimeFormat_vs($stringtime) {
        return Helper::tTimeFormat(strtotime($stringtime));
    }

    public static function tTimeFormat($timestamp) {
        $curTime = time();
        $space   = $curTime - $timestamp;
        //1分钟
        if ($space < 60) {
            $string = "刚刚";
            return $string;
        } elseif ($space < 3600) { //一小时前
            $string = floor($space / 60) . "分钟前";
            return $string;
        }
        $curtimeArray = getdate($curTime);
        $timeArray    = getDate($timestamp);
        if ($curtimeArray['year'] == $timeArray['year']) {
            if ($curtimeArray['yday'] == $timeArray['yday']) {
                $format = "%H:%M";
                $string = strftime($format, $timestamp);
                return "今天 {$string}";
            } elseif (($curtimeArray['yday'] - 1) == $timeArray['yday']) {
                $format = "%H:%M";
                $string = strftime($format, $timestamp);
                return "昨天 {$string}";
            } else {
                $string = sprintf("%d月%d日 %02d:%02d", $timeArray['mon'], $timeArray['mday'], $timeArray['hours'], $timeArray['minutes']);
                return $string;
            }
        }
        $string = sprintf("%d年%d月%d日 %02d:%02d", $timeArray['year'], $timeArray['mon'], $timeArray['mday'], $timeArray['hours'], $timeArray['minutes']);
        return $string;
    }

}
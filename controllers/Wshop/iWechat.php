<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 微信消息入口
 * @description Holp You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class iWechat extends ControllerShop {

    /**
     * @var WXBizMsgCrypt
     */
    private $aesHelper;

    /**
     * iWechat constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->aesHelper = new WXBizMsgCrypt(TOKEN, EncodingAESKey, APPID);
    }

    /**
     * @var WechatPostObject $postObj
     */
    public function index() {

        global $config;

        $postStr = file_get_contents('php://input');

        #$postStr = '<xml> <ToUserName><![CDATA[gh_09be1bd2a23f]]></ToUserName> <Encrypt><![CDATA[Bp7T7AgsN8nMhVvquGfGN222c4dDDRkG/iXh3sUVgOI/j9GSEiWh6W83bY4vaY0myD19z8Tt1HlcBW0vA0lp/D4lOWXdQHmSc4Cs8YgYeOCAXfj/UKsmmeQRDLK1Ws/gMDSbBXy6m/y73qB7/pjxrn4iD765u3+wVYJ/pctrQi9DEqN5/vht8oL8bKTno5y9UJs1fysjo0SPAsaojQe9kjIfZ3+fDVnRPc/Jpn5rAfs/kAobzFKr6xV8uaRZVkAGZ1YurRpXdsTZ0y95vyvT9O06Z7rbyqCxNZZUW1NVrgeE/xCX3fbuHPeGdh78noS4jF/vVi+4fx+cfCLQKMpzKnjjMvCEw2vGI6zhK0E6qIR+0aGSZHVIloLs4ltZ9ST5F+ecRYQNtNw0GDNiQ7Lnsetep2DuBn45GaTdjLMEy9k=]]></Encrypt> </xml>';

        # Util::log($postStr);

        if (sizeof($_GET) == 0) {
            return Util::log("无效的微信消息请求");
        }

        if (isset($_GET['echostr'])) {
            if (!$this->checkSignature()) {
                // 验证
                Util::log("微信消息签名错误");
            } else {
                echo $_GET['echostr'];
                Util::log("微信服务器认证通过:" . $_GET['echostr']);
            }
            return true;
        }

        if ($config->wechat_check_ip && !$this->checkIpAccess()) {
            return Util::log("无效的微信消息请求, ip" . $this->Util->getIp());
        }

        // 解包
        $postObj = $this->unpackXML($postStr);

        if ($postObj && $postObj instanceof SimpleXMLElement) {

            $sMsgSignature = $_GET['msg_signature'];
            $sTimeStamp    = $_GET['timestamp'];
            $sNonce        = $_GET['nonce'];

            // 安全模式
            if ($config->wechat_aes_open && isset($postObj->Encrypt)) {

                if (!extension_loaded('mcrypt')) {
                    Util::log("加密消息体解析失败: 请先安装mcrypt扩展");
                }

                try {

                    $unpacked = false;

                    $errcode = $this->aesHelper->decryptMsg($sMsgSignature, $sTimeStamp, $sNonce, $postStr, $unpacked);

                    if ($errcode == 0) {
                        $msgData = $this->unpackXML($unpacked);
                    } else {
                        // 加密消息体解析失败
                        return Util::log("加密消息体解析失败[$errcode]: " . $postStr);
                    }

                } catch (Exception $e) {
                    Util::log("加密消息体解析失败: " . $e->getMessage());
                }

            } else {
                // 兼容或者明文模式
                $msgData = $postObj;
            }

            $this->handleRequest($msgData, $config->wechat_msg_handler);

        } else {
            // unpack error
            Util::log("微信消息解包失败, 数据:" . $postStr);
        }
    }

    /**
     * @param $postStr
     * @return WechatPostObject
     */
    private function unpackXML($postStr) {
        if (empty($postStr)) {
            return false;
        }
        return simplexml_load_string($postStr, 'SimpleXMLElement', LIBXML_NOCDATA);
    }

    /**
     * @param string $type
     * @param WechatPostObject $msgData
     * @param array $wechat_msg_handler
     */
    private function handleRequest(&$msgData, $wechat_msg_handler) {
        if ($wechat_msg_handler && $msgData) {
            $type = strtolower($msgData->MsgType);
            if (array_key_exists($type, $wechat_msg_handler)) {
                if (is_array($wechat_msg_handler[$type])) {
                    foreach ($wechat_msg_handler[$type] as $cHandler) {
                        $this->dispatchHandler($cHandler, $msgData);
                    }
                } else if (is_string($wechat_msg_handler[$type])) {
                    $this->dispatchHandler($wechat_msg_handler[$type], $msgData);
                }
            }
        } else {
            Util::log("微信消息处理失败,参数无效" . json_encode($msgData));
        }
    }

    /**
     * @param $className
     */
    private function dispatchHandler($className, &$msgData) {
        global $config;
        $object            = new $className();
        $object->aesOn     = $config->wechat_aes_open;
        $object->aesHelper = $this->aesHelper;
        $object->Dao       = $this->Dao;
        $object->Db        = $this->Db;
        $object->init($msgData);
    }

    /**
     * 验证签名
     * @return bool
     */
    private function checkSignature() {

        $signature = $_GET["signature"];
        $timestamp = $_GET["timestamp"];
        $nonce     = $_GET["nonce"];

        $token  = TOKEN;
        $tmpArr = array($token, $timestamp, $nonce);
        sort($tmpArr, SORT_STRING);
        $tmpStr = implode($tmpArr);
        $tmpStr = sha1($tmpStr);

        return $tmpStr == $signature;
    }

    /**
     * 检查ip来路
     */
    private function checkIpAccess() {
        $ip       = $this->Util->getIp();
        $wechatIp = WechatSdk::getWechatServerIps();
        return in_array($ip, $wechatIp);
    }

}

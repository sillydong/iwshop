<?php
class SignTool {

    /** 密钥 */
    var $key;

    /** 请求的参数 */
    var $parameters;

    /** debug信息 */
    var $debugInfo;

    function __construct() {
        $this->initTool();
    }

    //function SignTool() {
    function initTool() {
        $this->key = "";
        $this->parameters = array();
        $this->debugInfo = "";
    }

    /**
     * 初始化函数。
     */
    function init() {
        //nothing to do
    }

    /**
     * 获取密钥
     */
    function getKey() {
        return $this->key;
    }

    /**
     * 设置密钥
     */
    function setKey($key) {
        $this->key = $key;
    }

    /**
     * 获取参数值
     */
    function getParameter($parameter) {
        return $this->parameters[$parameter];
    }

    /**
     * 设置参数值
     */
    function setParameter($parameter, $parameterValue) {
        $this->parameters[$parameter] = $parameterValue;
    }

    /**
     * 获取所有请求的参数
     * @return array
     */
    function getAllParameters() {
        return $this->parameters;
    }

    /**
     * 获取url模式的参数字符串(encode后数据)
     */
    function getUrlString() {
        $this->createMD5Sign();
        $reqPar = "";
        ksort($this->parameters);
        foreach ($this->parameters as $k => $v) {
            $reqPar .= $k . "=" . urlencode($v) . "&";
        }
        //去掉最后一个&
        $reqPar = substr($reqPar, 0, strlen($reqPar) - 1);
        return $reqPar;
    }

    /**
     * 获取debug信息
     */
    function getDebugInfo() {
        return $this->debugInfo;
    }

    /**
     * 创建md5摘要,规则是:按参数名称a-z排序,遇到空值的参数不参加签名。
     */
    function createMD5Sign() {
        $signPars = "";
        ksort($this->parameters);
        foreach ($this->parameters as $k => $v) {
            if ("" != $v && "sign" != $k) {
                $signPars .= $k . "=" . $v . "&";
            }
        }
        $signPars .= "key=" . $this->getKey();
        $sign = strtoupper(md5($signPars));
        $this->setParameter("sign", $sign);
        //debug信息
        $this->_setDebugInfo("source:" . $signPars . "|sign:" . $sign);
    }

    //创建签名SHA1
    function genSha1Sign() {
        $signPars = '';
        ksort($this->parameters);
        foreach ($this->parameters as $k => $v) {
            if ("" != $v && "sign" != $k) {
                if ($signPars == '')
                    $signPars .= $k . "=" . $v;
                else
                    $signPars .= "&" . $k . "=" . $v;
            }
        }
        $sign = SHA1($signPars);
        $this->setParameter("sign", $sign);
        //debug信息
        $this->debugInfo = "source:" . $signPars . "|appsign:" . $sign;
        return $sign;
    }

    //获取带参数列表返回给app端，自定义协议
    function getXmlBody() {
        foreach ($this->parameters as $k => $v) {
            if ($k != "appkey" && $k != "key") {
                $reqPars .= "<" . $k . ">" . $v . "</" . $k . ">" . PHP_EOL;
            }
        }
        return $reqPars;
    }

    //native支付，getpackage返回参数
    function genGetPackage() {
        $signPars = '';
        ksort($this->parameters);
        foreach ($this->parameters as $k => $v) {
            if ("AppSignature" != $k) {
                if ($signPars == '')
                    $signPars .= strtolower($k) . "=" . $v;
                else
                    $signPars .= "&" . strtolower($k) . "=" . $v;
            }
        }
        $sign = SHA1($signPars);
        $this->setParameter("AppSignature", $sign);
        //debug信息
        $this->debugInfo = "source:" . $signPars . "|sha1sign:" . $sign;

        foreach ($this->parameters as $k => $v) {
            if ($k != "AppKey") {
                if ($k == "RetCode" || $k == "TimeStamp")
                    $reqPars .= "<" . $k . ">" . $v . "</" . $k . ">";
                else
                    $reqPars .= "<" . $k . "><![CDATA[" . $v . "]]></" . $k . ">";
            }
        }
        return "<xml>" . $reqPars . "<SignMethod><![CDATA[sha1]]></SignMethod></xml>";
    }

    //维权接口参数签名检查
    function checkFeedBackSign() {

        if ($this->parameters["AppId"] == "" || $this->parameters["TimeStamp"] == "" || $this->parameters["OpenId"] == "")
            return false;

        $signPars = "appid=" . $this->parameters["AppId"] . "&appkey=" . $this->parameters["AppKey"] . "&openid=" . $this->parameters["OpenId"] . "&timestamp=" . $this->parameters["TimeStamp"];

        $sign = SHA1($signPars);

        $this->debugInfo = "source:" . $signPars . "|sha1sign:" . $sign;

        return $sign == $this->parameters["AppSignature"];
    }

    /**
     * 设置debug信息
     */
    function _setDebugInfo($debugInfo) {
        $this->debugInfo = $debugInfo;
    }
}
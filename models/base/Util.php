<?php

include_once 'Curl.php';
include_once 'DigCrypt.php';

/**
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Util extends Model
{

    private $DigCrypt;

    // 日志级别
    const LOG_ACCESS = 'access';
    const LOG_ERRORS = 'errors';

    public function __construct() {
        parent::__construct();
        $this->DigCrypt = new DigCrypt();
    }

    /**
     * getIPaddress
     * @return type
     */
    public function getIp() {
        $cIP  = getenv('REMOTE_ADDR');
        $cIP1 = getenv('HTTP_X_FORWARDED_FOR');
        $cIP2 = getenv('HTTP_CLIENT_IP');
        $cIP1 ? $cIP = $cIP1 : null;
        $cIP2 ? $cIP = $cIP2 : null;
        return $cIP;
    }

    /**
     * getIPaddress
     * @return type
     */
    public static function getIps() {
        $cIP  = getenv('REMOTE_ADDR');
        $cIP1 = getenv('HTTP_X_FORWARDED_FOR');
        $cIP2 = getenv('HTTP_CLIENT_IP');
        $cIP1 ? $cIP = $cIP1 : null;
        $cIP2 ? $cIP = $cIP2 : null;
        return $cIP;
    }

    /**
     * xssFilter
     * @todo function
     * @param type $str
     * @return type
     */
    public function xssFilter($str) {
        return addslashes($str);
    }

    public function getServerIP() {
        return gethostbyname($_SERVER["SERVER_NAME"]);
    }

    /**
     *
     * @param type $timestamp
     * @return string
     */
    public function dateTimeFormat($timestamp) {
        $timestamp = strtotime($timestamp);
        $curTime   = time();
        $space     = $curTime - $timestamp;
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
        $string = sprintf("%d-%d-%d %d:%d", $timeArray['year'], $timeArray['mon'], $timeArray['mday'], $timeArray['hours'], $timeArray['minutes']);
        return $string;
    }

    /**
     * ip转换地址
     * @param string $ip
     * @return array
     */
    public function ipConvAddress($ip) {
        $json = file_get_contents('http://ip.taobao.com/service/getIpInfo.php?ip=' . $ip);
        $arr  = json_decode($json);
        return $arr->data;
    }

    public function digEncrypt($nums) {
        return $this->DigCrypt->en($nums);
    }

    public function digDecrypt($code) {
        return $this->DigCrypt->de($code);
    }

    /**
     * 性别eng转换
     * @param string $sex
     * @return string
     */
    public function sexConv($sex) {
        $s = array(
            'f' => '女',
            'm' => '男'
        );
        if (array_key_exists($sex, $s)) {
            return $s[$sex];
        } else {
            return '未知';
        }
    }

    /**
     * digitDefault
     * @param string $input
     * @param int $default
     * @return string
     */
    public static function digitDefault($input, $default = 0) {
        return (is_numeric($input) && $input > 0) ? intval($input) : $default;
    }

    /**
     * digitDefaultZero
     * @param string $input
     * @param int $default
     * @return int
     */
    public static function digitDefaultZero($input, $default = 0) {
        return (is_numeric($input) && $input > -1) ? intval($input) : $default;
    }

    /**
     * strDefault
     * @param string $input
     * @param string $default
     * @return string
     */
    public static function strDefault($input, $default = '') {
        return !empty($input) ? trim(addslashes($input)) : $default;
    }

    /**
     * 删除目录文件
     * @param string $dir
     * @return bool
     */
    public function delDirFiles($dir) {
        $dirs = dir($dir);
        if ($dirs && is_readable($dirs)) {
            try {
                while ($file = $dirs->read()) {
                    $file = $dir . $file;
                    if (is_file($file)) {
                        unlink($file);
                    }
                }
                return true;
            } catch (Exception $ex) {
                return false;
            }
        }
        return false;
    }

    /**
     * 数组转换XML
     * @param array $arr
     * @return string
     */
    public function toXML($arr) {
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
     * 生成随机字符串
     * @param int $length
     * @return string
     */
    public function createNoncestr($length = 16) {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        $str   = "";
        for ($i = 0; $i < $length; $i++) {
            $str .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
            //$str .= $chars[ mt_rand(0, strlen($chars) - 1) ];  
        }
        return $str;
    }

    /**
     * 检查是否登陆
     * @return bool
     */
    public function isLogin() {
        if (isset($_COOKIE['uopenid']) && isset($_COOKIE['uid'])) {
            return $this->User->checkUserExt($_COOKIE['uopenid']);
        } else {
            return false;
        }
    }

    /**
     * 写入日志数据库
     * @param string $message
     * @param int $type 默认错误级别
     */
    public static function log($message, $type = self::LOG_ERRORS) {
        $dao = Dao::get_instance();
        $dao->insert(TABLE_LOGS, [
            'log_level',
            'log_info',
            'log_url',
            'log_time',
            'log_ip'
        ])->values([
            0,
            addslashes($message),
            self::getURI(),
            self::getNOW(),
            self::getIps()
        ])->exec();
    }

    /**
     * 组合数组key
     * @param $array
     */
    public static function combineArrayKey($array) {
        $tmp = [];
        foreach ($array as $key => $a) {
            $tmp[] = $key;
        }
        return $tmp;
    }

    /**
     * 组合数组值
     * @param $array
     */
    public static function combineArrayValue($array) {
        $tmp = [];
        foreach ($array as $key => $a) {
            $tmp[] = $a;
        }
        return $tmp;
    }

    /**
     * 获取完整根域名
     * @return string
     */
    public static function getHOST() {
        return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://" . $_SERVER['HTTP_HOST'];
    }

    /**
     * 获取请求完整路径
     * @return string
     */
    public static function getURI() {
        return self::getHOST() . $_SERVER['REQUEST_URI'];
    }

    /**
     * 获取根路径
     * @return string
     */
    public static function getROOT() {
        global $config;
        return self::getHOST() . $config->shoproot;
    }

    /**
     * @return bool|string
     */
    public static function getNOW() {
        return date('Y-m-d H:i:s');
    }

    /**
     * 打包商品图片地址数据
     * @param $name
     */
    public static function packProductImgURI($name) {
        global $config;
        if (isset($config->oss) && $config->oss['on']) {
            // 兼容oss
            return $name;
        } else {
            return Util::getHOST() . $config->productPicLink . $name;
        }
    }

    /**
     * 转换回调地址
     * @param string $url
     * @return string
     */
    public static function convURI($url) {
        $url = preg_replace("/(\?|\&)from=(timeline|singlemessage|groupmessage)&isappinstalled=0/", "", $url);
        $tmp = parse_url($url);
        parse_str($tmp[query], $t);
        if ($t[code] || $t[state]) {
            $a = array('code' => $t[code], 'state' => $t[state]);
            $s = http_build_query($a);
            $r = preg_replace("/(\?|\&)" . $s . "/", "", $url);
        } else {
            $r = $url;
        }
        return $r;
    }

    /**
     * 获取今天星期几
     */
    public function getTodayStr() {
        $weekarray = array(
            "日",
            "一",
            "二",
            "三",
            "四",
            "五",
            "六"
        );
        return $weekarray[date('w')];
    }

    /**
     * 充值订单序列号
     * @return string
     */
    public function createDepositSerial(){
        return "D_" . time() . mt_rand(100, 999);
    }

}

<?php

/**
 * Curl模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Curl {
    /**
     * @param $url
     * @return mixed
     */
    public static function get($url) {
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url); // 要访问的地址
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 对认证证书来源的检查
        curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97'); // 模拟用户使用的浏览器
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); // 使用自动跳转
        curl_setopt($curl, CURLOPT_AUTOREFERER, 1); // 自动设置Referer
        curl_setopt($curl, CURLOPT_TIMEOUT, 30); // 设置超时限制防止死循环
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); // 获取的信息以文件流的形式返回
        $res = curl_exec($curl);
        curl_close($curl);
        return $res;
    }

    /**
     * @param $url
     * @param $postData
     * @param bool|false $raw
     * @return mixed
     */
    public static function post($url, $postData, $raw = false) {
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        #curl_setopt($curl, CURLOPT_REFERER, 'https://mp.weixin.qq.com/');
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 对认证证书来源的检查
        curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97'); // 模拟用户使用的浏览器
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); // 使用自动跳转
        curl_setopt($curl, CURLOPT_AUTOREFERER, 1); // 自动设置Referer
        curl_setopt($curl, CURLOPT_TIMEOUT, 30); // 设置超时限制防止死循环
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); // 获取的信息以文件流的形式返回
        // post数据
        curl_setopt($curl, CURLOPT_POST, 1);
		
		//http://blog.csdn.net/baidu_25845567/article/details/53172465
		//关于微信报错media data missing的解决方案
		//php5.6及旧版本curl传文件差异
				if (phpversion() < 5.6){
			if (is_array($postData) && !$raw) {
				$data = http_build_query($postData);
			}
			else{
				$data = $postData;
			}
		}
		else{
			if (is_array($postData)) {
				foreach ($postData as $key => $value){
					//如果是上传文件，以@开头
					if (substr($value,0,1) == '@'){
						$value = substr($value,1);
						$data[$key] = new CURLFile($value);
					}
					else{
						$data[$key] = $value;
					}
				}
			}
			else{
				$data = $postData;
			}
		}
		

		curl_setopt($curl, CURLOPT_POSTFIELDS,$data);
        $output = curl_exec($curl);
		
        return $output;
    }

    /**
     * @param type $url
     * @param type $head
     * @return type
     */
    public static function getWithHeader($url, $head = false) {
        $curl      = curl_init();
        $header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,";
        $header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
        $header[] = "Cache-Control: max-age=0";
        $header[] = "Connection: keep-alive";
        $header[] = "Keep-Alive: 300";
        $header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
        $header[] = "Accept-Language: en-us,en;q=0.5";
        $header[] = "Pragma: "; // browsers keep this blank.
        if ($header) {
            $header[] = $head;
        }
        curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
        curl_setopt($curl, CURLOPT_URL, $url); // 要访问的地址
        curl_setopt($curl, CURLOPT_REFERER, 'http://sz.fang.com/');
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 对认证证书来源的检查
        curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97'); // 模拟用户使用的浏览器
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); // 使用自动跳转
        curl_setopt($curl, CURLOPT_AUTOREFERER, 1); // 自动设置Referer
        curl_setopt($curl, CURLOPT_TIMEOUT, 30); // 设置超时限制防止死循环
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); // 获取的信息以文件流的形式返回
        $res = curl_exec($curl);
        curl_close($curl);
        return $res;
    }

    /**
     * curl POST
     *
     * @param   string  url
     * @param   array   数据
     * @param   int     请求超时时间
     * @param   bool    HTTPS时是否进行严格认证
     * @return  string
     */
    public static function postSSL($url, $data = array(), $timeout = 30) {

        $ch = curl_init();

        curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

        // 财付通caKey路径
        curl_setopt($ch, CURLOPT_SSLCERTTYPE, 'PEM');
        curl_setopt($ch, CURLOPT_SSLCERT, CERT_PATH);
        curl_setopt($ch, CURLOPT_SSLCERTPASSWD, PARTNER);

        //默认格式为PEM，可以注释
        curl_setopt($ch, CURLOPT_SSLCERTTYPE, 'PEM');
        curl_setopt($ch, CURLOPT_SSLKEY, CERT_KEY_PATH);

        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Expect:'));
        //curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data)); //data with URLEncode
        $ret = curl_exec($ch);
        curl_close($ch);
        $retObj = simplexml_load_string($ret, 'SimpleXMLElement', LIBXML_NOCDATA);
        return $retObj;
    }

}

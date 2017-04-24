<?php

/**
 * Api-模型
 */
class dooApi {

    const exp = 300;
    const API_RESPONSE_JSON = 'json_object';
    const API_REQUEST_METHOD_GET = 'get';
    const API_REQUEST_METHOD_POST = 'post';

    const API_TOKEN_URI = '/auth/accessToken/x3LFvimQdPlwp8wI1lg2b4dgqOvN7USe1AysoW7GCwvXeHmaZDLXiTerP5oeHRhe/';

    private static $accesstoken = false;

    /**
     * @return bool|string
     */
    public static function getToken() {
        if (!self::$accesstoken) {
            global $config;
            $accessToken       = self::_getToken();
            self::$accesstoken = $accessToken[0];
        }
        return self::$accesstoken;
    }

    /**
     * 直接获取token，无缓存
     * @return string
     */
    private static function _getToken() {
        global $config;
        $curlRet = Curl::get('https://api.doohui.com/' . self::API_TOKEN_URI);
        $rt      = json_decode($curlRet);
        if ($rt) {
            return [$rt->retmsg->access_token, $rt->retmsg->expire_at];
        } else {
            Util::log('ApiToken ERROR : ' . 'https://api.doohui.com/' . self::API_TOKEN_URI . $curlRet);
            return [false, 0];
        }
    }

    /**
     * 发起Api调用
     * @param string $uri
     * @param array $params
     * @param string $method
     */
    public static function call($uri, $params = array(), $method = self::API_REQUEST_METHOD_GET, $debug = false) {
        global $config;
        $url = 'https://api.doohui.com/' . $uri;
        if ($method == self::API_REQUEST_METHOD_GET) {
            // get
            $requestURI = $url . '?token=' . dooApi::getToken() . dooApi::packParam($params);
            $ret        = Curl::get($requestURI);
        } else {
            // post
            $requestURI = $url . '?token=' . dooApi::getToken();
            $ret        = Curl::post($requestURI, $params);
        }
        if ($debug) {
            echo $requestURI;
            var_dump($ret);
        }
        $result = json_decode($ret);
        if (!$result || empty($result) || (isset($result->retcode) && $result->retcode == 403)) {
            $tokenfile = APP_PATH . '/app/cache/accesstoken.cache.php';
            if (is_file($tokenfile)) {
                // token 过期了
                unlink($tokenfile);
            }
            return dooApi::call($uri, $params, $method, $debug);
        } else {
            return json_decode($ret);
        }
    }

    /**
     * 打包参数
     * @param type $params
     */
    public static function packParam($params) {
        $str = '';
        foreach ($params as $key => $value) {
            $str .= "&$key=$value";
        }
        return $str;
    }

}

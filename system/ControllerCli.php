<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * @property string $root 根目录
 * @property Dao $Dao Data access Object
 * @property User $User User Management
 * @property Product $Product
 * @property Banners $Banners
 * @property mOrder $mOrder
 * @property mCompany $mCompany
 * @property Email $Email
 * @property ImageUploader $ImageUploader
 * @property Db $Db
 * @property DigCrypt $DigCrypt
 * @property mGmess $mGmess
 * @property mMemcache $Memcache
 * @property config $config Description
 * @property Smarty $Smarty Smarty
 * @property Helper $Helper Helper
 * @property UserCredit $UserCredit UserCredit
 * @property UserLevel $UserLevel UserLevel
 * @property Auth $Auth Auth
 * @property Envs $Envs Envs
 * @property HomeSection $HomeSection HomeSection
 * @property Load $Load Load
 * @property SqlCached $SqlCached SqlCached
 * @property GroupBuying $GroupBuying GroupBuying
 * @property mProductSpec $mProductSpec mProductSpec
 * @property Util $Util Util
 * @property Supplier $Supplier Supplier
 * @property CreditExchange $CreditExchange CreditExchange
 * @property Express $Express Express
 * @property JsSdk $JsSdk JsSdk
 * @property WdminAdmin $WdminAdmin WdminAdmin
 * @property HomeNavigation $HomeNavigation $HomeNavigation
 * @property Session $Session Session
 * @property mCompanyLevel $mCompanyLevel mCompanyLevel
 */
class ControllerCli {

    // 模板引擎句柄
    public $Smarty;
    // ActionName
    private $Action;
    // ControllerName
    private $ControllerName;
    // QueryString
    private $QueryString;
    // currentURI
    public $uri;
    // Smarty Cache Id
    public $cacheId = null;
    // Smarty TplName
    public $TplName;
    // Now
    public $now;
    // Settings
    public $settings;
    /**
     * 来自config.php的配置文件
     * @var
     */
    public $config;

    const VPAR_RES_GET = 0;
    const VPAR_RES_POST = 1;
    const VPAR_RES_COOKIE = 2;

    /**
     * Controller constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        global $config;
        $this->config = $config;
        // Params
        $this->ControllerName = $ControllerName;
        $this->Action         = $Action;
        $this->QueryString    = $QueryString;
        $this->now            = time();
        // Smarty
        $this->Smarty = new Smarty();
        // Smarty caching
        if ($config->Smarty['cached']) {
            $this->Smarty->cache_lifetime = $config->Smarty['cache_lifetime'];
            $this->Smarty->setCacheDir($config->Smarty['cache_dir']);
        }
        $this->Smarty->caching = false;
        // Smarty TemplateDir
        $this->Smarty->setTemplateDir($config->Smarty['view_dir']);
        // Smarty CompileDir
        $this->Smarty->setCompileDir($config->Smarty['compile_dir']);
        // css version
        $this->Smarty->assign('cssversion', $config->cssversion);
        // root
        $this->Smarty->assign('docroot', $config->shoproot);
        // root
        $this->Smarty->assign('config', (array)($config));
        // searchkey
        $this->Smarty->assign('searchkey', '');
        // inwechat
        $this->Smarty->assign('inWechat', $this->inWechat());
        // pageStr
        $this->Smarty->assign('controller', $this->ControllerName);
        // Tplname
        $this->TplName = '.' . DIRECTORY_SEPARATOR . strtolower($this->ControllerName) . DIRECTORY_SEPARATOR . strtolower($this->Action) . '.tpl';

        $this->modulePreload();

        $this->initSettings();

        $this->Session->start();

        // 测试模式
        $this->Session->set('openid', 'oRky_wrIoWKBqVuafV9BM9zPrEeg');
        $this->Session->set('uid', '1374');

    }

    /**
     * 模块预加载
     * @global type $config
     */
    public function modulePreload() {
        global $config;
        foreach ($config->preload as $_preload) {
            $this->loadModel($_preload);
        }
    }

    /**
     * 模板渲染
     * 模板文件名判断，必须区分控制器目录。
     * 如果指定目录，则查找view目录
     */
    public function show($tpl_name = false) {
        $tpl_name = !$tpl_name ? $this->Action : $tpl_name;
        // 带目录路径
        if (preg_match('/\//', $tpl_name)) {
            $this->Smarty->display($tpl_name, $this->cacheId);
        } else {
            $this->Smarty->display(strtolower($this->ControllerName) . DIRECTORY_SEPARATOR . strtolower($tpl_name) . '.tpl', $this->cacheId);
        }
    }

    /**
     * 判断Smarty是否已经缓存
     * @param type $cacheId
     * @param type $tplName
     * @return type
     */
    public final function isCached($cacheId = null, $tplName = null) {
        return $this->Smarty->isCached($tplName ? $tplName : $this->TplName, $cacheId ? $cacheId : $this->cacheId);
    }

    /**
     * 加载模型
     * @param type $modelName
     * @return stdClass
     */
    public function loadModel($modelNames) {
        if (!is_array($modelNames)) {
            $modelNames = [$modelNames];
        }
        foreach ($modelNames as $modelName) {
            if (!isset($this->$modelName)) {
                // 模型未加载
                if (property_exists($modelName, 'instance')) {
                    // 单例模式
                    $this->$modelName = $modelName::get_instance();
                } else {
                    $this->$modelName = new $modelName();
                }
                // 判断是否继承Model
                if ($this->$modelName instanceof Model) {
                    $this->$modelName->linkController($this);
                }
            } else {
                // 模型已经加载
            }
        }
    }

    /**
     * 判断是否在微信浏览器
     * @return type
     */
    final public static function inWechat() {
        return strpos($_SERVER['HTTP_USER_AGENT'], 'MicroMessenger') !== false;
    }

    /**
     * 获取用户openid
     * @param type $both 是否同时获取accesstoken
     * @return boolean | object
     */
    final public function getOpenId($redirect_uri = false, $both = false) {
        $openid = $this->Session->get('openid');
        if (!empty($openid)) {
            return $openid;
        } else {
            if ($this->inWechat()) {
                $this->loadModel('WechatSdk');
                $this->loadModel('User');
                //使用原始回调地址
                $redirect_uri = !$redirect_uri ? Util::convURI($this->uri) : $redirect_uri;
                $AccessCode   = WechatSdk::getAccessCode($redirect_uri, "snsapi_base");
                if ($AccessCode !== FALSE) {
                    // 获取Openid
                    $Result = WechatSdk::getAccessToken($AccessCode);
                    $openid = $Result->openid;
                    $this->Session->set('openid', $openid);
                    // 获取Uid
                    $uid = $this->User->getUidByOpenId($openid);
                    $this->Session->set('uid', $uid);
                    // 跳转原始回调地址
                    header("location:" . $redirect_uri);
                    exit(0);
                }
            } else {
                $openid = false;
            }
            return $openid;
        }
    }

    /**
     * include path
     */
    protected function add_include_path($path) {
        set_include_path($path . get_include_path());
    }

    /**
     * 获取Ip地址
     * @return type
     */
    final public function getIp() {
        return $this->Util->getIp();
    }

    /**
     * 输出JSON
     * @param mixed $arr
     */
    final public function echoJson($arr, $options = JSON_UNESCAPED_UNICODE) {
        header('Content-Type: application/json; charset=utf-8');
        if (strpos(PHP_VERSION, '5.3') > -1) {
            // php 5.3-
            echo json_encode($arr);
        } else {
            // php 5.4+
            echo json_encode($arr, $options);
        }
        return true;
    }

    /**
     * 输出Text
     * Thx for Arlon.Young
     * @param mixed $arr
     */
    final public function echoText($arr) {
        header('Content-Type: text/plain; charset=utf-8');
        if (strpos(PHP_VERSION, '5.3') > -1) {
            // php 5.3-
            echo json_encode($arr);
        } else {
            // php 5.4+
            echo json_encode($arr, JSON_UNESCAPED_UNICODE);
        }
        return true;
    }

    /**
     * 输出失败JSON消息
     */
    final public function echoFail() {
        $this->echoMsg(-1, 'failed');
    }

    /**
     * 输出成功JSON消息
     */
    final public function echoSuccess() {
        $this->echoMsg(0, 'success');
    }

    /**
     * 输出JSON消息
     * @param mixed $code
     * @param mixed $msg
     */
    final public function echoMsg($code, $msg = '', $options = JSON_UNESCAPED_UNICODE) {
        return $this->echoJson(array(
            'ret_code' => $code,
            'ret_msg' => $msg
        ), $options);
    }

    /**
     * 数组转换JSON
     * @param array $arr
     * @return string
     */
    final public function toJson($arr) {
        return print_r(json_encode($arr), true);
    }

    /**
     * 获取店铺全局设置
     */
    public function initSettings($recache = false) {
        $redis = mRedis::get_instance();
        if ($redis && !$recache) {
            $redisKey = mRedis::getKey('wshop_setting');
            $assoc    = $redis->hGetAll($redisKey);
            if (!$assoc) {
                $assoc = $this->_getSettings();
                $redis->hMset($redisKey, $assoc);
                $redis->expireAt($redisKey, time() + 60);
            }
        } else {
            $assoc = $this->_getSettings();
        }
        $this->settings = $assoc;
        $this->Smarty->assign('settings', $assoc);
    }

    /**
     * @return array
     */
    private function _getSettings() {
        // 文件缓存
        $ass = array();
        $ret = $this->Dao->select()
            ->from('wshop_settings')
            ->exec(false);
        foreach ($ret as $r) {
            $ass[$r['key']] = $r['value'];
        }
        return $ass;
    }

    /**
     * 获取GET参数
     * @param type $name
     * @param type $default
     * @return type
     */
    public function pGet($name = false, $default = false) {
        return $this->getpostV($name, $default, $_GET);
    }

    /**
     * 获取POST参数
     * @param type $name
     * @param type $default
     * @return mixed
     */
    public function pPost($name = false, $default = false) {
        return $this->getpostV($name, $default, $_POST);
    }

    /**
     *
     * @param type $name
     * @param type $default
     * @return String
     */
    public function pCookie($name = false, $default = false) {
        if (!isset($_COOKIE[$name])) {
            return false;
        } else {
            return $this->getpostV($name, $default, $_COOKIE);
        }
    }

    /**
     *
     * @param string $key
     * @param mixed $value
     * @param int $exp
     * @return bool <b>TRUE</b> on success or <b>FALSE</b> on failure.
     */
    public function sCookie($key, $value, $exp = 36000, $path = NULL, $domain = NULL) {
        return setcookie($key, $value, $this->now + $exp, $path, $domain);
    }

    /**
     *
     * HttpOnly使得js无法读取cookie内容，防止xss
     * @param string $key
     * @param mixed $value
     * @param int $exp
     * @return bool <b>TRUE</b> on success or <b>FALSE</b> on failure.
     */
    public function sCookieHttpOnly($key, $value, $exp = 36000, $path = NULL, $domain = NULL) {
        return setcookie($key, $value, $this->now + $exp, $path, $domain, false, true);
    }

    /**
     * GET || POST Filter
     * @param type $name
     * @param type $default
     * @param type $retSet
     * @param type $isGet
     * @return boolean
     */
    private function getpostV($name, $default = false, $retSet = array()) {
        // empty or null
        if (!$name || empty($retSet) || empty($name)) {
            // return false
            return $default;
        } else if (!isset($retSet[$name])) {
            // if default value isseted then
            // return default value
            return $default;
        } else {
            // return the filted value
            return $retSet[$name];
        }
    }

    /**
     * 获取server参数
     * @param string $name
     * @return string
     */
    final public function server($name = false) {
        if ($name !== false) {
            return $_SERVER[$name];
        } else {
            return $_SERVER;
        }
    }

    /**
     * 获取post参数
     * @param type $name
     * @return type
     */
    final public function post($name = false) {
        if (!$name) {
            return $_POST;
        }
        return $_POST[$name];
    }

    /**
     * decode unicode
     * @param type $str
     * @return type
     */
    function unIescape($str) {
        return str_replace('\/', '/', preg_replace("#\\\u([0-9a-f]+)#ie", "iconv('UCS-2', 'UTF-8', pack('H4', '\\1'))", $str));
    }

    /**
     * 跳转
     * @param mixed $href
     */
    function redirect($href) {
        header("Location:$href");
        exit(0);
    }

    /**
     * 获取系统设置项
     * @param mixed $key
     * @return mixed
     */
    public function getSetting($key) {
        if (isset($this->settings[$key])) {
            return $this->settings[$key];
        } else {
            return false;
        }
    }

    /**
     * 获取基URL
     * @return type
     */
    public function getBaseURI() {
        return $_SERVER["HTTP_HOST"] . $this->config->docroot;
    }

    /**
     * 获取用户uid
     * @return int | false
     * @todo Session
     */
    public function getUid() {
        return $this->Session->getUID();
    }

    /**
     * Smarty assign
     * @param string $key
     * @param mixed $value
     * @return bool
     */
    public function assign($key, $value) {
        return $this->Smarty->assign($key, $value);
    }

    /**
     * 写入日志文件
     * @param string $message
     * @param int $type 默认错误级别
     */
    public function log($message, $type = Util::LOG_ERRORS) {
        Util::log($message, $type);
    }

    /**
     * 控制器加载前动作，做权限控制、重定向
     * @param bool true 则继续执行
     */
    public function beforeLoad() {
        return true;
    }

    /**
     * 获取店铺名
     * @return mixed
     */
    public function getShopname() {
        return $this->config->shopName;
    }

    /**
     * 判断是否有文件上传了
     */
    public function hasFiles() {
        return sizeof($_FILES) > 0;
    }

    /**
     * 获取所有上传文件数据
     * @return UpLoadFile[]
     */
    public function getUploadedFiles() {
        if ($this->hasFiles()) {
            $tmp = [];
            foreach ($_FILES as $key => $file) {
                $tmp[] = new UpLoadFile($file);
            }
            return $tmp;
        } else {
            return [];
        }
    }

    /**
     * 是否Ajax请求
     */
    public function isAjax() {
        if (isset($_SERVER["HTTP_X_REQUESTED_WITH"]) && strtolower($_SERVER["HTTP_X_REQUESTED_WITH"]) == "xmlhttprequest") {
            // ajax 请求的处理方式
            return true;
        } else {
            // 正常请求的处理方式
            return false;
        }
    }

}

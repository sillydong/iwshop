<?php

/**
 * Conifg Object
 */
$config = new stdClass();

$config->orderStatus = array(
    'unpay' => '未支付',
    'payed' => '已支付',
    'canceled' => '已取消',
    'received' => '已完成',
    'delivering' => '快递中',
    'closed' => '已关闭',
    'refunded' => '已退款',
    'reqing' => '代付'
);

/**
 * 系统初始化自动加载模块
 */
$config->preload = array('Smarty', 'Db', 'Util', 'Dao', 'Banners', 'Load', 'Auth', 'Session');

/**
 * 控制器默认方法，最终默认为index
 */
$config->defaultAction = array(
    'ViewProduct' => 'view_list',
    'Uc' => 'home'
);

/**
 * 默认视图文件目录
 */
$config->tpl_dir = "views";

/**
 * Smarty配置
 */
$config->Smarty = [
    'cache_lifetime' => 30,
    'cache_dir' => APP_PATH . 'tmp/tpl_cache/',
    'compile_dir' => APP_PATH . 'tmp/tpl_compile/',
    'view_dir' => APP_PATH . 'views/',
    'cached' => false
];

/**
 * 默认Controller
 */
$config->default_controller = "Index";

/**
 * 模块加载自动查找路径
 */
$config->classRoot = array(
    'controllers/',
    'models/',
    'system/',
    'lib/',
    'lib/Smarty/',
    'lib/Smarty/plugins/',
    'lib/Smarty/sysplugins/',
    'lib/barcodegen/',
    'lib/phpqrcode/',
    'lib/PHPExcel/Classes/PHPExcel/',
    'controllers/Wdmin/',
    'controllers/Wshop/',
    'models/cache_adapter/',
    'controllers/Interface/'
);

/**
 * config -> shoproot
 * 微信支付发起路径
 */
$config->wxpayroot = 'wxpay.php';

/**
 * config -> admin_salt
 * 管理后台加密盐
 */
$config->admin_salt = 'm3LtFl=U';

/**
 * config -> admin_salt
 * 微店加密盐
 */
$config->wshop_salt = '_n7pq_kn';

/**
 * 默认规格名称
 */
$config->default_spec_name = '默认规格';

/**
 * 系统版本号
 */
$config->system_version = 'v0.9.6';

/**
 * 微信消息使用AES密文模式[推荐]
 * @see http://mp.weixin.qq.com/wiki/11/2d2d1df945b75605e7fea9ea2573b667.html
 */
$config->wechat_aes_open = true;

/**
 * 微信消息处理回调选项
 * 可以添加多个类名, 必须继承 WechatHandler 这个类哦
 */
$config->wechat_msg_handler = [
    'text' => ['TextHandler'],
    'event' => ['EventHandler'],
    'voice' => ['VoiceHandler']
];

/**
 * 是否检查微信ip来路
 * 如果对于安全性要求很高,请打开此选项,但是会牺牲一定的性能
 */
$config->wechat_check_ip = false;

if (is_file(__DIR__ . DIRECTORY_SEPARATOR . 'config_oss.php')) {
    include_once __DIR__ . DIRECTORY_SEPARATOR . 'config_oss.php';
}

if (is_file(__DIR__ . DIRECTORY_SEPARATOR . 'config_redis.php')) {
    include_once __DIR__ . DIRECTORY_SEPARATOR . 'config_redis.php';
}

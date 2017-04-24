<?php

/**
 * iWshop入口
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

header('X-Powered-By: DongWuTec.com');

require_once 'lib/sqlSafe.php';

// 系统根目录（完整路径）
define('APP_PATH', __DIR__ . DIRECTORY_SEPARATOR);

// 系统文档根目录（相对服务器DOCUMENT_ROOT的目录）
define('DOC_ROOT', substr(APP_PATH, strlen($_SERVER['DOCUMENT_ROOT'])));

// 判断安装，生产环境可以注释这一段以提高性能是
if (is_dir(APP_PATH . 'install/') && !is_file(APP_PATH . 'install/install.lock')) {
    header('Location:./install/');
}

// ini设置错误显示选项
ini_set('display_errors', 'On');

// 关闭magic_quotes_gpc
ini_set('magic_quotes_gpc', 'Off');

// 设置默认时区
date_default_timezone_set('PRC');

// 设置错误级别
error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_WARNING);

// 设置默认ContentType
header("Content-type:text/html;charset=utf-8");

try {

    if (PHP_SAPI == 'cli') {
        if ($argc > 0 && !empty($argv)) {
            if (!empty($argv[1])) {
                $GLOBALS['controller'] = $argv[1];
            }
            if (!empty($argv[2])) {
                $GLOBALS['action'] = $argv[2];
            }
        }
    }
    // Config
    require_once 'config/config.php';

    // Include Paths
    require_once 'config/sys_includes.php';

    // ClassLoader
    require_once 'system/ClassLoader.php';

    // App
    require_once 'system/App.php';

    // Contoller
    require_once 'system/Controller.php';

    // Model
    require_once 'system/Model.php';

    // Smarty
    require_once 'lib/Smarty/Smarty.class.php';

    // 实例化入口
    $App = App::getInstance();

    // @see URL /?/Controller/Action/@queryString
    $App->parseRequest();
} catch (Exception $ex) {

    // 错误处理 写入日志或者跳转错误页面
    Util::log($ex->getMessage());

    # echo $ex->getMessage();

}

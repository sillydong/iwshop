<?php

// 关闭错误信息
error_reporting(0);

define('APP_PATH', __DIR__ . '/../');

define('VERSION', '0.9.5');

// 引入错误捕捉

include __DIR__ . DIRECTORY_SEPARATOR . 'error_handler.php';

/*
 * Copyright (C) 2014 koodo@qq.com.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */

switch ($_POST['a']) {
    // 环境检查
    case 'env_check' : {
        $json = array();
        // php 版本
        $php_version        = explode('-', phpversion());
        $php_version        = $php_version[0];
        $json['version']    = $php_version;
        $json['version_ok'] = strnatcasecmp($php_version, '5.4.0') >= 0 ? true : false;
        // 扩展检测
        $json['ext_curl']      = extension_loaded('curl');
        $json['ext_pdo_mysql'] = extension_loaded('pdo_mysql');
        $json['ext_gd']        = extension_loaded('gd');
        // 目录检测
        $json['dir_tmp']           = is_dir(APP_PATH . 'tmp') && is_writable(APP_PATH . 'tmp');
        $json['dir_uploads']       = is_dir(APP_PATH . 'uploads') && is_writable(APP_PATH . 'uploads');
        $json['dir_html_gmess']    = is_dir(APP_PATH . 'html/gmess') && is_writable(APP_PATH . 'html/gmess');
        $json['dir_html_products'] = is_dir(APP_PATH . 'html/products') && is_writable(APP_PATH . 'html/products');
        $json['dir_install']       = is_dir(APP_PATH . 'install') && is_writable(APP_PATH . 'install');
        $json['dir_config']        = is_dir(APP_PATH . 'config') && is_writable(APP_PATH . 'config');
        if (!$json['dir_tmp']) {
            @mkdir(APP_PATH . "tmp", 777);
        }
        if (!$json['dir_uploads']) {
            @mkdir(APP_PATH . "tmp", 777);
        }
        if (!$json['dir_html_gmess']) {
            @mkdir(APP_PATH . "html/gmess", 777, true);
        }
        if (!$json['dir_html_products']) {
            @mkdir(APP_PATH . "html/products", 777, true);
        }
        echoMsg(0, $json);
    }
        break;
    // 数据库连接检查
    case 'db_valid' : {
        try {
            new PDO(sprintf("mysql:host=%s;dbname=", $_POST['f-dbaddress']), $_POST['f-dbusername'], $_POST['f-dbpassword']);
            echoMsg(0);
        } catch (Exception $e) {
            echoMsg(-1, '数据库连接失败！请检查扩展 pdo_mysql 是否已经开启或者数据库账号密码是否正确');
        }
    }
        break;
    // 数据库安装
    // @TODO 当数据库存在时，提示覆盖？
    case 'db_install': {
        $pdo = getDb($_POST['f-dbaddress'], $dbconfig['dbname'], $_POST['f-dbusername'], $_POST['f-dbpassword']);
        if ($pdo instanceof PDO) {
            try {
                $pdo->exec("drop database if exists " . $_POST['f-dbname'] . ";");
                $db_found = $pdo->exec("CREATE DATABASE IF NOT EXISTS " . $_POST['f-dbname'] . " DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;") !== false;
                if ($db_found) {
                    $db11           = array();
                    $db11['host']   = $_POST['f-dbaddress'];
                    $db11['dbname'] = $_POST['f-dbname'];
                    $db11['user']   = $_POST['f-dbusername'];
                    $db11['pwd']    = $_POST['f-dbpassword'];
                    // 导入数据库结构
                    $sql_file11 = APP_PATH . "install/database/iwshop.sql";
                    // 执行sql文件
                    run_sql_file($sql_file11, $db11, $pdo);
                    // 导入默认数据
                    $sql_file12 = APP_PATH . "install/database/demodata.sql";
                    // 执行sql文件
                    run_sql_file($sql_file12, $db11, $pdo);
                    // 写入店铺名称
                    $shopname = urldecode($_POST['f-shopname']);
                    // 写入店铺名称
                    $pdo->exec("INSERT INTO `wshop_settings` VALUES ('shopname', '$shopname', NOW(),'');");
                    // 返回成功
                    echoMsg(0);
                } else {
                    echoMsg(-1, "数据库创建失败");
                }
            } catch (Exception $ex) {
                echoMsg(-1, $ex->getMessage());
            }
        } else {
            echoMsg(-1, '数据库连接失败！请检查扩展 pdo_mysql 是否已经开启或者数据库账号密码是否正确');
        }
    }
        break;
    case 'config_install': {

        $pdo = getDb($_POST['f-dbaddress'], $dbconfig['dbname'], $_POST['f-dbusername'], $_POST['f-dbpassword']);

        $configCont = file_get_contents(dirname(__FILE__) . '/../config/config_sample.php');

        $configCont = str_replace('__APPID__', $_POST['f-appid'], $configCont);
        $configCont = str_replace('__APPSECRET__', $_POST['f-appsecret'], $configCont);
        $configCont = str_replace('__TOKEN__', $_POST['f-token'], $configCont);
        $configCont = str_replace('__PARTNER__', $_POST['f-partner'], $configCont);
        $configCont = str_replace('__PARTNERKEY__', $_POST['f-partnerkey'], $configCont);
        $configCont = str_replace('__DBNAME__', $_POST['f-dbname'], $configCont);
        $configCont = str_replace('__DBHOST__', $_POST['f-dbaddress'], $configCont);
        $configCont = str_replace('__DBUSER__', $_POST['f-dbusername'], $configCont);
        $configCont = str_replace('__DBPASS__', $_POST['f-dbpassword'], $configCont);
        $configCont = str_replace('__DOCROOT__', $_POST['f-docroot'], $configCont);
        $configCont = str_replace('__DOMAIN__', urldecode($_POST['f-domain']), $configCont);
        $configCont = str_replace('__SHOPNAME__', urldecode($_POST['f-shopname']), $configCont);

        // 写入店铺名称
        $pdo->exec("INSERT INTO `wshop_settings` VALUES ('shopname', '" . $_POST['f-shopname'] . "', '2015-11-22 13:12:18','');");

        touch(dirname(__FILE__) . '/install.lock');

        file_put_contents('../config/config.php', $configCont);

        if (file_exists(dirname(__FILE__) . '/install.lock')) {
            echoMsg(0);
        } else {
            echoMsg(-1, "请检查/install/目录权限是否可写");
        }

    }
}

/**
 * @param $sql_file
 * @param $dbconfig
 * @param $pdo PDO
 */
function run_sql_file($sql_file, $dbconfig, $pdo) {

    define('DB_CHARSET', 'utf8');
    $dbname = $dbconfig['dbname'];

    /* ############ 数据文件分段执行 ######### */
    $sql_str = file_get_contents($sql_file);
    $piece   = array(); // 数据段
    preg_match_all("@([\s\S]+?;)\h*[\n\r]@", $sql_str, $piece); // 数据以分号;\n\r换行  为分段标记
    !empty($piece[1]) && $piece = $piece[1];
    $count = count($piece);
    if ($count <= 0) {
        exit('mysql数据文件: ' . $sql_file . ' , 不是正确的数据文件. 请检查安装包.');
    }

    $tb_list = array(); // 表名列表
    preg_match_all('@CREATE\h+TABLE\h+[`]?([^`]+)[`]?@', $sql_str, $tb_list);
    !empty($tb_list[1]) && $tb_list = $tb_list[1];

    $pdo->exec("USE $dbname");

    // 开始循环执行
    for ($i = 0; $i < $count; $i++) {
        $pdo->exec($piece[$i]);
    }
}

/**
 * @param $host
 * @param $db
 * @param $user
 * @param $pass
 */
function getDb($host, $db, $user, $pass) {
    try {
        $pdo = new PDO(sprintf("mysql:host=%s;dbname=%s", $host, $db), $user, $pass);
        $pdo->exec("SET NAMES utf8mb4;");
        return $pdo;
    } catch (Exception $ex) {
        return false;
        // '数据库连接失败！请检查扩展PDO是否打开或者配置文件中账号密码是否正确！
    }
}
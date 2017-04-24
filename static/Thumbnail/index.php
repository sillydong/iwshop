<?php

/**
 * 生成缩略图
 * 依赖GD库
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

define('APP_PATH', __DIR__ . '/../../');

include APP_PATH . 'config/config.php';
include APP_PATH . 'models/ImageUtil.php';

$APP_PATH = $_SERVER['DOCUMENT_ROOT'];

$filePath = str_replace('//', "/", $_SERVER['DOCUMENT_ROOT'] . $_GET['p']);

$width = $_GET['w'];

$height = $_GET['h'];

$filePath = $APP_PATH . $_GET['p'];

if (is_file($filePath)) {
    $size     = getimagesize($filePath);
    $src_mime = $size['mime'];
    if (!$size) {
        return false;
    }
    ob_clean();
    header("Cache-Control: private, max-age=10800, pre-check=10800");
    header("Pragma: private");
    header("Expires: " . date(DATE_RFC822, strtotime(" 60 second")));
    header('Content-Type: ' . $src_mime);
    $docroot    = $_SERVER['DOCUMENT_ROOT'] . $config->shoproot;
    $ImageUtil  = new ImageUtil();
    $exts       = $ImageUtil->fileext($filePath);
    $cachePath  = hash('md4', $filePath);
    $cacheRoot  = APP_PATH . 'tmp' . DIRECTORY_SEPARATOR . 'img_cache' . DIRECTORY_SEPARATOR;
    $cacheSroot = $cacheRoot . substr($cachePath, 0, 4) . DIRECTORY_SEPARATOR;
    if (!is_dir($cacheSroot)) {
        mkdir($cacheSroot, 0755, true);
    }
    $cacheFile = $cacheSroot . $cachePath . '^' . $width . '-' . $height . '.' . $exts;
    if (is_file($cacheFile)) {
        echo fread(fopen($cacheFile, 'rb'), filesize($cacheFile));
    } else {
        $ImageUtil->img2thumb($filePath, $cacheFile, $width, $height);
        if (is_file($cacheFile)) {
            echo fread(fopen($cacheFile, 'rb'), filesize($cacheFile));
        } else {
            echo fread(fopen(dirname(__FILE__) . '/image_error.jpg', 'rb'), filesize(dirname(__FILE__) . '/image_error.jpg'));
        }
    }
} else {
    header('HTTP/1.1 404 Not Found');
    echo fread(fopen(dirname(__FILE__) . '/image_error.jpg', 'rb'), filesize(dirname(__FILE__) . '/image_error.jpg'));
}
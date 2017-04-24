<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Service extends ControllerShop {

    // 微信维权接口
    public function safeguarding() {
        echo 'success';
    }

    // 微信告警接口
    public function warning() {
        echo 'success';
    }

}

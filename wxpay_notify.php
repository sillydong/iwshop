<?php

/**
 * 支付回调入口
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
$GLOBALS['controller'] = 'iPayment';
$GLOBALS['action'] = 'payment_notify';

include dirname(__FILE__) . '/index.php';

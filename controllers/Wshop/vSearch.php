<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 搜索记录
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class vSearch extends ControllerShop {

    public function rd($Q) {
        $openid = $this->getOpenId();
        $this->loadModel('Search');
        $this->Search->record($openid, urldecode($Q->searchkey));
        $this->redirect('?/' . urldecode($Q->href));
    }

}

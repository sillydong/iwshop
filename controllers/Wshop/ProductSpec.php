<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 商品规格
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class ProductSpec extends ControllerShop {

    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('mProductSpec');
    }

    //put your code here
    public function ajaxAlterSpec() {
        if ($this->post('id') < 0) {
            // 删除
            $id = abs($this->post('id'));
            echo $this->Db->query("DELETE FROM `wshop_spec` WHERE id = $id;DELETE FROM `wshop_spec_det` WHERE spec_id = $id;");
        } else if ($this->post('spec_name')) {
            // 添加
            echo $this->mProductSpec->alterSpec($this->post('id'), $this->post('spec_name'), $this->post('spec_remark'), $this->post('dets'), $this->post('append'));
        } else {
            echo 0;
        }
    }

}

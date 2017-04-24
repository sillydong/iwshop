<?php

/**
 * 品牌模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Brand extends Model {

    /**
     * 获取品牌列表
     * @return type
     */
    public function getList() {
        return $this->Dao->select()
                         ->from(TABLE_BRAND)
                         ->orderby('`sort` ASC')
                         ->exec();
    }

    public function get($id, $cache = true) {
        if ($id > 0) {
            $id = intval($id);
            return $this->Db->getOneRow("SELECT * FROM `product_brand` WHERE `id` = $id;", $cache);
        }
        return false;
    }

    /**
     * 获取分类对应品牌列表
     * @param type $cat
     * @return type
     */
    public function getCatBrand($cat) {
        return $this->Dao->select()
                         ->from('product_brand')
                         ->where("brand_cat = $cat")
                         ->exec();
    }

}

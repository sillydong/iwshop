<?php

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Supplier extends Model {

    public function getList() {
        return $this->Dao->select()
                         ->from(TABLE_SUPPLIER)
                         ->exec(false);
    }

    /**
     * 获取信息
     * @param type $id
     * @return boolean
     */
    public function get($id) {
        if ($id > 0) {
            return $this->Dao->select()
                             ->from(TABLE_SUPPLIER)
                             ->where("id = $id")
                             ->getOneRow(false);
        } else {
            return false;
        }
    }

    /**
     * 获取商户产品数量
     * @param type $suppid
     */
    public function getSuppProductCount($suppid) {
        if ($suppid > 0) {
            return $this->Dao->select('')
                             ->count()
                             ->from(TABLE_PRODUCTS)
                             ->where("product_supplier = $suppid")
                             ->getOne();
        } else {
            return false;
        }
    }

    /**
     * 删除
     * @param type $id
     * @return type
     */
    public function delete($id) {
        return $this->Dao->delete()
                         ->from(TABLE_SUPPLIER)
                         ->where("id = $id")
                         ->exec();
    }

    /**
     * 新建
     * @param type $id
     * @param type $name
     * @param type $phone
     */
    public function create($data) {
        $keys   = array();
        $values = array();
        foreach ($data as $key => $value) {
            $keys[]   = $key;
            $values[] = $value;
        }
        return $this->Dao->insert(TABLE_SUPPLIER, implode(',', $keys))
                         ->values($values)
                         ->exec();
    }

    /**
     * 编辑商户
     * @param type $id
     * @param type $data
     */
    public function modify($id, $data) {
        if ($id > 0) {
            return $this->Dao->update(TABLE_SUPPLIER)
                             ->set($data)
                             ->where("id = $id")
                             ->exec();
        } else {
            return false;
        }
    }

}

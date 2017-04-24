<?php

/**
 * 积分兑换模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class CreditExchange extends Model {

    /**
     * 获取兑换积分需求
     * @param type $id
     * @return boolean
     */
    public function getReq($id) {
        if ($id > 0) {
            $id = intval($id);
            return $this->Dao->select('product_credits')
                             ->from(TABLE_CREDIT_EXCHANGE)
                             ->where("product_id = $id")
                             ->getOne();
        }
        return false;
    }

    /**
     * 获取兑换列表
     * @param type $cache
     * @return type
     */
    public function getList($cache = true) {
        return $this->Dao->select("ex.*, pd.product_name, pd.catimg")
                         ->from(TABLE_CREDIT_EXCHANGE)
                         ->alias('ex')
                         ->leftJoin(TABLE_PRODUCTS)
                         ->alias('pd')
                         ->on("pd.product_id = ex.product_id")
                         ->exec($cache);
    }

    /**
     * 添加
     * @param type $id
     * @param type $credit
     */
    public function add($id, $credit) {
        return $this->Dao->insert(TABLE_CREDIT_EXCHANGE, 'product_id, product_credits')
                         ->values(array(
                             $id,
                             $credit
                         ))
                         ->exec();
    }

    /**
     * 删除
     * @param type $id
     */
    public function del($id) {
        if ($id > 0) {
            return $this->Dao->delete()
                             ->from(TABLE_CREDIT_EXCHANGE)
                             ->where('product_id = ' . $id)
                             ->exec();
        }
        return false;
    }

    /**
     * 编辑
     * @param type $id
     * @param type $credit
     */
    public function modi($id, $credit) {
        return $this->Dao->update(TABLE_CREDIT_EXCHANGE)
                         ->set(array('product_credits' => $credit))
                         ->where('product_id = ' . $id)
                         ->exec();
    }

}

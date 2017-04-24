<?php

!defined('APP_PATH') && die(0);

/**
 * 购物车控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class UserCart extends ControllerShop
{

    /**
     * @var openid
     */
    private $openID = null;

    /**
     * @return bool
     */
    public function beforeLoad() {
        $this->openID = $this->Session->getOpenID();
        if (!$this->openID) {
            return false;
        }
        return true;
    }

    /**
     * 获取购物车数据
     */
    public function get() {

        $return = [];

        if (!empty($this->openID)) {
            $this->loadModel('User');
            $uid = $this->User->getUidByOpenId($this->openID);
            if ($uid > 0) {
                $return = $this->User->getCartData($this->openID, $uid);
            }
        }

        $this->echoMsg(0, $return);

    }

    /**
     * 添加购物车数据
     * @param int $product_id
     * @param int $spec_id
     * @param int $count
     * @param int $fixed [default:false]
     */
    public function set() {
        $product_id = $this->post('product_id');
        $spec_id    = $this->post('spec_id');
        $count      = $this->post('count');
        // 是否设置定值数量
        $fixed = $this->post('fixed', false);
        if (!empty($this->openID) && $product_id > 0 && $spec_id >= 0 && $count > 0) {
            $this->Db->cache = false;
            // 查找数据
            $cart_data = $this->Dao->select()->from(TABLE_CART)->where([
                'product_id' => $product_id,
                'spec_id' => $spec_id,
                'openid' => $this->openID
            ])->exec();
            try {
                if ($cart_data) {
                    // 定值Set
                    $set = $fixed ? ['count' => $count] : ['count' => 'count + ' . $count];
                    $this->Dao->update(TABLE_CART)->set($set, Dao::SET_RAW)->where([
                        'product_id' => $product_id,
                        'spec_id' => $spec_id,
                        'openid' => $this->openID
                    ])->exec();
                } else {
                    $this->Dao->insert(TABLE_CART, [
                        'product_id',
                        'spec_id',
                        'openid'
                    ])->values([
                        $product_id,
                        $spec_id,
                        $this->openID
                    ])->exec();
                }
                $this->echoSuccess();
            } catch (Exception $ex) {
                $this->Util->log($ex->getMessage());
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 从购物车中删除
     * @param int $product_id
     * @param int $spec_id
     * @param int $count
     * @param int $all [default:false]
     */
    public function del() {
        $product_id = $this->post('product_id');
        $spec_id    = $this->post('spec_id');
        $count      = $this->post('count');
        // 是否删除整个商品，而不是减少数量
        $all       = $this->post('all', false);
        $condition = [
            'product_id' => $product_id,
            'spec_id' => $spec_id,
            'openid' => $this->openID
        ];
        $cart_data = $this->Dao->select()->from(TABLE_CART)->where($condition)->exec();
        if ($cart_data) {
            try {
                // 如果是普通删除
                if ($cart_data['count'] > $count && !$all) {
                    $this->Dao->update(TABLE_CART)->set([
                        'count' => 'count - ' . $count
                    ], Dao::SET_RAW)->where($condition)->exec();
                } else {
                    // 溢出，全删
                    $this->Dao->delete()->from(TABLE_CART)->where($condition)->exec();
                }
                $this->echoSuccess();
            } catch (Exception $ex) {
                Util::log($ex->getMessage());
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 清空购物车
     */
    public function clear() {
        try {
            $this->Dao->delete()->from(TABLE_CART)->where([
                'openid' => $this->openID
            ])->exec();
            $this->echoSuccess();
        } catch (Exception $ex) {
            Util::log($ex->getMessage());
            $this->echoFail();
        }
    }

    /**
     * 获取购物车总数量
     */
    public function count() {
        if (!empty($this->openID)) {
            $this->Db->cache = false;
            $count           = $this->Dao->select('IFNULL(SUM(count),0 )')->alias('count')->from(TABLE_CART)->where(['openid' => $this->openID])->getOne();
            echo intval($count);
        } else {
            echo 0;
        }
    }
}
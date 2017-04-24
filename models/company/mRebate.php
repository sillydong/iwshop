<?php

/**
 * 代理返佣模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class mRebate extends Model
{
    /**
     * 删除返佣规则
     * @param $id
     * @return bool|type
     */
    public function delete($id) {
        if ($id > 0) {
            return $this->Dao->delete()
                             ->from(TABLE_REBATE_RULES)
                             ->where("id = $id")
                             ->exec();
        } else {
            return false;
        }
    }

    /**
     * 审核通过返佣
     * @param $id
     * @return bool|type
     */
    public function confirm($id) {
        if ($id > 0) {
            $rebate = $this->get($id);
            if ($rebate && $rebate['status'] == 'wait') {
                $this->loadModel('User');
                // 增加余额
                $this->User->mantUserBalance($rebate['rebate_amount'], $rebate['comid'], User::MANT_BALANCE_ADD);
                // 更新状态
                if ($this->updateStatus($id, 'pass')) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 审核拒绝返佣
     * @param $id
     * @return bool|type
     */
    public function reject($id) {
        if ($id > 0) {
            // 更新返佣单
            return $this->updateStatus($id, 'reject');
        } else {
            return false;
        }
    }

    /**
     * 获取返佣单信息
     * @param $id
     * @return Dao
     */
    public function get($id) {
        return $this->Dao->select()->from(TABLE_ORDER_REBATE)->where("id = $id")->getOneRow();
    }

    /**
     * 更新状态
     * @param $id
     * @param $status
     * @return bool
     */
    public function updateStatus($id, $status) {
        return $this->Dao->update(TABLE_ORDER_REBATE)->set([
            'status' => $status
        ])->where("id = $id")->exec();
    }

}
<?php

/**
 * 提现控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wWithdrawal extends ControllerAdmin {

    /**
     * 获取提现订单列表
     * @param int $page
     * @param string $status
     * @example ?/wWithdrawal/getList/
     */
    public function getList() {
        $search = $this->getPostStr('search');
        $status = $this->getPostStr('status', 'wait');
        $page   = $this->getPostInt('page', 1);
        if ($status != 'all') {
            $where = "status = '$status'";
        }
        // 搜索项
        if (!empty($search)) {
            $where .= "";
        }
        $page--;
        $pagesize = 25;
        $count    = $this->Dao->select('')->count(1)->from(TABLE_WITHDRAWAL_ORDER)->where($where)->getOne();
        $list     = $this->Dao->select()->from(TABLE_WITHDRAWAL_ORDER)->where($where)->limit($page * $pagesize, $pagesize)->exec();
        $this->echoJson([
            'count' => intval($count),
            'list' => $list
        ]);
    }

    /**
     * 提现审核操作
     * @param int $id
     * @param string $type [pass|reject]
     * @example ?/wWithdrawal/audit/
     */
    public function audit() {
        $id   = $this->getPostInt('id');
        $type = $this->getPostStr('type');
        if ($id > 0) {
            // 获取审核单数据
            $data = $this->Dao->select()->from(TABLE_WITHDRAWAL_ORDER)->where("status = 'wait' AND id = $id")->getOneRow();
            if ($data) {
                // 审核操作通过
                if ($type == 'pass') {
                    $this->loadModel('User');
                    $amount = doubleval($data['amount']);
                    if ($amount > 0) {
                        // 操作用户余额
                        if ($this->User->mantUserBalance($amount, $data['uid'], User::MANT_BALANCE_DIS)) {
                            // 更新审核单
                            $this->Dao->update(TABLE_WITHDRAWAL_ORDER)->set([
                                'status' => OrderWithdrawalStatus::pass
                            ])->where("id = $id")->exec();
                            // 回调通知
                            (new HookWithdrawal($this))->deal([
                                'type' => OrderWithdrawalStatus::pass,
                                'data' => $data
                            ]);
                            $this->echoSuccess();
                        } else {
                            $this->echoFail();
                        }
                    } else {
                        $this->echoFail();
                    }
                } else {
                    // 审核操作不通过
                    $this->Dao->update(TABLE_WITHDRAWAL_ORDER)->set([
                        'status' => OrderWithdrawalStatus::reject
                    ])->where("id = $id")->exec();
                    // 回调通知
                    (new HookWithdrawal($this))->deal([
                        'type' => OrderWithdrawalStatus::reject,
                        'data' => $data
                    ]);
                    $this->echoSuccess();
                }
            } else {
                $this->echoFail("审核单不存在");
            }
        } else {
            $this->echoFail();
        }
    }

}
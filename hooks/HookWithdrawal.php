<?php

/**
 * HookWithdrawal
 * 提现审核后的操作逻辑
 */
class HookWithdrawal extends Hook implements iHook {
    /**
     * @param $rebate
     */
    public function deal($data) {
        try {

            if ($data['type'] == OrderWithdrawalStatus::pass) {
                // 审核通过
            } else {
                // 审核不通过
            }

        } catch (Exception $ex) {
            Util::log($ex->getMessage());
        }
    }
}
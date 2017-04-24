<?php

/**
 * HookDeposit
 * 用户充值成功后的回调
 */
class HookDeposit extends Hook implements iHook
{
    /**
     * @param mixed $data
     */
    public function deal($data) {
        try {
            $tplconfig = include APP_PATH . 'config/config_msg_template.php';
            // 充值成功
            if (isset($tplconfig['deposit_notify'])) {
                // 获取当前用户余额
                $user = $this->Dao->select("client_money")->from(TABLE_USER)->where("client_wechat_openid = '$data[openid]'")->getOneRow(false);
                // 模板
                Messager::sendTemplateMessage($tplconfig['deposit_notify']['tpl_id'], $data['openid'], [
                    $tplconfig['deposit_notify']['first_key'] => '充值成功',
                    $tplconfig['deposit_notify']['deposit_amount'] => round($data['amount'], 2),
                    $tplconfig['deposit_notify']['deposit_time'] => date('Y-m-d H:i:s'),
                    $tplconfig['deposit_notify']['balance'] => $user['client_money'],
                    $tplconfig['deposit_notify']['remark_key'] => '点击详情 随时查看订单状态'
                ], Util::getHOST() . "?/Uc/home/");
            }
        } catch (Exception $ex) {
            Util::log($ex->getMessage());
        }
    }
}
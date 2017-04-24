<?php

/**
 * HookRebated
 * 代理返佣后的操作逻辑
 */
class HookRebated extends Hook implements iHook
{
    /**
     * @param $rebate
     */
    public function deal($data) {
        try {
            $tplconfig = include APP_PATH . 'config/config_msg_template.php';
            // 充值成功
            if (isset($tplconfig['rebate_success'])) {
                // 获取当前用户余额
                $company = $this->Dao->select('client_wechat_openid')->from(TABLE_USER)->where("client_id = $data[comid]")->getOneRow();
                if($company){
                    // 模板
                    Messager::sendTemplateMessage($tplconfig['rebate_success']['tpl_id'], $company['client_wechat_openid'], [
                        $tplconfig['rebate_success']['first_key'] => '您有一笔返佣到账了',
                        $tplconfig['rebate_success']['rebate_amount'] => $data['rebate_amount'],
                        $tplconfig['rebate_success']['rebate_time'] => date('Y-m-d H:i:s'),
                        $tplconfig['rebate_success']['remark_key'] => '请进入个人中心查看详情'
                    ], Util::getHOST() . "?/Uc/home/");
                }
            }
        } catch (Exception $ex) {
            Util::log($ex->getMessage());
        }
    }
}
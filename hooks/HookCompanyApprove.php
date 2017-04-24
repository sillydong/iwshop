<?php

/**
 * HookCompanyApprove
 * 代理审核通过之后的操作
 */
class HookCompanyApprove extends Hook implements iHook {
    /**
     * @param mixed $data
     */
    public function deal($data) {
        try {

            $tpl = MessageTemplate::getTpl('company_reg_notify');

            if ($tpl) {
                Messager::sendTemplateMessage($tpl['tpl_id'], $data['openid'], [
                    $tpl['first_key'] => '尊敬的' . $data['name'] . '，您的代理申请已通过，欢迎加入' . $this->settings['shopname'] . '大家庭',
                    $tpl['username'] => $data['name'],
                    $tpl['result'] => '已通过',
                    $tpl['remark_key'] => '点击详情 随时查看代理协议'
                ], $this->getBaseURI() . "/html/agent_agreement.html");
            }

        } catch (Exception $ex) {
            Util::log($ex->getMessage());
        }
    }
}
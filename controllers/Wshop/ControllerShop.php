<?php

/**
 * ControllerShop
 */
class ControllerShop extends Controller {

    /**
     * ControllerShop constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);

        // 获取代理编号
        if (isset($_GET['comid'])) {
            $companyId = intval($_GET['comid']);
            $uid       = $this->getUid();
            // 代理不能是自己
            if ($companyId == $uid) {
                return false;
            }
            $this->Session->set('companyId', $companyId);
            // 获取用户信息
            $openid = $this->getOpenId();
            if (!empty($openid)) {
                $this->loadModel('User');
                $info = $this->User->getUserInfoByOpenId($openid);
                if (intval($info['client_comid']) == 0) {
                    // 进行代理关联
                    $this->User->bindCompany($uid, $companyId);
                }
            }
        }
    }

}
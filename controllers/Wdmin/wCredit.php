<?php

/**
 * 积分相关控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wCredit extends ControllerAdmin {

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('CreditExchange');
        if (!$this->Auth->checkAuth()) {
            $this->redirect('?/Wdmin/logOut');
        } else {
            $this->Db->cache = false;
        }
    }

    public function modify() {
        $id     = $this->post('id');
        $amount = $this->post('amount');
        if ($id > 0 && $amount > 0) {
            if ($this->CreditExchange->modi($id, $amount)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        } else {
            $this->echoMsg(-1);
        }
    }

    public function delete() {
        $id = $this->post('id');
        if (!empty($id) && is_numeric($id)) {
            if ($this->CreditExchange->del($id)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * 添加积分兑换项
     * @param string $ids
     */
    public function add() {
        $ids = $this->post('ids');
        if (!empty($ids)) {
            if (strpos($ids, ",") > 0) {
                $ids = explode(',', $ids);
                foreach ($ids as $id) {
                    if (is_numeric($id) && $id > 0) {
                        $this->CreditExchange->add(trim($id), 0);
                    }
                }
            } else {
                if (is_numeric($ids) && $ids > 0) {
                    $this->CreditExchange->add(trim($ids), 0);
                }
            }
            $this->echoMsg(0, serialize(trim($ids)));
        } else {
            $this->echoFail();
        }
    }

}

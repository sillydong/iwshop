<?php

/**
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wSupplier extends ControllerAdmin {

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        if (!$this->Auth->checkAuth()) {
            $this->redirect('?/Wdmin/logOut');
        } else {
            $this->Db->cache = false;
        }
    }

    public function delete() {
        $id = $this->pPost('id');
        if ($id > 0) {
            $this->loadModel('Supplier');
            if ($this->Supplier->delete($id)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        } else {
            $this->echoMsg(-1);
        }
    }

    public function get($Query) {
        $id = $Query->id;
        if ($id > 0) {
            $this->loadModel('Supplier');
            $this->echoMsg(0, $this->Supplier->get($id));
        } else {
            $this->echoMsg(-1);
        }
    }

    public function modi() {
        $id   = $this->pPost('id');
        $data = $this->post('data');
        $this->loadModel('Supplier');
        if ($id > 0) {
            if ($this->Supplier->modify($id, $data)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        } else {
            if ($this->Supplier->create($data)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        }
    }

}

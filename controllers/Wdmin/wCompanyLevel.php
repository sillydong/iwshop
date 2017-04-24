<?php

/**
 * 代理等级控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      muqing <zmq2163@qq.com>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wCompanyLevel extends ControllerAdmin
{

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('mCompanyLevel');
        $this->Db->cache = false;
    }

    /**
     * 删除等级
     * @param int $id
     * /?/wCompanyLevel/deleteLevel/
     */
    public function deleteLevel() {
        $id = $this->pPost('id');
        $id = intval($id);
        if ($id > 0) {
            $this->echoMsg(0, $this->mCompanyLevel->delete($id));
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * @param $Query
     * /?/wCompanyLevel/get/
     */
    public function get($Query) {
        $id = $Query->id;
        if ($id > 0) {
            $this->echoMsg(0, $this->mCompanyLevel->get($id));
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     *修改代理等级信息
     */
    public function modi() {
        $id   = $this->pPost('id');
        $id   = intval($id);
        $data = $this->post();
        if (empty($data)) {
            return $this->echoFail();
        }
        if ($id > 0) {
            if ($this->mCompanyLevel->modify($id, $data)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        } else {
            if ($this->mCompanyLevel->create($data)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        }
    }

    /**
     * 获取代理等级信息
     * /?/wCompanyLevel/getInfo/
     */
    public function getInfo() {
        $id = $this->pPost('id');
        $id = intval($id);
        if ($id > 0) {
            $company_level = $this->mCompanyLevel->get($id);
            if ($company_level) {
                $this->echoMsg(0, $company_level);
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 获取代理等级列表
     * /?/wCompanyLevel/getList/
     */
    public function getList() {

        $company_level = $this->Dao->select("rebate_level as id,uname as name")
                                   ->from(TABLE_COMPANY_LEVEL)
                                   ->orderby('id')
                                   ->desc()
                                   ->exec();

        $this->echoJson([
            'list' => $company_level
        ]);
    }

    /**
     * 获取代理等级列表
     */
    public function getListAll() {

        $company_level = $this->Dao->select("*")
                                   ->from(TABLE_COMPANY_LEVEL)
                                   ->orderby('id')
                                   ->desc()
                                   ->exec();

        $this->echoJson([
            'list' => $company_level
        ]);
    }


}

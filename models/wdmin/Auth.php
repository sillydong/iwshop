<?php

/**
 * 权限控制模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Auth extends Model {

    /**
     * 检查管理员权限
     * @return bool
     */
    public function checkAuth() {
        $loginKey = $this->Session->get('loginKey');
        if (!$loginKey || empty($loginKey)) {
            return false;
        }
        return true;
    }

    public function get($id) {
        return $this->Dao->select()
            ->from(TABLE_AUTH)
            ->where("id = $id")
            ->getOneRow();
    }

    public function gets() {
        return $this->Dao->select()
            ->from(TABLE_AUTH)
            ->exec();
    }

}

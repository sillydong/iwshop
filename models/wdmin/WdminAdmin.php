<?php

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class WdminAdmin extends Model {

    /**
     * 生成admin加密密文
     * @global type $config
     * @param type $pwd
     * @return type
     */
    public function encryptPassword($pwd) {
        global $config;
        return hash('sha384', $pwd . $config->admin_salt);
    }

    /**
     * 校验登陆提交密码
     * @param string $pwd_db
     * @param string $pwd_submit
     * @return boolean
     */
    public function pwdCheck($pwd_db, $pwd_submit) {
        return $pwd_db == $this->encryptPassword($pwd_submit);
    }

    /**
     * 生成登陆token
     * @global type $config
     * @param type $ip
     * @param type $id
     * @return type
     */
    public function encryptToken($ip, $id) {
        return sha1($ip . $id);
    }

    /**
     * 管理员登陆记录
     * @param type $account
     * @param type $ip
     * @param type $id
     */
    public function updateAdminState($account, $ip, $id) {
        // 更新登陆时间
        $this->Db->query("UPDATE `admin` SET `admin_last_login` = NOW(),`admin_ip_address` = '$ip' WHERE id = $id;");
    }

    /**
     * 获取管理员账户
     * @param string $admin_acc
     * @return array
     */
    public function get($admin_acc) {
        return $this->Dao->select()
                         ->from(TABLE_AUTH)
                         ->where("admin_account = '$admin_acc'")
                         ->getOneRow();
    }

}

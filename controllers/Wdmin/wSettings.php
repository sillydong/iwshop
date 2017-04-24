<?php

/**
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wSettings extends ControllerAdmin
{

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

    /**
     * 更新系统设置项
     * 直接replace
     */
    public function updateSettings() {
        $data = $this->post('data');
        if (is_array($data) && count($data) > 0) {
            foreach ($data as &$d) {
                $d['value'] = trim(str_replace("'", '"', $d['value']));
                $set[]      = "('$d[name]', '$d[value]', NOW())";
            }
            $set = implode(',', $set);
            $sql = "REPLACE INTO `wshop_settings` (`key`,`value`,`last_mod`) VALUES $set;";
            if ($this->Db->exec($sql)) {
                $redis = mRedis::get_instance();
                if ($redis) {
                    $redis->del(mRedis::getKey('wshop_settings'));
                }
                echo $this->Db->query($sql);
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
    }

    /**
     * 获取店铺设置
     */
    public function ajaxGetSettings() {
        $jsonA = array();
        $datas = $this->Dao->select()
                           ->from('wshop_settings')
                           ->exec();
        foreach ($datas as $da) {
            $jsonA[$da['key']] = $da['value'];
        }
        $this->echoJson($jsonA);
    }

    /**
     * 获取运费模板
     */
    public function ajaxGetExpTemplate() {
        $datas = $this->Dao->select()
                           ->from('wshop_settings_expfee')
                           ->exec();
        $this->echoJson($datas);
    }

    /**
     * 设置运费模板
     */
    public function updateExpTemplate() {
        $data = $this->post('data');
        $this->Db->query('TRUNCATE TABLE `wshop_settings_expfee`;');
        foreach ($data as $a) {
            $this->Dao->insert('wshop_settings_expfee', '`province`,`ffee`,`ffeeadd`')
                      ->values($a)
                      ->exec();
        }
    }

    /**
     * 添加一个红包
     */
    public function addEnvs() {
        $this->loadModel('Envs');
        $id = $this->post('id') != '' ? $this->post('id') : false;
        echo $this->Envs->add($id, $this->post('name'), $this->post('req'), $this->post('dis'), $this->post('pid'), $this->post('remark'));
    }

    /**
     * 删除红包
     */
    public function delteEnvs() {
        $this->loadModel('Envs');
        echo $this->Envs->delete($this->post('id'));
    }

    /**
     * 编辑首页板块
     */
    public function alterSection() {
        $id      = $this->post('id');
        $name    = $this->post('name');
        $pid     = $this->post('pid');
        $banner  = $this->post('banner');
        $relId   = $this->post('relId');
        $relType = $this->post('relType');
        $bsort   = $this->post('bsort');
        $ftime   = $this->post('ftime');
        $ttime   = $this->post('ttime');
        if (!$bsort || !is_numeric($bsort)) {
            $bsort = 0;
        }
        if ($ftime == '') {
            $ftime = 'NULL';
        }
        if ($ttime == '') {
            $ttime = 'NULL';
        }
        if ($id > 0) {
            echo $this->Dao->update(TABLE_HOME_SECTION)
                           ->set(array(
                               'name' => $name,
                               'pid' => $pid,
                               'banner' => $banner,
                               'relid' => $relId,
                               'relType' => $relType,
                               'ftime' => $ftime,
                               'ttime' => $ttime,
                               'bsort' => $bsort
                           ))
                           ->where("id = $id")
                           ->exec();
        } else {
            echo $this->Dao->insert(TABLE_HOME_SECTION, '`name`,`pid`,`banner`,`reltype`,`relid`,`ftime`,`ttime`,`bsort`')
                           ->values(array(
                               $name,
                               $pid,
                               $banner,
                               $relType,
                               $relId,
                               $ftime,
                               $ttime,
                               $bsort
                           ))
                           ->exec();
        }
    }

    /**
     * 清空抢红包记录
     */
    public function clearEnvsRobRecord() {
        $eid = $this->post('eid');
        echo $this->Db->query("DELETE FROM `envs_robrecord` WHERE `eid` = $eid;") ? 1 : 0;
    }

    /**
     * ajax编辑用户 | 添加用户
     */
    public function ajaxAlterEnvs() {
        if ($this->post('id') == '0') {
            // add
            $field  = array();
            $values = array();
            $data   = $this->post('data');
            foreach ($data as &$d) {
                $field[]  = "`$d[name]`";
                $values[] = "'$d[value]'";
            }
            $SQL = sprintf("INSERT INTO `envs_robblist` (%s) VALUES (%s);", implode(',', $field), implode(',', $values));
            $ret = $this->Db->query($SQL);
            if ($ret !== false) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            // update
            $id = intval($this->post('id'));
            if ($id > 0) {
                $set  = array();
                $gid  = false;
                $data = $this->post('data');
                foreach ($data as &$d) {
                    $set[] = "`$d[name]` = '$d[value]'";
                }
                $set = implode(',', $set);
                $sql = "UPDATE `envs_robblist` SET $set WHERE `id` = $id";
                echo $this->Db->query($sql);
            }
        }
        #echo $SQL;
    }

    /**
     * 删除抢红包活动
     */
    public function deleteEnvsRob() {
        $id = $this->post('id');
        echo $this->Dao->delete()
                       ->from(TABLE_ENVS_ROBLIST)
                       ->where("id = $id")
                       ->exec();
    }

    /**
     * 获取用户账户信息
     */
    public function getAccount() {
        $id = $this->pPost('id');
        if ($id > 0) {
            $account = $this->Auth->get($id);
            $this->echoMsg(0, $account);
        } else {
            $this->echoFail();
        }
    }

    /**
     * 获取
     */
    public function getAccounts() {
        $this->loadModel('Auth');
        $auths   = $this->Auth->gets();
        $authStr = [
            'orde' => '订单管理',
            'prod' => '商品管理',
            'user' => '用户管理',
            'sett' => '店铺设置',
            'stat' => '报表中心',
            'gmes' => '营销管理',
            'comp' => '代理合作'
        ];
        foreach ($auths as &$auth) {
            $auth['admin_authstr'] = [];
            $tmp                   = explode(',', $auth['admin_auth']);
            foreach ($tmp as $t) {
                $auth['admin_authstr'][] = $authStr[$t];
            }
            $auth['admin_authstr'] = implode(',', $auth['admin_authstr']);
        }
        $this->echoMsg(0, $auths);
    }

    /**
     * 删除管理员账户
     */
    public function deleteAuth() {
        $id = $this->post('id');
        if ($id > 0) {
            if ($this->Dao->delete()
                          ->from(TABLE_AUTH)
                          ->where("id = $id")
                          ->exec()
            ) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 添加权限账号
     */
    public function addAuth() {
        $id   = $this->post('id');
        $name = $this->post('name');
        $acc  = $this->post('acc');
        $auth = $this->post('auth');
        $pwd  = $this->post('pwd');
        $this->loadModel('WdminAdmin');
        if ($pwd != '') {
            $pwd = $this->WdminAdmin->encryptPassword($pwd);
            if ($id > 0) {
                if ($this->Dao->update(TABLE_AUTH)
                              ->set(array(
                                  'admin_name' => $name,
                                  'admin_account' => $acc,
                                  'admin_auth' => $auth,
                                  'admin_password' => $pwd
                              ))
                              ->where("id = $id")
                              ->exec()
                ) {
                    $this->echoSuccess();
                } else {
                    $this->echoFail();
                }
            } else {
                if ($this->Dao->insert(TABLE_AUTH, 'admin_name, admin_account, admin_auth, admin_password')
                              ->values(array(
                                  $name,
                                  $acc,
                                  $auth,
                                  $pwd
                              ))
                              ->exec()
                ) {
                    $this->echoSuccess();
                } else {
                    $this->echoFail();
                }
            }
        } else {
            if ($id > 0) {
                if ($this->Dao->update(TABLE_AUTH)
                              ->set(array(
                                  'admin_name' => $name,
                                  'admin_account' => $acc,
                                  'admin_auth' => $auth,
                              ))
                              ->where("id = $id")
                              ->exec()
                ) {
                    $this->echoSuccess();
                } else {
                    $this->echoFail();
                }
            } else {
                if ($this->Dao->insert(TABLE_AUTH, 'admin_name, admin_account, admin_auth')
                              ->values(array(
                                  $name,
                                  $acc,
                                  $auth
                              ))
                              ->exec()
                ) {
                    $this->echoSuccess();
                } else {
                    $this->echoFail();
                }
            }
        }
    }

    /**
     * 编辑首页导航
     */
    public function alterNavigation() {
        $id      = $this->post('id');
        $name    = $this->post('nav_name');
        $content = $this->post('nav_content');
        $ico     = $this->post('nav_ico');
        $type    = $this->post('nav_type');
        $sort    = $this->post('sort');
        if (!$sort || !is_numeric($sort)) {
            $sort = 0;
        }
        if ($type == -1) {
            $type = 1;
        }
        if ($id > 0) {
            echo $this->Dao->update(TABLE_HOME_NAV)
                           ->set(array(
                               'nav_name' => $name,
                               'nav_ico' => $ico,
                               'nav_type' => $type,
                               'nav_content' => $content,
                               'sort' => $sort
                           ))
                           ->where("id = $id")
                           ->exec();
        } else {
            echo $this->Dao->insert(TABLE_HOME_NAV, '`nav_name`,`nav_ico`,`nav_type`,`nav_content`,`sort`')
                           ->values(array(
                               $name,
                               $ico,
                               $type,
                               $content,
                               $sort
                           ))
                           ->exec();
        }
    }

    /**
     * 获取微信自定义菜单
     */
    public function ajaxGetWechatMenu() {
        $this->loadModel('WechatSdk');
        $this->Smarty->assign('menu', WechatSdk::getMenu());
        $this->show('./views/wdminpage/settings/settings_menu_data.tpl');
    }

}

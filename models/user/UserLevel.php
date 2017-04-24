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
class UserLevel extends Model
{

    /**
     * 添加一个会员级别
     * @param type $name
     * @param type $credit
     * @param type $discount
     * @param type $feed
     * @param type $upable
     */
    public function addLevel($id, $name, $credit, $discount, $feed, $remark = '', $upable = true) {
        if ($id !== false && $id >= 0) {
            $ret = $this->Dao->update(TABLE_USER_LEVEL)
                             ->set(array(
                                 'level_name' => $name,
                                 'level_credit' => $credit,
                                 'level_discount' => $discount,
                                 'level_credit_feed' => $feed,
                                 'remark' => $remark,
                                 'upable' => intval($upable)
                             ))
                             ->where("id = $id")
                             ->exec();
            return $ret;
        } else {
            return $this->Dao->insert(TABLE_USER_LEVEL, 'level_name, level_credit, level_discount, level_credit_feed, remark, upable')
                             ->values(array(
                                 $name,
                                 $credit,
                                 $discount,
                                 $feed,
                                 $remark,
                                 intval($upable)
                             ))
                             ->exec();
        }
    }

    /**
     *
     * @param type $id
     * @return type
     */
    public function delete($id) {
        return $this->Dao->delete()
                         ->from(TABLE_USER_LEVEL)
                         ->where("id = $id")
                         ->exec();
    }

    /**
     * 获取等级列表
     * @return type
     */
    public function getList($cache = false) {
        return $this->Dao->select()
                         ->from(TABLE_USER_LEVEL)
                         ->exec($cache);
    }

    /**
     * 设置一个会员的级别
     * @param type $uid
     * @param type $levelid
     */
    public function set($uid, $levelid) {
        return $this->Dao->update(TABLE_USER)
                         ->set(array('client_level' => $levelid))
                         ->where("client_id = $uid")
                         ->exec();
    }

    /**
     * 获取等级信息
     * @param type $levId
     * @return type
     */
    public function get($levId) {
        return $this->Dao->select()
                         ->from(TABLE_USER_LEVEL)
                         ->where("id = $levId")
                         ->getOneRow();
    }

    /**
     *
     * @param type $uid
     */
    public function getLevByUid($uid) {
        $lev = $this->Dao->select('client_level')
                         ->from(TABLE_USER)
                         ->where("client_id = $uid")
                         ->getOne();
        return $this->get($lev);
    }

    /**
     * 检查升级
     * @param type $uid
     * @param type $credit
     */
    public function checkUpdate($uid) {
        $credit = $this->Dao->select('client_credit')
                            ->from(TABLE_USER)
                            ->where("client_id = $uid")
                            ->getOne();
        $nLev   = $this->Dao->select()
                            ->from(TABLE_USER_LEVEL)
                            ->where("level_credit <= $credit")
                            ->aw("upable = 1")
                            ->getOneRow();
        if (count($nLev) > 0) {
            // 可以升级
            // @todo 升级提示
            return $this->Dao->update(TABLE_USER)
                             ->set(array('client_level' => $nLev['id']))
                             ->where("client_id = $uid")
                             ->exec();
        } else {
            return false;
        }
    }

}

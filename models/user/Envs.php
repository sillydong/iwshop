<?php

/**
 * 红包模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Envs extends Model {

    /**
     * 添加红包种类
     * @param type $id
     * @param type $name
     * @param type $req
     * @param type $dis
     * @param type $pid
     * @return typ
     */
    public function add($id, $name, $req, $dis, $pid = 0, $remark = '') {
        if ($id > 0) {
            return $this->Dao->update(TABLE_USER_ENVL_TYPE)
                ->set(array(
                    'name' => $name,
                    'req_amount' => $req,
                    'dis_amount' => $dis,
                    'pid' => $pid,
                    'remark' => $remark
                ))
                ->where("id = $id")
                ->exec();
        } else {
            return $this->Dao->insert(TABLE_USER_ENVL_TYPE, '`name`, req_amount, dis_amount, pid, remark')
                ->values(array(
                    $name,
                    $req,
                    $dis,
                    $pid,
                    $remark
                ))
                ->exec();
        }
    }

    /**
     * 发放红包
     * @param type $uid
     * @param type $id
     */
    public function send($uid, $id, $count, $envsDt) {
        if ($envsDt == '') {
            return false;
        }
        $this->loadModel('User');
        $openid = $this->User->getOpenIdByUid($uid);
        $ex     = $this->Dao->select()
            ->from(TABLE_USER_ENVL)
            ->where("uid = $uid AND envid = $id AND `exp` = '$envsDt'")
            ->getOneRow();
        if ($ex) {
            $result = $this->Db->query("update `client_envelopes` set `count` = `count` + $count WHERE `uid` = $uid AND `envid` = $id AND `exp` = '$envsDt'");
        } else {
            $result = $this->Dao->insert(TABLE_USER_ENVL, 'uid,openid,envid,count,exp')
                ->values(array(
                    $uid,
                    $openid,
                    $id,
                    $count,
                    $envsDt
                ))
                ->exec();
        }
        if ($result !== false) {
            $this->loadModel('User');
            $this->loadModel('WechatSdk');
            // 提示用户
            $envsT  = $this->get($id);
            $openid = $this->User->getOpenIdByUid($uid);
            $host   = Util::getHOST();
            // 发送消息
            Messager::sendText(WechatSdk::getServiceAccessToken(), $openid, "恭喜你获得" . $envsT['name'] . "一个，<a href='$host?/Uc/home/'>点击查看</a>");
            return true;
        }
        return false;
    }

    /**
     * 删除红包
     * @param int $uid
     * @param int $id
     * @param int $count
     * @return bool
     */
    public function distoryEnvs($uid, $id, $count = 1) {
        $result = $this->Dao->update(TABLE_USER_ENVL)->set([
            'count' => 'count - ' . $count
        ], true)->where([
            'uid' => $uid,
            'envid' => $id
        ])->exec();
        // 回收一下无效的红包
        $this->Dao->delete()->from(TABLE_USER_ENVL)->where("count < 0")->exec();
        if ($result === false) {
            return $this->Dao->delete()
                ->from(TABLE_USER_ENVL)
                ->where("uid = $uid AND envid = $id")
                ->exec();
        }
        return true;
    }

    /**
     * 获取一个红包
     * @param type $id
     * @return type
     */
    public function get($id) {
        return $this->Dao->select()
            ->from(TABLE_USER_ENVL_TYPE)
            ->where("id = $id")
            ->getOneRow();
    }

    public function gets() {
        return $this->Dao->select()
            ->from(TABLE_USER_ENVL_TYPE)
            ->exec();
    }

    /**
     * 获取 抢红包活动列表
     * @return type
     */
    public function getRobList() {
        return $this->Dao->select()
            ->from(TABLE_ENVS_ROBLIST)
            ->exec();
    }

    /**
     * 获取活动信息
     * @param type $id
     * @return type
     */
    public function getRob($id) {
        return $this->Dao->select()
            ->from(TABLE_ENVS_ROBLIST)
            ->where("id = $id")
            ->getOneRow();
    }

    /**
     * 获取用户红包列表
     * @param int $uid
     * @return type
     */
    public function getUserEnvs($uid) {
        $envs = $this->Dao->select()
            ->from(TABLE_USER_ENVL)
            ->alias('env')
            ->leftJoin(TABLE_USER_ENVL_TYPE)
            ->alias('envt')
            ->on("env.envid = envt.id")
            ->where("uid = $uid")
            ->aw("(exp > NOW() OR exp = '0000-00-00 00:00:00')")
            ->aw("env.count > 0")
            ->exec();
        foreach ($envs as &$en) {
            if ($en['pid'] == '') {
                $en['pidx'] = '全品';
            } else {
                $P          = explode(',', $en['pid']);
                $en['pidx'] = count($P) . '类商品';
            }
        }
        return $envs;
    }

    /**
     * 获取商品关联红包
     * @param type $pid
     * @return type
     */
    public function getPdEnvs($pid, $limit = 10) {
        return $this->Dao->select()
            ->from(TABLE_USER_ENVL_TYPE)
            ->where("FIND_IN_SET($pid,pid)")
            ->limit($limit)
            ->exec();
    }

    /**
     * 获取商品关联红包
     * @param string $pid
     * @return string
     */
    public function getPdEnvsJoinStr($pid, $limit = 10) {
        return $this->Dao->select("GROUP_CONCAT(id)")
            ->from(TABLE_USER_ENVL_TYPE)
            ->where("FIND_IN_SET($pid,pid)")
            ->limit($limit)
            ->getOne();
    }

    /**
     * 删除红包类型
     * @param type $id
     * @return type
     */
    public function delete($id) {
        return $this->Dao->delete()
            ->from(TABLE_USER_ENVL_TYPE)
            ->where("id = $id")
            ->exec();
    }

    /**
     * 获取红包数量
     * @param $uid
     */
    public function getCount($uid) {
        return intval($this->Db->getOne("SELECT COUNT(`id`) AS `count` FROM `client_envelopes` WHERE `uid` = '$uid' AND `count` > 0 AND `exp` > NOW();"));
    }

}

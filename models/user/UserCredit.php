<?php

/**
 * 用户积分模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class UserCredit extends Model {

    /**
     * 加减积分
     * @param type $uid
     * @param type $point
     * @return boolean
     */
    public function add($uid, $point) {
        if ($uid > 0 && is_numeric($point)) {
            $command = $point > 0 ? '+' : '-';
            $point = abs($point);
            $ret = $this->Db->query("UPDATE clients SET `client_credit` = client_credit $command $point wHerE client_id = $uid;");

            if( $command == '+'){
                //用户分组升级
                $user = $this->Db->getOneRow("SELECT * FROM clients WHERE client_id = $uid;");
                $credit = $user['client_credit'];
                $level = $this->Db->getOne("SELECT max(id) FROM client_level WHERE level_credit < $credit;");
                if( $level > $user['client_level'] ){
                    $this->Db->query("UPDATE clients SET `client_level` = $level WHERE client_id = $uid;");
                }
            }

            return $ret;
        }
        return false;
    }

    /**
     * 记录积分情况
     * @param int $uid
     * @param float $amount
     * @param int $reltype
     * @param int $relid
     * @param string $remark
     */
    public function record($uid, $amount, $reltype = 0, $relid = 0, $remark = '') {
        return $this->Dao->insert(TABLE_CREDIT_RECORD, '`uid`,`amount`,`reltype`,`relid`, `dt`, `remark`')
                         ->values(array($uid, $amount, $reltype, $relid, 'NOW()', $remark))->exec();
    }

}

<?php

/**
 * 搜索模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Search extends Model{

    /**
     *
     * @param type $openid
     * @param type $key
     */
    public function record($openid, $key) {
        if (!empty($openid) && $openid !== '') {
            $r = $this->Dao->insert(TABLE_SEARCH_RECORD, '`openid`,`key`,`time`')
                           ->values(array(
                               $openid,
                               $key,
                               'NOW()'
                           ))
                           ->exec();
            return $r;
        }
        return false;
    }

}

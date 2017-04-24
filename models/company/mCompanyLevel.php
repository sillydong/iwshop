<?php

/**
 * 代理等级模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      muqing <zmq2163@qq.com>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class mCompanyLevel extends Model
{

    /**
     * @return type
     */
    public function getList() {
        return $this->Dao->select()
                         ->from(TABLE_COMPANY_LEVEL)
                         ->exec(false);
    }

    /**
     * 删除代理等级信息
     * @param type $id
     * @return boolean
     */
    public function delete($id) {
        if ($id > 0) {
            return $this->Dao->delete()
                             ->from(TABLE_COMPANY_LEVEL)
                             ->where("id = $id")
                             ->exec();
        } else {
            return false;
        }
    }

    /**
     * 获取代理等级信息
     * @param type $id
     * @return boolean
     */
    public function get($id) {
        if ($id > 0) {
            return $this->Dao->select()
                             ->from(TABLE_COMPANY_LEVEL)
                             ->where("id = $id")
                             ->getOneRow(false);
        } else {
            return false;
        }
    }

    /**
     * 新建
     * @param type $id
     * @param type $name
     * @param type $phone
     */
    public function create($data) {
        $keys   = array();
        $values = array();
        foreach ($data as $key => $value) {
            $keys[]   = $key;
            $values[] = $value;
        }
        return $this->Dao->insert(TABLE_COMPANY_LEVEL, implode(',', $keys))
                         ->values($values)
                         ->exec();
    }


    /**
     * 编辑代理等级信息
     * @param type $id
     * @param type $data
     */
    public function modify($id, $data) {
        if ($id > 0) {
            return $this->Dao->update(TABLE_COMPANY_LEVEL)
                             ->set($data)
                             ->where("id = $id")
                             ->exec();
        } else {
            return false;
        }
    }

}

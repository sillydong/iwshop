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
class Load extends Model {

    public function __construct() {
        parent::__construct();
    }

    /**
     * 加载模型
     * @param type $modelName
     * @return stdClass
     */
    public function model($modelName) {
        if (!isset($this->Controller->$modelName)) {
            if (property_exists($modelName, 'instance')) {
                // 单例模式
                $this->Controller->$modelName = $modelName::get_instance();
            } else {
                $r                            = new $modelName();
                $this->Controller->$modelName = $r;
                $r->linkController($this->Controller);
            }
        }
        return $r;
    }

}

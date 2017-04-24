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
class Logger extends Model {
    
    /**
     * log content to log db table
     * @param type $content
     */
    public function log($content) {
        $this->Db->query("INSERT INTO `log` (`logcont`) VALUES ('$content');");
    }
}

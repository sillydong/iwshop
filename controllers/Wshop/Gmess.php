<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 素材控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Gmess extends ControllerShop {

    /**
     * Gmess constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('mGmess');
    }

    /**
     * 群发页面
     * @param type $Query
     */
    public function view($Query) {
        $id = (int)$Query->id;
        if ($id > 0) {
            $this->cacheId                = $id;
            $this->Smarty->cache_lifetime = 7200;
            if (!$this->isCached()) {
                $this->initSettings(true);//读admin_setting
                $this->Db->query("UPDATE `gmess_send_stat` set read_count = read_count + 1 WHERE `msg_id` = $id;");
                $gmess               = $this->mGmess->getGmess($id);
                $gmess['createtime'] = date("Y-n-d", strtotime($gmess['createtime']));
                $this->Smarty->assign('page', $gmess);
            }
            $this->show('./views/wshop/gmess/view.tpl');
        }
    }

    /**
     * ajax记录分享数量
     * @param type $Query
     */
    public function ajaxUpShare($Query) {
        $id = (int)$Query->id;
        $this->Db->query("UPDATE `gmess_send_stat` set share_count = share_count + 1 WHERE `msg_id` = $id;");
        $this->log("UPDATE `gmess_send_stat` set share_count = share_count + 1 WHERE `msg_id` = $id;");
    }

    /**
     * 获取素材
     * @param type $Query
     */
    public function ajaxGetGmess($Query) {
        $id  = (int)$Query->id;
        $res = $this->Db->query("SELECT * FROM `gmess_page` WHERE `id` = $id;");
        $this->echoJson($res[0]);
    }

    /**
     * 客服消息群发
     * @param type $gmessId
     * @param type $method
     * @param type $isGroup
     * @param type $GroupId
     * @param type $openIds
     */
    public function sendGmessSWay() {
        $gmessId = intval($this->post('id'));
        $openIds = $this->post('openid');
        if (is_array($openIds) && count($openIds) > 0) {
            // openid列表群发
        } else {
            echo 0;
        }
    }

}

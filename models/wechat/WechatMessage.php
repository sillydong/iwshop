<?php

/**
 * 微信消息会话
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class WechatMessage extends Model {

    /**
     * 获取微信消息会话列表
     * @return type
     */
    public function getSessions() {
        return $this->Db->query("SELECT cls.*,cl.client_head AS headimg,cl.client_name FROM `client_message_session` cls LEFT JOIN `clients` cl ON cl.client_wechat_openid = cls.openid;");
    }

    /**
     * 获取会话消息列表
     * @param type $openid
     * @return type
     */
    public function getSession($openid) {
        return $this->Db->query("SELECT * FROM `client_messages` WHERE `openid` = '$openid';");
    }

}
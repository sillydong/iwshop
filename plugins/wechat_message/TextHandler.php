<?php

/**
 * 文本消息处理器
 * @description Holp You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class TextHandler extends WechatHandler
{
    /**
     * @param WechatPostObject $postObj
     */
    public function handle(&$postObj)
    {
        // 你可以在这里编写你要处理的逻辑

        $postObj->Content = trim($postObj->Content);

        $this->EnvsRobb($postObj->Content);
        $this->autoResponse($postObj->Content);

    }

    /**
     * 系统定义自动回复
     * @param $Content
     * @throws Exception
     */
    private function autoResponse($Content){

        // 系统定义自动回复
        $rep = $this->getAutoRspData($Content);

        /*
         * Added By Lei
         * http://www.jiloc.com
         * jerry.jee@live.com
         * 没有设定关键词的默认回复，名为 default
         */
        if (!$rep) {
            $Content = 'default';
            $rep = $this->getAutoRspData($Content);
        }

        if ($rep) {
            // 自动回复已匹配
            $this->Db->query("INSERT INTO `client_messages` (`openid`,`msgcont`,`autoreped`,`send_time`) VALUES ('$this->openID','$Content',1,NOW());");
            if ($rep['rel'] != 0 && $rep['reltype'] == 1) {
                $this->echoGmess($rep['rel']);
            } else {
                $this->responseText($rep['message']);
            }
        } else {
            @$this->Db->query("INSERT INTO `client_messages` (`openid`,`msgcont`,`autoreped`,`send_time`) VALUES ('$this->openID','$Content',0,NOW());");
        }
        @$this->Db->query("REPLACE INTO `client_message_session` (`openid`,`undesc`,`unread`,`lasttime`) VALUES ('$this->openID','$Content',(SELECT COUNT(*) FROM `client_messages` WHERE `openid` = '$this->openID' AND `msgtype` = 0 AND `sreaded` = 0),NOW());");

    }

    /**
     * 抢红包
     * @param $Content
     * @throws Exception
     */
    private function EnvsRobb($Content){

        //抢红包
        $Robs = $this->Db->query("SELECT * FROM `envs_robblist` WHERE `key` = '$Content';", FALSE);

        if (sizeof($Robs) > 0) {
            $Robs = $Robs[0];
            $RobId = $Robs['id'];
            $envsRobId = $Robs['envsid'];
            $envsRobOpen = $Robs['on'];
            if ($envsRobOpen > 0) {
                // 是否已经抢过
                $ex = $this->Db->query("SELECT * FROM `envs_robrecord` WHERE `openid` = '$this->openID' AND `envsid` = $envsRobId AND `eid` = $RobId;", FALSE);
                if (count($ex) == 0) {
                    // update限量 悲观锁
                    $remains = $Robs['remains'];
                    if ($remains >= 1) {
                        $remains--;
                        // 默认30天过期
                        $exp = date('Y-m-d H:i:s', strtotime('+30 day'));
                        // 获取uid
                        $uid = $this->Db->getOne("SELECT `client_id` FROM `clients` WHERE `client_wechat_openid` = '$this->openID';");
                        $uid = $uid > 0 ? $uid : NULL;
                        $ex = $this->Db->getOne("SELECT * FROM `client_envelopes` WHERE openid = '$this->openID' AND envid = $envsRobId and `exp` = '$exp';");
                        if ($ex && isset($ex['openid'])) {
                            $this->Db->query("UPDATE `client_envelopes` set `count` = `count` + 1 WHERE openid = '$this->openID' AND `envid` = $envsRobId AND `exp` = '$exp'");
                        } else {
                            $this->Db->query("INSERT INTO `client_envelopes` (openid,uid,envid,count,exp) VALUES('$this->openID',$uid,$envsRobId,1,'$exp');");
                        }
                        $this->Db->query("INSERT INTO `envs_robrecord` (openid,envsid,eid) VALUES('$this->openID',$envsRobId,$RobId);");
                        $count = $this->Db->getOne("SELECT COUNT(*) FROM `envs_robrecord` WHERE `eid` = $RobId;");
                        $envsName = $this->Db->getOne("SELECT `name` FROM `client_envelopes_type` WHERE `id` = $envsRobId;");
                        $this->Db->query("UPDATE `envs_robblist` SET `remains` = `remains` - 1 WHERE `id` = '$RobId';");
                        //$this->responseText("恭喜你获得'$envsName'红包一个，<a href='" . Util::getROOT() . "?/Uc/home/'>点击查看</a>，您是第{$count}位抢到红包的朋友，红包还剩{$remains}个。");
						$this->responseText("恭喜你获得 $envsName 红包一个，<a href=''.$host.'?/Uc/home/'>点击查看</a>，您是第{$count}位抢到红包的朋友，红包还剩{$remains}个。");
                    } else {
                        $this->responseText("抱歉~您来迟了，红包被抢完了。");
                    }
                } else {
                    $this->responseText("您已领取过红包，一人限领一份红包哦~");
                }
            }
        }
    }

    /**
     * @param $Content
     */
    private function getAutoRspData($Content){
        return $this->Dao->select()->from(TABLE_AUTO_RESPONSE)->where([
            'key' => $Content
        ])->getOneRow();
    }

}
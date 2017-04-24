<?php

/**
 * 事件消息处理器
 * @description Holp You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class EventHandler extends WechatHandler
{
    /**
     * @param WechatPostObject $postObj
     */
    public function handle(&$postObj) {

        // 你可以在这里编写你要处理的逻辑

        /**
         * 处理二维码扫描事件 关注事件
         * @see http://mp.weixin.qq.com/wiki/14/f79bdec63116f376113937e173652ba2.html#.E6.89.AB.E6.8F.8F.E5.B8.A6.E5.8F.82.E6.95.B0.E4.BA.8C.E7.BB.B4.E7.A0.81.E4.BA.8B.E4.BB.B6
         */
        if ($postObj->Event == "subscribe" || $postObj->Event == "SCAN") {
            $this->doCompanyLink($postObj);
            $this->doAutoEnvs();
            $this->doWelcome();
        }

        if (!empty($postObj->EventKey)) {

            // 自定义按钮点击
            if (stristr($postObj->EventKey, 'K_')) {
                $keyId = str_replace('K_', '', $postObj->EventKey);
                if ($keyId > 0) {
                    $r = $this->Db->getOneRow("SELECT * FROM `wshop_menu` WHERE `id` = '$keyId';");
                    if ($r) {
                        switch ($r['reltype']) {
                            case 0:
                                // 纯文字
                                $this->responseText($r['relcontent']);
                                break;
                            case 1:
                                // 图文
                                $this->echoGmess($r['relid']);
                                break;
                            case 2:
                                // 商品推荐
                                // todo
                        }
                    }
                }
            }

            // 签到按钮点击
            if ($postObj->EventKey == 'SIGN') {
                // uid
                $uid = $this->Db->getOne("SELECT `client_id` FROM `clients` WHERE `client_wechat_openid` = '$this->openID';");
                // 返回积分数额
                $credit = $this->Db->getOne("SELECT `value` FROM `wshop_settings` WHERE `key` = 'sign_credit';");
                // 签到限制天数
                $limitDay = $this->Db->getOne("SELECT `value` FROM `wshop_settings` WHERE `key` = 'sign_daylim';");
                // 查找上一次签到记录
                $lastSign = $this->Db->getOneRow("SELECT DATEDIFF(current_date(), `dt`) AS `d`,`dt` FROM `client_sign_record` WHERE `openid` = '$this->openID' order by `dt` DESC LIMIT 1;", false);
                // 比较
                if ((isset($lastSign['dt']) && $lastSign['d'] >= $limitDay) || $lastSign == false) {//首次签到查询不到记录返回的是false
                    // 尝试插入 签到记录 唯一索引控制
                    $r1 = $this->Db->query("INSERT INTO `client_sign_record` (`dt`,`credit`,`openid`) VALUES (NOW(),$credit,'$this->openID');");
                    // 签到记录
                    if ($r1 !== false) {
                        // 增加积分
                        $this->Db->query("UPDATE `clients` SET client_credit = client_credit + $credit WHERE `client_wechat_openid` = '$this->openID';");
                        // 积分记录
                        $r1 = $this->Db->query("INSERT INTO `client_credit_record` (`dt`,`amount`,`reltype`,`uid`,`relid`,`remark`) VALUES (NOW(),$credit,1,'$uid',0,'每日签到赠送积分'.$credit);");
                        if ($r1) {
                            $this->responseText("签到成功，您获得{$credit}积分。");
                        }
                    }
                } else {
                    $this->responseText("您最近已经签到过了。");
                }
            }
        }

    }

    /**
     * 用户关注公众号发送的消息
     * @throws Exception
     */
    private function doWelcome() {
        // 关注消息
        $welcomeId = $this->Db->getOne("SELECT `value` FROM `wshop_settings` WHERE `key` = 'welcomegmess';");
        if ($welcomeId > 0) {
            $this->echoGmess($welcomeId);
        }
    }

    /**
     * 自动红包
     * @param type $envid
     */
    public function doAutoEnvs() {
        $envid = $this->Db->getOne("SELECT `value` FROM `wshop_settings` WHERE `key` = 'auto_envs';");
        if ($envid > 0) {
            $exp = date('Y-m-d H:i:s', strtotime('+30 day'));
            $uid = $this->Db->getOne("SELECT `client_id` FROM `clients` WHERE `client_wechat_openid` = '$this->openID';");
            $ext = $this->Db->getOne("SELECT openid FROM `client_autoenvs` WHERE `openid` = '$this->openID';");
            if (!$ext) {
                $uid = $uid > 0 ? $uid : 'NULL';
                $this->Db->query("INSERT INTO `client_envelopes` (openid,uid,envid,count,exp) VALUES('$this->openID',$uid,$envid,1,'$exp');");
                $this->Db->query("INSERT INTO `client_autoenvs` (openid,envid) VALUES('$this->openID',$envid);");
                //Messager::sendText(WechatSdk::getServiceAccessToken(), $this->openID, "恭喜你获得红包一个，<a href='" . Util::getROOT() . "?/Uc/envslist/'>点击查看</a>");
				Messager::sendText(WechatSdk::getServiceAccessToken(), $this->openID, "恭喜你获得红包一个，<a href='" . Util::getROOT() . "?/Uc/envslist/'>点击查看</a>");
				// 发送消息
            //Messager::sendText(WechatSdk::getServiceAccessToken(), $openid, "恭喜你获得" . $envsT['name'] . "一个，<a href='$host?/Uc/home/'>点击查看</a>");Util::getHOST()
            }
        }
    }

    /**
     * @param $postObj
     */
    private function doCompanyLink(&$postObj) {

        $qrscene = '';

        // 获取$qrscene，也就是代理id
        if ($postObj->EventKey && preg_match("/qrscene_/is", $postObj->EventKey)) {
            // 情景：二维码扫描并且未关注公众号
            $qrscene = preg_replace("/qrscene_/is", "", $postObj->EventKey);
        } else if ($postObj->Event == "SCAN") {
            // 情景：二维码扫描但是<已关注>公众号
            $qrscene = intval($postObj->EventKey);
        }

        if ($qrscene > 0) {
            // 情景Id有效 判断是否已经关联
            $ext = $this->Dao->select()->from(TABLE_COMPANY_USERS)
                             ->where([
                                 'openid' => $this->openID,
                                 'comid' => $qrscene
                             ])->getOneRow();
            if (!$ext) {
                // 代理用户未加入
                $this->Db->transtart();
                try {
                    // 用户是否已注册
                    $user    = $this->Dao->select()->from(TABLE_USER)->where(['client_wechat_openid' => $this->openID])->getOneRow();
                    $company = $this->Dao->select()->from(TABLE_COMPANYS)->where(['uid' => $qrscene])->getOneRow();
                    if ($user) {
                        $uid = $user['client_id'];
                        // 用户已注册 但是没有关联任何代理
                        if ($user['client_comid'] == 0 && $uid != $company['uid']) {
                            // 更新用户对应代理的编号
                            $this->Dao->update(TABLE_USER)->set(['client_comid' => $qrscene])->where(['client_id' => $uid])->exec();
                            // 执行钩子程序
                            (new HookNewCompanyLinked($this))->deal([
                                'uid' => $uid,
                                'openid' => $this->openID,
                                'companyid' => $company[uid]
                            ]);
                        }
                    } else {
                        $uid = NULL;
                    }
                    // <请注意> 如果扫描的用户没有注册，也就是clients没有对应的用户信息，uid是NULL，用户注册之后，则会更新company_users表的对应字段
                    $this->Dao->insert(TABLE_COMPANY_USERS, 'openid,comid,uid')
                              ->values([$this->openID,
                                        $qrscene,
                                        $uid])->exec();
                    // 提醒代理
                    $openid = $this->Dao->select('openid')->from(TABLE_COMPANYS)->where(['id' => $qrscene])->getOne();
                    // 发送消息
                    Messager::sendText(WechatSdk::getServiceAccessToken(), $openid, date('Y-m-d') . $user['client_name'] . ' 成为您旗下的一员~');
                    // 提交事务
                    $this->Db->transcommit();
                } catch (Exception $ex) {
                    // 回滚事务
                    $this->Db->transrollback();
                    // 出错写入记录
                    Util::log(sprintf("代理关联失败：openid:%s,comid:%s,错误信息:%s", $this->openID, $qrscene, $ex->getMessage()));
                }
            }
        }
    }

}
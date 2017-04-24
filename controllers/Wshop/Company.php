<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 代理中心
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Company extends ControllerShop {

    /**
     * Company constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('mCompany');
    }

    public function home() {
        $this->show('./views/wshop/company/home.tpl');
    }

    public function rank() {
        $this->show('./views/wshop/company/rank.tpl');
    }

    public function agents() {
        $this->show('./views/wshop/company/agents.tpl');
    }

    public function rebate() {
        $this->show('./views/wshop/company/rebate.tpl');
    }

    /**
     * 代理分享二维码
     */
    public function share() {
        $this->loadModel('mCompany');
        $openid      = $this->getOpenId();
        $comId       = $this->mCompany->getCompanyIdByOpenId($openid);
        $stoken      = WechatSdk::getServiceAccessToken();
        $qrcodeImage = WechatSdk::getCQrcodeImage(WechatSdk::getCQrcodeTicket($stoken, $comId));
        $this->assign('qrcode', $qrcodeImage);
        $this->show('./views/wshop/company/share.tpl');
    }

    /**
     * 获取代理列表
     * /?/Company/getCompanyList/
     */
    public function getCompanyList() {
        $uid  = $this->getUid();
        $list = $this->Dao->select("us.*")
            ->from(TABLE_COMPANYS)
            ->alias("company")
            ->leftJoin(TABLE_USER)->alias("us")
            ->on("us.client_id = company.uid AND parent = $uid AND verifed = 1 AND company.deleted = 0")
            ->where("client_id > 0")
            ->orderby("us.client_id")
            ->desc()
            ->exec();
        $this->echoJson($list);
    }

    /**
     * 获取代理客户列表
     * /?/Company/getCustomerList/
     */
    public function getCustomerList() {
        $uid  = $this->getUid();
        $list = $this->Dao->select()->from(TABLE_USER)->where("client_comid = $uid")->orderby("client_id")->desc()->exec();
        $this->echoJson($list);
    }

    /**
     * 代理申请页面
     */
    public function companyRequest() {
        $uid = $this->getUid();
        if ($uid > 0) {
            $this->show('./views/wshop/company/companyrequest.tpl');
        }
    }

    /**
     *直属下级列表
     */
    public function listDirectMember() {
        $uid = $this->getUid();
        if (!$uid) {
            $this->loadModel('User');
            $Openid = $this->getOpenId();
            // 微信自动注册
            $this->User->wechatAutoReg($Openid);
            $uid = $this->getUid();
        }

        if (!$this->isCompany($uid)) {
            $this->assign('bcon', 'company');
            $this->show('wshop/company/listdirectmember.tpl');
        } else {
            $comid      = $this->Dao->select('id')
                ->from('companys')
                ->where("uid=$uid")
                ->getOne();
            $spreadData = $this->Db->getOneRow("select sum(readi) as readi,sum(turned) as turned from company_spread_record WHERE com_id = '$comid';");
            // 名下用户总数
            $spreadData['ucount'] = $this->Db->getOne("SELECT count(*) AS amount FROM `clients` WHERE client_comid = '$comid';");
            $spreadData['ucount'] = $spreadData['ucount'] > 0 ? $spreadData['ucount'] : 0;
            // 名下用户列表
            $spreadData['ulist'] = $this->Dao->select()
                ->from('clients')
                ->where('client_comid=' . $comid)
                ->exec();
            foreach ($spreadData['ulist'] as &$l) {
                $l['od'] = $this->Db->getOne("SELECT COUNT(DISTINCT(order_id)) FROM `company_income_record` WHERE com_id = $comid AND client_id = $l[client_id];");
            }
            $this->assign('stat_data', $spreadData);
            $this->assign('title', '直属下级成员');
            $this->assign('bcon', 'company');
            $this->show('wshop/company/listdirectmember.tpl');
        }
    }

    /**
     *直属下级合伙人列表
     */
    public function listDirectCom() {
        $this->loadModel('User');
        $uid = $this->getUid();
        if (!$uid) {
            $Openid = $this->getOpenId();
            // 微信自动注册
            $this->User->wechatAutoReg($Openid);
            $uid = $this->getUid();
        }
        if (!$this->isCompany($uid)) {

            $this->assign('bcon', 'company');
            $this->show('wshop/company/listdirectcom.tpl');
        } else {
            $comid      = $this->Dao->select('id')
                ->from('companys')
                ->where("uid=$uid")
                ->getOne();
            $spreadData = $this->Db->getOneRow("select sum(readi) as readi,sum(turned) as turned from company_spread_record WHERE com_id = '$comid';");
            // 名下用户总数
            $spreadData['ucount'] = $this->Db->getOne("SELECT count(*) AS amount FROM `clients` WHERE client_comid = '$comid' AND is_com = '1';");
            $spreadData['ucount'] = $spreadData['ucount'] > 0 ? $spreadData['ucount'] : 0;
            // 名下用户列表
            $spreadData['ulist'] = $this->Dao->select()
                ->from('clients')
                ->where("client_comid = $comid AND is_com = 1")
                ->exec();
            foreach ($spreadData['ulist'] as &$l) {
                $r                = $this->Db->getOneRow("SELECT * FROM `companys` WHERE uid = $l[client_id];");
                $l['underucount'] = $this->Db->getOne("SELECT count(*) AS amount FROM `clients` WHERE client_comid = $r[id];");
                $l['name']        = $r['name'];
                $l['jiondate']    = $r['join_date'];
                $l['utype']       = $r['utype'];
            }

            $levels   = $this->Db->query("SELECT uname FROM `company_level`;");
            $typename = array();
            $i        = 0;
            foreach ($levels as &$l) {
                $typename[$i] = $l['uname'];
                $i++;
            }

            $this->assign('com_data', $spreadData);
            $this->assign('typename', $typename);
            $this->assign('title', '直属合伙人');
            $this->assign('bcon', 'company');
            $this->show('wshop/company/listdirectcom.tpl');
        }
    }

    /**
     * 代理申请页面
     */
    public function companyReg() {
        $this->assign('title', '代理申请');
        $this->assign('openid', $this->getOpenId());
        $this->show('./views/wshop/company/companyreg.tpl');
    }

    /**
     * 添加一个com推广记录
     * @deprecated
     */
    public function addComSpread() {
        $productId = intval($this->post('productId'));
        $comId     = $this->post('comId');
        $Uin       = $this->Db->query("SELECT COUNT(`rid`) AS `count` FROM " . COMPANY_SPREAD_RECORD . "WHERE `product_id` = $productId AND `com_id` = '$comId';");
        // 生成记录
        if ($Uin[0]['count'] == 0) {
            $SQL = "REPLACE INTO " . COMPANY_SPREAD_RECORD . " (`product_id`,`com_id`) VALUES ($productId,'$comId');";
            echo $this->Db->query($SQL);
        } else {
            // 已经有记录了
            echo 0;
        }
    }

    /**
     * 添加微代理
     * @param string $name
     * @param string $phone
     * @param string $email
     */
    public function addCompany() {
        $openID = $this->getOpenId();
        $uid    = $this->getUid();
        // 查找是否用重复
        $company = $this->mCompany->getCompanyInfoByUID($uid);
        if (!$company) {
            $this->loadModel('User');
            $uname = Util::strDefault($this->pPost('name'), '');
            $phone = Util::strDefault($this->pPost('phone'), '');
            $email = Util::strDefault($this->pPost('email'), '');
            // 获取上级分组
            $user = $this->User->getUserInfoRaw($uid);
            if ($user) {
                $comid = $this->Dao->insert(TABLE_COMPANYS, "uid,name,phone,email,openid,join_date,parent")->values([
                    $uid,
                    $uname,
                    $phone,
                    $email,
                    $openID,
                    date('Y-m-d H:i:s'),
                    $user['client_comid']
                ])->exec();
                if ($comid > 0) {
                    $this->Session->set('companyid', $comid);
                    $this->echoSuccess();
                } else {
                    $this->echoFail("系统错误");
                }
            }
        } else {
            $this->echoFail("对不起，您的申请待审核中，请勿重复提交");
        }
    }

    /**
     * 判断是否微代理
     */
    private function isCompany($uid) {
        return $this->Db->query("SELECT `id` FROM `companys` WHERE `uid` = '$uid';");
    }

    /**
     * 代理二维码页面
     */
    public function companyQrcode() {
        $this->loadModel('mCompany');
        $openid = $this->getOpenId();
        $comId  = $this->mCompany->getCompanyIdByOpenId($openid);
        if ($comId > 0) {
            $stoken      = WechatSdk::getServiceAccessToken();
            $qrcodeImage = WechatSdk::getCQrcodeImage(WechatSdk::getCQrcodeTicket($stoken, $comId));
            echo $qrcodeImage;
        }
    }

    /**
     * 获取代理二维码
     * @param type $Query
     */
    public function ajaxGetCompanyQrcode($Query) {
        if (is_numeric($Query->id)) {
            $this->loadModel('WechatSdk');
            $this->Smarty->caching = false;
            $id                    = intval($Query->id);
            $stoken                = WechatSdk::getServiceAccessToken();
            $qrcodeImage           = WechatSdk::getCQrcodeImage(WechatSdk::getCQrcodeTicket($stoken, $id));
            $this->Smarty->assign('id', $id);
            $this->Smarty->assign('qrcode', $qrcodeImage);
            $this->show("wdminpage/company/ajax_qrcode.tpl");
        }
    }

    /**
     * 代理资料修改
     * @param type $length
     * @deprecated
     *
     */
    public function companyInfoEdit() {
        $ret = $this->Dao->update(TABLE_COMPANYS)
            ->set(array(
                'phone' => $this->pPost('phone'),
                'name' => $this->pPost('name'),
                'email' => $this->pPost('email'),
                'person_id' => $this->pPost('ids'),
                'bank_name' => $this->pPost('bname'),
                'bank_account' => $this->pPost('bacc'),
                'alipay' => $this->pPost('aliacc')
            ))
            ->where('uid', $this->getUid())
            ->exec();
        echo $ret ? 1 : 0;
    }

    /**
     * 代理结算
     */
    public function payCompanyBills() {
        if (intval($this->pPost('id')) > 0) {
            echo $this->mCompany->payCompanyBills($this->pPost('id'));
        } else {
            echo 0;
        }
    }

    /**
     * 获取代理排行榜数据
     * @example ?/Company/getRankList/
     */
    public function getRankList() {
        $data = $this->Db->query("SELECT
 com.uid,com.name,com.join_date,cls.client_head AS uhead,COALESCE(SUM(od.rebate_amount), 0) as income
FROM
	companys as com
LEFT JOIN order_rebates od on com.uid = od.comid AND od.status = 'pass'
LEFT JOIN clients cls on cls.client_id = com.uid
GROUP BY com.uid
ORDER BY income DESC
LIMIT 15");
        $this->echoJson($data);
    }

    /**
     * 获取返佣数据
     * @example ?/Company/getRebateList/
     */
    public function getRebateList() {
        $uid    = $this->getUid();
        $status = $this->getStr('status', 'all');
        $where  = [];
        if ($status != 'all') {
            $where['status'] = $status;
        }
        $where['comid'] = $uid;
        // 数据列表
        $list = $this->Dao->select("orebate.order_serial, orebate.rebate_amount, orebate.rtime, user.client_head")
            ->from(TABLE_ORDER_REBATE)->alias('orebate')
            ->leftJoin(TABLE_USER)->alias('user')
            ->on("user.client_id = orebate.uid")
            ->where($where)
            ->orderby("id")
            ->desc()
            ->limit(30)
            ->exec();
        // 返佣总数
        $total = $this->Dao->select("SUM(rebate_amount)")->from(TABLE_ORDER_REBATE)->where($where)->getOne();
        // 输出数据
        $this->echoJson([
            'list' => $list,
            'total' => $total
        ]);
    }

}

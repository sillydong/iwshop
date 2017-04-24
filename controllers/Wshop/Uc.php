<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 用户个人中心控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Uc extends ControllerShop {

    const COOKIEXP = 3600;

    /**
     * Uc constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('User');
    }

    /**
     * 登陆页面
     */
    public function login() {
        $this->assign('title', "用户登陆");
        $this->assign('bagRand', intval(rand(1, 3)));
        $this->show("uc/login.tpl");
    }

    /**
     * 注册页面
     */
    public function reg() {
        $this->assign('title', "用户注册");
        $this->show("uc/wechatplease.tpl");
    }

    /**
     * 威海巴厘林海度假村
     */
     public function balilinhai() {
        $this->assign('title', "威海巴厘林海度假村");
        $this->show("uc/balilinhai.tpl");
     }

     public function balilinhai_signin() {
        $this->assign('title', "威海巴厘林海度假村");
        $this->show("uc/balilinhai_signin.tpl");
     }

     public function balilinhai_signup() {
        $this->assign('title', "威海巴厘林海度假村");
        $this->show("uc/balilinhai_signup.tpl");
     }

     public function balilinhai_details() {
        $this->assign('title', "威海巴厘林海度假村");
        $this->show("uc/balilinhai_details.tpl");
     }

    /**
     * user Home
     * 用户中心首页
     */
    public function home() {

        // get openid
        $openID = $this->getOpenId();
        // 微信自动注册
        $this->User->wechatAutoReg($openID);

        $uid = $this->getUid();

        if (!empty($openID)) {

            $company_id = 0;

            $this->Smarty->caching = false;

            $this->loadModel([
                'mOrder',
                'UserLevel',
                'mCompany',
                'Envs'
            ]);

            // 回收过期订单
            $this->mOrder->orderReclycle($uid);

            $userInfo = false;

            if (!$uid) {
                // uid cookie 过期或者未注册
                if (!empty($openID)) {
                    if (!$this->User->checkUserExt($openID)) {
                        // 用户在微信里面 但是居然不存在这个用户
                        $this->redirect($this->root . '?/Uc/wechatPlease');
                    } else {
                        // 获取uid
                        $uid = $this->User->getUidByOpenId($openID);
                    }
                    $userInfo = $this->User->getUserInfoRaw($uid);
                }
            } else {
                // 用户已注册
                $userInfo = $this->User->getUserInfoRaw($uid);
                // 刷新微信头像
                if (time() - strtotime($userInfo['client_head_lastmod']) > 432000 && Controller::inWechat()) {
                    $AccessCode = WechatSdk::getAccessCode($this->uri, "snsapi_userinfo");
                    if ($AccessCode) {
                        // 获取到accesstoken和openid
                        $Result = WechatSdk::getAccessToken($AccessCode);
                        // 微信用户资料
                        $WechatUserInfo = WechatSdk::getUserInfo($Result->access_token, $Result->openid, false);
                        $this->Dao->update(TABLE_USER)
                            ->set([
                                'client_head' => preg_replace("/\\/0/", "", $WechatUserInfo->headimgurl),
                                'client_head_lastmod' => 'NOW()'
                            ])
                            ->where([
                                'client_wechat_openid' => $Result->openid
                            ])
                            ->exec();
                    }
                }
            }

            if (!$userInfo) {
                $this->redirect($this->root . '?/Uc/login');
            }

            // 代理开关
            $companyOn = $this->getSetting('company_on') == 0;

            if (!$this->mCompany->isReqesting($uid)) {
                $company_id = $this->mCompany->getCompanyIdByOpenId($openID);
                $income     = $this->mCompany->getCompanyIncomeCount($company_id, false, false);
                $this->assign('income', $income);
            } else {
                // 是否正在审核中
                $companyOn = false;
            }

            // 代理编号
            $this->assign('comid', $company_id);
            // 用户等级数据
            $this->assign('level', $this->UserLevel->getLevByUid($uid));
            // 红包数量
            $this->assign('count_envs', $this->Envs->getCount($uid));
            // 收藏数量
            $this->assign('count_like', $this->getProductLikeCount($openID));
            // 其他统计数据
            $this->assign('count', $this->getUcenterStat($openID));
            // 随机背景图计数
            $this->assign('bagRand', intval(rand(1, 3)));
            // 用户信息
            $this->assign('userinfo', $userInfo);
            // 是否开启代理
            $this->assign('companyOn', $companyOn);
            // 广告图数据
            $this->assign('ucBanners', $this->Banners->getBanners(2));
            // 名下客户数量
            $this->assign('customer_count', $this->mCompany->getCustomerCount($company_id));
            // 名下代理数量
            $this->assign('company_count', $this->mCompany->getCompanyCount($company_id));

            $this->show("wshop/ucenter/home.tpl");

        } else {
            $this->assign('title', "用户登陆");
            $this->assign('bagRand', intval(rand(1, 3)));
            $this->show("wshop/ucenter/wechatplease.tpl");
        }
    }

    /**
     * 请使用微信访问页面
     */
    public function wechatPlease() {
        $this->show();
    }

    /**
     * 我的零钱
     */
    public function balance() {
        // 获取用户余额
        $openID  = $this->getOpenId();
        $balance = round($this->User->getBalance($openID), 2);
        $this->assign('balance', $balance);
        $this->show("wshop/ucenter/balance.tpl");
    }

    /**
     * 我的零钱 提现
     */
    public function withdrawal() {
        // 获取用户余额
        $openID  = $this->getOpenId();
        $balance = round($this->User->getBalance($openID), 2);
        $this->assign('balance', $balance);
        $this->show("wshop/ucenter/withdrawal.tpl");
    }

    /**
     * 充值
     */
    public function deposit() {
        $this->loadModel('JsSdk', 'WechatSdk');
        $signPackage = $this->JsSdk->GetSignPackage();
        $this->assign('signPackage', $signPackage);
        $this->show("wshop/ucenter/deposit.tpl");
    }

    /**
     * 我的红包列表
     */
    public function envslist() {
        $this->loadModel('Envs');
        $openID = $this->getOpenId();
        // 微信注册
        $this->User->wechatAutoReg($openID);
        $envs = $this->Envs->getUserEnvs($this->getUid());
        $this->assign('envs', $envs);
        $this->assign('title', '我的红包');
        $this->show();
    }

    /**
     * 代理个人中心
     */
    public function companySpread() {
        // 统计数据
        $uid = $this->pCookie('uid');
        $this->loadModel('User');
        # $userInfo = $this->User->getUserInfo();
        if (!$this->isCompany($uid)) {
            header('Location:' . $this->root . '?/WechatWeb/proxy/');
        } else {

//            $comRow   = $this->Dao->select()
//                                  ->from('companys')
//                                  ->where("uid=$uid")
//                                  ->getOneRow();
            //从代理等级表获取佣金率 add by zmq2163
            $comRow  = $this->Db->getOneRow("select c.id as id,c.utype as utype,cl.return_percent as return_percent from companys c LEFT JOIN company_level cl on c.utype = cl.utype where c.uid = $uid ");
            $comid   = $comRow['id'];
            $comR    = $comRow['return_percent']; //返佣率
            $comtype = $comRow['utype'];          //代理等级
            //代理等级表 add by zmq2163
            $levels  = $this->Db->query("SELECT uname FROM `company_level`;");
            $typenum = array();
            $i       = 0;
            foreach ($levels as &$l) {
                $typenum[$i] = $l['uname'];
                $i++;
            }

            $this->assign("comR", $comR);
            $this->assign("comtype", $comtype);
            $this->assign("typenum", $typenum);

            // 这是什么
            $isset = '';

            $userInfo = $this->User->getUserInfoRaw();
            $this->assign("userinfo", $userInfo);
            $spreadData = $this->Db->getOneRow("select sum(readi) as readi,sum(turned) as turned from company_spread_record WHERE com_id = '$comid';");
            // 转化率
            $spreadData['turnrate'] = sprintf('%.2f', $spreadData['readi'] > 0 ? ($spreadData['turned'] / $spreadData['readi']) : 0);
            // 总收益
            $spreadData['incometot'] = $this->Db->getOne("SELECT sum(amount) AS amount FROM `company_income_record` WHERE com_id = '$comid';");
            $spreadData['incometot'] = $spreadData['incometot'] > 0 ? $spreadData['incometot'] : 0;
            // 今日收益
            $spreadData['incometod'] = $this->Db->getOne("SELECT sum(amount) AS amount FROM `company_income_record` WHERE com_id = '$comid' AND to_days(date) = to_days(now());");
            $spreadData['incometod'] = $spreadData['incometod'] > 0 ? $spreadData['incometod'] : 0;
            // 昨日收益
            $spreadData['incometotyet'] = $this->Db->getOne("SELECT sum(amount) AS amount FROM `company_income_record` WHERE com_id = '$comid' AND to_days(date) = to_days(now()) - 1;");
            $spreadData['incometotyet'] = $spreadData['incometotyet'] > 0 ? $spreadData['incometotyet'] : 0;
            // 本月收益
            $spreadData['incometotmonth'] = $this->Db->getOne("SELECT SUM(amount) AS amount FROM `company_income_record` WHERE $isset `com_id` = $comid AND DATE_FORMAT(`date`,'%Y-%m') = '" . date("Y-m") . "';");
            $spreadData['incometotmonth'] = $spreadData['incometotmonth'] > 0 ? $spreadData['incometotmonth'] : 0;
            // 已结算收益 2016年1月3日 16:37:24
            $spreadData['incometotsetted'] = $this->Db->getOne("SELECT SUM(amount) AS amount FROM `company_income_record` WHERE `is_seted` = 1 AND `com_id` = $comid;");
            $spreadData['incometotsetted'] = $spreadData['incometotsetted'] > 0 ? $spreadData['incometotsetted'] : 0;
            // 未结算收益  2016年1月3日 16:23:01
            $spreadData['incometotunset'] = $this->Db->getOne("SELECT SUM(amount) AS amount FROM `company_income_record` WHERE `is_seted` = 0 AND `com_id` = $comid;");
            $spreadData['incometotunset'] = $spreadData['incometotunset'] > 0 ? $spreadData['incometotunset'] : 0;

            // 名下用户总数
            $spreadData['ucount'] = $this->Db->getOne("SELECT count(*) AS amount FROM `company_users` WHERE comid = '$comid';");
            $spreadData['ucount'] = $spreadData['ucount'] > 0 ? $spreadData['ucount'] : 0;
            // 直属下级代理数量统计
            $spreadData['comcount'] = $this->Db->getOne("SELECT count(*) AS amount FROM `clients` WHERE client_comid = '$comid' AND is_com = '1';");
            $spreadData['comcount'] = $spreadData['comcount'] > 0 ? $spreadData['comcount'] : 0;

            $this->assign('stat_data', $spreadData);
            $this->assign('title', '我的推广');
            $this->show();
        }
    }

    /**
     * 代理资料修改
     */
    public function companyEdit() {
        $uid = $this->pCookie('uid');
        $this->loadModel('mCompany');
        if (!$this->isCompany($uid)) {
            header('Location:' . $this->root . '?/WechatWeb/proxy/');
        } else {
            $this->loadModel('mCompany');
            $cominfo = $this->Dao->select('*')
                ->from('companys')
                ->where("uid=$uid")
                ->getOneRow();
            $this->assign('cominfo', $cominfo);
            $this->show();
        }
    }

    /**
     * 订单列表
     * @param type $Query
     */
    public function orderlist($Query) {
        $this->loadModel('JsSdk', 'WechatSdk');
        $this->Smarty->caching = false;
        $signPackage           = $this->JsSdk->GetSignPackage();
        $openID                = $this->getOpenId();
        !isset($Query->status) && $Query->status = '';
        $this->assign('signPackage', $signPackage);
        $this->assign('status', $Query->status);
        $this->assign('title', '我的订单');
        $this->show();
    }

    /**
     * Ajax订单列表
     * @param type
     */
    public function ajaxOrderlist($Query) {

        $this->Db->cache       = false;
        $this->Smarty->caching = false;
        $openID                = $this->getOpenId();

        if (empty($openID)) {
            die(0);
        } else {
            !isset($Query->page) && $Query->page = 0;
            $limit = (5 * $Query->page) . ",5";

            if (!$this->isCached()) {
                global $config;
                $this->loadModel('Product');
                if ($Query->status == '' || !$Query->status) {
                    $SQL = "SELECT * FROM `orders` WHERE `wepay_openid` = '$openID' ORDER BY `order_time` DESC LIMIT $limit;";
                } else {
                    if ($Query->status == 'canceled') {
                        $SQL = "SELECT * FROM `orders` WHERE `wepay_openid` = '$openID' AND `status` = '$Query->status' AND `wepay_serial` <> '' ORDER BY `order_time` DESC LIMIT $limit;";
                    } else if ($Query->status == 'received') {
                        // 待评价订单列表
                        $SQL = "SELECT * FROM `orders` WHERE `wepay_openid` = '$openID' AND `status` = '$Query->status' AND `is_commented` = 0 ORDER BY `order_time` DESC LIMIT $limit;";
                    } else {
                        // 其他普通列表
                        $SQL = "SELECT * FROM `orders` WHERE `wepay_openid` = '$openID' AND `status` = '$Query->status' ORDER BY `order_time` DESC LIMIT $limit;";
                    }
                }
                $orders = $this->Db->query($SQL, false);
                foreach ($orders AS &$_order) {
                    // 是否为代付
                    $_order['isreq']      = false;
                    $_order['statusX']    = $config->orderStatus[$_order['status']];
                    $_order['order_time'] = $this->Util->dateTimeFormat($_order['order_time']);
                    $_order['data']       = $this->Db->query("SELECT catimg,`pi`.product_name,`pi`.product_id,`sd`.product_count,`sd`.product_discount_price,`sd`.product_price_hash_id " . "FROM `orders_detail` sd LEFT JOIN `products_info` pi on pi.product_id = sd.product_id WHERE `sd`.order_id = " . $_order['order_id']);
                    // 整理商品数据
                    foreach ($_order['data'] as &$data) {
                        $d             = $this->Product->getProductInfoWithSpec($data['product_id'], $data['product_price_hash_id']);
                        $data['spec1'] = $d['det_name1'];
                        $data['spec2'] = $d['det_name2'];
                    }
                }
                $this->assign('orders', $orders);
            }
        }
        $this->show();
    }

    /**
     * 查看订单详情
     * @param type $orderid
     */
    public function viewOrder() {
        $this->show();
    }

    /**
     * 判断是否微代理
     */
    private function isCompany($uid) {
        return $this->Db->query("SELECT `id` FROM `companys` WHERE `uid` = '$uid';");
    }

    /**
     * 我的收藏页面
     */
    public function uc_likes() {
        $this->assign('title', '我的收藏');
        $this->show("wshop/ucenter/product_likes.tpl");
    }

    /**
     * 获取收藏列表
     * @param type $Query
     */
    public function ajaxLikeList($Query) {
        $openID        = $this->getOpenId();
        $this->cacheId = $openID . $Query->page;
        if (!$this->isCached()) {
            !isset($Query->page) && $Query->page = 0;
            $limit = ($Query->page * 10) . ',10';
            $this->loadModel('User');
            $likeList = $this->User->getUserLikes($openID, $limit);
            if ($likeList !== false) {
                $this->assign('loaded', count($likeList));
                $this->assign('likeList', $likeList);
            } else {
                $this->assign('loaded', 0);
            }
        }
        $this->show();
    }

    /**
     * ajax获取用户分组
     */
    public function getAllGroup() {
        $this->loadModel('SqlCached');
        // file cached
        $cacheKey  = 'ucajaxGetCategroys';
        $fileCache = new SqlCached();
        $ret       = $fileCache->get($cacheKey);
        if (-1 === $ret) {
            $this->loadModel('UserLevel');
            $lev    = $this->UserLevel->getList();
            $levs   = array();
            $levs[] = array('dataId' => 0, 'name' => '全部用户');
            foreach ($lev as $l) {
                $levs[] = array('dataId' => $l['id'], 'name' => $l['level_name']);
            }
            $cats = $this->toJson($levs);
            $fileCache->set($cacheKey, $cats);
            echo $cats;
        } else {
            echo $ret;
        }
    }

    /**
     * 查看物流情况
     */
    public function expressDetail($Query) {

        global $config;

        $openID = $this->getOpenId();

        $this->loadModel('mOrder');

        $this->cacheId = $openID . $Query->order_id;

        if (!$this->isCached()) {

            // 通知人员openid
            $openIDs = explode(',', $this->getSetting('order_notify_openid'));
            // 配送人员openid
            $openIDExps = explode(',', $this->getSetting('order_express_openid'));
            // 允许查看订单
            $openIDs = array_merge($openIDExps, $openIDs);

            $Query->order_id = addslashes($Query->order_id);

            // 订单信息
            $orderData = $this->Db->getOneRow("SELECT * FROM `orders` WHERE `order_id` = $Query->order_id;");

            $openIDs[] = $orderData['wepay_openid'];

            if (!in_array($openID, $openIDs) || empty($openID)) {
                echo 0;
            } else {
                $this->loadModel('Product');
                $orderProductsList         = $this->Db->query("SELECT `catimg`,`pi`.product_name,`pi`.product_id,`sd`.product_count,`sd`.product_discount_price,`sd`.product_price_hash_id FROM `orders_detail` sd LEFT JOIN `products_info` pi on pi.product_id = sd.product_id WHERE `sd`.order_id = " . $Query->order_id);
                $expressCode               = include APP_PATH . 'config/express_code.php';
                $orderData['address']      = $this->Db->getOneRow("SELECT * FROM `orders_address` WHERE `order_id` = $Query->order_id;");
                $orderData['express_com1'] = $expressCode[$orderData['express_com']];
                $orderData['statusX']      = $config->orderStatus[$orderData['status']];
                foreach ($orderProductsList as &$pds) {
                    $d            = $this->Product->getProductInfoWithSpec($pds['product_id'], $pds['product_price_hash_id']);
                    $pds['spec1'] = $d['det_name1'];
                    $pds['spec2'] = $d['det_name2'];
                }
                $this->assign('orderdetail', $orderData);
                $this->assign('productlist', $orderProductsList);
                $this->assign('title', '订单详情');
            }
        }

        $this->show("wshop/ucenter/expressdetail.tpl");
    }

    /**
     * 积分兑换页面
     */
    public function credit_exchange() {
        $this->loadModel('CreditExchange');
        $list = $this->CreditExchange->getList(false);
        $this->assign('list', $list);
        $this->assign('title', '积分兑换');
        $this->show();
    }

    /**
     * 积分兑换详情选择地址页面
     */
    public function credit_exchange_detail($Query) {
        $this->loadModel('WechatSdk');
        $this->loadModel('JsSdk');
        $pid    = $Query->pid;
        $credit = $Query->credit;

        if ($pid > 0) {
            $this->loadModel('Product');
            $product = $this->Product->getProductInfo($pid, true);
        }

        if (Controller::inWechat()) {
            // 请求收货地址参数数据
            include_once(APP_PATH . "lib/wepaySdk/SignTool.php");
            $OauthURL = $this->root . '?/Uc/credit_exchange_detail/pid=' . $pid . '&credit=' . $credit;;
            $FinalURL        = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://" . $this->server('HTTP_HOST') . $this->server('REQUEST_URI');
            $addrsignPackage = WechatSdk::getAddrShareSign($OauthURL, $FinalURL);
            $this->assign('addrsignPackage', $this->toJson($addrsignPackage));
        } else {
            $this->assign('addrsignPackage', '{}');
        }

        $this->assign('title', '积分兑换');
        $this->assign('credit', $credit);
        $this->assign('pid', $pid);
        $this->assign('product', $product);

        $this->show();
    }

    /**
     * 检查是否可以兑换某产品
     */
    public function credit_exchange_check() {
        $openID = $this->getOpenId();
        $pid    = $this->getPostInt('pid');
        $uid    = $this->getUid();
        if ($uid > 0 && $this->User->checkUserExt($openID)) {
            $this->loadModel('CreditExchange');
            $creditReq = $this->CreditExchange->getReq($pid);
            $credit    = $this->User->getCredit($uid);
            if ($credit > 0 && $credit >= $creditReq) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1);
            }
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * 确定兑换某产品
     */
    public function credit_exchange_confirm() {
        $openID   = $this->getOpenId();
        $pid      = $this->getPostInt('pid');
        $addrData = $this->pPost('addrData');
        if (empty($addrData)) {
            return $this->echoMsg(-1, '地址数据非法');
        }

        $uid = $this->getUid();
        if ($uid > 0 && $this->User->checkUserExt($openID)) {
            $this->loadModel([
                'CreditExchange',
                'User',
                'mOrder'
            ]);
            $creditReq = $this->CreditExchange->getReq($pid);
            $credit    = $this->User->getCredit($uid);
            $newcredit = $credit - $creditReq;
            if ($newcredit >= 0) {

                $this->Db->transtart();

                try {

                    // 获取最近的收货地址
                    $this->mOrder->create($openID, array([
                                                             'pid' => $pid,
                                                             'spid' => 0,
                                                             'count' => 1
                                                         ]), $addrData, [
                        'status' => 'payed',
                        'remark' => '积分兑换商品-' . $creditReq
                    ]);

                    $this->User->setCredit($uid, $newcredit, '积分兑换商品-' . $creditReq);

                    $this->Db->transcommit();

                    $this->echoSuccess();

                } catch (Exception $e) {

                    $this->Db->transrollback();

                    $this->echoFail();

                }
            } else {
                $this->echoMsg(-1);
            }
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * 创建充值订单
     * /?/Uc/createDepositOrder/
     * @param float $amount 入金金额
     */
    public function createDepositOrder() {
        $openID         = $this->getOpenId();
        $amount         = $this->getPostFloat('amount');
        $amount         = doubleval($amount);
        $deposit_serial = $this->Util->createDepositSerial();
        if (!empty($openID) && $amount > 0) {
            $orderId = $this->Dao->insert(TABLE_DEPOSIT_ORDER, [
                'openid', 'amount', 'deposit_serial'
            ])->values([
                $openID, $amount, $deposit_serial
            ])->exec();
            if ($orderId > 0) {
                $this->echoSuccess($deposit_serial);
            } else {
                $this->echoMsg(-1, '充值订单无法创建');
            }
        } else {
            $this->echoMsg(-1, '充值金额不合法');
        }
    }

    /**
     * 获取个人中心统计数据
     * @param $openID
     */
    private function getUcenterStat($openID) {
        // 统计数据
        $count   = array();
        $count[] = $this->Db->getOne("SELECT COUNT(`order_id`) AS `count` FROM `orders` WHERE `status` = 'unpay' AND `wepay_openid` = '$openID';");
        $count[] = $this->Db->getOne("SELECT COUNT(`order_id`) AS `count` FROM `orders` WHERE `status` = 'payed' AND `wepay_openid` = '$openID';");
        $count[] = $this->Db->getOne("SELECT COUNT(`order_id`) AS `count` FROM `orders` WHERE `status` = 'delivering' AND `wepay_openid` = '$openID';");
        $count[] = $this->Db->getOne("SELECT COUNT(`order_id`) AS `count` FROM `orders` WHERE `status` = 'received' AND is_commented = 0 AND `wepay_openid` = '$openID';");
        $count[] = $this->Db->getOne("SELECT COUNT(`order_id`) AS `count` FROM `orders` WHERE `status` = 'canceled' AND `wepay_serial` <> '' AND `wepay_openid` = '$openID';");
        return $count;
    }

    /**
     * 获取收藏商品计数
     * @param $openID
     * @return int
     */
    private function getProductLikeCount($openID) {
        return intval($this->Dao->select("COUNT(1)")->from(TABLE_PRODUCT_LIKES)->where("`openid` = '$openID'")->getOne());
    }

    /**
     * 提交提现申请
     * @param $username
     * @param $bankname
     * @param $city
     * @param $dist
     * @param $phone
     * @param $subbranch
     * @param $cardno
     * @param $amount
     * @example /?/Uc/submitWithdrawal
     */
    public function submitWithdrawal() {

        $username  = $this->getPostStr('username');
        $bankname  = $this->getPostStr('bankname');
        $city      = $this->getPostStr('city');
        $dist      = $this->getPostStr('dist');
        $phone     = $this->getPostStr('phone');
        $subbranch = $this->getPostStr('subbranch');
        $cardno    = $this->getPostStr('cardno');
        $amount    = $this->getPostFloat('amount');
        $openID    = $this->getOpenId();
        $uid       = $this->getUid();

        $this->loadModel('User');

        // 判断是否有审核中的订单
        $ext = $this->Dao->select('1')->from(TABLE_WITHDRAWAL_ORDER)->where("uid = $uid AND status = 'wait'")->getOneRow();

        if ($ext) {
            return $this->echoFail('提交失败，您还有一个审核申请未处理');
        }

        $serial = $this->Util->createDepositSerial();

        if ($amount > 0 && !empty($bankname) && !empty($cardno) && !empty($openID) && $uid > 0) {
            // 获取用户余额
            $balance = $this->User->getBalance($openID);
            // 判断
            if ($balance > 0 && $balance >= $amount) {
                // 写入审核单
                $result = $this->Dao->insert(TABLE_WITHDRAWAL_ORDER, [
                    'uid', 'openid', 'amount', 'username', 'phone', 'bankname', 'subbranch', 'city', 'dist', 'cardno', 'serial'
                ])->values([
                    $uid, $openID, $amount, $username, $phone, $bankname, $subbranch, $city, $dist, $cardno, $serial
                ])->exec();
                if ($result) {
                    $this->echoSuccess();
                } else {
                    // 写入日志
                    Util::log("提现申请失败" . json_encode($_REQUEST, JSON_UNESCAPED_UNICODE));
                    $this->echoFail('提交失败，系统错误');
                }
            } else {
                $this->echoFail('提交失败，用户余额不足');
            }

        } else {
            $this->echoFail('提交失败，参数有误');
        }

    }

}

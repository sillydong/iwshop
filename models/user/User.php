<?php

/**
 * 用户管理模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class User extends Model
{

    const MANT_BALANCE_ADD = '+';
    const MANT_BALANCE_DIS = '-';

    /**
     * 删除用户
     * @param type $userId
     */
    public function deleteUser($userId)
    {
    }

    /**
     * 修改用户信息
     * @param type $userId
     * @param type $modifyData
     */
    public function modifyUser($userId, $modifyData = array())
    {
    }

    /**
     * 创建用户
     * @param type $userData
     */
    public function createUser($userData = array())
    {

        if (!isset($userData['client_joindate'])) {
            $userData['client_joindate'] = 'NOW()';
        }

        if (!isset($userData['client_head_lastmod'])) {
            $userData['client_head_lastmod'] = 'NOW()';
        }

        return $this->Dao->insert(TABLE_USER, array_keys($userData))
            ->values(array_values($userData))
            ->exec();
    }

    /**
     * 微信性别转换
     * @param type $sexInt
     * @return string
     */
    private function wechatSexConv($sexInt)
    {
        $sex_arr = array(
            'NULL',
            "m",
            "f",
        );

        return $sex_arr[($sexInt ? $sexInt : 0)];
    }

    /**
     * 获取用户信息
     * @param type $openId
     * @return type
     */
    public function getUserInfoByOpenId($openId = false)
    {
        if (!$openId) {
            $openId = $this->Session->getOpenID();
        }
        if (!empty($openId)) {
            return $this->Db->getOneRow("SELECT `client_wechat_openid` AS openid,`client_name`,`client_head`,`client_groupid`, `client_comid` FROM `clients` WHERE `client_wechat_openid` = '$openId';");
        } else {
            return [];
        }
    }

    /**
     *
     * @param type $uid
     * @return <object>
     */
    public function getUserInfoRaw($uid = false, $cache = true)
    {
        if (!$uid) {
            $uid = $this->Session->getUID();
        }
        if (!is_numeric($uid)) {
            $userInfosq = $this->Db->getOneRow("SELECT * from clients WHERE client_wechat_openid = '$uid';", $cache);
        } else {
            $userInfosq = $this->Db->getOneRow("SELECT * from clients WHERE client_id = $uid;", $cache);
        }

        return $userInfosq;
    }

    /**
     * 获取用户所有信息
     * @param type $uid
     * @return <object>
     * @deprecated
     */
    public function getUserInfoFull($uid)
    {
        $SQL
            = "SELECT
                cl.*, cl.client_id AS cid,
                cus.`name` AS `company_name`,
                (
                        SELECT
                                count(*)
                        FROM
                                `orders`
                        WHERE
                                client_id = cl.client_id
                ) AS `order_count`
        FROM
                `clients` cl
        LEFT JOIN `companys` cus ON cus.id = cl.client_comid
        WHERE
                cl.client_id = $uid;";
        $userInfosq = $this->Db->getOneRow($SQL);

        return $userInfosq;
    }

    /**
     * 获取用户积分
     * @param int $uid
     * @return boolean
     */
    public function getCredit($uid, $cache = false)
    {
        if ($uid > 0) {
            return $this->Dao->select('client_credit')
                ->from(TABLE_USER)
                ->where("client_id = $uid")
                ->getOne($cache);
        } else {
            return false;
        }
    }

    /**
     * 设置用户积分
     * @param int $uid 用户UID
     * @param int $credit 设置的积分数额
     * @return boolean
     */
    public function setCredit($uid, $credit, $remark = '开卡赠送积分')
    {
        $this->loadModel('UserCredit');
        if ($uid > 0 && $credit > 0) {
            $oldCredit = $this->getCredit($uid, false);
            $diff = $credit - $oldCredit;
            $result = $this->Dao->update(TABLE_USER)
                ->set(array('client_credit' => $credit))
                ->where("client_id = $uid")
                ->exec();
            if ($result) {
                // success
                $this->UserCredit->record($uid, $diff, 0, 0, $remark);

                return true;
            } else {
                $this->log("积分操作失败: " . $this->Db->getErrorInfo());

                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 对用户增加积分
     * @param $uid
     * @param $credit
     * @param $relid
     * @param $reltype
     */
    public function addCredit($uid, $credit, $relid = 0, $reltype = 0)
    {
        $this->loadModel('UserCredit');
        if ($uid > 0 && $credit > 0) {
            $this->Db->transtart();
            try {
                $this->UserCredit->add($uid, $credit);
                $this->UserCredit->record($uid, $credit, $reltype, $relid, '订单赠送积分' . $credit);
                $this->Db->transcommit();

                return true;
            } catch (Exception $ex) {
                $this->Db->transrollback();
                Util::log("积分操作失败: " . $ex->getMessage());

                return false;
            }
        } else {
            return false;
        }
    }
 /**
     * 对用户充值积分
     * @param $uid
     * @param $credit
     * @param $relid
     * @param $reltype
     */
    public function CaddCredit($uid, $credit, $relid = 0, $reltype = 0)
    {
        $this->loadModel('UserCredit');
        if ($uid > 0 && $credit > 0) {
            $this->Db->transtart();
            try {
                $this->UserCredit->add($uid, $credit);
                $this->UserCredit->record($uid, $credit, $reltype, $relid, '订单赠送积分' . $credit);
                $this->Db->transcommit();

                return true;
            } catch (Exception $ex) {
                $this->Db->transrollback();
                Util::log("积分操作失败: " . $ex->getMessage());

                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 获取用户信息
     * @param type $uid
     * @return <object>
     */
    public function getUserInfo($uid = false)
    {
        if (!$uid) {
            $uid = $this->getUID();
        }
        $userInfo = $this->Dao
            ->select("cs.client_address,cs.client_level,cs.client_id,cs.client_head,cs.client_wechat_openid,cs.client_name,cs.client_money")
            ->from(TABLE_USER)->alias('cs')
            ->where("cs.client_id = $uid;")
            ->getOneRow();
        if ($userInfo) {
            $info = new stdClass();
            $info->uid = intval($userInfo['client_id']);
            $info->uhead = $userInfo['client_head'] == '' ? $this->root . 'static/images/login/profle_1.png' : $userInfo['client_head'] . '/132';
            $info->nickname = $userInfo['client_name'];
            $info->address = $userInfo['client_address'];
            $info->balance = floatval($userInfo['client_money']);
            $info->type = intval($userInfo['client_level']);

            return $info;
        } else {
            return false;
        }
    }

    /**
     * 获取用户邮箱
     * @param type $uid
     * @return boolean
     */
    public function getUserEmail($uid, $cache = true)
    {
        if (is_numeric($uid)) {
            return $this->Dao->select("client_email")->from(TABLE_USER)->where("client_id = $uid")->getOne($cache);
        }

        return false;
    }

    /**
     * 用户余额操作
     * @param float $amount 金额
     * @param int $uid 用户编号
     * @param const $type 操作类型
     */
    public function mantUserBalance($amount, $uid, $rtype, $type = self::MANT_BALANCE_ADD)
    {
        $uid = intval($uid);
        $amount = floatval($amount);
        if ($uid > 0 && $amount > 0) {
            // 更新用户余额
            $result = $this->Dao->update(TABLE_USER)->set([
                'client_money' => "client_money $type $amount",
            ], true)->where("client_id = $uid")->exec();
            if ($result) {
                if ($type === self::MANT_BALANCE_DIS) {
                    $amount = (-1) * $amount;
                }
                // 写入用户余额记录
                $remark = '';
                switch ($rtype) {
                    case 'rebate':
                        $remark = "返佣: " . $amount;
                        break;
                    case 'deposit':
                        $remark = '预存: ' . $amount;
                        break;
                    case 'withdrawal':
                        $remark = '提现: ' . $amount;
                        break;
                    case 'default':
                        $remark = '余额支付: ' . $amount;
                        break;
                }

                return $this->Dao->insert('client_balance_records', ['uid', 'amount', 'remark', 'rtype', 'rtime'])->values([$uid, $amount, $remark, $rtype, time()])->exec();
            } else {
                Util::log("余额操作失败" . $this->Dao->getSql());

                return false;
            }
        }

        return false;
    }

    /**
     * 检查用户是否已经注册
     * @param type $openid
     */
    public function checkUserExt($openid)
    {
        $openid = addslashes(trim($openid));
        $ret = $this->Db->query("SELECT COUNT(*) AS count FROM `clients` WHERE `client_wechat_openid` = '$openid';");

        return $ret[0]['count'] > 0;
    }

    /**
     *
     * @global type $config
     * @param type $uid
     * @return type
     */
    public function genUcToken($uid)
    {
        global $config;
        $this->loadModel('Secure');

        return hash('sha1', $this->getIp() . hash('md4', $uid) . date("Y-m") . $config->wshop_salt);
    }

    /**
     *
     * @param type $account
     * @param type $password
     * @return boolean
     */
    public function userLogin($account, $password)
    {
        $password = $this->genUserPassword($password);
        $ret = $this->Db->getOneRow("SELECT `client_id` FROM `clients` WHERE (`client_email`= '$account' OR `client_phone` = '$account') AND `client_password` = '$password';");
        if ($ret !== false && isset($ret['client_id']) && is_numeric($ret['client_id'])) {
            return intval($ret['client_id']);
        } else {
            return false;
        }
    }

    /**
     * 生成用户密码
     * @global type $config
     * @param type $password
     * @return type
     */
    public function genUserPassword($password)
    {
        global $config;

        return hash('sha256', hash('md4', $password) . $config->wshop_salt . 'pwxd');
    }

    /**
     * 检查用户存在
     * @param type $field
     * @param type $val
     */
    public function userCheckExt($field, $val)
    {
        $ret = $this->Db->getOneRow("SELECT COUNT(*) AS count FROM `clients` WHERE `$field` = '$val' AND `client_wechat_openid` <> '';");
        if ($ret['count'] > 0) {
            return true;
        }

        return false;
    }

    /**
     * 检查用户是否存在
     * @param type $openid
     * @return boolean
     */
    public function userCheckReg($openid)
    {
        if (empty($openid)) {
            return false;
        } else {
            $c = $this->Dao->select('')
                ->count('*')
                ->from(TABLE_USER)
                ->where("client_wechat_openid = '$openid'")
                ->getOne();

            return $c > 0;
        }
    }

    /**
     * 获取用户收藏信息
     * @param type $openid
     * @param type $limit
     * @return boolean
     */
    public function getUserLikes($openid, $limit)
    {
        if ($openid != '') {
            return $this->Db->query("SELECT po.*,pos.sale_prices FROM `client_product_likes` cpl LEFT JOIN `products_info` po ON po.product_id = cpl.product_id LEFT JOIN `product_onsale` pos ON pos.product_id = cpl.product_id WHERE cpl.openid = '$openid' LIMIT $limit;");
        } else {
            return false;
        }
    }

    /**
     * 添加用户收藏
     * @param type $openid
     * @param type $productId
     * @return type
     */
    public function addUserLike($openid, $productId)
    {
        return $this->Db->query("INSERT INTO `client_product_likes` (`openid`,`product_id`) VALUES ('$openid','$productId');");
    }

    /**
     * 删除用户收藏
     * @param type $openid
     * @param type $productId
     * @return type
     */
    public function deleteUserLike($openid, $productId)
    {
        return $this->Db->query("DELETE FROM `client_product_likes` WHERE `openid` = '$openid' AND `product_id` = $productId;");
    }

    /**
     * 获取用户 uid by openid
     * @param string $openid
     * @return int
     */
    public function getUidByOpenId($openid)
    {
        return intval($this->Db->getOne("SELECT `client_id` FROM `clients` WHERE `client_wechat_openid` = '$openid';"));
    }

    /**
     * 获取用户 openid by uid
     * @param type $uid
     * @return type
     */
    public function getOpenIdByUid($uid)
    {
        return $this->Dao->select("client_wechat_openid")->from(TABLE_USER)->where("client_id = " . intval($uid))->getOne();
    }

    /**
     * 获取用户列表
     * @param type $gid
     * @param type $limit
     * @return type
     */
    public function getUserList($gid = '', $limit = 1000)
    {
        if ($gid != '') {
            $Ext = " AND `client_level` = $gid";
        } else {
            $Ext = '';
        }
        if ($this->pCookie('comid')) {
            $comid = $this->Util->digDecrypt($this->pCookie('comid'));
            $SQL
                = "SELECT
                    cl.*,cl.client_id AS cid,
                    (
                            SELECT
                                    count(*)
                            FROM
                                    `orders`
                            WHERE
                                    client_id = cl.client_id AND `orders`.status <> 'unpay'
                    ) AS `order_count`
                    FROM
                            company_users cu
                    LEFT JOIN clients cl ON cl.client_id = cu.uid
                    WHERE
                            cu.comid = $comid AND cl.deleted = 0 LIMIT $limit;";
        } else {
            $SQL
                = "SELECT
                            cl.*, cl.client_id AS cid,
                            cus.`name` AS `company_name`,
                            (
                                    SELECT
                                            count(*)
                                    FROM
                                            `orders`
                                    WHERE
                                            client_id = cl.client_id AND `orders`.status <> 'unpay'
                            ) AS `order_count`,cvs.level_name as `levelname`
                    FROM
                            `clients` cl
                    LEFT JOIN `companys` cus ON cus.id = cl.client_comid
                    LEFT JOIN `client_level` cvs ON cl.client_level = cvs.id
                    WHERE
                            cl.deleted = 0$Ext
                    ORDER BY
                            cl.client_id DESC
                    LIMIT $limit;";
        }
        $list = $this->Db->query($SQL);
        foreach ($list AS &$l) {
            $l['client_sex'] = $this->Util->sexConv($l['client_sex']);
        }

        return $list;
    }

    /**
     * 获取用户头像
     * @param type $openid
     * @return type
     */
    public function getUserHeadByOpenId($openid, $size = 0)
    {
        $head = $this->Db->getOne("SELECT client_head FROM `clients` WHERE `client_wechat_openid` = '$openid';");

        return $head ? $head . "/$size" : 'static/images/login/profle_1.png';
    }

    /**
     * 微信进入自动注册
     * @todo 事务？
     */
    public function wechatAutoReg($openid = '')
    {
        // 检查用户是否注册
        if (!empty($openid) && Controller::inWechat() && !$this->userCheckReg($openid)) {
            // 微信用户资料 UNIONID机制
            $WechatUserInfo = WechatSdk::getUserInfo(WechatSdk::getServiceAccessToken(), $openid, true);
            if ($WechatUserInfo->subscribe > 0) {
                // 如果已经关注，那么已经获取到信息
            } else {
                // 未关注，网页授权方式获取信息
                //###########################################################
                //$AccessCode = WechatSdk::getAccessCode($this->uri, "snsapi_userinfo");
                //使用原始回调地址
                $AccessCode = WechatSdk::getAccessCode(Util::convURI($this->uri), "snsapi_userinfo");
                //###########################################################
                if ($AccessCode !== FALSE) {
                    // 获取到accesstoken和openid
                    $Result = WechatSdk::getAccessToken($AccessCode);
                    // 微信用户资料
                    $WechatUserInfo = WechatSdk::getUserInfo($Result->access_token, $Result->openid);
                }
            }

            // 用户注册默认积分
            $reg_credit_default = intval($this->getSetting('reg_credit_default'));

            // 写入用户信息
            $uid = $this->createUser([
                'client_nickname' => $WechatUserInfo->nickname,
                'client_name' => $WechatUserInfo->nickname,
                'client_sex' => $this->wechatSexConv($WechatUserInfo->sex),
                'client_head' => substr($WechatUserInfo->headimgurl, 0, strlen($WechatUserInfo->headimgurl) - 2),
                'client_wechat_openid' => $openid,
                'client_province' => $WechatUserInfo->province,
                'client_city' => $WechatUserInfo->city,
                'client_address' => $WechatUserInfo->province . $WechatUserInfo->city,
                'client_credit' => $reg_credit_default,
            ]);

            if ($uid > 0) {

                // 用户注册成功
                $this->Session->set('uid', $uid);
                $this->Session->set('openid', $Result->openid);

                // 执行钩子程序
                (new HookNewUser())->deal([
                    'uid' => $uid,
                    'openid' => $openid,
                ]);

                // 红包绑定uid
                $this->Dao->update(TABLE_USER_ENVL)
                    ->set(['uid' => $uid])
                    ->where("openid = '$openid'")
                    ->aw("uid IS NULL")
                    ->exec();

                // 查找 代理-会员 对应关系
                $ret = $this->Dao->update(TABLE_COMPANY_USERS)
                    ->set(['uid' => $uid])
                    ->where("openid='$openid'")
                    ->exec();
                if ($ret) {
                    // 如果确实有代理推荐
                    $comid = $this->Dao->select('comid')
                        ->from(TABLE_COMPANY_USERS)
                        ->where("openid='$openid'")
                        ->getOne();
                    // 更新代理对应
                    if ($comid > 0 && $this->bindCompany($uid, $comid)) {
                        // 执行钩子程序
                        (new HookNewCompanyLinked($this->Controller))->deal([
                            'uid' => $uid,
                            'openid' => $openid,
                            'companyid' => $comid,
                        ]);
                    }
                }

                return true;
            } else {
                Util::log('用户注册失败，信息写入出错' . json_encode($WechatUserInfo));

                // 无法注册
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 绑定会员和代理的关系
     * @param $uid
     * @param $comid
     */
    public function bindCompany($uid, $comid)
    {
        return $this->Dao->update(TABLE_USER)
            ->set(['client_comid' => $comid])
            ->where("client_id=$uid")
            ->exec();
    }

    /**
     * 从订单收货地址中提取个人信息
     * @param type $orderId
     */
    public function importFromOrderAddress($orderId)
    {
        $this->loadModel('mOrder');
        $orderAddr = $this->mOrder->getOrderAddr($orderId);
        if ($orderAddr) {
            return $this->Dao->update(TABLE_USER)
                ->set(array(
                    'client_name' => $orderAddr['user_name'],
                    'client_address' => $orderAddr['address'],
                    'client_phone' => $orderAddr['tel_number'],
                    'client_province' => $orderAddr['province'],
                    'client_city' => $orderAddr['city'],
                ))
                ->where("client_id=" . $orderAddr['client_id'])
                ->exec();
        } else {
            return false;
        }
    }

    /**
     * 判断微信用户是否已经关注
     * @return type
     */
    public function isSubscribed()
    {
        if (Controller::inWechat()) {
            $openid = $this->getOpenId();
            $this->loadModel('WechatSdk');
            $WechatUserInfo = WechatSdk::getUserInfo(WechatSdk::getServiceAccessToken(), $openid, true);

            return $WechatUserInfo->subscribe == 1;
        }

        return false;
    }

    /**
     * 获取用户所在组的折扣
     * @param int $uid
     * @return float
     */
    public function getDiscount($uid)
    {
        $uid = intval($uid);
        if ($uid > 0) {
            $discount = $this->Dao->select('level_discount')
                            ->from(TABLE_USER)
                            ->alias('us')
                            ->leftJoin(TABLE_USER_LEVEL)
                            ->alias('ul')
                            ->on("ul.id = us.client_level")
                            ->where("us.client_id = $uid")
                            ->limit(1)
                            ->getOne() / 100;
            if ($discount > 0 && $discount <= 1) {
                return $discount;
            } else {
                return 1;
            }
        } else {
            return 1;
        }
    }

    /**
     * 获取所有用户组
     * @param type $catParent
     * @return type
     */
    public function getAllGroup()
    {
        $group = WechatSdk::getUserGroup();
        $g = array();
        $g[] = array(
            'dataId' => 0,
            'name' => '全部用户',
        );
        foreach ($group as &$l) {
            $a = array();
            $a['name'] = $l['name'];
            $a['dataId'] = intval($l['id']);
            $a['open'] = 'false';
            $a['hasChildren'] = false;
            $g[] = $a;
        }

        return $g;
    }

    /**
     * 获取用户代理编号
     * @param int $openid
     * @return boolean
     */
    public function getCompanyId($openid)
    {
        $companyCom = intval($this->Db->getOne("SELECT `comid` FROM `company_users` WHERE `openid` = '$openid';"));

        return $companyCom > 0 ? $companyCom : 0;
    }

    /**
     * 获取用户的购物车数据
     * @param $openId
     * @param $uid
     * @return array
     */
    public function getCartData($openId, $uid)
    {

        $this->Db->disableCache();

        $this->loadModel(['Product', 'Supplier', 'mProductSpec', 'Envs']);

        // 购物车数据
        $datas = $this->Dao->select("product_id, spec_id, count")
            ->from(TABLE_CART)->alias("cart")
            ->where("openid = '$openId'")->exec();

        $return = [
            'total' => 0,
            'supps' => [],
        ];

        if (sizeof($datas) > 0) {
            // 用户所在组的折扣
            $discount = $this->getDiscount($uid);
            // 商品数量
            $product_count = 0;
            // 供应商列表
            $suppliers = [];
            foreach ($datas as &$data) {
                // 商品信息
                $product_info = $this->Dao->select([
                    'product_name',
                    'product_supplier',
                    'product_weight',
                    'catimg',
                ])->from(TABLE_PRODUCTS)->where([
                    'product_id' => $data['product_id'],
                    'is_delete' => 0,
                    'product_online' => 1,
                ])->getOneRow();
                if ($product_info) {
                    // 商品规格信息
                    $product_spec = $this->mProductSpec->getProductSpecInfo($data['product_id'], $data['spec_id']);
                    $product_info['product_id'] = intval($data['product_id']);
                    $product_info['spec_id'] = intval($data['spec_id']);
                    $product_info['count'] = intval($data['count']);
                    $product_info['product_supplier'] = intval($product_info['product_supplier']);
                    $product_info['sale_price'] = floatval($product_spec['sale_price'] * $discount);
                    $product_info['market_price'] = floatval($product_spec['market_price']);
                    $product_info['instock'] = intval($product_spec['instock']);
                    $product_info['catimg'] = Util::packProductImgURI($product_info['catimg']);
                    // 商品红包字符串序列 红包id,红包id (获取商品关联红包)
                    $product_info['envstr'] = $this->Envs->getPdEnvsJoinStr($product_info['product_id']);
                    $product_info['specname'] = $product_spec['specname'];
                    $product_info['product_weight'] = floatval($product_info['product_weight']);
                    $supplier_id = intval($product_info['product_supplier']);
                    // 供应商信息存在
                    if ($supplier_id > 0) {
                        $supplier = $this->Supplier->get($supplier_id);
                        if (!$supplier) {
                            $supplier = ['supp_name' => null, 'supp_phone' => null];
                        }
                    } else {
                        // 供应商信息不存在
                        $supplier = ['supp_name' => $this->getShopname(), 'supp_phone' => null];
                    }
                    if (!array_key_exists('supp' . $supplier_id, $suppliers)) {
                        $suppliers['supp' . $supplier_id] = [
                            'supp_id' => $supplier_id,
                            'supp_name' => $supplier['supp_name'],
                            'supp_phone' => $supplier['supp_phone'],
                            'cart_datas' => [],
                        ];
                    }
                    // 购物车数据
                    array_push($suppliers['supp' . $supplier_id]['cart_datas'], $product_info);
                    // 商家信息
                    $product_count += $data['count'];
                } else {
                    // 商品信息不存在
                    continue;
                }
            }
            $return = [
                'total' => $product_count,
                'supps' => array_values($suppliers),
            ];
        }

        return $return;
    }

    /**
     * 获取购物车数据,简单结构
     * @param $openid
     * @return array
     */
    public function getCartDataSimple($openid)
    {
        $datas = $this->Dao->select("pd.product_id AS pid, spec_id AS spid, count")
            ->from(TABLE_CART)->alias("cart")
            ->leftJoin(TABLE_PRODUCTS)->alias('pd')
            ->on('pd.product_id = cart.product_id')
            ->where("openid = '$openid' AND pd.product_online = 1")->exec();

        return $datas;
    }

    /**
     * 获取用户余额
     * @return float
     */
    public function getBalance($openid)
    {
        $user = $this->Dao->select('client_money')->from(TABLE_USER)->where("client_wechat_openid = '$openid'")->getOne();

        return doubleval($user);
    }

}

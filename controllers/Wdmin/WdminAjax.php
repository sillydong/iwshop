<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * WdminAjax
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class WdminAjax extends ControllerAdmin
{

    /**
     * 查看订单<发货>
     */
    const ORDER_EXP = 0;

    /**
     * 查看订单
     */
    const ORDER_VIE = 1;

    /**
     * 构造函数
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        if (!$this->Auth->checkAuth()) {
            $this->redirect('?/Wdmin/logOut');
        }
    }

    /**
     * groupSendImageUpload
     */
    public function BannerImageUpload() {
        global $config;
        $this->loadModel('ImageUploader');
        $this->ImageUploader->dir = $config->oss ? $config->ossDir . '/banner/' : APP_PATH . 'uploads/banner/';
        $file                     = $this->ImageUploader->upload($config->oss, $config->access_id, $config->access_key, $config->bucket);
        if ($file !== false) {
            $this->echoJson(array(
                's' => 1,
                'img' => $file,
                'link' => $config->oss ? $file : '/uploads/banner/' . $file
            ));
        } else {
            $this->echoJson(array('s' => 0));
        }
    }

    /**
     * 上传群发封面图片
     * groupSendImageUpload
     */
    public function groupSendImageUpload() {
        global $config;
        $this->loadModel('ImageUploader');
        $this->ImageUploader->dir = $config->oss ? $config->ossDir . '/gmess_tmp/' : APP_PATH . 'uploads/gmess_tmp/';
        $file                     = $this->ImageUploader->upload($config->oss, $config->access_id, $config->access_key, $config->bucket);
        if ($file !== false) {
            $this->echoText(array(
                's' => 1,
                'img' => $file,
                'link' => $config->oss ? $file : '/uploads/gmess_tmp/' . $file
            ));
        } else {
            $this->echoText(array('s' => 0));
        }
    }

    // 获取订阅者列表
    public function ajaxGetSubScribelist() {
        $this->loadModel('WechatSdk');
        $access_token        = WechatSdk::getServiceAccessToken();
        $list                = WechatSdk::getWechatSubscriberList($access_token);
        $list['accesstoken'] = $access_token;
        $this->echoJson($list);
    }

    // 上传群发统计数据
    public function UploadGroupSendStatData() {
        $SQL = sprintf("INSERT INTO `gmess_send_stat` (msg_id,send_date,send_count,receive_count,msg_type) " . " VALUES (%s,NOW(),%s,%s,'images');", $_POST['msgid'], $_POST['total'], $_POST['success']);
        $rst = $this->Db->query($SQL);
        echo $rst ? 1 : 0;
    }

    /**
     * 获取商品详细信息
     * @param type $Query
     */
    public function ajaxGetProductInfo($Query) {
        $id            = intval($Query->id);
        $res           = $this->Db->getOneRow("SELECT * FROM `products_info` pi LEFT JOIN product_onsale po ON po.product_id = pi.product_id WHERE pi.`product_id` = $id;");
        $res['images'] = $this->Db->query("SELECT * FROM `product_images` WHERE `product_id` = " . $res['product_id']);
        $this->echoJson($res);
    }

    /**
     * 获取订单详情
     * @param type $Query
     */
    public function loadOrderDetail($Query) {
        $this->cacheId = hash('md4', serialize($Query));
        if (!$this->isCached()) {
            // cache
            global $config;
            $id = intval($Query->id);
            $this->loadModel('mOrder');
            $express          = include APP_PATH . 'config/express_code_prefix.php';
            $express_noprefix = include APP_PATH . 'config/express_code.php';

            $expressEs = $this->Dao->select("value")
                                   ->from('wshop_settings')
                                   ->where("`key` = 'expcompany'")
                                   ->getOne();
            $expressEs = explode(',', $expressEs);

            $openid  = $this->getSetting('order_express_openid');
            $openids = explode(',', $openid);
            $exps    = $this->Dao->select()
                                 ->from(TABLE_USER)
                                 ->where("client_wechat_openid in ('" . implode("','", $openids) . "')")
                                 ->exec();

            $this->assign('expressStaff', $exps);

            foreach ($express as $k => &$od) {
                if (!in_array($k, $expressEs)) {
                    unset($express[$k]);
                }
            }

            if (!isset($Query->mod)) {
                $Query->mod = self::ORDER_EXP;
            } else {
                $Query->mod = intval($Query->mod);
            }
            // get data
            $data                = $this->mOrder->GetOrderDetail($id);
            $data['statusX']     = $config->orderStatus[$data['status']];
            $data['expressName'] = $express_noprefix[$data['express_com']];
            // assign
            $this->Smarty->assign('expressCompany', $express);
            $this->Smarty->assign('data', $data);
            $this->Smarty->assign('mod', $Query->mod);
        }
        $this->show('wdminpage/orders/ajaxloadorderdetail.tpl');
    }

    /**
     * 管理后台加载报表页
     * @param type $Query
     */
    public function ajaxLoadStatHome() {
        $QueryDate  = date("Y-m-d");
        $QueryMonth = date("Y-m");
        // 日销售
        $DaySaleData = $this->Db->query("SELECT * FROM `vstatdaysalesumraw` WHERE `day` = '$QueryDate';");
        // 月销售
        $MonthSaleData = $this->Db->query("SELECT * FROM `vstatmonthsalesumraw` WHERE `month` = '$QueryMonth';");
        // 微信总关注
        $wechatSub = $this->Db->query("SELECT SUM(dv) AS sc FROM `wechat_subscribe_record`;");
        // 微信今天关注
        $wechatSubDay = $this->Db->query("SELECT SUM(dv) AS sc FROM `wechat_subscribe_record` WHERE DATE_FORMAT(`date`,'%Y-%m-%d') = '$QueryDate';");
        // 微信关注记录
        $WechatSubscribeStat = $this->Db->query("SELECT * FROM `vwechatsubscribestat` WHERE DATE_FORMAT(`date`,'%Y-%m') = '$QueryMonth';");
        $data_wechatsc       = array();
        foreach ($WechatSubscribeStat as $_record) {
            $data_wechatsc['day'][]   = intval(date("d", strtotime($_record['date'])));
            $data_wechatsc['count'][] = $_record['count'];
        }

        $wecahtCount = isset($data_wechatsc['count']) ? implode(',', $data_wechatsc['count']) : '';
        $wecahtDay   = isset($data_wechatsc['day']) ? implode(',', $data_wechatsc['day']) : '';

        $this->Smarty->assign('wecahtCount', $wecahtCount);
        $this->Smarty->assign('wecahtDay', $wecahtDay);
        $this->Smarty->assign('daysale', $DaySaleData[0]);
        $this->Smarty->assign('monthsale', $MonthSaleData[0]);
        $this->Smarty->assign('wechatSubDay', $wechatSubDay[0]['sc']);
        $this->Smarty->assign('wechatSubTotal', $wechatSub[0]['sc']);
        $this->show();
    }

    /**
     * 更新商品信息
     */
    public function updateProduct() {
        $this->loadModel('Product');
        $this->sCookie('lastSerial', $this->post('product_serial'));
        // 默认供货价
        if (!isset($_POST['supply_price']) || empty($_POST['supply_price'])) {
            $_POST['supply_price'] = 0.00;
        }
        try {
            $id = $this->Product->modifyProduct($_POST);
            if ($id > 0) {
                $this->echoMsg(0, $id);
            } else {
                $this->echoMsg(-1, '未知错误');
            }
        } catch (Exception $ex) {
            $this->echoMsg(-1, $ex->getMessage());
        }
    }

    /**
     * 更新自动回复内容
     * @todo opt
     */
    public function setAutoReplys() {
        $data  = $this->pPost('data');
        $gmess = $data['gmess'];
        if ($data['rel'] == 0 && $data['reltype'] != 0) {
            // 新建gmess
            $SQL = sprintf("INSERT INTO `gmess_page` (`title`,`content`,`desc`,`catimg`,`createtime`) VALUES ('%s','%s','%s','%s',NOW());", addslashes($gmess['title']), addslashes($gmess['content']), addslashes($gmess['desc']), $gmess['catimg']);
            $rst = $this->Db->query($SQL);
            $SQL = "REPLACE INTO `wechat_autoresponse` (`id`,`key`,`message`,`rel`,`reltype`) VALUES ($data[id],'$data[key]','$data[message]','$rst','$data[reltype]')";
            $ret = $this->Db->query($SQL);
            echo $ret;
        } else {
            $SQL = sprintf("UPDATE `wechat_autoresponse` SET `key` = '%s',`message` = '%s',`rel` = %s,`reltype` = %s WHERE `id` = %s;", $data['key'], $data['message'], $data['rel'], $data['reltype'], $data['id']);
            $ret = $this->Db->query($SQL);
            if ($data['rel'] > 0) {
                // 更新gmess
                $SQL  = sprintf("UPDATE `gmess_page` SET `title` = '%s',`content` = '%s',`desc` = '%s',`catimg` = '%s' WHERE `id` = %s;", addslashes($gmess['title']), addslashes($gmess['content']), addslashes($gmess['desc']), $gmess['catimg'], $gmess['id']);
                $rst1 = $this->Db->query($SQL);
                echo $rst1 + $ret;
            } else {
                echo $ret;
            }
        }
    }

    /**
     * 添加自动回复内容
     */
    public function addAutoReplys() {
        $key = $_POST['key'];
        $SQL = "INSERT INTO `wechat_autoresponse` (`key`,`message`) VALUES ('$key','');";
        echo $this->Db->query($SQL);
    }

    /**
     * 删除自动回复关键字
     */
    public function deleteAutoReplys() {
        $id  = intval($_POST['id']);
        $ret = $this->Db->query("DELETE FROM `wechat_autoresponse` WHERE `id` = $id;");
        echo $ret == false ? 0 : 1;
    }

    /**
     * 更新系统设置
     */
    public function setSettings() {
        $SQL = sprintf("UPDATE `shop_settings` SET `shop_name` = '%s',`wechat_subscribe_welcome` = '%s',`company_profit_percent` = '%s';", $_POST['shop_name'], $_POST['wechat_subscribe_welcome'], $_POST['company_profit_percent']);
        echo $this->Db->query($SQL);
    }

    /**
     * 获取微代理未结算数据
     * @return type
     */
    public function getCompanyCslist() {
        $this->loadModel('mCompany');
        $list = $this->mCompany->getCompanyCashs();
        #var_dump($list);
        $this->Smarty->assign('olist', count($list));
        $this->Smarty->assign('list', $list);
        $this->show();
    }

    public function companyCash($Query) {
        $this->loadModel('mCompany');
        $list = $this->mCompany->getCompanyCashs($Query->id);
        $this->Smarty->assign('list', $list[0]);
        $this->show();
    }

    public function cashCompanyReq() {
        $uid = $_POST['uid'];
        $this->Db->query(sprintf("UPDATE `companys` SET `bank_name` = '%s',`bank_account` = '%s',`bank_personname` = '%s' WHERE `uid` = '$uid';", $_POST['bank_name'], $_POST['bank_account'], $_POST['bank_personname']));
        echo $this->Db->query("UPDATE `company_income_record` SET `is_reqed` = 1 WHERE `is_seted` = 0 AND `is_reqed` = 0 AND `com_id` = '$uid';");
    }

    public function cashCompany() {
        $this->loadModel('mCompany');
        echo $this->mCompany->cashCompany($_POST['uid']);
    }

    /**
     * 删除商品
     */
    public function deleteProduct() {
        $id = intval($this->pPost('id'));
        $this->loadModel('Product');
        echo $this->Product->deleteProduct($id);
    }

    /**
     * 会员列表
     */
    public function ajaxUserList($Query) {
        !isset($Query->gid) && $Query->gid = '';
        $this->Smarty->caching = false;
        if ($Query->gid != '') {
            $Ext = " AND `client_groupid` = $Query->gid";
        } else {
            $Ext = '';
        }
        if ($this->pCookie('comid')) {
            $comid = $this->Util->digDecrypt($this->pCookie('comid'));
            $SQL   = "SELECT
	cl.*,cl.client_id AS cid,
	(
		SELECT
			count(*)
		FROM
			`orders`
		WHERE
			client_id = cl.client_id
	) AS `order_count`
        FROM
                company_users cu
        LEFT JOIN clients cl ON cl.client_id = cu.uid$Ext
        WHERE
                cu.comid = $comid AND cl.deleted = 0;";
        } else {
            $SQL = "SELECT
	*, cl.client_id AS cid,
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
        LEFT JOIN `client_info_exts` cx ON cx.client_id = cl.client_id WHERE cl.deleted = 0$Ext
        ORDER BY
	cl.client_id DESC;";
        }
        $list = $this->Db->query($SQL);
        foreach ($list AS &$l) {
            $l['client_sex'] = $this->sexConv($l['client_sex']);
        }
        $this->Smarty->assign('iscom', isset($comid));
        $this->Smarty->assign('list', $list);
        $this->show('wdminpage/users/ajaxuserlist.tpl');
    }

    /**
     * 性别eng转换
     * @param type $sex
     * @return string
     */
    private function sexConv($sex) {
        $s = array(
            'f' => '女',
            'm' => '男'
        );
        if (array_key_exists($sex, $s)) {
            return $s[$sex];
        } else {
            return '未知';
        }
    }

    /**
     * 获取横幅数据
     */
    public function getBannerData() {
        $dat = $this->Db->query("SELECT * FROM `ws_banner`;");
        $this->echoJson($dat);
    }

    public function SaveBannerData() {
        echo $this->Db->query(sprintf("UPDATE `ws_banner` SET `banner_image` = '%s',`banner_href` = '%s' WHERE `relid` = %s;", $this->post('img'), $this->post('href'), $this->post('relid')));
    }

    /**
     * 获取素材
     * @param type $Query
     */
    public function ajaxGmess($Query) {
        global $config;
        $id           = intval($Query->id);
        $page         = $this->Db->getOneRow("SELECT * FROM `gmess_page` WHERE `id` = $id;");
        $page['href'] = "http://" . $this->server('HTTP_HOST') . "$config->shoproot?/Gmess/view/id=" . $page['id'];
        $this->Smarty->assign('gm', $page);
        $this->show();
    }

    /**
     * 修改自动回复
     */
    public function updateAutoReply() {
        echo $this->Db->query(sprintf("UPDATE `wechat_autoresponse` SET `rel` = %s WHERE `id` = %s;", $this->post('rel'), $this->post('id')));
        # echo sprintf("UPDATE `wechat_autoresponse` SET `rel` = %s WHERE `id` = %s;", $this->post('rel'), $this->post('id'));
    }

    /**
     * 获取商品分类统计数据
     */
    public function ajaxGetProductStatnums() {
        $this->loadModel('SqlCached');
        // multi-supplier
        $supplier_id = $_SESSION['supplier_id'];
        if ($supplier_id) {
            $supplierAquery = " AND `product_supplier` = $supplier_id";
            $supplierWquery = " WHERE `product_supplier` = $supplier_id";
        } else {
            $supplierAquery = " ";
            $supplierWquery = " ";
        }
        // file cached
        $cacheKey  = 'ajaxGetProductStatnums';
        $fileCache = new SqlCached();
        $ret       = $fileCache->get($cacheKey);
        if (-1 === $ret) {
            $ret = array();

            $ret['pdcount2'] = intval($this->Db->getOne("SELECT COUNT(*) FROM products_info WHERE `is_delete` = 1 $supplierAquery;"));
            $ret['pdcount']  = intval($this->Db->getOne("SELECT COUNT(*) FROM products_info WHERE `is_delete` = 0 $supplierAquery;"));
            $ret['cacount']  = intval($this->Db->getOne("SELECT COUNT(*) FROM product_category $supplierWquery;"));
            $ret['spcount']  = intval($this->Db->getOne("SELECT COUNT(*) FROM wshop_spec $supplierWquery;"));
            //$ret['secount']  = intval($this->Db->getOne("SELECT COUNT(*) FROM product_serials $supplierWquery;"));
            $ret['brcount'] = intval($this->Db->getOne("SELECT COUNT(*) FROM product_brand $supplierWquery;"));

            $fileCache->set($cacheKey, $ret);
            $this->echoJson($ret);
        } else {
            $this->echoJson($ret);
        }
    }

    /**
     * 获取代理分类统计数据
     */
    public function ajaxGetCompanyStatNums() {
        $this->loadModel('SqlCached');
        // file cached
        $cacheKey  = 'ajaxGetCompanyStatNums';
        $fileCache = new SqlCached();
        $ret       = $fileCache->get($cacheKey);
        if (-1 === $ret) {
            $ret = array();

            $ret['count1'] = intval($this->Db->getOne("SELECT COUNT(*) FROM companys WHERE `verifed` = 1 AND `deleted` = 0;"));
            $ret['count2'] = intval($this->Db->getOne("SELECT COUNT(*) FROM companys WHERE `verifed` = 0 AND `deleted` = 0;"));
            $ret['count3'] = intval($this->Db->getOne("SELECT COUNT(distinct `com_id`) FROM `company_income_record` cir LEFT JOIN `companys` cs ON cs.id = cir.com_id WHERE `is_seted` = 0 AND cs.deleted = 0;"));

            $fileCache->set($cacheKey, $ret);
            $this->echoJson($ret);
        } else {
            $this->echoJson($ret);
        }
    }

    /**
     * 编辑用户分组名
     */
    public function ajaxAlterUserGroup() {
        $this->loadModel('WechatSdk');
        $this->echoJson(WechatSdk::alterUserGroup($this->post('id'), $this->post('name')));
    }

    /**
     * 添加用户分组
     */
    public function ajaxAddUserGroup() {
        $this->loadModel('WechatSdk');
        $this->echoJson(WechatSdk::addUserGroup($this->post('name')));
    }

    /**
     * 设置微信自定义菜单
     */
    public function ajaxSetWechatMenu() {
        $this->loadModel('WechatSdk');
        $rst = WechatSdk::setMenu($this->pPost('menu'));
        $this->echoJson($rst);
    }

    /**
     * 设置自定义菜单设置项
     */
    public function bindMenu() {
        echo $this->Db->query(sprintf("INSERT INTO `wshop_menu` (`relid`,`reltype`,`relcontent`) VALUE ('%s','%s','%s');", $this->pPost('relid'), $this->pPost('reltype'), strip_tags($this->pPost('relcontent'))));
    }

    /**
     * 获取自定义菜单设置项
     */
    public function getMenu() {
        $r = $this->Db->getOneRow("SELECT * FROM `wshop_menu` WHERE `id` = " . $this->pPost('id'));
        $this->echoJson($r);
    }

    public function ajaxDeleteBanner() {
        $id = $this->pPost('id');
        if ($id < 0) {
            $this->loadModel('Banners');
            echo $this->Banners->modiBanner($id) ? 1 : 0;
        }
    }

    /**
     * 编辑banner
     */
    public function modiBanner() {
        $id    = $this->pPost('id');
        $name  = $this->pPost('name');
        $relId = $this->pPost('relId');
        $sort  = $this->pPost('sort');
        $img   = $this->pPost('img');
        $pos   = $this->pPost('pos');
        $type  = $this->pPost('type');
        $href  = $this->pPost('href');
        $exp   = $this->pPost('exp');
        $this->loadModel('Banners');
        echo $this->Banners->modiBanner($id, $name, $img, $pos, $type, $relId, $sort, $href, $exp);
    }

    /**
     * ajax会员选择弹出框
     */
    public function ajax_customer_select() {
        $this->show();
    }

    /**
     * 获取会员列表
     * @param type $Q
     */
    public function ajax_customer_select_in($Q) {
        $this->loadModel('User');
        $this->cacheId = $Q->id;
        $list          = $this->User->getUserList($Q->id);
        $this->Smarty->assign('list', $list);
        $this->show();
    }

    /**
     * 删除首页板块
     */
    public function ajaxDeleteSection() {
        $id = $this->post('id');
        echo $this->Dao->delete()
                       ->from(TABLE_HOME_SECTION)
                       ->where("id = $id")
                       ->exec() !== false ? 1 : 0;
    }

    /**
     * 导航图标上传
     */
    public function NavigationImageUpload() {
        global $config;
        $this->loadModel('ImageUploader');
        $this->ImageUploader->dir = $config->oss ? $config->ossDir . '/navigation/' : APP_PATH . 'uploads/navigation/';
        $file                     = $this->ImageUploader->upload($config->oss, $config->access_id, $config->access_key, $config->bucket);
        if ($file !== false) {
            $this->echoJson(array(
                's' => 1,
                'img' => $file,
                'link' => $config->oss ? $file : '/uploads/navigation/' . $file
            ));
        } else {
            $this->echoJson(array('s' => 0));
        }
    }

    public function ajaxDeleteNavigation() {
        $id = $this->post('id');
        echo $this->Dao->delete()
                       ->from(TABLE_HOME_NAV)
                       ->where("id = $id")
                       ->exec() !== false ? 1 : 0;
    }

}

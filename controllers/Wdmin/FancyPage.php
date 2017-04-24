<?php

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 * @deprecated
 */
class FancyPage extends ControllerAdmin {

    const TPL = './views/wdminpage/fancy/';

    /**
     *
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('Session');
        $this->Session->start();
        if ($this->Session->get('loginKey') === false) {
            $this->redirect('?/Wdmin/logOut');
        }
    }

    /**
     * fancybox 编辑分组
     * @param type $Q
     */
    public function fancyAlterGroup($Q) {
        $this->Smarty->assign('id', $Q->id);
        $this->Smarty->assign('name', urldecode($Q->name));
        $this->show(self::TPL . 'fancy_altergroup.tpl');
    }

    /**
     * fancybox 添加分组
     */
    public function fancyAddGroup() {
        $this->show(self::TPL . 'fancy_addgroup.tpl');
    }

    /**
     * fancyBox订单退款处理
     * @param type $Q
     */
    public function orderRefund($Q) {
        $orderId = intval($Q->id);
        if ($orderId > 0) {
            $this->cacheId = hash('md4', serialize($Q));
            if (!$this->isCached()) {
                $this->loadModel('mOrder');
                // cache
                global $config;
                $this->loadModel('mOrder');
                $express          = include dirname(__FILE__) . '/../config/express_code_prefix.php';
                $express_noprefix = include dirname(__FILE__) . '/../config/express_code.php';
                // get data
                $data                = $this->mOrder->GetOrderDetail($orderId);
                $data['statusX']     = $config->orderStatus[$data['status']];
                $data['expressName'] = $express_noprefix[$data['express_com']];
                if ($data['order_amount'] < 1) {
                    $data['refundable'] = $data['order_amount'];
                } else {
                    $data['refundable'] = $this->mOrder->getUnRefunded($data['order_id']);
                }
                // assign
                $this->Smarty->assign('expressCompany', $express);
                $this->Smarty->assign('data', $data);
            }
            $this->show(self::TPL . 'order_refund.tpl');
        }
    }

    /**
     * 商品选择块
     */
    public function ajaxSelectProduct() {
        $this->show(self::TPL . 'ajaxSelectProduct.tpl');
    }

    /**
     * ajax获取商品选择块
     * @param type $Q
     */
    public function ajaxPdBlocks($Q) {
        $this->loadModel('Product');
        $this->Smarty->caching = false;
        $productList           = $this->Product->getList(isset($Q->id) ? $Q->id : false, 0, 100, 'pds.`product_id` DESC', $Q->key ? $Q->key : false);
        $this->Smarty->assign('products', $productList);
        $this->show(self::TPL . 'ajaxPdBlocks.tpl');
    }

}

<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 店铺首页
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Index extends ControllerShop
{

    /**
     * Index constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
    }

    /**
     * 店铺首页
     */
    public function index() {

        $this->loadModel([
            'User',
            'WechatSdk'
        ]);

        $openId = $this->getOpenId();

        // 微信注册
        $this->User->wechatAutoReg($openId);

        $this->Smarty->cache_lifetime = 60;

        if (!$this->isCached()) {

            $this->loadModel([
                'Product',
                'HomeSection',
                'HomeNavigation',
                'Banners'
            ]);

            // hotProduct
            $productHot = $this->Product->getHotEst(false, 4);

            // newProduct
            $productNew = $this->Product->getList(false, 0, 4);

            // topBanners
            $this->assign('topBanners', $this->Banners->getBanners(0));
            // bottomBanners
            $this->assign('bottomBanners', $this->Banners->getBanners(1));
            // section
            $in      = '0,1'; //获取产品列表展示版块
            $section = $this->HomeSection->gets($in);
            foreach ($section as &$s) {
                $s['products'] = $this->Product->getIn($s['pid']);
            }

            // section
            $inAdv  = "4"; //获取产品列表展示版块
            $secAdv = $this->HomeSection->gets($inAdv);
            foreach ($secAdv as &$s) {
                $s['advs'] = $this->Banners->gets($s['pid']);
            }
            $this->assign('secAdv', $secAdv);

            //navigation
            $nav = $this->HomeNavigation->getNav();
            $this->assign('navigation', $nav);
            $this->assign('Section', $section);
            $this->assign('productHot', $productHot);
            $this->assign('productNew', $productNew);
        }
        $this->show('./wshop/index/index.tpl');
    }

}

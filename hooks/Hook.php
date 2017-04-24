<?php

/**
 * @property string $root 根目录
 * @property Dao $Dao Data access Object
 * @property User $User User Management
 * @property Product $Product
 * @property Banners $Banners
 * @property mOrder $mOrder
 * @property mCompany $mCompany
 * @property Email $Email
 * @property ImageUploader $ImageUploader
 * @property Db $Db
 * @property DigCrypt $DigCrypt
 * @property mGmess $mGmess
 * @property mMemcache $Memcache
 * @property config $config Description
 * @property Smarty $Smarty Smarty
 * @property Helper $Helper Helper
 * @property UserCredit $UserCredit UserCredit
 * @property UserLevel $UserLevel UserLevel
 * @property Auth $Auth Auth
 * @property Envs $Envs Envs
 * @property HomeSection $HomeSection HomeSection
 * @property Load $Load Load
 * @property SqlCached $SqlCached SqlCached
 * @property GroupBuying $GroupBuying GroupBuying
 * @property mProductSpec $mProductSpec mProductSpec
 * @property Util $Util Util
 * @property Supplier $Supplier Supplier
 * @property CreditExchange $CreditExchange CreditExchange
 * @property Express $Express Express
 * @property JsSdk $JsSdk JsSdk
 * @property WdminAdmin $WdminAdmin WdminAdmin
 * @property HomeNavigation $HomeNavigation $HomeNavigation
 * @property Session $Session Session
 * @property mCompanyLevel $mCompanyLevel mCompanyLevel
 */
class Hook
{
    protected $controller;

    public function __construct($controller) {
        $this->controller = $controller;
    }

    /**
     * magic get
     * @param type $name
     * @return type
     */
    function __get($name) {
        $class = $this->controller;
        if (property_exists($class, $name)) {
            return $this->controller->$name;
        }
    }

    /**
     * @param $name
     * @param $arguments
     * @return bool|mixed
     */
    public function __call($name, $arguments) {
        // 对Controller进行动态反射，跨对象调用
        $class = new ReflectionClass('Controller');
        try {
            $ec = $class->getMethod($name);
            return $ec->invokeArgs($this->controller, $arguments);
        } catch (ReflectionException $re) {
            die('Fatal Error : ' . $re->getMessage());
        }
        return false;
    }
}
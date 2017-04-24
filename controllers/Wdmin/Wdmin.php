<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Wdmin extends Controller {

    const COOKIE_EXP = 28800;
    const LIST_LIMIT = 100;
    const loginKeyK = '4s5mpxa';

    /**
     * 构造函数
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('Session');
        header("Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0"); // HTTP/1.1
        header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); // Date in the past
        header("Pragma: no-cache"); // Date in the past
    }

    /**
     * 管理后台首页
     */
    public function index() {

        if (!$this->Auth->checkAuth()) {
            return $this->redirect('?/Wdmin/logOut');
        }

        if ($this->pCookie('loginKey')) {
            if (is_numeric($this->pCookie('lev'))) {
                $authStr                      = urldecode($this->pCookie('auth'));
                $this->cacheId                = $authStr;
                $this->Smarty->cache_lifetime = 7200;
                if (!$this->isCached()) {
                    $authArr = array();
                    foreach (explode(',', $authStr) as $a) {
                        $authArr[$a] = 1;
                    }
                    $this->Smarty->assign('adid', $this->pCookie('adid'));
                    $this->Smarty->assign('adname', $this->pCookie('adname'));
                    $this->Smarty->assign('admin_level', $this->pCookie('lev'));
                    $this->Smarty->assign('Auth', $authArr);
                    $this->Smarty->assign('today', date("n月j号 星期") . $this->Util->getTodayStr());
                }
                $this->show('./views/wcommon/wdmin_index.tpl');
            }
        } else {
            header('Location:' . $this->root . '?/Wdmin/login');
            exit(0);
        }
    }

    /**
     * 退出登录清空cookie
     */
    public function logOut() {
        foreach ($_COOKIE as $k => $v) {
            setcookie($k, NULL);
        }
        $this->Session->clear();
        header('Location:?/Wdmin/login/');
    }

    /**
     * 登录处理
     */
    public function checkLogin() {
        $this->Session->start();
        $ip = $this->getIp();
        $this->loadModel('WdminAdmin');
        $admin_acc = addslashes(trim($this->post('admin_acc')));
        $admin_pwd = addslashes(trim($this->post('admin_pwd')));
        // 保存登录账户
        $this->sCookie('admin_acc', $admin_acc, self::COOKIE_EXP);
        // admin login
        $admininfo = $this->WdminAdmin->get($admin_acc);
        // 获取该管理账户对应的商户id
        $supplier_id = $admininfo['supplier_id'];
        // 写入登陆记录
        @$this->Db->query("INSERT INTO `admin_login_records` (`account`, `ip`, `ldate`) VALUE ('$admin_acc', '$ip', NOW())");
        if ($admininfo) {
            // 校验成功
            if ($this->WdminAdmin->pwdCheck((string)$admininfo['admin_password'], (string)$admin_pwd)) {
                // 更新管理员登录状态
                $this->WdminAdmin->updateAdminState($admin_acc, $ip, $admininfo['id']);
                // 权限密钥
                $loginKey = $this->WdminAdmin->encryptToken($ip, $admininfo['id']);
                // 写入数据到session
                $this->Session->set('loginKey', $loginKey);
                if ($supplier_id) {
                    $this->Session->set('supplier_id', $supplier_id);
                }
                Util::log("登录成功 " . $admin_acc);
                // 下发管理员权限表
                $this->sCookieHttpOnly('auth', $admininfo['admin_auth'], self::COOKIE_EXP);
                $this->sCookieHttpOnly('loginKey', $loginKey, self::COOKIE_EXP);
                $this->sCookieHttpOnly('adid', $admininfo['id'], self::COOKIE_EXP);
                $this->sCookieHttpOnly('adname', $admininfo['admin_name'], self::COOKIE_EXP);
                $this->sCookieHttpOnly('lev', 0, self::COOKIE_EXP);
                // 删除cookie
                $this->sCookie('admin_acc', '', 1);
                // 成功
                $this->echoJson(array('status' => 1));
            } else {
                // 失败
                $this->echoJson(array('status' => 0));
            }
        } else {
            Util::log("管理员登录失败，密码有误！ " . $admin_acc);
            // 失败
            $this->echoJson(array('status' => 0));
        }
        $this->sCookie('admin_acc', null);
    }

    /**
     * 登录页面
     */
    public function login() {
        $this->initSettings(true);
        $this->show('./views/wcommon/wdmin_login.tpl');
    }

    /**
     * 用户登录接口
     * @param int $account 登录所用手机账号
     * @param string $password  登录密码
     * @example /Wdmin/loginUser/
     */
    public function loginUser(){
        $this->Session->start();
        $ip = $this->getIp();
        $this->loadModel('WdminAdmin');
        $account = addslashes(trim($this->post('account')));
        $password = addslashes(trim($this->post('password')));
        if( !$account || !$password){
            return $this->echoJson(array('status' => 0,'msg'=>"请完整账户和密码信息！"));
        }
        // 保存登录账户
        $this->sCookie('admin_acc', $account, self::COOKIE_EXP);

        $userinfo = $this->Dao->select('client_id,client_password')->from(TABLE_USER)->where(" client_phone = $account ")->getOneRow();
//        // admin login
//        $admininfo = $this->WdminAdmin->get($admin_acc);
        // 获取该管理账户对应的商户id
//        $supplier_id = $admininfo['supplier_id'];
        // 写入登陆记录
//        @$this->Db->query("INSERT INTO `admin_login_records` (`account`, `ip`, `ldate`) VALUE ('$admin_acc', '$ip', NOW())");
        if ($userinfo) {
            // 校验成功
//            if ($this->WdminAdmin->pwdCheck((string)$userinfo['admin_password'], (string)$admin_pwd)) {
//                // 更新管理员登录状态
            if( sha1($password) == $userinfo['client_password'] ){
//                $this->WdminAdmin->updateAdminState($admin_acc, $ip, $userinfo['id']);
                // 权限密钥
                $loginKey = $this->WdminAdmin->encryptToken($ip, $userinfo['id']);
                // 写入数据到session
                $this->Session->set('loginKey', $loginKey);
//                if ($supplier_id) {
//                    $this->Session->set('supplier_id', $supplier_id);
//                }
//                Util::log("登录成功 " . $admin_acc);
//                // 下发管理员权限表
//                $this->sCookieHttpOnly('auth', $admininfo['admin_auth'], self::COOKIE_EXP);
//                $this->sCookieHttpOnly('loginKey', $loginKey, self::COOKIE_EXP);
//                $this->sCookieHttpOnly('adid', $admininfo['id'], self::COOKIE_EXP);
//                $this->sCookieHttpOnly('adname', $admininfo['admin_name'], self::COOKIE_EXP);
//                $this->sCookieHttpOnly('lev', 0, self::COOKIE_EXP);
                // 删除cookie
                $this->sCookie('admin_acc', '', 1);
                // 成功
                $this->echoJson(array('status' => 1,'msg'=>array('id'=>$userinfo['client_id'])));
            } else {
                // 失败
                $this->echoJson(array('status' => 0,'msg'=>"登录失败，密码有误!". $account));
            }
        } else {
//            Util::log("登录失败，密码有误！ " . $account);
            // 失败
            $this->echoJson(array('status' => 0,'msg'=>"登录失败，信息获取失败！ " . $account));
        }
        $this->sCookie('admin_acc', null);
    }

    /**
     * 过期时间（秒）
     * @var int
     */
    private $expire = 7200;

    /**
     * 发送短信验证码 [POST]
     * @param int $phone 电话号码
     * 接口请求地址：/Wdmin/send/
     * 返回结果：{"retcode":1,"msg":"SUCCESS"}
     *
    public function sendCode($Q) {
        $phone = addslashes(trim($this->post('phone')));
        if (is_numeric($phone)) {
            $redis     = mRedis::get_instance();
            $validCode = rand(100000, 599999);
            // 发送模板短信
            $result = dooApi::call('/sms/send_template/', [
                'phone' => $phone,
                'template' => 'SMS_5089494',
                'params' => [
                    'product' => '一键送水',
                    'code' => $validCode
                ],
                'sign' => ''
            ], dooApi::API_REQUEST_METHOD_POST);
            if ($result->retcode == 0) {
                $appSessionKey   = 'valicode:' . $phone;
                $appSessionValue = $validCode;
                if ($redis) {
                    $redis->set($appSessionKey, $appSessionValue);
                    $redis->expire($appSessionKey, $this->expire);
                }
//                $this->echoMsg(0, $validCode);
                $this->echoJson(array('status' => 1,'msg'=>'SUCCESS'));
            } else {
//                $this->echoErrcode(ErrorCode::$ERR_SMS_ERROR);
                $this->echoJson(array('status' => 0,'msg'=>'短信发送出错'));
            }
        } else {
//            $this->echoErrcode(ErrorCode::$ERR_SMSERROR_PARAM);
            $this->echoJson(array('status' => 0,'msg'=>'参数错误'));
        }
    }

    /**
     * 注册新的用户账号 [POST]
     * @param int $phone 电话号码
     * @param string $code 验证码
     * @param string $password 密码
     * 接口请求地址：/Wdmin/registerUser/
     * 返回结果：{"retcode":1,"msg":{"id":新建的id}}
     *//*
    public function registerUser(){
        //获取参数
        $password = $this->post('password');
        $phone = addslashes(trim($this->post('phone')));
        $code = addslashes(trim($this->post('code')));
        if($phone && $code && $password){
            //如果参数齐全才进行下一步
            $redis     = mRedis::get_instance();
            $appSessionKey   = 'valicode:' . $phone;
            if($redis->get($appSessionKey) == $code){
                //如果验证码和redis里面储存的验证码一致时，才进行下一步
                $user = $this->Dao->select('client_id')->from(TABLE_USER)->where("client_phone = $phone")->getOneRow();
                if($user){
                    //同一个手机号不能重复注册
                    return $this->echoJson(array('status' => 0,'msg'=>'手机号码已经被注册过了'));
                }else{
                    $time = date('Y-m-d');
                    $re = $this->Dao->insert(TABLE_USER,"client_nickname,client_name,client_phone,client_joindate,client_password")
                        ->values(array(
                            'autoname',
                            'autoname',
                            $phone,
                            $time,
                            sha1($password),
                        ))
                        ->exec();
                    if($re){
                        //如果保存成功则返回注册成功
                        $this->echoJson(array('status' => 1,'msg'=>array('id'=>$re)));
                    }else{
                        //如果保存不成功则返回注册失败
                        $this->echoJson(array('status' => 0,'msg'=>'FAILED'));
                    }
                }
            }else{
                //如果验证码不正确，则返回验证码错误
                $this->echoJson(array('status' => 0,'msg'=>'验证码错误'));
            }

        }else{
            //如果参数不全，返回错误
            $this->echoJson(array('status' => 0,'msg'=>'参数错误'));
        }

    }*///

}

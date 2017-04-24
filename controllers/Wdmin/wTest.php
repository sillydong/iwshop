<?php

/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2016/5/1
 * Time: 21:45
 */
class wTest extends Controller {

    public function testhookRebate() {

        $this->loadModel(['mRebate']);

        $id = 102590;

        $rebate = $this->mRebate->get($id);

        (new HookRebated($this))->deal($rebate);
    }

    public function newUser() {

        $this->loadModel(['mOrder', 'User']);

        $uname  = "张三" . mt_rand(0, 9999);
        $openid = 'oRky_wm6trPHTyXZxjB2Z-33-Lqw' . mt_rand();
        $comid  = 1341;

        // 写入用户信息
        $uid = $this->User->createUser([
            'client_nickname' => $uname,
            'client_name' => $uname,
            'client_sex' => 'm',
            'client_head' => 'http://wx.qlogo.cn/mmopen/h0I0VFxcVRQibvEXhaGWxaFIOMo7dtFEsaZTc8TzbkeraOciaiaQ7LHVPSahMQ485gZn6ibYNkJibeFz95p2zVsFKPbsTc2mseEjS',
            'client_wechat_openid' => $openid,
            'client_province' => '广东',
            'client_city' => '深圳',
            'client_address' => '广东深圳',
            'client_credit' => 0,
            'client_comid' => $comid
        ]);

        if ($uid > 0) {
            // 执行钩子程序
            (new HookNewUser($this))->deal([
                'uid' => $uid,
                'openid' => $openid
            ]);
        }
    }

    /**
     * 生成大量订单
     */
    public function generateOrders() {
        set_time_limit(0);
        $this->loadModel(['mOrder', 'User']);
        $product   = $this->Dao->select('product_id')->from(TABLE_PRODUCTS)->orderby('RAND()')->limit(1)->getOne();
        $companyid = $this->Dao->select('uid')->from(TABLE_COMPANYS)->orderby('RAND()')->limit(1)->getOne();
        $cartData  = [
            [
                'pid' => intval($product),
                'spid' => 0,
                'count' => mt_rand(1, 15)
            ]
        ];
        $addrData  = json_decode('{"proviceFirstStageName":"广东","addressCitySecondStageName":"深圳市","addressCountiesThirdStageName":"前海区","addressDetailInfo":"振业国际商务中心2103","addressPostalCode":510006,"telNumber":18565518404,"userName":"张订单","Address":"广东深圳前海振业国际商务中心2103","err_msg":"edit_address:ok"}', true);
        if (!$cartData || sizeof($cartData) == 0) {
            return $this->echoMsg(-1, '订单数据非法');
        }
        if (empty($addrData)) {
            return $this->echoMsg(-1, '地址数据非法');
        }
        $status = ['payed', 'unpay', 'received', 'delivering', 'canceled'];
        for ($i = 0; $i < 1; $i++) {
            try {
                $orderId = $this->mOrder->create('oRky_wrIoWKBqVuafV9BM9zPrEeg', $cartData, $addrData, [
                    'remark' => $this->post('remark'),
                    'exptime' => $this->post('exptime'),
                    'balancePay' => $this->post('balancePay') == 1,
                    'expfee' => $this->post('expfee'),
                    'envsid' => intval($this->post('envsId')),
                    'status' => $status[mt_rand(0, 3)],
                    'wepay_serial' => uniqid(),
                    'companyid' => $companyid,
                    'express_com' => 'shentong',
                    'express_code' => '3309821702221'
                ]);
                $this->echoMsg(0, intval($orderId));
            } catch (Exception $ex) {
                $this->log('order_create_error:' . $ex->getMessage());
                $this->echoMsg(-1, $ex->getMessage());
            }
        }
    }

    /**
     * 测试模板消息
     */
    public function testMsg() {
        $this->loadModel('WechatSdk');
        $tplconfig = include APP_PATH . 'config/config_msg_template.php';
        $openid    = 'oRky_wrIoWKBqVuafV9BM9zPrEeg';

        // 感谢您在云上有店购物
        $tpl = $tplconfig['pay_success'];
//        $ret       = Messager::sendTemplateMessage($tpl['tpl_id'], $openid, array(
//            $tpl['first_key'] => '感谢您在云上有店购物',
//            $tpl['serial_key'] => '2016061902520183',
//            $tpl['product_name_key'] => '【2包装】花王Merries日本进口纸尿裤 (NB) 90片/包',
//            $tpl['product_count_key'] => '2件',
//            $tpl['order_amount_key'] => '¥1299',
//            $tpl['remark_key'] => '点击详情 随时查看订单状态'
//        ), $this->getBaseURI() . "?/Order/expressDetail/order_id=1");
//        var_dump($ret);

        // 您有一笔订单已发货
        $tpl = $tplconfig['exp_notify'];
        $ret = Messager::sendTemplateMessage($tpl['tpl_id'], $openid, [
            $tpl['first_key'] => '您有一笔订单已发货',
            $tpl['serial_key'] => 1,
            $tpl['expname'] => 2,
            $tpl['expcode'] => 3,
            $tpl['remark_key'] => '点击详情 随时查看订单状态'
        ], $this->getBaseURI() . "?/Order/expressDetail/order_id=1");
        var_dump($ret);

    }

    /**
     * 测试订单返佣
     */
    public function testRebate() {
        $this->loadModel(['OrderRebate', 'User']);
        $this->OrderRebate->rebate(360);
        $this->OrderRebate->rebate(361);
        $this->OrderRebate->rebate(362);
    }

    public function test(){
//        $re = $this->Dao->update('clients')->set(array(
//            'client_nicknam'=>'autoname',
//            'client_name' => 'autoname',
//            'client_phone' => '123',
//            'client_joindate' => date('Y-m-d'),
//        ))->exec();
        $redis     = mRedis::get_instance();
        $appSessionKey   = 'valicode:' . '15295996632';
        var_dump($redis->get($appSessionKey));exit;
        $user = $this->Dao->select('client_id')->from(TABLE_USER)->where("client_phone = 15295996632")->getOneRow();
        if($user){
            //同一个手机号不能重复注册
            return $this->echoJson(array('status' => 0,'msg'=>'手机号码已经被注册过了'));
        }exit;
        $time = date('Y-m-d');
        $re = $this->Dao->insert(TABLE_USER,"client_nickname,client_name,client_phone,client_joindate")
            ->values(array(
                'autoname',
                'autoname',
                '15295996632',
                $time,
            ))
            ->exec();
        var_dump($re);
        echo 'hello';
    }

}
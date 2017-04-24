<?php

/**
 * 订单处理控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wOrder extends ControllerAdmin {

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        if (!$this->Auth->checkAuth()) {
            $this->redirect('?/Wdmin/logOut');
        } else {
            $this->loadModel('mOrder');
            $this->Db->cache = false;
        }
    }

    /**
     * 订单导出
     * @param string $Q
     * @return null
     */
    public function order_exports($Q) {
        $stime = $Q->stime;
        $etime = $Q->etime;
        $otype = $Q->otype;
        if (!empty($stime) && !empty($etime)) {
            global $config;
            $express = include APP_PATH . 'config/express_code.php';
            if (strtotime($stime) > strtotime($etime)) {
                $tmp   = $stime;
                $stime = $etime;
                $etime = $tmp;
            }
            $where = "order_time >= '$stime' AND order_time <= '$etime'";
            if ($otype != '') {
                $where .= " AND status = '$otype'";
            }
            $orderList = $this->Dao->select('od.order_id,od.express_code,od.express_com,wepay_serial,od.serial_number,od.order_time,pd.product_id,pd.product_name,ods.product_count,ods.product_discount_price as product_price,od.order_expfee')
                ->from(TABLE_ORDERS_DETAILS)
                ->alias('ods')
                ->leftJoin(TABLE_ORDERS)
                ->alias('od')
                ->on("od.order_id = ods.order_id")
                ->leftJoin(TABLE_PRODUCTS)
                ->alias('pd')
                ->on("pd.product_id = ods.product_id")
                ->where($where)
                ->orderby('od.order_id')
                ->desc()
                ->exec();
            /**
             * 加工
             */
            foreach ($orderList as $index => $order) {
                // address
                $address                      = $this->Db->query("SELECT * FROM `orders_address` WHERE order_id = $order[order_id];");
                $orderList[$index]['address'] = $address[0];
                $orderList[$index]['expname'] = $express[$orderList[$index]['express_com']];
            }

            include APP_PATH . 'lib/PHPExcel/Classes/PHPExcel.php';

            include APP_PATH . 'lib/PHPExcel/Classes/PHPExcel/Writer/Excel2007.php';

            include APP_PATH . 'lib/PHPExcel/Classes/PHPExcel/Reader/Excel2007.php';

            $templateName = APP_PATH . 'exports/orders_export/order_exp_sample/sample_1.xlsx';

            $PHPReader = new PHPExcel_Reader_Excel2007();

            if (!$PHPReader->canRead($templateName)) {
                $PHPReader = new PHPExcel_Reader_Excel5();
                if (!$PHPReader->canRead($templateName)) {
                    echo '无法识别的Excel文件！';
                    return false;
                }
            }

            $PHPExcel = $PHPReader->load($templateName);

            header('Location: ' . $this->genXlsxFileType1($orderList, $PHPExcel, $PHPExcel->getActiveSheet(), 2));
        }
    }

    /**
     * @global array $config
     * @param array $data
     * @param object $PHPExcel
     * @param object $Sheet
     * @param int $offset
     * @param int $expType
     * @return null
     */
    private function genXlsxFileType1($data, $PHPExcel, $Sheet, $offset, $expType = 1) {
        global $config;

        $Sheet->getStyle('A1')
            ->getAlignment()
            ->setVertical(PHPExcel_Style_Alignment::VERTICAL_BOTTOM);

        foreach ($data as $index => $da) {

            $Sheet->setCellValueExplicit("A$offset", $da['wepay_serial'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("B$offset", $da['serial_number'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("C$offset", $da['order_time'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("D$offset", $da['address']['user_name'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("E$offset", $da['address']['address'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("F$offset", $da['address']['tel_number'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("G$offset", $da['product_id'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("H$offset", $da['product_name'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("I$offset", $da['product_count'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("J$offset", $da['product_price'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("K$offset", $da['product_price'] * $da['product_count'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("L$offset", $da['order_expfee'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("M$offset", $da['address']['postal_code'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("N$offset", $da['expname'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("O$offset", $da['express_code'], PHPExcel_Cell_DataType::TYPE_STRING);

            $offset++;
        }
        // 写入文件
        $objWriter = new PHPExcel_Writer_Excel2007($PHPExcel);
        $fileName  = date('Y-md') . '-' . $this->convName[$expType] . '-' . uniqid() . '.xlsx';
        $objWriter->save(APP_PATH . 'exports/orders_export/export_files/' . $fileName);
        return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://" . $_SERVER['HTTP_HOST'] . $config->shoproot . 'exports/orders_export/export_files/' . $fileName;
    }

    /**
     * 获取订单详情信息
     * @return null
     */
    public function getOrderInfo() {
        // 页码
        $id = $this->pGet('id');
        if ($id > 0) {
            global $config;
            $info                = $this->mOrder->GetOrderDetail($id, FALSE);
            $info['statusX']     = $config->orderStatus[$info['status']];
            $info['expressName'] = mOrder::getExpressCompanyName($info['express_com']);
            $this->echoMsg(0, $info);
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * 获取订单列表
     */
    public function getOrderList() {

        global $config;

        $this->Db->cache = false;

        // 页码
        $page = $this->pGet('page');
        // 订单状态
        $status = $this->pGet('status', 'all');
        // 页数
        $page_size = $this->pGet('page_size', 25);
        // 用户编号
        $uid = $this->pGet('uid', 0);
        // 搜索字段
        $serial_number = $this->pGet('serial_number', false);

        $express = include APP_PATH . 'config/express_code.php';

        $WHERE = ' order_id > 0 ';

        // where
        if ($status != 'all') {
            if ($status == 'canceled') {
                // 退货而且已经支付才需要审核，否则直接关闭订单
                $WHERE .= " AND status = '$status' AND wepay_serial <> '' ";
            } else {
                $WHERE .= " AND status = '$status' ";
            }
        }

        if ($uid > 0) {
            $WHERE .= " AND client_id = $uid ";
        }

        if ($serial_number) {
            $WHERE .= "AND `serial_number` LIKE '%$serial_number%' ";
        }

        // 如果商户id为0显示全部 有商户id则显示对应订单
        $supplier_id = $_SESSION['supplier_id'];

        if ($supplier_id) {
            $WHERE .= " AND `supplier_id` = $supplier_id ";
        } else {
            $WHERE .= " ";
        }

        $Limit = $page * $page_size . "," . $page_size;
        // 计算总数
        $count = $this->Db->getOne("SELECT COUNT(order_id) FROM `orders` WHERE $WHERE;");
        // 订单列表
        $orderList = $this->Dao->select()->from(TABLE_ORDERS)->where($WHERE)->orderby("order_id")->desc()->limit($Limit)->exec();

        if ($status == 'canceled') {
            foreach ($orderList as &$od) {
                if ($od['order_amount'] < 1) {
                    $od['refundable'] = $od['order_amount'];
                } else {
                    $od['refundable'] = $this->mOrder->getUnRefunded($od['order_id']);
                }
            }
        }

        /**
         * 加工
         */
        foreach ($orderList as $index => $order) {
            // address
            $orderList[$index]['address']     = $this->Db->getOneRow("SELECT user_name,tel_number,province,city FROM `orders_address` WHERE order_id = $order[order_id];");
            $orderList[$index]['order_time']  = $this->Util->dateTimeFormat($orderList[$index]['order_time']);
            $orderList[$index]['statusX']     = $config->orderStatus[$orderList[$index]['status']];
            $orderList[$index]['expressName'] = $express[$orderList[$index]['express_com']];
            // product info
            $orderList[$index]['data'] = $this->Db->getOneRow("SELECT catimg FROM `orders_detail` sd LEFT JOIN " . TABLE_PRODUCTS . " pi on pi.product_id = sd.product_id WHERE `sd`.order_id = " . $order['order_id']);
        }

        $data = array(
            'ret_code' => 0,
            'ret_msg' => array(
                'list' => $orderList,
                'count' => intval($count)
            )
        );

        $data = json_encode($data, JSON_UNESCAPED_UNICODE);

        $this->echoJsonRaw($data);
    }

    /**
     * 删除订单
     */
    public function deleteOrder() {
        $orderId = $this->pPost('order_id', false);
        if ($orderId > 0) {
            $this->loadModel('mOrder');
            if ($this->mOrder->deleteOrder($orderId)) {
                $this->echoMsg(0);
            } else {
                $this->echoMsg(-1, 'delete error');
            }
        } else {
            $this->echoMsg(-1, 'params error');
        }
    }

    /**
     * 获取订单分类统计数据
     */
    public function ajaxGetOrderStatnums() {
        $this->loadModel('SqlCached');
        // file cached
        $cacheKey  = 'ajaxGetOrderStatnum1s';
        $fileCache = new SqlCached();
        $ret       = $fileCache->get($cacheKey);
        // multi-supplier
        $supplier_id = $_SESSION['supplier_id'];
        if ($supplier_id) {
            $supplierquery  = " AND `supplier_id` = $supplier_id";
            $supplierWquery = " WHERE`supplier_id` = $supplier_id";
        } else {
            $supplierquery  = " ";
            $supplierWquery = " ";
        }
        if (-1 === $ret) {
            $status = array(
                'payed' => 0,
                'canceled' => 0,
                'delivering' => 0,
                'all' => 0,
                'unpay' => 0,
                'refunded' => 0,
                'received' => 0,
                'closed' => 0
            );
            foreach ($status as $key => &$value) {
                if ($key == 'all') {
                    $WHERE = $supplierWquery;
                } else {
                    $WHERE = " WHERE status = '$key' $supplierquery;";
                }
                $sql   = "select count(*) from `orders` $WHERE;";
                $ret   = $this->Db->getOne($sql);
                $value = intval($ret);
            }
            // 待退款订单
            $ret                 = $this->Db->getOne("select count(*) from `orders` WHERE status = 'canceled' AND `wepay_serial` <> '';");
            $status['refunding'] = intval($ret);
            $fileCache->set($cacheKey, $status);
            $this->echoJson($status);
        } else {
            $this->echoJson($ret);
        }
    }

    /**
     * 订单发货
     * @param int $orderId
     * @param string $expressCode
     * @param string $expressCompany
     * @param string $expressStaff
     */
    public function expressSend() {
        $tplconfig = include APP_PATH . 'config/config_msg_template.php';
        $tpl       = $tplconfig['exp_notify'];
        $this->loadModel('WechatSdk');
        $orderId        = intval($this->pPost('orderId'));
        $expressCode    = $this->pPost('expressCode');
        $expressCompany = $this->pPost('expressCompany');
        $expressStaff   = $this->post('expressStaff');

        if ($this->mOrder->despacthGood($orderId, $expressCode, $expressCompany)) {
            global $config;
            if (!empty($tpl['tpl_id'])) {
                // 快递公司列表
                $expressList = include APP_PATH . 'config/express_code.php';
                // 订单信息
                $orderData = $this->Dao->select("wepay_openid, serial_number")
                    ->from(TABLE_ORDERS)
                    ->where("order_id = $orderId")
                    ->getOneRow();
                // 微信模板消息提示
                if ($expressCompany == 'none' && !empty($expressStaff)) {
                    // 获取配送人员信息
                    $expStaff = $this->Dao->select('client_name, client_phone')
                        ->from(TABLE_USER)
                        ->where("client_wechat_openid = '$expressStaff'")
                        ->getOneRow();
                    // 更新订单信息
                    $this->Dao->update(TABLE_ORDERS)
                        ->set(array('express_openid' => $expStaff))
                        ->where("order_id = $orderId")
                        ->exec();
                    $expName = $expStaff['client_name'];
                    $expCode = $expStaff['client_phone'];
                } else {
                    // 正常快递派送
                    $expName = $expressList[$expressCompany];
                    $expCode = $expressCode;
                }

                // 消息参数
                $templateParams = [
                    $tpl['first_key'] => '您有一笔订单已发货',
                    $tpl['serial_key'] => $orderData['serial_number'],
                    $tpl['expname'] => $expName,
                    $tpl['expcode'] => $expCode,
                    $tpl['remark_key'] => '点击详情 随时查看订单状态'
                ];

                $url = $config->domain . "?/Uc/expressDetail/order_id=$orderId";

                Messager::sendTemplateMessage($tpl['tpl_id'], $orderData["wepay_openid"], $templateParams, $url);
                // 提示配送员
                if (!empty($expressStaff)) {
                    $templateParams[$tpl['first_key']] = '您有一笔订单需要进行派送处理';
                    Messager::sendTemplateMessage($tpl['tpl_id'], $expressStaff, $templateParams, $url . "&express=1");
                }
            }
            $this->echoSuccess();
        } else {
            $this->echoMsg(-1, '发货失败，参数错误');
        }
    }

    /**
     * 获取快递公司列表
     */
    public function getExpressCompanys() {
        $express         = include APP_PATH . 'config/express_code_prefix.php';
        $expressFormated = [];
        $expressEs       = $this->Dao->select("value")
            ->from('wshop_settings')
            ->where("`key` = 'expcompany'")
            ->getOne();
        $expressEs       = explode(',', $expressEs);
        foreach ($express as $k => &$od) {
            if (!in_array($k, $expressEs)) {
                unset($express[$k]);
            } else {
                $expressFormated[] = [
                    'code' => $k,
                    'name' => $od
                ];
            }
        }
        $this->echoMsg(0, $expressFormated);
    }

    /**
     * 获取快递人员列表
     */
    public function getExpressStaff() {
        $openid  = $this->getSetting('order_express_openid');
        $openids = explode(',', $openid);
        $exps    = $this->Dao->select("client_wechat_openid AS openid, client_name AS name")
            ->from(TABLE_USER)
            ->where("client_wechat_openid in ('" . implode("','", $openids) . "')")
            ->exec();
        $this->echoMsg(0, $exps);
    }

    /**
     * 获取快递人员列表
     */
    public function getExpressStaffHistroy() {
        $this->Dao->select('exps.openid, usr.client_name AS name')
            ->from(TABLE_EXPRESS_CECORD)->alias('exps');
        $list = $this->Dao->leftJoin(TABLE_USER)->alias('usr')
            ->on("usr.client_wechat_openid = exps.openid")
            ->groupby('exps.openid')
            ->desc()
            ->exec();
        $this->echoMsg(0, $list);
    }

    /**
     * 快递查询api
     * @see http://www.kuaidiapi.cn/
     * @param type $Query
     */
    public function ajaxLoadOrderExpress() {
        $this->Smarty->caching = false;
        $com                   = $this->pPost('com');
        $code                  = $this->pPost('code');
        if (!$this->Auth->checkAuth()) {
            $this->redirect('?/Wdmin/logOut');
        }
        $url = "http://www.kuaidiapi.cn/rest/?uid=23350&key=7614261fa71a4948ad73795e88d958af&order=$code&id=$com";
        $this->Smarty->assign('res', json_decode(Curl::get($url), true));
        $this->show('./views/wdminpage/orders/ajaxloadorderexpress.tpl');
    }

    /**
     * 退款记录
     */
    public function get_refund_record() {
        $this->Db->cache = false;
        // 页码
        $page     = $this->pPost('page', 0);
        $pagesize = $this->pPost('page_size', 30);
        // 搜索字段
        $serial_number = $this->pPost('serial_number', false);
        $count         = $this->Dao->select('')
            ->count()
            ->from(TABLE_REFUNDMENT)
            ->getOne();
        $this->Dao->select()
            ->from(TABLE_REFUNDMENT);
        if ($serial_number) {
            $this->Dao->where("serial_number LIKE '%$serial_number%'");
        }
        $list = $this->Dao->orderby('id')
            ->desc()
            ->limit($page * $pagesize, $pagesize)
            ->exec();
        $this->echoMsg(0, [
            'count' => intval($count),
            'list' => $list
        ]);
    }

    /**
     * 订单退款
     */
    public function refund() {
        $this->loadModel('mOrder');
        $refund_type   = $this->pPost('refund_type');
        $order_id      = $this->pPost('order_id');
        $wepay_method  = $this->pPost('paymethod');
        $refund_datas  = $this->pPost('refund_datas');
        $refund_amount = trim($this->pPost('refund_amount'));
        $orderInfo     = $this->mOrder->getOrderInfo($order_id);
        if ($order_id > 0 && $refund_amount > 0 && is_array($refund_datas)) {
            // 人工处理，不做网银退款
            if ($refund_type == 1 || $wepay_method == 2) {
                // 可退款金额
                $rAmount = $this->mOrder->getUnRefunded($order_id);
                // 已退款金额
                $rAmounted = $this->mOrder->getRefunded($order_id);
                if ($rAmount - $refund_amount <= 0) {
                    // 已经全部退款
                    $this->mOrder->updateOrderStatus($order_id, 'refunded', $rAmounted + $rAmount);
                } else {
                    // 部分退款
                    $this->mOrder->updateOrderStatus($order_id, 'canceled', $rAmounted + $refund_amount);
                }
                // 回加库存
                $this->mOrder->cutInstockPart($refund_datas);
                // 处理积分问题
                $this->mOrder->orderRefundCredit($order_id, $refund_amount);
                // 写入记录
                $this->mOrder->logRefundment($order_id, $orderInfo['serial_number'], $refund_amount, date("Ymdhis") . mt_rand(10, 99), $wepay_method, $refund_type);
                // 处理成功
                $this->echoSuccess();
            } else {
                // 网银退款
                try {
                    $this->refund_wepay($order_id, $refund_amount);
                    // 回加库存
                    $this->mOrder->cutInstockPart($refund_datas);
                    // 写入记录
                    $this->mOrder->logRefundment($order_id, $orderInfo['serial_number'], $refund_amount, $orderInfo['serial_number'] . '-' . $refund_amount, $wepay_method, $refund_type);
                    // 成功
                    $this->echoSuccess();
                } catch (Exception $ex) {
                    $this->echoMsg(-1, $ex->getMessage());
                }
            }
        } else {
            $this->echoMsg(-1, '参数错误');
        }
    }

    /**
     * 微信支付退款处理
     * @param $orderId
     * @param $amount
     */
    private function refund_wepay($orderId, $amount) {
        // 进行退款处理
        $ret = $this->mOrder->orderRefund($orderId, $amount);
        // 可退款金额
        $rAmount = $this->mOrder->getUnRefunded($orderId);
        // 已退款金额
        $rAmounted = $this->mOrder->getRefunded($orderId);
        if ($ret !== false) {
            if (isset($ret->return_code) && (string)$ret->return_code === 'SUCCESS') {
                // 申请已提交 进一步处理订单
                if ($rAmount == $amount) {
                    // 已经全部退款
                    $this->mOrder->updateOrderStatus($orderId, 'refunded', $rAmounted + $rAmount);
                } else {
                    // 部分退款
                    $this->mOrder->updateOrderStatus($orderId, 'canceled', $rAmounted + $amount);
                }
                // 处理积分问题
                $this->mOrder->orderRefundCredit($orderId, $amount);
                return true;
            } else {
                $this->log('微信支付退款失败 : ' . $ret->return_msg);
                throw new Exception($ret->return_msg);
            }
        } else {
            $this->log('微信支付退款失败 : 未知错误');
            throw new Exception('未知错误，请求失败');
        }
    }

    /**
     * 获取配送记录
     * @param $page
     * @param $pagesize
     */
    public function getExpressRecords() {

        // 页码
        $page     = $this->pGet('page', 0);
        $pagesize = $this->pGet('pagesize', 30);
        $wheres   = [];
        // 搜索字段
        $serial_number = $this->pGet('serial_number', false);
        if ($serial_number) {
            $wheres[] = "ods.serial_number LIKE '%$serial_number%'";
        }
        // 配送员
        $openid = $this->pGet('openid', false);
        if ($openid) {
            $wheres[] = "exps.openid = '$openid'";
        }
        $count = $this->Dao->select('')
            ->count()
            ->from(TABLE_EXPRESS_CECORD)->alias('exps')
            ->leftJoin(TABLE_ORDERS)->alias('ods')
            ->on("ods.order_id = exps.order_id")
            ->leftJoin(TABLE_USER)->alias('usr')
            ->on("usr.client_wechat_openid = exps.openid")
            ->where($wheres)
            ->getOne();
        $this->Dao->select('exps.*,ods.serial_number,ods.order_time,usr.client_head,usr.client_name')
            ->from(TABLE_EXPRESS_CECORD)->alias('exps');
        // 获取列表
        $list = $this->Dao->leftJoin(TABLE_ORDERS)->alias('ods')
            ->on("ods.order_id = exps.order_id")
            ->leftJoin(TABLE_USER)->alias('usr')
            ->on("usr.client_wechat_openid = exps.openid")
            ->where($wheres)
            ->orderby('exps.id')
            ->desc()
            ->limit($page * $pagesize, $pagesize)
            ->exec();
        $this->echoMsg(0, [
            'count' => intval($count),
            'list' => $list
        ]);

    }

    /**
     * 获取销售统计列表
     */
    public function getStatList() {

        global $config;

        $this->Db->cache = false;

        // 页码
        $page = $this->pGet('page');
        // 订单状态
        $status = $this->pGet('status', 'all');
        // 页数
        $page_size = $this->pGet('page_size', 30);
        // 用户编号
        $uid = $this->pGet('uid', 0);
        // 搜索字段
        $serial_number = $this->pGet('serial_number', false);
        $stime         = $this->pGet('stime', false);
        $etime         = $this->pGet('etime', false);
        $product       = $this->pGet('product', false);
        //$uname = $this->pGet('uname', false);

        $express = include APP_PATH . 'config/express_code.php';

        $WHERE = ' WHERE h.order_id > 0 ';

        // where
        if ($status != 'all') {
            if ($status == 'canceled') {
                // 退货而且已经支付才需要审核，否则直接关闭订单
                $WHERE .= " AND h.status = '$status' AND h.wepay_serial <> '' ";
            } else {
                $WHERE .= " AND h.status = '$status' ";
            }
        }

        if ($uid <> 0) {
            $WHERE .= " AND h.client_id in ( $uid ) ";
        }

        if ($serial_number) {
            $WHERE .= "AND h.serial_number LIKE '%$serial_number%' ";
        }

        if ($stime) {
            $WHERE .= "AND date_format(h.order_time,'%Y-%m-%d') >= '$stime' ";
        }

        if ($etime) {
            $WHERE .= "AND date_format(h.order_time,'%Y-%m-%d') <= '$etime' ";
        }
        $str = '';
        if ($product) {
            $WHERE .= "AND ( p.product_id in($product)) ";
            $str = " left join orders_detail l on h.order_id = l.order_id left join products_info p on l.product_id = p.product_id ";
        }

        $Limit = $page * $page_size . "," . $page_size;
        // 计算总数
        $count = $this->Db->getOne("SELECT IFNULL(COUNT(DISTINCT h.order_id),0) FROM orders h $str $WHERE;");
        //计算商品总数量
        $count1 = $this->Db->getOne("SELECT SUM(product_count) FROM orders_detail where order_id in(  SELECT DISTINCT h.order_id FROM orders h $str $WHERE );");
        // 计算总数
        $amount = $this->Db->getOne("SELECT IFNULL(SUM(order_amount),0) FROM orders where order_id in(  SELECT DISTINCT h.order_id FROM orders h $str $WHERE );");
        // 订单列表
        $orderList = $this->Db->query("SELECT * FROM orders where order_id in( SELECT DISTINCT h.order_id FROM orders h $str $WHERE ) ORDER BY order_id DESC LIMIT $Limit;");

        if ($status == 'canceled') {
            foreach ($orderList as &$od) {
                if ($od['order_amount'] < 1) {
                    $od['refundable'] = $od['order_amount'];
                } else {
                    $od['refundable'] = $this->mOrder->getUnRefunded($od['order_id']);
                }
            }
        }

        /**
         * 加工
         */
        foreach ($orderList as $index => $order) {
            // company
            if ($order['company_id'] > 0) {
                $orderList[$index]['company'] = $this->Db->getOneRow("SELECT `id`,`name` FROM `companys` WHERE `id` = $order[company_id];");
            }
            // address
            $address                          = $this->Db->query("SELECT * FROM `orders_address` WHERE order_id = $order[order_id];");
            $orderList[$index]['address']     = $address[0];
            $orderList[$index]['order_time']  = $this->Util->dateTimeFormat($orderList[$index]['order_time']);
            $orderList[$index]['statusX']     = $config->orderStatus[$orderList[$index]['status']];
            $orderList[$index]['expressName'] = $express[$orderList[$index]['express_com']];
            // product info
            $orderList[$index]['data'] = $this->Db->query("SELECT catimg,`pi`.product_name,`pi`.product_id,`sd`.product_count,`sd`.product_discount_price FROM `orders_detail` sd LEFT JOIN `vproductinfo` pi on pi.product_id = sd.product_id WHERE `sd`.order_id = " . $order['order_id']);
        }

        $this->echoMsg(0, array(
            'list' => $orderList,
            'count' => intval($count),
            'count1' => intval($count1),
            'amount' => $amount
        ));
    }

    /**
     * 获取历史地址数据
     * @throws Exception
     */
    public function getOrderAddresses() {
        $address = $this->Db->query("select * from orders_address where address IS NOT NULL AND address <> '' GROUP BY address ORDER BY tel_number DESC");
        $this->echoJson($address);
    }

    /**
     * 手动订单确认支付
     * @todo HOOK
     */
    public function orderPayed() {
        $orderId = $this->pPost('orderId');
        $this->mOrder->updateOrderStatus($orderId, OrderStatus::payed);
        $this->echoSuccess();
    }

}

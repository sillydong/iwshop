<?php

/**
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wUser extends ControllerAdmin {

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->Db->cache = false;
    }

    /**
     * ajax获取用户列表
     */
    public function getUserList($Query) {
        $this->loadModel('User');
        $gid      = $this->pGet('gid');
        $phone    = $this->pGet('phone');
		$cardno    = $this->pGet('cardno');
        $name     = urldecode($this->pGet('uname'));
        $page     = Util::digitDefault($this->pGet('page'), 0);
        $pagesize = Util::digitDefault($this->pGet('pagesize'), 30);

        $WHERE            = [];
        $WHERE['deleted'] = 0;

        $this->Dao->select('')
            ->count()
            ->from(TABLE_USER)
            ->where($WHERE);

        !empty($gid) && $WHERE['client_level'] = $gid;

        !empty($phone) && $this->Dao->aw("client_phone LIKE '%$phone%'");

        !empty($name) && $this->Dao->aw("client_name LIKE '%$name%'");

        $count = $this->Dao->getOne();

        $this->Dao->select()
            ->from(TABLE_USER)
            ->where($WHERE);

        !empty($gid) && $WHERE['client_level'] = $gid;

        !empty($phone) && $this->Dao->aw("client_phone LIKE '%$phone%'");

        !empty($name) && $this->Dao->aw("client_name LIKE '%$name%'");

        $list = $this->Dao->orderby('client_id')
            ->desc()
            ->limit($pagesize * $page, $pagesize)
            ->exec();

        $this->echoJson([
            'total' => intval($count),
            'list' => $list
        ]);
    }

    /**
     * 获取用户数量
     */
    public function getUserCount() {
        $count = $this->Dao->select('')
            ->count()
            ->from(TABLE_USER)
            ->where('`deleted` = 0')
            ->getOne();
        $this->echoMsg(0, $count);
    }

    /**
     * 获取用户分组
     */
    public function getUserLevel() {
        $this->loadModel('UserLevel');
        $list = $this->UserLevel->getList();
        $this->echoMsg(0, $list);
    }

    /**
     * 获取用户分组详情
     */
    public function getUserLevelInfo() {
        $id = $this->pGet('id');
        $this->loadModel('UserLevel');
        $info = $this->UserLevel->get($id);
        $this->echoMsg(0, $info);
    }

    /**
     * 编辑用户分组
     */
    public function alterUserLevelInfo() {
        $this->loadModel('UserLevel');
        $id = intval($this->post('id'));
        if ($id >= 0) {
            $ret = $this->UserLevel->addLevel($id, $this->post('level_name'), $this->post('level_credit'), $this->post('level_discount'), $this->post('level_credit_feed'), $this->post('remark'), 1);
        } else {
            $ret = $this->UserLevel->addLevel(false, $this->post('level_name'), $this->post('level_credit'), $this->post('level_discount'), $this->post('level_credit_feed'), $this->post('remark'), 1);
        }
        $this->echoMsg($ret ? 0 : -1);
    }

    /**
     * 删除用户分组
     */
    public function deleteLevel() {
        $this->loadModel('UserLevel');
        $id = intval($this->post('id'));
        try {
            $this->UserLevel->delete($id);
            $this->echoMsg(0);
        } catch (Exception $ex) {
            $this->echoMsg(-1, $ex->getMessage());
        }
    }

    /**
     * ajax删除用户
     */
    public function deleteUser() {
        $id = intval($this->post('id'));
        if ($id > 0) {
            $sql = "UPDATE `clients` SET `deleted` = 1 WHERE `client_id` = $id";
            if ($this->Db->query($sql)) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        }
    }

    /**
     * 获取用户信息
     */
    public function getUserInfo() {
        $id = intval($this->pGet('id'));
        if ($id > 0) {
            $ret = $this->Dao->select()
                ->from(TABLE_USER)
                ->where(['client_id' => $id])
                ->getOneRow();
            $this->echoMsg(0, $ret);
        } else {
            $this->echoFail();
        }
    }


    /**
     * ajax编辑用户 | 添加用户
     */
    public function alterUser() {
        $clientId = $this->pPost('client_id');
        $data     = $this->post();
        if ($clientId == 0) {
            $field                        = array();
            $values                       = array();
            $data['client_joindate']      = date('Y-m-d');
            $data['client_wechat_openid'] = hash('md4', uniqid() . time());
            foreach ($data as $key => $value) {
                $field[]  = $key;
                $values[] = $value;
            }
            if ($this->Dao->insert(TABLE_USER, implode(',', $field))
                ->values($values)
                ->exec()
            ) {
                $this->echoSuccess();
            } else {
                $this->log('新增会员失败,SQL:' . $this->Dao->getSQL());
                $this->echoFail();
            }
        } else {
            // 更新用户信息
            if ($this->Dao->update(TABLE_USER)
                ->set($data)
                ->where(['client_id' => $clientId])
                ->exec()
            ) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        }
    }

    /**
     * 用户导出
     * @param string $Q
     * @return null
     */
    public function user_exports($Q) {
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
            $where = "client_joindate >= '$stime' AND client_joindate <= '$etime'";
            if ($otype != '') {
                $where .= " AND client_level = '$otype'";
            }

            $orderList = $this->Dao->select('client_id,client_name,client_sex,client_phone,client_email,client_province,client_city,client_address,client_money,client_credit,client_joindate')
                ->from(TABLE_USER)
                ->alias('users')
                ->where($where)
                ->orderby('client_joindate')
                ->desc()
                ->exec();

            include APP_PATH . 'lib/PHPExcel/Classes/PHPExcel.php';

            include APP_PATH . 'lib/PHPExcel/Classes/PHPExcel/Writer/Excel2007.php';

            include APP_PATH . 'lib/PHPExcel/Classes/PHPExcel/Reader/Excel2007.php';

            $templateName = APP_PATH . 'exports/orders_export/order_exp_sample/sample_3.xlsx';

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

            $Sheet->setCellValueExplicit("A$offset", $da['client_name'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("B$offset", $da['client_sex'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("C$offset", $da['client_phone'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("D$offset", $da['client_email'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("E$offset", $da['client_id'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("F$offset", $da['client_joindate'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("G$offset", $da['client_province'] . "  " . $da['client_city'] . "  " . $da['client_address'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("H$offset", $da['client_money'], PHPExcel_Cell_DataType::TYPE_STRING);
            $Sheet->setCellValueExplicit("I$offset", $da['client_credit'], PHPExcel_Cell_DataType::TYPE_STRING);
            $offset++;
        }
        // 写入文件
        $objWriter = new PHPExcel_Writer_Excel2007($PHPExcel);
        $fileName  = date('Y-md') . '-' . $this->convName[$expType] . '-' . uniqid() . '.xlsx';
        $objWriter->save(APP_PATH . 'exports/orders_export/export_files/' . $fileName);
        return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://" . $_SERVER['HTTP_HOST'] . $config->shoproot . 'exports/orders_export/export_files/' . $fileName;
    }

    /**
     * 获取用户积分记录列表
     * @param int $page
     * @param string $key
     */
    public function getUserBalanceRecord() {
        $page = Util::digitDefault($this->pGet('page'), 0);
        $pagesize = Util::digitDefault($this->pGet('pagesize'), 30);
        if ($page >= 0 && $page <= 1000) {
            $total = $this->Dao->select('count(1)')->from(TABLE_USER_BALANCE_RECORD)->getOne();
            if ($total > 0) {
                $ret = $this->Dao->select('br.*,us.client_name,us.client_head,us.client_phone')
                    ->from(TABLE_USER_BALANCE_RECORD)->alias("br")
                    ->leftJoin(TABLE_USER)->alias('us')
                    ->on('us.client_id=br.uid')
                    ->orderby('id DESC')
                    ->limit($page * $pagesize, $pagesize)
                    ->exec();
            } else {
                $ret = [];
            }

            $this->echoMsg(0, [
                'total' => $total,
                'list' => $ret,
            ]);
        } else {
            $this->echoFail();
        }
    }

    /**
     * 获取用户积分记录列表
     * @param int $page
     * @param string $key
     */
    public function getUserCreditRecord() {
        $page = Util::digitDefault($this->pGet('page'),0);
        $pagesize=Util::digitDefault($this->pGet('pagesize'),30);
        if($page>=0 && $page<=1000){
            $total = $this->Dao->select('count(1)')->from(TABLE_USER_CREDIT_RECORD)->getOne();
            if($total>0){
                $ret = $this->Dao->select('cr.*,us.client_name,us.client_head,us.client_phone')
                    ->from(TABLE_USER_CREDIT_RECORD)->alias("cr")
                    ->leftJoin(TABLE_USER)->alias('us')
                    ->on('us.client_id=cr.uid')
                    ->orderby('id DESC')
                    ->limit($page * $pagesize, $pagesize)
                    ->exec();
                foreach ($ret as &$x){
                    switch($x['reltype']){
                        case 0:
                            $x['reltype']='下单';
                            break;
                        case 1:
                            $x['reltype']='签到';
                    }
                }
            }else{
                $ret=[];
            }
            
            $this->echoMsg(0,[
                'total'=>$total,
                'list'=>$ret,
            ]);
        }else{
            $this->echoFail();
        }
    }

}

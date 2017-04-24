<?php

/**
 * 返佣规则控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wRebate extends Controller
{

    const REBATED = 1;

    /**
     * 固定金额返佣
     */
    const REBATE_TYPE_AMOUNT = 'amount';

    /**
     * 固定比例返佣
     */
    const REBATE_TYPE_PERCENT = 'percent';

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        $this->loadModel('mRebate');
    }

    /**
     * 获取返佣历史数据
     * @param int $page
     * @param int $page_size
     */
    public function getRebateList() {

        // 页码
        $page = $this->pGet('page');
        // 页数
        $page_size = $this->pGet('page_size', 30);
        // 搜索字段
        $serial_number = $this->pGet('serial_number', false);
        // 状态
        $status = $this->pGet('status', false);

        $WHERE = ' WHERE id > 0 ';

        // 搜索参数
        if ($serial_number) {
            $serial_number = urldecode($serial_number);
            $WHERE .= "AND (`order_serial` LIKE '%$serial_number%' OR `comid` LIKE '%$serial_number%' OR `uid` LIKE '%$serial_number%') ";
        }

        if ($status && $status != 'all') {
            $WHERE .= "AND `status` = '$status' ";
        }

        $count = $this->Db->getOne("SELECT COUNT(order_id) FROM `" . TABLE_ORDER_REBATE . "` $WHERE;");

        $WHERE = str_replace('WHERE', '', $WHERE);

        // 订单列表
        $orderList = $this->Dao->select('rebate.*, us1.client_name as uname, us2.client_name as comname')
                               ->from(TABLE_ORDER_REBATE)
                               ->alias('rebate')
                               ->leftJoin(TABLE_USER)->alias('us1')
                               ->on('us1.client_id = rebate.uid')
                               ->leftJoin(TABLE_USER)->alias('us2')
                               ->on('us2.client_id = rebate.comid')
                               ->where($WHERE)
                               ->orderby('id')->desc()
                               ->limit($page * $page_size, $page_size)
                               ->exec();

        $this->echoMsg(0, array(
            'list' => $orderList,
            'count' => intval($count)
        ));

    }

    /**
     * 获取返佣规则
     * /?/wRebate/getRebateRules/
     */
    public function getRebateRules() {
        $list = $this->Dao->select()->from(TABLE_REBATE_RULES)->orderby('rebate_level')->asc()->exec();
        $this->echoJson($list);
    }

    /**
     * 进行返佣操作
     */
    public function checkRebate() {
        // 获取未处理的订单
        $this->loadModel('mCompany');
        // 只获取已完成的订单
        $orderList = $this->Dao->select()->from(TABLE_ORDERS)
                               ->where("company_id > 0 AND rebated = 0 AND wepayed = 1 AND status = 'received'")
                               ->limit(10)->exec(Db::NOCACHE);
        if ($orderList) {
            // 遍历订单数据
            foreach ($orderList as $order) {
                $orderId = $order['order_id'];
                // 已经返佣的金额
                $rebatedAmount = 0;
                if ($order['company_id'] > 0) {
                    // 获取上级代理数据
                    $companys = $this->getCompanys($order['company_id']);
                    if (sizeof($companys) > 0) {
                        $level = 1;
                        // 遍历代理数据，进行返佣操作
                        foreach ($companys as $company) {
                            // 匹配规则
                            $rebatedAmount += $this->doRebate($order, $company['uid'], $company['gid'], $level);
                            // 等级上升
                            $level++;
                        }
                    }
                }
                $this->doneRebate($orderId, $rebatedAmount);
            }
        }
    }

    /**
     * 获取上级代理数据
     * @param $companyId
     * @return array
     */
    private function getCompanys($companyId) {
        $companyId = intval($companyId);
        if ($companyId) {
            $array = [];
            // 遍历代理列表
            while ($company = $this->mCompany->getCompanyInfoByUID($companyId, 'id, uid, gid, name, email, phone, parent')) {
                if ($companyId == $company['parent']) {
                    // 如果代理是自己，跳出循环，避免死循环
                    break;
                } else {
                    $companyId = $company['parent'];
                }
                $array[] = $company;
            }
            return $array;
        } else {
            return [];
        }
    }

    /**
     * 返佣操作
     * @param $orderId
     * @param $orderAmount
     * @param $orderCount
     * @param $companyId
     * @param $level
     */
    private function doRebate($order, $companyId, $companyGid, $level) {
        $orderAmount = doubleval($order['order_amount']);
        $orderId     = intval($order['order_id']);
        $orderSerial = $order['serial_number'];
        $uid         = $order['client_id'];
        if ($orderAmount > 0) {

            // 查找返佣规则
            $rule = $this->Dao->select()->from(TABLE_REBATE_RULES)
                              ->where("enabled = 1 AND rebate_level = $level AND (level_id = $companyGid OR level_id = 0) AND rebate_amount > 0")
                              ->getOneRow(Db::NOCACHE);

            // 命中规则
            if ($rule) {
                $rebateAmount = 0;
                $rate         = doubleval($rule['rebate_amount']);
                if ($rule['rebate_type'] == wRebate::REBATE_TYPE_AMOUNT) {
                    // 固定金额
                    $rebateAmount = $rate;
                } else if ($rule['rebate_type'] == wRebate::REBATE_TYPE_PERCENT) {
                    // 固定比例
                    $rebateAmount = $orderAmount * $rate / 100;
                }
                // 写入返佣记录表

                $this->Dao->insert(TABLE_ORDER_REBATE, [
                    'uid',
                    'comid',
                    'order_id',
                    'order_serial',
                    'order_amount',
                    'order_time',
                    'rebate_amount',
                    'rebate_rate',
                    'rebate_type',
                    'rebate_level'
                ])->values([
                    $uid,
                    $companyId,
                    $orderId,
                    $orderSerial,
                    $orderAmount,
                    $order['order_time'],
                    $rebateAmount,
                    $rate,
                    $rule['rebate_type'],
                    $level
                ])->exec();

                echo $rule['level_name'] . " orderAmount: $orderAmount" . " rebated: " . $rebateAmount . " point: $rate" . PHP_EOL;

                Util::log($rule['level_name'] . " orderAmount: $orderAmount" . " rebated: " . $rebateAmount . " point: $rate");

                // 返回已经返佣的金额
                return $rebateAmount;
            }

        }
        return 0;
    }

    /**
     * 空返佣，不做处理
     * @param $orderId
     */
    private function doneRebate($orderId, $rebatedAmount) {
        $this->Dao->update(TABLE_ORDERS)->set([
            'rebated' => wRebate::REBATED,
            'rebated_amount' => doubleval($rebatedAmount)
        ])->where("order_id = $orderId")->exec();
    }

    /**
     * 编辑返佣规则
     */
    public function alterRuleInfo() {
        $data = $this->post();
        if (is_array($data)) {
            if (isset($data['$$hashKey'])) {
                unset($data['$$hashKey']);
            }
            if ($data['id'] == 0) {
                // 新建规则
                $ret = $this->Dao->insert(TABLE_REBATE_RULES, array_keys($data))->values(array_values($data))->exec();
            } else {
                $ret = $this->Dao->update(TABLE_REBATE_RULES)->set($data)->where("id = $data[id]")->exec();
            }
            if ($ret) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 删除返佣规则
     * @param int $id 规则编号
     */
    public function deleteRule() {
        $id = $this->pPost('id');
        $id = intval($id);
        if ($id > 0) {
            $this->echoMsg(0, $this->mRebate->delete($id));
        } else {
            $this->echoMsg(-1);
        }
    }

    /**
     * 审核通过返佣规则
     * /?/wRebate/comfirmRebate/
     * @params string $ids 编号数据
     */
    public function comfirmRebate() {
        $ids = $this->pPost('ids');
        if (!empty($ids)) {
            $ids = explode(',', $ids);
            foreach ($ids as $id) {
                $this->mRebate->confirm($id);
            }
        }
    }

    /**
     * 返佣审核操作
     * /?/wRebate/rebateCheck/
     */
    public function rebateCheck() {
        $id   = $this->pPost('id');
        $type = $this->pPost('type');
        if (!empty($id) && !empty($type)) {
            $id = intval($id);
            if ($type == 'pass') {
                $ret = $this->mRebate->confirm($id);
                // 返佣审核通过了
                if ($ret) {
                    $rebateData = $this->mRebate->get($id);
                    // 执行钩子
                    (new HookRebated($this))->deal($rebateData);
                }
            } else {
                $ret = $this->mRebate->reject($id);
            }
            if ($ret) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 获取返佣统计数据
     * /?/wRebate/getRebateCount/
     */
    public function getRebateCount() {
        $countUncheck = $this->Dao->select("COUNT(1)")->from(TABLE_ORDER_REBATE)->where("status = 'wait'")->getOne();
        $countChecked = $this->Dao->select("COUNT(1)")->from(TABLE_ORDER_REBATE)->where("status = 'pass'")->getOne();
        $countAll     = $this->Dao->select("COUNT(1)")->from(TABLE_ORDER_REBATE)->getOne();
        $this->echoJson([
            'check' => intval($countChecked),
            'uncheck' => intval($countUncheck),
            'all' => intval($countAll)
        ]);
    }

}
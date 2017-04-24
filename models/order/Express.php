<?php

/**
 * 快递配送模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Express extends Model {

    /**
     * 获取配送通知的openid列表
     * @return array
     */
    public function getExpressNotifyOpenids() {
        return explode(',', $this->getSetting('order_notify_openid'));
    }

    /**
     * 获取配送人员openid列表
     * @return array
     */
    public function getExpressStaffOpenids() {
        return explode(',', $this->getSetting('order_express_openid'));
    }

    /**
     * 获取快递编号列表
     * @return mixed
     */
    public function getExpressCodes() {
        return include APP_PATH . 'config/express_code.php';
    }

    /**
     * 获取快递编号列表 带前缀
     * @return mixed
     */
    public function getExpressCodesPrefixed() {
        return include APP_PATH . 'config/express_code_prefix.php';
    }

    /**
     * 写入配送记录
     * @param $orderId
     * @param $expressOpenid
     * @param $sendTime
     */
    public function setExpressRecord($orderId, $expressOpenid, $sendTime = false) {
        $now = time();
        $arr = $now - strtotime($sendTime);
        return $this->Dao->insert(TABLE_EXPRESS_CECORD, 'order_id, confirm_time, send_time, costs, openid')
                         ->values([
                             $orderId,
                             'NOW()',
                             $sendTime,
                             $this->sec2time($arr),
                             $expressOpenid
                         ])
                         ->exec();
    }

    /**
     * 格式化日期
     * @param $sec
     * @return string
     */
    private function sec2time($sec) {
        $sec = round($sec / 60);
        if ($sec >= 60) {
            $hour = floor($sec / 60);
            $min  = $sec % 60;
            $res  = $hour . ' 小时 ';
            $min != 0 && $res .= $min . ' 分';
        } else {
            $res = $sec . ' 分钟';
        }
        return $res;
    }

}
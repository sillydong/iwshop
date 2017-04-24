<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 店铺统计
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class WdminStat extends ControllerAdmin
{

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
     * 更新微信统计数据
     */
    public function update_wechat_stat() {
        $this->loadModel('StatOverView');
        $this->StatOverView->getWechatSummary();
    }

    /**
     * 检查是否需要更新微信统计数据
     */
    public function check_wechat_stat_status() {
        if (APPID == "__APPID__" || APPID == "" || APPSECRET == '__APPSECRET__' || APPSECRET == "") {
            // 不需要
            $this->echoMsg(1);
        } else {
            // 获取总数
            $tcount = $this->Dao->select('')
                                ->count()
                                ->from(TABLE_USER_CUMULATE)
                                ->getOne(false);
            // 最新日期
            $datelast = date('Y-m-d', strtotime("-1 day"));
            // 接口最终日期
            if ($tcount > 0) {
                // 获取统计最新日期
                $datendStr = $this->Dao->select('ref_date')
                                       ->from(TABLE_USER_CUMULATE)
                                       ->orderby('ref_date')
                                       ->desc()
                                       ->getOne(false);
                if ($datendStr == $datelast) {
                    // 不需要
                    $this->echoMsg(1);
                } else {
                    // 需要
                    $this->echoMsg(0, 1);
                }
            } else {
                // 需要
                $this->echoMsg(0, 2);
            }
        }
    }

    //put your code here
    public function getSaleStat($Query) {
        $comWhere   = isset($Query->com) ? ' AND company_id <> 0' : '';
        $dateEnd    = date('Y-m-d');
        $dateFrom   = date('Y-m-d', strtotime('-30 day'));
        $fileCached = new SqlCached();
        $mKey       = hash('md4', $dateEnd . $dateFrom . $comWhere);

        $data = $fileCached->get($mKey, 30);
        if (-1 === $data) {

            $data_salerecordtd = $this->Db->query("select order_time,SUM(order_amount) as order_amount " . "from orders " . "WHERE (`status` = 'payed' OR `status` = 'received' OR `status` = 'delivering') " . "AND order_amount <> '0' " . "AND `order_time` >= '$dateFrom' " . "AND `order_time` <= '$dateEnd'$comWhere" . "GROUP BY DATE_FORMAT(`order_time`,'%Y-%m-%d') " . "ORDER BY `order_time` ASC;");
            $data              = array();
            foreach ($data_salerecordtd as $_record) {
                $_date                = date("n-d", strtotime($_record['order_time']));
                $data[(string)$_date] = floatval($_record['order_amount']);
            }

            $fileCached->set($mKey, $data);
        }
        $this->echoJson($data);
    }

    public function getSalePercent($Query) {
        $com        = isset($Query->com);
        $QueryMonth = isset($_GET['date']) ? $_GET['date'] : date("Y-m");
        if (!$com) {
            $Sd = $this->Db->query("select pc.cat_name AS name,SUM(od.product_count) AS `count` from orders_detail od LEFT JOIN products_info pi on pi.product_id = od.product_id LEFT JOIN product_category pc on pc.cat_id = pi.product_cat
            LEFT JOIN orders ods ON ods.order_id = od.order_id
            WHERE DATE_FORMAT(ods.order_time,'%Y-%m') = '$QueryMonth'
            GROUP BY pi.product_cat");
        } else {
            $Sd = $this->Db->query("select COALESCE(com.`name`,'非代理') AS name,SUM(product_count) AS `count` from orders ods LEFT JOIN companys com on com.id = ods.company_id WHERE com.deleted = 0 AND com.verifed = 1 AND DATE_FORMAT(ods.order_time,'%Y-%m') = '$QueryMonth' GROUP BY com.id");
        }
        $r = array();
        $c = count($Sd);
        foreach ($Sd as $index => $s) {
            if ($s['name'] != '' && !empty($s['name'])) {
                $t = array(
                    $s['name'],
                    intval($s['count'])
                );
                $r[] = $t;
            }
        }
        $this->echoJson($r);
    }

    public function getHotSaleProduct() {
        $QueryMonth = isset($_GET['date']) ? $_GET['date'] : date("Y-m");
        $Sd         = $this->Db->query("select pi.product_name,SUM(od.product_count) AS `count` from orders_detail od LEFT JOIN products_info pi on pi.product_id = od.product_id LEFT JOIN orders ods on ods.order_id = od.order_id WHERE DATE_FORMAT(ods.order_time,'%Y-%m') = '$QueryMonth' GROUP BY od.product_id ORDER BY `count` DESC LIMIT 10");
        $r          = array();
        foreach ($Sd as $s) {
            $r[] = array(
                'name' => $s['product_name'],
                'value' => intval($s['count'])
            );
        }
        $this->echoJson($r);
    }

    /**
     * 获取用户统计数据
     * @todo cache
     * @param type $Q
     */
    public function getUserStat($Q) {
        $limit   = 28;
        $control = $Q->control;
        if (!$control) {
            $control = 'new_user'; //报表中心-》用户分析 暂时使用 by zmq 2016-01-30
        }
        if ($control == 'new_user' || $control == 'cancel_user') {
            $fields = "SUM(`$control`) AS `$control`";
        } else {
            $fields = 'SUM(new_user) AS new_user, SUM(cancel_user) AS cancel_user';
        }
        $data = $this->Dao->select("ref_date, $fields")
                          ->from(TABLE_USER_SUMMARY)
                          ->groupby('ref_date')
                          ->orderby('ref_date')
                          ->desc()
                          ->limit($limit)
                          ->exec();
        $data = array_reverse($data);
        $r    = array();
        if ($control == 'new_user' || $control == 'cancel_user') {
            foreach ($data as $s) {
                $r['x'][] = $s['ref_date'];
                $r['y'][] = intval($s[$control]);
            }
        }
        if ($control == 'pure_user') {
            foreach ($data as $s) {
                $r['x'][] = $s['ref_date'];
                $r['y'][] = intval($s['new_user'] - $s['cancel_user']);
            }
        }
        if ($control == 'cumulate_user') {
            $data = $this->Dao->select()
                              ->from(TABLE_USER_CUMULATE)
                              ->orderby('ref_date')
                              ->desc()
                              ->limit($limit)
                              ->exec();
            $data = array_reverse($data);
            foreach ($data as $s) {
                $r['x'][] = $s['ref_date'];
                $r['y'][] = intval($s['cumulate_user']);
            }
        }
        $this->echoJson($r);
    }

    /**
     * 获取性别比例
     */
    public function getUserSexPercent() {
        $Sd = $this->Db->query("select client_sex,COUNT(*) AS `count` FROM clients GROUP BY client_sex;");
        $r  = array();
        $x  = array(
            'm' => '男',
            'f' => '女',
            '' => '未知'
        );
        foreach ($Sd as &$s) {
            if (array_key_exists((string)$s['client_sex'], $x)) {
                $r[] = array(
                    $x[(string)$s['client_sex']],
                    intval($s['count'])
                );
            }
        }
        $this->echoJson($r);
    }

    public function getHotBuyUser() {
        $QueryMonth = isset($_GET['date']) ? $_GET['date'] : date("Y-m");
        $Sd         = $this->Db->query("select `client_name` AS `name`,SUM(ods.order_amount) AS `count` from orders ods LEFT JOIN clients cs on cs.client_id = ods.client_id WHERE (ods.`status` = 'payed' OR ods.`status` = 'received' OR ods.`status` = 'delivering') AND DATE_FORMAT(`order_time`,'%Y-%m') = '$QueryMonth' GROUP BY ods.client_id ORDER BY `count` DESC LIMIT 5;");
        $r          = array();
        foreach ($Sd as $s) {
            if (empty($s['name'])) {
                continue;
            }
            $r['x'][] = $s['name'];
            $r['y'][] = floatval($s['count']);
        }
        $this->echoJson($r);
    }

    public function getCompanyUserPercent() {
        $Sd = $this->Db->query("SELECT
                COUNT(clients.client_id) AS `count`,
                companys.`name`
        FROM
                clients
        LEFT JOIN companys ON companys.id = clients.client_comid
        WHERE
                companys.deleted = 0
        AND companys.verifed = 1
        GROUP BY
                clients.client_comid
        ORDER BY
                `count` DESC;");
        $r  = array();
        foreach ($Sd as $s) {
            if ($s['count'] > 0) {
                $r[] = array(
                    $s['name'],
                    intval($s['count'])
                );
            }
        }
        $this->echoJson($r);
    }

}

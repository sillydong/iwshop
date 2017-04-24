<?php

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class mProductSpec extends Model
{

    /**
     *
     * @param type $id
     * @param type $spec_name
     * @param type $spec_remark
     * @param type $dets
     * @return boolean
     */
    public function alterSpec($id, $spec_name, $spec_remark, $dets, $append = false) {
        # $this->Db->debug = true;
        if (empty($id)) {
            $id   = 'NULL';
            $SQL1 = "INSERT INTO `wshop_spec` (`spec_name`,`spec_remark`) VALUES ('$spec_name','$spec_remark');";
        } else {
            $id = intval($id);
            if ($id <= 0) {
                return false;
            }
            $SQL1 = "REPLACE INTO `wshop_spec` (`id`,`spec_name`,`spec_remark`) VALUES ($id,'$spec_name','$spec_remark');";
        }

        // bug!

        if ($id == 'NULL') {
            $id = $this->Db->query($SQL1);
            // 如果重名，追加内容
            if (!$id) {
                $id = intval($this->Db->getOne("SELECT id FROM `wshop_spec` WHERE `spec_name` = '$spec_name' AND `spec_remark` = '$spec_remark' LIMIT 1;"));
            }
        } else {
            $this->Db->query($SQL1);
        }

        if ($id !== false) {
            $ids = array();
            if (!$append) {
                // 追加模式
                $this->Db->query("DELETE FROM `wshop_spec_det` WHERE spec_id = $id;");
            }
            foreach ($dets as &$det) {
                if (empty($det['id'])) {
                    $det['id'] = 'NULL';
                }
                if ($det['name'] != '') {
                    array_push($ids, $this->Db->query("INSERT INTO `wshop_spec_det` (`id`,`spec_id`,`det_name`,`det_sort`) VALUES ($det[id], $id, '$det[name]', $det[sort]);"));
                }
            }
            return $id . '-' . implode('-', $ids);
        } else {
            return false;
        }
    }

    /**
     * 获取规格列表
     */
    public function getSpecList() {
        $ret = $this->Db->query("SELECT * FROM `wshop_spec`;");
        foreach ($ret as &$spec) {
            $spec['dets'] = $this->Db->query("SELECT * FROM `wshop_spec_det` WHERE `spec_id` = $spec[id];");
        }
        return $ret;
    }

    /**
     * 获取单个规格信息
     * @param type $id
     * @return boolean
     */
    public function getSpecData($id) {
        if (!empty($id) && is_numeric($id)) {
            $ret = $this->Db->getOneRow("SELECT * FROM `wshop_spec` WHERE `id` = $id;");
            if ($ret) {
                $ret['dets'] = $this->Db->query("SELECT * FROM `wshop_spec_det` WHERE `spec_id` = $id;");
                return $ret;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 获取商品规格名
     * @param type $id
     * @return type
     */
    public function getProductSpecName($id) {
        $r1 = $this->Dao->select()
                        ->from('product_spec')
                        ->where("id = $id")
                        ->getOneRow();
        $r2 = $this->Dao->select()
                        ->from('wshop_spec_det')
                        ->where("id = " . $r1['spec_det_id1'])
                        ->getOneRow();
        $r3 = $this->Dao->select()
                        ->from('wshop_spec_det')
                        ->where("id = " . $r1['spec_det_id2'])
                        ->getOneRow();
        $r4 = $this->Dao->select()
                        ->from('wshop_spec')
                        ->where("id = " . $r2['spec_id'])
                        ->getOneRow();
        return $r4['spec_name'] . '(' . $r2['det_name'] . $r3['det_name'] . ')';
    }

    /**
     * 获取商品规格信息
     * 包括价格、库存
     * @param $product_id
     * @param $spec_id
     * @todo 使用连表查询优化性能
     */
    public function getProductSpecInfo($product_id, $spec_id) {
        global $config;
        $return = [
            'specname' => '',
            'sale_price' => 0.00,
            'market_price' => 0.00,
            'instock' => 0
        ];
        if ($spec_id > 0 && $product_id > 0) {

            $r1 = $this->Dao->select()
                            ->from('product_spec')
                            ->where("id = $spec_id")
                            ->getOneRow();
            $r2 = $this->Dao->select()
                            ->from('wshop_spec_det')
                            ->where("id = " . $r1['spec_det_id1'])
                            ->getOneRow();
            $r3 = $this->Dao->select()
                            ->from('wshop_spec_det')
                            ->where("id = " . $r1['spec_det_id2'])
                            ->getOneRow();
            $r4 = $this->Dao->select()
                            ->from('wshop_spec')
                            ->where("id = " . $r2['spec_id'])
                            ->getOneRow();

            $return['specname']     = $r4['spec_name'] . '(' . $r2['det_name'] . $r3['det_name'] . ')';
            $return['sale_price']   = floatval($r1['sale_price']);
            $return['market_price'] = floatval($r1['market_price']);
            $return['instock']      = intval($r1['instock']);

        } else {
            // 如果spec_id为0，那就是没有设置规格，返回普通商品信息
            $productInfo            = $this->Product->getProductInfoSimple($product_id, false);
            $return['specname']     = $config->default_spec_name;
            $return['sale_price']   = $productInfo['sell_price'];
            $return['market_price'] = $productInfo['market_price'];
            $return['instock']      = $productInfo['product_instock'];
        }

        return $return;
    }

}

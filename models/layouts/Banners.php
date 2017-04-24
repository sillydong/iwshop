<?php

/**
 * 滚动广告模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Banners extends Model {

    /**
     * banner 增删改
     * @param type $id
     * @param type $bname
     *
     * @param tinyiny $bposition = 0 首页顶部位置
     * @param tinyiny $bposition = 1 首页底部位置
     *
     * @param tinyint $reltype = 0 链接到某分类
     * @param tinyint $reltype = 1 链接到商品池
     * @param tinyint $reltype = 2 链接到图文
     *
     * @param type $bimg
     * @param type $relid
     */
    public function modiBanner($id, $bname = '', $bimg = '', $bposition = 0, $reltype = 0, $relid = false, $sort = 0, $href = '#', $exp = '') {
        $id = intval($id);
        if ($exp == '') {
            $exp = 'NULL';
        }
        if ($id > 0) {
            $oldData = $this->getOne($id);
            // 编辑
            $r = $this->Dao->update(TABLE_BANNERS)
                           ->set(array(
                               'banner_name' => $bname,
                               'banner_href' => $href,
                               'banner_image' => $bimg,
                               'banner_position' => $bposition,
                               'relid' => $relid,
                               'reltype' => $reltype,
                               'sort' => $sort,
                               'exp' => $exp
                           ))
                           ->where("id=$id")
                           ->exec();
            if ($r) {
                if ($oldData['banner_image'] != $bimg) {
                    // 删除旧图片
                    @unlink(dirname(__FILE__) . "/../uploads/banner/" . $oldData['banner_image']);
                }
            }
            return $r;
        } else if ($id < 0) {
            // 删除
            $id = abs($id);
            return $this->Dao->delete()
                             ->from(TABLE_BANNERS)
                             ->where("id=$id")
                             ->exec() > 0;
        } else if ($id == 0 || !$id) {
            // 添加
            return $this->Dao->insert(TABLE_BANNERS, 'banner_name,banner_href,banner_image,banner_position,reltype,relid,sort,exp')
                             ->values(array(
                                 $bname,
                                 $href,
                                 $bimg,
                                 $bposition,
                                 $reltype,
                                 $relid,
                                 $sort,
                                 $exp
                             ))
                             ->exec();
        } else {
            return false;
        }
    }

    /**
     * 获取所有首页banner
     * @return type
     */
    public function getBanners($position = -1, $limit = 1000) {
        if ($position >= 0) {
            $banner = $this->Dao->select()
                                ->from(TABLE_BANNERS)
                                ->where("banner_position=$position")
                                ->aw("(`exp` > CURRENT_DATE() OR (`exp` IS NULL OR `exp` = '' OR `exp` = '0000-00-00 00:00:00'))")
                                ->orderby('sort')
                                ->desc()
                                ->limit($limit)
                                ->exec();
        } else {
            $banner = $this->Dao->select()
                                ->from(TABLE_BANNERS)
                                ->orderby('sort')
                                ->desc()
                                ->limit($limit)
                                ->exec();
        }
        foreach ($banner as &$b) {
            switch ($b['reltype']) {
                case 0:
                    $b['link'] = '?/vProduct/view_list/cat=' . $b['relid'];
                    break;
                case 1:
                    if (strpos(',', $b['relid']) !== -1) {
                        $b['link'] = '?/vProduct/view_list/in=' . $b['relid'] . '&showwxpaytitle=1';
                    } else {
                        $b['link'] = '?/vProduct/view/id=' . $b['relid'];
                    }
                    break;
                case 2:
                    $b['link'] = '?/Gmess/view/id=' . $b['relid'];
                    break;
                case 3:
                    $b['link'] = $b['banner_href'];
            }
        }
        return $banner;
    }

    /**
     * 获取指定ID的banner
     * @return type
     */
    public function gets($in, $limit = 1000) {
        if ($in != '') {
            $banner = $this->Dao->select()
                ->from(TABLE_BANNERS)
                ->where("id IN ($in) ")
                ->aw("(`exp` > CURRENT_DATE() OR (`exp` IS NULL OR `exp` = '' OR `exp` = '0000-00-00 00:00:00'))")
                ->orderby('sort')
                ->desc()
                ->limit($limit)
                ->exec();
        } else {
            $banner = $this->Dao->select()
                ->from(TABLE_BANNERS)
                ->orderby('sort')
                ->desc()
                ->limit($limit)
                ->exec();
        }
        foreach ($banner as &$b) {
            switch ($b['reltype']) {
                case 0:
                    $b['link'] = '?/vProduct/view_list/cat=' . $b['relid'];
                    break;
                case 1:
                    if (strpos(',', $b['relid']) !== -1) {
                        $b['link'] = '?/vProduct/view_list/in=' . $b['relid'] . '&showwxpaytitle=1';
                    } else {
                        $b['link'] = '?/vProduct/view/id=' . $b['relid'];
                    }
                    break;
                case 2:
                    $b['link'] = '?/Gmess/view/id=' . $b['relid'];
                    break;
                case 3:
                    $b['link'] = $b['banner_href'];
            }
        }
        return $banner;
    }



    /**
     *
     * @param type $id
     * @return type
     */
    public function getOne($id) {
        return $this->Dao->select()
                         ->from(TABLE_BANNERS)
                         ->where("id=$id")
                         ->getOneRow();
    }

}

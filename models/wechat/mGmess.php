<?php

if (!defined('APP_PATH')) {
    exit(0);
}

/**
 * 素材管理控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class mGmess extends Model {

    /**
     * 编辑素材内容
     * @param int $msgId
     * @param type $title
     * @param type $content
     * @param type $desc
     * @param type $thumbMediaId
     * @param string $content_source_url 原文链接
     * @param type $category
     */
    public function alterGmess($msgId, $title, $content, $desc, $catImg, $thumbMediaId = '', $content_source_url, $media_id = 0) {
        $desc    = addslashes($desc);
        $content = addslashes($content);
        if ($msgId > 0) {
            // 修改素材
            return $this->Dao->update(TABLE_GMESS)
                ->set(array(
                    'title' => $title,
                    'content' => $content,
                    'desc' => $desc,
                    'catimg' => $catImg,
                    'thumb_media_id' => $thumbMediaId,
                    'create_time' => date("Y-m-d H:i:s"),
                    'media_id' => $media_id,
                    'content_source_url' => $content_source_url
                ))->where('id', $msgId)->exec();
        } else {
            // 插入数据
            return $this->Dao->insert(TABLE_GMESS, explode(', ', 'title, content, desc, catimg, create_time, media_id, thumb_media_id, content_source_url'))
                ->values([$title,
                          $content,
                          $desc,
                          $catImg,
                          date("Y-m-d H:i:s"),
                          $media_id,
                          $thumbMediaId,
                          $content_source_url])
                ->exec();
        }
    }

    /**
     * 获取素材分类
     * @param type $parent
     * @return type
     */
    public function getGmessCategory($parent = 0) {
        $SQL = "SELECT `cat_name` AS `name`,`id` AS `dataId` FROM `gmess_category` WHERE `parent` = $parent ORDER BY sort DESC;";
        $Lst = $this->Db->query($SQL, false);
        foreach ($Lst as &$l) {
            $l['dataId']      = intval($l['dataId']);
            $l['children']    = $this->getGmessCategory($l['dataId']);
            $l['open']        = 'true';
            $l['hasChildren'] = count($l['children']) > 0;
        }
        return $Lst;
    }

    /**
     * 获取素材列表
     * @global type $config
     * @return type
     */
    public function getGmessList($page = 0, $limit = 20, $keyword = '', $cache = true) {
        $limit = sprintf("%s, %s", $page * $limit, $limit);
        $where = '`deleted` = 0';
        if (!empty($keyword)) {
            $keyword = urldecode($keyword);
            $where .= " AND (title LIKE '%$keyword%' OR `desc` LIKE '%$keyword%')";
            echo $where;
        }
        $this->Db->cache = $cache;
        $list            = $this->Db->query("SELECT id,title,`desc`,catimg,createtime,media_id FROM `gmess_page` WHERE $where ORDER BY `id` DESC LIMIT $limit;");
        $root            = $this->Util->getROOT();
        foreach ($list as &$l) {
            $l['href'] = $root . "?/Gmess/view/id=" . $l['id'];
            if (!stristr($l['catimg'], 'http') && !stristr($l['catimg'], 'iwshop')) {
                $l['catimg'] = $root . 'uploads/gmess/' . $l['catimg'];
            }
        }
        return $list;
    }

    /**
     * 获取素材总数
     * @return int
     */
    public function getGmessCount() {
        $count = $this->Dao->select('COUNT(1)')->from(TABLE_GMESS)->where('deleted = 0')->getOne(false);
        return intval($count);
    }

    /**
     * 获取素材
     * @param type $id
     * @return type
     */
    public function getGmess($id) {
        return $this->Db->getOneRow("SELECT * FROM `gmess_page` WHERE `id` = $id;");
    }

    /**
     * 删除群发素材
     * @param type $id
     * @return type
     */
    public function deleteGmess($id) {
        $oldData = $this->getGmess($id);
        if (is_file(dirname(__FILE__) . '/../uploads/gmess/' . $oldData['catimg'])) {
            @unlink(dirname(__FILE__) . '/../uploads/gmess/' . $oldData['catimg']);
        }
        $ret = $this->Db->query("UPDATE `gmess_page` SET `deleted` = 1 WHERE `id` = $id;");
        if ($ret) {
            // 删除页面缓存
            $this->Smarty->clearAllCache();
            return true;
        }
        return false;
    }

}

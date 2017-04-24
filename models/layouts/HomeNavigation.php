<?php

/**
 * 首页导航
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      张大蛤 <87500127@qq.com>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class HomeNavigation extends Model {

    /**
     * 获取首页板块列表
     * @return type
     */
    public function gets() {
        return $this->Dao->select()
            ->from(TABLE_HOME_NAV)
            ->orderby('`sort` ASC')
            ->exec();
    }

    /**
     * 返回导航
     */
    public function getNav() {
        $nav = $this->Dao->select()
            ->from(TABLE_HOME_NAV)
            ->orderby('`sort` ASC')
            ->exec();
        for ($i = 0; $i < count($nav); $i++) {
            if ($nav[$i]['nav_type'] == 1) {
                // 商品分类
                $nav[$i]['nav_content'] = "/?/vProduct/view_list/cat=" . $nav[$i]['nav_content'];
            }
        }

        return $nav;
    }

}

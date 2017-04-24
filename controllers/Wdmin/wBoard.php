<?php

/**
 * 用户反馈管理
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wBoard extends ControllerAdmin {

    /**
     * 权限检查
     * @param string $ControllerName
     * @param string $Action
     * @param string $QueryString
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
     * 获取店铺公告列表
     * @param int $page 页码
     * @param int $pageszie 页数
     */
    public function getList() {
        $page     = Util::digitDefault($this->pGet('page'), 0);
        $pagesize = Util::digitDefault($this->pGet('pagesize'), 50);
        if ($page >= 0 && $page <= 1000) {
            // 计算总数
            $total = $this->Dao->select('count(id)')
                               ->from(TABLE_BOARDS)
                               ->getOne();
            $ret   = $this->Dao->select()
                               ->from(TABLE_BOARDS)
                               ->limit($page * $pagesize, $page)
                               ->orderby('id DESC')
                               ->exec();
            $this->echoMsg(0, [
                'total' => $total,
                'list' => $ret
            ]);
        } else {
            $this->echoFail();
        }
    }

    /**
     * 添加店铺公告
     * @param string $title 标题
     * @param string $content 内容
     */
    public function addBoard() {
        $title   = $this->pPost('title');
        $content = $this->pPost('content');
        if (!empty($title) && !empty($content)) {
            if ($this->Dao->insert(TABLE_BOARDS, 'title, content, mtime')
                          ->values([
                                  $title,
                                  $content,
                                  date('Y-m-d H:i:s')
                              ])
                          ->exec()
            ) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 删除店铺公告
     * @param int $id 编号
     */
    public function deleteBoard() {
        $id = $this->pPost('id');
        if ($id > 0) {
            if ($this->Dao->delete()
                          ->from(TABLE_BOARDS)
                          ->where("id = $id")
                          ->exec()
            ) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

}
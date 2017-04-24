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
class wFeedBack extends ControllerAdmin {

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
     * 获取用户反馈列表
     * @param int $page 页码
     * @param int $pageszie 页数
     */
    public function getList() {
        $page     = Util::digitDefault($this->pGet('page'), 0);
        $pagesize = Util::digitDefault($this->pGet('pagesize'), 30);
        if ($page >= 0 && $page <= 1000) {
            // 计算总数
            $total = $this->Dao->select('count(id)')
                               ->from(TABLE_USER_FEEDBACK)
                               ->getOne();
            // 获取列表
            $ret = $this->Dao->select('fb.*, us.client_name, us.client_head, us.client_phone')
                             ->from(TABLE_USER_FEEDBACK)
                             ->alias('fb')
                             ->leftJoin(TABLE_USER)
                             ->alias('us')
                             ->on('us.client_id = fb.uid')
                             ->orderby('id DESC')
                             ->limit($page * $pagesize, $pagesize)
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
     * 删除用户反馈
     */
    public function deleteFeedBack() {
        $id = $this->pPost('id');
        if ($id > 0) {
            if ($this->Dao->delete()
                          ->from(TABLE_USER_FEEDBACK)
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
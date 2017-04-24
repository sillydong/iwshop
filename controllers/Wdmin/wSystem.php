<?php

/**
 * 系统控制器
 */
class wSystem extends ControllerAdmin
{

    const TPL = './views/wdminpage/';

    public function logs() {
        $this->show(self::TPL . 'system/logs.tpl');
    }

    /**
     *
     */
    public function getSystemLogs() {
        $pagesize = $this->pGet('pagesize') ? intval($this->pGet('pagesize')) : 30;
        $page     = $this->pGet('page');

        $list  = $this->Dao->select()->from(TABLE_LOGS)->orderby('id')->desc()->limit($page * $pagesize, $pagesize)->exec();
        $count = $this->Dao->select('count(1)')->from(TABLE_LOGS)->getOne();

        $this->echoJson([
            'list' => $list,
            'total' => intval($count)
        ]);

    }

}
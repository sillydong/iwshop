<?php

/**
 * common控制器
 */
class wCommon extends ControllerAdmin
{

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
    }

    public function error404() {
        $this->show();
    }

    public function error500() {
        $this->show();
    }

}
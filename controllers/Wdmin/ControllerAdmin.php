<?php

/**
 * ControllerAdmin
 */
class ControllerAdmin extends Controller
{
    /**
     * ControllerAdmin constructor.
     * @param $ControllerName
     * @param $Action
     * @param $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        if (!$this->Auth->checkAuth() && !$this->isAjax()) {
            $this->redirect("?/Wdmin/logOut");
        }
    }
}
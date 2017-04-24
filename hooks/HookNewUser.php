<?php

/**
 * HookNewUser
 * 有新用户注册之后的处理
 */
class HookNewUser extends Hook implements iHook
{
    /**
     * @param $rebate
     */
    public function deal($userData) {
        try {
            // var_dump($userData);
            #echo $this->controller->getUID();
        } catch (Exception $ex) {
            Util::log($ex->getMessage());
        }
    }
}
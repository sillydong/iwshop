<?php

/**
 * 模板消息
 */
class MessageTemplate {

    /**
     * 模板参数配置数据
     * @var array
     */
    static $tplConfig = false;

    /**
     * 获取模板消息参数
     * @param $tplname
     */
    public static function getTpl($tplname) {
        $configFile = APP_PATH . 'config/config_msg_template.php';
        if (is_file($configFile)) {
            if (!self::$tplConfig) {
                self::$tplConfig = include $configFile;
            }
            if (isset(self::$tplConfig[$tplname]) && !empty(self::$tplConfig[$tplname]['tpl_id'])) {
                return self::$tplConfig[$tplname];
            } else {
                return false;
            }
        } else {
            Util::log("无法获取模板消息参数， $configFile 配置文件不存在");
            return false;
        }
    }

}
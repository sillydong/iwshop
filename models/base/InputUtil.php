<?php

/**
 * 输入处理-模型
 */
class InputUtil {

    /**
     * 限制数字
     * @param type $input
     * @param type $default
     * @return type
     */
    public static function digit($input, $default = 0) {
        return is_numeric($input) ? intval($input) : $default;
    }

    /**
     * 限制正整数
     * @param type $input
     * @param type $default
     * @return type
     */
    public static function digitDefault($input, $default = 0) {
        return (is_numeric($input) && $input > 0) ? intval($input) : $default;
    }

    /**
     * 限制正浮点数
     * @param type $input
     * @param type $default
     * @return type
     */
    public static function floatDefault($input, $default = 0) {
        return (is_numeric($input) && $input > 0) ? floatval($input) : $default;
    }

    /**
     *
     * @param type $input
     * @param type $default
     * @return type
     */
    public static function strDefault($input, $default = '') {
        return !empty($input) ? trim($input) : $default;
    }

}

<?php

/**
 * redis单例模型
 */
class mFile implements iCache
{

    /**
     * @var mFile
     */
    private static $_instace;

    /**
     * @param $key
     * @param $value
     * @param $exprie
     */
    public static function set($key, $value, $exprie = 60) {

    }

    /**
     * @param $key
     */
    public static function get($key) {

    }

    /**
     * redis 单例模式
     * @return Redis Sigle Instance
     */
    public static function get_instance() {

    }
}
<?php

/**
 * Memcached单例模型
 */
class mMemcached implements iCache
{

    /**
     * @var Redis
     */
    private static $_instance;

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

    /**
     * @param $key
     * @return string
     */
    public static function getKey($key) {

    }

}
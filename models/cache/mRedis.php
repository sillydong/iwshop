<?php

/**
 * redis单例模型
 */
class mRedis implements iCache
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
        $key   = APPID . $key;
        $redis = self::get_instance();
        $redis->set($key, serialize($value));
        $redis->expire($key, $exprie);
    }

    /**
     * @param $key
     */
    public static function get($key) {
        $key   = APPID . $key;
        $redis = self::get_instance();
        return unserialize($redis->get($key));
    }

    /**
     * redis 单例模式
     * @return Redis Sigle Instance
     */
    public static function get_instance() {
        global $config;
        if ($config->redis_on && extension_loaded('redis')) {
            if (!(self::$_instance instanceof self)) {
                try {
                    self::$_instance = new Redis();
                    self::$_instance->connect($config->redis_host, $config->redis_port);
                    if ($config->redis_auth != '') {
                        self::$_instance->auth($config->redis_auth);
                    }
                } catch (Exception $ex) {
                    Util::log($ex->getMessage());
                    return false;
                }
            }
            return self::$_instance;
        } else {
            return false;
        }
    }

    /**
     * @param $key
     * @return string
     */
    public static function getKey($key) {
        return APPID . ':' . $key;
    }

}
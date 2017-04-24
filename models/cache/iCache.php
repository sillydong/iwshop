<?php

interface iCache
{

    /**
     * @param $key
     * @param $value
     * @param $exprie
     * @return mixed
     */
    public static function set($key, $value, $exprie = 60);

    /**
     * @param $key
     * @return mixed
     */
    public static function get($key);

}
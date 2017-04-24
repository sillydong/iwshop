<?php

/**
 * Redis Session
 *
 * Copyright (C) 2015 ycchen
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */
class rSession {

    /**
     * @var
     */
    public $sessionId;

    /**
     * @var string
     */
    private $sessionName = 'rsessionID';

    /**
     * @var
     */
    private $redisHKey;

    /**
     * redis
     * @var Redis
     */
    private $redis;

    /**
     * @var int
     */
    private $sessionExp = 72000;

    /**
     * @var bool
     */
    private $isStarted = false;

    public function start() {
        $this->redis = mRedis::get_instance();
        if (!isset($_COOKIE[$this->sessionName])) {
            // 分配sessionid
            $this->regenerateId();
            // redis key
            $this->redisHKey = 'rsession:' . APPID . $this->sessionId;
            // 设置默认信息
            $this->redis->hSet($this->redisHKey, '_sessionId', $this->sessionId);
            // 设置redis过期
            $this->redis->expire($this->redisHKey, $this->sessionExp);
            // 已启动
            $this->isStarted = true;
        } else {
            // 会话已存在
            if (!empty($_COOKIE[$this->sessionName])) {
                // sessionid
                $this->sessionId = $_COOKIE[$this->sessionName];
                // redis key
                $this->redisHKey = 'rsession:' . APPID . $this->sessionId;
                // 已启动
                $this->isStarted = true;
            } else {
                return false;
            }
        }
        $this->set('exp', $this->sessionExp);
        return true;
    }

    /**
     *
     * @param type $key
     * @param type $value
     * @return type
     */
    public function set($key, $value) {
        return $this->redis->hSet($this->redisHKey, $key, $value);
    }

    /**
     *
     * @param type $key
     * @return type
     */
    public function get($key) {
        return $this->redis->hGet($this->redisHKey, $key);
    }

    /**
     * 获取UID
     * @return type
     */
    public function getUID() {
        return $this->get('uid');
    }

    /**
     * 获取OpenID
     * @return type
     */
    public function getOpenID() {
        return $this->get('openid');
    }

    /**
     * 清空session
     * @return mixed
     */
    public function clear() {
        return $this->redis->delete($this->redisHKey);
    }

    /**
     * 删除一个session的key和value
     * @return: array
     */
    function del($key) {
        return $this->redis->hDel($this->redisHKey, $key);
    }

}
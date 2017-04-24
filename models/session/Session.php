<?php

/**
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
 */
class Session extends Model {

    public function start() {
        if (!isset($_SESSION)) {
            session_start();
        }
    }

    /**
     *
     * @param type $key
     * @param type $value
     * @return type
     */
    public function set($key, $value) {
        return $_SESSION[$key] = $value;
    }

    /**
     *
     * @param type $key
     * @return type
     */
    public function get($key) {
        return $_SESSION[$key];
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
        return session_destroy();
    }

    /**
     * 删除一个session的key和value
     * @return: array
     */
    function del($key) {
        unset($_SESSION[$key]);
    }

}

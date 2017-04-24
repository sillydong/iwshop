<?php

/**
 * SQLCached
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class SqlCached extends Model {

    // 缓存5秒
    const EXP = 5;

    private $dir = false;

    public function __construct() {
        parent::__construct();
        if (!is_dir($this->getDir())) {
            mkdir($this->getDir(), 0777, true);
        } else if (!is_writable($this->getDir())) {
            chmod($this->getDir(), 0777);
        }
    }

    /**
     *
     * @param type $k
     * @return type
     */
    private function genKey($k) {
        return hash('md4', $k . APPID . 'xa123d');
    }

    /**
     *
     * @param type $k
     * @return type
     */
    public function get($k, $exp = false) {
        $fn = $this->genKey($k);
        if (!$exp) {
            $exp = self::EXP;
        }
        $f = $this->getFile($fn);
        if (is_file($f) && (time() - filemtime($f)) < $exp) {
            return include $f;
        } else {
            @unlink($f);
            return -1;
        }
    }

    /**
     * 写入数据
     * @param type $k
     * @param type $v
     * @return boolean
     */
    public function set($k, $v) {
        $fn  = $this->genKey($k);
        $f   = $this->getFile($fn);
        $dir = dirname($f);
        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }
        $fp = fopen($f, 'w');
        @fwrite($fp, '<?php return ' . var_export($v, true) . ';');
        fclose($fp);
        return true;
    }

    /**
     * 获取缓存路径
     * @param type $fn
     * @return type
     */
    private function getFile($fn) {
        return $this->getDir() . substr($fn, 0, 1) . DIRECTORY_SEPARATOR . $fn . '.sqlc';
    }

    private function getDir() {
        if (!$this->dir) {
            $this->dir = dirname(__FILE__) . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'tmp' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'sql_cache' . DIRECTORY_SEPARATOR;
        }
        return $this->dir;
    }

    /**
     * 删除缓存
     * @param type $k
     */
    public function del($k) {
        $fn = $this->genKey($k);
        @unlink($this->getFile($fn));
    }

    /**
     * 清除缓存
     */
    public function clearCache() {
        $this->Util->delDirFiles(dirname(__FILE__) . '/../uploads/product_hpic_tmp/');
    }

}

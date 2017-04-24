<?php

/**
 * 类加载器
 */
class ClassLoader {

    /**
     * 加载类文件
     * @global type $config
     * @param type $className
     * @param type $c
     * @return boolean
     */
    public static function load($className, $c = false) {
        global $sys_include_paths, $config;
        // 缓存文件
        $cacheFile = APP_PATH . "tmp/ClassLoader.cache." . $config->system_version;
        // 缓存文件检查
        if (is_file($cacheFile) && is_readable($cacheFile)) {
            $pathHash = include $cacheFile;
        } else {
            $pathHash = array();
        }
        // 目录检查
        if (!is_dir(APP_PATH . 'tmp')) {
            mkdir(APP_PATH . 'tmp', 0777, true);
        }
        // 目录检查
        if (!is_writeable(APP_PATH . 'tmp')) {
            die('tmp目录不可写！');
        }
        // 查找缓存文件
        if (sizeof($pathHash) !== 0) {
            // 缓存不为空
            $suPath = self::loadClass($pathHash, $className, $c, true);
            if ($suPath !== false) {
                // 缓存找到，不做写入处理
                return true;
            }
        }
        // 查找本地配置文件 < 缓存查找失败
        $suPathLocal = self::loadClass($sys_include_paths, $className, $c);
        if ($suPathLocal !== false) {
            $pathHash[$className] = $suPathLocal;
            self::writeCacheFile($cacheFile, $pathHash);
            return true;
        }
        return false;
    }

    /**
     * 写入缓存文件
     * @param type $cacheFile
     * @param type $pathHash
     */
    private final static function writeCacheFile($cacheFile, $pathHash) {
        if (is_array($pathHash)) {
            if (!is_file($cacheFile)) {
                touch($cacheFile);
                chmod($cacheFile, 755);
            }
            $fp = fopen($cacheFile, 'w');
            @fwrite($fp, '<?php return ' . var_export($pathHash, true) . ';?>');
        }
    }

    /**
     * 加载子函数
     * @param string $className
     * @return boolean
     */
    private final static function loadClass($paths, $className, $c, $isCache = false) {
        if ($isCache) {
            // 缓存特定查找方法
            if (stristr($className, 'Smarty_')) {
                $className = strtolower($className);
            }
            // 直接查找数组
            if (array_key_exists($className, $paths)) {
                if (is_file($paths[$className])) {
                    include_once $paths[$className];
                    $c && $c->$className = new $className();
                } else {
                    return false;
                }
            }
        } else {
            // 查找本地路径
            foreach ($paths as $path) {
                $_path = APP_PATH . $path . $className . '.php';
                if (strpos($className, 'Smarty_') !== false) {
                    $className = strtolower($className);
                }
                if (is_file($_path)) {
                    // 找到类文件
                    include_once $_path;
                    $c && $c->$className = new $className();
                    return $path . $className . '.php';
                }
            }
        }
        return false;
    }

}

spl_autoload_register(array('ClassLoader', 'load'));
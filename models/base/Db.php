<?php

require_once 'SqlCached.php';

/**
 * Db模块，采用PDO
 * @property Redis $_redis Description
 */
class Db extends Model
{

    // db
    private $db;
    // 单例
    protected static $_instance = NULL;
    // memcached
    public $memcached = false;
    // single instance
    private static $instance = false;
    // db swcache
    public $prevDb = null;
    // file cache
    public $fileCache = true;
    // file cached
    public $fileCached = false;
    // 全局cache开关
    public $cache = false;
    // debug
    public $debug = false;
    // redis
    private static $_redis = false;
    // transactions
    private $transactions = 0;
    // nocache
    const NOCACHE = false;

    /**
     * @return bool|Db
     */
    public static function get_instance() {
        if (!self::$instance) {
            self::$instance = new Db();
        }
        return self::$instance;
    }

    /**
     * 初始化Db
     * @global object $config
     * @param bool $dbname
     */
    public function __construct($dbname = false) {
        global $config;
        parent::__construct();
        $this->initRedis($config);
        if ($dbname) {
            $config->db['db'] = $dbname;
        }
        try {
            $this->db = new PDO(sprintf("mysql:host=%s;dbname=%s", $config->db['host'], $config->db['db']), $config->db['user'], $config->db['pass']);
            $this->db->exec("SET NAMES utf8mb4;");
        } catch (Exception $ex) {
            die('数据库连接失败！请检查扩展PDO是否打开或者配置文件中账号密码是否正确！');
        }
    }

    /**
     * 使用事务
     * @return bool
     */
    public function transtart() {
        $this->transactions++;
        // 初次启动事务
        if ($this->transactions == 1) {
            // 关闭自动提交
            $this->db->setAttribute(PDO::ATTR_AUTOCOMMIT, FALSE);
            // 异常模式
            $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            // 启动事务
            return $this->db->beginTransaction();
        } else {
            return false;
        }
    }

    /**
     * 提交事务
     * @return bool
     */
    public function transcommit() {
        // 事务层--
        $this->transactions--;
        if ($this->transactions <= 0) {
            // 回到最外层事务
            return $this->db->commit();
        } else {
            return false;
        }
    }

    /**
     * 回滚事务
     * 事务回滚不考虑嵌套情况
     * @return bool
     */
    public function transrollback() {
        // 回滚最外层
        $this->transactions = 0;
        return $this->db->rollBack();
    }

    /**
     * @param string $statement
     * @param bool $mcache
     * @param int $fetchStyle
     * @return array
     */
    public function query($statement, $mcache = true, $fetchStyle = PDO::FETCH_ASSOC) {
        global $config;
        try {
            if (preg_match("/INSERT/is", $statement)) {
                // INSERT
                $this->db->exec($statement);
                $result = $this->db->lastInsertId();
            } else if (preg_match("/UPDATE|DELETE|REPLACE/s", $statement)) {
                // UPDATE|DELETE|REPLACE
                $this->db->exec($statement);
                // 修复更新没有内容变更的情况下，总是返回错误的bug
                return true;
            } else {
                // 使用redis而且连接成功
                if ($config->redis_on && $mcache && $this->cache) {
                    /**
                     * allow memcached <default>
                     */
                    $sHash = $this->getSHash($statement) . '.sqlcache';
                    $mca   = self::$_redis->get($sHash);
                    if ($mca) {
                        return unserialize($mca);
                    } else {
                        // SELECT
                        $result = $this->rawQuery($statement, $fetchStyle);
                        // cache sql query resultSet
                        self::$_redis->set($sHash, serialize($result));
                        self::$_redis->expireAt($sHash, time() + $config->redis_exps);
                    }
                } else {
                    $result = $this->rawQuery($statement, $fetchStyle);
                }
            }
            if ($this->db->errorCode() != '00000') {
                // 记录数据库执行日志
                $errInfo = $this->db->errorInfo();
                $this->log('db_query_error:' . $this->db->errorCode() . ' message:' . $errInfo[2] . PHP_EOL . ' --- [SQL]:' . $statement);
                throw new Exception($this->db->errorCode() . ' message:' . $errInfo[2]);
            }
        } catch (Exception $ex) {
            $this->log('db_query_error:' . $ex->getMessage());
            throw new Exception($ex->getMessage());
        }
        return $result;
    }

    /**
     * 直接执行SQL语句
     * @param string $statement
     * @param int $fetchStyle
     * @return array
     */
    private function rawQuery($statement, $fetchStyle) {
        // buffer模式
        $query = $this->db->prepare($statement);
        $query->execute();
        $result = $query->fetchAll($fetchStyle);
        $query->closeCursor();
        return $result;
    }

    /**
     * 查询一个数据
     * @param string $SQL
     * @return string
     */
    public function getOne($SQL, $cache = true) {
        $ret = $this->query($SQL, $cache);
        if (!$ret[0]) {
            return false;
        }
        return current($ret[0]);
    }

    /**
     * 查询一行数据
     * @param string $SQL
     * @return array
     */
    public function getOneRow($SQL, $cache = true) {
        $ret = $this->query($SQL, $cache);
        if ($ret) {
            return $ret[0];
        }
        return false;
    }

    /**
     * 检查某字段有某值
     * @param string $table
     * @param string $field
     * @param string $value
     * @return bool
     */
    public function isExist($table, $field, $value) {
        $rst = $this->query("SELECT * FROM `$table` WHERE `$field` = '$value' LIMIT 1");
        return count($rst) > 0;
    }

    /**
     * 直接执行SQL语句
     * @param type $statement
     * @return type
     */
    public function exec($statement) {
        $this->db->exec($statement);
        if ($this->db->errorCode() != '00000') {
            $errInfo = $this->db->errorInfo();
            $this->log('db_query_error:' . $this->db->errorCode() . ' message:' . $errInfo[2] . PHP_EOL . ' --- [SQL]:' . $statement);
            return false;
        } else {
            return true;
        }
    }

    /**
     * Redis
     * @param type $config
     * @return boolean
     */
    private function initRedis($config) {
        if ($config->redis_on && extension_loaded('redis')) {
            if (!(self::$_redis instanceof self)) {
                try {
                    self::$_redis = new Redis();
                    self::$_redis->pconnect($config->redis_host, $this->redis_port);
                } catch (Exception $ex) {
                    return false;
                }
            }
            return self::$_redis;
        } else {
            return false;
        }
    }

    /**
     * 获取查询缓存HashKey
     * @param type $statement
     * @return type
     */
    private final function getSHash($statement) {
        return md5($statement . APPID);
    }

    /**
     * 获取数据库错误信息
     * @return mixed
     */
    public function getErrorInfo() {
        $errInfo = $this->db->errorInfo();
        return $errInfo[2];
    }

    /**
     * 关闭缓存
     * @return bool
     */
    public function disableCache() {
        $this->cache = false;
        return true;
    }

}

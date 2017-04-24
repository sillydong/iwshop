<?php

/**
 * Class sModel
 * 对象访问模型
 * 启发于phalcon的Model
 * @link http://git.oschina.net/koodo/sModel
 */
class sModel
{

    /**
     * 属性变动栈
     * @var array
     */
    protected $changes = [];

    /**
     * 数据源表
     * @var string
     */
    private $_source = null;

    /**
     * Db对象
     * @var Db
     */
    private $_db = null;

    /**
     * 配置文件
     * @var mixed
     */
    private $_config;

    /**
     * 是否编辑模式
     * @var bool
     */
    private $is_modify = false;

    /**
     * @var array 数据
     */
    private $_values = [];

    /**
     * @var bool 是否缓存
     */
    private static $_cache = true;

    /**
     * sModel constructor.
     * @param $tableName
     */
    public function __construct($tableName = false, &$config = false, &$db = false) {
        if ($tableName) {
            $this->_source = $tableName;
        }
        if (!$config) {
            $this->_config = include __DIR__ . '/config.php';
        } else {
            if (is_array($config)) {
                $this->_config = $config;
            }
        }
        if (!$db) {
            $this->_db = Db::get_instance($this->_config);
        } else {
            if ($db instanceof Db) {
                $this->_db = $db;
            }
        }
    }

    /**
     * 记录未声明的变量赋值
     * @param $name
     * @param $value
     */
    public function __set($name, $value) {
        $this->_values[$name] = $value;
        $this->changes[$name] = $value;
    }

    /**
     * 设置模型数据源表
     * @param $source
     */
    public function setSource($source) {
        $this->_source = $source;
    }

    /**
     * 批量设置数据
     * @param $array
     */
    public function setData($data, $value = false) {
        if (empty($data)) {
            return false;
        }
        if (is_string($data)) {
            $this->$data = $value;
            return true;
        }
        if (is_array($data)) {
            foreach ($data as $key => $value) {
                $this->$key = $value;
            }
            return true;
        }
        return false;
    }

    /**
     * 设置模型模式
     * @param $mode true为编辑模式, false为新建模式
     */
    public function setMode($mode) {
        $this->is_modify = $mode;
    }

    /**
     * 在模型数据写入之前执行，用户预处理操作
     */
    public function beforeSave() {

    }

    /**
     * 在模型数据创建之前执行，用户预处理操作
     */
    public function beforeCreate() {

    }

    /**
     * @return bool
     */
    public function isModify() {
        return $this->is_modify;
    }

    /**
     * @return bool
     */
    public function isCreate() {
        return !$this->is_modify;
    }

    /**
     * @return bool
     */
    public function save() {

        $ref = new ReflectionClass(get_called_class());

        $source = $ref->getConstant('SOURCE');

        $propertys = $ref->getProperties(ReflectionProperty::IS_PUBLIC);

        $autoKey = false;

        // 获取已经修改的值
        foreach ($propertys as $property) {
            if (!$autoKey) {
                // 默认以第一个属性为主键
                $autoKey = $property->name;
            }
            if (isset($this->{$property->name}) && !empty($this->{$property->name})) {
                $this->changes[$property->name] = $this->{$property->name};
            }
        }

        if ($this->isModify()) {
            // 编辑模式
            $sets = [];
            foreach ($this->changes as $key => $value) {
                $sets[] = "`$key`='$value'";
            }
            $_primary_key_value = $this->$autoKey;
            $SQL                = "UPDATE `$source` SET " . implode(',', $sets) . " WHERE `$autoKey` = '$_primary_key_value';";

            $this->beforeSave();
        } else {
            // 新增模式
            $fileds = [];
            $values = [];
            foreach ($this->changes as $key => $value) {
                $fileds[] = "`$key`";
                $values[] = "'$value'";
            }
            $SQL = "INSERT INTO `$source` (" . implode(',', $fileds) . ") VALUES (" . implode(',', $values) . ");";

            $this->beforeCreate();
        }

        $result = $this->_db->query($SQL);

        if (!$this->isModify() && is_numeric($result)) {
            $this->$autoKey = intval($result);
        }

        return $result;
    }

    /**
     * @return bool
     */
    public function delete() {
        return true;
    }

    /**
     * @param mixed $conditions
     * @return array
     * @throws Exception
     */
    public static function find($conditions = false) {

        $result = [];

        $where = '';

        $columns = '*';

        $limit = '100';

        $group = '';

        $order = '';

        $ref = new ReflectionClass(get_called_class());

        $source = $ref->getConstant('SOURCE');

        $db = Db::get_instance();

        if (is_string($conditions)) {
            $where  = $conditions;
            $result = $db->query("select $columns from $source WHERE $where LIMIT $limit", self::$_cache);
        }

        if (is_array($conditions)) {
            if (is_string($conditions[0])) {
                $where = $conditions[0];
            }
            if (isset($conditions['columns'])) {
                if (is_string($conditions['columns'])) {
                    $columns = $conditions['columns'];
                } else if (is_array($conditions['columns'])) {
                    $columns = implode(',', $conditions['columns']);
                }
            }
            if (isset($conditions['limit'])) {
                if (is_string($conditions['limit'])) {
                    $limit = $conditions['limit'];
                } else if (is_array($conditions['limit'])) {
                    // size, offset
                    $limit = implode(',', $conditions['limit']);
                }
            }
            if (isset($conditions['order']) && is_string($conditions['order'])) {
                $order = 'ORDER BY ' . $conditions['order'];
            }
            if (isset($conditions['group']) && is_string($conditions['group'])) {
                $group = 'GROUP BY ' . $conditions['group'];
            }
            try {
                $result = $db->query("select $columns from $source WHERE $where $group $order LIMIT $limit", self::$_cache);
            } catch (Exception $ex) {
                throw $ex;
            }
        }

        if (empty($conditions) || !$conditions) {
            try {
                $result = $db->query("select $columns from $source LIMIT $limit", self::$_cache);
            } catch (Exception $ex) {
                throw $ex;
            }
        }

        return $result;
    }

    /**
     * @param mixed $conditions
     * @return sModel
     */
    public static function findFirst($conditions = false) {

        $result = [];

        $where = '';

        $columns = '*';

        $ref = new ReflectionClass(get_called_class());

        $source = $ref->getConstant('SOURCE');

        $db = Db::get_instance(include __DIR__ . '/config.php');

        if (is_string($conditions)) {
            $where  = $conditions;
            $result = $db->getOneRow("select $columns from $source WHERE $where LIMIT 1");
        }

        if (is_array($conditions)) {
            if (is_string($conditions[0])) {
                $where = $conditions[0];
            }
            if (isset($conditions['columns'])) {
                if (is_string($conditions['columns'])) {
                    $columns = $conditions['columns'];
                } else if (is_array($conditions['columns'])) {
                    $columns = implode(',', $conditions['columns']);
                }
            }
            $result = $db->getOneRow("select $columns from $source WHERE $where LIMIT 1");
        }

        if (empty($conditions) || !$conditions) {
            $result = $db->getOneRow("select $columns from $source LIMIT 1");
        }

        $model_object = new $ref->name();

        foreach ($result as $prot => $value) {
            $model_object->$prot = $value;
        }

        $model_object->changes = [];

        $model_object->is_modify = true;

        return $model_object;
    }

    /**
     * 数组化
     * @return array
     */
    public function toArray() {
        return $this->_values;
    }

}
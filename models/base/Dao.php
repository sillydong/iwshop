<?php

/**
 * Dao数据访问模块
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Dao {

    /**
     * @var Dao
     */
    static private $instance;

    private $sqlSelect = 'SeLEct ';
    private $sqlFrom = ' fRoM ';
    private $sqlWhere = ' wHerE ';
    private $sqlOrWhere = ' Or ';
    private $sqlAndWhere = ' aNd ';
    private $sqlLeftJoin = ' LeFt joIN ';
    private $sqlOn = ' oN ';
    private $sqlInsert = 'INSERT INTO ';
    private $sqlUpdate = 'UPDATE ';

    /**
     * 这个是干嘛，我也是醉了
     */
    const VALUE_PLUS = 'Wi0Tf8qNh0J0Com3uc9bBy5i5dpEtOhnJ361fm6xWgM';
    const VALUE_MINUS = 'Wi0Tf8qNh0J0Com3uc9bBy5i5dpEtOhnJ361fm6xWa';
    const FIELD_NOW = 'NOW()';

    /**
     * update不进行字符串转义
     */
    const SET_RAW = true;

    /**
     * sql字符串
     * @var String
     */
    private $sqlStr;

    /**
     * Db
     * @var Db
     */
    private $Db;

    /**
     * 查询结构
     * @var assoc
     */
    public $ret;

    /**
     * @return Dao
     */
    public static function get_instance() {
        if (!self::$instance instanceof Dao) {
            self::$instance = new self;
        }
        return self::$instance;
    }

    /**
     * Dao constructor.
     */
    public function __construct() {
        $this->Db = Db::get_instance();
    }

    /**
     * 清空sql
     */
    public function emp() {
        $this->sqlStr = '';
    }

    /**
     *
     * @param string $as
     * @return \Dao
     */
    public function alias($as) {
        $this->sqlStr .= ' AS ' . $as;
        return $this;
    }

    /**
     * Having
     * @param type $condition
     * @return \Dao
     */
    public function having($condition) {
        $this->sqlStr .= ' HAVING(' . $condition . ')';
        return $this;
    }

    /**
     * select查询
     * @param mixed $fields
     * @return \Dao
     */
    public function select($fields = '*') {
        $this->emp();
        if (is_array($fields)) {
            $this->sqlStr .= $this->sqlSelect . implode(',', $fields);
        } else {
            $this->sqlStr .= $this->sqlSelect . $fields;
        }
        return $this;
    }

    /**
     * 更新行
     * @param string $table
     * @param array $fields
     * @return \Dao
     */
    public function update($table) {
        $this->emp();
        $this->sqlStr .= $this->sqlUpdate . $table;
        return $this;
    }

    /**
     * update Set
     * @param array $fields
     * @param boolean $raw
     * @return \Dao
     */
    public function set($fields, $raw = false) {
        $tmp = array();
        foreach ($fields as $k => $v) {
            if ($raw) {
                $tmp[] = "`$k` = $v";
            } else {
                if ($v === self::VALUE_PLUS) {
                    $tmp[] = "`$k` = `$k` + 1";
                } else if ($v === self::VALUE_MINUS) {
                    $tmp[] = "`$k` = `$k` - 1";
                }
                {
                    if ($v !== 'NOW()' && $v !== 'NULL') {
                        $tmp[] = "`$k` = '$v'";
                    } else {
                        $tmp[] = "`$k` = $v";
                    }
                }
            }
        }
        $this->sqlStr .= ' SET ' . implode(',', $tmp) . ' ';
        return $this;
    }

    /**
     * 统计行数
     * @param type $field
     * @return \Dao
     */
    public function count($field = '*') {
        $this->sqlStr .= ' COUNT(' . $field . ')';
        return $this;
    }

    /**
     * 计算列总值
     * @param string $field
     * @return \Dao
     */
    public function sum($field) {
        $this->sqlStr .= ' SUM(' . $field . ')';
        return $this;
    }

    /**
     *
     * @param string $table
     * @return \Dao
     */
    public function from($table) {
        $this->sqlStr .= $this->sqlFrom . '`' . $table . '`';
        return $this;
    }

    /**
     * Dao Where
     * @param string|array $condition
     * @return \Dao
     */
    public function where($condition, $second = false, $implider = 'AND') {
        if (is_array($condition)) {
            if (sizeof($condition) == 0) {
                return $this;
            }
            $tmp = [];
            foreach ($condition as $cond => $value) {
                if (is_integer($cond)) {
                    // 直接字符串条件
                    $tmp[] = $value;
                } else {
                    $tmp[] = "`$cond`='$value'";
                }
            }
            // 连接查询条件
            $this->sqlStr .= $this->sqlWhere . implode(' ' . $implider . ' ', $tmp);
        } else {
            if ($second !== false) {
                $this->sqlStr .= $this->sqlWhere . $condition . " = '$second'";
            } else if ($condition && $condition != '') {
                $this->sqlStr .= $this->sqlWhere . $condition;
            }
        }
        return $this;
    }

    /**
     * OrWhere
     * @param string|array $condition
     * @return \Dao
     */
    public function ow($condition) {
        if ($condition && $condition != '') {
            $this->sqlStr .= $this->sqlOrWhere . $condition;
        }
        return $this;
    }

    /**
     * AndWhere
     * @param string $condition
     * @return \Dao
     */
    public function aw($condition) {
        $condition = trim($condition);
        if (!empty($condition)) {
            $this->sqlStr .= $this->sqlAndWhere . $condition;
        }
        return $this;
    }

    /**
     *
     * @param string $f
     * @param boolean $t
     * @return \Dao
     */
    public function limit($f, $t = false) {
        if (!$t) {
            $this->sqlStr .= " LIMIT $f";
        } else {
            $this->sqlStr .= " LIMIT $f,$t";
        }
        return $this;
    }

    /**
     *
     * @param string $table
     * @return \Dao
     */
    public function leftJoin($table, $condition = false) {
        $this->sqlStr .= $this->sqlLeftJoin . $table;
        if ($condition) {
            $this->on($condition);
        }
        return $this;
    }

    /**
     *
     * @param string $condition
     * @return \Dao
     */
    public function on($condition) {
        $this->sqlStr .= $this->sqlOn . $condition;
        return $this;
    }

    /**
     * @return \Dao
     */
    public function delete() {
        $this->emp();
        $this->sqlStr .= 'DELETE';
        return $this;
    }

    /**
     * 直接执行SQL
     * @param boolean $cache 是否缓存结果
     * @return type
     */
    public function exec($cache = false) {
        $this->sqlStr .= ';';
        $this->ret = $this->Db->query($this->sqlStr, $cache);
        return $this->ret;
    }

    /**
     * 获取一个数据
     * @param boolean $cache 是否缓存结果
     * @return type
     */
    public function getOne($cache = true) {
        $this->sqlStr .= ';';
        $this->ret = $this->Db->getOne($this->sqlStr, $cache);
        return $this->ret;
    }

    /**
     * 获取一行数据
     * @param boolean $cache 是否缓存结果
     * @return type
     */
    public function getOneRow($cache = true) {
        $this->sqlStr .= ';';
        $this->ret = $this->Db->getOneRow($this->sqlStr, $cache);
        return $this->ret;
    }

    /**
     * 插入语句
     * @param string $table
     * @param var $fields
     * @return \Dao
     */
    public function insert($table, $fields = '') {
        $this->emp();
        if (empty($fields)) {
            $this->sqlStr .= $this->sqlInsert . $table;
            return $this;
        }
        if (is_array($fields)) {
            foreach ($fields as &$field) {
                if (!strpos($fields, '`')) {
                    $field = '`' . $field . '`';
                }
            }
            $this->sqlStr .= $this->sqlInsert . $table . ' (' . implode(',', $fields) . ')';
        } else {
            if (strpos($fields, '`') === -1 || false === strpos($fields, '`')) {
                // 自动补充` 避免sql关键字冲突
                $fields = preg_replace('/(\w+)/', "`$1`", $fields);
            }
            $this->sqlStr .= $this->sqlInsert . $table . " ($fields)";
        }
        return $this;
    }

    /**
     * 插入多个数据
     * @param mixed $fields
     * @return \Dao
     */
    public function values($fields) {
        if (is_array($fields)) {
            $tmpArr = array();
            $this->sqlStr .= ' VALUES ';
            foreach ($fields as &$field) {
                if ($field !== 'NOW()' && $field !== 'NULL') {
                    $field = "'$field'";
                }
            }
            $tmpArr[] = '(' . implode(',', $fields) . ')';
            // compo
            $this->sqlStr .= implode(',', $tmpArr);
        } else {
            $this->sqlStr .= ' VALUES (' . $fields . ')';
        }
        return $this;
    }

    /**
     * orderby
     * @param string $field
     * @return \Dao
     */
    public function orderby($field) {
        $this->sqlStr .= ' ORDER BY ' . $field;
        return $this;
    }

    /**
     * groupby
     * @param string $field
     * @return \Dao
     */
    public function groupby($field) {
        $this->sqlStr .= ' GROUP BY ' . $field;
        return $this;
    }

    /**
     * ASC
     * @return \Dao
     */
    public function asc() {
        $this->sqlStr .= ' ASC';
        return $this;
    }

    /**
     * DESC
     * @return \Dao
     */
    public function desc() {
        $this->sqlStr .= ' DESC';
        return $this;
    }

    /**
     * var_dump
     */
    public function dump() {
        var_dump($this->ret);
    }

    /**
     * 输出sql语句
     */
    public function echoSql() {
        echo $this->sqlStr;
    }

    /**
     * 获取sql语句
     * @return String
     */
    public function getSql() {
        return $this->sqlStr;
    }

    /**
     * FOR UPDATE 独占锁
     * @return $this
     */
    public function forUpdate() {
        $this->sqlStr .= ' FOR UPDATE';
        return $this;
    }

}

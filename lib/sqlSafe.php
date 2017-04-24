<?php

class sqlSafe {
    private $getfilter = "'|(and|or)\\b.+?(>|<|=|in|like)|\\/\\*.+?\\*\\/|<\\s*script\\b|\\bEXEC\\b|UNION.+?SELECT|UPDATE.+?SET|INSERT\\s+INTO.+?VALUES|(SELECT|DELETE).+?FROM|(CREATE|ALTER|DROP|TRUNCATE)\\s+(TABLE|DATABASE)";
    private $postfilter = "\\b(and|or)\\b.{1,6}?(=|>|<|\\bin\\b|\\blike\\b)|\\/\\*.+?\\*\\/|<\\s*script\\b|\\bEXEC\\b|UNION.+?SELECT|UPDATE.+?SET|INSERT\\s+INTO.+?VALUES|(SELECT|DELETE).+?FROM|(CREATE|ALTER|DROP|TRUNCATE)\\s+(TABLE|DATABASE)";
    private $cookiefilter = "\\b(and|or)\\b.{1,6}?(=|>|<|\\bin\\b|\\blike\\b)|\\/\\*.+?\\*\\/|<\\s*script\\b|\\bEXEC\\b|UNION.+?SELECT|UPDATE.+?SET|INSERT\\s+INTO.+?VALUES|(SELECT|DELETE).+?FROM|(CREATE|ALTER|DROP|TRUNCATE)\\s+(TABLE|DATABASE)";

    /**
     * 构造函数
     */
    public function __construct() {
        foreach ($_GET as $key => $value) {
            $this->stopattack($key, $value, $this->getfilter);
        }
        foreach ($_POST as $key => $value) {
            $this->stopattack($key, $value, $this->postfilter);
        }
        foreach ($_COOKIE as $key => $value) {
            $this->stopattack($key, $value, $this->cookiefilter);
        }
    }

    /**
     * 参数检查并写日志
     */
    public function stopattack($StrFiltKey, $StrFiltValue, $ArrFiltReq) {
        if (is_array($StrFiltValue)) $StrFiltValue = implode($StrFiltValue);
        if (preg_match("/" . $ArrFiltReq . "/is", $StrFiltValue) == 1) {
            die('');
        }
    }
}
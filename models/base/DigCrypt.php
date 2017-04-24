<?php

/**
 * 数字加密模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class DigCrypt {

    private $strbase = "Flpvf70CsakVjqgeWUPXQxSyJizmNH6B1u3b8cAEKwTd54nRtZOMDhoG2YLrI";
    private $key, $length, $codelen, $codenums, $codeext;

    function __construct($length = 9, $key = 2543.5415412812) {
        $this->key      = $key;
        $this->length   = $length;
        $this->codelen  = substr($this->strbase, 0, $this->length);
        $this->codenums = substr($this->strbase, $this->length, 10);
        $this->codeext  = substr($this->strbase, $this->length + 10);
    }

    function en($nums) {
        $rtn     = "";
        $numslen = strlen($nums);
        //密文第一位标记数字的长度
        $begin = substr($this->codelen, $numslen - 1, 1);
        //密文的扩展位
        $extlen     = $this->length - $numslen - 1;
        $temp       = str_replace('.', '', $nums / $this->key);
        $temp       = substr($temp, -$extlen);
        $arrextTemp = str_split($this->codeext);
        $arrext     = str_split($temp);
        foreach ($arrext as $v) {
            $rtn .= $arrextTemp[$v];
        }
        $arrnumsTemp = str_split($this->codenums);
        $arrnums     = str_split($nums);
        foreach ($arrnums as $v) {
            $rtn .= $arrnumsTemp[$v];
        }
        return $begin . $rtn;
    }

    function de($code) {
        if (!$code) {
            return false;
        }
        $begin = substr($code, 0, 1);
        $rtn   = '';
        $len   = strpos($this->codelen, $begin);
        if ($len !== false) {
            $len++;
            $arrnums = str_split(substr($code, -$len));
            foreach ($arrnums as $v) {
                $rtn .= strpos($this->codenums, $v);
            }
        }

        return $rtn;
    }

}

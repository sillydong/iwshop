<?php

/**
 * 文件上传类
 * Class UpLoadFile
 */
class UpLoadFile
{

    private $name;

    private $mime_type;

    private $tmp_name;

    private $size;

    private $pathinfo;

    public function __construct($fileArr) {
        if (!empty($fileArr) && is_array($fileArr)) {
            if (isset($fileArr['name'])) {
                $this->name = $fileArr['name'];
            }
            if (isset($fileArr['type'])) {
                $this->mime_type = $fileArr['type'];
            }
            if (isset($fileArr['tmp_name'])) {
                $this->tmp_name = $fileArr['tmp_name'];
                // 获取pathinfo
                $this->pathinfo = pathinfo($this->name);
            }
            if (isset($fileArr['size'])) {
                $this->size = $fileArr['size'];
            }
        } else {

        }
    }

    /**
     * 获取文件名
     * @return mixed
     */
    public function getName() {
        return $this->name;
    }

    /**
     * 获取文件尺寸
     * @return mixed
     */
    public function getSize() {
        return $this->size;
    }

    /**
     * 获取临时文件名称
     * @return mixed
     */
    public function getTempName() {
        return $this->tmp_name;
    }

    /**
     * 获取文件扩展名
     * @return mixed
     */
    public function getRealType() {
        if (empty($this->pathinfo)) {
            return null;
        }
        return $this->pathinfo['extension'];
    }

}
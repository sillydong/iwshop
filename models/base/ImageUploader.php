<?php

/**
 * 文件上传处理模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class ImageUploader extends Model
{

    public $dir = '';
    private $access_id;
    private $access_key;
    private $bucket;

    /**
     * 文件上传处理
     * @todo 文件上传安全过滤
     * @return string|boolean
     */
    public function upload($oss = false, $access_id = null, $access_key = null, $bucket = null) {
        if (!empty($_FILES)) {
            $this->access_id  = $access_id;
            $this->access_key = $access_key;
            $this->bucket     = $bucket;
            $keyName          = !empty($_FILES['jUploaderFile']) ? 'jUploaderFile' : 'upfile';
            $tempFile         = $_FILES[$keyName]['tmp_name'];
            $namex            = explode(".", $_FILES[$keyName]['name']);
            $targetFileName   = uniqid(time()) . '.' . $namex[1];
            $targetDir        = str_replace('//', '/', $this->dir);
            if (!is_dir($targetDir)) {
                mkdir($targetDir, 0755, true);
            }
            $targetFile = $targetDir . $targetFileName;
            if (move_uploaded_file($tempFile, $targetFile)) {
                chmod($targetFile, 0755);
                return $targetFileName;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 阿里巴巴上传图片
     */
    public function ossUpload($tempFile, $targetFile) {
        include_once(dirname(__FILE__) . "/../lib/OssUpload/service/Storage.php");
        $oss = new Storage($this->access_id, $this->access_key, 'EmeOSS', $this->bucket);
        return $oss->upload($tempFile, $targetFile);
    }

}

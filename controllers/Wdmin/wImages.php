<?php

/**
 * 图片控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wImages extends ControllerAdmin
{

    private $baseDir = 'uploads/default/';

    /**
     * 上传产品图片
     * /?/wImages/ImageUpload/editor=0
     */
    public function ImageUpload($Q) {

        global $config;

        !isset($Q->editor) && $Q->editor = false;

        if ($this->hasFiles()) {

            foreach ($this->getUploadedFiles() as $file) {
                // 新文件名称
                $newname = hash('md4', time() . uniqid()) . '.' . $file->getRealType();
                $seed    = substr($newname, 0, 4) . '/' . strrev(substr($newname, 2, 5));
                // 阿里云OSS上传文件
                if (isset($config->oss) && $config->oss['on']) {
                    try {
                        $ossClient = AliYunOSS::getOssClient($config->oss['endpoint'], $config->oss['accessKeyId'], $config->oss['accessKeySecret']);
                        $path      = isset($config->oss['dir']) ? $config->oss['dir'] : '/';
                        $fullpath  = $path . "$seed/" . $newname;
                        $ossClient->uploadFile($config->oss['bucket'], $fullpath, $file->getTempName());
                        // 最终文件URI
                        $finalUrl = $config->oss['baseroot'] . $fullpath;
                        if ($Q->editor) {
                            // 编辑器模式
                            $return = [
                                "originalName" => $file->getName(),
                                "name" => $newname,
                                "url" => $finalUrl,
                                "size" => $file->getSize(),
                                "type" => $file->getRealType(),
                                "state" => $file ? "SUCCESS" : "FAIL"
                            ];
                        } else {
                            // 非编辑器
                            $return = [
                                'ret_code' => 0,
                                'ret_msg' => $finalUrl
                            ];
                        }
                    } catch (Exception $e) {
                        if ($Q->editor) {
                            $return = [
                                "state" => "FAIL"
                            ];
                        } else {
                            $return = [
                                'ret_code' => -1,
                                'ret_msg' => $e->getMessage()
                            ];
                        }
                    }
                } else {
                    // 普通文件上传
                    $fulldir  = APP_PATH . DIRECTORY_SEPARATOR . $this->baseDir . "/$seed/";
                    $fullpath = $fulldir . $newname;
                    // 新文件名
                    $newname = DIRECTORY_SEPARATOR . $this->baseDir . "/$seed/" . $newname;
                    // 目录问题
                    if (!is_dir($fulldir)) {
                        mkdir($fulldir, 0777, true);
                    }
                    if (@move_uploaded_file($file->getTempName(), $fullpath)) {
                        // 最终文件URI
                        $finalUrl = Util::getHOST() . $newname;
                        if ($Q->editor) {
                            // 编辑器模式
                            $return = [
                                "originalName" => $file->getName(),
                                "name" => $newname,
                                "url" => $finalUrl,
                                "size" => $file->getSize(),
                                "type" => $file->getRealType(),
                                "state" => $file ? "SUCCESS" : "FAIL"
                            ];
                        } else {
                            // 非编辑器
                            $return = [
                                'ret_code' => 0,
                                'ret_msg' => $finalUrl
                            ];
                        }
                    } else {
                        if ($Q->editor) {
                            $return = [
                                "state" => "FAIL"
                            ];
                        } else {
                            $return = [
                                'ret_code' => -1,
                                'ret_msg' => '文件上传失败，目录无权限'
                            ];
                        }
                    }
                }
                if ($Q->editor) {
                    echo json_encode($return);
                } else {
                    $this->echoJson($return);
                }
                break;
            }

        }
    }

}

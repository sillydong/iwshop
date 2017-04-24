<?php

/**
 * 消息群发
 */
class wGmess extends ControllerAdmin
{

    const TPL = './views/wdminpage/';

    /**
     * 素材列表
     * @example /?/wGmess/getGmessList/
     */
    public function getGmessList() {
        $this->loadModel('mGmess');
        $keyword = $this->pGet('key');
        $page    = intval($this->pGet('page'));
        $list    = $this->mGmess->getGmessList($page, 20, $keyword, false);
        $count   = $this->mGmess->getGmessCount();
        $this->echoJson([
            'list' => $list,
            'count' => $count
        ]);
    }

    /**
     * ajax删除素材
     * @example /?/wGmess/ajaxDelByMsgId/
     */
    public function ajaxDelByMsgId() {
        $this->loadModel('mGmess');
        $id = intval($this->post('msgid'));
        $this->echoJson(array('status' => $this->mGmess->deleteGmess($id) === false ? 0 : 1));
    }

    /**
     * 编辑素材
     * @param type $Query
     * @example /?/wGmess/gmess_edit/
     */
    public function gmess_edit($Query) {
        if (isset($Query->id) && is_numeric($Query->id) && $Query->id > 0) {
            $this->Db->cache = false;
            $id              = intval($Query->id);
            $this->loadModel('mGmess');
            $gmess = $this->mGmess->getGmess($id);
            $this->assign('g', $gmess);
        } else {
            $id = 0;
        }
        $this->assign('ed', $id > 0);
        $this->show(self::TPL . 'gmess/gmess_edit.tpl');
    }

    /**
     * 【云搜索】
     * 获取分类列表
     * @see http://apistore.baidu.com/apiworks/servicedetail/863.html
     * @example /?/wGmess/getCloudCategorys/
     * @todo cache
     */
    public function getCloudCategorys() {
        $apis = "http://apis.baidu.com/showapi_open_bus/weixin/weixin_article_type";
        $ret  = json_decode(Curl::getWithHeader($apis, 'apikey: d5c983389f7bac5b1884f7ca82ac8247'));
        $cats = $ret->showapi_res_body->typeList;
        foreach ($cats as $cat) {
            $cat->id = intval($cat->id);
        }
        $cats = array_reverse($cats);
        $this->echoJson($cats);
    }

    /**
     * 【云搜索】
     * 获取列表
     * @param type $id
     * @param type $keyword
     * @param type $page
     * @see http://apistore.baidu.com/apiworks/servicedetail/863.html
     * @example /?/wGmess/getCloudList/
     * @todo cache
     */
    public function getCloudList() {
        $id      = $this->pPost('id');
        $keyword = $this->pPost('key');
        $page    = intval($this->pPost('page')) + 1;
        if (!empty($keyword)) {
            $keyword = urlencode($keyword);
        }
        $apis = "http://apis.baidu.com/showapi_open_bus/weixin/weixin_article_list?typeId=$id&key=$keyword&page=$page";
        $ret  = json_decode(Curl::getWithHeader($apis, 'apikey: d5c983389f7bac5b1884f7ca82ac8247'));
        $this->echoJson($ret->showapi_res_body->pagebean);
    }

    /**
     * 素材克隆
     * @param string $url
     * @param string $contentImg
     * @example /?/wGmess/cloneGmess/
     */
    public function cloneGmess() {

        $url    = $this->pPost('url');
        $catimg = $this->pPost('contentImg');
        $data   = Curl::get($url);
        $html   = new simple_html_dom();
        $html->load($data);
        $rich_media_title = strip_tags($html->find('h2[class=rich_media_title]', 0));
        $js_content       = $html->find('div[id=js_content]', 0);

        if (!empty($rich_media_title) && !empty($js_content)) {
            $this->loadModel('mGmess');
            $desc       = trim(substr(strip_tags($js_content), 0, 100));
            $js_content = trim($js_content);
            if ($this->mGmess->alterGmess(0, $rich_media_title, $js_content, $desc, $catimg)) {
                $this->echoSuccess();
            } else {
                $this->Dao->echoSql();
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }

    }


    /**
     * 高级群发
     * @param type $gmessId
     * @param type $method
     * @param type $isGroup
     * @param type $GroupId
     * @param type $openIds
     * @deprecated
     * @example /?/wGmess/sendGmessNWay/
     */
    public function sendGmessNWay() {
        $this->loadModel('WechatSdk');

        $gmessId = intval($this->post('id'));
        $method  = $this->post('method');
        $groupId = $this->post('groupid');
        $toUser  = $this->post('openid');
        $total   = $this->post('total');

        if ($gmessId > 0) {
            $gmess = $this->mGmess->getGmess($gmessId);
            if ($gmess['catimg'] != '' && $gmess['thumb_media_id'] == '') {
                $thumbMediaId = WechatSdk::upLoadMedia($_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR . 'wshop' . DIRECTORY_SEPARATOR . 'static' . DIRECTORY_SEPARATOR . 'images_gmess' . DIRECTORY_SEPARATOR . $gmess['catimg'], 'image');
                $thumbMediaId = $thumbMediaId['media_id'];
                $this->Db->query("UPDATE `gmess_page` SET `thumb_media_id` = '$thumbMediaId' WHERE `id` = $gmessId;");
            } else {
                $thumbMediaId = $gmess['thumb_media_id'];
            }
            $mediaId = WechatSdk::upLoadGmess($thumbMediaId, $gmess['title'], $gmess['content'], $gmess['desc']);
            if (isset($mediaId['media_id'])) {
                $mediaId = $mediaId['media_id'];
                $this->Db->query("UPDATE `gmess_page` SET `media_id` = '$mediaId' WHERE `id` = $gmessId;");
            }
        }

        if ($method == 'openid') {
            // openid列表群发
            $ret = WechatSdk::sendGmessOpenId($mediaId, $toUser);
            // 总数要换一下
            $total = count($toUser);
        } else if ($method == 'all') {
            $ret = WechatSdk::sendGmessAll($mediaId, true);
        } else if ($method == 'group') {
            $ret = WechatSdk::sendGmessAll($mediaId, false, $groupId);
        } else {
            $ret['errcode'] = 1;
        }
        if (isset($ret) && $ret['errcode'] == 0) {
            $SQL = sprintf("INSERT INTO `gmess_send_stat` (msg_id,send_date,send_count,receive_count,msg_type,send_type) " . " VALUES (%s,NOW(),%s,%s,'images',1);", $gmessId, $total, $total);
            $this->Db->query($SQL);
        }
        echo $ret['errcode'];
    }

    /**
     * 创建群发页面
     * @param type $Query
     * @example /?/wGmess/alterGmessPage/
     */
    public function alterGmessPage() {

        $this->loadModel('mGmess');

        // 是否为更新
        $msgId = $this->getPostInt('msgid');

        // 首图
        $catimg = $this->getPostStr('catimg');

        // 描述
        $digest = $this->getPostStr('desc');

        // 内容
        $content = $this->getPostStr('content');

        // 标题
        $title = $this->getPostStr('title');

        // 显示封面图片
        $show_cover_pic = $this->getPostInt('show_cover_pic', 1);

        // 原文地址
        $content_source_url = $this->getPostStr('content_source_url');

        // 上传数据到微信服务器
        $tData = $this->uploadData($catimg, $title, $content, $digest, $show_cover_pic);

        if ($tData) {
            // 微信素材缩略图id
            $thumbMediaId = $tData[0];
            // 微信素材id
            $mediaId = $tData[1];
            // 编辑素材内容
            $rst = $this->mGmess->alterGmess($msgId, $title, $content, $digest, $catimg, $thumbMediaId, $content_source_url, $mediaId);
            if ($rst) {
                if ($msgId == 0) {
                    $ret['status'] = 1;
                    $ret['url']    = Util::getROOT() . "?/Gmess/view/id=" . $rst;
                    $ret['msgid']  = $rst;
                } else {
                    $ret['status'] = 1;
                }
            } else {
                $ret['status'] = 0;
            }
        }

        $this->echoJson($ret);

    }

    /**
     * 上传数据到腾讯
     * @param $catimg
     * @param $title
     * @param $content
     * @param $digest
     * @param $show_cover_pic
     * @example /?/wGmess/uploadData/
     */
    private function uploadData($catimg, $title, $content, $digest, $show_cover_pic) {
        // 上传数据到腾讯
        $file = file_get_contents($catimg);
        $filename = APP_PATH . '/tmp/' . time() . '.jpg';
        file_put_contents($filename, $file);

        if (is_file($filename)) {
            // 上传首图
            $reSult = WechatSdk::upLoadMedia($filename, 'image');
            // 删除临时文件
            unset($filename);
            if ($reSult && is_array($reSult)) {
                // 媒体编号
                $thumbMediaId = $reSult['media_id'];
                // 上传图文素材到腾讯服务器
                $ret = WechatSdk::upLoadGmess($thumbMediaId, $title, $content, $digest, $show_cover_pic);
                if ($ret && is_array($ret) && isset($ret['media_id'])) {
                    $mediaId = $ret['media_id'];
                    return [$thumbMediaId, $mediaId];
                } else {
                    return false;
                    Util::log("上传微信素材失败" . json_encode($ret));
                }
            } else {
                Util::log("上传微信素材失败" . json_encode($reSult));
                return false;
            }
        } else {
            Util::log("上传微信素材失败, 图片不存在, 或者/tmp/不可写");
            return false;
        }
    }

    /**
     * 发送图文群发
     * @example /?/wGmess/sendGemss/
     */
    public function sendGemss() {
        $mediaId = $this->getPostStr('mediaid');
        if (!empty($mediaId)) {
            // 请求微信服务器 发送群发
            $result = WechatSdk::sendGmessAll($mediaId, true);
            $result = json_decode($result);
            if ($result) {
                if ($result->errcode == 0) {
                    // 发送成功
                    $this->echoSuccess();
                    Util::log("消息群发成功 $mediaId");
                    // @todo 记录发送任务的ID
                } else {
                    Util::log("消息群发失败" . json_encode($result));
                    return $this->echoFail("发送失败, 系统错误");
                }
            } else {
                return $this->echoFail("发送失败, 系统错误");
            }
        } else {
            return $this->echoFail("发送失败, mediaId有误");
        }
    }

}
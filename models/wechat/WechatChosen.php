<?php

class WechatChosen {

    /**
     * 获取分类列表
     */
    public function getCategorys() {
        $apis = "http://apis.baidu.com/showapi_open_bus/weixin/weixin_article_type";
        $ret = json_decode(Curl::getWithHeader($apis, 'apikey: d5c983389f7bac5b1884f7ca82ac8247'));
        return $ret->showapi_res_body->typeList;
    }

    /**
     * 获取列表
     * @param type $id
     * @param type $keyword
     * @param type $page
     */
    public function getList($id, $keyword = '', $page = 0) {
        if (!empty($keyword)) {
            $keyword = urlencode($keyword);
        }
        $apis = "http://apis.baidu.com/showapi_open_bus/weixin/weixin_article_list?typeId=$id&key=$keyword&page=$page";
        $ret = json_decode(Curl::getWithHeader($apis, 'apikey: d5c983389f7bac5b1884f7ca82ac8247'));
        return $ret->showapi_res_body->pagebean;
    }

}

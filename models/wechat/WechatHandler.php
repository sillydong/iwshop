<?php

/**
 * Class WechatHandler
 */
class WechatHandler {

    /**
     * @var
     */
    public $openID;

    /**
     * @var
     */
    public $serverID;

    /**
     * @var
     */
    public $time;

    /**
     * @var WXBizMsgCrypt
     */
    public $aesHelper;

    /**
     * 是否使用aes加密
     * @var bool
     */
    public $aesOn = false;

    /**
     * @var string
     */
    private $nonce = '';

    /**
     * @var Dao
     */
    public $Dao;

    /**
     * @var Db
     */
    public $Db;

    /**
     * @param WechatPostObject $postObj
     */
    public final function init(&$postObj) {

        $this->time     = time();
        $this->openID   = $postObj->FromUserName;
        $this->serverID = $postObj->ToUserName;
        $this->nonce    = isset($_GET['nonce']) ? $_GET['nonce'] : uniqid();

        try {
            $this->handle($postObj);
        } catch (Exception $ex) {
            // 内错误捕捉
            Util::log($ex->getMessage());
        }

        // 多客服接口转发 @see http://dkf.qq.com/
        if ($postObj->MsgType == 'text') {
            echo "<xml><ToUserName><![CDATA[$this->openID]]></ToUserName><FromUserName><![CDATA[$this->serverID]]></FromUserName><CreateTime>$this->time</CreateTime><MsgType><![CDATA[transfer_customer_service]]></MsgType></xml>";
        }

    }

    /**
     * @param WechatPostObject $postObj
     */
    protected function handle(&$postObj) {
        // to be override
    }

    /**
     * 向用户发送文本消息
     * @param string $contentStr
     */
    public final function responseText($contentStr) {
        if (empty($contentStr)) {
            throw new Exception("回复普通文本失败, 内容不能为空!");
        }
        $data = [
            'ToUserName' => $this->openID,
            'FromUserName' => $this->serverID,
            'CreateTime' => $this->time,
            'MsgType' => 'text',
            'Content' => $contentStr,
            'FuncFlag' => 0
        ];
        die($this->packMsg($this->toXML($data)));
    }

    /**
     * 回复图文消息
     * @param type $data
     */
    public function responseImageText($data = array()) {
        $tpl
            = "<xml>
        <ToUserName><![CDATA[%s]]></ToUserName>
        <FromUserName><![CDATA[%s]]></FromUserName>
        <CreateTime>%s</CreateTime>
        <MsgType><![CDATA[news]]></MsgType>
        <ArticleCount>%s</ArticleCount>
        <Articles>%s</Articles>
        </xml>";

        $items = "";
        foreach ($data as $item) {
            $items .= "<item>";
            // cont
            $items .= "<Title><![CDATA[" . $item['title'] . "]]></Title>";
            $items .= "<Description><![CDATA[" . $item['desc'] . "]]></Description>";
            if ($item['url']) {
                $items .= "<Url><![CDATA[" . $item['url'] . "]]></Url>";
            }
            if ($item['picurl']) {
                $items .= "<PicUrl><![CDATA[" . $item['picurl'] . "]]></PicUrl>";
            }
            // cont
            $items .= "</item>";
        }

        $text = sprintf($tpl, $this->openID, $this->serverID, $this->time, count($data), $items);
        die($this->packMsg($text));
    }

    /**
     * 回复图文内容
     * @param int $msgid
     */
    public function echoGmess($msgid) {
        $msgid = intval($msgid);
        $gmess = [];
        $root  = Util::getHOST();
        if (is_array($msgid)) {
            $datas = $this->Dao->select()->from(TABLE_GMESS)->in('id', $msgid)->exec();
        } else if (is_numeric($msgid)) {
            $datas = [$this->Dao->select()->from(TABLE_GMESS)->where([
                'id' => $msgid
            ])->getOneRow()];
        } else {
            throw new Exception("回复图文消息失败,无效消息Id($msgid)");
        }
        if (sizeof($datas) == 0) {
            throw new Exception("回复图文消息失败,素材列表为空($msgid)");
        }
        foreach ($datas as $data) {
            $gmess[] = [
                'title' => $data['title'],
                'url' => "$root/?/Gmess/view/id=$msgid",
                'picurl' => $data['catimg'],
                'desc' => $data['desc']
            ];
        }
        $this->responseImageText($gmess);
    }

    /**
     * @param $text
     * @return string
     */
    private function packMsg($text) {
        Util::log($text);
        if ($this->aesOn) {
            $retmsg  = '';
            $errCode = $this->aesHelper->encryptMsg($text, $this->time, $this->nonce, $retmsg);
            if ($errCode == 0) {
                return $retmsg;
            } else {
                // 加密消息包出错
                Util::log("加密消息包出错 [$errCode] :" . $text);
                return false;
            }
        } else {
            return $text;
        }
    }

    /**
     * @param $arr
     * @return string
     */
    private function toXML($arr) {
        $xml = "<xml>";
        foreach ($arr as $key => $val) {
            if (is_numeric($val)) {
                $xml .= "<" . $key . ">" . $val . "</" . $key . ">";
            } else {
                $xml .= "<" . $key . "><![CDATA[" . $val . "]]></" . $key . ">";
            }
        }
        $xml .= "</xml>";
        return $xml;
    }

}

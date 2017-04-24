<?php

/**
 * Class WechatPostObject
 */
abstract class WechatPostObject
{

    public $ToUserName;
    public $MsgSignature;
    public $FromUserName;
    public $MsgType;
    public $Content;
    public $CreateTime;
    public $Encrypt;
    public $Nonce;
    public $TimeStamp;
    public $Event;
    public $EventKey;

}
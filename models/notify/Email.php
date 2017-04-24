<?php

/**
 * 邮件发送模型
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class Email extends Model {
    //put your code here

    /**
     * @access private
     * @var type 
     */
    private $smtpServer;

    /**
     * @access private
     * @var type 
     */
    private $smtpPort;

    /**
     *
     * @var type 
     */
    public $smtpAccount;

    /**
     *
     * @var type 
     */
    private $smtpPass;

    /**
     * @access private
     * @var type 
     */
    private $socket;

    /**
     * @access private
     * @var type 
     */
    private $socketR;

    /**
     * @access private
     * @var type 
     */
    private $_errorMessage;
    private $_fromName;
    private $_recp;
    private $_content;
    private $_subject;

    /*
     * debug开关
     */
    public $debug = false;

    public function send($recp, $fromName, $subject, $content) {
        global $config;
        if ($config->sendCloudOn) {
            // 使用sendcloud邮件群发服务
            $this->_sendCloud();
        } else {
            $this->init();
            $this->smtpLogin();
            $this->setFrom($fromName);
            $this->setRecp($recp);
            $this->setSubject($subject);
            $this->setContent($content);
            $this->_send();
            $this->close();
        }
    }

    private function setFrom($fromName) {
        $this->_fromName = $fromName;
    }

    private function setRecp($recp) {
        $this->_recp = $recp;
    }

    private function setContent($content) {
        $this->_content = $content;
    }

    private function setSubject($subject) {
        $this->_subject = $subject;
    }

    /**
     * 使用sendCloud发送
     * @see http://sendcloud.sohu.com/
     * @return type
     */
    private function _sendCloud() {

        global $config;

        // 单收货人校正 
        if (!is_array($this->_recp)) {
            $this->_recp = array($this->_recp);
        }

        $data = array(
            'api_user' => 'xb_iwshop_notify', # 使用api_user和api_key进行验证
            'api_key' => '0Qz3I5NPMsh6hGMF',
            'from' => $config->mail['formAddress'], # 发信人，用正确邮件地址替代
            'fromname' => $this->_fromName,
            'to' => implode(';', $this->_recp), # 收件人地址，用正确邮件地址替代，多个地址用';'分隔
            'subject' => $this->_subject,
            'html' => $this->_content
        );

        $result = Curl::post('https://sendcloud.sohu.com/webapi/mail.send.xml', $data);

        return $result;
    }

    private function _send() {
        $separator = "----=_Part_" . md5($this->smtpAccount . time()) . uniqid();
        $DATA = "";
        $DATA .= "FROM: <" . $this->_fromName . "><" . $this->smtpAccount . ">\r\n";
        if (is_array($this->_recp)) {
            $count = count($this->_recp);
            if ($count == 1) {
                $this->sendCommand("RCPT TO: <" . trim($this->_recp[0]) . ">\r\n", 250);
                $DATA .= "TO: <" . trim($this->_recp[0]) . ">\r\n";
            } else {
                for ($i = 0; $i < $count; $i++) {
                    $this->sendCommand("RCPT TO: <" . trim($this->_recp[$i]) . ">\r\n", 250);
                    if ($i == 0) {
                        $DATA .= "TO: <" . trim($this->_recp[$i]) . ">";
                    } elseif ($i + 1 == $count) {
                        $DATA .= ",<" . trim($this->_recp[$i]) . ">\r\n";
                    } else {
                        $DATA .= ",<" . trim($this->_recp[$i]) . ">";
                    }
                }
            }
        } else {
            $this->sendCommand("RCPT TO: <" . $this->_recp . ">\r\n", 250);
            $DATA .= "TO: <" . $this->_recp . ">\r\n";
        }
        $DATA .= "Subject: " . $this->_subject . "\r\n";
        $DATA .= "Content-Type: multipart/alternative;\r\n";
        $DATA .= "\t" . 'boundary="' . $separator . '"';
        $DATA .= "\r\nMIME-Version: 1.0\r\n";
        $DATA .= "\r\n--" . $separator . "\r\n";
        $DATA .= "Content-Type:text/html; charset=utf-8\r\n";
        $DATA .= "Content-Transfer-Encoding: base64\r\n\r\n";
        $DATA .= base64_encode($this->_content) . "\r\n";
        $DATA .= "--" . $separator . "\r\n";
        $DATA .= "\r\n.\r\n";
        $this->sendCommand("DATA\r\n", 354);
        $this->sendCommand($DATA, 250);
        $this->sendCommand("QUIT\r\n", 221);
    }

    public function init() {
        global $config;
        $this->smtpServer = $config->mail['server'];
        $this->smtpAccount = $config->mail['account'];
        $this->smtpPass = $config->mail['password'];
        $this->smtpPort = $config->mail['port'];
        $this->socket = socket_create(AF_INET, SOCK_STREAM, getprotobyname('tcp'));
        // socket_set_block($this->socket);
        socket_connect($this->socket, $this->smtpServer, $this->smtpPort);
        $str = socket_read($this->socket, 1024);
        if (strpos($str, "220") === false) {
            // err
            return false;
        }
        return true;
    }

    public function close() {
        if (isset($this->socket) && is_object($this->socket)) {
            $this->socket->close();
        } else {
            // err
        }
    }

    public function smtpLogin() {
        $this->sendCommand("HELO sendmail\r\n", 250);
        $this->sendCommand("AUTH LOGIN\r\n", 334);
        $this->sendCommand(base64_encode($this->smtpAccount) . "\r\n", 334);
        $this->sendCommand(base64_encode($this->smtpPass) . "\r\n", 235);
        $this->sendCommand("MAIL FROM: <" . $this->smtpAccount . ">\r\n", 250);
    }

    public function sendCommand($command, $code) {
        if ($this->debug) {
            echo PHP_EOL . 'Send command:' . $command . ',expected code:' . $code . PHP_EOL;
        }
        try {
            if (socket_write($this->socket, $command, strlen($command))) {

                //当邮件内容分多次发送时，没有$code，服务器没有返回
                if (empty($code)) {
                    return true;
                }

                //读取服务器返回
                $data = trim(socket_read($this->socket, 1024));
                if ($this->debug) {
                    echo 'response:' . $data . '<br /><br />';
                }

                if ($data) {
                    $pattern = "/^" . $code . "/";
                    if (preg_match($pattern, $data)) {
                        return true;
                    } else {
                        $this->_errorMessage = "Error:" . $data . "|**| command:";
                        return false;
                    }
                } else {
                    $this->_errorMessage = "Error:" . socket_strerror(socket_last_error());
                    return false;
                }
            } else {
                $this->_errorMessage = "Error:" . socket_strerror(socket_last_error());
                return false;
            }
        } catch (Exception $e) {
            $this->_errorMessage = "Error:" . $e->getMessage();
        }
    }

}

<?php

error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_WARNING);

/**
 * @param $retcode
 * @param $retmsg
 */
function echoMsg($retcode, $retmsg = ''){
    header('Content-Type: application/json; charset=utf-8');
    if(!is_array($retmsg)){
        $json = array('retcode' => $retcode, 'retmsg' => urlencode($retmsg));
    } else {
        $json = array('retcode' => $retcode, 'retmsg' => $retmsg);
    }
    echo urldecode(json_encode($json));
}

/**
 * @param $error_level
 * @param $error_message
 * @param $file
 * @param $line
 */
function error_handler ($error_level, $error_message, $file, $line) {
    switch ($error_level) {
        case E_NOTICE:
        case E_USER_NOTICE:
            $error_type = 'Notice';
            break;
        case E_WARNING:
        case E_USER_WARNING:
            $error_type = 'Warning';
            break;
        case E_ERROR:
        case E_USER_ERROR:
            $error_type = 'Fatal Error';
            break;
        default:
            $error_type = 'Unknown';
            break;
    }
    if($error_type != 'Notice'){
        echoMsg(-1, $error_message . ' Line:' . $line);
        die();
    }
}
set_error_handler ('error_handler');
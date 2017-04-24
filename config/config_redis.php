<?php

// redis缓存开关
$config->redis_on = true;

// redis host
$config->redis_host = '127.0.0.1';

// redis 端口
$config->redis_port = 6379;

// redis 过期 60s
$config->redis_exps = 60;

// redis 密码(默认无密码)
$config->redis_auth = '';
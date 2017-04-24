
CREATE TABLE `express_record` (
    `id`  int(11) NOT NULL AUTO_INCREMENT ,
    `order_id`  int(11) NULL DEFAULT NULL ,
    `confirm_time`  datetime NULL DEFAULT NULL ,
    `send_time`  datetime NULL DEFAULT NULL ,
    `costs`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '配送时效' ,
    `openid`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
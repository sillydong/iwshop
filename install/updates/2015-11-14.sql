
-- ----------------------------
-- Table structure for wshop_user_cumulate
-- ----------------------------
CREATE TABLE `wshop_user_cumulate` (
  `ref_date` date NOT NULL,
  `user_source` tinyint(2) DEFAULT '0',
  `cumulate_user` int(11) DEFAULT '0',
  PRIMARY KEY (`ref_date`),
  UNIQUE KEY `ref_date` (`ref_date`,`user_source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_user_summary
-- ----------------------------
CREATE TABLE `wshop_user_summary` (
  `ref_date` date NOT NULL,
  `user_source` tinyint(2) DEFAULT NULL COMMENT '0代表其他（包括带参数二维码） 3代表扫二维码 17代表名片分享 35代表搜号码（即微信添加朋友页的搜索） 39代表查询微信公众帐号 43代表图文页右上角菜单',
  `new_user` int(11) DEFAULT NULL,
  `cancel_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`ref_date`),
  UNIQUE KEY `ref_date` (`ref_date`,`user_source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 默认自动回复
INSERT INTO `wechat_autoresponse`(`key`,`message`,`rel`,`reltype`) VALUES ("default","默认回复","0","0");

ALTER TABLE `products_info` ADD COLUMN `product_storage`  varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '存储条件' AFTER `product_supplier`;

ALTER TABLE `products_info` ADD COLUMN `product_origin`  varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '商品产地' AFTER `product_storage`;

ALTER TABLE `products_info` ADD COLUMN `product_unit`  varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '商品单位' AFTER `product_origin`;

ALTER TABLE `products_info` ADD COLUMN `product_instocks`  int(11) NULL DEFAULT 0 COMMENT '商品库存，在没有规格的时候此字段可用' AFTER `product_unit`;

ALTER IGNORE TABLE `products_info` CHANGE `delete` `is_delete` TINYINT(1) DEFAULT 0;

ALTER TABLE `products_info` DROP COLUMN `store_id`;

ALTER TABLE `orders` ADD COLUMN `address_hash`  varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `is_commented`;

-- ----------------------------
-- Table structure for wshop_settings
-- ----------------------------
DROP TABLE IF EXISTS `wshop_settings`;
CREATE TABLE `wshop_settings` (
  `key` varchar(50) NOT NULL DEFAULT '',
  `value` varchar(512) DEFAULT NULL,
  `last_mod` datetime NOT NULL,
  PRIMARY KEY (`key`),
  KEY `index_key` (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wshop_settings
-- ----------------------------
INSERT INTO `wshop_settings` VALUES ('admin_setting_icon', '', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('admin_setting_qrcode', '', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('auto_envs', '0', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('company_on', '0', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('copyright', '111', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('expcompany', '', '2015-11-18 14:37:59');
INSERT INTO `wshop_settings` VALUES ('order_cancel_day', '7', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('order_confirm_day', '7', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('order_express_openid', '', '2015-11-18 14:37:59');
INSERT INTO `wshop_settings` VALUES ('order_notify_openid', '', '2015-11-18 14:37:59');
INSERT INTO `wshop_settings` VALUES ('record', '**********', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('shopname', '111', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('statcode', '', '2015-11-19 14:59:40');
INSERT INTO `wshop_settings` VALUES ('welcomegmess', '1', '2015-11-19 14:59:40');

-- ----------------------------
-- Table structure for credit_exchange_products
-- ----------------------------
DROP TABLE IF EXISTS `credit_exchange_products`;
CREATE TABLE `credit_exchange_products` (
  `product_id` int(11) NOT NULL,
  `product_credits` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
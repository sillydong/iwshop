--- 系统日志
CREATE TABLE `wshop_logs` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`log_level` tinyint(2) DEFAULT 0 COMMENT '错误级别',
	`log_info` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '错误信息',
	`log_filename` varchar(255) DEFAULT NULL,
	`log_time` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=`InnoDB` AUTO_INCREMENT=1 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

ALTER TABLE `products_info` ADD COLUMN `product_indexes` VARCHAR(50) COLLATE utf8_general_ci DEFAULT '' COMMENT '商品分类搜索索引' AFTER `product_instocks`;
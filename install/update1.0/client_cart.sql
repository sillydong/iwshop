/*
Navicat MySQL Data Transfer

Source Server         : rds
Source Server Version : 50616
Source Host           : ycchenrds.mysql.rds.aliyuncs.com:3306
Source Database       : iwshopdev

Target Server Type    : MYSQL
Target Server Version : 50616
File Encoding         : 65001

Date: 2016-02-26 22:37:54
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for client_cart
-- ----------------------------
DROP TABLE IF EXISTS `client_cart`;
CREATE TABLE `client_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) NOT NULL COMMENT '用户编号',
  `product_id` int(11) NOT NULL COMMENT '商品编号',
  `spec_id` int(11) DEFAULT '0' COMMENT '商品规格',
  `count` int(11) NOT NULL DEFAULT '1' COMMENT '商品数量',
  PRIMARY KEY (`id`),
  KEY `index_openid` (`openid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

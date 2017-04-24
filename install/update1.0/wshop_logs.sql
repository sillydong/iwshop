/*
Navicat MySQL Data Transfer

Source Server         : rds
Source Server Version : 50616
Source Host           : ycchenrds.mysql.rds.aliyuncs.com:3306
Source Database       : iwshopdev

Target Server Type    : MYSQL
Target Server Version : 50616
File Encoding         : 65001

Date: 2016-02-26 23:21:07
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for wshop_logs
-- ----------------------------
DROP TABLE IF EXISTS `wshop_logs`;
CREATE TABLE `wshop_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_level` tinyint(2) DEFAULT '0' COMMENT '错误级别',
  `log_info` text CHARACTER SET utf8 COMMENT '错误信息',
  `log_url` varchar(255) DEFAULT NULL,
  `log_time` datetime DEFAULT NULL,
  `log_ip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

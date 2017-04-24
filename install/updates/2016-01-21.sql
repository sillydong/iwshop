/*
Navicat MySQL Data Transfer

Source Server         : 120.24.212.22
Source Server Version : 50540
Source Host           : 120.24.212.22:3306
Source Database       : iwshop_test

Target Server Type    : MYSQL
Target Server Version : 50540
File Encoding         : 65001

Date: 2016-01-21 15:13:09
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for wshop_settings_nav
-- ----------------------------
DROP TABLE IF EXISTS `wshop_settings_nav`;
CREATE TABLE `wshop_settings_nav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nav_name` varchar(255) NOT NULL COMMENT '菜单名称',
  `nav_ico` varchar(255) NOT NULL COMMENT '显示ICO图片',
  `nav_type` int(11) NOT NULL COMMENT '菜单类型（0.超链接，1.产品分类）',
  `nav_content` text CHARACTER SET utf8,
  `sort` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

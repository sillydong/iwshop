-- phpMyAdmin SQL Dump
-- version 4.0.10.11
-- http://www.phpmyadmin.net
--
-- 主机: 127.0.0.1:3306
-- 生成日期: 2017-04-24 23:25:02
-- 服务器版本: 5.6.17-log
-- PHP 版本: 5.6.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `iwshopold`
--

-- --------------------------------------------------------

--
-- 表的结构 `admin`
--

CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(255) DEFAULT NULL,
  `admin_account` varchar(255) NOT NULL,
  `admin_password` varchar(255) NOT NULL,
  `admin_last_login` datetime DEFAULT NULL,
  `admin_ip_address` varchar(255) DEFAULT NULL,
  `admin_auth` varchar(255) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`admin_account`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='后台管理员' AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `admin`
--

INSERT INTO `admin` (`id`, `admin_name`, `admin_account`, `admin_password`, `admin_last_login`, `admin_ip_address`, `admin_auth`, `supplier_id`) VALUES
(1, '超级管理员', 'admin', 'aa020734260f1f905eb4e38b520de0fcb55155e171c2c60c3dc21c7b01bc725450fcd07b530c675a614959e545d92c98', '2017-04-21 23:53:07', '127.0.0.1', 'stat,orde,prod,gmes,user,comp,sett', 0);

-- --------------------------------------------------------

--
-- 表的结构 `admin_login_records`
--

CREATE TABLE IF NOT EXISTS `admin_login_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `ldate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='后台管理员登录记录' AUTO_INCREMENT=8 ;

--
-- 转存表中的数据 `admin_login_records`
--

INSERT INTO `admin_login_records` (`id`, `account`, `ip`, `ldate`) VALUES
(1, 'admin', '127.0.0.1', '2017-04-21 12:06:01'),
(2, 'admin', '127.0.0.1', '2017-04-21 20:38:35'),
(3, 'admin', '127.0.0.1', '2017-04-21 20:38:37'),
(4, 'admin', '127.0.0.1', '2017-04-21 20:38:39'),
(5, 'admin', '127.0.0.1', '2017-04-21 20:39:22'),
(6, 'admin', '127.0.0.1', '2017-04-21 20:39:45'),
(7, 'admin', '127.0.0.1', '2017-04-21 23:53:07');

-- --------------------------------------------------------

--
-- 表的结构 `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thumb_media_id` varchar(255) DEFAULT NULL COMMENT '图文消息缩略图的media_id，可以在基础支持-上传多媒体文件接口中获得',
  `author` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content_source_url` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `digest` varchar(255) DEFAULT NULL,
  `show_cover_pic` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='图文消息' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组id,自增主键',
  `module` varchar(20) NOT NULL DEFAULT '' COMMENT '用户组所属模块',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '组类型',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `description` varchar(80) NOT NULL DEFAULT '' COMMENT '描述信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '用户组状态：为1正常，为0禁用,-1为删除',
  `rules` text NOT NULL COMMENT '用户组拥有的规则code，多个规则 , 隔开',
  `update_time` int(10) unsigned NOT NULL,
  `create_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `auth_group_access`
--

CREATE TABLE IF NOT EXISTS `auth_group_access` (
  `uid` mediumint(8) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL,
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 表的结构 `auth_rule`
--

CREATE TABLE IF NOT EXISTS `auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `module` varchar(20) NOT NULL DEFAULT '' COMMENT '规则所属module',
  `pid` int(8) NOT NULL DEFAULT '0',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1-url;0-主菜单',
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一英文标识',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '规则中文描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `condition` varchar(255) NOT NULL DEFAULT '' COMMENT '规则附加条件',
  `is_menu` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是按钮',
  `code` varchar(12) NOT NULL DEFAULT '',
  `is_btn` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是按钮',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`) USING BTREE,
  KEY `module` (`status`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `clients`
--

CREATE TABLE IF NOT EXISTS `clients` (
  `client_id` int(25) NOT NULL AUTO_INCREMENT COMMENT '会员卡号',
  `cardno` int(25) DEFAULT NULL COMMENT '线下会员卡号',
  `client_nickname` varchar(512) NOT NULL,
  `client_name` varchar(512) NOT NULL COMMENT '会员姓名',
  `client_sex` varchar(1) DEFAULT NULL COMMENT '会员性别',
  `client_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '会员电话',
  `client_email` varchar(255) DEFAULT NULL,
  `client_head` varchar(255) DEFAULT NULL,
  `client_head_lastmod` datetime DEFAULT NULL,
  `client_password` varchar(255) DEFAULT '' COMMENT '会员密码',
  `client_level` tinyint(3) DEFAULT '0' COMMENT '会员种类\\r\\n1为普通会员\\r\\n0为合作商',
  `client_wechat_openid` varchar(50) NOT NULL DEFAULT '' COMMENT '会员微信openid',
  `client_joindate` date NOT NULL,
  `client_province` varchar(60) DEFAULT NULL,
  `client_city` varchar(60) DEFAULT NULL,
  `client_address` varchar(60) DEFAULT '' COMMENT '会员住址',
  `client_money` float(15,2) NOT NULL DEFAULT '0.00' COMMENT '会员存款',
  `client_credit` int(15) NOT NULL DEFAULT '0' COMMENT '会员积分',
  `client_remark` varchar(255) DEFAULT '' COMMENT '会员备注',
  `client_groupid` int(11) DEFAULT '0',
  `client_storeid` int(10) DEFAULT '0' COMMENT '会员所属店号',
  `client_personid` varchar(255) DEFAULT NULL,
  `client_comid` int(11) DEFAULT '0' COMMENT '代理编号',
  `client_autoenvrec` tinyint(4) DEFAULT '0',
  `client_overdraft_amount` float(11,2) DEFAULT '0.00' COMMENT '用户信用总额',
  `is_com` tinyint(4) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`client_id`),
  UNIQUE KEY `index_openid` (`client_wechat_openid`) USING BTREE,
  KEY `index_comid` (`client_comid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户信息表' AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `clients`
--

INSERT INTO `clients` (`client_id`, `cardno`, `client_nickname`, `client_name`, `client_sex`, `client_phone`, `client_email`, `client_head`, `client_head_lastmod`, `client_password`, `client_level`, `client_wechat_openid`, `client_joindate`, `client_province`, `client_city`, `client_address`, `client_money`, `client_credit`, `client_remark`, `client_groupid`, `client_storeid`, `client_personid`, `client_comid`, `client_autoenvrec`, `client_overdraft_amount`, `is_com`, `deleted`) VALUES
(1, NULL, '陈志东', '陈志东', 'm', '', NULL, 'http://wx.qlogo.cn/mmopen/PiajxSqBRaEJ9icMG1Pxt7gxKrvJztsyUwTHrmJhnQyyACZ2pN7YdPbfkXoGFEuz9gWClRFM120D6jciaTGOqqn5g', '2017-04-21 20:38:22', '', 0, 'oq2YEv-Ep8mTT_TOB56-V5FI_LSw', '2017-04-21', '江苏', '常州', '江苏常州', 0.00, 500, '', 0, 0, NULL, 0, 0, 0.00, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `client_addresses`
--

CREATE TABLE IF NOT EXISTS `client_addresses` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `uname` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `dist` varchar(255) DEFAULT NULL,
  `addrs` varchar(255) DEFAULT NULL,
  `poscode` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户地址信息' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_autoenvs`
--

CREATE TABLE IF NOT EXISTS `client_autoenvs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `envid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户关注自动红包' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_balance_records`
--

CREATE TABLE IF NOT EXISTS `client_balance_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `rtype` enum('default','rebate','deposit','withdrawal') DEFAULT 'default',
  `rtime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户余额记录' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_bank_card`
--

CREATE TABLE IF NOT EXISTS `client_bank_card` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `bankname` varchar(255) DEFAULT NULL,
  `sub` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `dist` varchar(255) DEFAULT NULL,
  `cardno` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户银行卡数据表';

-- --------------------------------------------------------

--
-- 表的结构 `client_cart`
--

CREATE TABLE IF NOT EXISTS `client_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) NOT NULL COMMENT '用户编号',
  `product_id` int(11) NOT NULL COMMENT '商品编号',
  `spec_id` int(11) DEFAULT '0' COMMENT '商品规格',
  `count` int(11) NOT NULL DEFAULT '1' COMMENT '商品数量',
  PRIMARY KEY (`id`),
  KEY `index_openid` (`openid`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户购物车' AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `client_cart`
--

INSERT INTO `client_cart` (`id`, `openid`, `product_id`, `spec_id`, `count`) VALUES
(1, 'oq2YEv-Ep8mTT_TOB56-V5FI_LSw', 1, 0, 1);

-- --------------------------------------------------------

--
-- 表的结构 `client_credit_record`
--

CREATE TABLE IF NOT EXISTS `client_credit_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `amount` int(5) DEFAULT NULL,
  `dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `reltype` tinyint(2) DEFAULT NULL,
  `relid` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `rtime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户积分记录' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_deposit_order`
--

CREATE TABLE IF NOT EXISTS `client_deposit_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `amount` float(11,2) DEFAULT '0.00',
  `deposit_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `deposit_status` enum('wait','payed') DEFAULT 'wait',
  `deposit_serial` varchar(255) DEFAULT NULL COMMENT '订单编号',
  `wepay_serial` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_openid` (`openid`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户充值表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_envelopes`
--

CREATE TABLE IF NOT EXISTS `client_envelopes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `envid` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT '0',
  `exp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户红包表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_envelopes_type`
--

CREATE TABLE IF NOT EXISTS `client_envelopes_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT '0',
  `req_amount` float DEFAULT NULL,
  `dis_amount` float DEFAULT NULL,
  `pid` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户红包类型表' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_feedbacks`
--

CREATE TABLE IF NOT EXISTS `client_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `feedback` text,
  `ftime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户反馈信息' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_level`
--

CREATE TABLE IF NOT EXISTS `client_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level_name` varchar(255) NOT NULL DEFAULT '',
  `level_credit` int(11) NOT NULL,
  `level_discount` float DEFAULT NULL,
  `level_credit_feed` float DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `upable` tinyint(1) DEFAULT '1',
  `isdefault` tinyint(1) DEFAULT '0' COMMENT '是否默认分组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='用户分组' AUTO_INCREMENT=14 ;

--
-- 转存表中的数据 `client_level`
--

INSERT INTO `client_level` (`id`, `level_name`, `level_credit`, `level_discount`, `level_credit_feed`, `remark`, `upable`, `isdefault`) VALUES
(9, '钻石会员', 10000, 75, 2, '', 1, 0),
(10, '铂金会员', 8000, 80, 3, '', 1, 0),
(12, '高级会员', 2000, 90, 8, '', 1, 0),
(13, '普通会员', 500, 100, 10, '', 1, 0);

-- --------------------------------------------------------

--
-- 表的结构 `client_messages`
--

CREATE TABLE IF NOT EXISTS `client_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `msgtype` tinyint(2) DEFAULT '0',
  `msgcont` text,
  `msgdirect` tinyint(4) DEFAULT '0',
  `autoreped` tinyint(4) DEFAULT '0',
  `send_time` datetime DEFAULT NULL,
  `sreaded` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_message_session`
--

CREATE TABLE IF NOT EXISTS `client_message_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `unread` int(11) DEFAULT '0',
  `undesc` varchar(255) DEFAULT NULL,
  `lasttime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniopenid` (`openid`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=35 ;

--
-- 转存表中的数据 `client_message_session`
--

INSERT INTO `client_message_session` (`id`, `openid`, `unread`, `undesc`, `lasttime`) VALUES
(34, 'oYGTiw-_nfws3YXgSqgXDnjRjNh0', 21, 'default', '2017-04-19 13:46:03');

-- --------------------------------------------------------

--
-- 表的结构 `client_order_address`
--

CREATE TABLE IF NOT EXISTS `client_order_address` (
  `addr_id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `tel` varchar(255) NOT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`addr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单地址信息表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_product_likes`
--

CREATE TABLE IF NOT EXISTS `client_product_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) NOT NULL,
  `product_id` int(11) NOT NULL,
  `like_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni` (`openid`,`product_id`) USING BTREE,
  KEY `uopenid` (`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户商品收藏' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_sign_record`
--

CREATE TABLE IF NOT EXISTS `client_sign_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dt` date DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `openid` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dt` (`dt`,`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户签到记录' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `client_urecord`
--

CREATE TABLE IF NOT EXISTS `client_urecord` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `amount` float(11,2) DEFAULT NULL,
  `ctime` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `client_withdrawal_order`
--

CREATE TABLE IF NOT EXISTS `client_withdrawal_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `openid` varchar(255) NOT NULL,
  `amount` float(11,2) NOT NULL DEFAULT '0.00',
  `username` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `bankname` varchar(255) DEFAULT NULL,
  `subbranch` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `dist` varchar(255) DEFAULT NULL,
  `cardno` varchar(255) DEFAULT NULL,
  `rtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('wait','reject','pass') DEFAULT 'wait',
  `serial` varchar(255) DEFAULT NULL COMMENT '订单编号',
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_openid` (`openid`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户提现表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `companys`
--

CREATE TABLE IF NOT EXISTS `companys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '代理的用户编号',
  `gid` int(11) DEFAULT '0' COMMENT '组ID',
  `parent` int(11) DEFAULT '0',
  `name` varchar(200) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `join_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `openid` varchar(255) DEFAULT NULL,
  `money` float DEFAULT '0',
  `alipay` varchar(255) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `bank_account` varchar(255) DEFAULT NULL,
  `bank_personname` varchar(255) DEFAULT NULL,
  `person_id` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `utype` tinyint(4) DEFAULT '0' COMMENT '已废弃字段',
  `verifed` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniuid` (`uid`),
  UNIQUE KEY `uniname` (`name`,`email`,`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理信息表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `company_bills`
--

CREATE TABLE IF NOT EXISTS `company_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comid` int(11) DEFAULT NULL,
  `bill_amount` float(10,2) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理账单信息, 废弃' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `company_income_record`
--

CREATE TABLE IF NOT EXISTS `company_income_record` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` float(11,2) NOT NULL DEFAULT '0.00',
  `date` datetime NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `order_id` int(11) NOT NULL,
  `com_id` varchar(255) NOT NULL,
  `pcount` int(11) NOT NULL,
  `is_seted` tinyint(4) DEFAULT '0',
  `is_reqed` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理收入记录, 废弃' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `company_level`
--

CREATE TABLE IF NOT EXISTS `company_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level_name` varchar(255) NOT NULL DEFAULT '',
  `level_discount` float(11,2) DEFAULT NULL,
  `level_rebate_point` float(11,2) DEFAULT '0.00',
  `level_remark` varchar(255) DEFAULT NULL,
  `level_addtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `upable` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理等级' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `company_rebate_rules`
--

CREATE TABLE IF NOT EXISTS `company_rebate_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level_id` int(11) DEFAULT '0',
  `level_name` varchar(255) DEFAULT NULL,
  `rule_name` varchar(255) DEFAULT NULL COMMENT '规则名称',
  `rebate_level` tinyint(2) DEFAULT '1',
  `rebate_type` enum('amount','percent') DEFAULT 'amount' COMMENT '返佣方式, 固定金额或比例',
  `rebate_amount` float(11,2) DEFAULT NULL,
  `addtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `remark` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '1' COMMENT '是否启用此规则',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理返佣规则' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `company_users`
--

CREATE TABLE IF NOT EXISTS `company_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `comid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniopenid` (`openid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理和用户关联信息' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `envs_robblist`
--

CREATE TABLE IF NOT EXISTS `envs_robblist` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `on` int(11) DEFAULT NULL,
  `remains` int(11) DEFAULT NULL,
  `envsid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `envs_robrecord`
--

CREATE TABLE IF NOT EXISTS `envs_robrecord` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `envsid` int(11) DEFAULT NULL,
  `eid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `express_record`
--

CREATE TABLE IF NOT EXISTS `express_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `confirm_time` datetime DEFAULT NULL,
  `send_time` datetime DEFAULT NULL,
  `costs` varchar(255) DEFAULT '0' COMMENT '配送时效',
  `openid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gmess_category`
--

CREATE TABLE IF NOT EXISTS `gmess_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(255) NOT NULL,
  `parent` int(11) DEFAULT '0',
  `sort` tinyint(4) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gmess_page`
--

CREATE TABLE IF NOT EXISTS `gmess_page` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL COMMENT '内容',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `catimg` varchar(255) NOT NULL DEFAULT '' COMMENT '封面图',
  `thumb_media_id` varchar(255) NOT NULL DEFAULT '',
  `content_source_url` varchar(255) NOT NULL DEFAULT '' COMMENT '原文链接',
  `media_id` varchar(255) NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `category` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '素材分类',
  `deleted` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `hits` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数目',
  `wechat_id` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '公众号ID',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `wei_url` varchar(255) NOT NULL DEFAULT '' COMMENT '微信url',
  `is_check` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否审核',
  `client_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `ad_product` varchar(32) NOT NULL DEFAULT '' COMMENT '推广产品的IDs',
  PRIMARY KEY (`id`),
  KEY `media_id` (`media_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gmess_send_stat`
--

CREATE TABLE IF NOT EXISTS `gmess_send_stat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg_id` int(11) NOT NULL,
  `send_date` datetime DEFAULT NULL,
  `send_count` int(11) DEFAULT NULL,
  `read_count` int(11) DEFAULT '0',
  `share_count` int(11) DEFAULT '0',
  `receive_count` int(11) DEFAULT NULL,
  `send_type` tinyint(4) DEFAULT '0',
  `msg_type` enum('text','images') DEFAULT 'images',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `gmess_tasks`
--

CREATE TABLE IF NOT EXISTS `gmess_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gmess_id` int(11) NOT NULL,
  `task_time` int(11) DEFAULT '0',
  `task_exec_time` int(11) DEFAULT '0',
  `task_finish_time` datetime DEFAULT NULL,
  `admin_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `group_buy`
--

CREATE TABLE IF NOT EXISTS `group_buy` (
  `tuan_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '团购ID',
  `tuan_title` varchar(255) NOT NULL COMMENT '团购标题',
  `product_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `tuan_picture` varchar(100) NOT NULL COMMENT '团购图片',
  `tuan_start_time` datetime NOT NULL COMMENT '活动开始时间',
  `tuan_end_time` datetime NOT NULL COMMENT '活动结束时间',
  `tuan_deposit_price` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '定金',
  `tuan_per_number` int(10) NOT NULL DEFAULT '0' COMMENT '每人限购数量',
  `tuan_send_point` int(11) NOT NULL DEFAULT '0' COMMENT '赠送积分数',
  `tuan_number` int(10) NOT NULL DEFAULT '0' COMMENT '限购数量',
  `tuan_pre_number` int(10) NOT NULL DEFAULT '0' COMMENT '虚拟购买数量',
  `tuan_desc` text NOT NULL COMMENT '团购介绍',
  `tuan_goodshow_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示商品详情',
  `tuan_now_number` int(10) NOT NULL DEFAULT '0' COMMENT '已团购数量',
  `tuan_order` int(10) NOT NULL DEFAULT '0' COMMENT '显示次序',
  `tuan_create_time` datetime NOT NULL COMMENT '团购创建时间',
  `tuan_update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '团购更新时间',
  `tuan_price` decimal(10,3) DEFAULT '0.000' COMMENT '团购价',
  `tuan_bid` int(11) NOT NULL DEFAULT '0' COMMENT '团购所属品牌类目',
  `tuan_cid` int(11) NOT NULL DEFAULT '0' COMMENT '团购所属分类',
  `tuan_baoyou` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否包邮：0：不包邮；1:包邮',
  `tuan_remark` varchar(255) DEFAULT NULL COMMENT '团购简介',
  `tuan_start_code` tinyint(1) DEFAULT '0' COMMENT '是否启用验证码',
  `overdue_start_time` datetime NOT NULL COMMENT '补交余款开始时间',
  `overdue_end_time` datetime NOT NULL COMMENT '补交余款结束时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_deposit` tinyint(1) DEFAULT '0' COMMENT '是否启用担保金',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`tuan_id`),
  KEY `is_active` (`is_active`) USING BTREE,
  KEY `sort_order` (`tuan_order`) USING BTREE,
  KEY `tuan_start_time` (`tuan_start_time`) USING BTREE,
  KEY `tuan_end_time` (`tuan_end_time`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `tuan_goodshow_status` (`tuan_goodshow_status`) USING BTREE,
  KEY `overdue_start_time` (`overdue_start_time`) USING BTREE,
  KEY `overdue_end_time` (`overdue_end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `group_buy_log`
--

CREATE TABLE IF NOT EXISTS `group_buy_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `tuan_id` int(10) NOT NULL DEFAULT '0' COMMENT '团购ID',
  `client_id` int(10) NOT NULL DEFAULT '0' COMMENT '会员ID',
  `product_id` int(10) NOT NULL COMMENT '商品ID',
  `num` int(4) NOT NULL DEFAULT '0' COMMENT '购买数量。取值范围:大于零的整数',
  `remark` varchar(200) NOT NULL COMMENT '备注',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单编号',
  `client_id` int(11) DEFAULT NULL COMMENT '客户编号',
  `serial_number` varchar(30) DEFAULT NULL,
  `order_time` datetime DEFAULT NULL COMMENT '订单交易时间',
  `receive_time` datetime DEFAULT NULL COMMENT '收货时间',
  `send_time` datetime DEFAULT NULL COMMENT '发货时间',
  `order_balance` float(10,2) DEFAULT '0.00' COMMENT '余额抵现',
  `order_expfee` float(10,2) DEFAULT '0.00' COMMENT '订单运费',
  `order_amount` float(10,2) DEFAULT '0.00' COMMENT '总价',
  `order_refund_amount` float(10,2) DEFAULT '0.00',
  `order_discounted` float(11,2) DEFAULT '1.00' COMMENT '订单折扣比例',
  `supply_price_amount` float(10,2) DEFAULT '0.00',
  `original_amount` float(10,2) DEFAULT '0.00',
  `company_id` int(11) DEFAULT '0',
  `product_count` int(11) DEFAULT '0',
  `wepay_serial` varchar(50) DEFAULT NULL,
  `wepay_openid` varchar(255) DEFAULT '',
  `wepay_unionid` varchar(255) DEFAULT NULL,
  `wepayed` varchar(3) DEFAULT NULL COMMENT '订单是否已支付',
  `leword` text,
  `status` enum('unpay','payed','received','canceled','closed','refunded','delivering','reqing') NOT NULL DEFAULT 'unpay' COMMENT '订单状态',
  `express_openid` varchar(255) DEFAULT NULL,
  `express_code` varchar(255) DEFAULT NULL,
  `express_com` varchar(255) DEFAULT NULL,
  `exptime` varchar(255) DEFAULT NULL,
  `envs_id` int(11) DEFAULT '0',
  `is_commented` tinyint(1) DEFAULT '0',
  `address_hash` varchar(255) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT '0',
  `rebated` tinyint(1) DEFAULT '0' COMMENT '返佣是否已经处理',
  `rebated_amount` float(11,2) DEFAULT '0.00' COMMENT '已经返佣的金额',
  PRIMARY KEY (`order_id`),
  KEY `openid` (`wepay_openid`) USING BTREE,
  KEY `serial_number` (`serial_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `orders_address`
--

CREATE TABLE IF NOT EXISTS `orders_address` (
  `addr_id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL DEFAULT '0',
  `order_id` int(11) NOT NULL DEFAULT '0',
  `user_name` varchar(255) NOT NULL,
  `tel_number` varchar(255) NOT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`addr_id`),
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `orders_comment`
--

CREATE TABLE IF NOT EXISTS `orders_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `starts` tinyint(4) DEFAULT NULL,
  `content` text,
  `mtime` datetime DEFAULT NULL,
  `orderid` int(11) DEFAULT NULL,
  `anonymous` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `openid` (`openid`(191)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `orders_detail`
--

CREATE TABLE IF NOT EXISTS `orders_detail` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(20) NOT NULL COMMENT '订单编号',
  `product_id` int(20) NOT NULL COMMENT '商品编号',
  `product_count` int(10) NOT NULL COMMENT '商品数量',
  `product_discount_price` float(11,2) NOT NULL DEFAULT '0.00',
  `original_amount` float(11,2) DEFAULT NULL,
  `product_price_hash_id` int(11) NOT NULL DEFAULT '0',
  `refunded` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`detail_id`),
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `order_credit_available`
--

CREATE TABLE IF NOT EXISTS `order_credit_available` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cfrom` float(5,2) DEFAULT NULL,
  `cto` float(5,2) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `order_rebates`
--

CREATE TABLE IF NOT EXISTS `order_rebates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `comid` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `order_amount` float(11,2) DEFAULT '0.00',
  `order_serial` varchar(255) DEFAULT NULL COMMENT '订单流水号',
  `order_time` datetime DEFAULT NULL COMMENT '下单时间',
  `rebate_amount` float(11,2) DEFAULT '0.00' COMMENT '返佣金额',
  `rebate_type` varchar(255) DEFAULT NULL COMMENT '返佣方式',
  `rebate_rate` float(11,2) DEFAULT '0.00' COMMENT '返佣比率',
  `rebate_level` tinyint(2) DEFAULT '0' COMMENT '返佣级别',
  `rtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('wait','pass','reject') DEFAULT 'wait',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_comid_orderid` (`order_id`,`comid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单返佣表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `order_refundment`
--

CREATE TABLE IF NOT EXISTS `order_refundment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `serial_number` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `refund_amount` float(10,2) DEFAULT '0.00',
  `refund_time` datetime DEFAULT NULL,
  `refund_type` tinyint(4) DEFAULT '0',
  `refund_serial` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `payment_type` tinyint(2) DEFAULT '0',
  `dowhois` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `products_info`
--

CREATE TABLE IF NOT EXISTS `products_info` (
  `product_id` int(20) NOT NULL AUTO_INCREMENT COMMENT '商品编号',
  `product_code` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '0' COMMENT '商品条码',
  `product_name` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '商品名称',
  `product_subname` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '商品颜色',
  `product_size` varchar(40) CHARACTER SET utf8 DEFAULT NULL COMMENT '商品大小',
  `product_cat` int(11) NOT NULL DEFAULT '1',
  `product_brand` int(11) DEFAULT '0',
  `product_readi` int(11) NOT NULL DEFAULT '0',
  `product_desc` longtext CHARACTER SET utf8,
  `product_subtitle` text CHARACTER SET utf8,
  `product_serial` int(11) DEFAULT '0',
  `product_weight` varchar(11) CHARACTER SET utf8 DEFAULT '0.00',
  `product_online` tinyint(4) DEFAULT '1',
  `product_credit` int(11) DEFAULT '0',
  `product_prom` int(11) DEFAULT '0',
  `product_prom_limit` int(11) DEFAULT '0',
  `product_prom_limitdate` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `product_prom_limitdays` int(11) DEFAULT '0',
  `product_prom_discount` int(11) DEFAULT '0',
  `product_expfee` float(5,2) DEFAULT '0.00' COMMENT '商品快递费用',
  `product_supplier` int(11) DEFAULT '0',
  `product_storage` varchar(255) CHARACTER SET utf8 DEFAULT '' COMMENT '存储条件',
  `product_origin` varchar(255) CHARACTER SET utf8 DEFAULT '' COMMENT '商品产地',
  `product_unit` varchar(255) CHARACTER SET utf8 DEFAULT '' COMMENT '商品单位',
  `product_instocks` int(11) DEFAULT '0' COMMENT '商品库存，在没有规格的时候此字段可用',
  `product_indexes` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT '商品分类搜索索引',
  `supply_price` float(11,2) DEFAULT '0.00',
  `sell_price` float(11,2) DEFAULT '0.00',
  `market_price` float(11,2) DEFAULT '0.00',
  `catimg` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `sort` int(10) DEFAULT '0',
  `is_delete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`product_id`),
  KEY `product_name` (`product_name`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='商品信息表' AUTO_INCREMENT=6 ;

--
-- 转存表中的数据 `products_info`
--

INSERT INTO `products_info` (`product_id`, `product_code`, `product_name`, `product_subname`, `product_size`, `product_cat`, `product_brand`, `product_readi`, `product_desc`, `product_subtitle`, `product_serial`, `product_weight`, `product_online`, `product_credit`, `product_prom`, `product_prom_limit`, `product_prom_limitdate`, `product_prom_limitdays`, `product_prom_discount`, `product_expfee`, `product_supplier`, `product_storage`, `product_origin`, `product_unit`, `product_instocks`, `product_indexes`, `supply_price`, `sell_price`, `market_price`, `catimg`, `sort`, `is_delete`) VALUES
(1, '0', 'asfdasdfasdf', 'asfdasdfasdf', NULL, 3, 0, 17, '<p>sdfasdfasdfasdfasfdasdf</p><p><img src="http://tianjiacdn.dongwutec.com/tianjia/a99f/27bf9/a99fb720179d31e90ee0199858db5deb.jpg" _src="http://tianjiacdn.dongwutec.com/tianjia/a99f/27bf9/a99fb720179d31e90ee0199858db5deb.jpg" style=""/></p><p><img src="http://tianjiacdn.dongwutec.com/tianjia/235d/c9fd5/235df9cc226ff537ada80487d82949ba.jpg" _src="http://tianjiacdn.dongwutec.com/tianjia/235d/c9fd5/235df9cc226ff537ada80487d82949ba.jpg" style=""/></p><p><br/></p>', '', 0, '0', 1, 0, 0, 0, '', 0, 0, 0.00, 0, '', '', '', 0, '', 0.00, 1.00, 1.00, '//tianjiacdn.dongwutec.com/tianjia/72c7/4a87c/72c78a4af7b0f123e7c1c69b233eabd5.jpg', 0, 0),
(2, 'asssssssss', 'ffffffff', 'ffffffff', NULL, 3, 0, 2, '<p>asdfasdfasdfasdfasfasfdasdfasdfasdf</p>', 'ssssssssss', 0, '0', 1, 0, 0, 0, '', 0, 0, 0.00, 0, '', '', '', 0, '', 0.00, 0.00, 0.00, '//tianjiacdn.dongwutec.com/tianjia/081a/f9ca1/081ac9f5fa3a590ba232c48148f15909.jpg', 0, 0),
(5, 'sdfgsdgsdg', 'ergsdfgsdfg', 'sdfgsdfgsdgf', NULL, 3, 0, 0, '<p>asfasfzxfasdfasfasf</p>', NULL, 0, '0', 1, 0, 0, 0, NULL, 0, 0, 0.00, 0, '', '', '', 0, '', 0.00, 1.00, 1.00, '//tianjiacdn.dongwutec.com/tianjia/9a40/7e404/9a404e748f29362c58bac9d3035fe43e.jpg', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `product_brand`
--

CREATE TABLE IF NOT EXISTS `product_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(255) DEFAULT NULL,
  `brand_img1` varchar(255) DEFAULT NULL,
  `brand_img2` varchar(255) DEFAULT NULL,
  `brand_cat` int(11) DEFAULT NULL,
  `sort` tinyint(4) DEFAULT '0',
  `deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniname` (`brand_name`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `product_brand`
--

INSERT INTO `product_brand` (`id`, `brand_name`, `brand_img1`, `brand_img2`, `brand_cat`, `sort`, `deleted`) VALUES
(1, '威宁特产', NULL, '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/31b6/be56b/31b65eb41c32043a0ef2817ee65d9235.jpg', 20, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `product_category`
--

CREATE TABLE IF NOT EXISTS `product_category` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(255) NOT NULL,
  `cat_descs` text,
  `cat_image` varchar(255) NOT NULL DEFAULT '',
  `cat_parent` int(11) NOT NULL DEFAULT '0',
  `cat_level` int(11) DEFAULT '0',
  `cat_order` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否启用',
  PRIMARY KEY (`cat_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=29 ;

--
-- 转存表中的数据 `product_category`
--

INSERT INTO `product_category` (`cat_id`, `cat_name`, `cat_descs`, `cat_image`, `cat_parent`, `cat_level`, `cat_order`, `status`) VALUES
(2, '礼品精选', '', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/446b/930b6/446b039e38ce6b51cbbf23371638c3f5.jpg', 0, 0, 1, 1),
(3, '特产荟萃', '', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/b4ea/a1cae/b4eac1ac3c12bf59ac7f5ce9b18dfd2b.jpg', 0, 0, 5, 1),
(4, '保健特产', '', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/2206/73860/2206837bcc2d9820697610ff721be02e.jpg', 0, 0, 3, 1),
(5, '礼品精选', '', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/8c26/14d62/8c26d419769a82e567003aac7c99b8c8.jpg', 0, 0, 4, 1),
(18, '产品试用', NULL, '//opencdn.iwshop.cn/iwshop/35f4/a524f/35f425a2414804929d21a2717719184b.jpg', 0, 0, 0, 1),
(21, '品牌特卖', NULL, '//buckoss.oss-cn-shenzhen.aliyuncs.com/iwshop/8753/7a435/87534a725cd576b0a458c1229574e792.jpg', 0, 0, 0, 1),
(22, '台式电脑采购', NULL, '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/8b71/3f317/8b713f3e50a38f40c092b629aef9bedd.jpg', 21, 0, 0, 1),
(23, '笔记本电脑采购', NULL, '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/7f5b/813b5/7f5b3188ee1b6ca8ba94bf1b2b3476d7.jpg', 21, 0, 0, 1),
(25, '微信开发', NULL, '//opencdn.iwshop.cn/iwshop/35f4/a524f/35f425a2414804929d21a2717719184b.jpg', 18, 0, 0, 1),
(26, '打印机采购维护', NULL, '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/0f89/47398/0f89374328b19283520f7719a39a3bda.jpg', 21, 0, 0, 1),
(27, '网站开发', NULL, '', 18, 0, 0, 1),
(28, '手机APP开发', NULL, '', 18, 0, 0, 1);

-- --------------------------------------------------------

--
-- 表的结构 `product_credit_exanges`
--

CREATE TABLE IF NOT EXISTS `product_credit_exanges` (
  `product_id` int(11) NOT NULL,
  `product_credits` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `product_images`
--

CREATE TABLE IF NOT EXISTS `product_images` (
  `product_id` int(11) NOT NULL DEFAULT '0',
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `image_path` varchar(512) NOT NULL,
  `image_sort` tinyint(4) DEFAULT '0',
  `image_type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`image_id`),
  KEY `index_product` (`product_id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- 转存表中的数据 `product_images`
--

INSERT INTO `product_images` (`product_id`, `image_id`, `image_path`, `image_sort`, `image_type`) VALUES
(1, 6, '', 0, 0),
(1, 7, '', 1, 0),
(1, 8, '', 2, 0),
(1, 9, '', 3, 0),
(1, 10, '', 4, 0),
(2, 21, '', 0, 0),
(2, 22, '', 1, 0),
(2, 23, '', 2, 0),
(2, 24, '', 3, 0),
(2, 25, '', 4, 0),
(5, 26, '', 0, 0),
(5, 27, '', 1, 0),
(5, 28, '', 2, 0),
(5, 29, '', 3, 0),
(5, 30, '', 4, 0);

-- --------------------------------------------------------

--
-- 表的结构 `product_onsale`
--

CREATE TABLE IF NOT EXISTS `product_onsale` (
  `product_id` int(20) NOT NULL AUTO_INCREMENT COMMENT '商品编号',
  `sale_prices` float(10,2) NOT NULL DEFAULT '0.00' COMMENT '售价',
  `store_id` int(8) NOT NULL DEFAULT '0' COMMENT '商店编号',
  `discount` int(3) NOT NULL DEFAULT '100' COMMENT '折扣',
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- 转存表中的数据 `product_onsale`
--

INSERT INTO `product_onsale` (`product_id`, `sale_prices`, `store_id`, `discount`) VALUES
(1, 1.00, 0, 1),
(2, 0.00, 0, 1),
(5, 1.00, 0, 1);

-- --------------------------------------------------------

--
-- 表的结构 `product_serials`
--

CREATE TABLE IF NOT EXISTS `product_serials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_name` varchar(255) DEFAULT NULL COMMENT '序列名称',
  `serial_image` varchar(255) DEFAULT NULL,
  `serial_desc` varchar(255) DEFAULT NULL,
  `relcat` tinyint(4) DEFAULT NULL,
  `relevel` tinyint(4) DEFAULT NULL,
  `sort` varchar(255) DEFAULT '0' COMMENT '排序',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- 转存表中的数据 `product_serials`
--

INSERT INTO `product_serials` (`id`, `serial_name`, `serial_image`, `serial_desc`, `relcat`, `relevel`, `sort`, `deleted`) VALUES
(0, '默认', NULL, NULL, NULL, NULL, '0', 0);

-- --------------------------------------------------------

--
-- 表的结构 `product_spec`
--

CREATE TABLE IF NOT EXISTS `product_spec` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `spec_det_id1` int(11) DEFAULT NULL,
  `spec_det_id2` int(11) DEFAULT NULL,
  `sale_price` float(11,2) DEFAULT NULL,
  `market_price` float(11,2) DEFAULT '0.00',
  `instock` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品规格' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wechats`
--

CREATE TABLE IF NOT EXISTS `wechats` (
  `wechat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wechat_name` varchar(32) NOT NULL COMMENT '公众号名称',
  `account` varchar(32) NOT NULL COMMENT '帐号',
  `original_account` varchar(32) NOT NULL COMMENT '原始帐号',
  `app_id` varchar(64) NOT NULL,
  `app_secret` varchar(64) NOT NULL,
  `encodingaeskey` varchar(64) NOT NULL DEFAULT '',
  `token` varchar(64) NOT NULL COMMENT '验证token',
  `entry_hash` varchar(64) NOT NULL COMMENT '入口hash用于区别所属公众号',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '服务器地址',
  `access_token` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`wechat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wechat_autoresponse`
--

CREATE TABLE IF NOT EXISTS `wechat_autoresponse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `message` text,
  `rel` int(11) DEFAULT '0',
  `reltype` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_banners`
--

CREATE TABLE IF NOT EXISTS `wshop_banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `banner_name` varchar(255) DEFAULT NULL,
  `banner_href` varchar(255) DEFAULT NULL,
  `banner_image` varchar(255) DEFAULT NULL,
  `banner_position` tinyint(4) DEFAULT '0',
  `reltype` tinyint(4) DEFAULT NULL,
  `relid` varchar(255) DEFAULT '0',
  `sort` tinyint(4) DEFAULT '0',
  `exp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `wshop_banners`
--

INSERT INTO `wshop_banners` (`id`, `banner_name`, `banner_href`, `banner_image`, `banner_position`, `reltype`, `relid`, `sort`, `exp`) VALUES
(1, 'asdfasdf', '', '//tianjiacdn.dongwutec.com/tianjia/c9d5/0515d/c9d5150470bec45d255da5a7027f9bf6.jpg', 0, 0, '3', 1, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `wshop_board_messages`
--

CREATE TABLE IF NOT EXISTS `wshop_board_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` text,
  `mtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_expresstaff`
--

CREATE TABLE IF NOT EXISTS `wshop_expresstaff` (
  `id` int(11) NOT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `headimg` varchar(255) DEFAULT NULL,
  `uname` varchar(255) DEFAULT NULL,
  `isnotify` tinyint(1) DEFAULT '0',
  `isexpress` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_logs`
--

CREATE TABLE IF NOT EXISTS `wshop_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_level` tinyint(2) DEFAULT '0' COMMENT '错误级别',
  `log_info` text COMMENT '错误信息',
  `log_url` varchar(255) DEFAULT NULL,
  `log_time` datetime DEFAULT NULL,
  `log_ip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='系统日志' AUTO_INCREMENT=8 ;

--
-- 转存表中的数据 `wshop_logs`
--

INSERT INTO `wshop_logs` (`id`, `log_level`, `log_info`, `log_url`, `log_time`, `log_ip`) VALUES
(1, 0, '访问错误：方法不存在 WdminPage->discount_code_list() 不存在', 'http://wechat.dongwutec.com/?/WdminPage/discount_code_list', '2017-04-20 21:22:51', '127.0.0.1'),
(2, 0, '访问错误：方法不存在 WdminPage->discount_code_list() 不存在', 'http://wechat.dongwutec.com/?/WdminPage/discount_code_list', '2017-04-20 21:22:53', '127.0.0.1'),
(3, 0, '访问错误：方法不存在 WdminPage->discount_code_list() 不存在', 'http://wechat.dongwutec.com/?/WdminPage/discount_code_list', '2017-04-20 21:25:19', '127.0.0.1'),
(4, 0, '访问错误：方法不存在 WdminPage->discount_code_list() 不存在', 'http://wechat.dongwutec.com/?/WdminPage/discount_code_list', '2017-04-20 21:29:45', '127.0.0.1'),
(5, 0, '登录成功 admin', 'http://wechat.dongwutec.com/?/Wdmin/checkLogin/', '2017-04-21 12:06:01', '127.0.0.1'),
(6, 0, '登录成功 admin', 'http://tianjia.dongwutec.com/?/Wdmin/checkLogin/', '2017-04-21 20:39:45', '127.0.0.1'),
(7, 0, '登录成功 admin', 'http://tianjia.dongwutec.com/?/Wdmin/checkLogin/', '2017-04-21 23:53:07', '127.0.0.1');

-- --------------------------------------------------------

--
-- 表的结构 `wshop_menu`
--

CREATE TABLE IF NOT EXISTS `wshop_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `relid` int(11) DEFAULT NULL,
  `reltype` tinyint(4) DEFAULT NULL,
  `relcontent` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_recomment_company`
--

CREATE TABLE IF NOT EXISTS `wshop_recomment_company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `status` enum('unfix','fixed','close') DEFAULT 'unfix',
  `content` text,
  `comid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_search_record`
--

CREATE TABLE IF NOT EXISTS `wshop_search_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_settings`
--

CREATE TABLE IF NOT EXISTS `wshop_settings` (
  `key` varchar(50) NOT NULL DEFAULT '',
  `value` varchar(512) DEFAULT NULL,
  `last_mod` datetime NOT NULL,
  `remark` varchar(255) DEFAULT '无',
  PRIMARY KEY (`key`),
  KEY `index_key` (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统设置表';

--
-- 转存表中的数据 `wshop_settings`
--

INSERT INTO `wshop_settings` (`key`, `value`, `last_mod`, `remark`) VALUES
('admin_setting_icon', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/3acd/b52dc/3acd25b6cd5865b2d95a0bce3f9d238a.png', '2017-04-21 20:39:58', '无'),
('admin_setting_qrcode', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/d6d3/c723d/d6d327c6e3d3b96dd0e1c64ef79fbe6b.jpg', '2017-04-21 20:39:58', '无'),
('auto_envs', '0', '2017-04-21 20:39:58', '无'),
('company_on', '1', '2017-04-21 20:39:58', '无'),
('copyright', '© 2016-2017 TianJia All rights reserved.', '2017-04-21 20:39:58', '无'),
('credit_ex', '0.01', '2017-04-21 20:39:58', '无'),
('credit_order_amount', '1', '2017-04-21 20:39:58', '无'),
('dispatch_day', '10', '2017-04-05 11:38:20', '无'),
('dispatch_day_zone', '9:00-12:00,14:00-18:00,18:00-21:00', '2017-04-05 11:38:20', '无'),
('expcompany', 'ems,guotong,jingdong,kuaijie,ririshun,shentong,shunfeng,tiantian,yousu,yuantong,yunda,zhongtong,anwl', '2017-04-14 09:28:51', '无'),
('exp_weight1', '1000', '2017-04-05 11:38:20', '无'),
('exp_weight2', '1000', '2017-04-05 11:38:20', '无'),
('order_cancel_day', '30', '2017-04-21 20:39:58', '无'),
('order_confirm_day', '30', '2017-04-21 20:39:58', '无'),
('order_express_openid', 'oYGTiwwlsMb2TLIS6c5VuTb4B080,oYGTiw-_nfws3YXgSqgXDnjRjNh0,oYGTiw_20KYykM3leY914uQwEgIE', '2017-04-14 09:28:51', '无'),
('order_notify_openid', 'oYGTiwwlsMb2TLIS6c5VuTb4B080,oYGTiw-_nfws3YXgSqgXDnjRjNh0,oYGTiw_20KYykM3leY914uQwEgIE', '2017-04-14 09:28:51', '无'),
('reci_cont', '普通发票,增值发票', '2017-04-21 20:39:58', '无'),
('reci_exp_open', '0', '2017-04-21 20:39:58', '无'),
('reci_open', '1', '2017-04-21 20:39:58', '无'),
('reci_perc', '10', '2017-04-21 20:39:58', '无'),
('reg_credit_default', '500', '2017-04-21 20:39:58', '无'),
('shopname', '恬家商城', '2017-04-21 20:39:58', '无'),
('sign_credit', '1', '2017-04-21 20:39:58', '无'),
('sign_daylim', '0', '2017-04-21 20:39:58', '无'),
('statcode', '', '2017-04-21 20:39:58', '无'),
('ucenter_background_image', '//yhuixm.oss-cn-shenzhen.aliyuncs.com/iwshop/14ab/811ba/14ab1186720a80a73f6d0c2639631927.jpg', '2017-04-21 20:39:58', '无'),
('welcomegmess', '', '2017-04-21 20:39:58', '无');

-- --------------------------------------------------------

--
-- 表的结构 `wshop_settings_expfee`
--

CREATE TABLE IF NOT EXISTS `wshop_settings_expfee` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `province` varchar(255) DEFAULT '',
  `citys` varchar(255) DEFAULT NULL,
  `ffee` float DEFAULT NULL,
  `ffeeadd` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='系统设置-运费模板' AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `wshop_settings_expfee`
--

INSERT INTO `wshop_settings_expfee` (`id`, `province`, `citys`, `ffee`, `ffeeadd`) VALUES
(1, '江苏|四川|贵州', NULL, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `wshop_settings_nav`
--

CREATE TABLE IF NOT EXISTS `wshop_settings_nav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nav_name` varchar(255) NOT NULL COMMENT '菜单名称',
  `nav_ico` varchar(255) NOT NULL COMMENT '显示ICO图片',
  `nav_type` int(11) NOT NULL COMMENT '菜单类型（0.超链接，1.产品分类）',
  `nav_content` text,
  `sort` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='系统设置-导航' AUTO_INCREMENT=28 ;

--
-- 转存表中的数据 `wshop_settings_nav`
--

INSERT INTO `wshop_settings_nav` (`id`, `nav_name`, `nav_ico`, `nav_type`, `nav_content`, `sort`) VALUES
(26, 'aaa', '//tianjiacdn.dongwutec.com/tianjia/ec36/cc463/ec364cc351eafaf868ecccf627ca30ef.jpg', 1, '3', 0),
(27, 'ccc', '//tianjiacdn.dongwutec.com/tianjia/10de/4aded/10deda437f916a81262dddb0c0f9a8d7.jpg', 1, '3', 0);

-- --------------------------------------------------------

--
-- 表的结构 `wshop_settings_section`
--

CREATE TABLE IF NOT EXISTS `wshop_settings_section` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `pid` varchar(255) DEFAULT NULL,
  `banner` varchar(255) DEFAULT NULL,
  `reltype` varchar(1) DEFAULT '0' COMMENT '首页版块类型0：产品分类 展示版块 1：产品列表 展示版块 2:图文消息 展示版块 3:超链接 展示版块 4:广告列表 展示版块',
  `relid` int(5) DEFAULT NULL,
  `bsort` tinyint(5) DEFAULT '0',
  `ftime` datetime DEFAULT NULL,
  `ttime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=20 ;

--
-- 转存表中的数据 `wshop_settings_section`
--

INSERT INTO `wshop_settings_section` (`id`, `name`, `pid`, `banner`, `reltype`, `relid`, `bsort`, `ftime`, `ttime`) VALUES
(18, 'sadfasdfasdfasfd', '1', '//tianjiacdn.dongwutec.com/tianjia/b498/28d89/b498d82280cffa7a84b1863103c40e58.jpg', '0', 3, 0, NULL, NULL),
(19, 'asdfasfdasfd', '1', '', '1', 3, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `wshop_spec`
--

CREATE TABLE IF NOT EXISTS `wshop_spec` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spec_name` varchar(255) NOT NULL,
  `spec_remark` varchar(255) DEFAULT NULL,
  `spec_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_spec_det`
--

CREATE TABLE IF NOT EXISTS `wshop_spec_det` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spec_id` int(11) NOT NULL,
  `det_name` varchar(255) NOT NULL,
  `det_sort` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_suppliers`
--

CREATE TABLE IF NOT EXISTS `wshop_suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_name` varchar(120) DEFAULT NULL,
  `supp_phone` varchar(255) DEFAULT NULL,
  `supp_stime` varchar(255) DEFAULT NULL,
  `supp_sprice` varchar(255) DEFAULT NULL,
  `supp_sarea` varchar(255) DEFAULT NULL,
  `supp_desc` text,
  `supp_pass` varchar(255) DEFAULT NULL,
  `supp_lastlogin` datetime DEFAULT NULL,
  `is_verified` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniname` (`supp_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `wshop_user_cumulate`
--

CREATE TABLE IF NOT EXISTS `wshop_user_cumulate` (
  `ref_date` date NOT NULL,
  `user_source` tinyint(2) NOT NULL DEFAULT '0',
  `cumulate_user` int(11) DEFAULT '0',
  PRIMARY KEY (`ref_date`,`user_source`),
  UNIQUE KEY `ref_date` (`ref_date`,`user_source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信粉丝统计数据';

--
-- 转存表中的数据 `wshop_user_cumulate`
--

INSERT INTO `wshop_user_cumulate` (`ref_date`, `user_source`, `cumulate_user`) VALUES
('2017-04-15', 0, 7),
('2017-04-16', 0, 7),
('2017-04-17', 0, 7),
('2017-04-18', 0, 7),
('2017-04-19', 0, 7),
('2017-04-20', 0, 7);

-- --------------------------------------------------------

--
-- 表的结构 `wshop_user_summary`
--

CREATE TABLE IF NOT EXISTS `wshop_user_summary` (
  `ref_date` date NOT NULL,
  `user_source` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0代表其他（包括带参数二维码） 3代表扫二维码 17代表名片分享 35代表搜号码（即微信添加朋友页的搜索） 39代表查询微信公众帐号 43代表图文页右上角菜单',
  `new_user` int(11) DEFAULT NULL,
  `cancel_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`ref_date`,`user_source`),
  UNIQUE KEY `ref_date` (`ref_date`,`user_source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信粉丝统计数据';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

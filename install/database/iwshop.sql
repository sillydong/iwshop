
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(255) DEFAULT NULL,
  `admin_account` varchar(255) NOT NULL,
  `admin_password` varchar(255) NOT NULL,
  `admin_last_login` datetime DEFAULT NULL,
  `admin_ip_address` varchar(255) DEFAULT NULL,
  `admin_auth` varchar(255) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`admin_account`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='后台管理员';

-- ----------------------------
-- Table structure for admin_login_records
-- ----------------------------
DROP TABLE IF EXISTS `admin_login_records`;
CREATE TABLE `admin_login_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `ldate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='后台管理员登录记录';

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thumb_media_id` varchar(255) DEFAULT NULL COMMENT '图文消息缩略图的media_id，可以在基础支持-上传多媒体文件接口中获得',
  `author` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content_source_url` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `digest` varchar(255) DEFAULT NULL,
  `show_cover_pic` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='图文消息';

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_access`;
CREATE TABLE `auth_group_access` (
  `uid` mediumint(8) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL,
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule`;
CREATE TABLE `auth_rule` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for clients
-- ----------------------------
DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `client_id` int(25) NOT NULL AUTO_INCREMENT COMMENT '会员卡号',
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户信息表';

-- ----------------------------
-- Table structure for client_addresses
-- ----------------------------
DROP TABLE IF EXISTS `client_addresses`;
CREATE TABLE `client_addresses` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户地址信息';

-- ----------------------------
-- Table structure for client_autoenvs
-- ----------------------------
DROP TABLE IF EXISTS `client_autoenvs`;
CREATE TABLE `client_autoenvs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `envid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户关注自动红包';

-- ----------------------------
-- Table structure for client_balance_records
-- ----------------------------
DROP TABLE IF EXISTS `client_balance_records`;
CREATE TABLE `client_balance_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `rtype` enum('default','rebate','deposit','withdrawal') DEFAULT 'default',
  `rtime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户余额记录';

-- ----------------------------
-- Table structure for client_bank_card
-- ----------------------------
DROP TABLE IF EXISTS `client_bank_card`;
CREATE TABLE `client_bank_card` (
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
  KEY `index_openid` (`openid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户购物车';

-- ----------------------------
-- Table structure for client_credit_record
-- ----------------------------
DROP TABLE IF EXISTS `client_credit_record`;
CREATE TABLE `client_credit_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `amount` int(5) DEFAULT NULL,
  `dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `reltype` tinyint(2) DEFAULT NULL,
  `relid` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `rtime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户积分记录';

-- ----------------------------
-- Table structure for client_deposit_order
-- ----------------------------
DROP TABLE IF EXISTS `client_deposit_order`;
CREATE TABLE `client_deposit_order` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户充值表';

-- ----------------------------
-- Table structure for client_envelopes
-- ----------------------------
DROP TABLE IF EXISTS `client_envelopes`;
CREATE TABLE `client_envelopes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `envid` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT '0',
  `exp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户红包表';

-- ----------------------------
-- Table structure for client_envelopes_type
-- ----------------------------
DROP TABLE IF EXISTS `client_envelopes_type`;
CREATE TABLE `client_envelopes_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT '0',
  `req_amount` float DEFAULT NULL,
  `dis_amount` float DEFAULT NULL,
  `pid` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户红包类型表';

-- ----------------------------
-- Table structure for client_feedbacks
-- ----------------------------
DROP TABLE IF EXISTS `client_feedbacks`;
CREATE TABLE `client_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `feedback` text,
  `ftime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户反馈信息';

-- ----------------------------
-- Table structure for client_level
-- ----------------------------
DROP TABLE IF EXISTS `client_level`;
CREATE TABLE `client_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level_name` varchar(255) NOT NULL DEFAULT '',
  `level_credit` int(11) NOT NULL,
  `level_discount` float DEFAULT NULL,
  `level_credit_feed` float DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `upable` tinyint(1) DEFAULT '1',
  `isdefault` tinyint(1) DEFAULT '0' COMMENT '是否默认分组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户分组';

-- ----------------------------
-- Table structure for client_messages
-- ----------------------------
DROP TABLE IF EXISTS `client_messages`;
CREATE TABLE `client_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `msgtype` tinyint(2) DEFAULT '0',
  `msgcont` text,
  `msgdirect` tinyint(4) DEFAULT '0',
  `autoreped` tinyint(4) DEFAULT '0',
  `send_time` datetime DEFAULT NULL,
  `sreaded` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for client_message_session
-- ----------------------------
DROP TABLE IF EXISTS `client_message_session`;
CREATE TABLE `client_message_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `unread` int(11) DEFAULT '0',
  `undesc` varchar(255) DEFAULT NULL,
  `lasttime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniopenid` (`openid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for client_order_address
-- ----------------------------
DROP TABLE IF EXISTS `client_order_address`;
CREATE TABLE `client_order_address` (
  `addr_id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `tel` varchar(255) NOT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`addr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单地址信息表';

-- ----------------------------
-- Table structure for client_product_likes
-- ----------------------------
DROP TABLE IF EXISTS `client_product_likes`;
CREATE TABLE `client_product_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) NOT NULL,
  `product_id` int(11) NOT NULL,
  `like_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni` (`openid`,`product_id`) USING BTREE,
  KEY `uopenid` (`openid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户商品收藏';

-- ----------------------------
-- Table structure for client_sign_record
-- ----------------------------
DROP TABLE IF EXISTS `client_sign_record`;
CREATE TABLE `client_sign_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dt` date DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `openid` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dt` (`dt`,`openid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户签到记录';

-- ----------------------------
-- Table structure for client_urecord
-- ----------------------------
DROP TABLE IF EXISTS `client_urecord`;
CREATE TABLE `client_urecord` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `amount` float(11,2) DEFAULT NULL,
  `ctime` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for client_withdrawal_order
-- ----------------------------
DROP TABLE IF EXISTS `client_withdrawal_order`;
CREATE TABLE `client_withdrawal_order` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户提现表';

-- ----------------------------
-- Table structure for companys
-- ----------------------------
DROP TABLE IF EXISTS `companys`;
CREATE TABLE `companys` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='代理信息表';

-- ----------------------------
-- Table structure for company_bills
-- ----------------------------
DROP TABLE IF EXISTS `company_bills`;
CREATE TABLE `company_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comid` int(11) DEFAULT NULL,
  `bill_amount` float(10,2) DEFAULT NULL,
  `bill_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理账单信息, 废弃';

-- ----------------------------
-- Table structure for company_income_record
-- ----------------------------
DROP TABLE IF EXISTS `company_income_record`;
CREATE TABLE `company_income_record` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='代理收入记录, 废弃';

-- ----------------------------
-- Table structure for company_level
-- ----------------------------
DROP TABLE IF EXISTS `company_level`;
CREATE TABLE `company_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level_name` varchar(255) NOT NULL DEFAULT '',
  `level_discount` float(11,2) DEFAULT NULL,
  `level_rebate_point` float(11,2) DEFAULT '0.00',
  `level_remark` varchar(255) DEFAULT NULL,
  `level_addtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `upable` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='代理等级';

-- ----------------------------
-- Table structure for company_rebate_rules
-- ----------------------------
DROP TABLE IF EXISTS `company_rebate_rules`;
CREATE TABLE `company_rebate_rules` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='代理返佣规则';

-- ----------------------------
-- Table structure for company_users
-- ----------------------------
DROP TABLE IF EXISTS `company_users`;
CREATE TABLE `company_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `comid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniopenid` (`openid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='代理和用户关联信息';

-- ----------------------------
-- Table structure for envs_robblist
-- ----------------------------
DROP TABLE IF EXISTS `envs_robblist`;
CREATE TABLE `envs_robblist` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `on` int(11) DEFAULT NULL,
  `remains` int(11) DEFAULT NULL,
  `envsid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for envs_robrecord
-- ----------------------------
DROP TABLE IF EXISTS `envs_robrecord`;
CREATE TABLE `envs_robrecord` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `envsid` int(11) DEFAULT NULL,
  `eid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for express_record
-- ----------------------------
DROP TABLE IF EXISTS `express_record`;
CREATE TABLE `express_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `confirm_time` datetime DEFAULT NULL,
  `send_time` datetime DEFAULT NULL,
  `costs` varchar(255) DEFAULT '0' COMMENT '配送时效',
  `openid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gmess_category
-- ----------------------------
DROP TABLE IF EXISTS `gmess_category`;
CREATE TABLE `gmess_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(255) NOT NULL,
  `parent` int(11) DEFAULT '0',
  `sort` tinyint(4) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gmess_page
-- ----------------------------
DROP TABLE IF EXISTS `gmess_page`;
CREATE TABLE `gmess_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL COMMENT '内容',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `catimg` varchar(255) NOT NULL DEFAULT '' COMMENT '封面图',
  `thumb_media_id` varchar(255) NOT NULL DEFAULT '',
  `content_source_url` varchar(255) NOT NULL DEFAULT '' COMMENT '原文链接',
  `media_id` varchar(255) NOT NULL DEFAULT '',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `category` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '素材分类',
  `deleted` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `hits` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数目',
  `wechat_id` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '公众号ID',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `wei_url` varchar(255) NOT NULL DEFAULT '' COMMENT '微信url',
  `is_check` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否审核',
  `client_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `ad_product` varchar(32) NOT NULL DEFAULT '' COMMENT '推广产品的IDs',
  PRIMARY KEY (`id`),
  KEY `media_id` (`media_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gmess_send_stat
-- ----------------------------
DROP TABLE IF EXISTS `gmess_send_stat`;
CREATE TABLE `gmess_send_stat` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gmess_tasks
-- ----------------------------
DROP TABLE IF EXISTS `gmess_tasks`;
CREATE TABLE `gmess_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gmess_id` int(11) NOT NULL,
  `task_time` int(11) DEFAULT '0',
  `task_exec_time` int(11) DEFAULT '0',
  `task_finish_time` datetime DEFAULT NULL,
  `admin_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for group_buy
-- ----------------------------
DROP TABLE IF EXISTS `group_buy`;
CREATE TABLE `group_buy` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for group_buy_log
-- ----------------------------
DROP TABLE IF EXISTS `group_buy_log`;
CREATE TABLE `group_buy_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `tuan_id` int(10) NOT NULL DEFAULT '0' COMMENT '团购ID',
  `client_id` int(10) NOT NULL DEFAULT '0' COMMENT '会员ID',
  `product_id` int(10) NOT NULL COMMENT '商品ID',
  `num` int(4) NOT NULL DEFAULT '0' COMMENT '购买数量。取值范围:大于零的整数',
  `remark` varchar(200) NOT NULL COMMENT '备注',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
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
  `wepayed` tinyint(1) DEFAULT '0' COMMENT '订单是否已支付',
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for orders_address
-- ----------------------------
DROP TABLE IF EXISTS `orders_address`;
CREATE TABLE `orders_address` (
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
  PRIMARY KEY (`addr_id`),
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for orders_comment
-- ----------------------------
DROP TABLE IF EXISTS `orders_comment`;
CREATE TABLE `orders_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `starts` tinyint(4) DEFAULT NULL,
  `content` text,
  `mtime` datetime DEFAULT NULL,
  `orderid` int(11) DEFAULT NULL,
  `anonymous` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `openid` (`openid`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for orders_detail
-- ----------------------------
DROP TABLE IF EXISTS `orders_detail`;
CREATE TABLE `orders_detail` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for order_credit_available
-- ----------------------------
DROP TABLE IF EXISTS `order_credit_available`;
CREATE TABLE `order_credit_available` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cfrom` float(5,2) DEFAULT NULL,
  `cto` float(5,2) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for order_rebates
-- ----------------------------
DROP TABLE IF EXISTS `order_rebates`;
CREATE TABLE `order_rebates` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='订单返佣表';

-- ----------------------------
-- Table structure for order_refundment
-- ----------------------------
DROP TABLE IF EXISTS `order_refundment`;
CREATE TABLE `order_refundment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `serial_number` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `refund_amount` float(10,2) DEFAULT '0.00',
  `refund_time` datetime DEFAULT NULL,
  `refund_type` tinyint(4) DEFAULT '0',
  `refund_serial` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `payment_type` tinyint(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for products_info
-- ----------------------------
DROP TABLE IF EXISTS `products_info`;
CREATE TABLE `products_info` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='商品信息表';

-- ----------------------------
-- Table structure for product_brand
-- ----------------------------
DROP TABLE IF EXISTS `product_brand`;
CREATE TABLE `product_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(255) DEFAULT NULL,
  `brand_img1` varchar(255) DEFAULT NULL,
  `brand_img2` varchar(255) DEFAULT NULL,
  `brand_cat` int(11) DEFAULT NULL,
  `sort` tinyint(4) DEFAULT '0',
  `deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniname` (`brand_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_category
-- ----------------------------
DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(255) NOT NULL,
  `cat_descs` text,
  `cat_image` varchar(255) NOT NULL DEFAULT '',
  `cat_parent` int(11) NOT NULL DEFAULT '0',
  `cat_level` int(11) DEFAULT '0',
  `cat_order` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否启用',
  PRIMARY KEY (`cat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_credit_exanges
-- ----------------------------
DROP TABLE IF EXISTS `product_credit_exanges`;
CREATE TABLE `product_credit_exanges` (
  `product_id` int(11) NOT NULL,
  `product_credits` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_images
-- ----------------------------
DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images` (
  `product_id` int(11) NOT NULL DEFAULT '0',
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `image_path` varchar(512) NOT NULL,
  `image_sort` tinyint(4) DEFAULT '0',
  `image_type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`image_id`),
  KEY `index_product` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_onsale
-- ----------------------------
DROP TABLE IF EXISTS `product_onsale`;
CREATE TABLE `product_onsale` (
  `product_id` int(20) NOT NULL AUTO_INCREMENT COMMENT '商品编号',
  `sale_prices` float(10,2) NOT NULL DEFAULT '0.00' COMMENT '售价',
  `store_id` int(8) NOT NULL DEFAULT '0' COMMENT '商店编号',
  `discount` int(3) NOT NULL DEFAULT '100' COMMENT '折扣',
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_serials
-- ----------------------------
DROP TABLE IF EXISTS `product_serials`;
CREATE TABLE `product_serials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_name` varchar(255) DEFAULT NULL COMMENT '序列名称',
  `serial_image` varchar(255) DEFAULT NULL,
  `serial_desc` varchar(255) DEFAULT NULL,
  `relcat` tinyint(4) DEFAULT NULL,
  `relevel` tinyint(4) DEFAULT NULL,
  `sort` varchar(255) DEFAULT '0' COMMENT '排序',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_spec
-- ----------------------------
DROP TABLE IF EXISTS `product_spec`;
CREATE TABLE `product_spec` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `spec_det_id1` int(11) DEFAULT NULL,
  `spec_det_id2` int(11) DEFAULT NULL,
  `sale_price` float(11,2) DEFAULT NULL,
  `market_price` float(11,2) DEFAULT '0.00',
  `instock` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='商品规格';

-- ----------------------------
-- Table structure for wechats
-- ----------------------------
DROP TABLE IF EXISTS `wechats`;
CREATE TABLE `wechats` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for wechat_autoresponse
-- ----------------------------
DROP TABLE IF EXISTS `wechat_autoresponse`;
CREATE TABLE `wechat_autoresponse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `message` text,
  `rel` int(11) DEFAULT '0',
  `reltype` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_banners
-- ----------------------------
DROP TABLE IF EXISTS `wshop_banners`;
CREATE TABLE `wshop_banners` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_board_messages
-- ----------------------------
DROP TABLE IF EXISTS `wshop_board_messages`;
CREATE TABLE `wshop_board_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` text,
  `mtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_expresstaff
-- ----------------------------
DROP TABLE IF EXISTS `wshop_expresstaff`;
CREATE TABLE `wshop_expresstaff` (
  `id` int(11) NOT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `headimg` varchar(255) DEFAULT NULL,
  `uname` varchar(255) DEFAULT NULL,
  `isnotify` tinyint(1) DEFAULT '0',
  `isexpress` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_logs
-- ----------------------------
DROP TABLE IF EXISTS `wshop_logs`;
CREATE TABLE `wshop_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_level` tinyint(2) DEFAULT '0' COMMENT '错误级别',
  `log_info` text COMMENT '错误信息',
  `log_url` varchar(255) DEFAULT NULL,
  `log_time` datetime DEFAULT NULL,
  `log_ip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='系统日志';

-- ----------------------------
-- Table structure for wshop_menu
-- ----------------------------
DROP TABLE IF EXISTS `wshop_menu`;
CREATE TABLE `wshop_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `relid` int(11) DEFAULT NULL,
  `reltype` tinyint(4) DEFAULT NULL,
  `relcontent` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_recomment_company
-- ----------------------------
DROP TABLE IF EXISTS `wshop_recomment_company`;
CREATE TABLE `wshop_recomment_company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `status` enum('unfix','fixed','close') DEFAULT 'unfix',
  `content` text,
  `comid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_search_record
-- ----------------------------
DROP TABLE IF EXISTS `wshop_search_record`;
CREATE TABLE `wshop_search_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_settings
-- ----------------------------
DROP TABLE IF EXISTS `wshop_settings`;
CREATE TABLE `wshop_settings` (
  `key` varchar(50) NOT NULL DEFAULT '',
  `value` varchar(512) DEFAULT NULL,
  `last_mod` datetime NOT NULL,
  `remark` varchar(255) DEFAULT '无',
  PRIMARY KEY (`key`),
  KEY `index_key` (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统设置表';

-- ----------------------------
-- Table structure for wshop_settings_expfee
-- ----------------------------
DROP TABLE IF EXISTS `wshop_settings_expfee`;
CREATE TABLE `wshop_settings_expfee` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `province` varchar(255) DEFAULT '',
  `citys` varchar(255) DEFAULT NULL,
  `ffee` float DEFAULT NULL,
  `ffeeadd` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='系统设置-运费模板';

-- ----------------------------
-- Table structure for wshop_settings_nav
-- ----------------------------
DROP TABLE IF EXISTS `wshop_settings_nav`;
CREATE TABLE `wshop_settings_nav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nav_name` varchar(255) NOT NULL COMMENT '菜单名称',
  `nav_ico` varchar(255) NOT NULL COMMENT '显示ICO图片',
  `nav_type` int(11) NOT NULL COMMENT '菜单类型（0.超链接，1.产品分类）',
  `nav_content` text,
  `sort` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='系统设置-导航';

-- ----------------------------
-- Table structure for wshop_settings_section
-- ----------------------------
DROP TABLE IF EXISTS `wshop_settings_section`;
CREATE TABLE `wshop_settings_section` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_spec
-- ----------------------------
DROP TABLE IF EXISTS `wshop_spec`;
CREATE TABLE `wshop_spec` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spec_name` varchar(255) NOT NULL,
  `spec_remark` varchar(255) DEFAULT NULL,
  `spec_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_spec_det
-- ----------------------------
DROP TABLE IF EXISTS `wshop_spec_det`;
CREATE TABLE `wshop_spec_det` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spec_id` int(11) NOT NULL,
  `det_name` varchar(255) NOT NULL,
  `det_sort` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_suppliers
-- ----------------------------
DROP TABLE IF EXISTS `wshop_suppliers`;
CREATE TABLE `wshop_suppliers` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wshop_user_cumulate
-- ----------------------------
DROP TABLE IF EXISTS `wshop_user_cumulate`;
CREATE TABLE `wshop_user_cumulate` (
  `ref_date` date NOT NULL,
  `user_source` tinyint(2) NOT NULL DEFAULT '0',
  `cumulate_user` int(11) DEFAULT '0',
  PRIMARY KEY (`ref_date`,`user_source`),
  UNIQUE KEY `ref_date` (`ref_date`,`user_source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信粉丝统计数据';

-- ----------------------------
-- Table structure for wshop_user_summary
-- ----------------------------
DROP TABLE IF EXISTS `wshop_user_summary`;
CREATE TABLE `wshop_user_summary` (
  `ref_date` date NOT NULL,
  `user_source` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0代表其他（包括带参数二维码） 3代表扫二维码 17代表名片分享 35代表搜号码（即微信添加朋友页的搜索） 39代表查询微信公众帐号 43代表图文页右上角菜单',
  `new_user` int(11) DEFAULT NULL,
  `cancel_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`ref_date`,`user_source`),
  UNIQUE KEY `ref_date` (`ref_date`,`user_source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信粉丝统计数据';
SET FOREIGN_KEY_CHECKS=1;
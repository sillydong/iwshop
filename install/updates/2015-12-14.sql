-- 代理表增加字段 支付宝付款账号
ALTER TABLE `companys` ADD COLUMN `alipay` varchar(255) DEFAULT '' COMMENT '支付宝';
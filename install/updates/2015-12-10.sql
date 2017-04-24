
-- 管理员表增加字段
ALTER TABLE `admin` ADD COLUMN `admin_name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '管理员姓名' AFTER `id`;

-- 废弃管理员 admin_permission 字段
ALTER TABLE `admin` DROP COLUMN `admin_permission`;

-- 订单表增加字段
ALTER TABLE `orders` ADD COLUMN `original_amount` float(10,2) DEFAULT '0.00' COMMENT '供货价总价';

-- 供应商表增加字段
ALTER TABLE `products_info` ADD COLUMN `supply_price` float(10,2) DEFAULT '0.00' COMMENT '供货价';

-- 订单详情
ALTER IGNORE TABLE `orders_detail` CHANGE `is_returned` `refunded` TINYINT(1) DEFAULT 0;

-- 供应商表增加字段
ALTER TABLE `orders_detail` ADD COLUMN `original_amount` float(10,2) DEFAULT '0.00' COMMENT '供货价';

-- original_amount
ALTER TABLE `orders` ADD COLUMN `original_amount` float(10,2) DEFAULT '0.00' COMMENT '供货价';
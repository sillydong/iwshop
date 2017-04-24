-- ---------------------------------
-- 商品分享数量
-- ---------------------------------
ALTER TABLE `products_info` ADD COLUMN `product_sharei` INT(11) DEFAULT '0' COMMENT '商品分销数量'  AFTER `is_delete`;
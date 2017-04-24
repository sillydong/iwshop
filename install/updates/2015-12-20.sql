-- 团队数量统计
ALTER TABLE `companys` ADD COLUMN `sum_underline` varchar(255) DEFAULT '0' COMMENT '直属会员数量';

ALTER TABLE `companys` ADD COLUMN `sum_two` varchar(255) DEFAULT '0' COMMENT '相对往下第二层的会员数量';

ALTER TABLE `companys` ADD COLUMN `sum_three` varchar(255) DEFAULT '0' COMMENT '相对往下第三层的会员数量';
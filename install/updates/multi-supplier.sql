ALTER TABLE `admin` ADD COLUMN `supplier_id` int(11) NOT NULL DEFAULT '0' AFTER `admin_auth`;

ALTER TABLE `wshop_suppliers` ADD COLUMN `supp_pass` varchar(255) DEFAULT NULL AFTER `supp_desc`;
ALTER TABLE `wshop_suppliers` ADD COLUMN `supp_lastlogin` datetime DEFAULT NULL AFTER `supp_pass`;
ALTER TABLE `wshop_suppliers` ADD COLUMN `is_verified` int(11) NOT NULL DEFAULT '0' AFTER `supp_lastlogin`;
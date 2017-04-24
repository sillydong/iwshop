-- ----------------------------
-- 订单退款记录表
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
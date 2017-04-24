-- ---------------------------------
-- Table structure for company_level
-- ---------------------------------
DROP TABLE IF EXISTS `company_level`;

CREATE TABLE `company_level` (
  `id`              int(11) NOT NULL AUTO_INCREMENT,
  `utype`           TINYINT(4)      DEFAULT NULL COMMENT '代理等级',
  `uname`           varchar(20)     NOT NULL COMMENT '代理名称',
  `return_percent`  FLOAT(5, 3)           DEFAULT '0.050' COMMENT '返佣比例',
  `crt_time`        DATETIME         DEFAULT NULL COMMENT '创建，修改时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

insert into company_level values(1,'0','I级','0.10','2016-01-25 00:00:00' );
insert into company_level values(2,'1','II级','0.10','2016-01-25 00:00:00' );
insert into company_level values(3,'2','III级','0.10','2016-01-25 00:00:00' );
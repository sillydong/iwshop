ALTER TABLE `wshop_user_cumulate` DROP PRIMARY KEY;

ALTER TABLE `wshop_user_cumulate` ADD PRIMARY KEY (`ref_date`, `user_source`);

ALTER TABLE `wshop_user_summary` DROP PRIMARY KEY;

ALTER TABLE `wshop_user_summary` ADD PRIMARY KEY (`ref_date`, `user_source`);

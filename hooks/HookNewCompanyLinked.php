<?php

/**
 * HookNewCompanyLinked
 * 代理的下级用户关系建立之后的处理
 */
class HookNewCompanyLinked extends Hook implements iHook
{
    /**
     * @param int $uid
     * @param string $openid
     * @param string $companyid
     */
    public function deal($data) {
        try {
            // 获取代理信息
            $company = $this->Dao->select('client_wechat_openid')->from(TABLE_USER)->where("client_id = $data[companyid]")->getOneRow();
            if ($company) {
                // 判断代理人数
                $shareCount = $this->Dao->select("count(1)")->from(TABLE_USER)->where("client_comid = $data[companyid]")->getOne(false);
                // 销售价标价为零售价，分享名片且有五人以上关注，会员购物将长久按7.5折优惠结算。
                if ($shareCount == 5) {
                    // 调整代理分组
                    $this->Dao->update(TABLE_COMPANYS)->set([
                        'gid' => 7
                    ])->where("uid = $data[companyid]")->exec();
                    // todo 通知信息
                }
            }
        } catch (Exception $ex) {
            Util::log($ex->getMessage());
        }
    }
}
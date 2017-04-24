<?php

/**
 * 代理管理控制器
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */
class wCompany extends ControllerAdmin {

    /**
     * 权限检查
     * @param type $ControllerName
     * @param type $Action
     * @param type $QueryString
     */
    public function __construct($ControllerName, $Action, $QueryString) {
        parent::__construct($ControllerName, $Action, $QueryString);
        if (!$this->Auth->checkAuth()) {
            $this->redirect('?/Wdmin/logOut');
        } else {
            $this->loadModel('CreditExchange');
            $this->loadModel('mCompany');
            $this->Db->cache = false;
        }
    }

    /**
     * 获取代理信息
     */
    public function getInfo() {
        // 页码
        $id = $this->pGet('id', 0);
        if ($id > 0) {
            $info = $this->mCompany->getCompanyInfo($id);
            unset($info['password']);
            $info['utype'] = intval($info['utype']);
            $this->echoMsg(0, $info);
        } else {
            $this->echoFail();
        }
    }

    /**
     * 编辑代理信息
     */
    public function modify() {

        $data       = $this->post();
        $data['id'] = intval($data['id']);

        if ($data['id'] > 0) {
            // update
            $company = $this->mCompany->getCompanyInfo($data['id']);
            $result  = $this->Dao->update(TABLE_COMPANYS)
                ->set($data)
                ->where([
                    'id' => $data['id']
                ])
                ->exec();
            if ($result) {

                // 如果这个用户还不是代理, 那么就是通过操作
                if ($company['verifed'] == 0) {
                    // 更新用户表
                    $this->Dao->update(TABLE_USER)->set([
                        'is_com' => 1
                    ])->where([
                        'client_id' => $data['uid']
                    ])->exec();
                    (new HookCompanyApprove($this))->deal($data);
                }

                $this->echoSuccess();

            } else {
                $this->log("更新代理表申请审核失败！" . json_encode($data, JSON_UNESCAPED_UNICODE));
                $this->echoFail();
            }
        } else {
            // v0.9.5
            // 目前版本不支持手动添加代理的功能了
            // 必须在个人中心提交审核数据
            $this->echoFail();
        }
    }

    /**
     * 获取代理列表
     */
    public function getList() {

        // 页码
        $page = $this->pGet('page', 0);
        // 页数
        $page_size = $this->pGet('pagesize', 30);
        // 是否审核
        $verifed = $this->pGet('verifed', 1);
        // 是否简单列表
        $simple = $this->pGet('simple', 0);

        $where = [
            "verifed" => $verifed,
            'deleted' => 0
        ];

        $list_count = $this->Dao->select('')
            ->count()
            ->alias('count')
            ->from(TABLE_COMPANYS)
            ->where($where)
            ->getOne();

        $companys = $this->Dao->select()
            ->from(TABLE_COMPANYS)
            ->where($where)
            ->orderby('uid')
            ->desc()
            ->limit($page * $page_size, $page_size)
            ->exec();

        $companyLevel = $this->mCompany->getCompanyLevel();

        if ($simple == 0) {
            foreach ($companys as &$c) {
                $c['level_name']   = $this->mCompany->getLevelName($c['gid']);
                $c['fellow_count'] = $this->mCompany->getCompanyFellowsCount($c['uid']);
                $c['income_total'] = $this->mCompany->getCompanyIncomeCount($c['uid'], false);
                $c['income_month'] = $this->mCompany->getCompanyIncomeCount($c['uid'], false, true);
                $c['income_unset'] = $this->mCompany->getCompanyIncomeCount($c['uid'], 0, false);
                $c['orderscount']  = $this->Db->getOne("SELECT COUNT(*) FROM `orders` WHERE company_id > 0 AND `company_id` = $c[uid];");
                $c['level']        = $companyLevel[intval($c['utype'])];
            }
        }

        $data = $this->toJson([
            'total' => $list_count,
            'list' => $companys
        ]);

        $this->echoJsonRaw($data);

    }

    /**
     * 删除代理
     */
    public function deleteCompany() {
        if ($this->post('id') && is_numeric($this->post('id'))) {
            $id = intval($this->post('id'));
            if ($id > 0) {
                $this->Db->transtart();
                try {
                    $clientId = $this->Dao->select('uid')
                        ->from('companys')
                        ->where("id=$id")
                        ->getOne();
                    // 更新用户表
                    $this->Dao->update(TABLE_USER)->set([
                        'is_com' => 0
                    ])->where([
                        'client_id' => $clientId
                    ])->exec();
                    // 更新代理表
                    $this->Dao->update(TABLE_COMPANYS)->set([
                        'deleted' => 1
                    ])->where([
                        'id' => $id
                    ])->exec();
                    $this->Db->transcommit();
                    $this->echoSuccess();
                } catch (Exception $ex) {
                    $this->Db->transrollback();
                    $this->echoFail();
                }
            } else {
                $this->echoFail();
            }
        }
    }

    /**
     * 获取未审核代理计数
     */
    public function getUnVerifedCount() {
        $count = $this->Dao->select('')->count()->from(TABLE_COMPANYS)->where(['verifed' => 0,
                                                                               'deleted' => 0])->getOne();
        $this->echoMsg(0, $count);
    }

    /**
     * 获取正式审核代理计数
     */
    public function getVerifedCount() {
        $count = $this->Dao->select('')->count()->from(TABLE_COMPANYS)->where(['verifed' => 1,
                                                                               'deleted' => 0])->getOne();
        $this->echoMsg(0, $count);
    }

    /**
     * 代理申请审核不通过
     */
    public function companyReqDeny() {
        $id = intval($this->pPost('id'));
        if ($id > 0) {
            // 更新代理表
            if ($this->Dao->update(TABLE_COMPANYS)->set([
                'deleted' => 1
            ])->where([
                'id' => $id,
                'verifed' => 0
            ])->exec()
            ) {
                $this->echoSuccess();
            } else {
                $this->echoFail();
            }
        } else {
            $this->echoFail();
        }
    }

    /**
     * 设置代理协议
     */
    public function setCompanyAgreement() {
        $content = $this->post('content');
        if (file_put_contents(APP_PATH . 'html/agent_agreement.html', $content)) {
            $this->echoSuccess();
        } else {
            $this->echoFail();
        }
    }

}
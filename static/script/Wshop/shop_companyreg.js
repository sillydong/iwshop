/**
 * 代理注册页面
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

require(['config'], function (config) {

    require(['util', 'jquery', 'Spinner', 'Tiping'], function (util, $, Spinner, Tiping) {

        $('#reg-btn').click(function () {
            var name = $('#set-form-name').val();
            var phone = $('#set-form-phone').val();
            var email = $('#set-form-email').val();
            if (name !== '' && phone !== '' && email !== '') {
                $.post(shoproot + '?/Company/addCompany/', {
                    name: name,
                    phone: phone,
                    email: email
                }, function (r) {
                    if (r.ret_code == 0) {
                        alert('您的申请已提交，请耐心等待系统审核。');
                        location.href = '?/Uc/home/';
                    } else {
                        alert(r.ret_msg);
                    }
                });
            } else {
                alert('请填写正确的内容');
            }
        });

    });
});
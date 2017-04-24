/* global shoproot */

/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

/**
 * 图文Id
 * @type Boolean
 */
var appMsgId = false;

/**
 * 菜单添加 是否添加顶级菜单
 * @type Boolean|Boolean|Boolean
 */
var addIsTop = false;

/**
 * 菜单添加 夫级节点
 * @type Boolean|@call;$@call;parents
 */
var addParent = false;

/**
 * 当前编辑的菜单项
 * @type Boolean
 */
var curMenu = false;

requirejs(['jquery', 'util', 'fancyBox', 'datatables', 'Spinner'], function ($, util, fancyBox, dataTables, Spinner) {

    var lock = false;

    Spinner.spin($('#menuX').get(0));

    /**
     * 加载菜单数据
     */
    $('#menuX').load(shoproot + '?/wSettings/ajaxGetWechatMenu/', function () {
        Spinner.stop();
        fnBtnListen();
        if ($('.menutop').length > 0) {
            $('#add_menu_please').hide();
            $('.menutop').eq(0).click();
        } else {
            // 没有数据，提示添加菜单
            $('#add_menu_please').show();
        }
    });

    /**
     * 按钮点击监听
     * @returns {undefined}
     */
    function fnBtnListen() {
        // 一级删除
        $('.menusubs .del').unbind('click').on('click', function () {
            $(this).parent().remove();
        });
        // 二级删除 4 - 8
        $('.menutop .del').unbind('click').on('click', function () {
            $(this).parent().parent().remove();
        });
        // 二级添加 8 - 16
        $('.menutop .sadd').unbind('click').on('click', function () {
            addIsTop = false;
            addParent = $(this).parents('.tMenus');
            if ($('.menusubs li', addParent).length <= 4) {
                $('#menu-name-sm').val('');
                $('#addmenu1_t').click();
            } else {
                util.Alert('二级菜单最多只能五个', true);
            }
        });
        // 菜单项点击
        $('.menusubs li,.menutop').unbind('click').bind('click', fnMenuClick);
    }

    /**
     * 菜单按钮点击监听
     * @returns {undefined}
     */
    function fnMenuClick() {
        curMenu = $(this);
        // toggle class
        $('.menutop.hov').removeClass('hov');
        $('.menusubs li.hov').removeClass('hov');
        // hover class
        curMenu.addClass('hov');
        $('.acts').hide();
        // haschild
        var MenuHasChild = curMenu.parent().find('.menusubs li').length > 0;
        if (curMenu.hasClass('menutop') && MenuHasChild) {
            // 如果是顶级菜单
            $('#nTop').hide();
        } else {
            // 非顶级菜单 或者 顶级菜单无子菜单
            $('#nTop').show();
            if (curMenu.attr('data-type') === 'view') {
                // 跳转按钮
                $('#rad2').click();
                $('#menu-url-ed').val(curMenu.attr('data-url'));
            } else {
                // 签到按钮
                if (curMenu.attr('data-key') === 'SIGN') {
                    $('#rad3').click();
                } else {
                    // 动作按钮
                    $('#rad1').click();
                    if (curMenu.attr('data-key') !== '') {
                        // 加载绑定数据
                        $('#iframe_loading').show();
                        Spinner.spin($('#iframe_loading').get(0));
                        var keyId = parseInt(curMenu.attr('data-key').replace('K_', ''));
                        gmessReset();
                        // 拆解KeyId
                        $.post(shoproot + '?/WdminAjax/getMenu/', {
                            id: keyId
                        }, function (R) {
                            if (R && R.reltype >= 0) {
                                R.reltype = parseInt(R.reltype);
                                if (R.reltype !== 1) {
                                    $('#iframe_loading').hide();
                                    Spinner.stop();
                                }
                                // 消息设置赋值
                                $('#reltype option[value=' + R.reltype + ']').get(0).selected = true;
                                // 触发变化事件
                                $('#reltype').change();
                                switch (R.reltype) {
                                    case 0:
                                        $('.mpdcont').eq(0).val(R.relcontent)
                                        break;
                                    case 1:
                                        // 加载图文数据
                                        appMsgId = parseInt(R.relid);
                                        // [HttpGet]
                                        $.get(shoproot + '?/Gmess/ajaxGetGmess/id=' + appMsgId, function (Gmess) {
                                            $('.appmsg_title a').eq(0).html(Gmess.title);
                                            $('#thumbUp').eq(0).addClass('ove');
                                            $('#appmsimg-preview').attr('src', shoproot + 'static/images_gmess/' + Gmess.catimg).show();
                                            $('.appmsg_desc').eq(0).html(Gmess.desc);
                                            $('#iframe_loading').hide();
                                            Spinner.stop();
                                        });
                                        break;
                                    case 2:
                                        $('#cattype option[value=' + R.relid + ']').get(0).selected = true;
                                }
                            } else {
                                util.Alert('加载数据失败,未知键值', true);
                                $('#iframe_loading').hide();
                                Spinner.stop();
                            }
                        });
                    }
                }
            }
        }
        $('#menu-name-ed').val(curMenu.attr('data-name'));
    }

    $('#rad1').unbind('click').on('click', function () {
        $('.acts').hide();
        $('#act1').show();
    });

    $('#rad2').unbind('click').on('click', function () {
        $('.acts').hide();
        $('#act2').show();
    });

    $('#rad3').unbind('click').on('click', function () {
        $('.acts').hide();
    });

    // 一级添加
    // 添加顶级菜单
    $('#topAdd').on('click', function () {
        addIsTop = true;
        if ($('.menutop').length <= 2) {
            $('#menu-name-sm').val('');
            $('#addmenu1_t').click();
        } else {
            util.Alert('一级菜单最多只能三个', true);
        }
    });

    fnFancyBox('#addmenu1_t', function () {
        $('#menu-name-sm').focus();
    });

    /**
     * fancyBox 添加确认按钮监听
     */
    $('#add_menu_btn').click(function () {
        // 重置表单
        $('#ntright')[0].reset();
        $('#rad1').click();
        var name = $('#menu-name-sm').val(), n;
        if (name != '') {
            // 顶级添加
            if (addIsTop) {
                n = $('<div class="tMenus"><div class="menutop" data-name="' + name + '" data-type="click" data-url="" data-key=""><span class="n">' + name + '</span><a class="del" href="javascript:;"></a><a class="sadd" href="javascript:;"></a></div><ul class="menusubs"></ul></div>')
                $('#menuX').append(n);
                fnBtnListen();
                n.find('.menutop').eq(0).click();
            } else {
                // 二级添加
                n = $('<li data-type="click" data-name="' + name + '" data-url="" data-key=""><span class="n">' + name + '</span><a class="del" href="javascript:;"></a></li>');
                addParent.find('.menusubs').append(n);
                fnBtnListen();
                n.click();
            }
            $('#add_menu_please').hide();
            $.fancybox.close();
        } else {
            util.Alert("请填写菜单名称", true);
            $('#menu-name-sm').focus();
        }
    });

    /**
     * 保存按钮点击
     */
    $('#menu_savebtn').on('click', function () {
        var MenuHasChild = curMenu.parent().find('.menusubs li').length > 0;
        if (curMenu.hasClass('menutop') && MenuHasChild) {
            // 如果是顶级菜单
            $('#nTop').hide();
        } else {
            if ($('#rad1').get(0).checked) {
                var postData = {};
                postData.reltype = parseInt($('#reltype').val());
                postData.relid = 0;
                postData.relcontent = '';
                // 这里要做很多绑定处理
                curMenu.attr('data-type', 'click');
                switch (postData.reltype) {
                    case 0 :
                        // 文字
                        postData.relcontent = $('.mpdcont').eq(0).val();
                        break;
                    case 1 :
                        // 回复图文
                        postData.relid = appMsgId;
                        break;
                    case 2 :
                        // 商品推荐
                        postData.relid = $('#cattype').val();
                }
                $('#menu_savebtn').html('数据处理中');
                // [HttpPost]
                $.post(shoproot + '?/WdminAjax/bindMenu/', postData, function (k) {
                    if (k > 0) {
                        curMenu.attr('data-key', 'K_' + k);
                        util.Alert('保存成功！');
                    } else {
                        util.Alert('保存失败,系统错误！', true);
                    }
                    $('#menu_savebtn').html('保存');
                });
            } else if ($('#rad2').get(0).checked) {
                curMenu.attr('data-type', 'view');
                curMenu.attr('data-url', $('#menu-url-ed').val());
            } else if ($('#rad3').get(0).checked) {
                curMenu.attr('data-type', 'click');
                curMenu.attr('data-key', 'SIGN');
            }
        }
        // 名称赋值
        curMenu.attr('data-name', $('#menu-name-ed').val());
        curMenu.find('.n').html($('#menu-name-ed').val());
    });

    /**
     * 发布按钮点击
     */
    $('#menu_pubbtn').on('click', function () {
        if (lock) {
            return false;
        }
        lock = true;
        var Json = convToJson();
        util.loading();
        // httpPost
        $.post('?/WdminAjax/ajaxSetWechatMenu/', {
            menu: JSON.stringify(Json)
        }, function (R) {
            lock = false;
            util.loading(false);
            if (parseInt(R.errcode) === 0) {
                util.Alert('发布成功！');
            } else {
                util.Alert('发布失败,系统错误！', true);
            }
        });
    });

    /**
     * 类型选择
     */
    $('#reltype').on('change', function () {
        var id = parseInt($(this).val());
        $('#cattype,.mpdcont,#appmsgItem1').hide();
        if (id === 2) {
            $('#cattype').show();
        } else if (id === 0) {
            $('.mpdcont').show();
        } else if (id === 1) {
            $('#appmsgItem1').show();
        }
    });

    /**
     * 图文选择点击
     * @returns {undefined}
     */
    fnFancyBox('#thumbUp', function () {
        $('.gmBlock').bind('click', function () {
            var block = $(this).clone();
            appMsgId = parseInt(block.attr('data-id'));
            $('.appmsg_title a').eq(0).html(block.find('.title').html());
            $('#appmsimg-preview').attr('src', block.find('img').attr('src')).show();
            $('#thumbUp').eq(0).addClass('ove');
            $('.appmsg_desc').eq(0).html(block.find('.desc').html());
            $.fancybox.close();
        });
    });

    /**
     * 重置gmess
     * @returns {undefined}
     */
    function gmessReset() {
        appMsgId = false;
        $('.appmsg_title a').eq(0).html('标题');
        $('#thumbUp').eq(0).removeClass('ove');
        $('#appmsimg-preview').attr('src', '').hide();
        $('.appmsg_desc').eq(0).html('');
    }

    /**
     * 菜单Json转换
     * @returns {_L14.convToJson.Json}
     */
    function convToJson() {
        var Json = {
            button: []
        };
        $('.tMenus').each(function () {
            var sJson = {};
            var t = $(this).find('.menutop').eq(0);
            var childs = $(this).find('.menusubs li');
            sJson.name = t.attr('data-name');
            if (childs.length > 0) {
                // 具有子菜单
                sJson.sub_button = [];
                childs.each(function () {
                    var cJson = {
                        type: $(this).attr('data-type'),
                        name: $(this).attr('data-name')
                    };
                    if (cJson.type === 'view') {
                        cJson.url = $(this).attr('data-url');
                    } else {
                        cJson.key = $(this).attr('data-key');
                    }
                    sJson.sub_button.push(cJson);
                });
            } else {
                sJson.type = t.attr('data-type');
                if (sJson.type === 'view') {
                    sJson.url = t.attr('data-url');
                } else {
                    sJson.key = t.attr('data-key');
                }
            }
            Json.button.push(sJson);
        });
        return Json;
    }

});
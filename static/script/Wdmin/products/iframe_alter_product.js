/* global shoproot */

/**
 * 商品编辑
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http://www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http://www.iwshop.cn
 */

requirejs(['util', 'fancyBox', 'ueditor', 'jUploader'], function (util, fancyBox, ueditor, jUploader) {

    // 商品图片列表
    var pdImages = ['', '', '', '', ''];
    // 商品id
    var pdId = false;
    // 商品图片宽度
    var pdImageWidth = false;
    // ajax锁
    var loadingLock = false;
    var pdCatimg = false;
    var entDiscount = [];
    var entDisLastOpt;

    fnFancyBox('#catimgPv');
    fnFancyBox('.pd-image-view');
    fnFancyBox('#fetch_product_btn');//抓取数据按钮fancybox

    // 产品首图
    pdCatimg = $('#pd-catimg').val() === '' ? false : $('#pd-catimg').val();

    if ($('#mod').val() === 'edit') {
        // 编辑模式 存入图片列表
        $('.pd-images').each(function (i, node) {
            if ($(node).val() && $(node).val() !== '' && i < 5) {
                pdImages[$(node).attr('data-sort')] = $(node).val();
                $('.pd-image-sec').eq(parseInt($(node).attr('data-sort')) + 1).append('<img src="' + $(node).val() + '" width="' + pdImageWidth + 'px" /><a href="' + $(node).val() + '" class="pd-image-view"> </a><i data-id=' + $(node).attr('data-sort') + ' class="pd-image-delete"> </i>').addClass('ove');
            }
        });
        fnPdimageDelete();
        // 商品编号
        pdId = parseInt($('#pid').val());
        fnFancyBox('.pd-image-view');
    } else {
        // 新建模式
        pdId = false;
    }

    // 产品分类
    var pdCatSelect = $("#pd-catselect").find("option[value='" + $('#pd-form-cat').val() + "']");

    if (pdCatSelect.get(0) !== undefined) {
        pdCatSelect.get(0).selected = true;
    }

    // 产品秒杀
    $('#pd-prom').on('change', function () {
        if (parseInt($(this).val()) === 1) {
            $('#prom_option').removeClass('hidden');
        } else {
            $('#prom_option').addClass('hidden');
        }
    });

    // 集团折扣
    $('.product-ent-discount').each(function (i, node) {
        if (i === 0) {
            $('#pd-ent-discount').val(parseFloat($(this).attr('data-discount')));
            entDisLastOpt = $(this);
        }
        entDiscount.push({
            ent: parseInt($(this).val()),
            discount: parseFloat($(this).attr('data-discount'))
        });
    });

    // 产品图片
    $('.pd-image-sec').each(function () {
        var btn = this;
        // 图片上传插件
        $.jUploader({
            button: $(btn),
            action: '?/wImages/ImageUpload/',
            onUpload: function (fileName) {
                util.Alert('图片上传中');
            },
            onComplete: function (fileName, response) {
                var Btn = $(this.button[0]);
                if (response.ret_code == 0) {
                    var iid = parseInt(Btn.attr('data-id'));
                    var src = decodeURIComponent(response.link);
                    Btn.addClass('ove').removeClass('hover');
                    util.Alert('图片上传成功');
                    if (Btn.find('img').length > 0) {
                        Btn.find('img').attr('src', response.ret_msg);
                        Btn.find('.pd-image-view').attr('href', response.ret_msg);
                    } else {
                        Btn.append('<img src="' + response.ret_msg + '" /><a href="' + response.ret_msg + '" class="pd-image-view"> </a><i data-id=' + (iid - 1) + ' class="pd-image-delete"> </i>');
                    }
                    // 商品首图
                    if (!pdCatimg || iid === 0) {
                        $('#pd-catimg').val(response.ret_msg);
                        $('#catimgPv').attr('href', response.ret_msg);
                    }
                    if (iid !== 0) {
                        pdImages[iid - 1] = response.ret_msg;
                    }
                    fnFancyBox('.pd-image-view');
                    fnPdimageDelete();
                } else {
                    util.Alert('上传图片失败');
                }
            }
        });
        $(this).hover(function () {
            if (!$(this).hasClass('ove')) {
                $(this).addClass('hover');
            }
        }, function () {
            if (!$(this).hasClass('ove')) {
                $(this).removeClass('hover');
            }
        });
    });

    // 产品首图
    if (pdCatimg) {
        $('.pd-image-sec').eq(0).addClass('ove').append('<img src="' + pdCatimg + '" />');
        $('#catimgPv').attr('href', pdCatimg);
    }

    $('body').css('overflow-x', 'hidden');

    // 图片已经上传过了。
    $('#save_product_btn').unbind('click').click(__ProductAlterFinish);

    // 删除图片--
    function fnPdimageDelete() {
        $('.pd-image-delete').unbind('click').on('click', function () {
            var nP = $(this).parent();
            // 删除图集数据
            pdImages[parseInt($(this).attr('data-id'))] = '';
            // 删除标记
            nP.removeClass('ove').find('i,img,.pd-image-view').remove();
            nP = null;
        });
    }

    /**
     * 商品编辑结束
     * @returns {undefined}
     */
    function __ProductAlterFinish() {
        if (!loadingLock) {
            // discount
            entDisLastOpt = $('#pd-entprise').find("option:selected");
            $.each(entDiscount, function (i, n) {
                if (n.ent === parseInt(entDisLastOpt.val())) {
                    n.discount = parseFloat($('#pd-ent-discount').val());
                }
            });
            var postData = $('#pd-baseinfo').serializeArray();
            var price = parseFloat($('#pd-form-prices').val());
            // 规格表检查 自动补0
            fnSpecCheck();
            util.loading();
            if ($('#pd-form-title').val() !== '' && price !== '') {
                loadingLock = true;
                // [HttpPost]
                $.post(shoproot + '?/WdminAjax/updateProduct', {
                    product_id: !pdId ? 0 : pdId,
                    product_infos: postData,
                    product_prices: price > 0 ? price : 0,
                    product_images: pdImages,
                    entDiscount: entDiscount,
                    spec: getSpecs()
                }, function (r) {
                    util.loading(false);
                    if (r.ret_code === 0) {
                        loadingLock = false;
                        if (!pdId) {
                            pdId = r.ret_msg;
                            util.Alert('添加成功', false, function () {
                                // 返回列表
                                history.go(-1);
                            });
                        } else {
                            pdId = r.ret_msg;
                            util.Alert('保存成功');
                        }
                    } else {
                        util.Alert('保存失败,错误信息：' + r.ret_msg);
                    }
                });
            } else {
                util.Alert('无法提交，表单不完整。');
            }
        } else {

        }
    }

    /**
     * 商品删除监听
     */
    util.pdDeleteListen();

    // 商品规格添加按钮
    $('#pd-spec-add').click(function () {
        $('#pd-spec-frame').removeClass('hidden').css('margin-top', '15px');
        var tr = $('.specselect').eq(0).clone(false);
        tr.find('select option:selected').each(function () {
            this.selected = false;
        });
        tr.find('input').val(0);
        tr.attr('data-id', 0);
        tr.removeClass('hidden');
        $('#pd-spec-frame tbody').append(tr);
        fnSpecListen();
        tr = null;
    });

    /**
     * 获取商品价格表
     * @returns {Array}
     */
    function getSpecs() {
        var spec = [];
        $('.specselect').each(function () {
            if ($(this).attr('data-id') !== '#') {
                spec.push({
                    id: $(this).attr('data-id'),
                    sid: $(this).find('.spec1').val() + '-' + $(this).find('.spec2').val(),
                    price: parseFloat($(this).find('.pd-spec-prices').val()),
                    market_price: parseFloat($(this).find('.pd-spec-market').val()),
                    instock: parseFloat($(this).find('.pd-spec-stock').val())
                });
            }
        });
        return spec;
    }

    /**
     * 规格表自动补0
     * @returns {undefined}
     */
    function fnSpecCheck() {
        $('.specselect input').each(function () {
            if ($(this).val() === '') {
                $(this).val(0);
            }
        });
    }

    // 初始化
    fnSpecCheck();
    fnSpecListen();

    /**
     * 规格表事件监听
     * @returns {undefined}
     */
    function fnSpecListen() {
        $('.btn-delete-spectr').unbind('click').bind('click', function () {
            var nParent = $(this).parents('tr');
            if (nParent.attr('data-id') > 0) {
                // 赋值负数表示删除
                nParent.attr('data-id', nParent.attr('data-id') * -1);
                nParent.addClass('hidden');
            } else {
                // 否则直接删除节点, 不然会有无效数据
                nParent.remove();
            }
        });
        $('.spec1').unbind('change').bind('change', fnSpecChange);
        $('.spec1').change();
    }

    /**
     * 规格选择监听
     * @returns {undefined}
     */
    function fnSpecChange() {
        // 避免重复选择规格
        var specId = +$(this).find('option:selected').attr('data-spec');
        $(this).parents('tr').eq(0).find('.spec2 option').each(function () {
            if (+$(this).attr('data-spec') === specId) {
                // 判断父级
                this.disabled = true;
            } else {
                this.disabled = false;
            }
        });
    }

    /**
     * ueditor
     */
    uep = UM.getEditor('ueditorp', {
        autoHeight: true
    });
    uep.ready(function () {
        ueploaded = true;
        uep.setWidth("100%");
    });

    /**
     * window resize 监听
     */
    util.onresize(function () {
        var _h = $('.pd-image-sec.ps20').eq(0).width();
        $('.pd-image-sec').each(function () {
            if ($(this).hasClass('ps20')) {
                $(this).height(_h);
            } else {
                $(this).height($(this).width());
            }
        });
        uep.setWidth("100%");
    });
});
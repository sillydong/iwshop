/**
 * 统计首页
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http=>//www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http=>//www.iwshop.cn
 */
requirejs(['jquery', 'util', 'highcharts', 'bootstrap'], function ($, util, highcharts) {

    // 检查微信统计数据更新
    $.get('?/WdminStat/update_wechat_stat/');

    function fnLoadUserStat(control, node) {
        // [HttpGet]
        $.get('?/WdminStat/getUserStat/control=' + control, function (res) {
            var types = {
                new_user: '新增粉丝',
                cancel_user: '取消关注',
                pure_user: '净增粉丝',
                cumulate_user: '粉丝总数'
            };
            node.highcharts({
                credits: {
                    enabled: false
                },
                title: {
                    text: '',
                    style: {
                        fontSize: '15px',
                        color: '#666',
                        fontWeight: 'lighter'
                    }
                },
                chart: {
                    type: 'area',
                    style: {
                        fontFamily: '"Microsoft YaHei"',
                        fontSize: '12px'
                    }
                },
                xAxis: {
                    type: 'date',
                    categories: res.x,
                    lineWidth: 0,
                    tickInterval: 3
                },
                yAxis: {
                    gridLineColor: '#eee',
                    gridLineWidth: 1,
                    lineWidth: 0,
                    title: {
                        text: ''
                    },
                    minPadding: 0
                },
                legend: {
                    enabled: false
                },
                plotOptions: {
                    area: {
                        lineWidth: 1,
                        fillColor: 'rgba(68,181,73,0.1)',
                        fillOpacity: 0.1,
                        lineColor: '#44b549'
                    }
                },
                exporting: {
                    enabled: false
                },
                series: [{
                    name: types[control],
                    data: res.y,
                    marker: {
                        fillColor: '#44b549'
                    }
                }]
            });
        });
    }

    $('.nav-tabs a').click(function () {
        var id = $(this).attr('aria-controls');
        var node = $('#' + id).find('.fansStatChart');
        if (!node.hasClass('loaded')) {
            node.addClass('loaded');
            fnLoadUserStat(id, node);
        }
    });

    $('.nav-tabs a').eq(0).click();

    $('#order-percent2').highcharts({
        credits: {
            enabled: false
        },
        chart: {
            type: 'area',
            inverted: true,
            style: {
                fontFamily: '"Microsoft YaHei"',
                fontSize: '12px'
            }
        },
        title: {
            text: ' '
        },
        xAxis: {
            categories: [
                '下订单',
                '已支付',
                '快递中',
                '未发货'
            ]
        },
        yAxis: {
            title: {
                text: ''
            }
        },
        plotOptions: {
            area: {
                fillOpacity: 0.5,
                dataLabels: {
                    enabled: true,
                    x: 20,
                    y: 15
                },
                color: '#44b549'
            }
        },
        series: [{
            name: '',
            data: [parseInt($('#neworder_month').val()), parseInt($('#valorder_month').val()), parseInt($('#orderdelivering').html()), parseInt($('#ordertoexp').html())]
        }],
        exporting: {
            enabled: false
        },
        legend: {
            enabled: false
        },
        tooltip: {
            enabled: false,
            pointFormat: '<b>{point.y}</b>'
        }
    });

    $.get(shoproot + '?/WdminStat/getSalePercent/', function (res) {

        $('#order-percent').eq(0).highcharts({
            credits: {
                enabled: false
            },
            chart: {
                type: 'pie', style: {
                    fontFamily: '"Microsoft YaHei"',
                    fontSize: '12px'
                }
            },
            title: {
                text: ' ',
                style: {
                    fontSize: '15px',
                    color: '#666',
                    fontWeight: 'lighter'
                }
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    depth: 35,
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                    },
                    size: '60%'
                }
            },

            series: [{
                type: 'pie',
                name: '产品分类',
                data: res
            }]
        });
    });


});

//$(function () {
//
//    $(function () {
//        $('#right_charts1').highcharts({
//            credits: {
//                enabled: false
//            },
//            chart: {
//                type: 'area',
//                inverted: true,
//                style: {
//                    fontFamily: '"Microsoft YaHei"',
//                    fontSize: '12px'
//                }
//            },
//            title: {
//                text: ' '
//            },
//            xAxis: {
//                categories: [
//                    '粉丝数',
//                    '会员数',
//                    '代理数'
//                ]
//            },
//            yAxis: {
//                title: {
//                    text: ''
//                }
//            },
//            plotOptions: {
//                area: {
//                    fillOpacity: 0.5,
//                    dataLabels: {
//                        enabled: true,
//                        x: 20,
//                        y: 12
//                    },
//                    color: '#44b549'
//                }
//            },
//            series: [{
//                    name: '',
//                    data: [parseInt($('#allfanscount').html()), parseInt($('#usersum').html()), parseInt($('#comsum').html())]
//                }],
//            exporting: {
//                enabled: false
//            },
//            legend: {
//                enabled: false
//            },
//            tooltip: {
//                enabled: false,
//                pointFormat: '<b>{point.y}</b>'
//            }
//        });
//
//        $('#right_charts2').highcharts({
//            credits: {
//                enabled: false
//            },
//            chart: {
//                type: 'area',
//                inverted: true,
//                style: {
//                    fontFamily: '"Microsoft YaHei"',
//                    fontSize: '12px'
//                }
//            },
//            title: {
//                text: ' '
//            },
//            xAxis: {
//                categories: [
//                    '下订单',
//                    '已支付',
//                    '快递中',
//                    '未发货'
//                ]
//            },
//            yAxis: {
//                title: {
//                    text: ''
//                }
//            },
//            plotOptions: {
//                area: {
//                    fillOpacity: 0.5,
//                    dataLabels: {
//                        enabled: true,
//                        x: 20,
//                        y: 15
//                    },
//                    color: '#44b549'
//                }
//            },
//            series: [{
//                    name: '',
//                    data: [parseInt($('#neworder_month').val()), parseInt($('#valorder_month').val()), parseInt($('#orderdelivering').html()), parseInt($('#ordertoexp').html())]
//                }],
//            exporting: {
//                enabled: false
//            },
//            legend: {
//                enabled: false
//            },
//            tooltip: {
//                enabled: false,
//                pointFormat: '<b>{point.y}</b>'
//            }
//        });
//    });
//
//    util.onresize(function () {
//        $('#ovw-left,#ovw-right').height($(window).height());
//        $('#right_charts').height($('#dTb').eq(0).height() - 2);
//        $('#right_charts1').height($('#right_charts').height() / 2);
//        $('#right_charts2').height($('#right_charts').height() / 2);
//    });
//});
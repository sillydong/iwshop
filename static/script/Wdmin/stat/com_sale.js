/**
 * Desc
 * @description Hope You Do Good But Not Evil
 * @copyright   Copyright 2014-2015 <ycchen@iwshop.cn>
 * @license     LGPL (http=>//www.gnu.org/licenses/lgpl.html)
 * @author      Chenyong Cai <ycchen@iwshop.cn>
 * @package     Wshop
 * @link        http=>//www.iwshop.cn
 */
requirejs(['jquery', 'util', 'highcharts'], function($, util, highcharts) {
    $(function() {
        $.get(shoproot + '?/WdminStat/getSaleStat/com=1', function(res) {
            $('.stat-h-50').eq(0).highcharts({
                credits: {
                    enabled: false
                },
                title: {
                    text: '本月代理销售趋势',
                    style: {
                        fontSize: '15px',
                        color: '#666',
                        fontWeight: 'lighter'
                    }
                },
                chart: {
                    type: 'line',
                    style: {
                        fontFamily: '"Microsoft YaHei"',
                        fontSize: '12px'
                    }
                },
                xAxis: {
                    categories: res.x,
                    lineWidth: 0
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    minPadding: 0
                },
                legend: {
                    enabled: false
                },
                plotOptions: {
                    line: {
                        dataLabels: {
                            enabled: true,
                            x: 0,
                            y: -7,
                            style: {
                                fontFamily: 'Verdana',
                                fontSize: '13px'
                            },
                            format: '¥{y}'
                        }
                    }
                },
                tooltip: {
                    pointFormat: '销售额: <b>{point.y}</b> 元'
                },
                exporting: {
                    enabled: false
                },
                series: [{
                        name: '销售额',
                        data: res.y
                    }]
            });
        });

        $.get(shoproot + '?/WdminStat/getSalePercent/com=1', function(res) {
            $('.fLeft50').eq(0).highcharts({
                credits: {
                    enabled: false
                },
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    style: {
                        fontFamily: '"Microsoft YaHei"',
                        fontSize: '12px'
                    },
                    width: $(window).width() / 2,
                    height: $(window).height() / 2
                },
                title: {
                    text: '本月代理销售占比',
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
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                        },
                        size: '60%'
                    }
                },
                series: [{
                        type: 'pie',
                        name: '占比',
                        data: res
                    }]
            });
        });

        $.get(shoproot + '?/WdminStat/getCompanyUserPercent/', function(res) {
            $('.fLeft50').eq(1).highcharts({
                credits: {
                    enabled: false
                },
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    style: {
                        fontFamily: '"Microsoft YaHei"',
                        fontSize: '12px'
                    },
                    width: $(window).width() / 2,
                    height: $(window).height() / 2
                },
                title: {
                    text: '代理名下会员比例',
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
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                        },
                        size: '60%'
                    }
                },
                series: [{
                        type: 'pie',
                        name: '占比',
                        data: res
                    }]
            });
        });

        util.onresize(function() {
            var h = $(window).height() - 2;
            $('.stat-h-50').height(h / 2);
            $('#stat-wrap').height(h);
            $('.fLeft50').height((h / 2) - 3);
        });
    });
});
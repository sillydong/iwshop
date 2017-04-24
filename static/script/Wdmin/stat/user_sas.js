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
        $.get(shoproot + '?/WdminStat/getUserStat/', function(res) {
            $('.stat-h-50').eq(0).highcharts({
                credits: {
                    enabled: false
                },
                title: {
                    text: '微信粉丝每日新增',
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
                                fontFamily: '"Microsoft YaHei"'
                            },
                            format: '{y}人'
                        }
                    }
                },
                exporting: {
                    enabled: false
                },
                series: [{
                        name: '增长数',
                        data: res.y
                    }]
            });
        });
        $.get(shoproot + '?/WdminStat/getUserSexPercent/', function(res) {
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
                    text: '会员性别比例',
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
                        colors: ['#d8d8d8', '#F24182', 'rgb(124, 181, 236)'],
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

        $.get(shoproot + '?/WdminStat/getHotBuyUser/', function(r) {
            $('.fLeft50').eq(1).highcharts({
                credits: {
                    enabled: false
                },
                chart: {
                    type: 'column',
                    style: {
                        fontFamily: '"Microsoft YaHei"',
                        fontSize: '12px'
                    },
                    height: $(window).height() / 2
                },
                title: {
                    text: '本月购买力最高',
                    style: {
                        fontSize: '15px',
                        color: '#666',
                        fontWeight: 'lighter'
                    }
                },
                xAxis: {
                    categories: r.x,
                    labels: {
                        rotation: -45,
                        align: 'right',
                        style: {
                            fontSize: '13px',
                            fontFamily: 'Verdana, sans-serif'
                        }
                    }
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '消费金额 (元)'
                    }
                },
                legend: {
                    enabled: false
                },
                tooltip: {
                    pointFormat: '消费金额: <b>{point.y:.2f}</b> 元'
                },
                series: [{
                        name: '库存',
                        data: r.y,
                        dataLabels: {
                            enabled: true,
                            rotation: -90,
                            color: '#FFFFFF',
                            align: 'right',
                            x: 4,
                            y: 10,
                            style: {
                                fontSize: '13px',
                                fontFamily: 'Verdana, sans-serif',
                                textShadow: '0 0 3px black'
                            }
                        }
                    }]});
        });

        util.onresize(function() {
            var h = $(window).height() - 2;
            $('.stat-h-50').height(h / 2);
            $('#stat-wrap').height(h);
            $('.fLeft50').height((h / 2) - 3);
        });
    });
});
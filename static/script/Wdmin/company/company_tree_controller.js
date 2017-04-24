/* global angular */

var app = angular.module('ngApp', ['User.services', 'Util.services', 'Company.services']);

app.controller('companyTreeController', function ($scope, User, Util, Company) {

    var strHTML = '';

    var option = {
        theme: 'vsStyle',
        expandLevel: 5,
        onSelect: function ($treeTable, id) {
            window.console && console.log('onSelect:' + id);
        }
    };

    Util.loading();
    $.get('?/wCompany/getList/&page=0&pagesize=2000&verifed=1', function (r) {
        Util.loading(false);
        var List = r.list;
        for (var i in List) {
            strHTML += '<tr data-tt-id="' + List[i].uid + '" data-tt-parent-id="' + List[i].parent + '"><td>' + List[i].name + '</td><td>' + List[i].uid + '</td><td>' + List[i].email + '</td><td>' + List[i].phone + '</td><td>' + List[i].money + '</td><td>' + List[i].fellow_count + '</td><td class="text-danger">&yen' + List[i].income_total + '</td><td class="text-danger">&yen' + List[i].income_unset + '</td><td>' + List[i].join_date + '</td></tr>';
        }
        $('#treeTable1').append(strHTML);
        $('#treeTable1').treetable(option);
    });

});
/**
 * Created by vignesh on 1/11/16.
 */
$(function () {
    $('#drugs_chart_container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: 'Users vs Stores'
        },
        xAxis: {
            categories: ['A&E Ward', 'Afternoon Dispensary', 'Ante Natal Clinic', 'Chest Clinic', 'Copd Injection Room']
        },
        yAxis: {
            min: 0,
            allowDecimals: false,
            title: {
                text: 'Count'
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            align: 'right',
            x: -30,
            verticalAlign: 'top',
            y: 25,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false
        },
        credits: {
            enabled: false
        },
        tooltip: {
            formatter: function () {
                return '<b>' + this.x + '</b><br/>' +
                    this.series.name + ': ' + this.y + '<br/>' +
                    'Total: ' + this.point.stackTotal;
            }
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: {
                        textShadow: '0 0 3px black'
                    }
                }
            }
        },
        series: [{
            name: 'Store Keeper',
            data: [5, 3, 4, 7, 2]
        }, {
            name: 'Store Manager',
            data: [2, 2, 3, 2, 1]
        }, {
            name: 'Pharmacist',
            data: [3, 4, 4, 2, 5]
        }, {
            name: 'Pharmacy Technician',
            data: [3, 1, 2, 4, 5]
        }]
    });
});
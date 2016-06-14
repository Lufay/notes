### 特性
+ 纯javascript编写的图表库
+ 支持直线图、曲线图、面积图、柱状图、饼图、散点图等多达18种不同类型的图表
+ 支持多种数据形式
+ 多轴支持
+ 图表缩放
+ 图表导出和打印功能

### 安装
只需要一个JS文件和 jQuery 、 MooTools 、Prototype 、Highcharts Standalone Framework 常用 JS 框架中的一个。

### 使用
图表的大小是根据容器设定的

#### 配置
```
$("#container").highcharts("StockChart", {
    chart: {
        type: 'line'      //图表类型（默认：折线）
    },
    title: {
        text: '',
        style: {}
    },
    subtitle: {
        text: '',
        style: {}
    },
    xAxis: {                    //可配置为数组，从而为多多坐标轴，索引从1开始
        title: {
            text: '',
            style: {}
        },
        labels: {               //x轴标记
            format: '{value}',
            formatter: function() {},   //自定义标记内容
            style: {"color":"#6D869F", "fontWeight":"bold"}
        },
        tickInterval: 60000,    //固定x轴时间标记之间的间隔，单位毫秒
        minTickInterval: 60000, //时间标记之间的最小间隔，单位毫秒，默认为两个点之间距离
        dateTimeLabelFormats: { //不同时间单位下的日期格式
			millisecond: '%H:%M:%S.%L',
			second: '%H:%M:%S',
			minute: '%H:%M',
			hour: '%H:%M',
			day: '%e. %b',
			week: '%e. %b',
			month: '%b \'%y',
			year: '%Y'
		},
        plotLines: [],          //垂直标示线，每个数组元素标识一条特殊意义的x值
        plotBands: [],          //垂直标示区
        breaks:                 //x轴打断
        floor:                  //最小值
        ceiling:
        gridLineWidth:          //网格线的宽度，单位px
        gridLineDashStyle:      //网格线的样式
        minRange:               //不能放大的最小区间
        minTickInterval:
    },
    yAxis: {},                  //y轴配置同x轴
    series: [{                  //数据，支持有多条数据，故配置为数组
        name: '',
        data: []                //每个元素表示一个点（可以是[x,y]，也可以是一个obj）
    }],
    tooltip: {                  //坐标点的提示框
        formatter: function() {},
        headerFormat: '',       //提示框头的格式化（通过{}来引用变量）
        pointFormat: '',
        pointFormatter: function() {},
        valuePrefix: '',        //前缀
        valueSuffix: '',        //后缀
        dateTimeLabelFormats: {},
        shared: true,           //多个数据列共享一个提示框
        crosshairs:             //十字准星
        positioner: function() {}   //固定提示框的位置
    },
    legend: {                   //图例
        enabled: true,          //启用
        labelFormat: '',        //内容格式化
        labelFormat: function() {},
        align: 'center'         //在图表中的对齐方式
        layout: 'horizontal'    //水平布局
        floating: false         //浮动后不占位置
    },
    exporting: {                //导出按钮
    },
    plotOptions: {
        line: {
            dataLabels: {       //线上的标签
                enabled: false,
                format: '{y}',
                formatter: function() {}
            }
        },
        series: {
            lineWidth:          //折线宽度，单位px
            dashStyle:          //线样式
            zones: []           //分段显色
            event: {}
        }
    },
    navigator: {                //预览条
        enabled: true,
    },
    rangeSelector: {            //区间查看
        enabled: true,
        buttons: [],            //预置的区间按钮
        selected:               //预选按钮
    },
    scrollbar: {},               //水平拖动条

});
```
[Highcharts配置](http://www.hcharts.cn/api/index.php)
[Highstock配置](http://www.hcharts.cn/api/highstock.php)

### API
*获取chart对象：`$('.chart').highcharts()`*
reflow()：让图大小适应容器。默认情形下，图可以自动响应 window.resize 事件而自动调整大小，但如果仅仅是容器大小调整，而窗口并未调整，图无法自动适应，此时就要显示调用该函数。
setSize(width, height, [Mixed animation])：固定图的大小，宽高单位为pixel，animation默认为true，表示使用默认animation配置，该参数也可以指定为一个配置对象（包括duration 和easing 属性）

*获取series对象：`chart.series`*
*此外，还可以通过series在配置中的id 获取：`chart.get(id)`*
`addPoint(point, b_redraw=true, b_shift=false, animation=true)`：point可以是一个数（y值，被插入图的最后），[x, y]，或[x, open, high, low, close]，obj。`b_redraw`表示插入点后是否进行图形重绘，`b_shift`表示插入点后是否进行图形平移，animation可以是一个obj，包含duration 和easing 配置
`removePoint(index, b_redraw, animation)`：

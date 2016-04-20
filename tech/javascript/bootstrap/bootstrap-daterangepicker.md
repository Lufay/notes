# 时间区间选择插件

[官网](http://www.daterangepicker.com)

## 依赖
jQuery, Bootstrap, Moment.js

## 用法
该插件被绑定到任意的页面元素之上，例如input元素和div元素上：
```HTML
<input type="text" name="daterange" value="01/01/2015 - 01/31/2015" />

<div id="reportrange" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc; width: 100%">
    <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>&nbsp;
    <span></span> <b class="caret"></b>
</div>
```
```javascript
$('input[name="daterange"]').daterangepicker();

function cb(start, end) {							//即时更新显示
	$('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
}
cb(moment().subtract(29, 'days'), moment());		//预置最近30天
$('#reportrange').daterangepicker({}, cb);
```
默认是选择一个日期的区间，绑定到input元素就直接使用其value进行初始化

daterangepicker可以接受2个参数，一个是配置obj，一个是当用户更改日期后的回调函数

### 配置
```javascript
{
    startDate: '2013-01-01',	//预置起始时间
    endDate: '2013-12-31',		//预置终止时间
    timePicker: true,			//增加时间区间选择
    timePickerIncrement: 30,	//分钟选择列表的间隔大小（只提供15和30）
    locale: {
        format: 'MM/DD/YYYY h:mm A',	//时间显示格式
		separator: " - ",		//时间区间分隔符
		applyLabel: "Apply",
		cancelLabel: "Cancel",
		daysOfWeek: [],			//本地化的星期表示
		monthNames: []			//本地化的月份表示
    },
//  singleDatePicker: true,		//退化为时间点选择
    showDropdowns: true,		//使年月也可以通过下拉框选择
	autoUpdateInput: false,		//禁用input value 的自动更新
	autoApply: true,			//不用apply和cancel按钮，当选择好时间段后自动确认
    ranges: {					//预定义时间范围
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
	},
	alwaysShowCalendars: true	//当选择预定义时间范围时同样显示日历
}
```
### 回调函数
```javascript
function(start, end, label) {
    var years = moment().diff(start, 'years');
    alert("You are " + years + " years old.");
});
```
其中start和end是选择的起始和终止时间，如果退化为时间点选择，则只有start有效。他们是moment对象，是当前选择的时间通过locale.format格式化得到。
而label是当前选择的时间段标签(li)
*注意*：由于是先执行该回调函数，再执行input value 的auto update，所以auto update可以会覆盖这里对input value的修改。

### 事件
apply.daterangepicker	点击apply按钮后响应
cancel.daterangepicker	点击cancel按钮后响应
show.daterangepicker	选择器打开时响应
hide.daterangepicker	选择器关闭时响应
showCalendar.daterangepicker	日历打开时响应
hideCalendar.daterangepicker	日历关闭时响应
例如：
```
$('input[name="datefilter"]').on('apply.daterangepicker', function(ev, picker) {
	$(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
});
$('input[name="datefilter"]').on('cancel.daterangepicker', function(ev, picker) {
	$(this).val('');
});
```

### 方法
首先获取到实例：
```javascript
var drp = $('#daterange').data('daterangepicker');
```
方法有
`setStartDate(Date/moment/string)`
`setEndDate(Date/moment/string)`

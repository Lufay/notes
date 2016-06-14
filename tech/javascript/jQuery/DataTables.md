# 基于jQuery 的表格插件
[TOC]

[英文官网](https://datatables.net)
[中文网](http://datatables.club)

## 依赖
jQuery 1.7+

## 用法
```
<table>
    <thead>
        ...
    </thead>
    <tbody>
        ...
    </tbody>
    <tfoot>
        ...
    </tfoot>
</table>

$('table').DataTable();
```

### 数据源
+ client-side: 数据全量导入，排序和搜索都在浏览器端完成，因此适用于小规模的数据（10000行以内）
默认模式
+ server-side: 当需要表格重绘时，都会给服务器发送一个Ajax请求，获得当前需要数据，绘制表格，适用于大规模的数据（大于10w行）
需要配置`serverSide`选项来启动

#### 数据源格式
+ Array of Array: 内层数组的每一项对应表格的一列（按位序对应），要求内层数组的长度和表格的列数相等
默认模式
+ Array of Object: 一个Object就是一个kv数据包，需要在columns的配置中配置和列之间的映射关系
+ Array of Instance: 每个Instance都是一个new 得到的对象，可以通过columns的配置，配置该对象的属性或方法名和列之间的映射关系

#### 数据提供方式
+ DOM: 现成的table数据，支持使用`data-*`的tag属性作为排序和搜索的标准，即当表格中有数据时，再使用将不再接受下面两种方式传入的数据。
+ JavaScript: 使用js 变量来配置data（格式可以是以上三种）
+ Ajax: 通过ajax进行配置，只支持Array或Object，因为Instance没法用json格式表示。

### 更多配置
1.10+版本:
```
{
    paging: false,			//分页（默认true）
    lengthChange: false,	//每页记录数改变（默认true）
    searching: false,		//搜索（默认true）
    ordering: false,		//排序（默认true）
    order: [
        [0, 'asc'],
        [1, 'desc']
    ],
    orderClasses: true,		//可以通过增加class的方式对排序列高亮显示，大数据对性能有影响（默认true）
    columns: [              //设定列的所有初始属性，每列一个，不配置用null占位
        {
            data: '',       //关联data的key, 可以设null，表示不从data配置中获取数据
			title: '',      //thead显示的标题
            name: '',       //给列一个别名，方便使用API时进行定位
            className: '',  //给列的每一项<td>添加一个css class
            orderable: false,   //是否允许该列进行排序（默认true）
            orderSequence: [ 'asc', 'desc' ],   //排序序列
            defaultContent: '', //当没有数据时的静态内容
            render: mix     //复杂的渲染需求
        },
        {},
    ],
    columnDefs: [           //设置定义列的初始属性，可以通过targets进行定位，targets可以是'_all'（所有列），非负数（从左向右，0开始），负数（从右向左，-1开始），字符串（列名匹配），数组（指定多列）。该配置后于columns执行
        {targets:'_all', visible:false},
        {targets:[1, 2], searchable:false}
    ],
    info: true,         //页脚信息（默认true）
    displayStart: 0,    //设置默认每页展示起始位置（default：0）
    pageLength: 10,     //设置默认每页展示个数（default：10）
    lengthMenu: [       //指定每页显示个数下拉框选项
        [10, 25, 50, -1],
        [10, 25, 50, "All"]
    ],
    stateSave: true,        //保存表格状态信息
    pagingType: "full_numbers",     //翻页样式，另一种是two_button
    processing: true,       //处理中的提示
    serverSide: false,  //使用服务端处理
    data:               //js数据源配置
    ajax:               //ajax数据源配置
    autoWidth: true,
    scrollX: true,          //水平滚动条
    scrollY: 400,           //垂直滚动条
    jQueryUI: true,
    scrollCollapse: fales,
    language: {},       //显示语言
    deferRender: false, //启用该选项后，Datatables将不会渲染所有数据，而仅仅渲染当前页数据，而当其他也数据需要时才渲染
    dom:
}
```
*注*: 1.10+版本的配置接口和1.9-的版本有很大不同，而且有些旧的配置可能已经失效，如果想要在1.10+版本进行兼容，需要配置
```
$.fn.dataTable.ext.legacy.ajax = true;
```
选项参考：
<http://datatables.club/reference/option/>
<http://datatables.net/reference/option/>

### 事件

### API
首先需要获得一个DataTable的API实例，才能访问其方法。方式有三种：
通过jQuery对象获取（1.9-的使用方式）
```
$(selector).dataTable()
```
该方法获得一个jQuery对象，可以直接使用其访问方法，也可以通过调用api()方法获得API实例。
```
$(selector).DataTable();
```
配置构造完成后就获得一个API实例。
```
new $.fn.dataTable.Api( selector );
```

大部分方法都支持调用链

#### 表格
table(selector)
tables(selector)

#### 行
row(selector, modifier)
selector 可以是整数（行索引）、字符串（jQuery的selector）、DOM元素变量（tr/td）、jQuery对象、function、以及他们组成的数组
其中function(index, data, node)，index是行索引，data是行数据（原始数据），node是结点元素，返回true/false

子行：附加在一行数据之后的一个独立的行，只有一个单元格（使用colspan），默认不显示
row().child(data, className): 有参数调用，返回一个API实例，data用于填充子row的内容，className是给子行的`<tr>`和`<td>`元素的css class
row().child(): 无参数调用，返回一个jQuery对象或undefined，因为该方法不能进行链式调用，所以无参调用直接使用下面的方法
row().child.isShown(): 检查子行是否显示
row().child.show()
row().child.hide()
row().child.remove()

#### 列

#### 单元格

#### 核心方法

#### 工具

### 样式

### 正交数据(Orthogonal data)
一个单元格可以拥有多重数据格式，用于不同的用途

### server-side 模式
当启用该模式，ajax发送给server处理以下参数
`draw`：int，计数器，用于datatables多次异步的重绘请求进行定序
`start`：int，分页起始的位置（0开始的）
`length`：int，一个分页的记录数（-1表示取回所有）
`search[value]`：str，全局搜索条件，应用于所有searchable为true的列
`search[regex]`：bool，全局搜索条件是否使用正则
`order[i][column]`：int，第i级排序的的列号（基于columns数组）
`order[i][dir]`：str，第i级排序的顺序（’asc’ or ‘desc’）
`columns[i][data]`：str，配置中 columns.data 的值
`columns[i][name]`：str，配置中 columns.name 的值
`columns[i][searchable]`：bool，是否可搜索，配置中 columns.searchable的值
`columns[i][orderable]`：bool，是否可排序，配置中columns.orderable的值
`columns[i][search][value]`：str，应用于某一列的搜索条件
`columns[i][search][regex]`：bool，应用于某一列的搜索条件是否使用正则

服务端应返回
`draw`：int，建议将发给server的draw参数转型为int后再返回，以避免XSS攻击
`recordsTotal`：int，数据库中的记录总数
`recordsFiltered`：int，从数据库中筛选后的记录数
`data`：array，展示的数据内容，每条记录是一个成员，也是一个Array
`error`：str，如果发生错误，则返回错误信息，如果没有，则不要该字段

对于data中，除了每个成员之外，还可以附加
`DT_RowId`：str，设置`<tr>`的id
`DT_RowClass`：str，给`<tr>`增加一个class
`DT_RowData`：obj，使用jQuery的data()方法附加数据
`DT_RowAttr`： obj，给`<tr>`增加属性，obj的key作为属性key，val作为属性值

配置：
```
$(selector).DataTable({
    serverSide: true,
    ajax: '/data-source'
});
```
注：
ajax: 可以是一个url，还可以类似jQuery的格式，或一个自定义的function（对Ajax的完全控制）。
如果使用jQuery格式，ajax.data可以指定为一个function，该函数接受一个obj作为参数，返回值作为ajax.data发送给server；ajax.success不可重写，因为那是datatables处理的。

参考：
<http://datatables.net/manual/server-side>
<http://datatables.club/manual/server-side.html>
样例：
<http://datatables.club/example/server_side/simple.html>

### columns.data 和 columns.render 的用法
他们的使用方式比较相似，可以认为render 是 data 的一个只读版本，它仅仅是从数据源读取数据进行显示，而data 会写数据源
+ int, 默认，数组索引
+ str, object的key，但有三个特殊字符可以改变行为
    - `.`，获取嵌套对象
    - `[]`，将数组中指定的属性，用[]之间的内容作为连接字符串连成一个整串
    - `()`，调用对应函数
+ Object, key为用途类型，value可以是整数、字符串或函数（参考其他内容）
    - "`_`": "plain",   //默认值的key
    - "filter": "filter", //filter时的key
    - "display": "display",//display时的key
    - "type": "display"
    - "sort": "display"
+ function(data, type, row, meta)
    - data: 当前cell的值（基于columns.data）
    - type: display、type、sort、filter
    - row: 整行数据（即data中的当前行）
    - meta: {
        + row: 被请求单元格行索引
        + col: 被请求单元格列索引
        + settings: DataTables.Settings API实例

### createdRow 回调
function (row, data, dataIndex)
其中row是已经渲染的tr结点，data是这行的数据，dataIndex是Datatables内部的存储索引


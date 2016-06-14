# CSS

解决内容与表现样式分离的问题，从而样式可以复用于多个文件之中
## 导入方式
### 外部样式表（多文件统一）
```
<head>
	<link rel="stylesheet" type="text/css" href="mystyle.css" />
</head>
```

### 内部样式表（单文件统一）
```
<head>
	<style type="text/css">
		body {
			background-color: red;
		}
		p {
			margin-left: 20px;
		}
	</style>
</head>
```

### 内联样式（元素单设）
```
<p style="color: red; margin-left: 20px">
	This is a paragraph
</p>
```

## 层叠的优先次序
内联 > 内部 > 外部 > 浏览器默认设置
（在同一级上的层叠次序就变得很有趣<http://www.zhangxinxu.com/wordpress/2012/08/256-class-selector-beat-id-selector/>）

子元素会继承父元素的CSS属性，除非子元素对该属性进行了重定义

## 语法规则
```
selector {
	property: value;
	property: value;
	property: value;
	...
}
```
selector是选择器，详见下文
如果value是多个单词，需要使用引号括起来，而如果是多项，则使用逗号分隔

### 注释
```
/* xxxx */
```

### 选择器
使用元素标签名      `tag_name`      可以使用`*`匹配全部
使用ID              `#id`
使用class           `.class`
使用标签属性        `[attr]`
伪类                `:first`
除class和id外，对大小写不敏感

上面的选择器可以组合使用：
连在一起使用，表示“且”的关系
逗号分隔，表示为这些元素都应用同一样式（并）
空格分隔，表示后者是前者的内部元素，只对该派生结构的内部元素应用
而 > 分隔，表示后者是前者的子元素，只对该子元素应用
而 + 分隔，表示后者是紧跟在前者后面的兄弟元素，只对该元素应用

#### 伪类
链接的四种状态：
+ a:link - 普通的、未被访问的链接
+ a:visited - 用户已访问的链接
+ a:hover - 鼠标指针位于链接的上方
+ a:active - 链接被点击的时刻
当为链接的不同状态设置样式时，请按照以下次序规则：
a:hover 必须位于 a:link 和 a:visited 之后
a:active 必须位于 a:hover 之后
其他伪类：
tag:first-child——作为第一个子元素的tag

### value函数
rgb(r,g,b)，对应了#000000~#ffffff的值;
url(/a/b/c.d)
位置：top, bottom, left, right, center
长度：px（像素）,em（相对于父元素一个字体的高度）,rem（相对于根元素html一个字体的高度）,cm
百分比：90%，0%（左上角表示原点）

## 专题
### 框模型
border
margin 外边距，默认透明，垂直方向的外边距会合并
padding 内边距，拥有背景
默认都是0
内边距以内是内容部分，width和height指定的是这部分的大小
如果元素没有指定height，则内容的高度由inline-height决定，而一个块的inline-height的值由其子元素中最大的inline-height决定，而实际的内容是在inline-height之内的居中位置
行内元素的默认垂直对齐方式（vertical-align）是按基线对齐，如果一个inline-block元素，其中没有行内元素，那么其基线就是inline-block元素的下边框，而如果有行内元素，那么其基线就是其中行内元素的基线

### 定位position
display设置生成框的类型：
常用：
+ none不显示（也不占位）
+ block块级元素（结束后自动换行）
+ inline内联元素（行内），行高由行内最高元素决定
定位机制：普通流（默认）、浮动、绝对定位
默认普通流中定位，按照HTML中的位置，块级元素从上到下一个接一个排列，行内框的一行水平布置。
#### position属性
+ static（普通流）
+ relative：元素相对于其本来位置（普通流）偏移（普通流中依然占位），会覆盖其他元素
+ absolute：相对于最近已定位的祖先元素定位（普通流中不占位），会覆盖其他元素（自身变为块级框）
+ fixed：相对于视窗本身内绝对定位
而后就可以使用top、bottom、left、right设置位置
可以使用width和height设置内容大小，如果内容溢出设置的范围，可以使用overflow: scroll设置滚动条（默认是visible，还可以设置hidden隐藏）
内容重叠后，可以使用z-index这是显示优先级。
#### 浮动float
元素脱离普通流进行左右浮动，直到碰到框边界或另一个浮动框的边框为止
由于浮动元素并不在普通流中，所以会覆盖下一个相邻的块级元素，而行内其他框会环绕浮动框展现，除非指定框的clear属性，使其某边（both/left/right）不挨着浮动框（简单的说就是浮动元素不占高度，只占宽度）
当一个元素浮动后，就不再认定其本身的块级或行内元素，都按浮动次序进行水平排列，（父级元素）行宽不足则换行，在换行时，尽可能保持最高的垂直位置

### table-layout 属性
确定表格行、列、单元格布局的方式
可能的值
|值|描述|
|---|---|
|automatic |默认。列宽度由所有单元格中最宽设定（较慢）|
|fixed     |列宽由表格宽度和列宽度（列宽取决于第一行单元格宽度）设定（较快）|
|inherit   |规定应该从父元素继承 table-layout 属性的值。|

### overflow 属性
溢出元素内容区的内容处理方式
可能的值
|值|描述|
|---|---|
|visible |默认值。内容不会被修剪，会呈现在元素框之外。|
|hidden  |内容会被修剪，并且其余内容是不可见的。|
|scroll  |内容会被修剪，但是浏览器会显示滚动条以便查看其余的内容。|
|auto    |如果内容被修剪，则浏览器会显示滚动条以便查看其余的内容。|
|inherit |规定应该从父元素继承 overflow 属性的值。|

### text-overflow 属性
CSS3，当文本溢出包含元素时的处理方式
可能的值
|值|描述|
|---|---|
|clip      |修剪文本。|
|ellipsis  |显示省略符号来代表被修剪的文本。|
|string    |使用给定的字符串来代表被修剪的文本。|


### white-space 属性
对内容中空格的处理
可能的值
|值|描述|
|---|---|
|normal    |默认。空白会被浏览器忽略。|
|pre       |空白会被浏览器保留。其行为方式类似 HTML 中的 `<pre>` 标签。|
|nowrap    |文本不会换行，文本会在在同一行上继续，直到遇到 `<br>` 标签为止。|
|pre-wrap  |保留空白符序列，但是正常地进行换行。|
|pre-line  |合并空白符序列，但是保留换行符。|
|inherit   |规定应该从父元素继承 white-space 属性的值。|

### word-wrap 和 word-break 属性
CSS3，文本自动换行方法
word-wrap的做法，会首先将长单词另起一行，如果依然超长，才折断单词
word-break的做法，会直接在当前行将超长单词进行折断
#### word-wrap
可能的值
|值|描述|
|---|---|
|normal    |只在允许的断字点换行（浏览器保持默认处理）。|
|break-word|在长单词或 URL 地址内部进行换行。|
#### word-break
可能的值
|值|描述|
|---|---|
|normal    |使用浏览器默认的换行规则。|
|break-all |允许在单词内换行。|
|keep-all  |只能在半角空格或连字符处换行。|
|hyphenate ||

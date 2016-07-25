# Js DOM
[TOC]

### js 代码为什么受到吐槽
永远不要假定JavaScript或者Ajax一定可用
> 最佳实践：
> **平稳退化、渐进增强、以用户为中心**

即，确保网页在没有或不支持js的情况下也能正常工作

+ 网页的本质是内容
+ HTML就是为内容搭建的结构
+ CSS是结构上的装饰物
+ JavaScript就是让这些动起来

**代码是思想和概念的体现**

### 最佳实践
+ 为了提高性能，减少请求次数，尽可能把 js 代码合并到一个文件中（因为每个js 文件就意味着一次请求，除非已经缓存）
+ 尽量减少标签数量，不必要的元素会增加DOM 树的规模，增加遍历DOM 树查找特定元素的时间
+ `<script>`标记应放在`</body>`标记之前，因为按照HTTP规范，浏览器每次从同一域名最多只能同时下载两个文件，而且在下载脚本期间，浏览器不会下载其他任何文件，即使来自于不同域名的文件。而当加载到`</body>`时，主体页面都已经加载完毕，此时加载大型的js 文件不会严重影响体验。
+ 写完脚本，做了优化之后，可以通过压缩脚本（删除不必要的字节，如空格和注释；使用更短的变量名）来加快加载速度（通常，.min.js 就对应了压缩版的文件名）（网上有很多这样的工具）

******

## js 语法
js 是浏览器解释执行的脚本语言（实际上是浏览器中的 js 解释器）
于是js可以直接嵌入到HTML代码中，如：
```
<script>
    js code
</script>
```
当然也可以像css一样从外部导入：
```
<script type="text/javascript" src="file.js"></script>
```
由于`type="text/javascript"`是默认值，因此可以省略
最好是将该标签放在`<body>`的底部，已确保加载完静态内容再加载可能较慢的动态内容

另外还有一种伪协议调用（不推荐）
```
<a href="javascript:func(args);"></a>
```
func可以是一个已经定义的函数

### 语言特性
行末不必有分号分隔，除非一行写多条语句（但写上分号是一个良好的习惯，推荐）

#### 注释
支持 `//` 和 `/*...*/` 的注释
（还可以使用HTML的`<!--`作为注释，但作用和`//`是一样的）

### 交互
`alert(var)`: 弹出式警告窗口
`confirm(msg)`: 弹出式确认窗口，如果确认，返回true；否则返回false

### 调试
`console.dir(var)`: 在调试器的控制台打印出var。如果var是一个DOM对象，那么使用console.dirxml()效果更好
`debugger;`: 该语句直接在代码中放入一个断点，并且可以放在条件语句中进行控制。

### 变量
#### 声明
```
var a, b, c;
```
声明的变量是限定作用域的（函数级），而未声明的变量是全局的（整个脚本）
标识符名除了一般的标识符规则外，还可以包含 $ 字符，大小写敏感
JavaScript是一种弱类型语言，声明并不确定类型，类型由赋值时确定

#### 类型
+ 数值（Number）包括整数、浮点
+ 布尔（Boolean）只有true、false
+ 字符串（String）单双引号均可
+ 数组（Array）
+ 对象（Object）
+ 空，只有null
+ 未定义，未赋值的变量，undefined

##### 类型测试
`typeof a` 测试变量a的类型，返回一个字符串表示的类型名（number、boolean、string、undefined、function、object），但对于null，Array和Object返回的名都是object

`null`是个单例对象，可以用===进行比较

判断数组的方法有三种：
```
Object.prototype.toString.apply(arr) == '[object Array]'
Object.prototype.toString.call(arr) == '[object Array]'
```
或（跨页面传递的数组会判断失败）
```
arr.constructor == Array
```
或（跨页面传递的数组会判断失败）
```
arr instanceof Array
```

##### 布尔测试
数值 0，空串，null进行布尔判断时都是false

### 数组
```
var arr1 = Array();
var arr2 = Array(4);             //指定初始化大小
var arr3 = Array('a', 2, false, arr2);
var arr4 = ['a', 2, false, arr2];      //上面的简写形式
```
下标从0 开始，数组的长度通过其 length 属性获取
支持混合类型，支持嵌套

#### 关联数组
```
var arr = Array();
arr["a"] = "aaa";
```
Array也是对象，这里是给这个对象添加了一个属性
不推荐，推荐使用对象

### 对象
```
var obj = Object();
obj.a = 'aaa';
obj.b = 323;
obj.c = false;

var ojb2 = {property1:value1, property2:value2}   //简写形式
```
property和变量的命名规则相同，value可以是任何类型

### 运算符
+ 数值：支持`++`、`--`、`+=`
+ 字符串：使用 `\\` 转义，+ 进行字符串连接（可以直接和数值进行连接），也支持`+=`
+ 关系：== / !=（等价判断，进行类型归一）=== / !==（全等判断，类型不同就false）、比较(4种)
+ 逻辑：支持&&、||、!
+ 三目：?:

注意：不要在条件判断中使用赋值的 `=`, 只要赋值成功就是true

### 控制语句
同C
if、while、do {} while、for

### 函数
```
function func_name(args) {
    //block
    return ret;
}
```
多个参数使用逗号分隔，在调用时不必给出全部参数，没有给出的参数将是undefined

### 面向对象
创建实例使用 new 运算符，访问成员使用`.`运算符
#### 自定义对象
```
var a = new Person;
a.age       // 访问成员
```
#### 内建对象
Array、Math、Date
#### 宿主对象
由运行环境（如浏览器）提供的预定义对象（例如Form、Image、Element、document）



******

## DOM
DOM定义了访问HTML和XML文档的标准，与平台和语言无关的编程接口，允许程序动态地访问和更新文档的内容、结构和样式。
DOM不专属于 js，可以通用于支持DOM的程序语言，它的作用也不仅仅限于处理网页，还可以处理任何一种标记语言
**即：**它可以让拥有DOM API的任意一种语言处理任意一种标记语言

DOM是树形对象，每个节点也都是一个对象，拥有属性和方法
而结点的类型有元素、文本、属性、注释

### 元素对象
#### 属性
+ childNodes，包含所有类型的子节点的数组
+ firstChild，childNodes[0]
+ lastChild，childNodes[childNodes.length-1]
+ nextSibling
+ parentNode，父节点
+ attributes，属性节点
+ nodeName，结点标签名/属性名/#text（只读），总是返回大写字符串
+ nodeType，（只读）12种取值，其中1表示元素节点、2表示属性节点、3表示文本节点、8表示注释
+ nodeValue，获取和设置节点的值，元素节点为null/undefined，文本节点为内容，属性为属性值（读写）

#### 方法
+ getElementsByTagName("name")，返回对应标签元素的对象数组（有属性length可以获知长度），其中name支持 * 通配符
+ getElementsByClassName("cname")，返回拥有这些class的对应标签元素的对象数组，其中cname可以指定多个class（且），class之间用空格分隔，顺序不重要
不一定完全支持，需用`if (node.getElementsByClassName)`进行测试
+ getAttribute("aname")，该元素节点对象不能是document，如果没有，则返回null
+ setAttribute("aname", "value")，该元素节点对象不能是document，无则添加，有则修改（该改动不会影响浏览器查看源码的显示）

#### 事件
##### 在HTML中注册事件（不推荐）
```
<tag event="js codes">
```

##### 通过js代码绑定事件
```
node.event = function() { js codes }
```

其中[event](http://www.w3school.com.cn/jsref/dom_obj_event.asp)常用的包括：
+ onclick：该事件不仅仅对鼠标点击会响应，对于回车键打开链接也会响应
+ ondblclick：双击
+ onmousedown和onmouseup：鼠标按下和松开（而后触发onclick事件）
+ onkeypress：键盘按键
+ onkeydown和onkeyup：键盘键按下和松开
+ onmouseover和onmouseout：鼠标移入和移出时触发。
+ onmousemove：鼠标每移动一个像素就触发一次
+ onselect：文本被选中
+ onchange：改变输入字段内容时触发
+ onsubmit：提交按钮被点击
+ onreset：重置按钮被点击
+ onfocus和onblur：对象获得焦点和失去焦点
+ onresize：窗口或框架被调整大小
+ onload：页面或图片加载完成后
+ onunload：用户退出页面时

在 js codes 中，可以使用this表示当前的元素对象node
在最后，如果`return true`（默认），则继续触发该tag标签的默认事件（比如a 标签的跳转），如果`return false`，则不会触发后续动作（从而实现对事件的拦截）

> 平稳退化
如果拦截了标签的默认事件，比如a 标签，此时href 属性就没什么用处了，当然可以指定为"#"（内部空链接），不过基于平稳退化的考虑，还是将其指定为一个有效的URL，来确保即使 js 代码无效时也可以响应用户。





### window
对应浏览器窗口本身
#### 方法
+ open(url, name, features)
    url: 新窗口打开页面的url，如果缺省则为空白页
    name: 新窗口的名字，可以在代码中通过该名字与新窗口进行通信
    features: 新窗口的各种属性（字符串，属性间用逗号分隔），例如`"width=320,height=480"`

### window.document
网页内容（只有当window加载完成后，该对象才是有效的）
#### 方法
+ getElementById("id")，返回对应元素的对象

### window.location
#### 属性
+ href：取得当前地址栏中的完整URL，可以通过赋值改变当前地址栏中的URL；
+ search：取得当前URL的参数部分，即“?”后面的部分（包括问号），可以通过赋值改变URL的参数部分；
+ hash：取得当前URL中包含的锚记，即“#”后面的部分（包括#），可以通过赋值改变URL的锚记部分;
+ host：取得当前URL中的主机信息，包括端口号，可以通过赋值改变主机信息；
+ hostname：取得当前URL中的域名部分，不包括端口号，可以通过赋值改变域名；
+ port：取得当前URL中的端口号，可以通过赋值改变端口号；
+ pathname：取得当前URL中的路径信息，即域名与参数之间的部分，可以通过赋值改变当前URL的路径；
+ protocol：取得当前URL的协议部分，比如http:，https:等，可以通过赋值改变URL的协议部分；

#### 方法
+ replace(url)：用传入的URL字符串替代当前的URL，该方法会将历史记录中的URL一并替换掉，也就是说，这个方法会覆盖之前的历史记录；
+ reload()：重新加载当前URL，相当于刷新；
+ assign(url)：加载传入的URL，该方法不会覆盖之前的历史记录；

### window.history
包含用户（在浏览器窗口中）访问过的 URL
当访问一个页面时，将该页面插入到history的当前位置

#### 属性
length : 返回浏览器历史列表中的 URL 数量

#### 方法
+ back()
加载历史列表中的前一个 URL（如果存在）
效果等价于点击后退按钮或调用 history.go(-1)
+ forward()
加载历史列表中的下一个 URL
效果等价于点击前进按钮或调用 history.go(1)
+ go(number|URL)
加载历史列表中的某个具体的页面
URL 参数使用的是要访问的 URL，或 URL 的子串。而 number 参数使用的是要访问的 URL 在 History 的 URL 列表中的相对位置。

******
HTML5 新接口
使用其最好使用`if (window.history.pushState)` 或 `if ('pushState' in history)` 进行测试

+ pushState(state, title, url)
将一条history插入到当前位置（url会变更，当并不刷新页面，也就是说该history实际关联的还是原页面，除非刷新页面）
state 是一个JavaScript对象（最大存储空间为640K），它和history的一条记录关联，当一条history被取出时，会触发 window.onpostate 事件，并将对应的state（没有state为null）传递给事件处理函数.
title 是一个字符串，目前没什么效果
url 就是新插入history 的url，可以是绝对，也可以相对（不能跨域）如果缺省，则为当前的url。
如果后退则会退回未执行本语句之前的url，再前进回来也不会刷新页面。
+ replaceState
修改当前的history条目

#### 事件
window.onpostate

```
window.history.pushState({title:title, url:url}, title, url);

window.addEventListener('popstate', function (event) {
	if (history.state) {			// 当前URL下对应的状态信息
		var url = event.state.url;	// event.state 同history.state
		//根据url值进行相应操作
	}
}, false);
```

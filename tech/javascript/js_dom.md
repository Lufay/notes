# JavaScript
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

# js 语法
js 是浏览器解释执行的脚本语言（实际上是浏览器中的 js 解释器）
当然通过node 在服务端也可以解释执行

## client（浏览器）
于是js可以直接嵌入到HTML代码中，如：
```html
<script>
    js code
</script>
```
当然也可以像css一样从外部导入：
```html
<script type="text/javascript" src="file.js"></script>
```
由于`type="text/javascript"`是默认值，因此可以省略
最好是将该标签放在`<body>`的底部，已确保加载完静态内容再加载可能较慢的动态内容
因为
当浏览器加载 HTML 时遇到`<script>...</script>`标签，浏览器就不能继续构建 DOM。它必须立刻执行此脚本。对于外部脚本`<script src="..."></script>`也是一样的：浏览器必须等脚本下载完，并执行结束，之后才能继续处理剩余的页面。
这会导致两个重要的问题：
1. 脚本不能访问到位于它们下面的 DOM 元素
2. 如果页面顶部有一个笨重的脚本，它会“阻塞页面”。在该脚本下载并执行结束前，用户都不能看到页面内容
但放在`<body>`的底部，也有一个缺点，就是浏览器只有在下载了完整的 HTML 文档之后才会注意到该脚本（并且可以开始下载它）。对于长的 HTML 文档来说，这样可能会造成明显的延迟。
有2种特性可用解决该问题：

### defer 特性
浏览器不要等待脚本。相反，浏览器将继续处理 HTML，构建 DOM。脚本会“在后台”下载，然后等 DOM 构建完成后，脚本才会执行。
该特性HTML 4.01支持，并且只对外部脚本文件才有效，所以必须要有src 属性

```html
<script defer src="https://javascript.info/article/script-async-defer/long.js"></script>
<script defer src="https://javascript.info/article/script-async-defer/small.js"></script>
```
具有 defer 特性的脚本总是要等到 DOM 解析完毕，但在 DOMContentLoaded 事件之前执行。
并且执行顺序和其位置顺序一致，也就是long.js和small.js 同时下载并加载，但small.js 必须要等到long.js执行结束才会被执行

### async 特性
与defer 类似，不阻塞页面，差别是async 是独立的，没有位置依赖关系，它会异步下载，加载完成后立即执行（但执行脚本会阻塞页面渲染）
该特性HTML5支持，仅适用于外部脚本，即必须有src 属性

```html
<script async src="https://javascript.info/article/script-async-defer/long.js"></script>
<script async src="https://javascript.info/article/script-async-defer/small.js"></script>
```

对于动态脚本
```js
let script = document.createElement('script');
script.src = "/article/script-async-defer/long.js";
// script.async = false;
document.body.append(script);
```
默认append 就是async 的，除非将async 置为 false，则变成defer


另外还有一种伪协议调用（不推荐）
```
<a href="javascript:func(args);"></a>
```
func可以是一个已经定义的函数

## 语言特性
大小写敏感
行末不必有分号分隔，除非一行写多条语句（但写上分号是一个良好的习惯，推荐）

### 注释
支持 `//` 和 `/*...*/` 的注释
（还可以使用HTML的`<!--`作为注释，但作用和`//`是一样的）

### 交互
`alert(var)`: 弹出式警告窗口
`confirm(msg)`: 弹出式确认窗口，如果确认，返回true；否则返回false

#### 调试
`console.log(...args)`: 可以在控制台打印多个变量
`console.dir(var)`: 在调试器的控制台打印出var。如果var是一个DOM对象，那么使用console.dirxml()效果更好
`debugger;`: 该语句直接在代码中放入一个断点，并且可以放在条件语句中进行控制。

## 变量
### 声明
```js
var a, b, c;    // 不推荐
const d = {}    // ES6推荐1，必须初始化并绑定
let e, f;       // ES6推荐2
```
声明的变量是限定作用域的（函数级），而未声明的变量是全局的（整个脚本）
标识符名除了一般的标识符规则外，还可以包含 $ 字符（一般用于DOM elements）
JavaScript是一种弱类型语言，声明并不确定类型，类型由赋值时确定

var 的声明是原有的声明方式，拥有函数级作用域（不带任何标识是全局作用域），它有几个问题：
1. 声明之前就可以使用该变量，但值是undefined（用到的是声明提升的特性，即var 声明会提升到函数体首）
2. 对于同一个名字，可以多次声明，离使用位置最近的一处生效
3. for 循环中var 声明的变量实际会被提升到函数首，所以在该语句块结束后，在函数中依然可以使用
4. 若在全局作用域使用var 声明，则将成为window对象的属性
let 声明是块作用域，不会声明提升
1. 声明前使用会报错
2. 不允许重复声明同一名字，否则报错
3. 即使在在全局作用域声明，也不会成为window对象的属性
const 也是块作用域，而且名字和对象会绑定，不允许改绑

```js
for (let i=0; i<5; i++) {
    setTimeout(() => {
        console.log(i)
    }, 0);
}
// 如果不支持ES6 就只能这样：
for (var i=0; i<5; i++) {
   (function(k){
    setTimeout(function(){console.log(k)},1000)
    })(i);
}
```
如果使用var i 将得到5 5 5 5 5，而使用let 得到的是0 1 2 3 4
因为var 会把i 提升为函数变量，所以内部匿名函数保存的就是就是这个函数变量，即退出循环的值；而let 是块级变量，每次迭代绑定的是不同的变量
而通过封装函数调用，则每次绑定的都是函数的参数k

### 类型
+ 数值（Number）包括整数、浮点
+ 布尔（Boolean）只有true、false
+ 字符串（String）单双引号均可，允许使用'\uxxxx' 表示一个字符(Unicode码点)
+ 数组（Array）例如`['a', 'b']`
+ 对象（Object）例如`{color: 'red', shape: 'Rectangle'}`
+ 映射（Map）key 可以是任意值，能保持插入顺序，例如new Map()
+ 空，只有null
+ 未定义，未赋值的变量，undefined

#### 类型测试
`typeof a` 测试变量a的类型，返回一个字符串表示的类型名（number、boolean、string、undefined、function、object），但对于null，Array和Object返回的名都是object

`null`是个单例对象，可以用===进行比较

判断数组的方法有三种：
```js
Object.prototype.toString.apply(arr) == '[object Array]'
Object.prototype.toString.call(arr) == '[object Array]'
```
或（跨页面传递的数组会判断失败）
```js
arr.constructor == Array
```
或（跨页面传递的数组会判断失败）
```js
arr instanceof Array
```

#### 布尔测试
数值 0，空串，undefined，null进行布尔判断时都是false

### 数组
```js
var arr1 = Array();
var arr2 = Array(4);             //指定初始化大小
var arr3 = Array('a', 2, false, arr2);
var arr4 = ['a', 2, false, arr2];      //上面的简写形式
```
下标从0 开始，数组的长度通过其 length 属性获取
支持混合类型，支持嵌套

#### 方法
push(...items): 数组尾添加元素，返回之后的数组长度

map(func, )

#### 关联数组
```js
var arr = Array();
arr["a"] = "aaa";
```
Array也是对象，这里是给这个对象添加了一个属性
不推荐，推荐使用对象

#### 方法
join(separator=',')：将数组每个成员（转换为字符串）通过separator连接起来，返回连接的字符串。
some()
every()
filter()
map()
<http://www.w3school.com.cn/jsref/jsref_obj_array.asp>
<http://www.runoob.com/jsref/jsref-obj-array.html>

### 对象
```js
var obj = Object();
obj.a = 'aaa';
obj.b = 323;
obj.c = false;
obj['d'] = 1
obj[Symbol('abc')] = 10

var obj2 = {property1:value1, property2:value2}   //简写形式
for (const property in obj2) {          // for-in 遍历会忽略Symbol key
    console.log(`${property}: ${object[property]}`)
}
```
property和变量的命名规则相同，value可以是任何类型

Object 无法直接for-of遍历，需要Object.keys(o)/Object.values(o)/Object.entries(o) 转为一个可迭代实例
但Object 可以使用for-in 遍历property，该遍历会延原型链由近及远的遍历所有继承的属性

#### 原型链
对象有一个`__proto__` 的属性，默认是Object.prototype，也可以自己指定为一个对象，当指定为一个对象以后，那么这个对象也拥有了`__proto__` 的属性，从而形成了一条原型链
`Object.prototype.__proto__` === null，即没有原型

### Map
```js
const map1 = new Map();
for (const t of map1) {
    console.log(t)  // t is [key, val]
}
```
key 可以是任意类型，其相等比较相当于`===` 差别是NaN，key 比较认为相同，而`===` 认为不同

#### 属性
size

#### 方法
set(key, val): 覆写set
get(key): 若不存在key，则返回undefined
has(key): 是否存在
delete(key): 返回是否删除成功
clear(): 清空
keys(): key的迭代器
values(): val的迭代器
entries(): [key, val] 的迭代

#### 跟Object的区别
1. Map 初始不包含任何key，而Object 初始就有prototype 属性
2. Map 的key 可以是任意类型，Object 的key 必须是String 或Symbol
3. Map 的顺序是和插入顺序一致的，Object 的顺序则是不一定的
4. Object 没有size 属性
5. Map 可以for-of直接遍历，Object 不能for-of直接遍历

## 运算符
+ 赋值：支持增量赋值，例如`+=`等
+ 数值：支持`++`、`--`、`**`(乘方)
+ 字符串：使用 `\\` 转义，+ 进行字符串连接（可以直接和数值进行连接），也支持`+=`
+ 关系：== / !=（等价判断，比较前进行类型统一）=== / !==（全等判断，类型不同就false）、比较(4种)
+ 逻辑：支持&&、||、!、??
+ 位运算：`<<`、`>>`、`>>>`(无符号右移)、&、|、^(xor)
+ 三目：?:

注意：
1. 不要在条件判断中使用赋值的 `=`, 只要赋值成功就是true
1. || 运算当左操作数的布尔判断为true，就返回左操作数；否则返回右操作数
    && 运算当左操作数的布尔判断为false，就返回左操作数；否则返回右操作数

### 解包赋值
```js
const foo = ['one', 'two', 'three'];
const big = ['four', 'five', ...foo]    // 解包扩展，扩展不限定是最后一个

const [one, two, three] = foo;
[a, ...rest] = foo  // rest 也是一个Array
[a, ,b] = [1, 2, 3, 4, 5]   // a = 1, b = 3，长度不需要对齐，若左侧较多，则值为undefined
[a=9, ,b] = [, 2, 3, 4, 5]  // a = 9, 当长度不足，或者undefined、null 时使用默认值，默认值可以是任意表达式，仅当启用默认值时才进行表达式计算

const obj = { a: 1, b: 2};
const bigO = {c:3, ...obj}    // 解包扩展，扩展不限定是最后一个

const { a, b } = obj;   // a = obj.a, b = obj.b
({a: foo[1], b: foo[2]} = obj); // 赋值而非声明时，必须加括号

const obj = { a: 1, b: { c: 2 } };
const { a, b: { c: d } } = obj; // a = obj.a, d = ojb.b.c

const { a, ...others } = { a: 1, b: 2, c: 3 };  // others 也是一个obj
```
数组解包的右侧不仅限于Array，只要支持可迭代协议，都可以对其进行解包

## 控制语句
同C
if、while、do {} while、for

### for of
```js
for (const element of array1) {
  console.log(element);
}
```
只要支持可迭代协议的对象都可以进行迭代，内置的对象包括String,Array, array-like objects (e.g., arguments or NodeList), TypedArray, Map, Set

## 函数
```js
function func_name(args) {
    //block
    return ret;
}
```
多个参数使用逗号分隔，在调用时不必给出全部参数，也可以给超出参数列表个数的参数，没有给出的参数将是undefined，超出部分可以使用arguments获取
单入口单出口原则：单出口就是要确保函数只有一个return语句（当然除非这些return语句是为了避免陷入过深的逻辑嵌套）
函数也是一个对象，它有prototype 属性，该属性默认就是Object()

### arguments
这是函数体内的一个内置对象，它包含了当前函数所有的参数，是一个类似Array 的对象（不能改动/sort/forEach/map），可以通过callee 属性访问当前函数
可以通过以下方式将其转换为一个array：
```js
Array.prototype.slice.call(arguments)   // 可以指定第二个参数n，表示从位置n开始的切片，n 支持负值，-1 是最后一个字符
[].slice.call(arguments)
Array.from(arguments)
[...arguments]
```
typeof arguments == object

### 变长参数 & 解包调用
```js
function f(a, b, ...theArgs) {
  // type of theArgs is Array
}

const arr = [1, 2, 3, 4, 5]
f(...arr)   // Spread
```
跟arguments 不同的是，theArgs 是一个真正的array

## 面向对象
创建实例使用 new 运算符，访问成员使用`.`运算符

`new C()`中new 运算符的作用：调用C() 函数，初始化 this = {}，然后将函数的prototype 赋给this`this.__proto__ = C.prototype`，执行其他初始化工作（也就是函数体），返回this
这里C() 可以是任意函数，无论该函数是否return，如果被new 调用，都会忽略

### 自定义对象
```js
function Person() {}

var a = new Person;
// a.__proto__ === Person.prototype
// Person.prototype.constructor === Person
a.age       // 访问成员
```

### 内建对象
Array、Math、Date

### 宿主对象
由运行环境（如浏览器）提供的预定义对象（例如Form、Image、Element、document）



******

# DOM
DOM定义了访问HTML和XML文档的标准，与平台和语言无关的编程接口，允许程序动态地访问和更新文档的内容、结构和样式。
DOM不专属于 js，可以通用于支持DOM的程序语言，它的作用也不仅仅限于处理网页，还可以处理任何一种标记语言
**即：**它可以让拥有DOM API的任意一种语言处理任意一种标记语言

DOM是树形对象，每个节点也都是一个对象，拥有属性和方法
而结点的类型有元素、文本、属性、注释

针对网页，有特殊的HTML DOM，它比通用DOM用法更简单，但只能处理Web文档，例如
document.form
element.src
element.href
element.innerHTML
和各种事件属性

## 元素对象
### 属性
+ childNodes，包含所有类型的子节点的数组
+ firstChild，childNodes[0]
+ lastChild，childNodes[childNodes.length-1]
+ nextSibling，下一个兄弟结点，注意：元素之间的空白文本也构成文本结点，而对于最后一个结点，该属性为null
+ parentNode，父节点
+ attributes，属性节点
+ nodeName，结点标签名/属性名/#text（只读），总是返回大写字符串
+ nodeType，（只读）12种取值，其中1表示元素节点、2表示属性节点、3表示文本节点、8表示注释
+ nodeValue，获取和设置节点的值，元素节点为null/undefined，文本节点为内容，属性为属性值（读写）
+ innerHTML，元素节点的内部HTML文档（读写）

### 方法
+ getElementsByTagName("name")，返回对应标签元素的对象数组（有属性length可以获知长度），其中name支持 * 通配符，找不到返回空数组
+ getElementsByClassName("cname")，返回拥有这些class的对应标签元素的对象数组，其中cname可以指定多个class（且），class之间用空格分隔，顺序不重要，找不到返回空数组
不一定完全支持，需用`if (node.getElementsByClassName)`进行测试
+ getAttribute("aname")，该元素节点对象不能是document，如果没有，则返回null
+ setAttribute("aname", "value")，该元素节点对象不能是document，无则添加，有则修改（该改动不会影响浏览器查看源码的显示）
+ appendChild(node)，追加子节点
+ insertBefore(node, child)，在指定子节点child前插入新节点

### 事件
#### 在HTML中注册事件（不推荐）
```
<tag onevent="js codes">
```
其中 js codes 中可以使用 event 这个事件对象，和 this表示当前的元素对象node

#### 通过js代码绑定事件
```
node.onevent = function(evt) { js codes }
```
事件回调函数的第一个参数就是事件对象
（在兼容IE8-的浏览器中，js codes中也可以使用 window.event 这个事件对象）
该函数被认为是node的方法，可以使用函数中可以使用this引用node
可以通过重新赋值改变绑定事件，或赋值为null删除事件

#### DOM方法
```
node.addEventListener(event, listener, useCapture=false)
```
event是事件名字符串（不带on）
listener是回调函数（接收第一个参数是event对象），同样被视为node的方法，可以使用函数中可以使用this引用node
useCapture，默认false表示在冒泡阶段触发，true表示在捕获阶段触发
此外，还可以给一个事件添加多个listener，他们按照添加的顺序触发。（如果三个参数都相同就只保留一个，匿名函数不行）
移除listener使用node.removeEventListener方法，参数和添加时相同（意味着使用匿名函数添加的listener将无法删除）
*注：IE8-不支持该方法*

其中[onevent](http://www.w3school.com.cn/jsref/dom_obj_event.asp)常用的包括：
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


#### DOM事件流
在DOM Level 2 Events中，事件流包括三阶段：捕获阶段，目标阶段、冒泡阶段
捕获阶段是从document结点到目标元素，触发各个元素绑定在捕获阶段的listener；
冒泡阶段是从目标元素到document，触发各个元素绑定在冒泡阶段的listener；
*注：IE8-不支持捕获阶段*

#### 事件属性
全是只读
type：返回事件名称（字符串）
target：返回事件触发的目标元素
currentTarget：返回事件流过程中的当前处理事件结点
eventPhase：返回事件流中的当前阶段（`Event.CAPTURING_PHASE` 1，`Event.AT_TARGET` 2，`Event.BUBBLING_PHASE` 3）
timeStamp：事件发生的事件戳（从 epoch 开始的毫秒数，也可能从客户机启动的时间开始）（不保证可用）
cancelable：指示preventDefault方法是否可用
relatedTarget：与事件目标节点相关的节点（例如鼠标离开事件的鼠标进入节点，focus事件的失去焦点节点等），如果没有则为null或undefined

##### 键鼠事件对象属性
key：键盘按键的字符串
which / keyCode：键盘按键的Unicode值
altKey
ctrlKey
metaKey
shiftKey：当事件触发时，对应的键是否按下
button：当事件触发时，那个鼠标按键被点击
clientX
clientY：当事件触发时，鼠标指针相对于浏览器页面当前窗口的坐标
screenX
screenY：当事件触发时，鼠标指针相对于屏幕的坐标

#### 事件方法
preventDefault()：不执行与事件关联的默认动作（在兼容IE的浏览器中，事件绑定的 js codes 最后如果`return false`，有同样效果）
stopPropagation()：终止事件在传播过程的捕获、目标处理或起泡阶段进一步传播。调用该方法后，该节点上处理该事件的处理程序将被调用，事件不再被分派到其他节点。
stopImmediatePropagation()：阻止剩余的事件处理函数的执行（但依然会执行事件关联的默认动作），并防止当前事件在DOM树上冒泡。

> 平稳退化
如果拦截了标签的默认事件，比如a 标签，此时href 属性就没什么用处了，当然可以指定为"#"（内部空链接），不过基于平稳退化的考虑，还是将其指定为一个有效的URL，来确保即使 js 代码无效时也可以响应用户。


## window
对应浏览器窗口本身
### 方法
+ open(url, name, features)
    url: 新窗口打开页面的url，如果缺省则为空白页
    name: 新窗口的名字，可以在代码中通过该名字与新窗口进行通信
    features: 新窗口的各种属性（字符串，属性间用逗号分隔），例如`"width=320,height=480"`

## window.document
网页内容（只有当window加载完成后，该对象才是有效的）
### 方法
+ getElementById("id")，返回对应元素的对象，找不到返回null
+ createElement("name")，创建一个元素结点
+ createTextNode("text")，创建一个文本结点
+ `write("<h1>This is a heading</h1>");`，在页面加载过程中调用，可以插入内容，如果在页面加载完成后调用会覆盖整个文档。

## window.location
### 属性
+ href：取得当前地址栏中的完整URL，可以通过赋值改变当前地址栏中的URL；
+ protocol：取得当前URL的协议部分，比如http:，https:等，可以通过赋值改变URL的协议部分；
+ host：取得当前URL中的主机信息，包括端口号，可以通过赋值改变主机信息；
+ hostname：取得当前URL中的域名部分，不包括端口号，可以通过赋值改变域名；
+ port：取得当前URL中的端口号，可以通过赋值改变端口号；
+ origin: protocol+host，该属性只读
+ pathname：取得当前URL中的路径信息，即域名与参数之间的部分（包括开头的/），可以通过赋值改变当前URL的路径；
+ search：取得当前URL的参数部分，即“?”后面的部分（包括问号），可以通过赋值改变URL的参数部分；
+ hash：取得当前URL中包含的锚记，即“#”后面的部分（包括#），可以通过赋值改变URL的锚记部分;


### 方法
+ assign(url)：加载传入的URL，该方法不会覆盖之前的历史记录；
+ replace(url)：加载传入的URL，该方法是用传入的URL字符串替代当前的URL，并且会将历史记录中的URL一并替换掉，也就是说，无法通过后退回到原URL；
+ reload()：重新加载当前URL，相当于刷新；
+ toString()：返回URL 字符串，跟href 一样

## window.history
包含用户（在浏览器窗口中）访问过的 URL
当访问一个页面时，将该页面插入到history的当前位置

### 属性
length : 返回浏览器历史列表中的 URL 数量

### 方法
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

### 事件
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

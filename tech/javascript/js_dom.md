# JavaScript
[TOC]

## 历史概念
ECMAScript 是这个脚本语言的标准，而JavaScript 是一种实现（其他实现还有JScript 和ActionScript）
Babel 转码器可以将ES6 的代码转为ES5 的代码。配置文件是.babelrc，然后就可以使用babel-cli 工具进行转码、替代node直接执行、require自动转码、或者直接调用其API。
Traceur 是Google 的转码器，自动识别标记type=module 的代码进行转码
ESLint 用于静态代码检查语法和风格。配置文件是.eslintrc
Mocha 是一个测试框架

## 语言特性

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
`prompt(msg)`: 弹出式输入框，返回用户输入的字符串
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
声明的变量是限定作用域的（函数级，若是在全局域声明，则具有DontDelete，即不能被delete），而未声明的变量（以及函数）是全局的（从属于一个全局对象，被称为顶层对象，也就是全局的this，比如浏览器的window,Node的global，顶层对象的属性可以被delete）
标识符名除了一般的标识符规则外，还可以包含 $ 字符（一般用于DOM elements）
JavaScript是一种弱类型语言，声明并不确定类型，类型由赋值时确定

var 的声明是原有的声明方式，拥有函数级作用域（不带任何标识是全局作用域），它有几个问题：
1. 声明之前就可以使用该变量，但值是undefined（用到的是声明提升的特性，即var 声明会提升到函数体首）
2. 对于同一个名字，可以多次声明，离使用位置最近的一处生效
3. for 循环中var 声明的变量实际会被提升到函数首，所以在该语句块结束后，在函数中依然可以使用
4. 若在全局作用域使用var 声明，则将成为顶层对象的属性
let 声明是块作用域，不会声明提升
1. 声明前使用会报错ReferenceError
2. 块内不允许重复声明同一名字，否则报错。块内声明前是暂时性死区（temporal dead zone），即使有同名的全局变量也不能使用。
3. 即使在在全局作用域声明，也不会成为顶层对象的属性
const 也是块作用域，而且名字和对象会绑定，不允许改绑（也就是说对象的属性和成员可以变动，想要完全不可变，需要使用`Object.freeze(obj)`）

```js
for (let i=0; i<5; i++) {
    setTimeout(() => {
        console.log(i)  // i 只对当前迭代有效
    }, 0);
}
// 如果不支持ES6 就只能使用立即执行的匿名函数（IIFE）：
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
+ 数值（Number）包括整数、浮点（支持e的科学计数法），表示范围-(2^53 - 1) 到 (2^53 -1) ，超出范围自动转为特殊值，特殊值Infinity、-Infinity 和 NaN（0/0）
+ 布尔（Boolean）只有true、false
+ 字符串（String）单双引号均可，允许使用'\uxxxx' 表示一个字符(Unicode码点)
+ Symbol: ES6 引入的一种类型，表示独一无二的值。使用Symbol(str)/Symbol.for(str)创建，会到全局符号表查询，没有则插入。反向可以用Symbol.keyFor(sym) 获得对应的str
+ 数组（Array）例如`['a', 'b']`
+ 对象（Object）例如`{color: 'red', shape: 'Rectangle'}`
+ 映射（Map）key 可以是任意值，能保持插入顺序，例如new Map()
+ 空，只有null
+ 未定义，未赋值的变量，undefined
+ 函数（Function）

#### 类型测试
`typeof a` 测试变量a的类型，返回一个字符串表示的类型名（number、boolean、string、undefined、function、object），但对于null，Array和Object返回的名都是object

`null`是个单例对象，可以用===进行比较

判断数组的方法有三种：
```js
// 1. 最稳定
Object.prototype.toString.apply(arr) == '[object Array]'
Object.prototype.toString.call(arr) == '[object Array]'
// 2. 跨页面传递的数组会判断失败
arr.constructor == Array
// 3. 跨页面传递的数组会判断失败
arr instanceof Array
```

#### 布尔测试
数值 0，空串，undefined，null进行布尔判断时都是false

### 数值方法
Number(str): 将字符串转换为数值返回

### 模板字符串
使用反引号，支持多行字符串，可以内嵌`${expression}`

#### 标签模板
若将模板字符串传给一个函数，则函数括号可以省略，即
```js
function tag(strArr, ...args) { return }
tag`before${name}\n and ${after} end` // strArr is ['before', '\n and ', ' end', raw=Array(...)], args is [name, after]
```
其中strArr.raw 就是['before', '\\n and ', ' end']，跟strArr 本身的差别就是raw 会忽略转义符

### 字符串方法
<https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String>
length 长度属性
`+` 字符串连接（字符串可以连接数字，会将数字自动转为字符串）
indexOf(substr) 查找指定字符串位置，-1表示找不到
split(separator, limit) 按指定字符（支持正则或一个包含 Symbol.split 方法的对象）进行分割成至多limit项。省略 separator 或传递 undefined 会导致 split() 返回一个只包含所调用字符串数组
replace(src, target)
slice(begIdx, endIdx) 字符串切片，第二个参数可以缺省。支持负值索引，表示从倒数第几个字符
toLowerCase()
toUpperCase()

### 数组
```js
var arr1 = Array();
var arr2 = Array(4);             //指定初始化大小
var arr3 = Array('a', 2, false, arr2);
var arr4 = ['a', 2, false, arr2];      //上面的简写形式
```
下标从0 开始，数组的长度通过其 length 属性获取
支持混合类型，支持嵌套

#### 关联数组
```js
var arr = Array();
arr["a"] = "aaa";
```
Array也是对象，这里是给这个对象添加了一个属性
不推荐，推荐使用对象

#### 方法
push(...items): 数组尾添加元素，返回添加后的数组长度
pop(): 删除最后一个元素
unshift(...items): 数组头添加元素，返回添加后的数组长度
shift(): 删除第一个元素
join(separator=',')：将数组每个成员（转换为字符串）通过separator连接起来，返回连接的字符串。
(arr): 把两个数组连在一起返回
some()
every()
filter()
forEach(func)
map(func, )
reduce((a, b) => a + b)
<http://www.w3school.com.cn/jsref/jsref_obj_array.asp>
<http://www.runoob.com/jsref/jsref-obj-array.html>
<https://developer.mozilla.org/zh-CN/docs/Web/JconcatavaScript/Reference/Global_Objects/Array>

#### 数组函数
Array.isArray(arr)

#### 修改行为
`arr[Symbol.isConcatSpreadable] = false` 会使得arr 在执行或被执行concat 时作为一个整体被合成，而不是元组连接

### 对象
JavaScript 的对象可以不依赖于类直接创建，所以他的创建方式有：
1. 直接创建Object 对象
2. 大括号式
3. 从一个原型创建
4. 构造函数创建，即使用new 调用函数
5. 基于class 的constructor 创建，实际上是特殊的函数，但差别是函数声明会提升，而类声明不会（声明后才能使用）
```js
// 1.
var obj = Object();
obj.a = 'aaa';  // 点式访问
obj.b = 323;
obj.c = false;
obj['d'] = 1    // 索引访问，类似关联数组，跟点式访问完全互通
obj[Symbol('abc')] = 10
// 2.
var obj0 = {
    a: 'a',
    b: 10,
    c: ['abc', 'def'],
    d: function() { return this.b; },
    e(){},  // ES6 getter or setter 的写法
}
obj00 = {obj, obj0}     // 相当于obj00 = {obj:obj, obj0:obj0}，即以变量名作为key
// 3.
const obj1 = Object.create(obj0)
// 4.
function Person(name) {
    this.name = name
}
var p = new Person('hhh');
// p.__proto__ === Person.prototype
// Person.prototype.constructor === Person
p.age       // 访问成员
Object.assign(Person.prototype, personPrototype);   // 将personPrototype 原型对象定义的所有属性和方法，都复制给Person.prototype
Object.setPrototypeOf(Person.prototype, personPrototype)  // 直接修改Person 的原型，修改原型的性能很差，并且对于某些内置对象而言不可修改原型
Person.prototype.method = function () {}    // 实例的单方法
Preson.s_method = function () {}    // 类静态方法
// 5.
class Person {      // 也可以写作let Person = class {
    // 给属性提供默认值
    name = '';
    // 私有属性 # 开头，私有属性不可被delete，而且必须先声明才能用this等引用之
    #age;
    // 静态也可以是私有的，不过就只能被静态方法访问，而且最好不要使用this，因为静态方法的this是调用类，而不一定是私有属性的所属类
    static s_field = '';
    // JavaScript引擎会自动为它添加一个空的constructor方法，即:
    // constructor() {}     // 只能有一个
    static {}   // 支持静态初始化块，所有静态域按序执行，所以这里可以访问已经初始化的s_field
    method() {}
    get prop() { return this.#p_method() }
    // 私有的方法 # 开头
    #p_method() {}
    static s_method() { }   // 静态方法的this 就是这个类（在继承结构中，则是调用类），静态方法也可以是私有的，但子类无法调用（子类只能调用公开的静态方法）
}
let p = new Person()    // 必须使用new 才能调用constructor
p.constructor === Person  // 实例的constructor 就是这个类
p.constructor.s_method()

// for-in 遍历会忽略Symbol key
for (const property in obj2) {
    console.log(`${property}: ${object[property]}`)
}
```
property和变量的命名规则相同，value可以是任何类型

Object 无法直接for-of遍历，需要Object.keys(o)/Object.values(o)/Object.entries(o) 转为一个可迭代实例
但Object 可以使用for-in 遍历property，该遍历会延原型链由近及远的遍历所有继承的属性

静态属性和方法，只能使用类访问，不能用实例访问（不过可以通过ins.constructor进行访问）

不能把方法复制给一个变量，因为会调用时会丢失this：
```js
let f = obj.method
f() // 会丢失this，此时this 将成为undefined 或者global object(顶层对象)
```

#### 原型链
每个对象都有一个原型，类似于类的继承链，对象有原型链，终止于null（`Object.prototype.__proto__` === null，即没有原型）
对象有一个`__proto__` 的属性（浏览器标准，更一般的获取方法是Object.getPrototypeOf()），默认是Object.prototype，也可以指定一个对象作为其原型

当访问对象属性或方法时，会从当前对象延原型链搜索，搜不到最终返回undefined
因此，其设计思路更像是设计模式中的责任链

##### 继承的方法
prop in obj: 检查obj 是否有prop 的属性，无论该属性是否是继承得到的。Array 支持数字索引、Symbol.iterator等。不支持检查私有属性
hasOwnProperty(prop): 从Object.prototype 继承而来的方法，判断指定字段prop（数字、字符串或Symbol）是否是对象的自有字段（无论该字段值是null还是undefined都算），而不是继承得到的或者不存在的字段。但该方法也可能被重写，所以推荐使用**Object.hasOwn(obj, prop)**替代之。
toString(): 从Object.prototype 继承而来的方法，转换为字符串形式。若是 number 类型转换，可以指定一个进制值，表示数字转换为多少进制的字符串

#### 构造函数
`new C()`中new 运算符的作用：
1. 调用C() 函数，初始化 this = {}
2. 然后将函数的prototype 赋给this，即`this.__proto__ = C.prototype`
3. 执行其他初始化工作（也就是函数体），最后返回this（自动，无需return）
这里C() 可以是任意函数，无论该函数是否有return语句，如果被new 调用，都会忽略

函数的prototype 就是它用来构造实例的原型

#### 行为修改
##### Symbol.match/replace/search/split
支持正则函数
```js
var a = {
    [Symbol.match](){
        return true;
    }
}
 
"hello".match(a);  //true
```

##### Symbol.iterator
支持for-of 迭代
```js
var a = {
    name: "夕山雨",
    age: 24,
    [Symbol.iterator]: function* (){
        yield this.name;
        yield this.age;
    }
}
```

##### Symbol.toPrimitive
如何转换为基本类型（在与基本类型进行运算时自动转换）
```js
let obj = {
  [Symbol.toPrimitive](hint) {
    switch (hint) {
      case 'number':
        return 123;
      case 'string':
        return 'str';
      case 'default':   // 没有要转换的类型
        return 'default';
      default:
        throw new Error();
     }
   }
};
 
2 * obj // 246
3 + obj // '3default'
obj == 'default' // true
String(obj) // 'str'
```

##### Symbol.toStringTag
通常对象的toString方法会返回一个类似[object Object]的字符串，该方法可以修改具体的类型名Tag
```js
a[Symbol.toStringTag] = function(){
  return "xxx";
}
a.toString(); //"[object xxx]"
```

##### Symbol.unscopables
用于with，默认该语句块可以引用对象的所有字段（找不到再引用外部的），该方法可以指定一个对象属性白名单（这些属性直接查找外部的）
```js
var author = {
    name: "夕山雨",
    age: 24,
    stature: "179",
    weight: 65,
    get [Symbol.unscopables](){
      return { name: true, age: true }
    }
}
 
var name = "张三";
var age = "28";
var stature = "153";
var weight = 80;
 
with(author){
  console.log(name);  //“张三”
  console.log(age);   //28
  console.log(stature);  //"179"
  console.log(weight);   //65
}
```

#### 类的继承
只支持单继承
```js
// Peaple 可以是class 声明的，也可以是function 声明的构造函数
class Student extends People{
    sub_f = super.base_method();

    constructor(sex,age) {
        super(sex, age);    // 必须先调用了父类的构造函数
        // 注意: 在派生类中, 必须先调用 super() 才能使用 "this"。
        // 忽略这个，将会导致一个引用错误。
        this.name = 'xiao hua';
        this._info = this.name+' ' + this.sex+' ' + this.age;
    }
    get info() {
        return this._info;
    }
    set info(value) {
        // 注意：不可使用 this.info= value
        // 否则会导致循环call setter方法导致爆栈
        this._info = value;
    }
};
```
通过typeof Student 可以看到，是一个function，所以他也有prototype 属性
extends 本质上还是原型链

##### Mixins
可以通过嵌套匿名类的方式实现
```js
var calculatorMixin = (Base) =>
  class extends Base {
    calc() {}
  };

var randomizerMixin = (Base) =>
  class extends Base {
    randomize() {}
  };

class Foo {}
class Bar extends calculatorMixin(randomizerMixin(Foo)) {}
```
通过调用链形成了继承链：Bar -> calculateMixin(匿名) -> randomizerMixin(匿名) -> Foo

##### 继承内置对象
```js
class MyArray extends Array {
  // 重载这个方法是用于.map, .filter 等方法返回的构造函数使用哪个
  // 默认使用当前类构造函数（也就是返回this），这里指定为Array，即返回的是Array 的实例
  // 也可以返回null，则将使用默认的数组构造，也就是Array
  // 该属性只有getter
  static get [Symbol.species]() {
    return Array;
  }
  // 用于[] instanceof MyArray 判定
  static [Symbol.hasInstance](ins) {
    return Array.isArray(ins);
  }
}
```

### 内建对象

#### Math
Math.PI
Math.sqrt(num)
Math.random(): 返回 0 到 1 之间的随机数
Math.floor(num)

#### Date
Date.now(): 当前时间的时间戳，单位是毫秒的一个整数

#### Error
`throw new Error(msg)`

#### XMLHttpRequest
HTTP 请求

##### 属性和方法
open("GET", requestURL)
responseType = "json"
send(): 发送请求
onload = function () {request.response;}    处理response
onerror = () => {request.statusText}

#### JSON
JSON.parse(text) 转为js obj
JSON.stringify(js_obj) 转为string

#### URL
URL.createObjectURL(blob)

### 宿主对象
由运行环境（如浏览器）提供的预定义对象（例如Form、Image、Element、document）

### Map
```js
const map1 = new Map();
for (const t of map1) {
    console.log(t)  // t is [key, val]
}
let iterable = new Map([["a", 1], ["b", 2], ["c", 3]]);
for (let [key, value] of iterable) {
  console.log(value);
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
+ 位运算：`<<`、`>>`、`>>>`(无符号右移)、&、|、^(xor)、`~`(位非)
+ 三目：?:

注意：
1. 不要在条件判断中使用赋值的 `=`, 只要赋值成功就是true
1. || 运算当左操作数的布尔判断为true，就返回左操作数；否则返回右操作数
    && 运算当左操作数的布尔判断为false，就返回左操作数；否则返回右操作数

### 解包赋值
```js
const foo = ['one', 'two', 'three'];
const big = ['four', 'five', ...foo]    // 解包扩展，扩展不限定是最后一个

const [one, two, three] = foo;  // 即使嵌套数组也可以
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

### do 语句块（提案中）
```js
let x = do {
  let t = f();
  t * t + 1;
}
```
常规的语句块没有返回值，而do 语句块可以相当于一个表达式，可以获得语句块中最后一个表达式的值

## 控制语句
同C
if-else、switch-case-default、while、do {} while、for

### for-in
for (const prop in obj) {}
for-in 只用于遍历Object

### for of
ES6 新增支持可迭代协议的对象的遍历，内置的对象包括String, Array, array-like objects (例如 arguments、NodeList), TypedArray, Map, Set
```js
for (const element of array1) {
  console.log(element);
}
```

## 函数
```js
function func_name(args) {
    //block
    return ret;
}

// 匿名函数，不绑定this、arguments，不能作为构造函数和生成器函数，也没有prototype属性
// 所以statements 中如果引用this、arguments，是外部变量
// 如果需要不定参数，可以使用 ...args
(args) => { statements }
// 若只有一个return 语句时
(args) => expression    // 相当于{ return expression }
// 若只有一个参数，可以省略小括号
```
函数声明会提升，所以可以后声明先使用（在ES6 中，函数声明相当于let 语句，具有块作用域，但依然会提升到所在块的头部，所以行为类似var语句）
多个参数使用逗号分隔，在调用时不必给出全部参数，也可以给超出参数列表个数的参数，没有给出的参数将是undefined，超出部分可以使用arguments获取
函数参数在ES6中默认是使用let 声明的局部变量。支持默认参数值
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

### 生成器
`function*` 定义一个生成器函数，生成器函数返回一个GeneratorFunction 实例
```js
function* generator(i) {
  yield i;
  yield i + 10;
}
```
yield是ES6的新关键字，yield* 则是转发给另一个生成器
调用GeneratorFunction 实例的next() 方法，都会执行到yield 处停止，返回一个对象{value: xx, done: false}，当done==true时，表示生成器函数结束，此时value为return的值，默认为undefined。
next()方法可以带一个参数，这个参数就是yield 语句的返回值
对于已经结束的生成器函数，再次next 会得到{value: undefined, done: true}

生成器函数不能作为构造器函数

### 内置函数
setInterval(func, interval)
setTimeout(func, t): 延迟t 毫秒后调用func

## 异步
最早的异步是基于回调函数实现的，但深度的回调嵌套会陷入回调地狱，从而现代一般使用 Promise
Promise 的状态分为三种：Fulfilled、Rejected、Pending。分别表示正确返回、异常返回、未返回。

### 生成Promise 的API
#### 构造
+ new Promise((resolve, reject) => {resolve("成功！"); // 或reject("错误!");
}): 作为参数的这个函数是在创建Promise时立即执行（同步调用）。resolve 和 reject 只调用一个即可（异步调用），因为只有第一个被调用的参数会被注册为Promise的状态以及对应的result或reason，若两个都没调用，则状态是Pending。这两个函数result或reason都可以使用一个Promise 作为参数，则其result或reason就是这个Promise 的result或reason。返回值会被忽略，若在调用resolve/reject之前抛异常，则返回一个拒绝的Promise，否则则该异常不会影响返回的Promise状态。
+ Promise.resolve(res): 以res 为result 构造一个Promise；res 也可以是一个thenable 对象（即有then(onFulfilled, onRejected)方法的对象），则直接下发res
+ Promise.reject(msg): 以msg 构造一个`throw new Error(msg)`的Promise（永远是新构造的，不会重用msg）
+ Promise.all(promises): Promise 可迭代对象作为参数，返回一个Promise。当所有都被兑现时，结果被兑现，res 是一个所有Promise对象的res 的数组。若有一个被拒绝，则立即返回被拒绝的Promise
+ Promise.allSettled(promises): 跟all 很像，差别是即使有拒绝，allSettled也会等到所有入参都已经结束才会返回
+ Promise.any(promises): 当第一个Promise 兑现时，就返回对应兑现的返回。当所有都被拒绝（包括空的promises），则返回一个拒绝原因数组的AggregateError的拒绝Promise
+ Promise.race(promises): 当第一个Promise 敲定时（兑现或拒绝），就返回对应的返回。如果promises 为空，返回的 promise 就会一直保持待定状态

*JavaScript 的本质上是单线程的，因此在任何时刻，只有一个任务会被执行，尽管控制权可以在不同的 Promise 之间切换，从而使 Promise 的执行看起来是并发的。在 JavaScript 中，并行执行只能通过 worker 线程实现*

#### req-resp
fetch(input[, init]): input 可以是URL字符串或者Request 对象；init 是一个配置对象，可以包含以下字段
+ method: GET、POST
+ headers: 可以是字面值对象或Headers 对象，可以使用get(key)获取指定的值
+ body: 
+ mode: 如 cors、no-cors 或者 same-origin
+ credentials: 如 omit、same-origin 或者 include。为了在当前域名内自动发送 cookie，必须提供这个选项
+ cache: default、 no-store、 reload 、 no-cache、 force-cache 或者 only-if-cached
+ redirect: follow (自动重定向), error (如果产生重定向将自动终止并且抛出一个错误），或者 manual (手动处理重定向)。在 Chrome 中默认使用 follow
+ referrer: 可以是 no-referrer、client 或一个 URL。默认是 client
+ referrerPolicy: 可能为以下值之一：no-referrer、 no-referrer-when-downgrade、origin、origin-when-cross-origin、 unsafe-url
该方法返回一个Response 作为result 的Promise
##### Response
+ headers: 关联的 Headers 对象
+ ok: HTTP 状态码的范围在 200-299
+ redirected: 是否来自一个重定向，如果是的话，它的 URL 列表将会有多个条目
+ status: 状态码
+ statusText: 状态码一致的状态信息
+ type: 类型（例如，basic、cors）
+ url
+ body: 一个简单的 getter，用于暴露一个 ReadableStream 类型的 body 内容
+ bodyUsed: 标示该 Response 是否读取过

###### 方法
+ clone()
+ error(): 返回一个绑定了网络错误的新的 Response 对象
+ redirect(): 用另一个 URL 创建一个新的 Response
以下为读取内容（stream 的方式，所以它们只能被读取一次），格式不同：
+ arrayBuffer(): 解析为 ArrayBuffer 格式的 Promise 对象
+ blob(): 解析为 Blob 格式的 Promise 对象
+ formData(): 解析为 FormData 格式的 Promise 对象
+ json(): 解析为 JSON 格式的 Promise 对象
+ text(): 解析为 USVString 格式的 Promise 对象

### Promise 的方法
+ then((res) => {}, [(reason) => {}]): res 是Promise 收到的Result，函数里可以return 一个Promise 可以进行链式调用；若没有return，默认返回一个result === undefined 的Promise（如果返回的不是Promise，则以其为res生成一个Promise 返回）。该方法并不意味着立即等待回调函数的调用，而是将回调函数注册上，时机达成时则会调用（若Promise兑现则调用前者，若拒绝时调用后者，若尚为Pending，则注册完后继续下发这个Pending的Promise）。若参数不是函数，将被忽略直接透传。
+ catch((reason) => {}): reason 可能是链路上throw 的Error；也可能是前面reject的reason。若没有显式返回，则返回一个总是待定的Promise；否则使用显式返回作为返回Promise的兑现或拒绝值。
+ finally(() => {}): 注册一个在 promise 敲定（兑现或拒绝）时调用的函数。除非返回一个拒绝的Promise，否则返回值将被忽略，原来的Promise 将被透传下去。

若Promise 被拒绝，但并未使用上面三个方法处理，则将触发rejectionhandled 事件

### async 和 await
在一个函数的开头添加 async，就可以使其成为一个异步函数。该函数必须返回一个Promise，如果不是，会被自动包装为Promise，即使没有返回也会包装undefined。
在异步函数中，你可以在调用一个返回 Promise 的函数之前使用 await 关键字。这使得代码在该点上等待（让出控制权），直到 Promise 被完成，这时 Promise 的result被当作返回值，或者被拒绝的reason被作为错误抛出。
如果await 后面没有跟一个返回Promise 的函数，则会自动根据该值包装成一个Promise。

```js
async function func_name() {}
async () => {
    try {
        const res = await p()   // promise 拒绝会抛异常
    } catch (err) {}
}
```

### workers
Workers 给了你在不同线程中运行某些任务的能力。
为了避免数据race，你的主代码和你的 worker 代码永远不能直接访问彼此的变量。Workers 和主代码运行在完全分离的环境中，只有通过相互发送消息来进行交互。这意味着 workers 不能访问 DOM（窗口、文档、页面元素等等）。
有三种不同类型的 workers：
+ dedicated workers（下面例子）
+ shared workers 可以由运行在不同窗口中的多个不同脚本共享
+ service workers 行为就像代理服务器，缓存资源以便于 web 应用程序可以在用户离线时工作。他们是渐进式 Web 应用的关键组件

main.js:
```js
// 生成worker 会立即执行该脚本，该脚本需要做好接收任务，回发结果的准备
const worker = new Worker("./generate.js");
// 向worker 下发任务
worker.postMessage({
    command: "generate",
    quota: 10,
});
// 接收worker 完成消息
worker.addEventListener("message", (message) => {
  document.querySelector(
    "#output",
  ).textContent = `Finished generating ${message.data} primes!`;
});
```
Worker(url, opts): url 是脚本地址，必须遵守同源策略（不能跨域，MIME 类型必须是 text/javascript）；opts 是可选的设置：
+ type: 可以是 classic（默认） 或 module
+ credentials: 可以是omit（默认）, same-origin，或 include
postMessage(message, transfer): 传的message 对象会放到data 中，若不重要，可以传null；transfer是可转移对象数组，用于共享资源防冲突，比如ArrayBuffer、MessagePort 或 ImageBitmap 类的实例

generate.js:
```js
// 注册接收任务
addEventListener("message", (message) => {
  if (message.data.command === "generate") {
    do_somethings(message.data.quota);
  }
});

function do_somethings(quota) {
    // 完成后回发消息
    postMessage(quota)
}
```

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
+ textContent，元素文本内容
+ classList，元素的所有class

### 方法
+ querySelector(css_selector): 可以基于一个css选择器找第一个匹配元素
+ querySelectorAll(css_selector): 基于一个css选择器找所有匹配元素
+ getElementsByTagName("name")，返回对应标签元素的对象数组（有属性length可以获知长度），其中name支持 * 通配符，找不到返回空数组
+ getElementsByClassName("cname")，返回拥有这些class的对应标签元素的对象数组，其中cname可以指定多个class（且），class之间用空格分隔，顺序不重要，找不到返回空数组
不一定完全支持，需用`if (node.getElementsByClassName)`进行测试
+ getAttribute("aname")，该元素节点对象不能是document，如果没有，则返回null
+ setAttribute("aname", "value")，该元素节点对象不能是document，无则添加，有则修改（该改动不会影响浏览器查看源码的显示）
+ append(node_or_domstring)，追加子节点（由于可以是字符串，所以可以追加多个对象），无返回
+ appendChild(node)，追加子节点，返回追加的对象
+ insertBefore(node, child)，在指定子节点child前插入新节点
+ insertAdjacentHTML(position, text): position有4种（beforebegin、afterbegin、beforeend、afterend，对应当前元素之前、内部最前、内部最后、当前元素之后），text是html 文本会被解析。由于不用重新解析现有元素，所以比直接操作innerHTML快。
+ insertAdjacentElement(position, ele): 同上，ele 是Element对象

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
可以通过重新赋值改变绑定事件，或赋值为null删除事件（不能一个事件上绑定多个处理函数）

#### DOM方法
```
node.addEventListener(event, listener, useCapture=false)
```
event是事件名字符串（不带on）
listener是回调函数（接收第一个参数是event对象），同样被视为node的方法，可以使用函数中可以使用this引用node
useCapture，默认false表示在冒泡阶段触发，true表示在捕获阶段触发。这个参数现在变成一个对象`{capture: true}`
此外，还可以给一个事件添加多个listener，他们按照添加的顺序触发。（如果三个参数都相同就只保留一个，匿名函数不行）
移除listener使用node.removeEventListener方法，参数和添加时相同（意味着使用匿名函数添加的listener无法使用该方法无法删除）
*注：IE8-不支持该方法*

另一个移除监听器的方法是通过AbortController：
```js
const controller = new AbortController();
btn.addEventListener("click",
  () => {
    const rndCol = `rgb(${random(255)}, ${random(255)}, ${random(255)})`;
    document.body.style.backgroundColor = rndCol;
  },
  { signal: controller.signal } // 向该处理器传递 AbortSignal
);
controller.abort(); // 移除任何/所有与该控制器相关的事件处理器
```

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
stopPropagation()：终止事件在传播过程的捕获、目标处理或冒泡阶段进一步传播。调用该方法后，该节点上处理该事件的处理程序将被调用，事件不再被分派到其他节点。
stopImmediatePropagation()：阻止剩余的事件处理函数的执行（但依然会执行事件关联的默认动作），并防止当前事件在DOM树上冒泡。

> 平稳退化
如果拦截了标签的默认事件，比如a 标签，此时href 属性就没什么用处了，当然可以指定为"#"（内部空链接），不过基于平稳退化的考虑，还是将其指定为一个有效的URL，来确保即使 js 代码无效时也可以响应用户。


## window
对应浏览器窗口本身
### 只读属性
innerWidth: 以像素为单位的窗口的内部宽度。如果垂直滚动条存在，则这个属性将包括它的宽度。
innerHeight: 浏览器窗口的视口（viewport）高度（以像素为单位）；如果有水平滚动条，也包括滚动条高度。

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

# Node
node 环境的顶层变量是global，可以使用全局的this 获取。但
+ 模块的this 返回的是当前模块
+ 函数的this 在非严格模式是global，在严格模式是undefined。作为方法，则是这个对象
+ `new Function('return this')()` 总是返回顶层对象
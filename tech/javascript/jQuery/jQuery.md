# jQuery
[TOC]

## 特性
+ HTML 元素选取
+ HTML 元素操作
+ CSS 操作
+ HTML 事件函数
+ JavaScript 特效和动画
+ HTML DOM 遍历和修改
+ AJAX
+ Utilities

## 使用
### 基础语法
`$(selector).action()`
美元符号定义为jQuery: 指定查询范围
选择符（selector）查找HTML 元素: 指定查询目标（通常是一组对象）
jQuery 的 action() 执行对元素的操作: 指定遍历行为

### jQuery的选择器
内置对象：`$(this)    $(document)    $(window)`
基于标签：`$("p")` ，特别的`$('*')`表示所有元素
基于id：`$("#test")`
基于class：`$(".test")`
基于属性：`$("[href]")    $("[href='#']")    $("[href!='#']")    $("[href$='.jpg']")`
基于条件：`$(':first')    $(':last')`
可以连接使用，表示"且"的关系；用逗号连接，表示"或"的关系（并）；用空格分隔，表示对后代标签进行筛选
<http://www.w3school.com.cn/jquery/jquery_ref_selectors.asp>
#### js与jQuery、Prototype等库的对比
在Prototype，`$('#id')`等于document.getElementById('id')，即DOM对象。
但在jQuery中，`$('#id')`获取的却是jQuery对象，而不是DOM对象。
所以，在Prototype中可以直接使用`$('#id').JS内置方法()`
但jQuery只能`$('#id').jQuery方法()`
jQuery这样做的好处是，使用jQuery方法后返回的仍然是jQuery对象，所以可以形成一个调用链，如`$('#id').css(...).hide().show();`

### jQuery里的绑定事件
<http://www.w3school.com.cn/jquery/jquery_ref_events.asp>
`bind(events, [data,] function)`：适用于所有版本，1.7推荐用on代替，只能对已存在的元素绑定（对应unbind()）
`delegate(childselector, events, [data,] function)`：1.42以上版本，为通过委托指定子元素添加事件（适用于大量子元素需要绑定到统一事件）元素可以是以后加入的（对应undelegate()）
`on(events[, childselector][, data], function)`：1.7版本以后的推荐方式，兼容以上用法。（对应的解绑定：off()）
`on({event1:func1, event2:func2, ...}[, childselector][, data])`：一次绑定多个方法到多个事件上
如需添加只运行一次的事件然后移除，请使用 one() 方法。
其中，
events是可以是一个用空格分隔事件名的字符串，其中事件名支持namespace限定（点分的各个namespace是并列关系，是不同的namespace而不是层次关系），可以在触发事件、移除事件时限定范围；
childselector是选择器，指定触发事件的后代元素（此时function中的this是触发事件的后代元素，如果该参数为null或未指定，则this指当前元素）；
data是传给function的额外数据，可以通过传给回调函数事件对象的data属性获取；
function, func1, func2, ... 是事件的回调函数，其第一个参数是jQuery事件对象。
*注：使用childselector进行委托绑定并不是直接绑定到后代元素之上，而是委托给当前元素，当事件冒泡抵达该元素后判断触发源是否是指定的后代元素，如果是的话就执行对应的回调函数，这对于需要绑定大量元素事件的情形非常有效*

#### 快捷的事件绑定方法
很多事件已经有对应的jQuery方法，比如：
`$(selector).bind("click", function() {});`
可以直接写作：
`$(selector).click(function() {});`
不带function参数则相当于trigger('click');

#### 手动触发方法
trigger(event, [param1, param2, ...])
triggerHandler 同上
其中
event指定触发的事件字符串（可以是标准事件，也可以是自定义事件，还支持namespace限定——没有namespace限定就把该事件所有namespace绑定的回调函数都触发）
例如：
trigger('click')触发`click.*`所有
trigger('click.aaa')触发click.xxx.aaa和click.aaa.xxx
trigger('click.aaa.bbb')触发`click.aaa.bbb.*`等组合
`[param1, param2, ...]` 是传递给事件回调函数的额外参数（从第二次参数开始）
区别：
1. triggerHandler 不会执行浏览器的默认动作，也不产生事件冒泡
1. trigger() 会操作 jQuery 对象匹配的所有元素，而 triggerHandler() 只影响第一个匹配元素
1. triggerHandler 返回的是事件处理函数的返回值，而不是具有可链性的 jQuery 对象。此外，如果没有处理程序被触发，则这个方法返回 undefined。

#### jQuery事件对象
##### 属性
完全兼容js事件对象属性
此外还有：
data：事件绑定时指定的额外数据
delegateTarget：返回被委托的结点，即事件被绑定的结点；如果没有委托，则其值同currentTarget（注：currentTarget是委托结点，即childselector指定的子结点）
namespace：返回触发事件时指定的namespace字符串，如果没有则为空串，多个则用点分
result：如果事件绑定多个回调函数，该属性返回上一个回调函数的返回值，如果没有上一个回调为undefined

##### 方法
完全兼容js事件对象方法
stopPropagation、stopImmediatePropagation这两个函数由于委托事件的存在，只能阻止被委托的祖辈元素之后的事件处理函数执行，而在目标元素和被委托元素之间的元素则无法阻止。
对应js的三个方法，也有三个判断方法：
isDefaultPrevented()：是否调用preventDefault()
isPropagationStopped()
isImmediatePropagationStopped()


### 特效：
hide/show/toggle，显隐
fadeIn/fadeOut/fadeToggle/fadeTo，淡入淡出
slideDown/slideUp/slideToggle，滑入滑出
animate，渐变动画
stop，清除当前动画
每个特效都可以设置动画速度，以及动画完成后的回调函数


### 操作DOM：
#### setter/getter
html()：含标记的内容
text()：文本内容
val()：表单的value
attr('xxx')：表单的xxx属性
上述方法默认为获取，加上一个参数就是设置（该参数可以是字符串或一个回调函数，函数的参数是当前被选元素的下标和原始内容，返回新的内容），attr可以使用{}作为参数，设置多个属性

#### 增
append("content")：插入到被选元素之内的末尾（作为子元素）
prepend("content")：插入到被选元素之内的开头（作为子元素）
after("content")：插入被选元素之后
before("content")：插入被选元素之前

**特别的：**
$("content").appendTo(selector);：作用同append，但返回的是追加内容的jQuery对象，如果该对象使用的不是新内容而是已有元素，那么效果是移动该元素。
类似prependTo()

data()：向元素附加数据和取回附加的数据（数据可以是任意的js 变量）

#### 删
remove()：删除被选元素（可以用一个选择器做参数进行过滤）
empty()：清空被选元素的所有子元素

#### 拷贝
clone(with, deepWith)：克隆当前元素集合的一个副本（jQuery对象）两个参数可选，都是bool，前者表示是否复制元素的附加数据和绑定事件，默认为false；后者表示是否复制所有子元素的附加数据和绑定事件，默认为前者的值
注意克隆的时机，如果此时该元素尚未渲染完全或者事件尚未绑定，那么克隆出来的对象也将是不完全的。

#### 判断
is(selector)：判断是否满足一个选择器


### CSS操作
addClass()：给被选元素增加一个或多个class
removeClass()：给被选元素去除一个或多个class
toggleClass()：有则删，无则增
css()：设置或获取一个css属性，可以使用{}设置多个css属性
******
width()
height()

### 遍历器
parent、parents、parentUntil：向上查找
children、find：向下查找
siblings、next…、prev…：同级查找
first、last、eq、slice：一组元素中按位置定位
filter、not：一组元素按选择器过滤
add：将元素添加到被选元素中
end：在筛选链中，退出最近的一次筛选，将被选元素回到之前的元素
has：根据后代进行一次过滤
******
length属性：选择器中元素的数量
each：为被选的每个元素执行function(index, element)，其中index这些元素的索引（从0起），ele是索引的元素亦即$(this)
map：把每个被选元素传入function执行，返回一组新的jQuery对象（在function中，可以通过this访问当前被选元素）
******

### DOM交互
get(index)：获得jQuery对象指定的DOM元素
size()：获取匹配元素数量（指的是DOM元素）
toArray()：返回DOM元素数组

### Ajax
`load(url [, data] [, callback])`：将Url载入被选元素中
`$.get(url [, data] [, callback] [, type])`：请求Url发送data数据，，成功后执行callback: function(response, status, xhr)（第一个参数包括请求返回的内容，第二个参数返回请求的状态，第三个参数是XMLHttpRequest 对象），type为返回数据类型
`$.post(url [, data] [, callback] [, type])`：同时，方式为POST
```
$.ajax({
    url: '?r=controller/action',    //请求的URL
    //type: "GET",
    //async: true,
    data: {},                       //请求的数据
    dataType: 'json',               //请求返回的数据类型
    //timeout: 60000,               //请求的超时时间
    success: function(res) {},      //成功回调（res为返回的数据，类型根据dataType决定）
    error: function(xhr, err, errType) {},  //错误回调（xhr为XMLHttpRequest 对象，可以通过查询status、statusText和responseText得到返回码和状态信息，err可能包含错误信息名）
    complete: function(xhr, statusStr) {}   //总是执行的回调（在上面两个回调之后执行）
})
```

### Utilities
`$.inArray(value, arr, fromIndex=0)`
判断value是否在数组arr中，如果在返回其索引位置，否则返回-1，fromIndex表示从哪个索引位置开始找
*注*：这里使用的是严格的比较，即`===`

`$.each(iter, func, arg)`
其中iter可以是js的Array和Object：
如果function有参数，可以通过arg(Array)传入，也可以是：
如果iter是Array：index, element
如果iter是Object：name, value
function中可以使用this引用当前的被选元素，可以使用return true达到continue的效果，return false达到break的效果。

`$.extend(recur=false, dest [, src1] [, ...])`
默认将src1, ...的成员合并到dest上，如果key冲突，则后者覆盖前者，最后返回dest的值
如果recur为true，则当key冲突，而value又是一个object，则进行递归合并
如果只有dest，则将dest直接合并到this对象上（即调用extend的对象）

`$.trim(str)`
去除字符串两端的空白符



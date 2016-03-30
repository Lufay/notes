[TOC]

### jQuery 库的特性
+ HTML 元素选取
+ HTML 元素操作
+ CSS 操作
+ HTML 事件函数
+ JavaScript 特效和动画
+ HTML DOM 遍历和修改
+ AJAX
+ Utilities

### 基础语法
`$(selector).action()`
美元符号定义为jQuery: 指定查询范围
选择符（selector）查找HTML 元素: 指定查询目标（通常是一组对象）
jQuery 的 action() 执行对元素的操作: 指定遍历行为

### jQuery的选择器
内置对象：`$(this)    $(document)    $(window)`
基于标签：`$("p")` ，特别的`$('*')`表示所有元素
基于class：`$(".test")`
基于id：`$("#test")`
基于属性：`$("[href]")    $("[href='#']")    $("[href!='#']")    $("[href$='.jpg']")`
基于条件：`$(':first')    $(':last')`
后四种可以连接使用，表示"且"的关系；可以用逗号连接，表示"或"的关系
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
`on(events, [childselector,] [data,] function)`：1.7版本以后的推荐方式，兼容以上用法。（对应的解绑定：off()）
其中，events是可以是一个用空格分隔事件名的字符串；
另外，还可以将{event1:func1, event2:func2, ...}作为参数，一次绑定多个方法到多个事件上
而且，很多事件已经有对应的jQuery方法，比如：
`$(selector).bind("click", function() {});`
可以直接写作：
`$(selector).click(function() {});`

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
append()：插入到被选元素之内的末尾（作为子元素）
prepend()：插入到被选元素之内的开头（作为子元素）
after()：插入被选元素之后
before()：插入被选元素之前

#### 删
remove()：删除被选元素（可以用一个选择器做参数进行过滤）
empty()：清空被选元素的所有子元素

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
`$.each(iter, func, arg)`
其中iter可以是js的Array和Object：
如果function有参数，可以通过arg(Array)传入，也可以是：
如果iter是Array：index, element
如果iter是Object：name, value
function中可以使用this引用当前的被选元素，可以使用return true达到continue的效果，return false达到break的效果。

### DOM交互
get(index)：获得jQuery对象指定的DOM元素
size()：获取匹配元素数量（指的是DOM元素）
toArray()：返回DOM元素数组

### Ajax
load(url, [data, ] [callback])：将Url载入被选元素中
`$.get(url, [callback])`：请求Url，成功后执行callback（第一个参数包括请求返回的内容，第二个参数返回请求的状态）
`$.post(url, [data, ] [callback])`：请求Url发送data数据，成功后执行callback（第一个参数包括请求返回的内容，第二个参数返回请求的状态）
`$.ajax({})`


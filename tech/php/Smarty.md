Smarty是一个php模板引擎。
模版引擎的目的，就是要达到把程序应用逻辑 (或称商业应用逻辑) 与网页呈现逻辑分离。就是说 PHP 程序里不要有太多的 HTML 码，HTML页面中也不要掺杂太多PHP代码。程序中只要决定好那些变量要塞到模版里，让模版自己决定该如何呈现这些变量 (甚至不出现也行)。在应用程序员和美工进行分工之后，使得程序逻辑和页面展现相解耦。更便于各方独立升级。

Smarty的特点之一是"模板编译"。意思是Smarty读取模板文件生成php脚本并执行。因此并没有花费模板文件的语法解析,同时每个模板可以享受到诸如[Zend加速器](http://www.zend.com) 或者[PHP加速器](http://www.php-accelerator.co.uk)这样的php编译器高速缓存解决方案。

特点：

+ 速度：提高开发速度
+ 编译型：Smarty在接到请求后，先判断是否第一次请求该 url 和文件是否被修改（是：编译后重定向；否：直接重定向）
+ 扩展性：可以通过编辑'自定义函数'和自定义'变量'实现扩展，Smarty模板引擎采用PHP实现，不仅可以在源代码中修改，还可以自定义功能插件
+ 强大的表现逻辑：诸如 if/elseif/else/endif 语句可以被传递到php语法解析器
+ 模板继承：smarty3的新事物，更直观和易管理
+ 内建缓存支持：Smarty提供了一种可以选择的缓存技术，它可以将用户最终看到的HTML文件缓存成一个静态的html页。当用户开启Smarty缓存时，并在设定的时间内，将用户的请求直接转换到这个静态的HTML文件中来，相当于调用一个静态的HTML文件。可自定义缓存处理函数
+ 可定制：可以内嵌php代码到你的模板文件中,虽然这可能并不需要(不推荐)

> 模版引擎，依文件呈现方式大概分成：需搭配程序处理的模版引擎 和 完全由模版本身自行决定的模版引擎两种形式。
> 在需搭配程序处理的模版引擎中，程序开发者必须要负责变量的呈现逻辑，也就是说他必须把变量的内容在输出到模版前先处理好，才能做 assign 的工作。换句话说，程序开发者还是得多写一些程序来决定变量呈现的风貌。而完全由模版本身自行决定的模版引擎，它允许变量直接 assign 到模版中，让视觉设计师在设计模版时再决定变量要如何呈现。因此它就可能会有另一套属于自己的模版程序语法 (如 Smarty) ，以方便控制变量的呈现。但这样一来，视觉设计师也得学习如何使用模版语言。
> 一般的模版引擎 (如 PHPLib) 都是在建立模版对象时取得要解析的模版，然后把变量套入后，透过 parse() 这个方法来解析模版，最后再将网页输出。
> 对 Smarty 的使用者来说，程序里也不需要做任何 parse 的动作了，这些 Smarty 自动会帮我们做。而且已经编译过的网页，如果模版没有变动的话， Smarty 就自动跳过编译的动作，直接执行编译过的网页，以节省编译的时间。

### 为什么要分离
在一般模版引擎中，我们常看到区域的观念，所谓区块大概都会长成这样：
```
　　<!-- START : Block name -->
　　区域内容
　　<!-- END : Block name -->
```
这些区块大部份都会在 PHP 程序中以 if 或 for, while 来控制它们的显示状态，虽然模版看起来简洁多了，但只要一换了显示方式不同的模版， PHP 程序势必要再改一次！
在 Smarty 中，一切以变量为主，所有的呈现逻辑都让模版自行控制。因为 Smarty 会有自己的模版语言，所以不管是区块是否要显示还是要重复，都是用 Smarty 的模版语法 (if, foreach, section) 搭配变量内容作呈现。这样一来感觉上好象模版变得有点复杂，但好处是只要规划得当， PHP 程序一行都不必改。




[参考](http://www.smarty.net/documentation)
可以自行设置模板定界符,所以你可以使用{}, {{}}, <!--{}-->, 等等
如果允许的话,section之间可以无限嵌套


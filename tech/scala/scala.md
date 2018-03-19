# Scala
[官网](http://www.scala-lang.org/)

## 概述
一门多范式（multi-paradigm）的编程语言，设计初衷是要集成面向对象编程和函数式编程的各种特性。

通用编程语言，既可用于大规模应用程序开发，也可用于脚本编程
源代码被编译成Java字节码，所以它可以运行于JVM之上；并可以和Java 无缝互操作，Scala 类可以调用Java 方法，创建Java 对象，继承Java 类和实现Java 接口，调用现有的Java类库。

+ 面向对象
每个值都是对象。对象的数据类型以及行为由类和特质描述。
类抽象机制的扩展有两种途径：一种途径是子类继承，另一种途径是灵活的混入(mixin)机制。这两种途径能避免多重继承的种种问题。
+ 函数式
函数也能当成值来使用
匿名函数、高阶函数、闭包、允许嵌套多层函数，并支持柯里化。
case class及其内置的模式匹配相当于函数式编程语言中常用的代数类型。

### 类型系统
编译时检查
泛型类
协变和逆变
标注
类型参数的上下限约束
把类别和抽象类型作为对象成员
复合类型
引用自己时显式指定类型
视图
多态方法

### 扩展性
任何方法可用作前缀或后缀操作符
可以根据预期类型自动构造闭包。

### 并发
Actor作为其并发模型，Actor是类似线程的实体
Actor可以复用线程，因此可以在程序中可以使用数百万个Actor,而线程只能创建数千个。

### Web 框架
[Lift](https://liftweb.net/)
[Play](http://www.playframework.org/)

## 基本语法
大小写敏感
语句末尾的分号 ; 是可选的
类名的第一个字母要大写
方法名的第一个字母用小写
程序文件的名称应该与对象名称完全匹配，并追加".scala"为文件扩展名。
Scala程序从main()方法开始处理，这是每一个Scala程序的强制程序入口部分。

### 标识符
#### 字符数字标志符
使用字母或是下划线开头，后面可以接字母或是数字，符号"$"在 Scala 中也看作为字母。然而以"$"开头的标识符为保留的 Scala 编译器产生的标志符使用，应用程序应该避免使用"$"开始的标识符，以免造成冲突。
camel 命名规则

#### 符号标志符
```
+ ++ ::: < ?> :->
```

#### 混合标志符
由字符数字标志符后面跟着一个或多个符号组成

### 注释
类似 Java 支持单行和多行注释。多行注释可以嵌套，但必须正确嵌套，一个注释开始符号对应一个结束符号。


## 数据类型
+ Byte, Short, Int, Long	有符号整数（8、16、32、64）默认Int
+ Float, Double	IEEE754 浮点数（32、64）默认Double
+ Char	16位无符号Unicode字符，用单引号
+ String	字符串，用双引号，支持三双引号多行字符串
+ Boolean	true或false
+ Unit	表示无值，和其他语言中void等同。只有一个实例值，写成()
+ Null	空引用，只有一个实例null
+ Nothing	类层级的最低端；它是任何其他类型的子类型，因此没有实例
+ Any		所有其他类的超类
+ AnyRef	所有引用类(reference class)的基类

### 字符串
实际上就是java.lang.String，不可变字符串；如果需要一个可以修改的字符串可以使用StringBuilder 类

#### 方法
length()：返回字符串长度
indexOf(str, fromIndex=0)：返回指定子字符串在此字符串中第一次出现处的索引，从指定的索引开始
lastIndexOf(str[, fromIndex])：返回指定子字符串在此字符串中最后一次出现处的索引，从指定的索引开始反向搜索

toLowerCase()
toUpperCase()
trim()
concat(str)：连接另一个字符串后返回，相当于`+`
format(...)：用参数格式化带占位符的字符串返回
charAt(index)：返回指定位置的字符
substring(beginIndex, endIndex)：返回子串
replace(oldChar,newChar)：全部替换字符
replaceAll(regex,replacement)：全部替换字符串
replaceFirst(regex,replacement)
toCharArray()
split(regex[, limit])：正则切分为数组

equals(obj)
equalsIgnoreCase(str)
compareTo(obj)
compareToIgnoreCase(str)
startsWith(str, index=0)
endsWith(str)
matches(regex)：是否匹配给定的正则表达式

#### StringBuilder 类
```
val buf = new StringBuilder;
buf += 'a'			// 连上一个字符
buf ++= "bcdef"		// 连上一个字符串
println( "buf is : " + buf.toString );
```

#### 符号字面值
字符串有一种特别的字面值：scala.Symbol
```
'<标识符串>
```
其中标识符串是不以数字开头的任何字母或数字序列
实际上，该字面值被映射为Symbol("<标识符串>") 的实例
Symbol 是interned string，即使用字符串池进行保存，以后相同的字符串都使用同一实例，节省内存，加速字符串比较

#### 转义字符
在字符或字符串中，反斜线和后面的字符序列不能构成一个合法的转义序列将会导致 编译错误。

### 空
Unit	表示正常返回但无返回值，只有一个实例，封装了Java 的void，“()”也只是这个单例对象toSting的输出内容而已
Null	空引用，只有一个实例null就对应了Java 的null，在scala中不直接使用null
Nothing	任何其他类型的子类型，无实例，作为返回类型时指非正常返回（抛异常）
Nil		List[Nothing]的子类，单例对象，与类型无关的空容器
None	Option类型的空值（单例对象），Option类型是Some() 或None（Option类型可以理解为一个长度可能为0 或1 的容器）


### 数组
```
var arr:Array[type] = new Array[type](length)	//定义并初始化为默认值（如果不写new 则只定义数组，不初始化）
var arr1 = Array(1, 2, 3)	// 简洁形式
arr(0) = 
```
type 为数组元素的类型，length 是数组的长度
定长同类型，首元素索引为0

#### 多维数组
数组的type 可以又是一个数组
也可以使用`Array.ofDim[type](n1, n2, ...)` 构造一个多维规则数组，其中type 是多维数组基本元素的类型，n? 是每一维的长度

#### Array 包里的方法
需要`import Array._`

#### 变长数组
```

```

## 运算符、表达式、语句
### 运算符和表达式
#### 赋值与销毁
```
var myVar: String = "Foo"		// 变量
val myVal: String = "Foo"		// 常量
val xmax, ymax = 100	// xmax, ymax都声明为100，并被推断为Int
val pa = (40,"Foo")		// 元组
```
如果不指定类型，则通过初始值进行推断

#### 算术、关系、逻辑、位运算、运算赋值
同Java，但不支持++、--

#### 访问修饰
private，protected，public
默认public
在嵌套类情况下，外层类不能访问被嵌套类的private成员；但内层可以访问外层的private成员
protected 比private 扩展子类内可以访问

##### 作用域保护
```
private[x]
protected[x]
```
x指代某个所属的包、类或单例对象。
表示除了包、类及它们的伴生对像可见外，对其它所有类都是private或protected

#### 表达式块
表达式可以是一个大括号括起来的语句块，其值为最后一条语句的值

### 语句
#### 条件
if() {} else {}
同Java

#### 循环
while/do while 同Java

##### for
```
for(var1 <- Range1; var2 <- Range2
	if cond1; if cond2) {
	// 语句
}
```
其中Range，可以是`i to j`（整数区间[i, j]）、`i until j`（整数区间[i, j)）
也可以是一个Array、List
有多重迭代时，后面的迭代先进行，类似于嵌套（后面的是内层循环）

###### for-yield
```
var newList = for{ a <- oldList
	if cond1; if cond2
}yield a
```

##### 循环控制
没有break 和continue 关键字
可以使用`scala.util.control.Breaks` 进行控制
```
val loop = new Breaks;
loop.breakable {
	for(...) {
		loop.break;
	}
}
```
loop.break 会跳出对应的loop.breakable 块，通过控制breakable 块的位置可以实现break 和continue
如果不需要做跳出控制，可以直接`import util.control.Breaks._` 进而可以直接使用breakable 和break

breakable 和break 其实都是函数：
```
def breakable(op: => Unit) {
	try {
		op
	} catch {
		case ex: BreakControl =>
			if (ex ne breakException) throw ex
	}
}

def break(): Nothing = { throw breakException }
```
代码块作为一个值为Unit 的表达式参数按名调用breakable 函数，并捕获其breakException（由break 函数抛出）

#### 打印
print()
println()
printf("浮点型变量为 %f, 整型变量为 %d, 字符串为 %s", floatVar, intVar, strVar)


## 函数
函数名可以有以下特殊字符：+, ++, ~, &,-, -- , \, /, : 等
### 声明、定义、调用
```
def funcName([arg1:arg1_type[=default_val1], arg2:arg2_type[=default_val2], ...[, argN:argN_type*]])[: ret_type] = {
	// func body
	return xxx
}

[instance.]functionName(a, b, ...)
```
不写等号和函数体是声明，会被隐式声明为"抽象(abstract)"，包含它的类型于是也是一个抽象类型。
支持默认参数值
支持嵌套函数定义、闭包
最后一个参数类型后面加`*`，表示可变长参数。函数内可以当做一个列表
支持指定参数名调用
支持递归调用

+ 如果args 为空，则函数定义和调用时都可以省去小括号
+ 无结果返回，`ret_type`使用Unit
+ 如果`ret_type`缺省，则return 也必须缺省，返回结果是最后一个表达式的结果
	- 最简形式：`def funcName([args]) = ret_expr`
+ 如果`ret_type` 和`=` 缺省，相当于`ret_type` 为Unit

### 传名调用
在`arg_type`前加上` =>`表示该参数的实参延迟求值，即在函数体内每次需要改变量的值的时候，都会重新计算一下
如果函数内多次使用这个值，传值调用更好；而如果这个函数本身会被多次调用，但只有很少次会用到这个值，传名调用更好

### 偏应用函数
只提供部分参数，不提供的使用`_: arg_type`，进行占位
```
import java.util.Date
def log(date: Date, msg: String) = println(date + "------" + msg)
val logWithDate = log(new Date, _: String)
logWithDate("test")
```

### 高阶函数
函数式编程，函数可以作为值传给其他函数，也可以作为返回值从其他函数返回
类型标识可以是
```
() => Unit		// 一个返回为空的无参函数
Int => String	// 返回一个字符串、接受一个整数参数的函数
```

### 匿名函数
```
([arg1:arg1_type[=default_val1], arg2:arg2_type[=default_val2], ...[, argN:argN_type*]]) => ret_expr
```

### 柯里化(Currying)
柯里化(Currying) 指的是原来多参数函数，变为单参数函数链
```
def strcat(s1: String)(s2: String) = s1 + s2
```


## 包
```
package com.runoob
```
在文件的头定义包名，一个文件一个包
```
package com.runoob {
  class HelloWorld
}
```
可以在一个文件中定义多个包

### 导入包
使用 import 关键字引用包
import语句可以出现在任何地方，而不是只能在文件顶部。import的效果从开始延伸到语句块的结束。
```
import java.awt._  // 引入包内所有成员
import java.awt.{Color, Font}  // 引入包中的几个成员，可以使用selector（选取器）
import java.util.{HashMap => JavaHashMap}  // 重命名成员
import java.util.{HashMap => _, _} // 引入了util包的所有成员，但是HashMap被隐藏了
```
*注意：默认情况下，Scala 总会引入 java.lang._ 、 scala._ 和 Predef._，这里也能解释，为什么以scala开头的包，在使用时都是省去scala.的。*



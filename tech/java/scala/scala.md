# Scala
[官网](http://www.scala-lang.org/)
[API](http://www.scala-lang.org/api)
[TOC]

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

### 随机数
util.Random([seed])
seed 是一个整数，可选

### 字符串
实际上就是java.lang.String，不可变字符串；默认值是null
如果需要一个可以修改的字符串可以使用StringBuilder 类

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
可变字符串
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

### Any
方法：
isInstanceOf[type]：测试是否是某种具体类型
asInstanceOf[type]：转换为某种具体类型


### 数组
```
var arr:Array[type] = new Array[type](length)	//定义并初始化为默认值（如果不写new 则只定义数组，不初始化）
val arr = Array("aa", "bb", "cc")	//相当于伴生对象val arr = Array.apply("aa", "bb", "cc")
arr(0) = "dd"						//相当于对象本身arr.update(0, "dd")
```
type 为数组元素的类型，length 是数组的长度
定长同类型，首元素索引为0

#### 多维数组
数组的type 可以又是一个数组
也可以使用`Array.ofDim[type](n1, n2, ...)` 构造一个多维规则数组，其中type 是多维数组基本元素的类型，n? 是每一维的长度

#### 方法
length：数组长度
sum：只支持数值数组
reverse：返回一个反序的数组
sorted：返回一个排序的数组
toBuffer：返回一个ArrayBuffer
mkString：返回一个字符串，将各个元素的字符串表示连在一起
++(arr)：和另一个数组arr连接后返回

##### Array 包里的方法
需要`import Array._`

empty：返回长度为 0 的数组
range(start, end, step=1)
`fill(len)(ele: =>T)`：返回长度为len 的数组，该函数还可以指定多个len 来创建多维数组
tabulate(len)(f)：返回长度为len 的数组，把0 until len 依次代入函数f，将返回值赋给每个元素，该函数还可以指定多个len 来创建多维数组
iterate(s, len)(f)：返回长度为len 的数组，第一个元素是s，而后把前一个元素代入函数f，返回值作为下一个元素

`concat(arr*)`：连接多个数组返回之
copy(src, srcPos, dest, destPos, length)：复制数组元素

#### 变长数组
scala.collection.mutable.ArrayBuffer
```
import collection.mutable.ArrayBuffer
val arr = new ArrayBuffer[Int]	// 获得一个空变长数组
val arr = ArrayBuffer[type]()
val arr = ArrayBuffer.empty[type]

arr += 99		// 元素追加
arr += (1, 2, 3, 4)	// 追加多个元素
arr ++= Array(7, 8, 9)	// 追加任何集合
arr.trimEnd(n)	// 移除最后n 个元素

arr.insert(pos, addEle*)	// 在索引pos 的位置传入多个元素
arr.remove(pos, n)		// 从索引pos 的位置移除n 个元素


arr.toArray		// 返回一个Array
```

### 容器类型
scala.collection 有三个子包类型：
scala.collection.immutable：不可变容器（默认）
scala.collection.mutable：可变容器
scala.collection.generic：实现容器的构建块
为了方便，这些包里的有些类在scala 包下创建了别名，从而可以直接使用，这些类包括：
Traversable, Iterable, Seq, IndexedSeq, Iterator, Stream, Vector, StringBuilder, Range, List, Set, Map

共有的操作
apply 工厂：都可以通过罗列创建（Map 特别一些，元素可以是`key -> val` 或 `(key, val)`）
toString

#### Traversable
它是一个trait，是所有容器的根
它只有一个抽象操作：foreach(func)，每个容器类都必须实现这个遍历操作（参数是一个一元函数，对每个元素进行操作，不在意返回类型）

##### 操作
++(t)：连上另一个容器或迭代器返回

foreach(func)：遍历每个元素
map(func)：用每个元素调用func 的返回值组成另一个容器返回
flatMap(func)：用每个元素调用func 的返回值（是一个容器），再将这些容器连起来作为一个容器
collect(pf)：同map，只不过接收一个偏函数，如果isDefinedAt 检查失败会忽略



#### 


## 运算符、表达式、语句
### 运算符和表达式
#### 赋值与销毁
```
var myVar: String = _		// 变量，用默认值赋值
val myVal: String = "Foo"		// 常量
lazy val tVal: String = myVar	// 并不立即求值，在首次引用时才进行求值
def nVal: String = myVar		// 常量，并不立即求值，而在每次引用都重新求值（call-by-name）
val xmax, ymax = 100	// xmax, ymax都声明为100，并被推断为Int
val pa = (40, "Foo", 1.1)		// 元组
val (_, str, fl) = pa			// 从元组中取值，相当于val str = pa._2; val fl = pa._3
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
可以将其进行赋值或作为参数

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
其中Range，可以是`i to j`（整数区间[i, j]）、`i until j`（整数区间[i, j)）；后面可以跟`by k`，表示step 为k，也可以j,k 合在一起写作`(j, k)`
也可以是一个Array、List
有多重迭代时，后面的迭代先进行，类似于嵌套（后面的是内层循环）
*注：for 会比同规模的while 循环慢4倍左右*

###### for-yield
```
var newList = for{ a <- oldList
	if cond1; if cond2
}yield expr
```
花括号和小括号都可以
expr 表达式可以是使用a

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


## 函数与方法
由于scala 是纯面向对象的，所以不允许游离在class 或object 之外的函数
由于scala 是函数式的，所以函数也是一种对象，它也有它的类型和方法
而方法属于对象，最终执行的动作都是方法描述的，它只有签名，没有类型

### 方法的声明、定义、调用
```
def funcName([arg1:arg1_type[=default_val1], arg2:arg2_type[=default_val2], ...[, argN:argN_type*]])[: ret_type] = {
	// func body
	[return ]xxx
}

[instance.]functionName(a, b, ...)
```
funcName 可以有这些特殊字符：+, ++, ~, &,-, -- , \, /, : 等
不写等号和函数体是声明，会被隐式声明为"抽象(abstract)"，包含它的类型于是也是一个抽象类型。
支持默认参数值（并不要求从后向前依次给默认值）
支持嵌套函数定义、闭包
最后一个参数类型后面加`*`，表示可变长参数。函数内可以当做一个列表
支持指定参数名调用
支持方法重载
支持递归调用

+ 如果args 为空，则调用方法时可以省去小括号
+ 无结果返回，`ret_type`使用Unit
+ 如果`ret_type`缺省，则return 也必须缺省，返回结果是最后一个表达式的结果（反之，可以只省return，不省`ret_type`）；即如果写return，则必须显示写`ret_type`
	- 最简形式：`def funcName([args]) = ret_expr`
+ 如果`ret_type` 和`=` 缺省，相当于`ret_type` 为Unit

### 传名调用（call-by-name）
在`arg_type`前加上` =>`表示该参数的实参延迟求值，即在函数体内每次需要改变量的值的时候，都会重新计算一下
如果函数内多次使用这个值，传值调用更好；而如果这个函数本身会被多次调用，但只有很少次会用到这个值，传名调用更好

对于call-by-name 的对象，其行为相当于一个无参方法
同样可以使用eta-expansion 将其转换为一个函数对象：
```
def r = new Random().nextInt
val t = r _
```

### 高阶函数
函数式编程，函数可以作为值传给其他函数，也可以作为返回值从其他函数返回
类型标识可以是
```
() => Unit		// 一个返回为空的无参函数，是Function0[Unit] 的简写
Int => String	// 返回一个字符串、接受一个整数参数的函数，是Function1[Int, String] 的简写
```

### 匿名函数
```
([arg1:arg1_type[=default_val1], arg2:arg2_type[=default_val2], ...[, argN:argN_type*]]) => ret_expr
```
如果可以通过上下文推断类型（如将该匿名函数赋值给显式声明类型的对象或作为确定类型的参数），则可以省略`arg?_type`
实际上，匿名函数是下面的的简写法：
```
new FunctionN[arg1_type,arg2_type,...,argN_type,ret_type]{
	def apply([arg1:arg1_type[=default_val1], arg2:arg2_type[=default_val2], ...[, argN:argN_type*]]) = ret_expr
}
```
其中N 可以是0-22，表示参数个数
后面的类型列表是参数类型和返回类型（最后一个）

+ Function1 的内置方法
andThen(func1)：接收另一个Function1 对象，返回一个新的Function1（先执行本对象，再将结果传入func1执行）
compose(func1)：接收另一个Function1 对象，返回一个新的Function1（先执行func1，再将结果传入本对象执行）
+ Function2 的内置方法
curried：返回一个柯里化的版本
tupled：返回一个接收元组参数的版本

#### 占位符匿名函数
由占位符`_` 组成的表达式，Scala 会自动将其转换为匿名函数。
*如果`_`需要指明类型，可以写作`(_:type)`*
转换过程是：
1. 找到这个表达式：尽可能长，直到找到括号、逗号、分号为边界
如果这个表达式是`_`，那么就忽略这个边界，继续找一个更大的表达式
1. 将这个表达式中的每个`_`，转换为一个变量（不复用）
1. 有几个`_`就是几个参数，函数体就是该表达式

### 偏应用函数
只提供部分参数，不提供的使用`_` 进行占位
```
import java.util.Date
def log(date: Date, msg: String) = println(date + "------" + msg)
val logWithDate = log(new Date, _: String)		//logWithDate 类型需要推断，所以占位符必须带类型
// 或者val logWithDate: String => Unit = log(new Date, _)
logWithDate("test")
```
**注：这里不能根据log 的参数类型来自动推断logWithDate 的类型，因为偏应用函数中的参数类型可以是原函数或方法的参数类型的派生类，所以必须指明占位符参数类型**

#### eta-expansion
特别的`func _` 等价于`func(_, _, ..., _)`，此时不用指明每个参数的类型；并且如果可以通过上下文推断类型（如将该匿名函数赋值给显式声明类型的对象或作为确定类型的参数），可以用`func` 代替`func _`
但如果func 是重载方法，则必须指明类型，例如
```
func _ : ((String, Int) => Int)		// 类型外面这个括号是必须的
func(_: String, _: Int)
```
不过也有例外，当两个重载方法，其中一个只有一个 AnyRef 的参数，那么`func _`就会默认选择另一个方法

实际上，这里是Scala的会被解析为`(x$1, x$2, ..., x$n) => func(x$1, x$2, ..., x$n)`这样的匿名函数，这个过程叫做eta-expansion
eta-conversion是一种lambda变换，意思是上面的lambda 表达式和func 是等价的（入参一致，结果一致），所以可以用func 表示这个lambda 表达式；
eta-expansion 就是Scala 自动将func 这个方法转换为一个匿名函数的过程

### 偏函数
普通的函数是针对参数数据类型的全集来做映射，是否满足入参条件是有编译检查完成的；而偏函数是只针对其子集的映射，是否满足入参条件还通过该函数的isDefinedAt方法进行判断

偏函数是PartialFunction[-A,+B] 的实例，它是一个trait，继承自Function1，需要实现两个操作：apply 和isDefinedAt
isDefinedAt 则用于判断参数是否满足该偏函数的执行条件；调用偏函数前都必须进行该检查，因为可能这里检查失败，但apply 方法也可以执行，只不过那未必是期望的
apply 和普通函数一样，表示该函数的执行方法；实际上调用的是偏函数的applyOrElse(x, PartialFunction.empty) 方法（返回PartialFunction[Any, Nothong]对象），后者是一个默认方法，是当isDefinedAt 判断失败执行的默认函数

其他方法：
继承Function1 的andThen 和compose
lift：转化为一个普通函数返回。这个普通函数返回是Option
orElse(pf)：结合另一个偏函数，返回一个结合这两个入参子集并集的偏函数（对于交集部分，则本函数优先）
runWith(action)：返回一个函数相当于`if(this isDefinedAt x) { action(this(x)); true } else false`


通常，偏函数通过case 语句块来实现（但并不是意味着case 语句块就一定是偏函数，case 语句块既可以编译为普通函数，也可以编译为偏函数，这取决于其期望类型——赋值变量的类型或参数类型）
之所以PartialFunction 是Function1 的子类而不是更多参数的，就是因为case 的结构，每个case 语句只能声明一个对象，所以偏函数只有一个参数。如果真的需要多个参数，完全可以通过tuple 来实现


### 柯里化(Currying)
柯里化(Currying) 指的是原来多参数函数，变为单参数函数链
```
def strcat(s1: String)(s2: String) = s1 + s2
```


## 类和对象
### 方法
对于无参的方法，方法调用的括号可以省略
对于单个参数的方法，可以变方法调用为运算调用：
```
str.equals(str_1)	//等价于 str equals str_1
```

### 伴生对象
Scala 的类没有静态成员，但可以给类同名定义一个伴生对象（companion object，单例）
伴生对象必须和他的类在同一文件中定义，类和伴生对象可以相互访问私有成员

### 注入方法和抽取方法
使用类或对象直接进行函数调用，实际上是调用该类的伴生对象或该对象本身（定义在类中）的apply 方法或update 方法

而unapply 方法和unapplySeq 方法则常用于模式匹配
这两个方法的参数就是模式匹配的左值，case 是类名(返回值列表)
```
class Money(val value: Double, val country: String) {}

// 伴生对象
object Money {
	// apply 做工厂方法
    def apply(value: Double, country: String) : Money = new Money(value, country)

    def unapply(money: Money): Option[(Double, String)] = {
        if(money == null) {
            None
        } else {
            Some(money.value, money.country)
        }
    }
}

val money = Money(1.1, "RMB")
money match {
	case Money(v, "RMB") => println("RMB: " + v)
	case _ => println("no money")
}

object Name {
	def unapplySeq(input: String): Option[Seq[String]] =
		if (input == "") None else Some(input.trim.split("\\s+"))
}


"aa bb cc" match {
	case Name(first, second, third) => {
		println(s"$first $second $third")
	}
	case _ => println("nothing matched")
}
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
*注意：默认情况下，Scala 总会引入 java.lang._ 、 scala._ 和 Predef._，所以以scala开头的包，在使用时可以省去`scala.`。*


## IO 相关
scala.io.Source
```
val source = Source.fromFile(filename)
source.getLines()	// 返回一个Iterator[String]，迭代每一行
```

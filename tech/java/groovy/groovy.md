# Groovy
<https://docs.groovy-lang.org/latest/html/documentation/>
<http://docs.groovy-lang.org/latest/html/api/>
<http://docs.groovy-lang.org/latest/html/groovy-jdk/>

## 简述
动态语言
脚本可以直接写函数，groovy 会自动将其编译为一个类的方法

脚本可以直接用groovy 命令执行
也可以先用groovyc 预编译，再用java 执行

Groovy 一切皆对象（都实现了GroovyObject接口），即使是基本类型，所以所有运算符的背后都是方法，比如
`==` 调用equals 方法
`+` 调用plus 方法
`-` 调用minus 方法
`*` 调用multiply 方法
这些方法都可以进行重写，从而重载运算符

### 语句风格
可以不用分号结尾
多条语句连在一行需要使用分号分隔，注意`{}` 也是一条语句，也需要用分号和后面的语句分隔

### 注释
和Java 一样
支持`//` 和 `/* ... */`

### 打印
print()
println(str)
printf(format, args...)

## 数据类型
支持Java 所有基础类型（都会被装箱为对象），可以用`.class`属性查看类型。

如果对象为空（包括null, "", 空容器），则在判断时视为false
本质上是调用了asBoolean() 方法，即使null 也是一个对象，它是org.codehaus.groovy.runtime.NullObject 的实例
null 支持的方法有getClass()、equals、asBoolean、+（字符串连接）、iterator()

字符串、List、Map 都可以使用== 进行比较（本质上是调用了equals 方法），如果要判断引用是否相同，可以使用a.is(b)

### 字符
```
char c1 = 'A'
def c2 = 'B' as char
def c3 = (char)'C'
```

### 字符串
```
"hello world"							// java.lang.String 类型，非变量解析的字符串均是该类型
"the sum of 2 and 3 equals ${2 + 3}"	// groovy.lang.GString 类型，支持变量解析（如果单个变量可以省略大括号）、表达式解析（支持闭包表达式）、多条语句组成的复杂表达式

"abcdefg"[2]							// c，相当于.getAt(2)
"abcdefg"[1..3]							// bcd，相当于.getAt(1..3) 或substring(1,3)（第二个参数缺省为最后一个字符）
"abcdefg".size()						// 等价于length()
"abcdefg".indexOf("b")					// 1，返回子串的起始索引，如果没有，则返回-1
"abcdefg".endsWith("b")					// false
"abcdefg".compareToIgnoreCase("ABCDEFG")	// 0，大于返回正，小于返回负

"abcd" + 'ef'							// abcdef，等价于concat（不影响原字符串）
"abcd" - 'bc'							// ad，删除子串
"abcd" << "ef"							// abcdef，等价于leftShift，返回类型为java.lang.StringBuffer
"abcd".previous()						// abcc，按字典顺序给最后一个字符-1
"abcd".next()							// abce，按字典顺序给最后一个字符+1
"abcd".reverse()
"abcd".toUpperCase()
"ABCD".toLowerCase()
"demo".center(10, '1234')				// 123demo1234，第二个参数缺省为空格
"abcd".padLeft(5,"12")					// 1abcd，第二个参数缺省为空格
"abcd".padRight(5,"12")					// abcd1，第二个参数缺省为空格

'a.b./c/d'.tokenize('./')				// [a, b, c, d]，token 字符串每个字符都是分隔符，缺省为空白符，多个分隔符视为一个，返回List
''.split(reg)							// 用正则字符串进行分隔，reg默认空白符，返回string[]
''.matches(reg)							// 字符串是否匹配正则字符串

'''
	code
'''.stripIndent(4)						// 去掉多行字符串的缩进字符数，缺省参数为多行代码的最小缩进空格数
```
单引号串不对 $ 符号进行占位替换（interpolated）
双引号串会对 $ 符号进行占位替换
三引号串支持多行，支持$ 占位替换（三个双引号），在行末使用`\`可以取消换行符
`/`字符串是Slashy 字符串，支持多行，支持$ 占位替换。由于无需转义反斜杠，主要用于正则

支持转义字符，`\u` 开头的UNICODE字符
可以使用toCharacter() .toInteger() toLong() toFloat() .toDouble() toLong() toString() toList()（单字符列表）等转换方法
可以直接使用`==` 比较内容相等

#### GString 字符串
`$` 开头的.表达式（单变量表达式）
`${}` 包起来的表达式（复合表达式）没有表达式的`${}` 表示null

表达式可以是分号分隔的语句，最后一句是其返回值，如果为空，则为null
也可以是0或1个参数（默认可省）的闭包表达式（为了区别非闭包表达式，这里的0参闭包不能省略`->`），可以做到延迟解析的效果，因为一般的表达式在创建时绑定完成，闭包表达式在使用时加载绑定
当然如果绑定的是对象，当对象的属性发生变化，字符串也还是可以动态变化的

注意同意字符串内容的String 串和GString 串的 hashCode() 是不同的，所以不要作为map 的key
例如：
```
def key = "a"
def m = ["${key}": "letter ${key}"]
assert m["a"] == null

```

#### Slashy 字符串
```
/.*foo.*/
$/.*foo.*/$
```
前者转义符是`\`，后者转义符是`$`

Slashy 字符串前面直接加上`~` 就可以创建java.util.regex.Pattern 的实例，例如：
```
def p = ~/a*/		// p.class == java.util.regex.Patter
def m = s =~ /a*/	// m.class == java.util.regex.Matcher
def b = s ==~ /a*/	// b.class == java.lang.Boolean
```

##### 正则支持
\b :单词的开始或者结尾
\w :匹配字母或者数字或者下划线或汉字
\d :匹配数字
\s :匹配任意的空白符


### 容器
#### List
可以直接使用`==` 判断相等
```
def eList = []		// 空List
def aList = [5,'string',false]	// 支持混合类型
aList.size()	// 元素个数
aList.isEmpty()
aList[3]		// null，相当于aList.get(3)
aList[-2]		// string，相当于aList.getAt(-2)，get 方法不支持负参
aList[1..2]		// ['string', false]，相当于aList.getAt(1..2) 或aList.getAt([1,2])
aList << 10 << 'bb' << bList	// 追加数据（返回追加后的列表），相当于aList.leftShift(10) 或aList.add(bList) 但add返回为true
aList + bList + c		// List 连接，性能不如 <<，因为会创建新的列表
aList += bList			// 连接回赋（会创建新列表）
aList - c				// 删除元素
aList - bList			// 差集
aList -= bList			// 删除回赋（会创建新列表）
aList.remove(1)			// 删除位置为1 的元素（返回该元素）
aList.pop()				// 删除第一个元素（返回该元素）
aList.intersect(bList)	// 交集
aList.disjoint(bList)	// 是否相交（不相交返回true）
aList.clone()
aList*n					// 多个重复List 进行连接
aList[10] = 100			//[5, string, false, null, null, null, null, null, null, null, 100]
aList.reverse()			// 逆序
aList.contains(5)		// 是否包含指定元素，等价于 5 in aList
aList.containsAll([5, 'string'])	// 都存在返回true
aList.indexOf('string')	// 返回指定元素的索引
aList.count('string')	// 返回指定元素的出现次数，也可以是一个闭包参数，则计数满足条件的次数
aList.sum([init])		// init 依次+ 上列表每个元素
aList.sort([key])		// 排序，可以传入一个闭包，返回用于比较的key
aList.max([comparator])	// 可以传入一个Comparator 做比较，Comparator 可以是一个闭包（单参数闭包则是返回用于比较的值，双参数闭包返回两个比较对象比较完后返回整数值）
aList.min([comparator])
aList.join(str)			// 用str 连接列表每个元素
aList.flatten()			// 多维数组变为一维
aList.each {
	// it 为迭代元素
}
aList.reverseEach {
	// it
}
aList.eachWithIndex { it, i ->
	// it 为迭代元素，i 为迭代索引
}
aList.collect([init]) {		// init 是一个初始化的列表，aList 映射的列表就追加到init 中
	// 映射操作
}
aList*.multiply(n)	// 等价于aList.collect { it*n }
aList.inject([init]) { t, it ->
	// t 为前一次迭代的结果，若有init初始为init，若没有则为aList 第一个元素
	// it 为迭代元素，若没有init 则从aList 第二个元素开始
}
aList.find { cond }	// 返回满足条件cond 的第一个元素
aList.findAll { cond } // 返回满足条件cond 的所有元素
aList.grep { cond } // 返回满足条件cond 的所有元素，cond 支持~/regex/ 表达式
aList.findIndexOf { cond }	// 返回满足条件cond 的第一个元素的索引
aList.findLastIndexOf { cond }	// 返回满足条件cond 的最后一个元素的索引
aList.every { cond }	// 都满足条件cond 返回true
aList.any { cond }		// 至少一个满足条件cond 返回true
```

##### 高阶列表
dList.transpose()		// 矩阵转置，相当于Python 的zip()
dList.combinations()	// eg. [[2, 3],[4, 5, 6]] -> [[2, 4], [3, 4], [2, 5], [3, 5], [2, 6], [3, 6]]


##### Range
```
def range1 = 1..5	// [1, 2, 3, 4, 5]
def range2 = 1..<5	// [1, 2, 3, 4]
def now = new Date()
def week = now..now+7
range.from		// 返回第一个元素
range.to		// 返回最后一个元素

range.last()		// 返回最后一个元素
range.clear()

range.iterator()	//迭代器
```

#### Set
```
new java.util.HashSet(list)		// 需要显式声明
[] as Set						// 默认是LinkedHashSet

set.toList()
```

#### Map
默认类型java.util.LinkedHashMap
可以直接使用`==` 判断相等
```
def eMap = [:]	// 空map
def map = [key1: "value1", key2: "value2", *: eMap]	// key 可以是int, String（不带引号默认转，若想获取变量的值作为key，则可以使用(key) ）*:eMap 可以将eMap 的内容放入当前Map
tMap = new TreeMap()	// 显式声明一个有序Map
map.size()	// 元素个数
map.isEmpty()
map.keySet()
map.values()
map.entrySet()
map.key1	// map.'key1' 或map['key1']，相当于map.getAt('key1')
map?.key1	// 等价于if (map != null) map.key1 else null
map.get("key1")
map.get("key4", 1)			// 若没有key4，则返回1，并将该kv 插入map
map1 + map2					// map 合并
map1 += map2				// 相当于map1.putAll(map2) 并返回合并后的map1
map.put("key4", "val4")		// 将key4:val4 放入map，返回key4 原来的val
map.containsKey("key1")		// 等价于 "key1" in map
map.containsValue("values1")
map.remove('key1')
map.subMap(['key2', 'key3'])
map.clear()
map.each {		// 单个参数entry
	// it.key
	// it.value
}
map.each { k,v ->
}
map.collect([init]) {}	// 映射为一个list
map.find {}		// 返回一个满足条件的entry
map.findAll {}	// 返回一个满足条件的子Map
map.any {}
map.every {}

Iterator it = map.iterator()
while (it.hasNext()) {
    println "遍历map: " + it.next()		// 遍历map: key1=value1
}
```

### 闭包Closure
类型groovy.lang.Closure
```
def aClosure = {[paramters ->] code}
aClosure.call("this is string",100)
//或者
aClosure("this is string", 100)
```
paramters 缺省时，有一个隐藏的参数it，指这个闭包本身

#### 内置成员
it: 隐式的闭包入参
this: 和Java 一样，在静态域定义的指该类对象，在其他定义的指实例对象
owner: 若定义在闭包中，则指该闭包对象，其他则和this 一致。使用owner 调用，相当于直接在外层闭包的环境下隐式调用（所以具有向外传递的特性，最大传递到类空间中，而后在尝试delegate 逐层回溯）
delegate: 默认和owner 一致，只不过它有set 方法可以进行重置

##### 隐式调用和解析策略
没有显式用this/owner/delegate 进行调用
1. 首先查询局部域（包括当前闭包和外层闭包），是否有名字的定义，如果有则直接使用，否则
2. 使用解析策略进行名字解析
可以通过修改闭包的resolveStrategy 来调整，可取值包括：
`Closure.OWNER_FIRST`: 默认值，优先使用owner 调用
`Closure.DELEGATE_FIRST`: 优先使用delegate 调用
`Closure.OWNER_ONLY`: 只使用owner 调用
`Closure.DELEGATE_ONLY`: 只使用delegate 调用
`Closure.TO_SELF`: 自定义解析策略，必须实现Closure 的子类

例如：
```
def hello() {		// 1
	println "hello"
}

def testClosure() {
	def hello = {	// 2
		println "in closure hello"
	}
	def closure1 = {
		def closure2 = {
			def closure3 = {
				hello()		// 3
			}
			closure3.delegate = new DemoC()
			closure3()
		}
		closure2.delegate = new DemoB()
		closure2()
	}
	closure1.delegate = new DemoA()
	closure1()
}
```
3 位置的hello 调用：
在局部域找到定义2，则使用之；若2 没有定义
`OWNER_FIRST`策略：解析为closure3.owner.hello() 即closure2.hello() 失败，继续解析为closure2.owner.hello() 即closure1.hello() 失败，继续解析为closure1.owner.hello() 即类空间（包括静态和非静态）即1 处的定义；
				若1 处没有定义，则尝试delegate，即closure1.delegate.hello() 即new DemoA().hello()，若不存在，继续解析为closure2.delegate.hello() 即new DemoB().hello()，若不存在继续解析为closure3.delegate.hello() 即new DemoC().hello()
				若还没有则解析失败
`DELEGATE_FIRST`策略：解析为closure3.delegate.hello() 即new DemoC().hello()，若不存在，则解析为closure3.owner.hello() 即closure2.hello()，后续过程同上
`OWNER_ONLY`策略：解析为closure3.owner.hello() 即closure2.hello() 失败，继续解析为closure2.owner.hello() 即closure1.hello() 失败，继续解析为closure1.owner.hello() 即类空间（包括静态和非静态）即1 处的定义；
				若没有则解析失败
`DELEGATE_ONLY`策略：解析为closure3.delegate.hello() 即new DemoC().hello()，若不存在，则失败

#### 柯里化
闭包有三个方法可以生成柯里化闭包
curry: 左侧优先绑定
rcurry: 右侧优先绑定
ncurry(index, arg...): 可以指定参数位置开始绑定（index 从0开始）

#### 闭包组合
使用`<<` 或`>>` 可以合成为一个新的闭包
比如`closure1 >> closure2` 就会合成一个闭包为`closure2(closure1(it))`

#### 结果缓存
fib = { long n -> n<2?n:fib(n-1)+fib(n-2) }.memoize()
会自动缓存诸如fib(1)、fib(2)、...等单元的结果，用于加速计算
该功能最好只用于仅适用基本类型为参数的闭包

类似函数：
memoizeAtMost: 最多缓存n 个值
memoizeAtLeast:	最少缓存n 个值
memoizeBetween: 缓存[m, n] 个值

#### 蹦床技术
为了解决递归栈溢出问题，将递归函数展平为链式调用
例如递归函数：
```
def factorial
factorial = { int n, def accu = 1G ->
    if (n < 2) return accu
    factorial.trampoline(n - 1, n * accu)		// 返回TrampolineClosure(factorial.curry(args))
}
factorial = factorial.trampoline()				// 返回一个TrampolineClosure(factorial)
```
比如factorial(3) 本质上是TrampolineClosure(3)，而后就被转变为循环，直到返回结果不是TrampolineClosure：
```
result = factorial(3) 是TrampolineClosure，继续
result = factorial(2, 3*1) 是TrampolineClosure，继续
result = factorial(1, 2*3) 是accu 即6，返回
```

### 类型转换
```
s1 as int
s1.asType(Integer)
(char)'C'
```

### 定义变量
支持动态类型和类型推断
```
// 定义局部变量
def a = 1
def b = "b"
def double c = 1.0
def func = b.&toUpperCase	// 获取函数对象Closure 的子类

// 定义生成类的实例属性（去掉def）

// 定义生成类的类成员
@Field s1 = "123"
```

## 运算符、表达式
### 计算
```
2 ** 5		// 幂计算
```

### null 默认值
```
name != null ? name : "abc"
// 可以简写为
name?: "abc"
```

### in 运算符
instanceof 操作符可以换用 in

## 语句
### 分支
```
if (person!= null){
    if (person.Data!=null){
        println person.Data.name
    }
}
// 可以简写做
println person?.Data?.name
```
a?.b 相当于 a != null ? a : null

```
switch (age) {
    case "string":
        rate = 0.05
        break
    case 27..36:
        rate = 0.06
        break
    case [4, 5, 6, 7,'inList']:
        rate = 0.07
        break
    case Integer:
        rate = 0.8
        break
    case List:
        rate = 0.8
        break
    default:
        throw new IllegalArgumentException()
}
```

### 循环
```
while(i <= 5) {
}

for (i = 0; i < 5 ; i++) {
	// 0 1 2 3 4
}

for (i in 0..5) {
	// 0 1 2 3 4 5
}

for (i in map) {
	// i.key
}

5.times {
	//
}
```


## 函数
```
def func_name(arg_list) {
	ret_val
}

ret_type func_name(arg_list) {
	ret_val
}
```
`arg_list` 可空，多个逗号分隔，可以不指定类型，支持默认值，变长参数
函数最后一行就是返回值，可以不使用return
单参数函数调用可以不加括号；如果函数的最后一个参数是一个闭包，可以提到函数调用的小括号之外

## 类
```
class Name {
	String name
	String getName() {
		name
	}
	void setName(String name) {
		this.name = name
	}
	@Override
	String toString() {
		return name
	}
}

Name n = new Name()
Name n = new Name(name:"xxx")
n.name								// 如果有getName()、setName() 方法，则优先使用，否则才使用成员变量
n.@name								// 直接访问name 字段
n?.name								// 等价于if (n != null) n.name else null
```
所有成员默认都是public 的

### 魔术方法
+ getProperty/setProperty 方法会分派所有的get/set 方法，即n.name 如果实例n 没有getName() 方法的话（并且未定义该成员），则调用getProperty('name')
+ invokeMethod 方法会分派方法调用，即n.method() ，如果没有定义method，就会调用invokeMethod
如果类实现GroovyInterceptable 接口，则n.method() 会强制使用invokeMethod，只能通过n.&method() 来访问定义的方法
通过metaClass 来重写invokeMethod 方法也可以做到所有方法强制使用invokeMethod，例如：
```
n.metaClass.invokeMethod = { name, args ->
    if (name == 'greet') {
        println "in closure $name, call $args"
    } else {
        throw new MissingMethodException(name, delegate, args)
    }
}
```
+ methodMissing 和propertyMissing 方法（setter的比getter 的多一个value 参数），可以进行重写，用以进行兜底

### 元编程
所有对象都有一个metaClass（实现了MetaObjectProtocol接口），可以动态给该类型添加方法，比如
```
// not in collection 可以这样写：
Object.metaClass.notIn = { Object collection -> !(delegate in collection) }
// 构造函数
String.metaClass.constructor = {args -> new String(...) }
// 静态成员
Name.metaClass.static.create = {...}

"a".notIn(map)
```
注意使用metaClass 动态添加方法，delegate 都被设置为调用该方法的实例

#### Category


## 包
```
package pk_name
```

## 异常
catch (anything)
可以捕获除Throwable 外的Exception

## 库
### JSON 操作
```
Person person = new Person()
def json = JsonOutput.toJson(person)

JsonSlurper jsonSlurper = new JsonSlurper()
Person person1 = jsonSlurper.parseText(json)
```

### I/O 操作
```
def file = new File(filePath)

// 读
println file.text //输出文本

file.eachLine {
    println it
}
file.eachLine("utf-8") { // 指定读取编码
    println it
}

def ism =  file.newInputStream()
//...
ism.close

file.withInputStream {ism->
    // 操作ism. 不用close。Groovy会自动替你close
    ism.eachLine {
        println it  //读取文本
    }
}

// 写
file.withPrintWriter {
    it.println("测试")
    it.println("hello world")
}

def out = file.newPrintWriter();
out.println("测试")
out.println("hello world")
out.flush()
out.close()

// 遍历目录
file.eachDir {
    println "文件夹："+it.name
}
file.eachFile {
    println "文件："+ it.name
}
file.eachDirRecurse {
    println it.name
}
file.eachFileRecurse {
    println it.path
}
```

### xml 解析
```
def t = new XmlParser().parse(filePath)
```
t 就是这个xml 树的根
子节点可以用t.nodeName 进行访问（如果是多个，可以使用each 遍历
节点属性可以用node..attribute(attr) 获取
节点的文本，可以用node.text() 获取


# Groovy

## 简述
动态语言

### 
可以不用分号结尾

### 注释
和Java 一样
支持`//` 和 `/* ... */`

## 
println(str)

## 数据类型
支持Java 所有基础类型（都会被装箱为对象），可以用`.class`属性查看类型。
如果对象为空，则判断为false
字符串、List、Map 都可以使用== 进行比较，如果要判断引用是否相同，可以使用a.is(b)
### 字符
```
char c = 'A'
```

### 字符串
```
"hello world"							// java.lang.String 类型
"the sum of 2 and 3 equals ${2 + 3}"	// groovy.lang.GString 类型，支持变量解析和表达式解析

"abcdefg"[2]							// c，相当于.getAt(2)
"abcdefg"[1..3]							// bcd，相当于.getAt(1..3) 或substring(1,3)（第二个参数缺省为最后一个字符）
"abcdefg".size()						// 等价于length()
"abcdefg".indexOf("b")					// 1，返回子串的起始索引，如果没有，则返回-1
"abcdefg".endsWith("b")					// false
"abcdefg".compareToIgnoreCase("ABCDEFG")	// 0，大于返回正，小于返回负

"abcd" + 'ef'							// abcdef，等价于concat/plus（不影响原字符串）
"abcd" - 'bc'							// ad，删除子串，相当于minus
"abcd" << "ef"							// abcdef，等价于leftShift
"abcd".previous()						// abcc，按字典顺序给最后一个字符-1
"abcd".next()							// abce，按字典顺序给最后一个字符+1
"abcd".reverse()
"abcd".toUpperCase()
"ABCD".toLowerCase()
"demo".center(10, '1234')				// 123demo1234，没有第二个参数缺省为空格
"abcd".padLeft(5,"12")					// 1abcd
"abcd".padRight(5,"12")					// abcd1

'a.b./c/d'.tokenize('./')				// [a, b, c, d]，token 字符串每个字符都是分隔符，缺省为空白符，多个分隔符视为一个，返回List
''.split(reg)							// 用正则字符串进行分隔，reg默认空白符，返回string[]
''.matches(reg)							// 字符串是否匹配正则字符串
```
单引号串不对 $ 符号进行占位替换（interpolated）
双引号串会对 $ 符号进行占位替换
三引号串支持多行，支持$ 占位替换（三双引号），在行末使用`\`可以取消换行符
`/`字符串是Slashy 字符串，支持多行，支持$ 占位替换。由于无需转义反斜杠，主要用于正则

支持转义字符，`\u` 开头的UNICODE字符
可以使用toCharacter() .toInteger() toLong() toFloat() .toDouble() toLong()等转换方法
可以用`+`操作符进行连接

#### GString 字符串
`$` 开头的.表达式
`${}` 包起来的表达式

表达式可以是分号分隔的语句，最后一句是其返回值，如果为空，则为null
也可以是一个单参数（默认可以省略）的闭包表达式，可以做到延迟解析的效果，即访问该字符串时才调用闭包进行解析

由于该字符串是可变的，所以其 hashCode() 也是可变的，所以不要作为map 的key

#### Slashy 字符串
```
/.*foo.*/
$/.*foo.*/$
```
前者转义符是`\`，后者转义符是`$`


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
aList + bList + c		// List 连接，相当于aList.plus(bList).plus(c)
aList += bList			// 连接回赋（会创建新列表）
aList - c				// 删除元素，相当于aList.minus(c)
aList - bList			// 差集
aList -= bList			// 删除回赋（会创建新列表）
aList.remove(1)			// 删除位置为1 的元素（返回该元素）
aList.pop()				// 删除第一个元素（返回该元素）
aList.intersect(bList)	// 交集
aList.disjoint(bList)	// 是否相交
aList.clone()
aList*n					// 多个重复List 进行连接等价于aList.multiply(n)
aList[10] = 100			//[5, string, false, null, null, null, null, null, null, null, 100]
aList.reverse()			// 逆序
aList.contains(5)		// 是否包含指定元素，等价于 5 in aList
aList.containsAll([5, 'string'])	// 都存在返回true
aList.indexOf('string')	// 返回指定元素的索引
aList.count('string')	// 返回指定元素的出现次数，也可以是一个闭包参数，则计数满足条件的次数
aList.sum([init])		// init 依次+ 上列表每个元素
aList.sort([key])		// 排序，可以传入一个闭包，返回用于比较的key
aList.max([comparator])	// 可以传入一个Comparator 做比较，Comparator 可以是一个闭包
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
aList.findIndexOf { cond }	// 返回满足条件cond 的第一个元素的索引
aList.findLastIndexOf { cond }	// 返回满足条件cond 的最后一个元素的索引
aList.every { cond }	// 都满足条件cond 返回true
aList.any { cond }		// 至少一个满足条件cond 返回true
```

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

#### Map
默认类型java.util.HashMap（java.util.LinkedHashMap）
可以直接使用`==` 判断相等
```
def eMap = [:]	// 空map
def map = [key1: "value1", key2: "value2", key3: "value3"]	// key 可以是int, String（不带引号默认转，若想获取变量的值作为key，则可以使用(key) ）
map.size()	// 元素个数
map.isEmpty()
map.keySet()
map.values()
map.entrySet()
map.key1	// map['key1']，相当于map.getAt('key1')
map?.key1	// 等价于if (map != null) map.key1
map.get("key1")
map.get("key4", 1)			// 若没有key4，则返回1，并将该kv 插入map
map.put("key4", "val4")		// 将key4:val4 放入map，返回key4 原来的val
map.containsKey("key1")
map.containsValue("values1")
map.remove('key1')
map.subMap(['key2', 'key3'])
map.clear()
map.each {
	// it.key
	// it.value
}
map.each { k,v ->
}
map.collect {}
map.find {}
map.findAll {}
map.any {}
map.every {}

Iterator it = map.iterator()
while (it.hasNext()) {
    println "遍历map: " + it.next()		// 遍历map: key1=value1
}
```

### 闭包
```
def aClosure = {paramters -> code}
aClosure.call("this is string",100)
//或者
aClosure("this is string", 100)
```
paramters 缺省时，有一个隐藏的参数it，指这个闭包本身

## 类型转换
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

// 定义生成类的实例属性（去掉def）

// 定义生成类的类成员
@Field s1 = "123"
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
`arg_list` 可空，多个逗号分隔，可以不指定类型，支持默认值
函数最后一行就是返回值，可以不使用return
单参数函数调用可以不加括号

## 类
```
class Name {
	def String name
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
```
所有成员默认都是public 的

## 包
```
package pk_name
```

## 表达式
```
name != null ? name : "abc"
// 可以简写为
name?: "abc"
```

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


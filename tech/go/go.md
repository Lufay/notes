# Go
[官方文档中文版](https://golang.org/doc/)
[官方文档中文版](https://go-zh.org/doc/)
[Go 指南](https://tour.go-zh.org/list)
[Go语言圣经](https://www.gitbook.com/book/yar999/gopl-zh/details)
[Go语言圣经(繁体)](https://www.gitbook.com/book/wizardforcel/gopl-zh/details)
[TOC]

## Go 概述
没有继承只有组合

Go 不允许定义变量而不使用，但可以用`_`，表示丢弃返回

## 数据类型
### 1. 基本数据类型
浮点类型： float32 (c中的float ), float64 ( c中的double ) 
复数类型: complex64, complex128(go中特有的) 
字符串： string (内置类型) 
字符类型: rune(Unicode字符类型), byte(UTF-8字符类型) 
golang中只支持UTF-8以及Unicode的编码，而对于其他的编码并没有内置的编码转换
UTF-8的编码是用byte这种类型来定义的，Unicode是用rune来定义的。
在字符串遍历的时候，如果使用range关键字，那么使用的是rune的形式来遍历的。而以数组取值的方式是byte的形式。

### 数组和slice
[]string
字符串数组

数组使用大括号初始化，实际上是值拷贝

#### 内建函数
copy(rsp.BookCoupon, req.BookCoupon)
把后一个复制给前一个

append(sinfo.healthyNodesOne, host)
把第二个元素追加到第一个数组最后

### map
`map[string]*NodeInfo`
字符串到NodeInfo指针的字典

#### 内建函数
value, ok := myMap["1234"]
访问返回是2个值，后者表示是否找到

delete(map容器，key值)
删除字典中的一个元素

### 类型转换
T(x)
如果T 比较长，可以加括号，即(T)(x)
Go语言要求所有统一表达式的不同的类型之间必须做显示的类型转换
普通类型变量向接口类型转换时是隐式的
接口类型之间的转换要看接口定义的包容性：如果包容，更多方法的接口可以向更少方法的接口进行隐式转换，反之则需要类型断言

## 运算符、表达式、语句
### 1 运算符和表达式
#### 1.1 赋值与销毁
var v1 int = 10  //最规矩的写法
var v2 = 10 //编译器自动推算v2类型
v3 := 10    //同时进行变量的声明和初始化工作，只能在函数体内使用
param := "topic=availableCoupons&pid=" + req.Pid  //赋值并分配空间

多个变量定义在一起
var {
    v1  int
    v2  string
}

常量定义
const (                     //iota被重设为0
        a = iota            //a = 0
        b = iota            //b=1
        c = iota            //c=2
)

##### 多元赋值
支持i , j = j, i

### 2 语句
#### 2.1 条件语句
```
if cond_expr {
	code_block
} else {
	code_block
}

if a:= 8; a > 2 {}
```
1. 无论语句体内有几条语句，花括号 {} 都是必须存在的
1. 左花括号 { 必须与 if 或者 else 处于同一行
1. 在if之后，条件语句之前可以添加变量初始化语句，使用 ; 间隔，该变量的作用域只在该条件的逻辑块中
1. 在有返回值的函数中，不允许将“最终的” return 语句包含在 if...else... 结构中

#### 2.2 选择语句
```
switch val_expr {
	case val1:
		code_block
	case val2:
		fallthrough
	case val3, val4:
		code_block
	default:
		code_block
}

switch {
	case cond_expr:
		code_block
	case cond_expr:
		code_block
}
```
1. 左花括号 { 必须与 switch 处于同一行
1. 单个 case 中，可以出现多个结果选项
1. 不需要break，只有使用fallthrough 语句才会继续执行紧跟的下一个 case
1. 可以不设定 switch 之后的表达式，而在case 中使用条件表达式，在此种情况下，整个 switch 结构与多个if...else... 的逻辑作用等同

#### 2.3 循环语句
```
for i := 0; i < 10; i++ {}
for i,j := 0,len-1; i < j; i,j = i+1,j-1 {}	// 支持多重赋值，不支持以逗号为间隔的多个赋值语句
for cond_expr {}

for {}		// 无限循环

for i, ele := range array {}	// 遍历数组

for k, v := range map {}	// 遍历字典

for v := range ch {}	// 读取管道，当管道为空，会阻塞循环，除非管道被关闭
```
1. 左花括号 { 必须与 for 处于同一行
1. 支持continue 和 break，还支持break TAG，直接跳出多层循环
注意，这里的i，ele，k，v都是在遍历开始时新分配的空间，而后在遍历时不断将数组或字典的当前元素拷贝到这两个空间

#### 2.4 跳转语句
goto label
在这里，标签(label)可以是除去关键字任何纯文本


## 函数
```
func f(var int) (result int)
```
普通函数，参数var是值传递，slice和map是传引用，命名返回值
命名返回值和未命名返回值的区别在于命名返回值在函数体中是可以真实访问到返回值变量，而未命名则只能在return时，将值赋给返回值变量（值拷贝）

defer 的时机就是在这个赋值和真正返回之前执行的，如果有多个defer，则后进先出依次执行

### 内建函数
```
func new(Type) *Type
```
用来分配内存，参数是一个类型，返回值是一个指向新分配类型零值的指针

```
make(type, count, capacity)
```
为 slice，map 或 chan 类型分配内存和初始化一个对象，返回类型的引用
type是分配空间的类型
count是分配的单元
capacity是预留的单元数

## 类型扩展
类型重命名并扩展（下面扩展了len()方法）
```
type name string
func (n name) len() int {
return len(n)
}
```

定义结构体及其方法
```
type Person struct {
	name string  //注意后面不能有逗号
	age  int
}
func (p Person) Name() string {
	return p.name
}
func (p *Person) GetAge( ) (int, error) {
	return p.age, nil
}
```
可以用p访问这个实例，参数列表为空，最后是返回列表
结构体实例的创建，可以使用new 内建函数，也可以使用大括号的方式（此种方式有2 种具体形式：按序给值，也可以按name-val 给值）

定义函数类型并扩展（下面扩展了add方法）
```
type handler func(name string) int
func (h handler) add(name string) int {
return h(name) + 10
}
```

定义接口
```
type IPerson interface {
	Run()
	Name() string
}
```
结构体和函数对象都可以实现接口（只需要实现其所有定义的方法即可）
```
var p IPerson
p = Person{"taozs", 18} //或者：&Person{"taozs", 18}
```
接口中可以包含其他接口，但不能递归包含
空接口interface{}，所有其它数据类型都实现了空接口
类型检测：
```
switch t := x.(type) {
	case int:
		code_block	// t has type int
	case *int:
		code_block
}
```
这里的每个case 不能写多个类型，否则就服务完成类型的转换（即还是接口类型）
类型断言 x.(T)
接口类型断言到具体类型
```
var p2 Person = p.(Person)	// 这种推断失败会先panic
p2, ok := p.(Person)		// 这种推断失败ok 为false，p2 为nil
```
想要把实例对象赋值给接口变量，必须该对象实现了所有接口的方法（不能是对象指针），但无论是对象指针还是对象实现了所有接口的方法，就可以把对象指针赋值给接口变量。


## 并发编程
goroutine
go 函数调用

### 管道
类似消息队列
var ch chan int
一个类型为int 的channel
ch <- a		// 写消息
<- ch		// 读消息
close(ch)	// 关闭将变成只读的管道

无缓冲读写都会阻塞，即会挂起当前的goroutine，除非另一端已经准备好
有缓冲，满才会堵塞写，空才会堵塞读

#### select
```
select {
	case chanStmt:
		code_block
	case chanStmt:
		code_block
	default:
		code_block
}
```
每个case 语句都是一个管道语句，无论是读、还是写
select 首先会对每个chanStmt，进行求值，顺序是自上而下、从左到右
都求值完毕后如果有一个或多个IO操作可以完成，则Go运行时系统会随机的选择一个执行；否则的话，如果有default分支，则执行default分支语句；如果连default都没有，则select语句会一直阻塞，直到至少有一个IO操作可以进行
select 中管道出现问题并不会报错，只不过不会走该case
如果使用一个空的`select {}`语句，则将永远阻塞线程
由于`code_block` 中可以使用break 跳出select，所以当select 外面套一个for 循环时，break 是无法跳出for 循环，这里就必须使用带标签的break，标记外层循环后break 该标记


## 包
package
[参考](https://golang.org/pkg/)

### 导入包
import
导入包并重命名：`import alias_name "pkg_name"`
如果为了避免导入包缺没有使用可以使用`_` 作为`alias_name`


## 测试
import "testing"
文件命名：`xxx_test.go`

### 测试命令
go test [options] [dir]
dir 是测试包所在目录
选项：
-v 测试详细信息
-c 编译go test成为可执行的二进制文件，但是不运行测试
-i 安装测试包依赖的package，但是不运行测试
-run="fileName"
-test.run pattern 只跑哪些单元测试用例（功能测试函数名）
-cover 测试对代码的覆盖率
-coverprofile 详细的覆盖率信息，输出到文件，并使用go tool cover来查看
-test.bench pattern 只跑哪些性能测试用例（不执行功能测试）
-test.benchmem : 是否在性能测试的时候输出内存情况
-test.benchtime t : 性能测试运行的时间，默认是1s
-bench="benchName"
-count=5 指定执行多少次
-cpuprofile="profileName"
-test.cpuprofile cpu.out : 是否输出cpu性能分析文件
-test.memprofile mem.out : 是否输出内存性能分析文件
-test.blockprofile block.out : 是否输出内部goroutine阻塞的性能分析文件
-test.memprofilerate n : 在内存性能分析时，设置分配了多少内存进行一次打点记录。默认是设置为511 * 1024的。如果设置为0，就不打点了。可以通过设置memprofilerate=1和GOGC=off来关闭内存回收，并且对每个内存块的分配进行观察。
-test.blockprofilerate n: 基本同上，控制的是goroutine阻塞时候打点的纳秒数。默认不设置就相当于-test.blockprofilerate=1，每一纳秒都打点记录一下
-test.parallel n : 性能测试的程序并行cpu数，默认等于GOMAXPROCS。
-test.timeout t : 如果测试用例运行时间超过t，则抛出panic
-test.cpu 1,2,4 : 程序运行在哪些CPU上面，使用二进制的1所在位代表，和nginx的nginx_worker_cpu_affinity是一个道理
-test.short : 将那些运行时间较长的测试用例运行时间缩短

### 功能测试
函数命名：
```
func TestXyz(t *Testing.T) {
	t.Log()			// 记录日志
	t.Logf()

	t.Parallel()	// 标记并发执行的测试函数
	t.Fail()		// 失败继续
	t.FailNow()		// 失败终止
	t.Error("Expected 5, got ", ret)	// 标记失败，记录错误，继续执行
	t.Errorf()
	t.Fatal()		// 失败退出
	t.FatalIf()
	t.Skip()		// 报告并跳过该case
	t.Skipf()
}
```

### 压力测试
函数命名：
```
func BenchmarkXyz(b *testing.B) {
	b.ReportAllocs()	//启用内存使用分析
	b.StopTimer() //调用该函数停止压力测试的时间计数，因为默认是打开计时的

    //做一些初始化的工作,例如读取文件数据,数据库连接之类的,
    //这样这些时间不影响我们测试函数本身的性能

    b.StartTimer() //重新开始时间，可以使用b.ResetTimer() 进行重置
	for i := 0; i < b.N; i++ {
		do_things()
	}
	b.SetParallelism(10) 制定并行数目
	var v Value
	v.Store(new(int))
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			x := v.Load().(*int)
			if *x != 0 {}
		}
	})
}
```
必须循环 b.N 次 。 这个数字 b.N 会在运行中调整，以便最终达到合适的时间消耗。方便计算出合理的数据。（ 免得数据全部是 0 ）

在使用-cpuprofile 等选项产生profile 文件和test 文件之后，还可以使用`go tool pprof aa.test cpu.profile` 在交互模式下查看性能
`go tool pprof --web aa.test cpu.profile` 进入web 模式
`go tool pprof --text mybin http://myserver:6060:/debug/pprof/profile`

### 样例测试
用来看运行中，输出的内容是否与预期的一样
示例函数需要归属于某个 包/函数/类型/类型 的方法，具体命名规则如下：
```
func Example() { ... }  # 被测试对象是整个包
func ExampleF() { ... }  # 被测试对象是函数F
func ExampleT() { ... }  # 被测试对象是类型T
func ExampleT_M() { ... } # 被测试对象是类型T的M方法

# 多示例函数 需要跟下划线加小写字母开头的后缀
func Example_suffix() { ... }
func ExampleF_suffix() { ... }
func ExampleT_suffix() { ... }
func ExampleT_M_suffix() { ... }
```
go doc 工具会解析示例函数的函数体作为对应 包/函数/类型/类型的方法 的用法。

### 用于测试的Main函数
```
func TestMain(m *testing.M) {
	// call flag.Parse() here if TestMain uses flags
	os.Exit(m.Run())
}
```

### setup or teardown
testing 并没有提供这样的函数，但可以通过Subtests 的方式来进行实现：
```
func TestFoo(t *testing.T) {
    // <setup code>
    t.Run("A=1", func(t *testing.T) { ... })
    t.Run("A=2", func(t *testing.T) { ... })
    t.Run("B=1", func(t *testing.T) { ... })
    // <tear-down code>
}
```
Run 方法的第一个参数是Subtests 的name，第二个参数是一个匿名方法，这个方法将在一个独立的goroutine 中运行，并block 住，直到所有并行Subtests 都执行结束。
```
go test -run ''      # Run all tests.
go test -run Foo     # Run top-level tests matching "Foo", such as "TestFooBar".
go test -run Foo/A=  # For top-level tests matching "Foo", run subtests matching "A=".
go test -run /A=1    # For all top-level tests, run subtests matching "A=1".
```
可以通过斜杠分隔的pattern，来指定执行Subtests，最后也可以有一个序数来避免混淆

如果想要一个全局的setup or teardown，可以使用TestMain，m 也有Run 方法

### 测试工具
#### 黑盒测试
testing/quick包实现了帮助黑盒测试的实用函数 Check和CheckEqual。

```
Check(f, config *Config)
```
第1个参数是要测试的只返回bool值的黑盒函数f，Check会为f的每个参数设置任意值并多次调用，如果f返回false，Check函数会返回错误值 `*CheckError`。
第2个参数 可以指定一个quick.Config类型的config，传nil则会默认使用quick.defaultConfig。quick.Config结构体包含了测试运行的选项。

CheckEqual函数是比较给定的两个黑盒函数是否相等，函数原型如下：
```
func CheckEqual(f, g interface{}, config *Config) (err error)
```

#### IO 相关
testing/iotest包中实现了常用的出错的Reader和Writer，可供我们在io相关的测试中使用。主要有：

触发数据错误dataErrReader，通过DataErrReader()函数创建
读取一半内容的halfReader，通过HalfReader()函数创建
读取一个byte的oneByteReader，通过OneByteReader()函数创建
触发超时错误的timeoutReader，通过TimeoutReader()函数创建
写入指定位数内容后停止的truncateWriter，通过TruncateWriter()函数创建
读取时记录日志的readLogger，通过NewReadLogger()函数创建
写入时记录日志的writeLogger，通过NewWriteLogger()函数创建

#### HTTP测试
net/http/httptest包提供了HTTP相关代码的工具，我们的测试代码中可以创建一个临时的httptest.Server来测试发送HTTP请求的代码:
```
ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
 fmt.Fprintln(w, "Hello, client")
}))
defer ts.Close()

res, err := http.Get(ts.URL)
if err != nil {
 log.Fatal(err)
}

greeting, err := ioutil.ReadAll(res.Body)
res.Body.Close()
if err != nil {
 log.Fatal(err)
}

fmt.Printf("%s", greeting)
```

还可以创建一个应答的记录器httptest.ResponseRecorder来检测应答的内容：
```
handler := func(w http.ResponseWriter, r *http.Request) {
 http.Error(w, "something failed", http.StatusInternalServerError)
}

req, err := http.NewRequest("GET", "http://example.com/foo", nil)
if err != nil {
 log.Fatal(err)
}

w := httptest.NewRecorder()
handler(w, req)

fmt.Printf("%d - %s", w.Code, w.Body.String())
```






每种类型对应的零值：
bool      -> false
numbers -> 0
string    -> ""

pointers -> nil
slices -> nil
maps -> nil
channels -> nil
functions -> nil
interfaces -> nil

struct，则结构中的每个成员的零值就是结构的零值。
slice有三个元素，分别是长度、容量、指向数组的指针
interface的底层实现由两部分组成，一个是类型，一个值。只有当类型和值都是nil的时候，才等于nil。当将任何类型的变量（除了nil本身）赋值给接口时，都将其类型和值分别赋予这两部分，只有当将nil赋值给接口时，接口才真正是nil




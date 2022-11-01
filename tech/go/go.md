[官方文档](https://golang.org/doc/)
[官方文档中文版](https://go-zh.org/doc/)
[Go 指南](https://tour.go-zh.org/list)
[Go语言圣经](https://www.gitbook.com/book/yar999/gopl-zh/details)
[Go语言圣经(繁体)](https://www.gitbook.com/book/wizardforcel/gopl-zh/details)
[An Introduction to Programming in Go](http://www.golang-book.com/books/intro)
<https://github.com/golang/go/wiki/CodeReviewComments>
[TOC]

# 概述
简洁、设计一致性：避免过度的复杂性

作为C 语音的继承者，没有纯粹的面向对象、没有继承多态，而是通过组合实现继承（当然也包括多继承）；通过隐式的接口实现，来进行多态编程
没有异常警告只有报错，基于结果检查进行错误处理
并行（多核）和分布式（集群化）的原生支持：
1. 协程：标准库所有系统调用（当然包括同步IO）都会让出CPU 给其他协程

先前，go代码文件都被组织成包(package)基于GOPATH进行管理，在1.11 版本引入module 概念后用以替换基于GOPATH 的管理方式，支持多版本共存（1.13版本以前Go Module默认关闭，需要设置GO111MODULE=on 打开）

不允许定义变量导入包而不使用，但可以用`_`，表示丢弃返回（也可以用于函数的多返回值中）

有gc

# 开始
设置环境变量GOROOT 为go 的安装目录（不是go 这个二进制的目录，而是bin 所在的目录）
设置环境变量GOPATH 为工作空间目录（该环境变量可以是多个目录，下载默认下载到第一个，而查找包则会按顺序依次查找）
版本查看`go version`

查看环境变量默认值`go env [ENVAR]`，若指定变量名则查看单个，若不指定则查看全部
可以使用`go env -w ENVAR=xxx` 修改环境变量默认值；也可以使用`go env -u ENVAR` 将修改的默认值进行重置
例如设置GoProxy：
```sh
go env -w GOPROXY="https://goproxy.xxx.org|https://goproxy.cn|direct"
go env -w GOPRIVATE="*.xxx.org,*.yyy.cn,git.zzz.com"
go env -w GOSUMDB="sum.golang.google.cn"
```
Go 1.15 支持了使用 ｜ 分隔符来分隔多个 proxy server，这样一个 proxy 如果报错，会自动 fallback 到下一个
GOPRIVATE 指定了不走官方proxy 的pattern


go 命令下有一系列子命令：
1. gofmt 代码格式化
可以使用`go fmt`对指定包中所有go 文件进行格式化，默认是当前目录
1. goimports 自动导入
可以根据代码需要自动生成和删除import
1. go get $gitPath
2. go get $module@v1.0.0
自动下载go 项目并安装（会安装到GOPATH指定的目录下）

## REPL
<https://github.com/motemen/gore>
<https://github.com/d4l3k/go-pry>

## 执行
直接使用`go run src.go` 就可以编译链接并执行该源文件
也可以使用`go build src.go` 将该源文件编译为可执行文件（静态编译，不用担心动态库的版本依赖问题）

`package main`这个包定义了一个独立的可执行程序，其中的main() 函数就是这个程序的入口，这个函数没有参数和返回值

## 代码文本
如果包含非ANSI 字符，需要保存为UTF-8 编码
编译器会自动在特定的行末尾加分号，所以行末的分号是不必要的
正因为于此，为避免错加分号，if/func 等的左大括号必须跟在行尾而不能独立成行，+/-/&&/|| 等二元连接符也必须在行尾，也不能另起一行
而一行的多条语句需要用分号分隔

## 注释
```go
// 行注释

/*
块注释
*/
```

## 打印
print(args ...Type): 内建的方法，相当于fmt.Print
println(args ...Type): 内建的方法，相当于fmt.Println

## 命令行参数
### os.Args
解决跨平台的问题
os.Args 是命令行参数的切片（类型是[]string）
第一个元素是命令本身，而后是参数列表

### flag 包
#### 命令行配置
##### 绑定变量
```go
// 第一个参数是选项名，第二个是默认值，第三个是说明信息，通过返回值接收（对应类型的指针）
ok := flag.Bool("ok", false, "is ok")
id := flag.Int("id", 0, "id")
prot := flag.String("port", ":8080", "http listen port")
// 第一个参数是接收的值（指针类型）
flag.BoolVar(&ok, "ok", false, "is ok")
flag.StringVar(&name, "name", "123", "name")
```
若没有指定参数，则返回nil

##### 设置usage
```go
flag.Usage = func () {
	fmt.Fprintf(os.Stderr, `nginx version: nginx/1.10.0
Usage: nginx [-hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

Options:
`)
	flag.PrintDefaults()	// 打印所有注册好的flag的默认值（默认写入标准错误输出，除非通过SetOutput()设置）
}
```
当使用-h 以及参数解析出错时调用

#### 命令行解析
`flag.Parse()`
当遇到单独的一个`-`/`--`或不是`-`开始的命令行参数时，会停止解析（`-`会被当做非flag参数，而`--`会当做flag 和非flag 的分隔符）

在解析完成后，可以使用以下函数：
NFlag()：返回用户指定了几个flag
NArg()：返回非flag 参数的个数
Args()：返回所有非flag 参数
Arg(i int)：返回指定位置的非flag 参数（i 从0 到NArg()-1）

#### 支持的格式
```
-h

-ok		# 仅支持bool 类型（表示-ok=true）
-id=1
--id=1
-id 1	# 仅支持非bool类型
--id 1
```
整数支持十进制、十六进制、八进制的正负数
bool类型可以是1, 0, t, f, T, F, true, false, TRUE, FALSE, True, False
Duration可以接受任何time.ParseDuration 能解析的类型

#### 创建自定义flag
实现flag.Value接口
而后就可以通过如下方式配置该flag：`flag.Var(&flagVal, "name", "help message for flagname")`，该flag的类型和值由第一个参数表示

```go
type Value interface {
    String() string
    Set(string) error
}

type Getter interface {
    Value
    Get() any
}
```

#### 其他函数
Set(name, value string)：设置已注册的flag的值
Lookup(name string)：返回指定name 的Flag 指针
`Visit(fn func(*Flag))`：按照字典顺序遍历用户设置的flag，并且对每个标签调用fn
`VisitAll(fn func(*Flag))`：按照字典顺序遍历配置的flag，并且对每个标签调用fn

```go
type Flag struct {
    Name     string // name as it appears on command line
    Usage    string // help message
    Value    Value  // value as set
    DefValue string // default value (as text); for usage message
}
```

### 第三方包
[command](https://github.com/polaris1119/command)
[goptions](https://github.com/polaris1119/goptions)
[urfave/cli](https://github.com/urfave/cli)
[spf13/cobra](https://github.com/spf13/cobra)


# 数据类型
## 1. 数值与布尔类型
+ 整数类型：默认推导为平台相关类型，且各种类型无法隐式转换，无法直接比较
  + 平台相关: int、uint, uintptr
  + 确定长度: int8, int16, int32、 int64, uint16, uint32、 uint64
+ 布尔类型：bool(true/false)，不能从其他类型转换
+ 浮点类型：float32 (C中的float ), float64 (C中的double，默认推导) 
+ 复数类型: complex64, complex128（默认推导）
  + a+bi == complex(a, b); a == real(z); b == imag(z)
+ 字符类型: rune（Unicode字符类型，即int32）, byte（UTF-8字符类型，即uint8）
golang中只支持UTF-8以及Unicode的编码，而对于其他的编码并没有内置的编码转换（可以基于iconv库用Cgo包装一个）
UTF-8的编码是用 byte 这种类型来定义的，Unicode是用 rune 来定义的。
在字符串遍历的时候，如果使用range关键字，那么使用的是rune的形式来遍历的。而以数组取值的方式是byte的形式。

### math 包、math/cmplx 包
Sqrt(f): 对浮点数求开方


## 2. 字符串 string
不可变字符串，初始化后不能改写内容
ch := str[0] 可以获取第一个字符(字节)，但不可写
len(s) 获取字符串长度(字节数)，在UTF8编码下，一个汉字对应三个字节，如果按unicode字符计算，可以使用utf8.RuneCountInString函数
s1 + s2 字符串连接
+= 会产生一个新字符串回赋

### strings 包
Count(s, sep)：在字符串s 中查找sep 串出现次数
Index(s, sep)：在字符串s 中查找sep 串首次出现的位置（找不到返回-1，sep 空串返回0）
IndexAny(s, chars)
IndexByte(s, c)
IndexRune(s, rune)：在字符串s 中查找rune 字符首次出现的位置（找不到返回-1）
IndexFunc(s, f func(rune) bool)
LastIndex(s, sep)：在字符串s 中查找sep 串最后一次出现的位置（找不到返回-1，sep 空串返回字符串长度）
LastIndexAny(s, chars)
LastIndexByte(s, c)
LastIndexFunc(s, f func(rune) bool)
Contains(s, substr)：在字符串s 中查找是否含有substr 串
ContainsAny(s, chars)：在字符串s 中查找是否含有chars 串中的任一字符
ContainsRune(s, rune)：在字符串s 中查找是否含有rune 字符
HasPrefix(s, prefix)
HasSuffix(s, suffix)

ToLower(s)、ToTitle、ToUpper
Cut(s, sep): 使用sep 将字符串s 前后两部分（按第一次出现sep 的位置）返回(before, after, found)，found 表示是否找到，若found=false，after=""
Fields(s): 使用空白符对s 分割为切片（会去除开头结尾的空白符）
FieldsFunc(s string, isSep func(rune) bool): 同上，差别是使用函数isSep 进行字符判定
Split(s, sp): 使用sp 将字符串s 分割为多个字符串切片
SplitN(s, sep, n): 切成n 块，若n 为负，则同上
SplitAfter(s, sep): 同上，只不过每块都带着sep
SplitAfterN(s, sep, n): 切成n 块，若n 为负，则同上
Join(strSeq, sp)：用字符串sp 把字符串切片strSeq 连接起来
Repeat(s, count)：重复count 次进行连接
Trim(s, cutset)、TrimLeft、TrimPrefix、TrimRight、TrimSuffix: 字符串s 收尾有cutset 中的字符都会被去除
TrimFunc(s, f func(rune) bool)、TrimLeftFunc、TrimRightFunc: 函数f 返回true 都被移除
TrimSpace(s): 去掉字符串收尾的空白符
Replace(s, old, new, n)：将字符串s 中的old 串替换为new，最多替换n 次，若n为负，则全部替换
ReplaceAll(s, old, new)
Map(mapping func(rune) rune, s string): 用函数mapping 对字符串每个字符进行替换，如果函数返回负值，则移除该字符

#### Builder
用于高效追加内容的字符串
零值就是空串

##### 方法
Cap()、Len()
Grow(n): 容量+n 字节（n 不能为负）
Reset(): 清空
String(): 返回字符串

Write(p []byte) (int, error): append返回len(p), nil
WriteByte(c byte): append 返回nil
WriteRune(r rune) (int, error): append返回len(r), nil
WriteString(s string) (int, error): append返回len(s), nil

#### Reader
实现了io.Reader, io.ReaderAt, io.ByteReader, io.ByteScanner, io.RuneReader, io.RuneScanner, io.Seeker, and io.WriterTo 接口
从内存读字符串，零值就是空串，可以使用`NewReader(s)` 初始化

##### 方法
Len()、Size()
Reset(s string): 重置读取的字符串
Read(b []byte) (n int, err error)
ReadAt(b []byte, off int64) (n int, err error)
ReadByte() (byte, error)
ReadRune() (ch rune, size int, err error)
Seek(offset int64, whence int) (int64, error)
UnreadByte() error
UnreadRune() error
WriteTo(w io.Writer) (n int64, err error)

#### Replacer
多重替换，获取`NewReplacer(oldnew ...string)`，参数必须是偶数个字符串，一个old 对应一个new
按序进行匹配命中，而且不会重复替换

##### 方法
Replace(s) 返回替换后的字符串
WriteString(w io.Writer, s string): 将替换后的字符串写入w

### unicode 包
IsLetter(c rune)
IsNumber(c rune)

### unicode/utf8、16、32 包
提供unicode 和 各种数据格式的转换

### strconv 包
ParseBool(str)：将字符串转为布尔值（字符串1、t、T、true、True、TRUE 为true，字符串0、f、F、false、False、FALSE 为false）
FormatBool(b)：将布尔值转为字符串"true" 或 "false"
ParseFloat(str, size)：字符串转浮点数（size 指定32 还是64）返回float64
ParseInt(str, base, size)：字符串转整数（base 是2 到36 进制，如果为0，则使用字符串前缀判断；size 是0:int, 8:int8, 16:int16, 32:int32, 64:int64）返回int64
ParseUint(str, base, size)：字符串转无符号整数，返回uint64
Atoi(str): 字符串转整数，返回(int, error)
Itoa(int_val): 返回str

## 3. 数组和 slice
数组长度和类型不可变，长度必须是一个常量表达式，比如`[10]string` 是长度为10的字符串数组，`[3][5]int`是一个二维数组（即3个`[5]int`），可以多维
并且是值类型拷贝（必须类型和长度相同才能相互赋值）
初始化：
+ `[5]string{"a", "b", "c"}` 未提供的值类型的零值（这里即为空串）
+ `[...]string{"a", "b", "c"}`长度推断为3
+ `[5]string{1:"a", 3:"b"}` 指定索引初始化

切片slice（比如`[]int`）是对底层数组的一段引用，并且同时拥有头指针head、长度len 和容量cap 三个属性，所以它是一种动态数组，其长度可以动态变化，由于其结构仅仅是指针结构，所以具有引用拷贝的语义。
获取切片的方式
1. 基于现有数组或切片：arr[m:n]，其中m 为起始索引缺省为0，n 为终止索引缺省为len(s)，最大可以取到cap(s)，不支持负索引。此种方式在数组空间足够的情况下，会直接操作该数组（即该数组就是底层存储），如果不够则会开辟新空间。
2. 基于数组字面值：`[]string{"a", "b", "c"}` 即去掉长度进行初始化（会有一个匿名数组被创建，即底层存储）
3. 使用make() 函数进行创建，元素均为0 值
4. 如果不初始化，也可以直接使用，只不过len=cap=0

### 操作
len(arr) 获取元素个数
cap(slice) 获取切片容量（对于数组使用则==len()）
arr[i] 访问单个元素，索引从0开始，不支持负索引


### 内建函数
append(slice, eles...)
向切片中添加一个或多个元素，也可以是一个切片后面跟`...`表示将该切片展开为多个元素，返回一个新的切片（若slice 底层cap 足够容纳eles，则返回的就是slice，否则将新分配一个空间拷贝进去数据返回）
不能对数组使用该函数

copy(dst, src)
把后一个复制给前一个，返回复制的元素个数
+ 如果是切片，则取两个最小长度进行复制

```go
new_s1 := append(s[:0], s[1:]...)
copy(s, s[1:])

new_s2 := s[:copy(s, s[1:])]	// 这样才能去掉尾部的多余元素
```
前两者对 s 的操作效果是一样的，都是后面的往前复制，并且他们都不会清理多出来的最后一个元素，也就是执行完上述操作，s 的len 和 cap 都不会变，只有内容会变化
而new_s1 和new_s2 则是完全一样的都是基于s 底层存储的一个新的切片

## 4. map
`map[keyType]valType`
kv无序字典结构，和切片一样，也具有引用拷贝的语义
keyType 是comparable类型，valType 可以是任意类型
非线程安全

在未初始化之前，不能使用索引读写
初始化方式：
1. make() 内置函数，可以指定初始化长度
2. 使用大括号：`{key1: value1, key2: value2,}` 最后一个元素后面可以保留一个逗号

### 内建函数
value, ok := myMap["1234"]
访问返回是2个值，后者表示是否找到

delete(map容器，key值)
删除字典中的一个元素，只需要确保该key 值不是nil，不用关系key 值是否存在

也可以使用len() 测量长度

## 5. struct
```go
struct {
	e eType
	//...
}
```
结构类型的定义就如同函数参数列表一样，名字-类型-顺序 三者组成了结构唯一性的标识，只要三者均相同就认为是相同类型，否则则不同（顺序之所以重要，是因为它决定了内存布局）
结构类型变量之间的赋值也是值拷贝

## 6. 函数对象
匿名函数（没有指定函数名）可以作为变量赋值给变量
其函数头就是该函数对象的类型（可以忽略参数和返回值的命名）
函数对象和字符串有些类似，相互赋值具有整体的值拷贝语义

## 7. 指针
`*type` 就是一个type 类型的指针
`*ptr` 可以获取指针内容，`&v` 可以获取变量的指针

指针的意义在于可以在值拷贝的语义下，能够修改原对象
结构体指针可以和结构体变量一样，直接调用属性和方法，而无须使用取内容操作`*`

## 8. 接口对象
接口对象可以接受任何满足接口规约的对象来赋值，并且接口可以自动基于类型的非指针方法推导出指针方法（反之不行）
接口一般都不使用指针，因为其可以承接任何类型，只要其实现了接口规约，因此，接口对象只能调用接口规约中的方法，而无法修改对象本身，即使承接的是指针
接口只包含方法签名，没有成员变量（接口也可以包含其他的接口和类型，表示类型规约）包含其他类型的接口只能用于泛型的类型规约中，不能定义变量
因此，一个接口就是一个规则集，多行取交集（即必须同时满足每一行的要求），行内的多个类型可以使用`|` 取并集（这些类型不能是带方法的接口）。那么，一个空接口，就是一个没有任何约束的规则集，也就是任何类型都可以满足

interface 的底层实现由两部分组成，一个是类型，一个值。只有当类型和值都是nil的时候，才等于nil。当将任何类型的变量（除了nil本身）赋值给接口时，都将其类型和值分别赋予这两部分，只有当将nil赋值给接口时，接口才真正是nil


```go
type Integer int
func (a Integer) Less(b Integer) bool {
	return a < b
}
// 上面方法可以自动推导生成：
func (a *Integer) Less(b Integer) bool {
	return (*a).Less(b)
}
```

## 9. 管道
chan EType，定义形式类似于指针，这种是双向的管道，使用make 进行初始化
chan<- EType，只写管道，用于接收一个管道变量（需要进行类型转换），并限定其行为
<-chan EType，只读管道，用于接收一个管道变量（需要进行类型转换），并限定其行为

管道的行为类似切片，赋值时具有引用拷贝的语义


## 衍生内建对象
### nil
它不是类型，而是一个预定义对象，它本身是无类型的，仅当赋值给有类型变量才具有类型

### error
```go
type error interface {
	Error() string
}
```
一般使用err 作为函数最后一个返回值，所以可以用其是否为nil 来判断返回是否出错
可以使用`errors.New("msg")`创建一个error 实例

```go
func panic(interface{})
func recover() interface{}
```
panic 函数用于抛出异常，会终止正常的程序流程，仅执行已经注册的defer 函数，直至所属goroutine 终止，而一个goroutine 以panic 结束，会导致整个程序崩溃
panic 抛出的异常信息（就是参数）可以使用recover 接收，因为异常处理流程，所以recover 一般在defer 的函数调用中使用

```go
defer func() {
	if r := recover(); r != nil {
		log.Print("")
	}
}()
```

## 类型转换
T(x)，T 不能是bool
如果T 比较长，可以加括号，即(T)(x)
Go语言要求所有统一表达式的不同的类型之间必须做显示的类型转换

普通类型变量向接口类型转换时是隐式的（只要实现了接口所有的方法）
接口类型之间的转换要看接口定义的方法集合是否包容：接口对象可以向其方法集合真子集的接口类型进行隐式转换，反之则需要类型断言

# 运算符、表达式、语句
## 运算符
每种数值或逻辑运算符都有对应的回赋运算符（例如+=）
但 i++, i-- 是语句（赋值语句）而不是表达式，且只支持后缀

### 位运算
支持`<<` `>>` `&` `|` `^`（单目是取反，双目是异或）

## 表达式
表达式可以求值，可以赋给变量或作为参数传递

## 语句
### 变量声明
变量会在声明时进行初始化
```go
var var_name type1  // 自动初始化为默认值（类型零值，例如0 和""）
var var_name type2 = val  // 初始化
var (
	v1 type1
	v2 type2
)
var var_name = val  // 初始化，用val 进行类型推断
var_name := val		// 短变量声明，只能在函数体内使用
```

#### 类型默认零值
bool    -> false
numbers -> 0
string  -> ""
array -> `[零值...]`，用零值填充满的数组
slices -> nil，也就相当于[]（len=0, cap=0）
maps -> nil，也就相当于map[]（len=0）
struct -> 结构中的每个成员的零值就是结构的零值
functions -> nil
pointers -> nil
interfaces -> nil
channels -> nil

### 常量&枚举定义
可以指定，也可以不指定类型（无类型常量）
不能赋值运行时才能求值的表达式
```go
const (         //iota被重设为0
	a = iota    //a = 0
	b     //b=1，这里和前一个表达式一致，所以可以缺省表达式
	c = 1 << iota    //c=4, iota 是一个可以参与运算的值
)
```

#### 多元赋值
支持 i , j = j, i

### 条件语句 if
```go
if cond_expr {
	code_block
} else {
	code_block
}

if a:= 8; a > 2 {}
```
1. 小括号可以无，大括号必须有
1. 左花括号 { 和 else 不可另起一行
1. 在if之后，条件语句之前可以添加变量初始化语句，使用 ; 间隔，该变量的作用域只在该条件的逻辑块中（类似于for 循环格式，只不过不需要步进条件）
1. 在有返回值的函数中，不允许将“最终的” return 语句包含在 if...else... 结构中

### 选择语句 switch
```go
switch val_expr {
	case val1:
		code_block
	case val2:
		fallthrough
	case val3, val4:	// 单个 case 中，可以出现多个结果选项
		code_block
	default:
		code_block
}

switch {	// 这里可以有一个初始化语句（用;结尾）
	case cond_expr:
		code_block
	case cond_expr:
		code_block
}
```
1. 小括号可以无，大括号必须有
1. 左花括号 { 不可另起一行
2. 不需要break（不带标签的break没有任何作用），只有使用fallthrough 语句才会继续执行紧跟的下一个 case
3. 可以不设定 switch 之后的表达式，而在case 中使用条件表达式，在此种情况下，整个 switch 结构与多个if...else... 的逻辑作用等同

### 循环语句 for
1. 迭代式：`for init; cond; step {`
1. 遍历式：`for index, val := range seq {`

```go
for i := 0; i < 10; i++ {}
for i,j := 0,len-1; i < j; i,j = i+1,j-1 {}	// 支持多重赋值，不支持以逗号为间隔的多个赋值语句
for cond_expr {}	// 省去init 和stop，即while条件循环
OUTER:
for {		// 全部省去，无限循环
	break OUTER
}

for i, ele := range array {}	// 遍历字符串、数组
for k, v := range map {}	// 遍历字典，v 可以缺省
for v := range ch {}	// 读取管道，当管道为空，会阻塞循环，除非管道被关闭
```
1. 小括号可以无，大括号必须有
1. 左花括号 { 不可另起一行
1. init 只能是短变量声明、赋值语句（含自增自减），函数调用
1. 如果i, k 并不会用到，可以使用`_` 作为占位符（可以用于语法上需要变量名，但该变量并不会被用到）
1. 支持continue 和 break，还支持break TAG，直接跳出多层循环（标签TAG 必须定义在for、switch 和 select 的代码块上）
注意，这里的i，ele，k，v都是在遍历开始时新分配的空间，而后在遍历时不断将数组或字典的当前元素拷贝到这些空间中

### 跳转语句
goto label
`label:` 可以放在本函数内的任意位置（独立一行） 
在这里，标签(label)可以是除去关键字任何纯文本


# 函数
```go
func func_name([params]) [(results)] {
	// func_body
}
```

params 是参数列表，逗号分隔，每个参数既可以是`arg arg_type`；也可以多个参数`arg1, arg2, arg3 arg_type` 连在一起写（连续形同类型）
参数var是值传递，slice和map是传引用

results 是返回值列表，支持多返回值，单个返回值可以不用加括号，多个需要加括号，用逗号分隔
每个返回可以只写类型（匿名返回值）也可以两者都有（命名返回值，已被声明为默认0值）
命名返回值和匿名返回值的区别在于：命名返回值在函数体中是可以直接赋值返回值变量进行返回（直接获取到返回值变量的引用）；而未命名则只能在return中，将值赋给返回值变量（值拷贝）

参数列表和返回列表中，当多个连续的类型相同时，可以省略前几个，只保留最后一个

不支持函数和运算符重载

## 变长参数
函数的最后一个参数，可以在类型前加上`...`，表示其是一个变长参数，在使用上和切片一致
相似的，在函数调用时，对于切片变量，可以后面跟上`...` 表示将该切片展开

## 闭包
有状态的函数对象
函数内定义的函数对象可以使用外层函数的变量（这种变量被称为自由变量），这种函数对象就是闭包

## defer
`defer 函数调用`
函数调用的参数是在当前位置进行绑定的，而执行时机是在计算完成其所在函数的返回值表达式之后；但对于命名返回值而言，由于命名返回值直接引用接受变量，所以若函数调用中修改该命名返回的值是会生效的
提供一种try-finally 机制，也就是一个上下文的回收
如果有多个defer，则逆序执行，即后指定先执行

## 内建函数
```go
func new(Type) *Type
```
用来分配内存，参数是一个类型，返回值是一个指向新分配类型零值的指针

```go
make(type, count, capacity)
```
为 slice，map 或 chan 类型分配内存和初始化一个对象，返回类型的引用
type是分配空间的类型
count是分配的单元
capacity是预留的单元数

# 类型派生
## 格式
### 定义类型
`type Tname BaseType`
type 关键字基于一种基础类型 BaseType 声明一种新类型
BaseType 可以是一种内建类型、匿名函数、struct组合结构、interface 组合接口

实例化方式：
```go
t := new(Tname)
t := &Tname{}	// 未进行显式初始化的变量都会被初始化为该类型的零值（false/0/空串）
t := &Tname{1, "foo"}	// 按序初始化必须提供所有field 的值
t := &Tname{id: 1, name: "foo"}	// 可以缺省部分字段
```
以上都是获取到该类型实例的指针
习惯上，通常会定义一个`NewTname(...) *Tname` 的函数用来当做一个初始化函数

### 定义方法
```go
func (obj Tname) method() {
}
```
对于一个类型，可以定义其值方法，也可以定义其指针方法
1. 对于值方法，由于存在自动的指针方法推演，所以，值方法既可以使用变量本身调用，也可以使用变量指针调用
2. 对于指针方法，一般只能使用指针进行调用，除非调用者是一个左值（即可以使用`&`取地址），那么左值也可以调用指针方法
综上：
1. 如果会修改调用者本身，必须使用指针方法
3. 若struct 中包含不可拷贝成员（比如sync.Mutex等），必须使用指针方法
2. 如果对象较大（值拷贝成本高），最好使用指针方法
4. 对同一个类，最好不用混用两者
5. 仅当调用者是不可变对象，或者本身就已经是指针（比如map/func/chan，以及不会扩缩容的slice）时，才推荐使用值方法

### 类型别名
`type TypeAlias = Type`
给别名添加方法，会影响到源类型，这一点不同于类型扩展
但是，编译器不允许给其他包的类型添加方法

类型扩展本质上和源类型是两种类型，变量需要进行类型转换，才能使用
类型别名则和源类型没有区别

## 例子
### 扩展内建类型
下面扩展了len()方法
```go
type Name string
func (n Name) len() int {
return len(n)
}
```

### 扩展函数对象
下面扩展了add方法
```go
type handler func(name string) int
func (h handler) add(name string) int {
	return h(name) + 10
}
```
### 定义结构体
```go
type Person struct {
	name string	 // 后面不能有逗号
	An  // 这里仅有一个结构类型而没有名字，是匿名成员，通过此种方式来实现继承，该结构的成员将展开平铺到这里（如果有重名，则以本地优先）
	age  int
}
func (p Person) Name() string {
	return p.name
}
func (p *Person) GetAge() (int, error) {
	return p.age, nil
}
```
结构体实例的创建，可以使用new 内建函数，也可以使用大括号的方式（此种方式有2 种具体形式：按序给值，也可以按name-val 给值）
结构体内组合的类型的方法都将被提升为该结构的方法，但调用时的接收者并没有变化
在继承结构的方法中，如果想要调用父类方法，可以显示的调用`p.An.Method()`，如果有多个父类有相同标识，则需要用类型加以区分`p.An.Identify`，即以类型名（去掉包名）作为成员名

### 定义接口
```go
type IPerson interface {
	Run()
	Name() string
}
var p IPerson = Person{"taozs", 18} //或者：&Person{"taozs", 18}
```
拥有相同方法的接口，无论其方法定义顺序如何，无论位置在哪都是等价的，所以没必要为了一个接口而引入一个包（也会引入更多耦合）
结构体和函数对象都可以隐式自动实现接口（只需要实现其所有定义的方法即可）

接口中可以包含其他接口，但不能递归包含


godoc 命令支持额外参数 -analysis ，能列出都有哪些类型实现了某个接口

#### 空接口interface{}
由于所有其它数据类型都实现了空接口
所以这种类型可以认为是最基本的类型，即object
该类型也可以直接写作any（`type any = interface{}`）

#### 类型检测和断言
可以通过类型检测来执行不同的逻辑：
```go
switch t := x.(type) {
	case int:
		code_block	// t has type int
	case *int:
		code_block	// t has type *int
	default:
		// t 没有成功初始化，可以直接使用x
}
```
这里的每个case 不能写多个类型，否则就服务完成类型的转换（即还是接口类型）

类型断言 x.(T)
接口类型断言到具体类型
```go
var p2 Person = p.(Person)	// 这种推断失败会先panic
p2, ok := p.(Person)		// 这种推断失败则ok 为false，p2 为nil
```
想要把实例对象赋值给接口变量，必须该对象实现了所有接口的方法（不能是对象指针），但无论是对象指针还是对象实现了所有接口的方法，就可以把对象指针赋值给接口变量。

# 泛型
go1.18 引入
<https://segmentfault.com/a/1190000041634906>

## 格式
```go
// 泛型函数
func FuncName[T TypeSpec1, U TypeSpec2](a T, b U) { ... }
FuncName(1, 2)	// 自动推断类型参数
FuncName[int](1, 3)		// 显式指定类型参数
// 泛型类型，源类型不能只是一个类型参数
type Slice[T int | float32 | float64] []T
// 泛型结构，不支持单纯的泛型方法，所有方法的类型参数必须放在结构上
type Stack[T comparable] struct {
	vals []T
}
func (s *Stack[T]) Method() T { ...}
type WowStruct[T int | float32, S []T] struct {		// 类型参数可以相互引用
    Data     S
    MaxValue T
    MinValue T
}
// 类型约束接口
type MyInt interface {
	int | int8 | int16 | int32 | int64
}
type MyInt interface {
	~int8		// 不仅支持int8, 还支持int8的衍生类型
	String() string // 还必须有一个方法
}
// 泛型接口
type Differ[T any] interface {
    fmt.Stringer
    Diff(T) float64
}
```
其中TypeSpec 就是对T 这个类型参数的一个约束，可以是一个类型或接口，也可以是使用`|` 进行组合（不能是带方法的接口，且各个类型不能有交集）
多个泛型参数使用`,` 分隔，称为类型参数列表，类型参数列表和名字一起构成了新的类型名，所以泛型不支持匿名函数 和 匿名结构
泛型使用`~`支持基于原生类型的派生（包括任意级派生），但`~` 后面只能是原生类型（可以是匿名结构，但不能是命名的结构类型），也不能是接口类型（无论是否命名）
由于语法解析的问题，类型约束无法直接写指针类型，这种可以加上`interface{}` 保住指针，比如：`interface{*int|*float64}`
另外，泛型类型定义的变量不同于接口变量，可以进行类型检测，只能使用反射或者将其传给接口变量才能根据不同类型进行不同操作。这样其实并不适合使用泛型。

go 内置了2个泛型接口：
+ any 也就是interface{}
+ comparable 就是所有内置的可比较类型（指的是支持`==`, `!=`操作）

# IO
## io 包
提供IO 的基本接口
```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}
```
os.File 同时实现了这两个接口（os.Stdin/Stdout/Stderr 是三个特殊的实例）
strings.Reader, strings.Builder 分别实现了 io.Reader 和 io.Writer
bufio.Reader/Writer 分别实现了 io.Reader 和 io.Writer
bytes.Buffer 同时实现了 io.Reader 和 io.Writer
bytes.Reader 实现了 io.Reader
compress/gzip.Reader/Writer 分别实现了 io.Reader 和 io.Writer
crypto/cipher.StreamReader/StreamWriter 分别实现了 io.Reader 和 io.Writer
crypto/tls.Conn 同时实现了 io.Reader 和 io.Writer
encoding/csv.Reader/Writer 分别实现了 io.Reader 和 io.Writer
mime/multipart.Part 实现了 io.Reader
net/conn 分别实现了 io.Reader 和 io.Writer(Conn接口定义了Read/Write)

io 包本身也有这两个接口的实现类型：
实现了 Reader 的类型：LimitedReader、PipeReader、SectionReader
实现了 Writer 的类型：PipeWriter

## fmt 包
+ Print(...any)：打印多个值（相当于使用%v），返回(打印的字节数, error)
+ Println(...any)：打印多个值，空格分隔，带换行，返回(打印的字节数, error)，对于struct 若实现了String() 方法，则调用之，否则，则逐个打印其成员
+ Printf(format, ...any)：按格式化字符串打印，返回(打印的字节数, error)
+ Sprint, Sprintln, Sprintf：返回格式化字符串
+ Fprint, Fprintln, Fprintf：第一个参数io.Writer，是输出目标

+ Scan(...any)：从标准输入读入空格或换行分隔的参数，返回(读入参数格式，error)
+ Scanln(...any)：从标准输入读入空格分隔的参数，返回(读入参数格式，error)，换行会终止读入，最后一个参数后面必须有换行或EOF
+ Scanf(format, ...any)：从标准输入按format 读入参数（换行也要匹配）（如果使用%c 会读入一个rune，无论是否是一个空白符）
+ Sscan, Sscanln, Sscanf：第一个参数是string
+ Fscan, Fscanln, Fscanf：第一个参数是io.Reader

+ Errorf(format, ...any)：返回格式化的error

### format
`%[flag][width][.][precision]verb`
width 缺省使用默认；precision 缺省，如果有. 为0，否则使用默认，其单位是Unicode code points
如果width 和precision 指定为`*`，则其值也从参数获得，也可以使用`[i]` 来指定使用第i 个参数
对于字符串和字节数组，precision 限制格式化的输入长度（截断格式化）
对于浮点数，%g 的precision 指定的是有效数位数，其他指定的是小数位数

#### flag
`#`	使用Go 语法格式打印
`+`	对于数字值始终打印正负号
`-`	左对齐（默认右对齐）
`0`	填充0（默认空格）

#### varb
varb 前可以指定`[i]`，来显式指定使用第i 个参数（后面如果不指定，则依次使用i+1, i+2, ...）
+ General
%v	使用值的默认格式（如果struct 需要带field 名字使用%+v）
%T	使用Go 语法格式打印类型
+ Boolean
%t	true or false
+ Integer
%b	base 2
%o	base 8
%d	base 10（默认）
%x	base 16, with a-f
%X	base 16, with A-F
%c	Unicode code point的字符表示
%q	使用单引号的字符字面值（Go 语法）
%U	Unicode format: U+1234; same as "U+%04X"
+ Float
%f	无指数表示 e.g. 123.456
%e	科学计数法, e.g. -1.234456e+78
%g	%e for large exponents, %f otherwise（默认）
%b	无小数部分的，指数为2 的幂的科学计数法e.g. -123456p-78
+ 字符串与字节切片
%s	输出字符串内容（默认）
%q	使用双引号的字符串表示（Go 语法）
%x	16 进制字符串表示（lower-case）two characters per byte
%X	16 进制字符串表示（upper-case）two characters per byte
+ Pointer, chan
%p	前缀0x 的16 进制表示
%b, %d, %o, %x, %X 都可以使用，即将指针当整数进行格式化

#### 说明
1. 对于复合类型的操作数，会递归打印
1. 如果操作数实现了Formatter接口，会调用该接口的方法。Formatter提供了格式化的控制。
1. 如果使用%#v，且操作数实现了GoStringer接口，会调用该接口。
1. 如果使用%s、%q、%v、%x、%X
	+ 操作数实现了error接口，Error方法会用来生成字符串
	+ 操作数具有String方法，这个方法将被用来生成字符串

1. scan %s %v 用在字符串时会读取空白分隔的一个片段
1. scan 可以使用width（表示最多使用多少个rune 生成一个字符串）不能使用precision 
1. scanf 多个连续的空白字符（除了换行符）在输出和输出中都被等价于一个空白符
1. 提供的所有操作数必须为指针或者实现了Scanner接口
1. Fscan等函数可能会在返回前多读取一个rune，这导致多次调用这些函数时可能会跳过部分输入。只有在输入里各值之间没有空白时，会出现问题

```go
type Formatter interface {
    Format(f State, c rune)
}

type GoStringer interface {
    GoString() string
}

type Stringer interface {
    String() string
}

type Scanner interface {
    Scan(state ScanState, verb rune) error
}
```

## bufio 包
### Reader
实现了io.Reader 接口

NewReader(rd io.Reader)：返回默认buffer 大小的Reader 指针
NewReaderSize(rd io.Reader, size int)：返回指定buffer 大小Reader 指针（若size 小于16，会被改为16）

#### 方法
以下的方法在遇到EOF 时，error 为 io.EOF
读到的[]byte 可以使用string(bs) 转换为字符串 

Read(p []byte)：读数据到p，返回(读到的字节数n, error)（0 <= n <= len(p)），只要缓存还有字节未读就会只读缓存，而不会调用底层Read，如果缓存为空，而p 的长度又大于缓冲长度，就跳过缓冲，直接使用底层Read 读数据到p
ReadByte()：返回读到的(byte, error)
ReadRune()：读一个UTF-8 编码的Unicode 字符，返回读到的(rune, size int, error)，第二个返回值是字符的字节数，如果编码出错，则消耗一个字节，返回unicode.ReplacementChar (U+FFFD)
ReadSlice(delim byte)：返回读到的([]byte, error)，直到遇到delim 为止（包括delim），该函数读出的是缓冲区的切片（可能被下一次IO修改），所以读取长度不能超出缓存，否则返回ErrBufferFull
ReadBytes(delim byte)：返回读到的([]byte, error)，直到遇到delim 为止（包括delim），该函数返回的是一个新的切片，如果超出缓存会多次调用ReadSlice，拼接结果后返回
ReadString(delim byte)：返回读到的(string, error)，直到遇到delim 为止（包括delim），该函数是对ReadBytes 的简单封装
ReadLine()：返回(line []byte, isPrefix bool, error)，line 不包含换行符（"\r\n" 或 "\n"）。如果一行超过缓冲区，isPrefix 为true，下次调用返回后续，isPrefix 为false，表示没有后续（该行结束）
UnreadByte()：将最近读出的一个字节放回缓冲区
UnreadRune()：将最近读出的一个rune放回缓冲区（如果最近的一次读操作不是ReadRune，将返回失败）
Size()：返回缓冲区的大小（字节数）
Buffered()：返回缓冲区已缓存的字节数
Discard(n int)：丢弃即将读的n 个字节（如果超出缓存则会调用底层Read读取更多数据而后再丢弃，可能多次调用），返回(已丢弃的字节数, error)，如果丢弃字节数少于n，则有error（如果0 <= n <= Buffered()，则本函数保证成功）
Peek(n int)：预取返回(即将读的n 个字节的切片, error)，但并不真的读（返回的是缓冲区引用，也就是说可以修改缓冲区，对后面的读操作有影响）。如果返回的字节数不是n，就有error，如果error 为ErrBufferFull，表示n 超过缓冲区大小
WriteTo(io.Writer)：实现io.WriterTo 接口，不断读数据写入，直到没有数据或发生错误，返回(写入的字节数, error)

### SplitFunc
函数签名类型
`type SplitFunc func(data []byte, atEOF bool) (advance int, token []byte, err error)`
用于Scanner 对输入进行分词的函数
这个包里有4个这个类型的函数
ScanBytes：每次一个字节
ScanRunes：每次一个UTF-8-encoded rune
ScanLines：每次一行并去掉换行符
ScanWords：每次一个空格分隔的词（空格可以通过unicode.IsSpace 设置）并去掉两边的空格

### Scanner
用SplitFunc 分词遍历，直到遇到EOF，IO error 和超长的分词（超出buffer）（能处理的最长分词长度为64k）
NewScanner(r io.Reader)：返回Scanner 指针

#### 方法
Split(SplitFunc)：设置一个分词函数，默认是ScanLines
Scan()：前进一个分词，返回是否成功前进，若成功可以调用Text 或Bytes 获取分词，失败可以使用Err 获取错误（遇到EOF除外）
Text()：返回当前string 分词（新分配的空间）
Bytes()：返回当前[]byte 分词（未分配空间，使用指针指向）
Err()

### Writer
实现了io.Writer 接口

NewWriter(w io.Writer)：返回默认buffer 大小（4096）的Writer 指针
NewWriterSize(w io.Writer, size int)：返回指定buffer 大小Reader 指针

#### 方法
Write(p []byte)：将p 中的内容写到缓冲区，返回(写的字节数n, error)，如果n < len(p) 就会返回错误说明
WriteByte(c byte)：写一个字节
WriteRune(r rune)：写一个Unicode code point，返回(size int, error)，size 是写入的字节数
WriteString(s string)：写一个字符串，返回(size int, error)，size 是写入的字节数
Flush()：将缓冲区中的内容刷写到目标
Reset(io.Writer)：丢弃未刷写的缓冲，清除错误，并重定位目标（缓冲区复用）
Buffered()：返回已经写入缓冲区的字节数
Available()：返回缓冲区还有多少字节未用
ReadFrom(io.Reader)：实现io.ReaderFrom 接口，不断读数据直到 EOF 或发生错误，返回(读入的字节数, error)，error 不包括io.EOF

**说明：
如果调用w 的Write 操作返回了一个错误，那Writer 就不会再进行写操作
如果写的字节数超出缓冲区，就不会缓存，直接调用底层w 进行Write**


### ReadWriter
实现了io.ReadWriter 接口
```go
type ReadWriter interface {
    Reader
    Writer
}
```

`NewReadWriter(*Reader, *Writer)`：返回ReadWriter 的指针


## io/ioutil 包
ioutil.Discard 支持io.Writer 接口

该包在go1.16 被弃用，函数被挪到io包和os包


# 并发编程
轻量级线程goroutine，可以轻松创建上百万个
格式：go 函数调用
如果函数调用有返回值也将被丢弃

在go1.5 之前，Go还不能很智能地去发现和利用多核的优势，默认会将所有goroutine 运行在一个核心上，可以通过GOMAXPROCS 这个环境变量控制使用多少个核心，或者在goroutine 启动前，调用`runtime.GOMAXPROCS(n)` 来设置使用n 个核心（可以通过`runtime.NumCPU()` 获得核心数）
在go1.5+ 会默认执行`runtime.GOMAXPROCS(runtime.NumCPU())` 以便最大效率地利用 CPU

## 管道
用于goroutine 间的同步和通信（推荐使用的同步方式，当然如果想要共享内存空间也可以使用sync 包进行读写锁的同步方式；如果跨进程通信可以使用Socket或HTTP等通信协议）
类似消息队列，其长度就是队列缓冲长度
`var ch chan int = make(chan int)`
一个类型为int 的channel
`ch <- a`		// 写消息，将变量写入管道，没有buffer 就会阻塞
`<- ch`			// 读消息，返回读取的内容，buffer 为空就会阻塞
`close(ch)`		// 关闭将变成只读的管道
`x, ok := <-ch`	// 如果ok == false，则表示管道已关闭

无缓冲读写都会阻塞，即会挂起当前的goroutine，除非另一端已经准备好，好处是不会有额外的数据拷贝
有缓冲，满才会堵塞写，空才会堵塞读

### select
用于异步IO
```go
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

#### 超时机制
管道没有超时设置，需要使用select 来构造出一种超时的机制
```go
timeout := make(chan bool, 1)
go func() {
	time.Sleep(1e9)		// 超时时间1秒
	timeout <- true
}()

select {
	case <-ch:
		// 超时前读取到数据
	case <-timeout:	// 	更简单的可以使用 <-time.After(10 * time.Second)
		// 超时返回
}
```

## 锁 和 同步
### sync 包
<https://pkg.go.dev/sync>
该包定义的变量，一旦使用都不可拷贝

接口Locker，方法是Lock() 和 Unlock()

#### Mutex 互斥锁
实现Locker 接口
获取锁: `&sync.Mutex{}`
其Lock() 和 Unlock() 方法可以保护共享资源
go1.18 引入TryLock() 方法如果加锁失败，不会block 而是返回false

#### RWMutex 读写锁
实现Locker 接口
其RLock() 获取到读锁，不会阻塞读，会阻塞写，对应的是RUnlock()
Lock() 就是写锁（相当于组合了Mutex），对应的是Unlock()
go1.18 引入TryLock()和TryRLock() 方法如果加锁失败，不会block 而是返回false

RLocker() Locker: 方法返回一个实例在调用Locker 的Lock() 和 Unlock() 实际上调用的是RLock() 和 RUnlock()

#### Cond 条件变量
获取：`&sync.Cond{L: locker}` 或者 `sync.NewCond(l Locker)`

##### 方法
Wait(): 该方法会首先c.L.Unlock()，然后挂起当前goroutine，直到被唤醒（Signal或Broadcast），再c.L.Lock() 后返回。因此典型的用法如下
Signal(): 唤醒一个等待在该条件变量上的goroutine
Broadcast(): 唤醒所有等待在该条件变量上的goroutine

```go
c.L.Lock()
for !condition {
	c.Wait()
}
// process
c.L.Unlock()
```

#### WaitGroup
跟Java的CountDownLatch 类似，让一组goroutine 等一个计数器清零才被唤醒
清零后并且没有wait的goroutine的WaitGroup 可以重复使用

##### 方法
Add(delta int): 增加计数器，delta当然可以使用负值，但计数器变为负值时，该方法会panic。所以该方法必须早于Done() 和 Wait()
Done(): 计数器-1
Wait(): 阻塞当前线程直到计数器归零 

#### Map
Go1.9 引入线程安全的map，读取、插入、删除都保持常数级的时间复杂度
其零值是一个空的 map

##### 方法
Load(key): 返回(val, ok)，ok 表示是否存在，如果不存在val=nil
Store(key, value): 保存指定k-v
Delete(key): 删除指定key
LoadOrStore(key, value): 返回(actual, loaded)，若key 存在，返回其val，loaded=true; 否则返回参数value 并保存，loaded=false
LoadAndDelete(key): 返回(val, loaded)，loaded 表示是否存在，相当于pop
Range(f func(key, value) bool): 使用函数f 遍历map，当函数返回false 则终止迭代

#### Pool
获取：Pool(New: func() any)
使用池化实例，可以减少GC（GC 时，实例会从local 移入victim 避免销毁）
池中的实例可以动态扩容缩容，因此，使用者应当假定池中实例均为初始态
通常在池中放置统一类型的实例，因为Go 没有泛型，所以这里用any

##### 方法
Get() any: 从池中随机获取一个实例（会从池中移除），如果池中没有实例，则使用New 函数返回一个
Put(x any): 将实例放回池中

#### Once
Do(f func()): 在多个goroutine 中仅执行一次f 函数
注意：
1. 这个函数和这个Once 变量是绑定的，换一个函数就需要新声明一个Once 变量
2. 如果f 函数panic，则也视为已经完成f 调用，其他goroutine 不会再调用f 了


```go
var once sync.Once
func setup() {
	// ...
}
func do() {
	once.Do(setup)	// setup 在所有调用do 的goroutine 中只会执行一次
	// 而且，所有调用do 的goroutine 都会阻塞直到这一次的setup 执行完之后，才会执行后面的代码
}
```

#### sync/atomic 包
##### 函数
+ AddT(a *t, d t) t: T 可以是Int32、Int64、Uint32、Uint64、Uintptr，对应的t 是int32、int64、uint32、uint64、uintptr
  对于非浮点数，如果想要做减法，比如a-5，可以使用`AddUint32(&a, ^uint32(5-1))`
+ CompareAndSwapT(val *t, old, new t) (swapped bool)：T/t 除了上面的5种外，还有Pointer，对应unsafe.Pointer。若*val==old，则返回false，否则*val=new，返回true
+ LoadT(a *t) t: T/t 和CompareAndSwapT 一样有6种，用于原子读，类似Java's volatile variables
+ StoreT(a *t, val t) t: T/t 和LoadT 一样有6种，用于原子写，类似Java's volatile variables
+ SwapT(a *t, val t) t: T/t 和LoadT 一样有6种，原子的写入新值返回旧值

##### Bool/Pointer[T]/Value
atomic bool/*T，0值为false/nil
Value 一旦Store，就不可复制

+ CompareAndSwap(old, new) (swapped bool)
+ Load() t
+ Store(val t)
+ Swap(new) old

##### Int32/Int64/Uint32/Uint64/Uintptr
atomic int32/int64/uint32/uint64/uintptr

+ Add(delta t) (new t)
+ CompareAndSwap(old, new) swapped
+ Load() t
+ Store(val t)
+ Swap(new) old

# 包 & 模块 & 库
[参考](https://golang.org/pkg/)
一个目录下的一个或多个go 文件组成，每个源文件都是以一条package 声明语句开始，通常包名和目录名一致，而生成可执行的包必须是`package main`，并且该包里有一个main() 函数
同一个包内的所有标识都拥有可见性
一个Go 库(repository)可以包含一个或多个模块（通常是一个）。一个模块(module)是多个相关联包的集合，在模块的根目录下有一个go.mod 文件会记录该模块下其他包的导入路径前缀，而模块外的导入就是模块路径前缀+包路径（标准库的包不需要模块路径前缀）。通常一个路径前缀就是repository 的路径去掉协议头（比如https://）
[参考go-cmp](https://github.com/google/go-cmp)

## 模块
### 创建一个模块
`go mod init <module-prefix>`

### 安装一个模块
执行`go install [<module-prefix>]`，就会将该模块进行编译成二进制文件，然后放入指定目录（若GOBIN 环境变量设置，则放入该目录；若GOPATH 环境变量设置，则放入该目录的bin 下（通过`go env GOPATH` 可以查看该环境变量的默认值）
若module-prefix 在GOPATH 的目录之下，则该命令可以在任意位置执行，否则则只能在模块的目录下执行（也就是go.mod所在的目录，当然在该目录下执行可以省略module-prefix）

### 查看当前模块
在模块的目录下（也就是go.mod所在的目录）执行：
go list: 返回当前模块的module-prefix
`go list -f '{{.Target}}'`: 返回当前模块的二进制目标

### 更新模块依赖
`go mod tidy` 可以自动扫描模块下的外部包的依赖，并下载，而后将其版本信息更新到go.mod 文件以及go.sum 文件
外部包的依赖会自动下载到`$GOPATH/pkg/mod`下
想要移除下载的模块可以使用`go clean -modcache`

由于go 默认使用https:// 协议下载外部包，而且下载过程中并不会提示输入username:password，所以可能会因此导致失败
有几种方案
1. 使用`GIT_TERMINAL_PROMPT=1`的环境变量设置，可以提示输入username:password
2. 增加~/.gitconfig 配置项：
```ini
[credential "https://code.baidud.org"]
    username = XXX
[url "ssh://XXX@git.baidud.org:29418"]
    insteadOf = https://git.baidud.org
[url "git@code.baidud.org:"]
    insteadOf = https://code.baidud.org/
```
第一个提供用户名，后两个将https:// 转换为ssh 方式
3. 

## 导入包
```go
import "fmt"	// stdlib, no module-prefix
// multi-import
import (
	"example/user/hello/morestr"	// module-prefix: example/user/hello, package: morestr
	"github.com/google/go-cmp/cmp"	// module-prefix: github.com/google/go-cmp, package: cmp
)
```

导入包并重命名：`import alias_name "pkg_name"`
如果为了避免导入包缺没有使用可以使用`_` 作为`alias_name`
gofmt 工具会按字母顺序对导入的包进行排序

## 访问权限
包内的大写字母开头的标识是对包外暴露的，其他则是对包外屏蔽的，仅能在包内访问

## 常用包
### os 包
Open(fileName): 打开文件，返回(file, error)，file 是os.File，若文件打开是吧，file 是nil
Create(fileName): 创建文件，返回(file, error)
Stat(fileName): 返回文件状态(stat, error), stat 是fs.FileInfo（io/fs包）

#### File 对象
##### 方法
Close() 关闭文件句柄，返回error
WriteString(s)
Readdirnames(n) file 必须是目录，返回目录下的文件名，最多返回n 个（若n<0，则返回全部），返回(fileNames, error)
Stat(): 返回文件状态(stat, error), stat 是fs.FileInfo

#### FileInfo 对象
是fs.FileInfo 的别名

##### 方法
IsDir(): 文件是否是目录
ModTime(): 文件修改时间
Mode(): 返回fs.FileMode
Name():
Size(): 返回文件大小

### time 包
Sleep(100 * time.Millisecond) 当前协程休眠，单位是1e-9 秒

Now(): 获取当前时间对象Time
Unix(timestamp, nanoseconds): 返回一个Time 对象，前者单位是秒，后者单位是1e-9 秒，最终结果是两者之和
Since(t Time): 返回Duration 对象，表示当前时间和t 之间的时间差（t 是过去的时间点）
Until(t Time): 返回Duration 对象，表示当前时间和t 之间的时间差（t 是未来的时间点）
After(d Duration): 返回一个只读管道<-chan Time，在过完时间后，将当前时间放入管道中

#### Time
##### 方法
Unix() int64: 返回时间戳（自 1970 年 1 月 1 日 UTC 以来经过的秒数）
Sub(t Time): 返回Duration 对象，表示两者的时间差
UTC(): 自身变为UTC 时间返回
Local(): 自身变为本地时间返回
Format(time.RFC3339): 按指定格式进行字符串化

#### Date
Date(year, month, day, hour, minute, second, ns, zoneinfo)
其中month、zoneinfo 可以使用time 包中定义的常量（比如time.September、time.UTC）

###### 方法
Unix(): 秒级时间戳
UnixNano(): 1e-9 秒级时间戳

### runtime 包
Gosched(): 主动出让时间片给其他goroutine
GOMAXPROCS(n): 调整goroutine 使用的核心数
NumCPU(): 获取核心数

### encoding/json 包
序列化：Marshal(&st) (bytes, error)
参数是序列化结构的指针（该结构需要在成员type 后面标注"name" 也就是映射到json 的key）
返回[]byte 和错误

反序列化：Unmarshal(bytes, &st) error
bytes 是[]byte，如果是string，可以进行强制转换
st 是一个struct 结构，只不过需要在成员type 后面标注"name" 也就是映射到json 的key


# 反射
import "reflect"

```go
s := reflect.ValueOf(&A{"aaa", 10}).Elem()
typeofT := s.Type()
for i := 0; i < s.NumField(); i++ {
	f := s.Field(i)
	fmt.Printf("%d: %s %s = %v\n", i, typeofT.Field(i).Name, f.Type(), f.Interface())
}
```

# Cgo
和C 语言进行交互
```go
import (
	"C"
	"unsafe"
)
cstr := C.CString("Hello, world.")
C.puts(cstr)
C.free(unsafe.Pointer(cstr))
```

# 测试
import "testing"
文件命名：`xxx_test.go`

测试代码中也能定义init函数，init函数会在引入外部包、定义常量、声明变量之后被自动调用，可以在init函数里编写测试相关的初始化代码

## 测试命令
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

## 功能测试
函数命名：
```go
func TestXyz(t *Testing.T) {
	t.Log()			// 记录日志
	t.Logf()

	t.Parallel()	// 标记并发执行的测试函数
	t.Fail()		// 失败继续
	t.FailNow()		// 失败终止
	t.Error("Expected 5, got ", ret)	// 标记失败，记录错误，继续执行
	t.Errorf("%d", ret)	//
	t.Fatal()		// 失败退出
	t.FatalIf()
	t.Skip()		// 报告并跳过该case
	t.Skipf()
}
```

## 压力测试
函数命名：
```go
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

## 样例测试
用来看运行中，输出的内容是否与预期的一样
示例函数需要归属于某个 包/函数/类型/类型 的方法，具体命名规则如下：
```go
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

## 用于测试的Main函数
```go
func TestMain(m *testing.M) {
	// call flag.Parse() here if TestMain uses flags
	os.Exit(m.Run())
}
```

## setup or teardown
testing 并没有提供这样的函数，但可以通过Subtests 的方式来进行实现：
```go
func TestFoo(t *testing.T) {
    // <setup code>
    t.Run("A=1", func(t *testing.T) { ... })
    t.Run("A=2", func(t *testing.T) { ... })
    t.Run("B=1", func(t *testing.T) { ... })
    // <tear-down code>
}
```
Run 方法的第一个参数是Subtests 的name，第二个参数是一个匿名方法，这个方法将在一个独立的goroutine 中运行，并block 住，直到所有并行Subtests 都执行结束。
```go
go test -run ''      # Run all tests.
go test -run Foo     # Run top-level tests matching "Foo", such as "TestFooBar".
go test -run Foo/A=  # For top-level tests matching "Foo", run subtests matching "A=".
go test -run /A=1    # For all top-level tests, run subtests matching "A=1".
```
可以通过斜杠分隔的pattern，来指定执行Subtests，最后也可以有一个序数来避免混淆

如果想要一个全局的setup or teardown，可以使用TestMain，m 也有Run 方法

## 测试工具
### 黑盒测试
testing/quick包实现了帮助黑盒测试的实用函数 Check和CheckEqual。

```go
Check(f, config *Config)
```
第1个参数是要测试的只返回bool值的黑盒函数f，Check会为f的每个参数设置任意值并多次调用，如果f返回false，Check函数会返回错误值 `*CheckError`。
第2个参数 可以指定一个quick.Config类型的config，传nil则会默认使用quick.defaultConfig。quick.Config结构体包含了测试运行的选项。

CheckEqual函数是比较给定的两个黑盒函数是否相等，函数原型如下：
```go
func CheckEqual(f, g interface{}, config *Config) (err error)
```

### IO 相关
testing/iotest包中实现了常用的出错的Reader和Writer，可供我们在io相关的测试中使用。主要有：

触发数据错误dataErrReader，通过DataErrReader()函数创建
读取一半内容的halfReader，通过HalfReader()函数创建
读取一个byte的oneByteReader，通过OneByteReader()函数创建
触发超时错误的timeoutReader，通过TimeoutReader()函数创建
写入指定位数内容后停止的truncateWriter，通过TruncateWriter()函数创建
读取时记录日志的readLogger，通过NewReadLogger()函数创建
写入时记录日志的writeLogger，通过NewWriteLogger()函数创建

### HTTP测试
net/http/httptest包提供了HTTP相关代码的工具，我们的测试代码中可以创建一个临时的httptest.Server来测试发送HTTP请求的代码:
```go
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
```go
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










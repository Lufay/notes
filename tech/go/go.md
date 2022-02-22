# Go
[官方文档](https://golang.org/doc/)
[官方文档中文版](https://go-zh.org/doc/)
[Go 指南](https://tour.go-zh.org/list)
[Go语言圣经](https://www.gitbook.com/book/yar999/gopl-zh/details)
[Go语言圣经(繁体)](https://www.gitbook.com/book/wizardforcel/gopl-zh/details)
[An Introduction to Programming in Go](http://www.golang-book.com/books/intro)
[TOC]

## 概述
简洁、设计一致性：避免过度的复杂性

没有继承只有组合
没有警告只有报错

不允许定义变量导入包而不使用，但可以用`_`，表示丢弃返回

## 开始
版本查看`go version`

go 命令下有一系列子命令：
1. gofmt 代码格式化
可以使用`go fmt`对指定包中所有go 文件进行格式化，默认是当前目录
1. goimports 自动导入
可以根据代码需要自动生成和删除import
1. go get $gitPath
自动下载go 项目并安装

### REPL
<https://github.com/motemen/gore>
<https://github.com/d4l3k/go-pry>

### 执行
设置环境变量`GOPATH` 为工作空间
直接使用`go run src.go` 就可以编译链接并执行该源文件
也可以使用`go build src.go` 将该源文件编译为可执行文件（静态编译，不用担心动态库的版本依赖问题）

main 这个包定义了一个独立的可执行程序，其中的main 函数就是这个程序的入口

### 代码文本
编译器会自动在特定的行末尾加分号，所以行末的分号是不必要的
正因为于此，为避免错加分号，if/func 等的左大括号必须跟在行尾而不能独立成行，+/-/&&/|| 等二元连接符也必须在行尾，也不能另起一行
而一行的多条语句需要用分号分隔

### 注释
`//` 行注释

### 命令行参数
#### os 包
解决跨平台的问题
os.Args 是命令行参数的切片（类型是[]string）
第一个元素是命令本身，而后是参数列表

#### flag 包
##### 命令行配置
###### 绑定变量
```go
// 第一个参数是选项名，第二个是默认值，第三个是说明信息，通过返回值接收（对应类型的指针）
ok := flag.Bool("ok", false, "is ok")
id := flag.Int("id", 0, "id")
prot := flag.String("port", ":8080", "http listen port")
// 第一个参数是接收的值（指针类型）
flag.BoolVar(&ok, "ok", false, "is ok")
flag.StringVar(&name, "name", "123", "name")
```

###### 设置usage
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

##### 命令行解析
`flag.Parse()`
当遇到单独的一个`-`/`--`或不是`-`开始的命令行参数时，会停止解析（`-`会被当做非flag参数，而`--`会当做flag 和非flag 的分隔符）

在解析完成后，可以使用以下函数：
NFlag()：返回用户指定了几个flag
NArg()：返回非flag 参数的个数
Args()：返回所有非flag 参数
Arg(i int)：返回指定位置的非flag 参数（i 从0 到NArg()-1）

##### 支持的格式
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

##### 创建自定义flag
实现flag.Value接口
而后就可以通过如下方式配置该flag：`flag.Var(&flagVal, "name", "help message for flagname")`，该flag的类型和值由第一个参数表示

```go
type Value interface {
    String() string
    Set(string) error
}

type Getter interface {
    Value
    Get() interface{}
}
```

##### 其他函数
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

#### 第三方包
[command](https://github.com/polaris1119/command)
[goptions](https://github.com/polaris1119/goptions)
[urfave/cli](https://github.com/urfave/cli)
[spf13/cobra](https://github.com/spf13/cobra)


## 数据类型
### 1. 基本数据类型
浮点类型： float32 (c中的float ), float64 ( c中的double ) 
复数类型: complex64, complex128(go中特有的) 
字符类型: rune(Unicode字符类型), byte(UTF-8字符类型) 
golang中只支持UTF-8以及Unicode的编码，而对于其他的编码并没有内置的编码转换
UTF-8的编码是用byte这种类型来定义的，Unicode是用rune来定义的。
在字符串遍历的时候，如果使用range关键字，那么使用的是rune的形式来遍历的。而以数组取值的方式是byte的形式。

### 字符串 string
多行字符串：反斜杠
s1 + s2 字符串连接
+= 会产生一个新字符串回赋

#### strings 包
Count(s, sep)：在字符串s 中查找sep 串出现次数
Index(s, sep)：在字符串s 中查找sep 串首次出现的位置（找不到返回-1，sep 空串返回0）
LastIndex(s, sep)：在字符串s 中查找sep 串最后一次出现的位置（找不到返回-1，sep 空串返回字符串长度）
IndexRune(s, rune)：在字符串s 中查找rune 字符首次出现的位置（找不到返回-1）
Contains(s, substr)：在字符串s 中查找是否含有substr 串
ContainsAny(s, chars)：在字符串s 中查找是否含有chars 串中的任一字符
ContainsRune(s, rune)：在字符串s 中查找是否含有rune 字符
Join(strSeq, s)：用字符串s 把字符串序列strSeq 连接起来
Replace(s, old, new, n)：将字符串s 中的old 串替换为new，最多替换n 次，若为-1，则全部替换

#### strconv 包
ParseBool(str)：将字符串转为布尔值（字符串1、t、T、true、True、TRUE 为true，字符串0、f、F、false、False、FALSE 为false）
FormatBool(b)：将布尔值转为字符串"true" 或 "false"
ParseFloat(str, size)：字符串转浮点数（size 指定32 还是64）返回float64
ParseInt(str, base, size)：字符串转整数（base 是2 到36 进制，如果为0，则使用字符串前缀判断；size 是0:int, 8:int8, 16:int16, 32:int32, 64:int64）返回int64
ParseUint(str, base, size)：字符串转无符号整数，返回uint64
Atoi


### 数组和slice
[]string
字符串数组

切片slice 是动态数组（长度动态变化）

数组使用大括号初始化，实际上是值拷贝

len(s) 获取元素个数
s[i] 访问单个元素
s[m:n] 获取子切片（m 缺省为0，n 缺省为len(s)）


#### 内建函数
copy(rsp.BookCoupon, req.BookCoupon)
把后一个复制给前一个

append(slice, ele...)
向切片中添加元素（可以一次添加多个），并返回一个新的切片
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
### 运算符
每种数值或逻辑运算符都有对应的回赋运算符（例如+=）
i++, i-- 是语句（赋值语句）而不是表达式，且只支持后缀

### 表达式
表达式可以求值，可以赋给变量或作为参数传递

### 语句
#### 变量声明
变量会在声明时进行初始化
```go
var var_name type  // 自动初始化为默认值（类型零值，例如0 和""）
var var_name type = val  // 初始化
var var_name = val  // 初始化，用val 进行类型推断
var_name := val		// 短变量声明，只能在函数体内使用
```

多个变量定义在一起
var {
    v1  type1
    v2  type2
}

常量定义
const (                     //iota被重设为0
        a = iota            //a = 0
        b = iota            //b=1
        c = iota            //c=2
)

##### 多元赋值
支持i , j = j, i

#### 条件语句 if
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
1. 在if之后，条件语句之前可以添加变量初始化语句，使用 ; 间隔，该变量的作用域只在该条件的逻辑块中
1. 在有返回值的函数中，不允许将“最终的” return 语句包含在 if...else... 结构中

#### 选择语句 switch
```go
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
1. 小括号可以无，大括号必须有
1. 左花括号 { 不可另起一行
1. 单个 case 中，可以出现多个结果选项
1. 不需要break，只有使用fallthrough 语句才会继续执行紧跟的下一个 case
1. 可以不设定 switch 之后的表达式，而在case 中使用条件表达式，在此种情况下，整个 switch 结构与多个if...else... 的逻辑作用等同

#### 循环语句 for
1. 迭代式：`for init; cond; step {`
1. 遍历式：`for index, val := range seq {`

```go
for i := 0; i < 10; i++ {}
for i,j := 0,len-1; i < j; i,j = i+1,j-1 {}	// 支持多重赋值，不支持以逗号为间隔的多个赋值语句
for cond_expr {}	// 省去init 和stop，条件循环
for {}		// 全部省去，无限循环

for i, ele := range array {}	// 遍历数组
for k, v := range map {}	// 遍历字典
for v := range ch {}	// 读取管道，当管道为空，会阻塞循环，除非管道被关闭
```
1. 小括号可以无，大括号必须有
1. 左花括号 { 不可另起一行
1. init 只能是短变量声明、赋值语句（含自增自减），函数调用
1. 如果i, k 并不会用到，可以使用`_` 作为占位符（可以用于语法上需要变量名，但该变量并不会被用到）
1. 支持continue 和 break，还支持break TAG，直接跳出多层循环
注意，这里的i，ele，k，v都是在遍历开始时新分配的空间，而后在遍历时不断将数组或字典的当前元素拷贝到这些空间中

#### 跳转语句
goto label
在这里，标签(label)可以是除去关键字任何纯文本


## 函数
```go
func func_name([params]) [(results)] {
	// func_body
}
```

params 是参数列表，逗号分隔，每个参数既可以是`arg arg_type`；也可以多个参数`arg1, arg2, arg3 arg_type` 连在一起写
参数var是值传递，slice和map是传引用

results 是返回值列表，逗号分隔，每个返回如果除了类型还写了返回变量名，就是命名返回值
命名返回值和未命名返回值的区别在于：命名返回值在函数体中是可以真实访问到返回值变量；而未命名则只能在return时，将值赋给返回值变量（值拷贝）

defer 的时机就是在这个赋值和真正返回之前执行的，如果有多个defer，则后进先出依次执行

### 内建函数
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

## 类型扩展
类型重命名并扩展（下面扩展了len()方法）
```go
type name string
func (n name) len() int {
return len(n)
}
```

定义结构体及其方法
```go
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
```go
type handler func(name string) int
func (h handler) add(name string) int {
return h(name) + 10
}
```

定义接口
```go
type IPerson interface {
	Run()
	Name() string
}
```
结构体和函数对象都可以实现接口（只需要实现其所有定义的方法即可）
godoc 命令支持额外参数 -analysis ，能列出都有哪些类型实现了某个接口
```go
var p IPerson
p = Person{"taozs", 18} //或者：&Person{"taozs", 18}
```
接口中可以包含其他接口，但不能递归包含
空接口interface{}，所有其它数据类型都实现了空接口
类型检测：
```go
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
```go
var p2 Person = p.(Person)	// 这种推断失败会先panic
p2, ok := p.(Person)		// 这种推断失败ok 为false，p2 为nil
```
想要把实例对象赋值给接口变量，必须该对象实现了所有接口的方法（不能是对象指针），但无论是对象指针还是对象实现了所有接口的方法，就可以把对象指针赋值给接口变量。


## IO
### io 包
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
strings.Reader 实现了 io.Reader
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

### fmt 包
+ Print(...interface {})：打印多个值（相当于使用%v），返回(打印的字节数, error)
+ Println(...interface {})：打印多个值，空格分隔，带换行，返回(打印的字节数, error)
+ Printf(format, ...interface {})：按格式化字符串打印，返回(打印的字节数, error)
+ Sprint, Sprintln, Sprintf：返回格式化字符串
+ Fprint, Fprintln, Fprintf：第一个参数io.Writer，是输出目标

+ Scan(...interface{})：从标准输入读入空格或换行分隔的参数，返回(读入参数格式，error)
+ Scanln(...interface{})：从标准输入读入空格分隔的参数，返回(读入参数格式，error)，换行会终止读入，最后一个参数后面必须有换行或EOF
+ Scanf(format, ...interface {})：从标准输入按format 读入参数（换行也要匹配）（如果使用%c 会读入一个rune，无论是否是一个空白符）
+ Sscan, Sscanln, Sscanf：第一个参数是string
+ Fscan, Fscanln, Fscanf：第一个参数是io.Reader

+ Errorf(format, ...interface{})：返回格式化的error

#### format
`%[flag][width][.][precision]verb`
width 缺省使用默认；precision 缺省，如果有. 为0，否则使用默认，其单位是Unicode code points
如果width 和precision 指定为`*`，则其值也从参数获得，也可以使用`[i]` 来指定使用第i 个参数
对于字符串和字节数组，precision 限制格式化的输入长度（截断格式化）
对于浮点数，%g 的precision 指定的是有效数位数，其他指定的是小数位数

##### flag
`#`	使用Go 语法格式打印
`+`	对于数字值始终打印正负号
`-`	左对齐（默认右对齐）
`0`	填充0（默认空格）

##### varb
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

##### 说明
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

### bufio 包
#### Reader
实现了io.Reader 接口

NewReader(rd io.Reader)：返回默认buffer 大小的Reader 指针
NewReaderSize(rd io.Reader, size int)：返回指定buffer 大小Reader 指针（若size 小于16，会被改为16）

##### 方法
Read(p []byte)：读数据到p，返回(读到的字节数n, error)（0 <= n <= len(p)，但遇到EOF 时，error 为 io.EOF），只要缓存还有字节未读就会只读缓存，而不会调用底层Read，如果缓存为空，而p 的长度又大于缓冲长度，就跳过缓冲，直接使用底层Read 读数据到p
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

#### SplitFunc
函数签名类型
`type SplitFunc func(data []byte, atEOF bool) (advance int, token []byte, err error)`
用于Scanner 对输入进行分词的函数
这个包里有4个这个类型的函数
ScanBytes：每次一个字节
ScanRunes：每次一个UTF-8-encoded rune
ScanLines：每次一行并去掉换行符
ScanWords：每次一个空格分隔的词（空格可以通过unicode.IsSpace 设置）并去掉两边的空格

#### Scanner
用SplitFunc 分词遍历，直到遇到EOF，IO error 和超长的分词（超出buffer）（能处理的最长分词长度为64k）
NewScanner(r io.Reader)：返回Scanner 指针

##### 方法
Split(SplitFunc)：设置一个分词函数，默认是ScanLines
Scan()：前进一个分词，返回是否成功前进，若成功可以调用Text 或Bytes 获取分词，失败可以使用Err 获取错误（遇到EOF除外）
Text()：返回当前string 分词（新分配的空间）
Bytes()：返回当前[]byte 分词（未分配空间，使用指针指向）
Err()

#### Writer
实现了io.Writer 接口

NewWriter(w io.Writer)：返回默认buffer 大小（4096）的Writer 指针
NewWriterSize(w io.Writer, size int)：返回指定buffer 大小Reader 指针

##### 方法
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


#### ReadWriter
实现了io.ReadWriter 接口
```go
type ReadWriter interface {
    Reader
    Writer
}
```

`NewReadWriter(*Reader, *Writer)`：返回ReadWriter 的指针


### io/ioutil 包
ioutil.Discard 支持io.Writer 接口


## 并发编程
轻量级线程goroutine
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


## 包
[参考](https://golang.org/pkg/)
一个目录下的一个或多个go 文件组成，每个源文件都是以一条package 声明语句开始

### 导入包
```go
import "pkg_name"
// multi-import
import (
	"pkg1_name"
	"pkg2_name"
)
```

导入包并重命名：`import alias_name "pkg_name"`
如果为了避免导入包缺没有使用可以使用`_` 作为`alias_name`
gofmt 工具会按字母顺序对导入的包进行排序


## 测试
import "testing"
文件命名：`xxx_test.go`

测试代码中也能定义init函数，init函数会在引入外部包、定义常量、声明变量之后被自动调用，可以在init函数里编写测试相关的初始化代码

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
```go
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

### 样例测试
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

### 用于测试的Main函数
```go
func TestMain(m *testing.M) {
	// call flag.Parse() here if TestMain uses flags
	os.Exit(m.Run())
}
```

### setup or teardown
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

### 测试工具
#### 黑盒测试
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




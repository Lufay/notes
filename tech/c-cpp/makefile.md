# Makefile

## 格式
支持使用`#` 进行行注释

每个规则（指令段）：
```
target ...: prerequisites
    command1
    command2
```
+ target 是该段的一个标的，如果target 指定的文件不存在或者它的修改时间早于prerequisites 中任何一个的修改时间，则执行该段代码（[特殊的目标](http://c.biancheng.net/view/7129.html)）
有一种特殊情况，就是target 指定的这个文件存在，但我实际并不想要使用它的情况做判断，这时候，我就需要声明这个target 是一个伪目标：`.PHONY : all clean`（声明伪目标要在该目标的规则定义之前）
+ prerequisites 是target 所依赖的一些标的（标的必须是存在的文件，否则必须在Makefile文件中有定义段），可以没有，多个用空格分隔，支持使用shell通配符（“?”、“*”、“[]”）
+ command 是要执行的shell 命令，**注意：command 必须使用Tab 制表符开头**，另外每一行command 就是一个子进程，两行之间的局部变量不互通，如果想要放到一个进程中，可以在行末使用`\` 进行行续接（命令要使用`;`分隔）
默认情况下，先回显一行命令，然后执行返回该行命令的结果，可以在command 开头使用`@` 不让该命令进行回显

### % 匹配
```
test:test.o test1.o
    gcc -o $@ $^
%.o:%.c
    gcc -o $@ $^
```
% 从匹配模式来说跟shell 下的`*` 是一致的（最长匹配），差别是，它会根据命中目标部分进行映射关联。具体的就是它首先命中test，然后执行`gcc -o test.o test.c` 然后命中test1，然后执行`gcc -o test1.o test1.c`

## 变量
### Makefile 变量
在Makefile 中`var=xxx` 可以定义，使用时，使用`$(var)`或`${var}`" `展开该Makefile 变量
*注意：如果xxx 中含有shell 通配符，在使用`$(var)`并不会立即展开通配符，此时需要使用wildcard 函数，比如：`var=$(wildcard *.c)`

和shell 变量一样，支持变量连接 和 $() 的嵌套解析

#### 内置变量
CC：C 编译程序
CFLAGS：C 编译参数
CXX：C++编译程序。
CPP：C程序的预处理器。
AR：库文件打包程序
MAKE：就是make
CURDIR：make的工作目录，可以使用-C 选项注入该变量
SHELL：就是解析命令的shell程序，默认/bin/sh

使用MAKE 嵌套调用其他Makefile 时，有些变量可以进行传递，其中内置的包括SHELL 和MAKEFLAGS（表示make的选项信息）
也可以使用`export <variable>` 把指定的变量进行传递，而后可以使用`unexport <variable>`取消

#### 自动化变量
`$@`	表示当前规则段的目标标的。若当前规则段有多个目标，则其表示当前命中的那个标的。
`$%`	仅当目标文件是一个静态库文件（Unix下是[.a]，Windows下是[.lib]）时，表示规则中的目标成员名。否则其值为空
`$^`	表示所有依赖标的的列表（会去重），以空格分隔。如果目标是静态库文件，它所代表的只能是所有的库成员（.o 文件）名。
`$+`	类似“$^”，但是它保留了依赖文件中重复出现的文件。主要用在程序链接时库的交叉引用场合。
`$<`	表示第一个依赖的标的。
`$?`	所有比目标文件更新的依赖文件列表，以空格分隔。如果目标文件时静态库文件，代表的是库文件（.o 文件）。
`$*`	在模式规则和静态模式规则中，代表“茎”。“茎”是目标模式中“%”所代表的部分（当文件名中存在目录时，“茎”也包含目录部分）。

GNU make 还额外加入字符 "D" 或者 "F"，用以处理包含路径的操作
`$(@D)`	表示文件的目录部分（不包括斜杠）。如果 "$@" 表示的是 "dir/foo.o" 那么 "$(@D)" 表示的值就是 "dir"。如果 "$@" 不存在斜杠（文件在当前目录下），其值就是 "."。
`$(@F)`	表示的是文件除目录外的部分（实际的文件名）。如果 "$@" 表示的是 "dir/foo.o"，那么 "$@F" 表示的值为 "dir"。
`$(*D)`
`$(*F)`	分别代表 "茎" 中的目录部分和文件名部分
`$(%D)`
`$(%F)`	当以 "archive(member)" 形式静态库为目标时，分别表示库文件成员 "member" 名中的目录部分和文件名部分。踏进对这种新型时的目标有效。
`$(<D)`
`$(<F)`	表示第一个依赖文件的目录部分和文件名部分。
`$(^D)`
`$(^F)`	分别表示所有依赖文件的目录部分和文件部分。
`$(+D)`
`$(+F)`	分别表示所有的依赖文件的目录部分和文件部分。
`$(?D)`
`$(?F)`	分别表示更新的依赖文件的目录部分和文件名部分。

#### 变量赋值
##### 即时赋值
`var := xxx`
这种赋值如果xxx 中包含其他变量的引用，会立即被展开

##### 延迟赋值
`var = xxx`
这种赋值如果xxx 中包含其他变量的引用，会延迟到使用var 时才会展开

##### 空赋值
`var ?= xxx`
这种赋值仅当var未定义时，才会赋值成功

##### 追加赋值
`var += xxx`
这种赋值可以在var 后面追加一个空格然后接上xxx

#### 变量内容替换
例如
`$(var:%.o=%.c)` 会将var 变量中匹配%.o 模式的部分替换为相应的%.c
`$(var:.c=.o)` 会将var 变量中的.o 替换为.c

## 内置函数
函数调用格式：`$(<function> <arguments>)`或者是`${<function> <arguments>}`
参数之间要用逗号分隔开

### 字符串处理

#### 字符串查找 findstring
参数表是`<find>,<in>`，在in 中找find，找到就返回子串

#### 模式滤取 filter / filter-out
参数表是`<pattern>,<text>`，pattern 可以写多个，filter返回所有命中的子串，filter-out 返回去除命中之后剩下的子串
#### 去空格 strip
去掉字符串的开头和结尾的字符串，并且将其中的多个连续的空格合并成为一个空格
#### 字符串替换 subst
参数表是`<from>,<to>,<text>`，把text 中的from 子串替换为to

#### 模式字符串替换 patsubst
参数表是`<pattern>,<replacement>,<text>`，即将text 中命中pattern 的内容替换为replacement（pattern 和replacement都可以使用%）

#### 列表取值 word
参数表为`<n>,<text>`，text 是一个空格分隔的列表，该函数返回第n个（列表从1开始）

#### 字符串排序 sort
将参数（用空格分隔的列表）按字母序排序

### 文件相关函数
<http://c.biancheng.net/view/7081.html>

### 逻辑函数
<http://c.biancheng.net/view/7095.html>

## 条件判断
ifeq	判断参数是否不相等，相等为 true，不相等为 false。
ifneq	判断参数是否不相等，不相等为 true，相等为 false。
ifdef	判断是否有值，有值为 true，没有值为 false。（这里有一种比较特殊的foo = $(bar)，则无论bar 是否为空，foo 都是有值的）
ifndef	判断是否有值，没有值为 true，有值为 false。

```
ifeq (ARG1, ARG2)
ifeq 'ARG1' 'ARG2'
ifeq "ARG1" "ARG2"
ifeq "ARG1" 'ARG2'
ifeq 'ARG1' "ARG2"
```

```
foo:$(objects)
ifeq ($(CC),gcc)
    $(CC) -o foo $(objects) $(libs_for_gcc)
else
    $(CC) -o foo $(objects) $(noemal_libs)
endif
```

## 路径搜索
Makefile 默认在同级目录下进行目标搜索
可以通过设置`VPATH := src car` 指定多个搜索的目录（依然会优先搜索当前目录，而后才是VPATH 指定的各个目录）

另外还可以使用关键字搜索 vpath
```
vpath PATTERN DIRECTORIES 
vpath PATTERN
vpath
```
PATTERN 是可以包含% 通配符，DIRECTORIES可以写多个空格分隔的目录
第一行表示配置一种匹配模式，满足模式的可以到这些目录去找
第二行表示清除一种匹配模式
第三行都是清除所有匹配模式

## 隐含规则
如果某个标的没有对应的指令段，该标的可以搜索到同名的源文件，并且标的和源文件之间能通过隐含变量指定的编译工具进行生成，那么就会自动生成这样一条隐含规则（指令段）
伪目标不会试图查看隐含规则，因此效率更高

## 包含其他Makefile
`include <filenames>` filenames 是 shell 支持的文件名（可以使用通配符表示的文件）
该命令相当于将对应文件的内容嵌入到当前的位置

查找文件的路径
1. 当前目录
2. -l 选项指定的目录
3. 系统目录："usr/gnu/include"、"usr/local/include" 和 "usr/include"

若找不到，会报告警告，然后尝试从规则中构建该文件
可以在include 前加上`-` 来忽略文件不存在或者是无法创建的错误提示（默认，Makefile 会在报错时退出，都可以使用`-` 去抑制错误，继续执行下面的代码）

## 执行
make 命令会默认选择Makefile 文件的第一个没有通配符的target 去执行
也可以使用`make $target` 去指定一个target 去执行

### 选项
[参考](http://c.biancheng.net/view/7126.html)
`-C $dir` 可以指定执行指定目录下的Makefile
-n        只命令回显，不执行
-s        所有命令都不回显
-j n      指定并发执行的命令数，默认是1（注意同一时间只能有一进程占用标准IO）
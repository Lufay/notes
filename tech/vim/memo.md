# Vim 小技巧备忘
[TOC]

## 命令行指代
`%` 当前文件的完整路径名
`%:h` 当前文件的所属目录
`%:t` 当前文件的文件名
`%:r` 当前文件的无扩展名的文件名
`%:e` 当前文件的扩展名

## 管理
### 窗口
1. 分屏打开vim
水平：vim -oN
垂直：vim -ON
N 是分屏的个数
1. 创建新窗口并打开文件
水平：`:new [file]` 或`:sp [file]`
垂直：`:vnew [file]` 或`:vsp [file]`
如果缺省file，new 会打开一个空白窗口；sp则打开当前文件，相当于Ctrl+w s/v
1. 关闭窗口
:close
Ctrl+w c
Ctrl+w q（最后一个窗口会关闭vim）
1. 只保留当前窗口
:only
1. 切换窗口
Ctrl+w w/h/j/k/l
1. 调整大小
Ctrl+w +/-/=
`:Nwinc+/-/</>`：N 是数字
1. 打开当前目录
:Ex[plore]
:Sex

### tab
tab 是一个page，在一个page里可以分割多个window

1. 新建tab 并打开文件：`:tabnew [file]` 或`:tabe [file]`
如果file 缺省，则打开一个空白tab
还可以用`:Ex`打开目录后，选择文件后按t，就可以在新的tab 中打开
1. 关闭Tab：`:tabc` 或`:q`
1. 切换Tab：`gt` 和`gT` 或 `:tabn` 和`:tabp`（后一个tab、前一个tab）
还可以用`Ngt` 或`:tabn N`，N 是tab page ID，可以直接跳到对应tab
1. 显示所有tab详情：`:tabs`

### buffer
每个打开的文件都对应了一个buffer，每个buffer都有一个特定的编号和名字
buffer 是所有window 和Tab 共享的的后台数据

1. 新建一个buffer：`:badd [file]`
1. 新建一个buffer 并在当前窗口打开文件：`:edit [file]`
1. 查看当前的buffers list：`:buffers` 或`:ls` 或`:files`
第一列是buffer id，第二列是状态（% 表示当前，# 表示次当前，a 表示active，即显示在窗口中），第三列是name（默认使用打开的文件名命名）
1. 切换当前窗口的buffer：`:b[uffer] [N]`
N 可以是buffer id；也可以是# 进行来回切换
1. 删除一个buffer：`:bdelete [N]`
N 可以是buffer id，如果缺省则默认是当前窗口的buffer
如果被删除的buffer 占用了一个窗口，且不是最后一个窗口，则窗口也关闭
1. 可以使用`:f name`命令给buffer 改名

### session
+ 会话信息中保存了所有窗口的视图，外加全局设置
+ viminfo信息中保存了命令行历史、搜索字符串历史、输入行历史、非空的寄存器内容、文件的位置标记、最近搜索/替换的模式、缓冲区列表、全局变量等信息

创建会话：`:mksession [file]`，如果文件名省略为Session.vim
会话文件中保存哪些信息，是由'sessionoptions' 选项决定的。缺省的'sessionoptions'包括"blank,buffers,curdir,folds,help,options,tabpages,winsize"，即当前编辑环境的空窗口、缓冲区、当前目录、折叠相关的信息、帮助窗口、所有的选项和映射、所有的标签页、窗口大小。
如果你使用windows上的VIM，并且希望你的会话文件可以同时被windows版本的VIM和UNIX版本的VIM共同使用的话，在'sessionoptions' 中加入'slash' 和'unix' ，前者把文件名中的’\’替换为’/’，后者会把会话文件的换行符保存成unix格式。
可以通过命令：`:set sessionoptions-=curdir` 和 `:set sessionoptions+=sesdir` 类似的进行增删
在你通过网络访问其它项目时，或者你的项目有多个不同版本（位于不同的目录），而你想始终使用一个会话文件时，你只需要把会话文件拷贝到不同的目录，然后使用就可以了。会话文件中保存的是文件的相对路径，而 不是绝对路径。
恢复会话：`:source [file]` 或 `vim -S [file]`

在VIM退出时，每次都会保存一个.viminfo文件在用户的主目录。之所以手动创建一个viminfo文件，因为缺省的.viminfo文件会在每次退出VIM时自动更新，谁知道你在关闭当前软件项目后，又使用VIM做过些什么呢？这样的话，.viminfo中的信息，也许就与你所进行的软件项目无关了。还是手动保存一个保险。
创建一个viminfo文件：`:wviminfo [file]`
保存哪些内容，以及保存的数目，由'viminfo' 选项决定
读入你所保存的viminfo文件，使用`:rviminfo [file]`
******

## 光标控制
| 快捷键 | 作用 |
|:---:|---|
| `^` 或0 |跳转到行首|
| `$` |跳转到行首|
| % |跳转到配对的括号|
| `[[` |跳转到代码段的开头|
|`<C-O>`|沿跳转记录回跳|
|`<C-I>`|沿跳转记录前跳|
| gD |跳转到局部变量的定义处|

### 书签标记
使用`mx`命令可以在当前光标行插入一个标记（x是A-Za-z的一个字母，不过小写字母的标记是文件级的，大写字母的标记是全局的）
`'x`或`` `x``命令可以快速跳转到标记的该行，另外，所有需要行号的命令位置，都可以使用该命令替代行号（差别是 ' 不记忆列，而是在第一个非空白字符，\` 可以调到原列）
`:marks` 显示所有设置的标记
`:delm x y z` 删除标记
有一些常用的自动标记：
`'` 或`` ` ``	光标上次停靠的位置
`.`	最近修改的位置
`"`	上次退出当前缓冲区时光标的最后位置（在普通模式下）
`^`	上次退出当前缓冲区时光标的最后位置（在插入模式下）
`[`	最近修改或拷贝位置的开头
`]`	最近修改或拷贝位置的结尾
`<`	最近可视化选择区的开头
`>`	最近可视化选择区的结尾
0-9	在 .viminfo 文件中设置

### 搜索
#### 行内搜索（单个字符）
fx      向后搜索下一个x字符（F是向前）
;       下一个
,       上一个

#### 快速定位光标所在的单词：
\*      向下查找
\#      向上查找

#### 忽略大小写
+ 设置
```
:set ignorecase		' 缩写ic
:set noignorecase	' 缩写noic
:set ignorecase smartcase	' 全小写字母则大小写不敏感，否则敏感
```

+ 单次
在模式前加上`\c` 则大小写不敏感，`\C` 则大小写敏感
******

## 编辑技巧
### 大段复制、移动
```
:m,n co d
```
m行到n行的内容复制到d行之后
co 换成 m 表示移动，d 表示删除

### 块注释
Ctrl+v 进入块选模式
选择你要注释的行
I 进行前插入
输入行注释

想要取消注释可以用块选删除注释符

### 有用的替换
1. 一行拆多行
:s/.../\r/g
其中多个空白符可以使用`\s\+`
1. 多行合一行
    + 空格分隔或不分隔
    J 可以合并当前行和下一行，并用一个空格分隔；如果不需要这个空格，可以使用gJ 命令
    :[m,n]join 命令可以一次合并多行，如果不想要分隔符，使用 :join!
	可以通过:set nojoinspaces 控制合并时的分隔符
    + 使用其他分隔符
    :[m,n]s/\n/.../
1. 滤除回车符“^M”
:%s/\r//g
或者^M 也可以使用Ctrl+v Ctrl+m 打出来
1. 删除所有空行
`:g/^\s*$/d`

### 大小写变换
guu		行变小写
gUU		行变小写
g~~		行大小写切换

guw		从当前位置到单词结尾变小写
gUw		从当前位置到单词结尾变小写
g~w		从当前位置到单词结尾大小写切换

也可以在可视模式下选择后使用u/U 进行大小写变换
******

## 设置
### 当前环境
```
:pwd	" 当前工作目录
:f		" 当前文件名（或Ctrl+g）
```
### vim 粘贴不缩进
```
:set paste
```
恢复：
```
:set nopaste
```
如果想要进一步设置开关快捷键：
```
:set pastetoggle=<F11>
```
即设置 F11 为开关快捷键，[参考](http://www.cnblogs.com/jianyungsun/archive/2011/03/19/1988855.html)

### 查看格式控制字符
```
set list
```
TAB 键显示为 ^I
换行符显示为 $
Windows 的CR 符显示为 ^M
******

## 键映射
设置`<Leader>` 键：`let mapleader = "\<Space>"`

map 命令
### 命令前缀
+ nore: 非递归映射，即不对映射内容进行递归映射
+ n: 普通模式生效
+ v: 可视模式(x)和选择模式(s)生效
+ i: 插入模式生效
+ c: 命令行模式生效
+ o: 操作符等待模式生效

默认在普通、可视、选择、操作符等待模式生效
map! 在插入和命令行模式生效
### 命令格式
`map {lhs} {rhs}`
就是把键系列 {lhs} 映射为 {rhs}，{rhs}可进行映射扫描，也就是可递归映射。
`unmap {lhs}`
取消键映射
`mapclear`
取消所有键映射

在{rhs}前面可以有一个特殊字符：
+ * 表示不可重映射
+ & 表示仅当本地脚本映射可以重映射
+ @ 表示一个本地缓冲区的映射

### 键表
`<k0>` - `<k9>` 小键盘 0 到 9
`<F0>` - `<F10>` 功能键 F0 到 F10
`<S-...>` Shift + 键
`<C-...>` Control + 键
`<M-...>` Alt＋键 或 meta＋键
`<A-...>` 同 `<M-...>`
`<D-...>` Command + 键
`<Esc>` Escape 键
`<Up>` 光标上移键
`<Space>` 插入空格
`<Tab>` 插入Tab
`<CR>` 等于`<Enter>`

### 特殊参数
这些参数置于map 命令之后，表示
`<buffer>`  映射只限于当前缓冲区（即当前文件）
`<silent>`  执行键绑定时不在命令行上回显
`<special>`  用于定义特殊键怕有副作用的场合
`<expr>`  {rhs} 会作为表达式来进行计算
`<unique>`  用于定义新的键映射或者缩写命令的同时检查是否该键已经被映射，如果该映射或者缩写已经存在，则该命令会失败
`<nowait>`
`<script>`
******

## 正则
支持分组引用
默认贪婪模式，在{m,n}中使用 {- 打头，表示非贪婪模式。

不支持POSIX字符类，但支持：
\d    匹配阿拉伯数字，等同于[0-9]
\D    匹配阿拉伯数字之外的任意字符，等同于[^0-9]
\x    匹配十六进制数字，等同于[0-9A-Fa-f]
\X    匹配十六进制数字之外的任意字符，等同于[^0-9A-Fa-f]
\l    小写字母 [a-z]
\L    非小写字母 [^a-z]
\u    大写字母 [A-Z]
\U    非大写字母 [^A-Z]
\a    所有的字母字符. 等同于[a-zA-Z]
\w    匹配单词字母，等同于`[0-9A-Za-z_]`
\W    匹配单词字母之外的任意字符，等同于`[^0-9A-Za-z_]`
\t    匹配`<TAB>`字符。
\s    匹配空白字符，等同于[ \t]。
\S    匹配非空白字符，等同于[^ \t]。
**注意：虽然 / 和 ? 不是元字符，但是搜索的命令，因此，如果被搜索字符串中含有该字符也需要转义（不过可以在 / 搜索中使用 ?，而在? 搜索中使用 / ）**

### 函数调用
`\=函数表达式` 可以调用line(".")、submatch(0)等函数

### 特别分组
不保存分组：`\%(atom\)`
固化分组：`\@>`

### 断言
+ 正预测先行断言：`\@=`
+ 负预测先行断言：`\@!`
+ 正回顾后发断言：`\@<=`
+ 负回顾后发断言：`\@<!`

### magic设定
vim的正则运行于4中模式
+ magic：标准正则模式，扩展正则元字符都需转义，否则只表示字面意。\m
+ nomagic：弱正则模式，除^$外的元字符都需要转义。\M
+ very magic：扩展正则模式。\v
+ very nomagic：无正则模式，所有字符均为文本意。\V
默认magic模式，除了使用set magic这样进行统一处理外，还可以在搜索命令 / 使用\m等，表示一次使用。
******

## 其他
### 重新加载打开的文件：
```
:e
```
如果后面加 ! 表示放弃当前修改，而重新加载

### 查看二进制文件
```
vi -b bin_file
:%!xxd
:%!xxd -r
```
可以16 进制查看编辑，-r 可以转回来
如果只是想查看的话，可以直接使用命令`xxd -b bin_file`

### 自动调整缩进版式：
先将光标移到自动调整的起始位置（例如：gg，nG）
点 =
再将光标移到自动调整的终止位置（例如：nG，G）

### 多粘贴板
用`:reg`命令可以查看各个粘贴板里的内容
其中
"" 是默认的vim粘贴板，直接使用 d/y/p 命令都从这里存取（最近一次）
"0 是复制粘贴板，即 y 命令存入这里
"1 是剪切粘贴板，即 d 命令存入这里
"0 到 "9
"a 到 "z
"A 到 "Z
"- 是行内剪切板
以下只读：
": 是最近执行的命令
". 是最近插入文本
"% 是当前文件名
"# 是当前交替文件名
"/ 是最近搜索的模式
选择与拖拽（非GUI版本的vim，不可用）：
"\*
"+ 系统粘贴板，可以用Ctrl+v粘贴到外部或者外部Ctrl+c复制到这里
"~
系统粘贴板可用时，可与外部应用交互
黑洞：
"\_ 不存储，直接丢弃

如果要使用其他粘贴板，只需在命令前带上粘贴板的板号即可（例如"a）

### 打开文件并定位到某一行
```
vim filename +n
```

### 其他
[垂直对齐线](http://www.oschina.net/code/snippet_574132_13357)
<http://www.tuicool.com/articles/f6feae>
<http://blog.chinaunix.net/uid-128922-id-289967.html>








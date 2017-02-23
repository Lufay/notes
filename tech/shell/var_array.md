# shell 变量
[TOC]

shell变量可分为两类：局部变量和环境变量。  
局部变量只在创建它们的shell中可用。  
环境变量则可以在创建它们的shell及其派生出来的任意子进程中使用。

变量的命名规范同C，任何其他的字符都标志着变量名的终止（包括空格，=），大小写敏感  
**注意：给变量赋值时，等号周围不能有任何空白符。为了给变量赋空值，可以在等号后跟一个换行符。**


## shell 字符串
shell 下默认的类型就是字符串，而引号仅仅是移除shell的meta字符的特殊含义

### meta 字符
```
|  &  ;  <  >  (  )  $  `  \  "  '  <space>  <tab>  <newline>
```
部分环境下的meta字符
```
*   ?   [   #   ˜   =   %
```

### 转义符
这种移除特殊含义的功能还可以通过`\`转义实现，只不过转义只能移除其后一个字符的特殊含义。  
如果该字符没有特殊含义，则该字符保留，`\`则不会保留；  
而且`\`转义还有一个例外，就是如果`\`是在一行的末尾，即转义的是`<newline>`，那么它表示的是续行，而不是字符串的换行，即该字符串会将两行连接为一行。

### 双引号
被双引号引起来的字符串，除``$  `  \  !``外均被转义（注意，不支持`\n`之类的控制字符，不过因为引号引的所有字符都原样保留，包括`<newline>`，所以，可以直接换行）  
``$ ` ``保持其原意，进行变量替换或命令执行结果的替换；  
`!`，将使用history 中的命令记录进行替换；  
`\`，仅当在以上三字符以及`"`字符之前才保持转义功能，即将这四种字符转义为文本，除此之外，该字符都作为普通字符保留在字符串中

### 单引号
被单引号引起来的字符串，所有meta字符均被转义  
不过有一种特殊的用法用以解决不支持`\n`之类的控制字符的问题  
就是在单引号字符串前加上`$`，即形如`$'string'`，则string中的ANSI C 标准的控制字符都会生效  
而双引号字符串前加上`$`，其转换方式则取决于当前的locale。如果当前的locale是C 或 POSIX `$`就会被忽略。

### 字符串变量
当将字符串赋值给变量，如果直接echo这个变量，该变量会被解析为直接的字符串从而进行显示，而字符串中的换行会作为一个空格进行显示，要想显示为一个换行，就将这个变量用双引号引起来

### 引用格式
`$var` 和 `${var}`：直接引用字符串，由于shell 直接将字符串连在一起写就是连接操作，所以后一种写法更能将变量名和其他内容隔开  
`${#var}`：返回字符串长度  
`${var:start}` 和 `${var:start:len}`：字符串子串，从start 位置开始（首个字符位置为0），长为len 的子串（缺省则到串尾）；start可以是0-x，表示从倒数第x 个字符开始，len 可以是负数，表示到串尾最后-len 个字符不要  
`${var:-newstr}` 和 `${var:=newstr}`：如果变量未定义或为空，则返回newstr（后者还会回赋给变量）；否则返回变量值。  
`${var:?newstr}`：如果变量未定义或为空，则本语句失败，并将newstr写入stderr；否则返回变量值。  
`${var:+newstr}`：如果变量非空，返回newstr，否则返回空串  
`${var#str}` 和 `${var##str}`：ltrim 操作，表示从字符串中去除匹配str的部分返回，str 可以使用`*`进行模糊匹配，前者是最少字符匹配模式，后者是贪婪模式  
`${var%str}` 和 `${var%%str}`：rtrim 操作，同上  
`${var/substr/newstr}` 和 `${var//substr/newstr}`：将字符串中的substr（可以使用通配符）替换为newstr，前者只替换一次，后者全部替换  
`$((expression))` 和 `$[expression]`：expression是整数的算术表达式（变量var可以不带`$`进行引用），返回算术表达式计算的值  
`$(cmd)` 和`` `cmd` ``：返回命令cmd 执行标准输出的字符串

## shell 整数
### 定义变量
```
declare -i var[=expression]
```
这样和以后对var赋值，shell 会将expression 作为算术运算表达式解析将结果赋值给var
解析方式是将合法的字符序列当做变量，未定义则当做0，如果表达式解析失败将报错。特别的，还支持其他进制数字的解析，格式为`base#num`，则shell会将num按base进制进行解析，另外和C 一样，以0 开头的数表示八进制数，以0x 开头的数表示十六进制数。
实际上，shell 并没有字符串之外的其他类型，这样定义仅仅是在赋值时，对赋值表达式进行特殊解析。

### let 命令
```
let var1=exp1 [var2=exp2] ...
```
exp 支持`+ - * / % = += -= ++ -- **（幂）` ，其中整数数表达式中的变量不用`$`引用

和`declare -i`的区别是，`declare -i`定义的变量在赋值时总是按照算术表达式解析，而let 命令仅在当次赋值按算术表达式解析

### expr 命令
```
expr expreesion
```
#### 整数运算
支持 `+ - * / %`
如果试图计算非整数，则会返回错误
注意：
1. `*`需要`\`转义，如果使用括号也要转义；
2. 数字和运算符需用空格分隔，否则视为一个整体

#### 逻辑运算
```
ARG1 \& ARG2
ARG1 \| ARG2
```
`& |`都需要转义
非0为真，0和空为假
对于`&`，如果两个参数都是真，则返回ARG1；否则返回0
对于`|`，如果ARG1 为真则返回之，否则返回ARG2

#### 比较运算
`= > < >= <= !=`
其中`<`和`>`都需要转义，若两边都是整数则做整数比较，否则做字符串比较

#### 模式匹配
```
str : re
```
str 为待匹配串，re 为正则串（BRE）
正则串必须能从str 的第一个字符开始匹配，所以^是普通字符，返回成功匹配的字符个数，如果正则串中使用`\(...\)`，则返回括号中匹配命中的字符串

#### 扩展（非标准）
##### 字符串长度
```
expr length "this is a test"
```

##### 提取子串
```
expr substr "this is a test" 3 5
```
从第3个字符，长为5个字符的子串

##### 查找字符首次出现位置
```
expr index "testforthegame" e
```
其中e 也可以是字符串，只不过表示集合的含义，表示其中任一字符的首次出现

### bc 命令
支持任意精度的浮点运算
其本身类似于awk，是一个命令解释器
```
bc [options] [files]
```
bc 会安装files 各文件的顺序依次处理各个文件中的命令，当所有文件处理完后，（如果没用终止处理的话）再接受stdin 输入进行处理
#### 选项
-q：不输出提示信息
-l：需要使用强大的数学库，比如计算三角函数
#### 语法细节
quit 命令退出处理（或者在stdin 中输入Ctrl+D终止）

数字支持任意精度，计算和表示都是通过十进制完成，每个数字都有2个属性：length（有效数字长度）scale（小数点精度）
16进制数必须使用大写字母
字符串使用双引号，其中的字符都原样保存，包括换行符

支持普通变量和数组，命名规范是字母开头，后面可以是字母、数字、下划线；数组后面跟`[]`。字母必须是小写。
有几个特殊变量：
scale：计算保留小数点精度，例如scale=2，则小数点后保存2位（默认为0，最大支持C整数的最大值）
ibase：设置输入整数进制（默认十进制，支持2 到16）
obase：设置输出的进制值（默认十进制，支持2 到`BC_BASE_MAX`，大于16进制可能引入多个数字表示一个数位）
last：非标准，是扩展，保存最近一次打印的值

支持C 语言的注释（注释将被视为一个空格）
扩展语法中，还支持`#`开头的单行注释

支持C 语言的所有的算术和算术赋值运算符（特别的，`^`表示乘方，支持整数幂）  
支持C 语言的所有的关系和逻辑运算（0 表示 false，1 表示 true）  
注意：优先级和C 语言不大相同，比如赋值比关系和逻辑运算都高  
> The expression precedence is as follows: (lowest to highest)  
> 	  || operator, left associative  
> 	  && operator, left associative  
> 	  ! operator, nonassociative  
> 	  Relational operators, left associative  
> 	  Assignment operator, right associative  
> 	  + and - operators, left associative  
> 	  *, / and % operators, left associative  
> 	  ^ operator, right associative  
> 	  unary - operator, nonassociative  
> 	  ++ and -- operators, nonassociative  

内置函数：
+ length ( expression )：有效数字长度
+ scale ( expression )：小数点精度
+ sqrt ( expression )：开方
+ read ( )：非标准，是扩展，从stdin 读入一个数字
数学函数：
> s (x)  The sine of x, x is in radians.  
> c (x)  The cosine of x, x is in radians.  
> a (x)  The arctangent of x, arctangent returns radians.  
> l (x)  The natural logarithm of x.  
> e (x)  The exponential function of raising e to the value x.  
> j (n,x)  
> 	  The bessel function of integer order n of x.  

bc 读到一条语句就会立即执行，换行和分号都是语句分隔符，可以用`\`对换行做转义，以完成多行语句
对于一条表达式，如果不是赋值语句，就会打印到标准输出中，算术表达式自带换行，字符串不带；还可以使用print 语句进行输出（扩展），它可以打印多个字符串或算术表达式的列表（用逗号分隔），各个打印元素之间不填充字符，最后也不添加换行，不过支持转义字符（"a" (alert or bell), "b" (backspace), "f" (form feed), "n" (newline), "r" (carriage return), "q" (double quote), "t" (tab), and "\" (backslash)）
还支持的语法有：
```
{ statement_list }
if ( expression ) statement1 [else statement2]
while ( expression ) statement
for ( [expression1] ; [expression2] ; [expression3] ) statement
break
continue
halt
quit
return
```
halt 和quit 都是退出bc，区别是halt 是运行期执行，而quit 是在编译期就确定了的，也就是说，halt 可以放在条件语句中控制退出，而quit 则无论在哪，只要被读到就会退出

支持函数定义，函数定义是动态的，调用尚未定义的函数，会引发运行时错误，而对于已经定义的函数，再次定义会覆盖之前的定义
```
define func_name ( parameters ) {
    auto_list
    statement_list
}
```
参数可以是数字和数组，用逗号分隔，数组参数在参数名后加`[]`
`auto_list`是局部变量声明，可选的，格式为`auto var1, var2, ...`，这些变量被初始化为0，也可以声明数组，和参数的声明方式相同
函数没有显示的return 的话，就会自动 return 0
函数中使用的常量将在函数调用时，收到ibase 的参数影响，而不取决于执行到该语句的ibase
支持回调


## 常见环境变量
`_`：上一条命令的最后一个参数
HOME：当前用户的主目录，即cd 命令的默认目标目录
BASH：
HISTSIZE：保存命令历史的文件。默认是~/.bash_history
HISTSIZE：保存命令历史的条数。默认是500
LANG：用来为没有以`LC_`开头的变量明确选取的种类确定locale类
PWD：当前目录，即pwd 命令的返回
OLDPWD：前一个工作目录，即cd - 命令前往的目录
PATH：命令搜索路径，一个由冒号分隔的目录列表
LD_LIBRARY_PATH
PS1：主提示符串，默认值是$
PS2：次提示符串，默认值是>
PS3：与select命令一起使用的选择提示符串，默认值是#?
PS4：当开启追踪时使用的调试提示符串，默认值是+。追踪可以用set –x开启
RANDOM：每次引用该变量，就产生一个随机整数（0到32767）。随机数序列可以通过给RANDOM赋值来初始化。如果RANDOM被复位，即使随后再设置，它也将失去特定的属性

## shell 数组
### 定义
```
arr=(0 1 2)
arr=([1]=1 [2]=2 [3]=3)
```
用空白符（可以是换行符）分隔，和shell 变量一样等号两边不能有空格
也可以进行离散定义：
```
arr[index]=val
```
其中index 会被当做一个非负数的算术表达式，字符序列会被当做变量进行解析，如果未定义将被认为是字符串，字符串都被视为0，如果计算结果为负数会报错
那么删除数组的指定元素就可以：
```
unset arr[index]
```

### 访问
如果直接使用`$arr`，等价于`${arr[0]}`
`${arr[index]}`，其中index 同上也当做一个非负的算术表达式
特别的，index 可以使用`*`或`@`来获得一个用空格分隔的数组非空元素列表（可以用于for遍历），例如：
```
arr=('work@10.226.52.66' 'work@10.226.52.67' 'work@10.226.53.65' 'work@10.226.57.67')
for site in ${arr[*]}
do
	sshpass -p baidu@soFa123 scp $site:/home/work/wangxing/ps/se/sofa/test/module_test_3/rpc_test/p2mp_test/server*.log ./server${site}.log
done
```

### 其他
`${#array[*]}`：数组的元素个数（包括空元素），注意：`${#arr}`等价于`${#arr[0]}`，指的是第一个元素的长度
`${!array[*]}`：数组有效索引的列表（空格分隔）
`${array[*]:start:length}`：从start位置开始长为length的子数组，其中start 可以使用0-n，表示从倒数第n个开始，`:length`可以缺省
`${array[*]#str}` 和 `${array[*]##str}`：对数组每个元素执行ltrim 操作
`${array[*]%str}` 和 `${array[*]%%str}`：对数组每个元素执行rtrim 操作
`${array[*]/substr/newstr}` 和 `${array[*]//substr/newstr}`：对数组每个元素进行替换操作


# Python
[Python 2](https://docs.python.org/2/)
[Python 3](https://docs.python.org/3/)
[TOC]

## 第一章. Python特性

### 1. 内置的高级数据结构
列表（高级数组，向量）、元组、字典（k-v map）

### 2. 面向对象
数据、行为、功能逻辑的封装

### 3. 函数式编程
函数式编程使用一系列的函数解决问题。函数仅接受输入并产生输出，不包含任何能影响产生输出的内部状态。任何情况下，使用相同的参数调用函数始终能产生同样的结果。
在一个函数式的程序中，输入的数据“流过”一系列的函数，每一个函数根据它的输入产生输出。
函数式风格避免编写有“边界效应”(side effects)的函数：修改内部状态，或者是其他无法反应在输出上的变化。完全没有边界效应的函数被称为“纯函数式的”(purely functional)。避免边界效应意味着不使用在程序运行时可变的数据结构，输出只依赖于输入。

#### 3.1 优点
逻辑可证，模块化、组件化（简单原则，一个函数只做一件事情，将大的功能拆分成尽可能小的模块，小的函数件组合出新功能），易测试（无效构造状态的测试桩）、易调试（只需检查是否正确使用接口即可），更好的可读性和可维护性。

#### 3.2 特征
函数是第一类值（first-class value）：函数（通常使用函数名）和整型、字符串等一样，可以作为变量、参数、返回值。
匿名函数（lambda）：使用处定义，不求重用，为更可读。
封装控制结构的内置模板函数：为了控制边界效应，就要尽量避免使用变量，尤其是为了控制流而定义的变量，于是这些控制流就被内化为一些模板函数，比如filter。结果是代码更简洁，也更可读，代价仅仅是一些学习成本。
闭包（closure）：函数可以定义于任何位置，而闭包就是绑定了函数定义所在域变量的函数。那么当离开函数定义的域之外使用这个函数对象时，就可以使用其绑定的变量；并且当执行到内部函数定义处，也就创建了不同的闭包，这样，即使是同一个函数，也绑定了不同的变量。（注：在python2.x中，绑定变量被看出创建了一个同名的局部变量将外部变量隐藏，因此实际上是无法修改绑定变量的值；而在python3.x中，引入了nonlocal关键字，使用该关键字修饰外部变量后，后面就绑定的是外部变量本身，于是也就可以修改外部变量了，也就是说不同闭包将会相互影响）
支持不可变的数据结构：使用不可变的数据结构，可以确保边界效应。
参考：<http://www.cnblogs.com/huxi/archive/2011/06/24/2089358.html>

### 4. 可重用性，易扩展性，可移植性，可读性，易维护
易扩展性建立在无论要访问的模块是来自于标准库还是自定义的，其访问方式都是一致的
对于强调性能的部分，还可以使用C作为Python扩展，并且访问方式也都是一致的
因为 Python 的标准实现是使用 C 语言完成的（也就是 CPython），所以要使用 C 和 C++ 编写 Python 扩展。Python 的 Java 实现被称作 Jython，要使用 Java 编写其扩展。最后，还有 IronPython，这是针对 .NET 或 Mono 平台的 C# 实现。你可以使用 C# 或者 VB.Net 扩展 IronPython。
CPython 的一个局限就是每个 Python 函数调用都会产生一个 C 函数调用. 这意味着同时产生的函数调用是有限制的, 因此 Python 难以实现用户级的线程库和复杂递归应用. 一旦超越这个限制, 程序就会崩溃. 你可以通过使用一个 “stackless” 的  Python 实现来突破这个限制, 一个 C 栈帧可以拥有任意数量的 Python 栈帧. 这样你就能够拥有几乎无穷的函数调用, 并能支持巨大数量的线程. 这个 Python 实现的名字就叫Stackless

基于C的可移植性，Python的可移植性既适用于不同的架构，也适用于不同的操作系统

没有其他语言通常用来访问变量、定义代码块和进行模式匹配的命令式符号。通常这些符号包括：美元符号（$）、分号（;）、波浪号（~）等等。
强制的代码风格要求

### 5. 健壮性（错误追踪）
一旦你的 Python 由于错误崩溃，解释程序就会转出一个“堆栈跟踪”，那里面有可用到的全部信息，包括你程序崩溃的原因以及是那段代码（文件名、行数、行数调用等等）出错了。这些错误被称为异常。如果在运行时发生这样的错误，Python 使你能够监控这些错误并进行处理。

### 6. 高效的快速原型开发工具
与那些封闭僵化的语言不同，Python 有许多面向其他系统的接口，它的功能足够强大，本身也足够强壮，所以完全可以使用 Python 开发整个系统的原型。传统的编译型语言也能实现同样的系统建模，但是 Python 工程方面的简洁性让我们可以在同样的时间内游刃有余的完成相同的工作。
大家已经为 Python 开发了为数众多的扩展库，所以无论你打算开发什么样的应用程序，都可能找到先行的前辈。你所要做的全部事情，就是来个“即插即用”（当然，也要自行配置一番）！只要你能想得出来，Python 模块和包就能帮你实现。Python 标准库是很完备的，如果你在其中找不到所需，那么第三方模块或包就会为你完成工作提供可能。

### 7. 内存管理
将内存管理工作从程序员的业务逻辑中分离出来，使之更为专注于后者。
引用计数技术：对每个对象都有一个引用计数器。释放掉引用计数为0的对象，和仅有这个对象可达的其他对象。
此外，为解决引用计数的循环引用问题，还有一个循环垃圾收集器。试图清理所有未引用的循环。
（Python的内存泄露？？）

### 8. 字节码
类似Java，Python同样字节编译的，而后在解释执行。
当源文件被解释器加载，或显式进行字节码编译时，会被编译为字节码，由于调用解释器的方式不同，源文件会被编译成.pyc或.pyo文件

### 9. 与其他语言的比较
Perl 最大的优势在于它的字符串模式匹配能力，其提供了一个十分强大的正则表达式匹配引擎。这使得 Perl 实际上成为了一种用于过滤、识别和抽取字符串文本的语言，而且它一直是开发 Web 服务器端 CGI(common gateway interface,通用网关接口)网络程序的最流行的语言。Python 的正则表达式引擎很大程度上是基于 Perl 的。
然而，Perl 语言的晦涩和对符号语法的过度使用，让解读变得很困难。Perl 的这些额外的“特色”使得完成同一个任务会有多个方法，进而引起了开发者之间的分歧和内讧。

Python的简洁比纯粹的使用 Java 提供了更加快速的开发环境。
在 Jython 的脚本环境中，你可以熟练地处理 Java 对象，Java可以和 Python 对象进行交互，你可以访问自己的 Java 标准类库，就如同 Java 一直是 Python环境的一部分一样。

由于 Rails 项目的流行，Python 也经常被拿来和 Ruby 进行比较。就像前面我们提到的，Python 是多种编程范式的混合，它不像 Ruby 那样完全的面向对象，也没有像 Smalltalk那样的块，而这正是 Ruby 最引人注目的特性。而 Ruby 事实上可以看作是面向对象的 Perl。

Tcl 是最易于使用的脚本语言之一，程序员很容易像访问系统调用一样对 Tcl 语言进行扩展。与 Python相比，它或许有更多局限性（主要是因为它有限的几种数据类型），不过它也拥有和 Python一样的通过扩展超越其原始设计的能力。更重要的是，Tcl 通常总是和它的图形工具包 Tk 一起工作， 一起协同开发图形用户界面应用程序。所以 Tk 已经被移植到Perl(Perl/Tk)和 Python(Tkinter)中. 与 Tcl 相比，因为Python 有类， 模块及包的机制，所以写起大程序来更加得心应手。

Python 有一点点函数化编程（functional programming ，FP）结构，这使得它有点类似List 或 Scheme 语言。举例来说， 列表解析就是一个广受欢迎的来自 Haskell 世界的特性， 而 Lisp 程序员在遇到 lambda, map, filter 和 reduce 时也会感到异常亲切。
参考：<http://www.cs.sfu.ca/CourseCentral/310/pwfong/Lisp/>

JavaScript 是基于原型系统的， 而 Python 则遵循传统的面向对象系统， 这使得二者的类和对象有一些差异。

## 第二章. 开始
Python之禅，输入import this就可以查看

### 1. 交互
Python 的主提示符( >>> )和次提示符( ... )，其功效类似于SHELL中的主提示符( $ )和次提示符( > )。主提示符是解释器告诉你它在等待你输入下一个语句，次提示符告诉你解释器正在等待你输入当前语句的其它部分。
退出交互：使用exit()函数或者输入EOF（Linux下的Ctrl+D，Windows下的Ctrl+Z）

#### 1.1 输出
```
print var1, var2, var3
```
其中var可以是字面值也可以是变量，用逗号分隔的各部分将显示为一个空格分隔，最后换行
如果不想要换行，可以在语句末尾加上一个逗号“,”即可。结果将是以空格收尾，而不是换行收尾。
单独的一个print语句，将打印一个空行

如果打印的是变量，由于python的面向对象特性，实际上是对变量调用了 str() 函数
在交互式环境中，直接使用变量名进行显示的是变量的原始内容，即对变量调用了 repr()函数，相当于反引号运算符（`` ` `` `` ` ``）。
*附*:str() 与repr() 的区别：
str() 目的在于可读性较好的字符串表示
repr() 目的在于可重建对象的字符串表示，对于一个对象obj，一般 obj == eval(repr(obj))


print 语句相当于函数`sys.stdout.write('xxxx\n')'`，只不过后者需要import sys模块。

##### 输出重定向
```
logfile = open('/tmp/mylog.txt', 'a')
print >> logfile, 'Fatal error: invalid input!'
logfile.close()
```
这里logfile，还可以是 sys.stderr （不需要打开，直接 import sys 即可）

#### 1.2 输入
```
user_in = raw_input('Enter login name: ')
```
`raw_input`这个函数的参数（可选的）是提示信息（系统不会补充换行符），而后等待用户输入，读取用户输入的一行后，返回输入的字符串（不包括最后的换行符）。
由于返回的是字符串，所以如果想用变为其他类型，必须使用类型转换函数。
如果读到EOF，则抛出EOFError异常；如果使用Ctrl+C，将产生一个KeyboardInterrupt异常。
当你需要暂停脚本的执行，观察之前执行的状态时，可以直接使用`raw_input()`，这样就可以保持窗口开着，直到你按下回车键才关闭。

#### 1.3 命令行参数
只需要import sys，命令行参数就在sys.argv这个列表中

##### 1.3.1 解析工具getopt
```
import getopt
getopt(args, shortopts, longopts=[]) -> opts, args
```
其中
args 是传入待解析的命令行参数列表，一般是sys.argv[1:]
shortopts 是一个字符串，每个字符表示一个短格式的选项字符，如果后面跟一个冒号，表示该选项需要一个输入参数。例如'ho:'表示可以使用可以使用 -h 选项和 -o file 选项。短格式且不需要输入参数的选项可以连写，比如’abc:’表示可以使用-abc file这样的选项写法，必须将需要输入参数的选项放到最后一个。
longopts 是一个字符串列表，每个字符串表示一个长格式的选项，如果后面跟一个'='，表示该选项需要一个输入参数。例如[‘help’, ‘output=’]表示可以使用 --help 和 --output=file 选项
返回值
opts 是一个字符串二元组的列表，每个二元组是 (选项串, 输入参数串)
args 是一个字符串列表，其中是没有解析的剩余参数
**注意**：如果一个选项需要一个输入参数，则后面的那一项就将被视为其输入参数；如果一个选项不需要输入参数，但却给了一个输入参数，将导致该输入参数无法解析，进而后面的选项都不再解析而进入args列表中。

调用该函数，可能抛出getopt.GetoptError异常，因此上面的函数需要在try块中调用。

##### 1.3.2 解析工具optparse
```
import optparse
parser = optparse.OptionParser()
```
构造器：
`OptionParser(usage="usage: %prog [options] arg1 arg2", version="%prog 1.0")`
usage 和 version 都是可选参数，提供一个usage 信息和版本信息。
其中%prog将自动以当前程序名的字符串替代，如同 os.path.basename(sys.argv[0])；%default将替换为该选项的默认值

OptionParser的方法：
+ `add_option(Option)`
配置一个可接受的选项，使用该方法
可以传入一个 Option 对象（Option也是optparse的一个类，其中包含了关于选项的各种属性）
也可以有选择的传入 Option 对象的某些属性的值，作为参数（kv型参数），其中`_short_opts`和`_long_opts`是必选的，可以直接作为第一、二个参数（直接作为位序参数）。
例子参见help(optparse)
+ `parse_args(args=sys.argv[1:], values=None) –> Values, args`
用于解析程序的命令行，返回一个二元组
第一个 Values 这个类的一个对象（Values也是optparse的一个类），它保存了所有解析的选项，即option argument；
第二个 args 是一个未解析的字符串列表，即positional argument（两者的区别在于前者是可有可无的，即使没有程序也能正常工作，而后者则是必须指定的）
如果发生错误，则调用error([msg])方法（默认打印usage信息到stderr，并带一个错误信息msg字符串调用sys.exit() ）

*注*：
1. 除了使用`add_option`方法配置的选项外，该类自动配置的选项还有：
    1. -h 和 --help 选项：自动的调用 OptionParser 的`print_help`方法，获取帮助信息
    在打印帮助信息时，首先将先打印usage信息，若在构造时未传入usage信息，则默认使用“usage: %prog [options]”
    如果解析发现 -h 和 --help 选项，不再解析后续命令行参数，直接退出
    2. --version 选项：获取程序的版本信息
2. 如果OptionParser类的错误处理不足以满足需求，可以从该类继承，并重写exit()和error()方法实现。

###### Option类的属性
+ `_short_opts` 和`_long_opts` 都是string，表示一个选项的短格式和长格式
+ action 是string，表示解析一个选项后的处理动作，默认是"store"，即命令行参数的值保存在Values的对象中。
还可以使用
`store_true`和`store_false`，用于处理选项不带输入参数的情形（开关选项）。此时Values对象保存的将是True和False。
`store_const`
`append`，追加列表的 option
`append_const`
`count`：计数 option
`callback`：调用指定函数
`help`
`version`
+ dest 是string，表示上面保存到Values对象的属性名，若缺省，则需使用长格式的命令行参数名作为属性名
+ type 是string，表示保存Values的属性的类型，默认是“string”
+ default，表示一个选项的默认值，默认是None（设置默认值的方式还可以采用OptionParser的`set_default`方法）
+ help是string，用以自动生成 -h 和 --help 选项的帮助信息
+ metavar 是string（并自动转换为大写），用以提醒用户，该选项期望的参数的描述（用以帮助信息中的占位）
+ const 在action为const 和 `store_const` 时需要
+ choices 是字符串数组，在type为choices时需要

OptonGroup这个类可以用以选项分组

##### 1.3.3 optparse的升级版argparse
###### 概念
+ positional argument：必要参数
+ option argument：可选参数，附加性的选项，可有可无
+ flag：不消耗参数（即，后面不需要提供参数值）

```
import argparse
parser = argparse.ArgumentParser()
```

常用的构造参数：
prog，默认sys.argv[0]；
usage，用法，默认自动生成，如果手动指定的话，可以通过%(prog)s引用prog
description，用以描述该脚本的作用，默认为None

ArgumentParser的方法：
+ `add_argument()`：告诉parser一个解析的参数，常用的参数有
	- 位序参数（字符串），可以指定一个positional argument，也可以指定option argument（可以提供short和long两个）
	- action，默认为'store'（直接保存值）
    其他
    `store_const` flag使用，保存为const的值
    `store_true` 和`store_false` flag使用，保存为True和False
    `append` 用于可多次指定，每次指定都将参数值插入列表中
    `append_const` 用于可多次指定，每次指定都将插入const的值到列表
    `count` 用于可多次指定，每次指定计数+1
    `help` 当解析到该参数将立即打印帮助信息并退出
    `version` 当解析到该参数将立即打印版本信息并退出
    此外，你还可以指定为一个argparse.Action的子类
	- nargs，消耗的参数个数（目标属性将成为一个列表），除了一个整数值，还可以是
    `?` 可选的，不指定将为default，指定了但没给参数值为const
    `*` 任意多个
    `+` 至少1个
    argparse.REMAINDER（将未能识别的参数都给该参数）
    *注*：nargs=1和不指定该项不同，前者目标属性将成为一个列表，后者还是一个值。
	- const，为action提供参数值（默认为None）
	- default，缺省默认值，默认为None，此外，如果指定为argparse.SUPPRESS，若指定该参数，则Namespace对象不存在该属性。
	- type，该参数将被转换的类型，转换不会作用于default的值。除了指定类型外，还可以指定特定的文件对象，如FileType('w')；还可以指定一个函数（参数为str，返回转换后的值）
	- choices，参数的可选容器（只支持in运算的类型），要求成员必须满足type类型
	- required，使之作为必选参数（对于option argument来说是不合理的，尽量不用）
	- help，帮助信息，可以通过%(prog)s、%(default)s、%(type)s来引用脚本名、默认值、类型需求。此外，如果指定为argparse.SUPPRESS，则不再为该选项生成帮助信息。
	- version，版本信息，可以通过%(prog)s、%(default)s、%(type)s来引用脚本名、默认值、类型需求。
	- metaver，用以提醒用户，该选项期望的参数的描述（用以帮助信息中的占位），默认为positional argument或option argument 的dest属性变大写。当需要多个期望参数是，该项指定为一个tuple.
	- dest，指定保存到`parse_args`返回Namespace对象的属性名（若不指定，则为选项名的长格式名，若没有则使用short格式名，其中间的`-`转换为`_`）
+ `parse_args()`：返回一个Namespace对象（可以通过vars()函数将其转换为dict）。无参调用将自动解析sys.argv，也可以手动提供这样一个list作为参数。
+ `add_argument_group(title=None, description=None)`：增加一个分组，返回一个分组对象，该对象同样可以进行`add_argument`
+ `add_mutually_exclusive_group(required=False)`：增加一个互斥分组（可以将冲突的参数合在一个互斥分组中，则该分组只能选一个），required为True，则要求互斥分组必选其一。
+ exit(status=0, message=None)：结束程序，返回status，并打印message
+ error(message)：结束程序，返回2，并打印message

*注*：
1. 如果没有add任何argument，也会自动生成一个-h/--help选项
2. 支持分隔式给定参数值，long格式=给定参数值，short格式和参数值连用，short格式一起连用；支持前缀指定参数（在不造成混淆的情况下）
参考：<https://docs.python.org/2/library/argparse.html#module-argparse>

#### 1.4 帮助
+ help([obj])
如果给出obj，则将给出其的帮助信息（文档字符串等），如果没有给出参数，则进入交互式帮助。

    dir([obj])
    如果给出obj，则返回obj可访问的属性列表；未给出则返回当前域的可访问属性列表。
    obj可以是模块，类，对象等

    type(obj)
    返回obj 的类型（返回的类型本身就是一个对象，可以通过该对象的__name__属性查看类型名）
    import types
    types.IntType、…

    isinstance(x, class_type_tuple)
    class_type_tuple可以是一个类型或类，也可以是一个类型或类的元组。如果x是这些类型或其子类的实例，则返回True，否则返回False

    hash(obj)
    返回一个对象的哈希值（整数），同值有相同哈希值，反之不一定。对于不可哈希的类型会抛TypeError异常
    对一个自定义的类调用该函数，则将调用该类的__hash__(self)这个方法，可以自己重定义该函数，返回一个整数值。

    环境信息：
    import sys
    sys.platform
    sys.version

    退出程序：
    sys.exit([status])
    如果缺省status，则进程返回0。如果是整数，则进程返回该整数，如果是其他的，则打印该对象，进程返回1.

#### 1.5 关于函数中进行IO的建议
设计函数时，最好将其输入输出都作为参数和返回值，而将IO的工作放在函数之外，除非该函数的功能就是完成IO。这样做的好处是使该函数的重用性更好。

### 2. 代码文本
执行脚本：python script.py

#### 2.1 脚本首行指定解释器（类Unix下）
指定绝对路径：
```
#!/usr/local/bin/python
```
使用env在系统搜索路径中找python解释器：
```
#!/usr/bin/env python
```

完成之后就可以给该脚本以执行权限执行了

#### 2.2 注释
##### 行注释
`#`
##### 文档注释
在模块、类或者函数的起始添加一个字符串（位于def后的第一行）
这种注释可在运行时访问（通过访问对象（模块、类、对象、函数的名字）的`__doc__`属性，动态获得）
也可以用来自动生成文档（help查看）

#### 2.3 标识符
大小写敏感，命名规范同C
Python 不支持重载标识符，所以任何时刻都只有一个名字绑定。

##### 2.3.1 关键字
import keyword
导入keyword模块，可以查看关键字列表`keyword.kwlist`和使用`iskeyword()`函数进行判断

##### 2.3.2 内建标识符
built-in系统保留字，可以把它们看成可用在任何一级 Python 代码的全局变量，表示特定的意义，一般不做他用，除非是在某些特定情况下进行重定义。
built-in 是`__builtins__`模块的成员，在你的程序开始或在交互解释器中给出>>>提示之前，由解释器自动导入。

##### 2.3.3 专用下划线标识符
`_`：表示最后一个表达式的值（注意：有些表达式可能没有值，比如赋值、print）
`_xxx`：不用`from module import *`导入；
`__xxx__`：系统定义名字；（例如：`obj.__name__`是obj的名字，`obj.__doc__`是obj的文档字符串）
`__xxx`：类中的私有变量名。
一般来讲，使用变量名`_xxx`命名私有的成员，即在模块或类外不可以使用。

#### 2.4 代码块
语句块通过缩进表示从属于哪个代码块，同一缩进深度表示属于同一代码块级别内
没有缩进的代码块是最高层次的，被称做脚本的“main”部分

如果一行写一条语句，则不需要语句分隔符，否则，需要用分号“;”
如果一行语句分多行写，可以在行末使用“\”进行续行（此外，括号和三引号内的内容，可以直接跨行而不用“\”）

#### 2.5 代码结构
首行指定解释器（类Unix下）
模块的文档描述
模块导入
模块级变量定义（外部可以通过模块名引用）
类定义
函数定义（外部可以通过模块名引用）
主程序（由于模块在被导入之后，这部分代码都一定会被执行，所以，需要根据`__name__`判断，是执行具体的功能，还是作为库仅仅做一些初始化工作）

例如：
```
#!/usr/bin/env python
''' module __doc__
...
'''

import module_a

module_var = 'aaaaa'

class AAA:
    ''' class __doc__
    ...
    '''
    pass

def main():
    ''' function __doc__
    ...
    '''
    pass

if __name__ == "__main__":
    main()
```

### 3. Python的一些特性
#### 3.1 一切类型的值均为对象
所有对象都有三个特性：Id、类型、值。他们分别可以使用内建函数id(obj)、type(obj)、obj来获得。其中Id用于唯一的标识一个对象，是一个int型的值，type返回的类型本身也是一种类型，这两者都是只读的，对于可变对象，值是可写的，而对于不可变对象，值也是只读的。
因此，那些在其他语言中视为常量的值，在Python中都是对象，可以直接调用他们的方法或运算符，而不必先将他们赋值给一个变量。

#### 3.2 动态类型
变量免声明，其类型和值在赋值时被赋予（但在变量在使用前必须初始化）

### 4. 其他开发工具
#### 4.1 测试
对于那些不直接执行的库模块，可以让其直接执行去完成一些测试任务，即在`__main__`中直接写简单的测试代码，因为该部分在import时是不执行的

##### unittest
[参考](https://docs.python.org/2/library/unittest.html)
Python标准库中还提供了unittest模块，有时也被称为PyUnit，是Python的单元测试框架
软件测试中最基本的组成单元是测试用例（test case），PyUnit使用TestCase类来表示测试用例，并要求所有用于执行测试的类都必须从该类继承。TestCase子类实现的测试代码应该是自包含（self contained）的，也就是说测试用例既可以单独运行，也可以和其它测试用例构成集合共同运行。利用Command和Composite设计模式，多个TestCase还可以组合成测试用例集合。

###### TestCase
在从TestCase继承的测试子类中，定义setUp()和tearDown()方法可以用于进行每个case的前置初始化和测试完的收尾工作。
一个TestCase的执行过程就是setUp –> 测试方法 –> tearDown。
测试方法的定义有两种方式，一种是静态方式，即定义一个runTest()方法，那么实例化测试类时，就使用无参构造；另一种是动态方式，不再定义runTest()方法，而定义多个测试方法（习惯以test开头），那么实例化测试类时，就要在构造时给出所要执行的那个测试方法的方法名字符串（作为参数）。

###### TestSuite
相关的测试用例合在一起成为一个测试用例集，在PyUnit中是用TestSuite类来表示的（可以将该类视为TestCase类的一个实现）。你需要定义一个名为suite()的全局函数，将其作为整个单元测试的入口，返回一个TestSuite的实例。在用例集添加用例的方法，可以直接在该函数中添加测试用例，还可以从TestSuite类继承一个子类，并在其初始化方法中添加所有测试用例，如下：
方式1：
```
def suite():
	suite = unittest.TestSuite()
	suite.addTest(ATestCase("testSize"))
	suite.addTest(ATestCase("testResize"))
	return suite
```
方式2：
```
class ATestSuite(unittest.TestSuite):
	def __init__(self):
		unittest.TestSuite.__init__(self, map(ATestCase, ("testSize", "testResize")))

def suite():
	return ATestSuite()
```
此外，如果测试用例类的所有测试方法都以test开头，则还可以使用模块中的makeSuite()方法来构造一个TestSuite：
```
def suite():
	return unittest.makeSuite(ATestCase, "test")
```
事实上，TestSuite除了可以包含TestCase外，也可以包含TestSuite。如下：
```
suite1 = ATestSuite()
suite2 = BTestSuite()
alltests = unittest.TestSuite((suite1, suite2))
```

###### TestRunner
PyUnit使用TestRunner类作为测试用例的基本执行环境，来驱动整个单元测试过程。Python开发人员在进行单元测试时一般不直接使用TestRunner类，而是使用其子类TextTestRunner来完成测试，并将测试结果以文本方式显示出来：
```
runner = unittest.TextTestRunner()
runner.run(suite)
```
默认情况下，TextTestRunner将结果输出到sys.stderr上，但如果在创建TextTestRunner类实例时将一个文件对象传递给了构造函数，则输出结果将被重定向到该文件中。

###### 简易方法
PyUnit模块中定义了一个名为main的全局方法，使用它可以很方便地将一个单元测试模块变成可以直接运行的测试脚本，main()方法通过TestProgram这个类使用TestLoader类来搜索所有包含在该模块中的测试方法，使用makesuite组装成一个testSuite，而后将之交给TextTestRunner去执行它们。如果Python程序员能够按照约定（以test开头）来命名所有的测试方法，那就只需要在测试模块的最后加入如下几行代码即可：
```
if __name__ == "__main__":
	unittest.main()
```
使用这种方式后，可以使用
`python main.py` 来执行所有case（按照测试方法名的字典序依次执行）
`python main.py ATestCase.testSize` 来执行指定的case
`python main.py –h` 来查看运行该脚本所有可能用到的参数

###### 测试结果
一个点（.）表示通过一个case
一个F表示fail了一个case
E表示程序自身异常

###### TestCase类中可用的检测方法
`assertEqual(a, b, msg=None)`			a == b，每个都有一个失败信息的可选参数（会覆盖原有的错误信息）
`assertNotEqual(a, b, msg=None)`		a != b
`assertAlmostEqual(a, b, places=None, msg=None, delta=None)`		places和delta 不能同时指定（可以都不指定）。如果都不指定或指定places，则检查round((a-b), places) == 0（places未指定则默认为7）；如果指定delta，则检查(a-b)<= delta。
`assertNotAlmostEqual(a, b, places=None, msg=None, delta=None)`

`assertTrue(expr, msg=None)`			expr is True
`assertFalse(expr, msg=None)`			expr is False

`assertLess(a, b, msg=None)`			a < b
`assertLessEqual(a, b, msg=None)`		a <= b
`assertGreater(a, b, msg=None)`		a > b
`assertGreaterEqual(a, b, msg=None)`		a >= b
`assertIs(expr1, expr2, msg=None)`			a is b
`assertIsNot(expr1, expr2, msg=None)`		a is not b
`assertIsNone(obj, msg=None)`
`assertIsNotNone(obj, msg=None)`

`assertIn(member, container, msg=None)`	a in b
`assertNotIn(member, container, msg=None)`	a not in b

`assertIsInstance(obj, cls, msg=None)`		isinstance(obj, cls)
`assertNotIsInstance(obj, cls, msg=None)`

`assertMultiLineEqual(stra, strb, msg=None)`
`assertRegexpMatches(text, re, msg=None)`
`assertNotRegexpMatches(text, re, msg=None)`

`assertListEqual(list1, list2, msg=None)`
`assertTupleEqual(tuple1, tuple2, msg=None)`
`assertSetEqual(set1, set2, msg=None)`
`assertDictEqual(d1, d2, msg=None)`
`assertDictContainsSubset(expected, actual, msg=None)`			字典expected都在actual中存在
`assertSequenceEqual(seq1, seq2, msg=None, seq_type=None)`		ordered sequences
`assertItemsEqual(expected_seq, actual_seq, msg=None)`			unordered sequence

`assertRaises(excClass, callableObj=None, *args, **kwargs)`
`assertRaisesRegexp(expected_exception, expected_regexp, callable_obj=None, *args, **kwargs)`

`fail(msg=None)`		直接fail掉

#### 4.2 调试器
pdb，支持（条件）断点，逐行执行，检查堆栈。还支持事后调试。
可以在执行Python时加上-m pdb选项（python -m pdb a.py），进行调试，断点是在程序执行的第一行之前。
当然，也可以在代码中import pdb；而后通过调用`pdb.run('mymodule.test()')`进行调试，或`pdb.set_trace()`设置断点。

##### 调试命令
h [cmd]	查询cmd命令
l		列出当前运行部分的代码
p		打印某个变量
b [line/func]	在line行或func函数入口设置断点（如果未给出位置，则显示当前所有断点）
condition bnum [cond]	将bnum号断点设置条件cond
cl [bnum]	清除指定断点，如果未给出断点号，则清除当前所有断点
disable/enable bnum	将bnum号断点禁用/激活
s		单句步进
n		单行步进
c		（从中断）恢复执行
j line		跳到指定行line
a		显示当前函数的参数
!stat		执行语句stat，可以直接改变某个变量
q		退出调试
w		打印栈跟踪信息（即bt命令）最近使用的栈框（frame）在底部，当前栈框有箭头指示
u/d		将当前栈框上移/下移

#### 4.3 日志
logging模块
线程安全

```
import logging
logging.basicConfig(
    filename = 'xxx.log', filemode = 'a',
    datefmt = '%Y-%m-%d %H:%M:%S %f',
    format = '%(levelname)s %(asctime)s [%(funcName)s:%(lineno)d] %(message)s',
    level = logging.DEBUG
)
```
配置：
filename：   用指定的文件名创建FiledHandler，日志会被存储在该文件中。
filemode：   文件打开方式，在指定了filename时使用这个参数，默认值为“a”还可指定为“w”。
datefmt：    指定日期时间格式，同time.strftime()。
format：      指定日志显示格式（默认：'%(levelname)s:%(name)s:%(message)s'）。
level：        设置rootlogger的日志级别（只有该级别或以上级别的日志才会打印）
stream：     用指定的stream创建StreamHandler。可以指定输出到sys.stderr, sys.stdout或文件，默认为sys.stderr。当设置了filename之后，该配置忽略

##### 日志的级别有
CRITICAL > ERROR > WARNING（默认） > INFO > DEBUG > NOTSET
除此之外，还可以自定义日志级别

CRITICAL：致命，程序无法继续运行
ERROR：错误，程序一些功能失败
WARNING：警告，程序可以按预期执行，但一些意想不到的事发生了，可能存在一些错误
INFO：通知信息
DEBUG：调试信息

##### format中的格式化串：
%(name)s             Logger的名字
%(levelno)s          数字形式的日志级别
%(levelname)s     文本形式的日志级别
%(pathname)s     调用日志输出函数的模块的完整路径名，可能没有
%(filename)s        调用日志输出函数的模块的文件名
%(module)s          调用日志输出函数的模块名
%(funcName)s     调用日志输出函数的函数名
%(lineno)d           调用日志输出函数的语句所在的代码行
%(created)f          当前时间，用UNIX标准的表示时间的浮 点数表示
%(relativeCreated)d    输出日志信息时的，自Logger创建以 来的毫秒数
%(asctime)s                字符串形式的当前时间。默认格式是 “2003-07-08 16:49:45,896”。逗号后面的是毫秒
%(thread)d                 线程ID。可能没有
%(threadName)s        线程名。可能没有
%(process)d              进程ID。可能没有
%(processName)d              进程名。可能没有
%(message)s            用户输出的消息

##### 每个级别对应一个打印函数
logging.debug('debug message')
logging.info('info message')
logging.warning('warning message')
logging.error('error message')
logging.critical('critical message')
实际上，调用这些打印函数，是通过一个Logger对象完成的
函数的原型是`(msg, *args, **kwargs)`，支持`msg % args`

##### 四个概念
+ Logger：负责接收用户message，完成打印；可以添加多个Handler和Filter
+ Handler：负责管理一个日志target；可以设置一个Formatter和添加多个Filter
+ Formatter：负责日志的格式
+ Filter：负责日志过滤（基于logger的name）

###### Logger
获得一个Logger
```
logging.getLogger([name])
```
name是一个Logger的标识key，因为Logger组成一个树形的层次关系，所以name字符串中可以用 . 划分层次。默认有一个root Logger，所有其他的Logger都默认在root之下，如果name缺省获得的就是root Logger。子Logger继承父Logger的配置。

一个Logger可以拥有多个Handler，从而可以同时输出到多个target

方法：
上面5个打印函数
setLevel(lel)：设置打印最低日志级别
addHandler(hd)：增加Handler
removeHandler(hd)：删除Handler
addFilter(filt)：增加Filter
removeFilter(filt)：删除Filter

如果在多模块使用：
同一个解释器中，日志管理的是同一套，即相同的标识key都是会返回同一个logger实例

###### Handler
获得一个Handler：
```
logging.FileHandler('/tmp/test.log')

logging.StreamHandler()

RotatingFileHandler('myapp.log', maxBytes=10*1024*1024,backupCount=5)
```

方法：
setLevel(lel)：设置打印最低日志级别
setFormatter(formatter)：  给这个handler选择一个Formatter
addFilter(filt)：增加Filter
removeFilter(filt)：删除Filter
flush()：确保所有日志都被刷出
close()：从handler的map中清除该handler

可用的Handler：
+ logging.StreamHandler(strm=sys.stderr)
    可以向类似与sys.stdout或者sys.stderr的任何文件对象(file object)输出信息
+ logging.FileHandler(filename, mode='a', encoding=None, delay=True)
    用于向一个文件输出日志信息, 如果存在延时(delay=True)，那么，文件打开推迟到第一次调用
+ logging.handlers.RotatingFileHandler(filename[, mode[, maxBytes[, backupCount]]])
    类似于上面的FileHandler，但是它可以管理文件大小。当文件达到一定大小之后，它会自动将当前日志文件改名（加上.n后缀），然后创建一个新的同名日志文件继续输出。
    maxBytes用于指定日志文件的最大文件大小，如果为0，意味着日志文件可以无限大;
    backupCount用于指定保留的备份文件的个数。比如，如果指定为2，当上面描述的重命名过程发生时，原有的chat.log.2并不会被更名，而是被删除。
+ logging.handlers.TimedRotatingFileHandler(filename[, when[, interval[, backupCount]]])
    和RotatingFileHandler类似，不过，它不是通过判断文件大小来决定何时重新创建日志文件，而是间隔一定时间就自动创建新的日志文件。
    interval是时间间隔；
    when参数是一个字符串。表示时间间隔的单位，不区分大小写，可取值为
    - S 秒
    - M 分
    - H 小时
    - D 天
    - W 每星期（interval==0时, 代表星期一）
    - midnight 每天凌晨
+ logging.handlers.SocketHandler(host, port)
    使用TCP协议，将日志信息发送到网络。
+ logging.handlers.DatagramHandler(host, port)
    使用UDP协议，将日志信息发送到网络。
+ logging.handlers.SysLogHandler
    日志输出到syslog
+ logging.handlers.NTEventLogHandler
    远程输出日志到Windows NT/2000/XP的事件日志
+ logging.handlers.SMTPHandler
    远程输出日志到邮件地址
+ logging.handlers.MemoryHandler
    日志输出到内存中的指定buffer
+ logging.handlers.HTTPHandler
    通过"GET"或"POST"远程输出到HTTP服务器

各个Handler的具体用法可查看参考书册：
<https://docs.python.org/2/library/logging.handlers.html#module-logging.handlers>

###### Formatter
获得一个Formatter：
```
logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
```

###### Filter
获得Filter：
```
logging.Filter('mylogger.child1.child2')：通过Logger标识key的前缀来完成过滤
```

##### 配置文件
```
[loggers]
keys=root,simpleExample
[handlers]
keys=consoleHandler
[formatters]
keys=simpleFormatter
[logger_root]
level=DEBUG
handlers=consoleHandler
[logger_simpleExample]
level=DEBUG
handlers=consoleHandler
qualname=simpleExample
propagate=0
[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)
[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt=
```
```
#logger.conf
###############################################
# [logger_xxxx] xxxx是loggers中的key，也是getLogger使用的key
# qualname  logger名称，应用程序通过 logging.getLogger获取。对于不能获取的名称，则记录到root模块。
# propagate 是否继承父类的log信息，0:否 1:是
###############################################
[loggers]
keys=root,example01,example02
[logger_root]
level=DEBUG
handlers=hand01,hand02
[logger_example01]
handlers=hand01,hand02
qualname=example01
propagate=0
[logger_example02]
handlers=hand01,hand03
qualname=example02
propagate=0
###############################################
# [handler_xxxx]
# args handler初始化函数参数
##############################################
[handlers]
keys=hand01,hand02,hand03
[handler_hand01]
class=StreamHandler
level=INFO
formatter=form02
args=(sys.stderr,)
[handler_hand02]
class=FileHandler
level=DEBUG
formatter=form01
args=('myapp.log', 'a')
[handler_hand03]
class=handlers.RotatingFileHandler
level=INFO
formatter=form02
args=('myapp.log', 'a', 10*1024*1024, 5)
###############################################
[formatters]
keys=form01,form02
[formatter_form01]
format=%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s
datefmt=%a, %d %b %Y %H:%M:%S
[formatter_form02]
format=%(name)-12s: %(levelname)-8s %(message)s
datefmt=
```
```
import logging
import logging.config

logging.config.fileConfig("logger.conf")
logger = logging.getLogger("example01")
```

#### 4.4 配置文件
Python 支持对ini 格式的配置文件进行读取

##### ini配置文件格式
+ 所有配置用[section]进行划分
+ 每个配置是"key : val"或"key = val"格式
其中
key不能以空白符开头，结尾的空白符会被滤掉；
val可以分多行写，但从第二行需以空白符开头，开头和结尾的空白符都会被滤掉；
val还可以%(key)s 引用本section 和DEFAULT section（全局的section）的指定key 的对应 val。
+ 以‘#’或';'开头的行是注释（不过#只能在行首才是有效，;可以跟在一行之后，但需要空白符分隔）。

section名区分大小写，option名会统一将大写改为小写，因此不区分
如果section重名会合并，如果option重名会覆盖（本section会覆盖default section的同名值）

*注：并不支持option数组格式*

##### ConfigParser 模块
该模块主要有三个类：
RawConfigParser、ConfigParser、SafeConfigParser，前者是后者的父类，RawConfigParser 不支持%(key)s 引用，SafeConfigParser 会比ConfigParser 有更多的合法性检查。

以ConfigParser 为例：
`ConfigParser([defaults[, dict_type[, allow_no_value]]])`：defaults是一个dict，key/val都必须是字符串，作为DEFAULT section；`dict_type`用于指定内置的字典类型，`allow_no_value`表示是否接受选项没有值，默认是False。

`read(conf_file)`：读取ini配置文件，`conf_file`可以是文件名的字符串或列表，返回一个成功打开了的文件名的字符串列表
readfp(file)：通过一个可读的文件对象读取配置

write(file)：通过一个可写的文件对象进行写回

sections()：获取ini文件中的section名列表
options('section')：获取一个section中的key名列表（融合default section的）
items('section', raw=Flase, vars=None)：获取一个section中的kv二元组列表，如果raw为True的话，就不再解释%(key) （融合default section的）
get('section', 'key', raw=Flase, vars=None)：获取一个section中key对应的value值（str类型），如果提供vars参数，需要是一个字典对象，查找顺序为`vars->section->defaults`
getint、getboolean、getfloat：同上，返回类型不同

`has_section('section')`：指定的section是否存在
`has_option('section', 'option')`：指定的section下的option是否存在

`add_section('section')`：动态添加一个section
`remove_section('section')`：动态删除一个section
set('section', 'key', 'value')：动态设置
`remove_option('section', 'key')`：动态删除一条配置


#### 4.5 Profilers（性能测试器）
Profile：老，Python实现，最慢
hotshot：较新，C实现，生成结果时间长
cProfile：新，C实现，分析时间长

## 第三章. 数据类型
### 1. 基本数据类型

#### 1.1 数值类型
这些类型都是不可变类型

##### 1.1.1 int
+ 十进制：1~9 开头
+ 八进制： 0 打头，且后一个数小于8。
可以使用`oct()`将一个十进制数转换为八进制字符串
+ 十六进制：0x 或0X 打头（字母大小写均可）
可以使用`hex()`将一个十进制数转换为十六进制字符串

使用print显示默认均为十进制

构造函数
int()           0
int(12)         12
int("100", 5)   25 注：100为5进制表示（如果该表示非法则抛出ValueError异常），生成其对应的整数

其宽度取决于环境，比如32位环境（机器和编译器）宽度为32位，只不过当计算溢出后，结果会自动转变为long

##### 1.1.2 long
后缀l或L（也支持十进制、八进制、十六进制表示）

构造函数
long()              0L
long("100", 5)      25L

其宽度仅受限于用户计算机的虚拟内存大小，类似于 Java 中的 BigInteger 类型

##### 1.1.3 bool（布尔值）
只有两个实例：True（数值1）、False（数值0）
是整形的子类，但不能被继承

构造函数：
bool()          False

所有标准对象都可用于布尔测试，因为可以隐式对其调用bool(obj)。
该函数的作用是调用类的`__nonzero__()`方法
对于内建类型：None，值为零的任何数字，空字符串、空列表、空元祖、空字典的布尔值都是False。其他都是True。
对于自定义的类的实例，如果类实现了`__nonzero__()`方法（返回类型为int或bool），则返回其返回值，如果没有实现该方法，而实现了`__len__()`方法（返回类型为非负整数），则返回其返回值，否则都没有时，为True。

##### 1.1.4 float（浮点数）
支持e和E的科学计数法

构造函数：
float()         0.0
支持字符串转换为一个浮点数，但字符串中不能含有非法字符，否则会抛异常

占8个字节，遵守IEEE754规范（52M底/11E指/1S符）
然而实际精度依赖于机器架构和编译Python解释器的编译器

###### decimal
还有一种十进制浮点数decimal，比float有着更大的取值范围或精度，但不是内建类型：
```
import decimal
decimal.Decimal('1.1')  # 获得一个该类型的值
```
为什么要有十进制浮点数呢，是因为float表示精度有限，而且是基于二进制的，因此即便`0.1` 这种简单的浮点数，实际上都有着精度误差，可以通过`decimal.Decimal(.1)`看到，而decimal可以构造出十进制上无误差的小数。于是，要构造这种小数就不能用浮点数来构造，而应该用字符串，即如上。同理，这种类型不能和float进行运算，可以和整数进行运算，因为和float进行运算会导致不精确的结果，污染decimal，而和整形数则不会。

##### 1.1.5 complex（复数）
使用j或J表示虚数的单位，实部real和虚部imag都是float
不支持比较运算

构造函数：
complex()               0j
complex(3.6)            (3.6+0j)
complex(1.2, 4.5)       (1.2+4.5j)

conjugate()方法：返回共轭复数

##### 1.1.6 相关模块
+ decimal		十进制浮点运算类
+ array			高效数值数组
+ math/cmath	标准C数学函数库，前者是常规运算，后者是复数运算
+ operator		函数形式调用操作符（不仅仅是数值运算可以，下面的容器运算也可以使用该模块）
+ random		多种分布的伪随机数发生器
该模块有很多直接可用的函数，但实际上这些函数都是Random这个类的方法，它们被关联到一个共享状态的实例上，当多线程需要随机数可以使用多个实例，并用jumpahead()方法确保生成不重叠的随机序列。
这些函数以random()为基础：该函数以当前时间为随机数种子，返回`[0, 1)`中的一个随机浮点数
其他常用的方法还有：
    - uniform(a, b)：a, b是上下限，顺序可换，返回a、b之间的浮点数（即`a + (b - a)*random()`）
    - randint(a, b)：返回[a, b]中的一个随机整数
    - randrange([start,] stop [, step])：在range(start, stop, step)生成的列表中随机选择一项（并不实际生成列表）
    - choice(seq)：从非空序列seq中随机选出一个元素
    - shuffle(x [, random])：将序列x原地打乱，random是一个0元函数返回`[0, 1)`之间的随机数，默认使用random()函数。
    - sample(population, k)：从序列population中随机选取k个元素组成一个新的序列返回
[参考](https://docs.python.org/2/library/random.html)

第三方包：
NumPy可以高效地存储和处理大型矩阵
SciPy有最优化、线性代数、积分、插值、特殊函数、快速傅里叶变换、信号处理和图像处理、常微分方程求解和其他科学与工程中常用的计算。

#### 1.2 容器类型
+ 可变类型：list、set、dict（key不可变，value可变）
+ 不可变类型：string、unicode、tuple、frozenset
不能改变容器的数量和每个的引用，但可以改变每个对象的内容

容器通用操作
1. 可以使用 len() 函数获得一个**序列（字符串、列表、元组）**或字典、集合的长度（大小）
len()函数实际上是调用对象类中的`__len__()`方法
2. obj [not] in container，判断obj是否是序列或集合的元素，或者obj是否是字典的键

序列通用操作
1. `+` 序列连接（类似的也支持`+=`运算）
2. `* n` 重复 n 次进行连接（类似的也支持`*=`运算）
*注意*：连接只能在同类型进行
3. `[n]` 索引某个元素
索引值n，正向从0递增，反向从 -1 递减——相当于加上len做偏移
4. `[start:end:step]` 切分出子序列，前闭后开区间，表示将从序列中选取从索引为start开始的元素，每次步进step，不到索引为end的元素的这些元素组成一个新的序列
step缺省或为None时默认为1；
当step为正时，start缺省或为None时默认为0，end缺省或为None时默认为len；
当step为负时，start缺省或为None时默认为-1，end缺省或为None时默认为0-1
索引规则同上

容器的构造和转换，实际上执行的是浅拷贝，即重新生成一个目标容器，而后将组成元素的引用插入到这个新生成的目标容器中
（如果是重新生成了组成元素，再将新生成的元素插入目标容器就叫深拷贝）

相关模块
copy        提供浅拷贝copy(obj)和深拷贝deepcopy(obj)的能力（为了优化深拷贝的性能，对于包含的完全是不可变类型的对象，即使使用深拷贝，执行的也是浅拷贝）
collections 高性能容器数据类型（例如，判断是否是可迭代对象：isinstance(obj, collections.Iterable)）

##### 1.2.1 字符串
引号之间的字符集合（单引号和双引号均可）。
*注*：如果两个字符串写在一起，如"aa" 'bb'，这两个字符串将在编译时就连接为一个字符串了，这种写法便于分行写字符串，并给以行注释）。

###### Unicode字符串
引号前面使用u 前缀
因为python的字符串可以保存任何字符，所以对于str串更应该称为字节串；而unicode字符串才是python内部真正的字符串（不必考虑其内部表示），这也就是之所以`s->u`叫做解码decode，反之`u->s`叫做编码encode。
通常在进行IO（包括存储和网络传输），是以字节流进行，而python进行处理的时候将其解码为Unicode串，处理完后重新编码进行IO

###### raw string
引号前面使用r 前缀（u在r前）
字符串中的所有字符都直接按照字面值给出，不存在转义或不能打印的字符（常用于构造正则表达式import re）。
转义方法类同标准C，有点不同就是，如果"\"和后面无法匹配转义，则"\"将保留在字符串中。（使用ASCII码表示的字符，可以使用八进制如\134或十六进制如\x5C表示；使用Unicode表示的字符，可以使用\u1234表示）

###### 三引号字符串
三引号（三个连续的单引号或者双引号）之间的字符是一种所见即所得的字符串，因为该串中的换行，制表和引号等特殊字符无需转义。
对于长字符串，需要跨行写的情况，如果用普通字符串，则在换行前使用"\"（此时，"\"和换行都将忽略，而不会出现在字符串中），否则会有语法错误。而使用三引号字符串，则可以直接跨多行书写（此时，换行将以"\n"保留在字符串中）。

###### 构造函数
str()               ''（空串）（如果对对象使用该函数，则调用对象的`__str__()`方法）
unicode()           u''（Unicode空字符串）（如果对对象使用该函数，则调用对象的`__unicode__()`方法）
basestring()        抽象工厂函数，作用仅仅是为前两者提供父类，因此，不能调用实例化

###### 字符操作
Python没有字符类型，所以字符串可以被视为一种自包含的容器。不过，却有以下函数：
ord(ch)：ch是一个单字符的字符串（ASCII或Unicode），该函数返回相应的ASCII或Unicode值。
chr(num)：返回给定数字（0<=num<=255）对应的ASCII字符。
unichr(num)：返回给定数字对应的Unicode字符，接受的码值范围依赖于Python是构建于UCS-2（0x0000-0xFFFF）还是UCS-4（0x000000-0x110000）

由于字符串的自包含特性，所以，对于[not] in运算符，不仅支持单字符的判断，还支持子串的判断。

###### 字符串格式化
格式为：`template_string % fill_data`
其中
`template_string`是模板字符串，在模板字符串中可以使用占位符，用于填充，占位符的格式为`%[(name)][flag][width.precision]typecode`
+ (name) 中name是当`fill_data`使用字典时对应的key，而后就用相应的val填充
+ flag 可以使用
    - `-` 表示当宽度过大时左对齐（默认右对齐）
    - `+` 正数前显示加号
    - ` ` 宽度过大时使用空格填充
    - `0` 宽度过大时使用0填充
    - `#` 在八进制数前显示0，在十六进制数前显示0x
+ width 表示显示的最小总宽度（字符数，默认是0）不足补空格
+ precision 表示小数点后的位数（浮点，默认是6）或至少的数字宽度（整数，不足补0）或至多的数据宽度（字符串，超出将尾截断）
width 和 precision 可以使用 `*` 表示宽度和精度的设置来自于`fill_data`，即`*`也会消耗一个`fill_data`中的一个成员（必须是整数）
+ typecode 可以是
    - %s 字符串（优先用str()进行转换），%c 转换成字符（单字符的字符串），%r（优先用repr()进行转换）
    - %d 有符号十进制整数，%u 无符号十进制整数，%o 无符号八进制整数，%x 无符号十六进制整数
    - %f 浮点数（小数部分自然截断），%e 科学计数法，%g 表示自动选择%f或%e
    - %% 单个%
`fill_data`是填充数据，可以是元组或字典，元组是按序和占位符对应，字典是使用name 和占位符对应
无论`template_string`还是`fill_data`只要有一个包含Unicode字符串，结果就返回Unicode字符串，否则返回字节串

###### 判断
`startswith(obj, start=0, end=len)`方法：检查字符串的指定子串是否以obj开头
`endswith(obj, start=0, end=len)`方法：检查字符串的指定子串是否以obj结尾
`isalpha()`方法：是否是非空字母串
`isdigit()`方法：是否是数字串
`isnumeric()`方法：是否只含数字字符（目前只对Unicode字符串存在）
`isalnum()`方法：是否是非空字母或数字串
`isdecimal()`方法：是否只含十进制数
`islower()`方法：是否是非空小写字符串
`isupper()`方法：是否是非空大写字符串
`isspace()`方法：是否只含空格
`istitle()`方法：是否是标题化（见title()）的字符串

###### 查找
`find(substr, start=0, end=len)`方法：正向查找子串，找到返回开始的索引值，找不到返回-1
`rfind(substr, start=0, end=len)`方法：反向查找子串
`index(substr, start=0, end=len)`方法：同find，只不过，找不到抛出ValueError异常
`rindex(substr, start=0, end=-1)`方法：同rfind，只不过，找不到抛出ValueError异常
`count(substr, start=0, end=len)`方法：查找子串，返回找到的个数

###### 串变换
`upper()`/`lower()`方法：将所有字符变成大写/小写
`swapcase()`方法：大小写互换
`capitalize()`方法：首字母大写
`title()`方法：所有单词首字母大写，其他字母为小写
`expandtabs(tabsize=8)`方法：把字符串中的tab符号转换为指定数量的空格
`lstrip()`方法：把字符串中左侧的空格去除
`rstrip()`方法：把字符串中右侧的空格去除
`strip()`方法：同时执行lstripe()和rstripe()方法
`center(width)`方法：返回一个原字符居中，并使用空格填充至给定长度width的新字符串。
`ljust(width)`方法：同上，左对齐
`rjust(width)`方法：同上，右对齐
`zfill(width)`方法：返回一个原字符右对齐，前面填充0的新字符串
`replace(str1, str2, num=count)`方法：把串中str1替换为str2，如果指定num，则替换不超过num次
`translate(table, [dels])`方法：table是一个长度为256的字符串，用于提供一个字符映射表，该方法就将字符串中的字符，去掉dels中出现的字符，再按给定的字符映射表进行转换；如果table是个None，则只做删除，不做映射。

###### 合并与拆分
`join(str_seq)`方法：参数是一个字符串构成的序列，该方法将序列按序用该字符串连接起来。（比+运算符更高效，因为+需要为每一个参与连接的字符串重新分配内存，以产生新的字符串）
`split(str, num=count)`方法：分割字符串为列表，默认按一个或多个空白字符分割，如果给定一个字符串参数，则按该字符串作为分割元；如果指定num，则仅分割为num个子串
`splitlines(num=count)`方法：把字符串按行分割为列表，如果指定num，则仅分割为num个子串
`partition(str)`方法：把字符串分成字符串三元组，即str前部分，str（从左侧首次出现），str后部分，如果字符串中找不到str这个字符，则str前部分为原串，后两项为空串
`rpartition(str)`方法：同上，不过从右边查找str（于是，如果找不到，则str后部分为原串，前两项为空）

###### 编码
`decode(encoding='UTF-8', errors='strict')`方法：对字节串按encoding解码为python的unicode串（和unicode(str, encoding)等效）。如果转码失败，除非errors指定为'ignore'或'replace'，否则出错抛出ValueError异常。注意：该方法仅对str串有效，因此，如果unicode串调用该方法，实际上是先str(unicode)转为str串（默认ascii编码）而后进行解码的。
`encode(encoding='UTF-8', errors='strict')`方法：以encoding指定方式编码字符串为str字节串。如果转码失败，除非errors指定为'ignore'或'replace'，否则出错抛出ValueError异常。注意：该方法仅对unicode串有效，因此，如果str串调用该方法，实际上是先unicode(str)转为unicode串而后进行编码的。
******
字节串可能有多重编码方式，如UTF-8、UTF-16、ISO8859-1/Latin-1SCII码
UTF-8使用的是变长编码方式，可以完全兼容ASCII码
UTF-16是定长的16位编码（易于读写）（这里的定长是针对基本多文种平面BMP，而其他的平面一般很少使用），由于是多字节表示，故而，需要一个BOM（Byte Order Mark）或者显式定义LE（小端）或BE（大端）
当需要将Unicode字符串写入文件时，就需要指定一个编码方式，这时就需要使用encode函数；反之，需要从文件中读取Unicode字符串时，必须进行解码
若将Unicode字符串和字节串连接，会将字节串转换为Unicode字符串
1. 不要将Unicode字符串传给非Unicode兼容的函数（比如string模块，pickle模块。前者已经有Unicode版本，而后者可以不使用文本格式，而使用二进制格式）
2. 在Web应用中，数据库这边只需确保每张表都用UTF-8编码即可。数据库适配器（如MySQLdb）需要考察其是否支持Unicode，以及需要哪些设置来配置为Unicode字符串。Web开发框架方面（如Django、`mod_python`、cgi、Zope、Plane）同样需要考察哪些配置来支持Unicode。

注意：python代码中的字符串字面值是以文件本身的编码进行保存的，为了让python解析器识别其编码，需要在源码文件中的第一行或第二行进行编码说明（以cp936为例）：
```
# coding=cp936
# -*- coding: cp936 -*-
# vim: set fileencoding=cp936 :
```
以上三种格式选一即可
那么，当python解析器读入代码文件时，如果是Unicode字符串，就会先将文件中的字节串按指定的编码说明进行decode（如果文件本身编码和声明编码不兼容就可能报错）；如果是字节串，则会直接原样读取，但在和Unicode字符串进行连接操作进行decode 的时候，就会按文件中指定的编码说明进行decode（此时不兼容会报错）。
因此，在python 代码中写中文，尽量使用Unicode字符串（因为能和大多数软件兼容）
如果在命令行直接使用python，则需要考虑命令行的编码（Windows下为gbk，也即cp936）
******
此外，python，还有一些非字符的编码集(non-character-encoding-codecs)：
比如16进制的编码：
```
'\n'.encode('hex') == '0a'
u'\n'.encode('hex') == '0a'
'0a'.decode('hex') == '\n'
u'0a'.decode('hex') == '\n'
```
比如MIME编码base64、quopri
比如压缩的：zlib、gzip、bz2
比如回转13编码：rot13
比如`string_escape`、uu
再比如：
```
print u'\\u0203'.decode('unicode-escape')
print u'\\u53eb\\u6211'.decode('unicode-escape')
```
参考
<http://docs.python.org/library/codecs.html>
<http://wiki.woodpecker.org.cn/moin/PyCkBk-3-18>
******
sys模块有个sys.setdefaultencodeding方法，该方法可以修改解释器对字符的默认编码
但在python的启动过程中，自动执行的site.py脚本会`del sys.setdefaultencodeding`，所以查看sys模块找不到该方法
可以通过`reload(sys)`重获该方法，但在IDLE 环境下，由于sys.stdout/sys.stderr/sys.stdin都是特定的，如果reload之后，这三个变量都会被重置导致IDLE下IO都失灵，因此，需要在reload之前先将这三个变量保存一下，在reload之后用保存的值进行恢复即可（最好使用其他方法解决编码问题，因为reload(sys)会衍生一些问题）

###### string 模块
import string
预制的字符串：
`string.ascii_uppercase`（ASCII大写字母串）string.uppercase（Unicode大写字母串）
`string.ascii_lowercase`（ASCII小写字母串）string.lowercase（Unicode小写字母串）
`string.ascii_letters`（ASCII字母串）string.letters（Unicode字母串）
string.digits（数字串）
方法：
string.upper(str)	返回str的大写字符串
`string.join(str_seq, sep=' ')`	等价于`sep.join(str_seq)`

###### 字符串模板类（比字典格式化更简单的替换方式，不用指定格式化类型）
例如：s = string.Template('There are ${howmany} ${lang} Quotation Symbols')
s.substitute(lang='Python', howmany=3)，必须给出全部$变量的替换，否则将跑出KeyError异常
`s.safe_substitute(lang='Python')`，可以不给出全部的$变量，仅作部分替换


###### 相关模块
re          正则表达式
struct      字符串和二进制之间的转换
StringIO/cStringIO      字符串缓冲对象，操作方法类似file对象（后者是C版本，更快一些，但不能被继承）
base64      Base 16/32/64数据编解码
baseascii       ASCII编解码
uu          格式编解码
codecs      解码器注册和基类
crypt       进行单方面加密
difflib     找出序列间的不同
hashlib     多种不同安全哈希算法和信息摘要算法的API
hma         HMAC信息鉴权算法
md5         RSA的MD5信息摘要鉴权
rotor       提供多平台的加解密服务
sha         NIAT的安全哈希算法SHA
stringprep  提供用于IP协议的Unicode字符串
textwrap        文本打包和填充
unicodedata Unicode数据库

##### 1.2.2 列表
列表（[a, b, c]）能保存任意数量任意类型的 Python 对象（有序）

###### 构造函数
list()					[]
list((1, 2, 3))			[1, 2, 3]（浅拷贝构造，即元素使用引用原容器元素）
list("fjal")			['f', 'j', 'a', 'l']（可将其他可迭代对象转换为列表）

###### 数字列表生成器
```
range([start,] stop[, step])
```
start默认为0，stop标定终止数字（结果不含该数字），step是步进值，可正可负，默认为1。它将生成从start开始的，每项递增step，最后一项小于（step为正）或大于（step为负）的列表

###### 方法
append(x)：追加一个元素
extend(iter)：追加一个可迭代对象的所有元素（比+=运算符更高效，因为+=会创建一个新list，而extend是本地操作）
insert(i, x)：在i位置插入元素
pop(i=-1)：删除位置为i的元素并返回之
remove(x)：删除第一个值为x的元素，不存在则抛异常
index(x, start=0, stop=len)：在[start:stop]范围内返回第一个值为x的元素的位置，不存在则抛异常
count(x)：返回,值为x的元素在列表中出现的次数
sort(cmp=None, key=None, reverse=False)：排序，cmp是一个类似cmp(x,y)的比较函数，key是一个一元函数，传入列表的每个元素，返回用于比较的key，reverse为True时，表示反序排序
reverse()：反转序列
del alist：销毁列表
del alist[i]：删除列表的第i项（还可以删除一个切片）
alist[1:3] = []：切片更新操作（等号右侧必须是一个可迭代对象），将指定切片替换为赋值的列表，例子所示为删除，[1:1]相当于在1的位置插入，其他相当于替换（区别[1:2]和[1]，前者的替换是扩展式的，即右侧的可迭代对象的元素替换切片元素；而后者单索引替换则是使用右侧的对象整体替换索引位置的元素）

###### 列表解析
```
[expression for var1 in iterable1 if cond1
			for var2 in iterable2 if cond2
			...
]
```
这里，expression是var1, var2, ...组成的表达式（可以应用函数），其中var1从iterable1中取得，并满足cond1，var2从iterable2中取得，并满足cond2。注意：这里两个循环虽然是并列的，但内部是一个嵌套关系，即var1先取得一个值后遍历var2的所有值。
例如：`[x ** 2 for x in range(8) if not x % 2]`，该列表含有x取值 0~7 的满足条件的x的平方
注：若expression不含某个迭代变量，则相当于在该迭代变量变化中，取得的值都是相同的。

###### 生成器表达式
由于列表解析意味着必须生成整个列表，也就意味着可能需要占用大量的内存，而实际使用的可能仅仅是遍历其元素，而不是真的需要整个列表。于是就有了更节省内存的生成器表达式，即为列表解析中去掉 [] ，只不过为避免语法错误，通常在外面加上一个括号 ()。
生成器表达式每次仅仅产生（yield）一个元素，非常适合于迭代。只不过，生成器表达式返回的是一个生成器（generator），也是一种迭代器。

###### array 模块
一种受限的可变序列类型array，要求所有元素都必须是同一类型，它需要在构造时，指定它受限的类型：
|代码 | 等价的C类型 | 最小字节数 |
|---|---|---|
|c		|char					|1|
|u		|chaunicode char		|2|
|b/B	|chabyte/unsigned byte	|1|
|h/H	|chashort/unsigned short|2|
|i/I	|chaint/unsigned int	|2|
|l/L	|chalong/unsigned long	|4|
|f		|float					|4|
|d		|double					|8|
例如：
```
import array
a = array.array('B')			# 构造一个空数组，受限为unsigned byte
a = array.array('h', [3, 5])		# 构造一个初始化的数组，受限为short
```
索引、切片、len、append、extend、insert、pop、remove、index、count、reverse		都同list（sort不行）
其他：
a.itemsize				# 返回上述的最小字节数
a.tolist()					# 转换一个list返回
a.fromlist([3, 4])			# 同extend
a.tostring()				# 将数组转换为字节序列字符串
a.fromstring(buffer)		# 将一段buffer或str追加到数组尾
a.tofile(file)				# 将数组转换为字节序列写入到指定的文件对象中
a.fromfiles(file, count)		# 从文件对象中读取count个元素追加到数组尾
a.byteswap()				# 交换数组中元素的字节顺序

##### 1.2.3	元组
元组（(a, b, c)，括号在不引起歧义的情形下是可选的）能保存固定数量任意类型的 Python 对象（有序）（注意：只有一个元素的元祖也要保留一个逗号，用以区分括号中的标量）
元组就是一个const语义的list，也就是说它只能保证自己是不可变的，而如果其中有可变对象，如果该可变对象变化，而由于可变对象的id没有变化，并不与元组的不可变性矛盾。

###### 构造函数
tuple()				()
tuple([1, 2, 3])	(1, 2, 3) （浅拷贝构造，即元素使用引用原容器元素）
tuple("fjal")		('f', 'j', 'a', 'l')（可将其他可迭代对象转换为元组）

###### 多元赋值
实际上是隐式的元组赋值
例如：`x, y, z = 1, 2, 'a string'`，也即圆括号是可以被省略的。并且一个变量出现在右侧不会因左侧的变化而受影响，也就是其结果好像是同一计算好了右值构造了一个新的元组对象赋给左侧的各个对象。（这样就可以使用一条语句进行变量值交换）

##### 1.2.4	字典
字典（{ak:av, bk:bv, ck:cv}）保存无序的键值映射，几乎所有不可变类型（可哈希类型）都可以作为键，一般常用整数和字符串，值可以是任何类型。各个元素的键的类型都可以不同，同样值的类型也都可以不同

###### 构造函数
dict()						{}
dict(x=1, y=2)				{'x':1, 'y':2}
dict([(ak, av), (bk, bv)])	{ak:av, bk:bv}（二元可迭代对象构造字典，二元不一定是元组）
dict(d)				使用另一个字典构造，比copy方法慢

###### 方法
d[key] = value：有则改值，无则添加key:value（注：当aaa[key]不存在且作为右值时，则将抛出KeyError，不会添加）
setdefault(key, default=None)方法：有key则返回对应值（并不会修改字典），无key则将key:default加入字典，返回default
get(key, default=None)方法：类似[key]，如果存在该key则返回value；如果不存在，get返回default
key in d：判断key是否是字典的一个键
`has_key(key)`方法：判断字典中是否有这个key（推荐使用in 运算符）
keys()方法：返回所有key的列表
values()方法：返回所有value的列表
items()方法：返回一个将字典的每一项变为一个二元组组成的一个列表
iterkeys()方法：同上，只不过返回的是一个迭代子，而不是列表
itervalues()方法：同上，只不过返回的是一个迭代子，而不是列表
iteritems()方法：同上，只不过返回的是一个迭代子，而不是列表
update(dict)方法：将另一个字典dict合并到本词典中，冲突的键，则覆盖之
del d[key]：将key对应的键值对从字典中删除，若key不存在则抛出KeyError
pop(key[, default])方法：如果key存在，将key对应的键值对从字典中删除，并返回对应值；否则，如果给出default，返回default，否则就抛出KeyError异常
popitem()方法：按print序删除并返回一个元素（作为二元组形式），若字典为空，则抛出KeyError异常
clear()方法：清空字典
copy()方法：返回一个和自己一样的字典（浅拷贝）
fromkeys(iterkey, value=None)方法：返回一个字典，字典的键来自于iterkey（可迭代对象），值都是value

注意：
+ 不支持连接`+`和重复`*`操作
+ 不支持一到多的映射，相同的key，会用后value覆盖前value，即使在一个{}中，靠后的也会覆盖前面的同key项。还要注意的是相同的key不是指id相同，而是指hash相同，于是，即使类型不同，只要哈希相同，就被认定为同key.

##### 1.2.5	集合
一组无序可哈希的对象。
集合有两种：
可变集合set和不可变集合frozenset
只能使用上面两种名字的构造函数进行构造，数据源（参数）可以来自可迭代对象

###### 集合运算
比较运算符表示集合的包含关系
`&`	表示交运算
`|`	表示合运算
`-`	表示差运算
`^`	表示对称差分
这些运算和集合的类型无关

###### 可变集合方法
`add(obj)`方法：向集合增添一个元素，如果已存在则无效果
`remove(obj)`方法：从集合中删除一个元素，如果不存在，则抛出KeyError
`discard(obj)`方法：从集合中删除一个元素，如果不存在则无效果
`pop()`方法：从集合中删除任意一个元素并返回，如果集合为空，则抛出KeyError
`update(iter)`方法：向集合添加一组元素（做合运算，等价于|=）
`intersection_update(iter)`方法：仅保留共有元素（做交运算，等价于&=）
`difference_update(iter)`方法：剔除包含在iter中的元素（做差运算，等价于-=）
`symmetric_difference_update(iter)`方法：剔除共有元素，加上iter独有元素（做差分运算，等价于^=）
`clear()`方法：清空集合

###### 通用方法
`issubset(iter)`方法：本集合是否是s集合的子集，即<=运算
`issuperset(iter)`方法：本集合是否是s集合的超集，即>=运算
`intersection(iter)`方法：返回本集合和s集合的交集，即&运算
`union(iter)`方法：返回本集合和s集合的合集，即|运算
`difference(iter)`方法：返回本集合和s集合的差集，即-运算
`symmetric_difference(iter)`方法：返回本集合和s集合的XOR集（元素只属于一个集合），即^运算
上述运算返回的结果的类型取决于左操作数，即本集合的类型。方法和操作符的区别，在于方法支持传入一个可迭代对象，而运算符只支持集合间的运算
`copy()`方法：浅拷贝一个自己的副本，比构造函数要快

### 2. 其他内建类型
类型type
None（等价于 NULL）
文件file
函数function/方法instancemethod
模块
类classobj

object()
classmethod()
staticmethod()
super()
property()

### 3. 内部类型
#### 代码
代码对象是编译过的Python源代码片段，是可执行对象。通过调用内建函数compile()可以得到代码对象。代码对象可被exec命令或eval()内建函数执行。对象本身不含任何执行环境信息，在被执行时动态获得上下文。事实上，代码对象是函数的一个属性（函数还有其他属性，如函数名、文档字符串等）

#### 帧（frame）
帧对象表示Python的执行栈帧。包含了所有Python解释器所需的执行环境信息。每次函数调用就会产生一个新的帧。

#### 跟踪记录（traceback）
当异常发生时，一个含有该异常的堆栈跟踪信息的跟踪记录对象被创建。如果一个异常有其处理程序，处理程序就可以访问这个对象。

#### 切片（slice）
当使用切片语法时，将创建切片对象。切片语法包括：步进切片，多维切片，省略切片。
步进切片的语法见上
多维切片的语法是：seq[start1:end1, start2:end2]
省略切片的语法是seq[..., start1:end1]
切片也可以使用内建函数slice()生成。

#### 省略（ellipsis）
省略对象用于省略切片中，作为一个记号。类似None，它也只有一个名字Ellipsis，布尔值恒为True。

#### XRange
当调用内建函数xrange()时，将生成一个XRange对象，该函数用于需要节省内存时或range()函数无法完成的超大数据集的场合，它只被用在for循环中，性能远高于range()。

## 第四章. 运算符、表达式、语句
### 1 运算符和表达式
#### 1.1 赋值与销毁
Python的变量都是引用，因此，对于一个频繁使用的其他模块、类变量，可以用一个本地的局部变量去接收该引用，既能简化写法，又能提高访问效率。
在赋值时，不管这个对象是新创建的，还是一个已经存在的，都是将该对象的引用（并不是值）赋值给变量。并且Python 的赋值语句不会返回值，这是因为Python支持链式赋值，例如
```
y = x = x+1
```
表示创建一个对象保存x+1的结果，并将这个对象的引用分别赋给x和y。

因为赋值语句不会返回值，所以不能用在任何需要值的位置，比如if/while 判断，lambda 表达式中。

销毁对象的引用：del x, y, ...

##### 增量赋值
支持增量赋值（例如`*=`），但不支持自增自减（连用的+/-表示两个单目的+/-），它和一般格式的赋值不同的是，对于可变对象，这种赋值是直接修改对象，而不是运算后重新申请一个对象，再赋引用给这个变量

##### 多元赋值
使用基于元组的多元赋值：
```
(go_surf, get_a_tan_while, boat_size, toll_money) = (1,'windsurfing', 40.0, -2.00)
```
左右的括号都可以省略
并且，右侧的值是在全部都计算完毕之后，才赋给左边的；由于是基于元祖的多元赋值，因此，必须保证左右两边的个数相同。

#### 1.2 算术运算符
`+`
`-`
`*`
`/`（类型相关的除法，整数执行地板除，浮点数执行真除法）
`//`（地板除，⌊x/y⌋）
`%`（取余，计算公式：x%y=x-⌊x/y⌋×y）
`**`（幂，乘方，另有内置函数pow(x, y)）

从上可以发现：`a == (a//b)*b + a%b`
这个等式无论正数还是负数，或是浮点数、复数都是成立的（注：复数的地板除，是对实部下取整，虚部为0）

##### 幂运算与单目运算符
幂运算比其左侧的单目运算符优先级高，比其右侧的单目运算符优先级低，单目运算符又高于其他双目运算符。
即`-10**-2` 表示的是`-(10**(-2))`

##### 内置的算术函数
abs(x)，取绝对值或复数的模
divmod(x, y)，取得由`x//y`和`x%y`组成的二元组
pow(x, y[, z])，两个参数同`x**y`，三个参数同`x**y % z`，但效率更高，用于密码计算
round(num, ndigit=0)：对num四舍五入到小数点后ndigit位（可以为负数），返回之（float类型）（对于负数，先对正数四舍五入，再取负）。（注意：虽然名义上是四舍五入，但由于float的精度问题，当舍入位为5且后无尾数时，并不能保证一定就进位，比如round(0.15,1)得到0.1，而round(0.05+0.1,1)得到0.2。
int(x)，截断x的小数部分（正数下取整，负数上取整）

##### math 模块
math.pi
math.inf，float('inf')
math.nan，float('nan')
math.e，自然指数
math.floor(x)，将x下取整
math.ceil(x)，将x上取整
math.factorial(x)，x!

#### 1.3 比较运算符（返回True或False的布尔值）
<       <=      >       >=      ==      !=      <>（同前者，不推荐）
特别的，像`3 < 4 < 5`这种语句也是合法的（连用比较运算符相当于隐式使用and运算）

##### 对象比较的逻辑
1. 同类型比较
    + 数字类型的比较，自动进行转换而后比较（注：complex无法参与任何比较）
    + 字符串比较，逐字符按字典序比较，若不同则直接返回结果，否则继续，若一个先比较完所有字符，则其较小。
    + 列表和元组的比较，逐元素进行比较，若不同则直接返回结果，否则继续，若一个先比较完所有元素，则其较小。
    + 字典的比较，首先比较len，长者较大；相同长度，则按keys()顺序比较各个键，若不同则返回结果；否则再比较各个键对应的值，若不同则返回结果，否则则相同。
    + Instance，classobj之间比较？？？（实例和类型均按名的字符串比较）
1. 混合类型比较
instance  <  数字型  <  classobj  <  dict  <  function  <  list  <  str  <  tuple

##### 内置的比较函数
cmp(obj1, obj2)
    If obj1 < obj2: return 负整数
    If obj1 > obj2: return 正整数
    If obj1 == obj2: return 0
如果比较用户自定义对象，则会调用类的`__cmp__()`方法

#### 1.4 is (not) （返回True或False的布尔值）
用is或is not判断两个变量是否指向同一对象，相当于id(a) == id(b)或id(a) != id(b)

#### 1.5 逻辑运算符与条件表达式
and     or      not
优先级低于比较运算符

支持短路计算：
x and y：判断x为False，则返回x；x为True，则返回y
x or y：判断x为True，则返回x；x为False，则返回y
于是，可以从此模拟出三目表达式：(cond and [x] or [y])[0]，这里之所以使用列表，是为了保证x恒为True值；
但事实上，正规的写法应该是x if cond else y

#### 1.6 位运算（仅用于整数）
~    &    |    ^    <<    >>
其中 << 左移运算，对int左移溢出后，会自动转变为long，而不会变为异号或为0

设value为一个值，bit为指定位为1的值：
打开位：value |= bit
关闭位：value &= bit
切换位：value ^= bit
测试位：if value & bit:

### 2 语句
#### 2.1 条件语句
```
if expression1:
    代码块1
elif expression2:       # 可选任意多个：当expression1为False时进行测试
    代码块2
else:                   # 可选：当expression? 均为False时执行
    代码块3
```
如果expression的值非0或为True，则执行对应的代码块。

#### 2.2 循环语句
```
while expression:
    代码块
else:                # 可选：当expression为False时执行，当break跳出则不执行
    代码块
```

```
for 迭代元 in 可迭代对象:
    代码块
else:             # 可选：迭代结束后执行，当break跳出则不执行
    代码块
```
可迭代对象包括：字符串（字符），列表和元组（元素），字典（key），文件对象（行）等

+ 为了产生计数循环，可以使用range函数或xrange函数作为序列发生器。
+ 对于一个字符串或序列，如果想要同时迭代它的位序和值，可以使用enumerate函数生成一个新的迭代器（详见下）：`for i, ch in enumerate(foo):`

##### for 实现机制 与 迭代器
for循环的机制：
1. 调用可迭代对象的`__iter__()`方法获得迭代器（通过iter()这个内建方法）
1. 每次循环迭代调用迭代器的next()方法获得遍历的下一个数据
1. 捕获到StopIteration异常，循环结束（当全部数据取完后会抛出一个StopIteration异常，以告知迭代完成）

+ 可迭代对象是一个有`__iter__()`方法的对象，该方法返回这个可迭代对象的迭代器。
+ 迭代器是一个有next()方法的对象（当然，通常迭代器本身也是可迭代对象，所以可以在`__iter__()`方法中返回自身）。

*注：迭代器只能单向遍历（不能回溯），而且不能复制，只能重新创建。*

序列、字典、集合、文件对象都是可迭代对象
只不过序列和集合迭代的是成员；字典迭代的是key，因为可以通过key找到value；文件对象迭代的是行。

> iter函数
iter(obj)，obj是可迭代对象，返回该可迭代对象的迭代器
iter(func, sentinel)，返回一个迭代器不断调用这个函数，直到它返回sentinel就抛出StopIteration异常

> next函数
next(iterator[, default])
调用iterator的next()方法返回下一个元素，如果给定default 参数，则不抛StopIteration异常，改为返回default。

##### 与迭代有关的函数
+ reversed(seq)：返回该序列seq的逆序迭代器
+ sorted(iter, cmp=None, key=None, reverse=False)：返回一个有序的列表，其他的可选参数同列表的sort方法
+ enumerate(iterable[, start])：iterable为一个可迭代对象，start设置迭代的起始位置，返回一个可迭代对象，该对象每次next会生成一个由(位序, 值)构成的二元组。
+ filter类
    - filter(func, iter)：func是一个判断函数对象，返回func判断为True的元素的列表，即每次从iter中取出一个元素，作为func的参数进行判断，若为True则加入结果中，返回的具体类型和iter的类型一致。如果func为None，则func相当于bool()，即判断元素本身的布尔值。
+ map类
    - zip(iter1, iter2, …)：返回一个元组的列表，其中第一个元组由这些序列的第一个元素依次组成，第二个元组由这些序列的第二个元素依次组成，直到其中一个序列取完为止。即返回的列表长度和这些序列中最短的一个相同。
    - map(func, iter1[, iter2, …])：func是一个函数对象，返回func结果的列表，即每次从各个序列中取出一个元素作为func的参数（具体是先组成一个元组，再使用`*tuple`传参），返回结果依次作为结果列表的一个元素，如果某些序列提前耗尽，则后续均为None。如果func指定为None，则func的行为就是直接返回组成的这个元组（行为类似zip，但zip返回的列表长度取决于序列中最短的一个，而map返回的序列长度则取决于序列中最长的一个）
+ reduce类
    - any(iter)：如果可迭代对象iter至少存在一个bool(x)为True的元素x，则返回True，否则返回False
    - all(iter)：如果可迭代对象iter为空，或所有元素x的bool(x)都为True，则返回True，否则返回False
    - sum(iter, init=0)：返回数值序列和init的总和（效果同reduce(operator.add, seq, init)）
    - max(iter, key=None)，min(iter, key=None)：key是一个函数返回一个用于比较的值，按该函数返回的值选出迭代对象中的最大和最小值。（此外，这两个函数还有一个可变参数版本：max(arg1, arg2, …, key=None)，min(arg1, arg2, …, key=None)
    - reduce(func, iter[, init])：func是一个需要两个参数的函数对象，每次从iter中取出一个元素和上次func的结果作为本次func的参数，如果提供了init参数，则初始init作为上次func的结果，如果未提供init参数，则首次取iter的两个元素作为func的参数。这里func不能是None。

##### 相关模块
itertools
1. 无限迭代器
1. 排列组合
1. 终止于最短的输入序列的迭代器
支持无限迭代的输入
<http://www.cnblogs.com/huxi/archive/2011/07/01/2095931.html>

#### 2.3 continue、break、pass
continue语句：跳过循环中剩下语句，进行下次迭代（进行条件检查或调用next()）
break语句：跳出循环
pass语句：空语句的占位符

## 第五章. 函数
### 1. 函数定义
```
def func_name([args]):
    'optional documention string'
    函数代码块
```
注意：
不支持函数重载，但可以通过type()确定参数类型来实现
支持调用在前，定义在后
函数调用时，小括号不可省略
支持递归
关键字参数：通过形参名来指定参数，可以不按顺序

#### 1.1 参数
参数是引用传递，所以对于可变对象，函数内的改变影响原始对象，而不可变对象则不影响
##### 1.1.1 默认参数
参数可以用赋值符给以默认参数，同样必须在所有非默认参数之后
**注意：函数的默认值是在函数定义时确认，并将该值存储起来，当默认值启用时，就使用该存储起来的值，类似于类的静态变量；有个问题就是如果该默认值是一个可变对象，那么如果函数中对这个使用默认值的参数进行的修改就会影响到这个存储起来的值，从而对下次使用默认值的函数调用造成影响**
例如：
```
def foo(a=[]):
    a.append('aa')
    return a

print foo() # 多次调用的结果不同
```
虽然和直觉相违，但也可以利用该特性做一些事情，比如记录一个函数距上次调用经过的时间：
```
import time
def dur( op=None, clock=[time.time()] ):
    if op != None:
        duration = time.time() - clock[0]
        print '%s finished. Duration %.6f seconds.' % (op, duration)
    clock[0] = time.time()
```
即利用列表默认值，实现了函数静态变量的特性


##### 1.1.2 可变参数
可变长参数必须在其他参数之后（并且关键字可变参数需在位序可变参数之后），例如：
```
func(*tuple_args, **dict_args)
```
额外的位序参数将封装为元组`tuple_args`, 额外的关键字参数封装为字典`dict_args`
说明：`*`运算符可以把序列拆解为多个参数，`**`运算符可以把字典拆解为多个关键字参数

#### 1.2 返回值
动态返回类型：能返回不同类型
如果函数无return语句，则将返回None对象
##### 1.2.1 多值返回
实际返回的是元组，只不过语法上可以不需要括号（同样，在接受多值返回时，也可以不需要括号）

### 2. 函数对象
函数定义就声明了一个函数对象，函数名就是这个函数对象的引用，可以赋给其他变量或作为参数传递

支持函数嵌套定义，因为函数是对象，内部定义的函数相当于一个在外部函数的作用域内函数对象实例
函数嵌套定义的作用是内部函数可以访问外部函数作用域内的变量，从而形成闭包

#### 2.1 属性
`func_name`：和`__name__`一样，函数名
`func_doc`：和`__doc__`一样，函数的文档注释
`func_closure`：用于存储每个自由变量。如果没有自由变量，则为None；否则其值是一个元组，元组的每个元素是cell类型，存储一个自由变量
`func_defaults`：函数的默认值元组
`func_code`：code 对象

#### 2.2 闭包
闭包是一个定义于函数内部的函数，且其引用了外部函数的局部变量（这些被引用的外层局部变量被称为自由变量）
+ 注意1：如果内部函数定义了外部函数同名的局部变量，则同样会覆盖自由变量的引用
+ 注意2：不光内部函数本身引用，该内部函数的内部函数的引用，也算该层的一个自由变量
+ 注意3：列表解析不能生成一个函数上下文
例如：
```
fs = [(lambda n: i + n) for i in range(10)]
```
由于列表解析不能生成一个函数上下文，所以lambda 表达式中的这个i 并不是绑定到具体的数字，而是绑定到当前上下文的这个i 的变量上，i 这个变量的最终值是9，所以`fs[3](4)`的结果就是13
要写创建一个真正意思上的闭包：
```
fs = map(lambda i: lambda n: i+n, range(10))
```
这里，外层的lambda 表达式形成了一个新的函数上下文，内部的lambda 就把它的i 绑定到这个自由变量上，因此，`fs[3](4)`的结果就是期望的7

### 3. 装饰器
也是一种函数，如果装饰器没有参数，那么其参数是被装饰的函数(对象)，返回被装饰后的函数(对象)；如果装饰器有参数，则通过参数调用，返回一个无参数的装饰器
即：
@deco1(deco_arg)
@deco2
def func():
    pass
相当于func = deco1(deco_arg)(deco2(func))
通过装饰器，可以实现AOP编程

### 4. 匿名函数lambda
```
lambda [arg_list]: expression
```
`arg_list`可省，可以有默认参数和可变参数
expression的结果就是返回值
结果是一个函数对象
**注意：expression 只能是单条表达式语句，而且该语句不能是赋值语句和print 语句，因为它们没有返回值**

### 5. 偏函数
即其他语言中的参数绑定
使用functools.partial()方法
偏函数是默认参数的一种有益补充，因为默认参数是在定义时给定，而且只能逆序指定；而使用偏函数绑定的参数是动态的，而且可以通过关键字绑定到任意的参数上
例如：
```python
from operator import add, sub
from functools import partial

inc = partial(add, 1)       # 按序绑定到add函数的第一个参数
dec = partial(lambda a,b:sub(a,b), b=1)     # 关键字绑定到匿名函数的b参数上
print inc(10)
print dec(10)
```

### 6. 生成器
从句法上，生成器函数是一个带yield 语句的函数，该函数返回一个生成器。
生成器可以看做迭代器的一个简易的实现（使用的是函数，而不是类），但更重要的是生成器可以实现协程。

#### 6.1 生成器的执行
从生成器函数调用者角度，调用生成器函数可以获得一个生成器（不会执行生成器函数的代码），生成器也是一个可迭代对象，可以调用生成器的next() 函数，以获得生成器函数下一次通过yield 返回的值，如果没有yield 语句或者遇到return 的话就抛出StopIteration 异常。
从生成器角度，从第一次调用next() 函数，开始执行生成器函数代码，直到遇到yield 语句，该语句会挂起生成器的执行，保存函数状态，直到调用者再次调用next() 或send() 重新激活生成器，才恢复执行。

#### 6.2 和生成器进行交互
生成器的调用者可以通过send() 函数给生成器进行传值，可以通过close() 函数要求生成器退出（退出后再调用生成器的next() 方法将抛出StopIteration 异常）。
生成器可以抛出异常
为了使生成器获得调用者给其的传值，yield 语句会返回一个值，该值就是调用者传入的值（如果调用者使用的是next() 未传值，则该返回值为None）。


## 第六章. 对象和类
### 1. 类定义
```
class ClassName(base_class[es]):
    "optional documentation string"
    static_member_declarations

    method_declarations(self)
```
`base_class`声明基类，如果没有指定，则使用 object 作为基类（object是最基本的类型）
每个实例方法第一个参数都是self，它是对象实例的引用，对象的私有成员和类的静态成员都可以使用它引用，例如通过`self.__class__.__name__`可以得到类名（`self.__class__`这个引用实际的类）
构造器：`__init__(self)`（实际上是对象创建后自动执行的第一个方法，执行初始化工作），如果没有显式定义该方法，则默认提供一个空的构造器。
foo = ClassName()就创建了一个该类的实例。当一个实例被创建，`__init__()`就会被自动调用。

```
class A:
    pass

class B(object):
    pass

a = A()
b = B()
type(A)        # <type ‘classobj’>
type(a)        # <type ‘instance’>
type(B)        # <type ‘type’>
type(b)        # <class ‘__main__.B’>
```

访问权限、嵌套类?

## 第七章. 模块
当你创建了一个 Python 源文件，模块的名字就是不带 .py 后缀的文件名

导入模块：`import module_name [as alias_name]`
访问模块中的：
```
module_name.variable
module_name.function()
```
导入模块中的内容：`from module_name import var`
而后就可以不用`module_name`直接访问var
不加前缀的`__name__`就表示显示当前模块的名字，一般作为主模块直接执行的`__name__`都是`__main__`，而被import的模块使用`__name__`则显示该模块的模块名。

查找模块的路径？

### 1. 作用域
在函数中定义的变量拥有函数级作用域（局部作用域），在函数外定义的变量拥有模块级作用域（全局域）
当搜索一个标识符的时候,python 先从局部作用域开始搜索。如果在局部作用域内没有找到那个名字，就就会逐层向外查找该标识符（自由变量），直到全局域确认这个变量是否存在，最后确认该标识符是否是一个内置标识，如果依然找不到就会被抛出 NameError 异常。

#### 1.1 函数作用域
如果函数没有对全局变量（以及外部的自由变量）进行赋值，则可以直接读取该变量的值；
如果函数内对全局变量（以及外部函数的同名变量）赋值，则视为定义了一个局部变量隐藏了同名的全局变量（或外部变量），而如果在赋值前读取该变量的值将抛出 UnboundLocalError 异常；
想要真正对全局变量赋值，需使用`global var[, var, ...]`声明（位于对全局变量的读写操作之前，否则会有警告）
Python 3.x引入了nonlocal 关键字，和global 功能类似，用于声明一个变量是外部（自由）变量，并且在当前作用域中需要修改这个外部变量。

### 2. 常用模块
#### time 模块
有两种时间表示方式：时间戳表示，元组表示
1. 时间戳表示：从Epoch 而来的秒数（整数或浮点，范围在1970 – 2038 之间）
1. 元组表示：9个整数分别表示年月日，时分秒，星期（周一是0），一年中的第几天，DST
在python中，有个`struct_time`就是这个9元组的一个表示

> **GMT 格林威治标准时间（Greenwich Mean Time）**，是指位于伦敦郊区的皇家格林威治天文台的标准时间，因为本初子午线（Prime meridian）被定义为通过那里的经线。GMT也叫世界时UT。
> **UTC 协调世界时间（Coordinated Universal Time）**, 又称世界标准时间，基于国际原子钟，误差为每日数纳秒。协调世界时的秒长与原子时的秒长一致，在时刻上则要求尽量与世界时接近（规定二者的差值保持在 0.9秒以内）。
> **时区** 是地球上的区域使用同一个时间定义。有关国际会议决定将地球表面按经线从南到北，划分成24个时区，并且规定相邻区域的时间相差1小时。当人们跨过一个区域，就将自己的时钟校正1小时（向西减1小时，向东加1小时），跨过几个区域就加或减几小时。比如我大中国处于东八区，表示为GMT+8。
> **夏令时 （Daylight Saving Time：DST）**，又称日光节约时制、日光节约时间或夏令时间。这是一种为节约能源而人为规定地方时间的制度，在夏天的时候，白天的时间会比较长，所以为了节约用电，因此在夏天的时候某些地区会将他们的时间定早一小时，也就是说，原本时区是8点好了，但是因为夏天太阳比较早出现，因此把时间向前挪，在原本8点的时候，订定为该天的9点(时间提早一小时)～如此一来，我们就可以利用阳光照明，省去了花费电力的时间，因此才会称之为夏季节约时间！
> **闰秒** 是的，不只有闰年，还有闰秒。闰秒是指为保持协调世界时接近于世界时时刻，由国际计量局统一规定在年底或年中（也可能在季末）对协调世界时增加或减少1秒的调整。由于地球自转的不均匀性和长期变慢性（主要由潮汐摩擦引起的），会使世界时（民用时）和原子时之间相差超过到±0.9秒时，就把世界时向前拨1秒（负闰秒，最后一分钟为59秒）或向后拨1秒（正闰秒，最后一分钟为61秒）； 闰秒一般加在公历年末或公历六月末。
> **Unix时间戳** 指的是从协调世界时（UTC）1970年1月1日0时0分0秒开始到现在的总秒数，不考虑闰秒。

##### 函数
sleep(seconds)：线程休眠，seconds是一个浮点数
time()：返回当前时间的浮点时间戳

1. 时间戳 => 9元组格式
gmtime([seconds])：不提供时间戳，则使用当前时间；使用UTC时间，亦即GMT
localtime([seconds])：不提供时间戳，则使用当前时间；使用本地时间
1. 时间戳 => 字符串
ctime([seconds])：转换为形如'Sat Jun 06 16:26:11 1998'的字符串；无参使用localtime()的返回值
1. 9元组格式=> 时间戳
mktime(tuple)：转换为浮点时间戳
1. 9元组格式 => 字符串
asctime([tuple])：转换为形如'Sat Jun 06 16:26:11 1998'的字符串；无参使用localtime()的返回值
strftime(format[, tuple])：format, 不提供元组使用localtime()的返回值
1. 字符串 => 9元组格式
strptime(string, format)：parse
其中format的格式化符号有：
  %y 两位数的年份表示（00-99）
  %Y 四位数的年份表示（000-9999）
  %m 月份（01-12）
  %d 月内中的一天（0-31）
  %H 24小时制小时数（0-23）
  %I 12小时制小时数（01-12）
  %M 分钟数（00-59）
  %S 秒（00-61）

  %a 本地简化星期名称
  %A 本地完整星期名称
  %b 本地简化的月份名称
  %B 本地完整的月份名称
  %c 本地相应的日期表示和时间表示
  %j 年内的一天（001-366）
  %p 本地A.M.或P.M.的等价符，“%p”只有与“%I”配合使用才有效果
  %U 一年中的星期数（00-53）星期天为星期的开始（第一个星期天之前的所有天数都放在第0周）
  %w 星期（0-6），星期天（0）为星期的开始
  %W 一年中的星期数（00-53）星期一为星期的开始
  %x 本地相应的日期表示
  %X 本地相应的时间表示
  %Z 当前时区的名称
  %% %号本身

#### datetime 模块
实现了日期和时间的类型，用于算术运算
类date、time、datetime（继承date）、timedelta

##### date 类
date(year, month, day)
参数必须在取值范围内（year 必须在[datetime.MINYEAR, datetime.MAXYEAR]区间中）
hashable（可用于字典key）

支持比较

###### 类属性
min/max
resolution：最小日期差（timedelta(days=1)）
###### 实例属性（只读）
year、month、day
###### 类方法
today()：返回本地的当天日期对象
fromtimestamp(timestamp)：将一个时间戳转换为日期对象
fromordinal(ordinal)：将一个日期序数转换为日期对象，以date(1, 1, 1)为1，date(1, 1, 2)为2，以此类推
###### 实例方法
replace(year=None, month=None, day=None)：修改日期中某部分的值，生成一个新的日期对象
timetuple()：返回`time.struct_time`类型的9元组
toordinal()：返回日期序数
weekday()：返回星期（0是周一，6是周末）
isoweekday()：返回星期（1是周一，7是周末）
isoformat()：返回形如'2002-12-04'的字符串，也就是str()函数的返回结果
ctime()：返回ctime格式字符串
strftime(format)：返回指定格式的字符串
`__format__(format)`：支持str对象的format 方法

##### time 类
time([hour[, minute[, second[, microsecond[, tzinfo]]]]])
和date类构造方法一样，构造参数必须在指定区间之内
hashable（可用于字典key）

支持比较
注意：不支持算术运算

###### 类属性
min/max
resolution：最小时间差（timedelta(microseconds=1)）
###### 实例属性（只读）
hour、minute、second、microsecond、tzinfo
###### 实例方法
replace(hour=None, minute=None, second=None, microsecond=None, tzinfo=None)：修改time 中某部分的值
isoformat()：返回形如'00:00:00.000000'的字符串，也就是str()函数的返回结果
strftime(format)：返回指定格式的字符串
`__format__(format)`：支持str对象的format 方法

##### datetime 类
datetime(year, month, day[, hour[, minute[, second[, microsecond[,tzinfo]]]]])
和date类构造方法一样，构造参数必须在指定区间之内
hashable（可用于字典key）

支持比较

###### 类属性
min/max
resolution：最小时间差（timedelta(microseconds=1)）
###### 实例属性（只读）
year、month、day、hour、minute、second、microsecond、tzinfo
###### 类方法
today()：返回本地的当前的datetime对象
fromtimestamp(timestamp[, tz])：将一个时间戳转换为本地的datetime 对象
fromordinal(ordinal)：将一个日期序数转换为datetime 对象（时分秒均为0，tz为None），以date(1, 1, 1)为1，date(1, 1, 2)为2，以此类推
now([tz])：如果不带tz参数，相当于today()方法，如果带tz参数，则其为tzinfo的一个子类实例，这样当前时间将被转化为指定的time zone。
utcnow()：返回当前的UTC datetime 对象
utcfromtimestamp(timestamp)：UTC 版本的fromtimestamp
combine(date, time)：组合date 对象和time 对象（包括其tz信息）为一个datetime 对象
strptime(dateString, format)：将一个字符串按指定格式转化为一个datetime 对象
###### 实例方法
replace(year=None, month=None, day=None, hour=None, minute=None, second=None, microsecond=None, tzinfo=None)：修改datetime 中某部分的值
timetuple()：返回`time.struct_time`类型的9元组
toordinal()：返回日期序数
weekday()：返回星期（0是周一，6是周末）
isoweekday()：返回星期（1是周一，7是周末）
isoformat(sep='T')：返回形如'2002-12-04T00:00:00.000000'的字符串，sep必须是单字符用于分隔时间和日期，如果sep=' '也就是str()函数的返回结果
ctime()：返回ctime格式字符串
strftime(format)：返回指定格式的字符串
`__format__(format)`：支持str对象的format 方法
date()：返回一个date 对象
time()：返回一个time 对象（tz为None）
timetz()：返回一个带tz 的time 对象
astimezone(tz)：将时间转换到指定的tz 上
utctimetuple()：UTC 版本的timetuple

##### timedelta 类
timedelta(days=0, seconds=0, microseconds=0, milliseconds=0, minutes=0, hours=0, weeks=0)
日期差值类型
实例化参数支持整数、浮点数、正数负数
由于内部只保存days、seconds、microseconds这三个属性，其他的参数将被转换到这三个属性上（浮点数可能会导致微秒级的精度丢失），并正规化到合理的区间（正规化的顺序是从microseconds 到 days）
hashable（可用于字典key）

该对象支持+-运算，支持对乘整数和整除整数，支持取反，abs，比较
还可以对date/datetime对象进行加减运算

`total_seconds()`返回时间区间的秒数（浮点）

#### calendar 模块
isleap(year)：是否是闰年


#### smtplib 模块
smtplib 模块主要通过SMTP类和其子类`SMTP_SSL`定义一个SMTP 客户端会话对象来完成邮件发送

`SMTP([host[, port[, local_hostname[, timeout]]]])`
如果提供了host 参数，将自动调用connect() 方法，连接指定的SMTP 服务器
port 是SMTP 服务的端口，默认是25

`SMTP_SSL([host[, port[, local_hostname[, keyfile[, certfile[, timeout]]]]]])`
其实例的行为和SMTP 的实例行为一致，仅当连接时必须使用SSL 时使用。
如果host未指定，则使用localhost；如果port忽略，则使用默认的SSL端口465；

##### 方法
1. `set_debuglevel(level=False)`：默认非调试模式，不会输出调试信息。
1. connect([host[, port]])：默认连接localhost 和默认的SMTP端口25。如果host以":number"结尾，则host将截去这部分，并解析为port。返回一个二元组(状态码，连接信息)
1. login(user, password)：当需要身份验证时调用之。
1. `sendmail(from_addr, to_addrs, msg[, mail_options, rcpt_options])`：发送邮件，只要有一个接收者正常接收，该函数就正常返回，否则将抛出异常。
`from_addr` 参数的格式必须是 RFC 822 的地址字符串；`to_addrs` 参数是该格式的字符串列表（如果只有一个的话，也可以是一个字符串）。msg是一个字符串，必须按照指定的格式指定发件人、收件人、标题、内容、附件等信息，通常使用email模块的类进行构造。
该函数返回一个字典，key是没有发送成功的`to_addr`，val是一个二元组`(SMTP_error_code, 错误信息)`
1. quit()：结束SMTP 会话并关闭连接

#### email 模块
<https://docs.python.org/2/library/email.html>

#### types 模块
标准解释器的类型名

##### 模块常量
IntType
FloatType
StringType
ListType
TupleType
DictType
GeneratorType

#### inspect 模块
反射信息

##### 函数
ismodule()
isclass()
ismethod()
isfunction()
isgeneratorfunction()：判断是否是生成器函数
isgenerator()：判断是否是一个生成器
istraceback()
isframe()
iscode()
isbuiltin()


## 第八章. IO相关
### 1. 文件对象file
文件对象不仅可以访问普通的磁盘文件，还可以访问其他抽象的“类文件”。一旦设置了合适的“钩子”，就可以通过文件对象的接口访问其他文件，就好像访问普通文件一样。这是因为，文件就是一种字节流的抽象。

#### 1.1 创建（打开文件）
##### 1.1.1 open()
```
open(file_name, access_mode = 'r', buffering=-1)
```
`file_name`是打开文件名的字符串（可使用绝对路径和相对路径）
`access_mode`是打开模式，'r' 表示读取（默认，文件必须存在），'w' 表示覆写（没有则新建，有则清空原内容重写）， 'a' 表示追加（没有则新建）；可叠加的：'+' 表示读写（r+要求文件必须存在，w+若已存在会清空），’U’通用换行符支持（通常配合r和a，如果使用该选项打开文件，则在文件读入python时，无论原来的EOL是什么，都将替换为\n）， 'b'表示二进制访问（为了兼容非Unix的文本文件）
buffering：0表示无缓冲，1表示行缓冲，更大的数表示指定的缓冲大小（大约字节数），负值表示使用系统默认缓冲机制（通常是全缓冲）。
如果 open() 成功，一个文件对象会被返回。

##### 1.1.2 file()
file(name, mode=’r’, buffering=1)
和open完全通用，推荐使用open()函数

#### 1.2 属性
+ name：文件名
+ mode：打开模式
+ encoding：文件编码，None使用系统默认编码。当Unicode字符串被写入时，将自动使用该编码转换为字节字符串
+ closed：标记文件是否已经关闭
+ newlines：文件中使用的换行符模式（是一个tuple）
+ softspace：空格是否显示的标识，默认是false（表示输出数据后加上一个空格符，true表示不加）

#### 1.3 方法
##### 1.3.1 关闭文件对象close()
尽管python的垃圾收集会在文件对象的引用计数减为0时自动关闭文件对象。但那可能会丢失缓冲区数据。

##### 1.3.2 读文件
+ read([size])：至多读取size个字节，返回字符串。若size缺省，则读到EOF为止。
+ readline([size])：至多读取size个字节，返回字符串。若size缺省，则读取一行（带换行符），若遇到EOF，则返回空串
+ readlines([size])：将文件按行读取，返回字符串列表。如果指定了size，则至多读取大约size个字节的行（这里是大约，因为，实际会读取多于size个字节，因为它会按size指定的大小，凑足内部缓冲的整数倍）
+ next()：为文件对象进行迭代。

##### 1.3.3 写文件
+ write(str)：向文件写入字符串str。由于buffer，需要调用flush或close才能刷新到文件。
+ writelines(str_iter)：将字符串迭代对象逐个写入文件（并不会写入额外的换行符）

##### 1.3.4 文件指针
+ seek(offset, whence=0)：whence是偏移基准，默认是0（文件头），还可以是1（当前位置），2（文件尾）。而offset是偏移量（单位字节），注意：如果是text模式打开文件，则不允许定位于文件尾之后的位置。此外，并不是所有文件对象都可以被seek的（比如以’a’模式打开的文件）。
+ tell()：返回当前读写文件偏移量（字节数）。

##### 1.3.5 杂项
+ truncate([size])：把文件裁成指定的大小（字节数），size默认是tell()的返回值。
+ fileno()：返回一个整型的文件描述符，用于底层的文件接口，如os.read()
+ isatty()：是否关联到一个类tty设备上
+ flush()：刷新内部的文件buffer（立即写到文件中）

#### 1.4 遍历
文件对象是一个可迭代对象，使用for in 则遍历文件每一行（含行末的换行符。注：这里的文件读写调用C的文件读写函数，因此不必考虑系统行分隔符的差异，因为，即使在Windows下，’\n’也将被转换为’\r\n’）。
遍历的性能优于使用readlines遍历列表，因为readlines是一次性将文件读入，对于大文件需考虑内存的占用，而使用迭代方式一次仅仅会读取一行。

#### 1.5 标准文件对象
标准输入sys.stdin（一般是键盘）
标准输出sys.tdout（到显示器的缓冲输出）
标准错误sys.tderr（到显示器的非缓冲输出）
这三个文件对象是预置的，无须打开，只要导入sys模块即可访问这三个对象。

### 2. os 模块
该模块实际上只是真正加载的模块的前端，而真正加载的模块与具体的操作系统有关，比如：posix（适用于Unix）、nt（Win32）、mac（旧版的MacOS）、dos（DOS）、os2（OS/2）等。不需要直接导入这些模块，只需导入os 模块，Python会自动选择正确的模块。（根据某个系统支持的特性，可能无法访问到一些在其他系统上可用的属性）

#### 2.1 模块属性
linesep        系统的行分隔符。（如Windows使用'\r\n'，Linux使用'\n'）
sep            用来分隔文件路径名的字符串
pathsep        多个路径之间的分隔符（如Windows使用’;’，Linux使用’:’）
curdir        返回当前目录（’.’）
pardir        返回当前目录的父目录（’..’）

#### 2.2 模块方法
##### 2.2.1 文件与目录
+ getcwd()/getcwdu()         返回当前工作路径的字符串（后者是Unicode字符串版本）
+ chdir(path)                将当前的工作路径变更为指定的位置（即，影响上一个函数的返回值）
+ chmod(path, mode)          改变path的访问属性
+ listdir(path)              返回一个列表，元素相当于ls -A的字符串
+ walk(top, topdown=True, oneerror=None, followlinks=False)
递归遍历top目录的目录树。
该函数是一个生成器函数，每次生成一个三元组：(dirpath, dirnames, filenames)，其中dirpath是当前遍历的目录的路径，dirnames是dirpath下的目录名列表，filenames是dirpath下的非目录的文件名列表。
默认遍历顺序是自上而下，即从top开始，而后依次递归遍历dirnames中的各个目录，如果topdown为False，则将先递归遍历dirnames中的各个目录，而后才到top，但无论topdown的值为何，dirnames总是在确定dirpath生成的，于是如果topdown为True，遍历过程中对dirnames的修改会影响递归中遍历哪些子目录和顺序，而topdown为False，遍历过程中的修改是无效的。
默认忽略os.listdir()的错误，而oneerror可以指定一个接受一个参数（一个os.error的实例）的函数，它可以被用于报告遍历过程中的出错，或者抛出异常终止遍历。
默认不跟踪符号连接，followlinks为True后可以改变着一点。
（注意：在遍历期间不要改变当前的工作目录）
+ mkdir(path, mode=0777)    创建一个mode访问权限的目录（如果中间路径不存在，并不会递归创建中间路径，递归版本是makedirs）
+ rmdir(path)                删除一个目录（也有一个递归版本：removedirs，它会按path由右向左依次删除，直到整个path都被删除或者遇到一个错误，该错误将被忽略，因为它一般是因为已经不满足删除条件，即非空目录）
+ remove(path)                删除一个文件，和unlink(path)相同
+ rename(old, new)            重命名一个文件或目录（也有一个递归版本renames，它会像makedirs一样为new创建中间路径，而后像removedirs一样递归删除old的中间目录。）
+ access(path, mode)            测试path，mode可以是`F_OK`不是是否存在，也可以是`R_OK`、`W_OK`、`X_OK`或其组合，表示是否具有该访问属性。
+ utime(path, (atime, mtime))    设置path的access时间和modified时间，如果第二个参数为None，则置为当前时间
+ stat(path)                    在指定的路径执行stat的系统调用，返回指定路径的相关信息
+ open(file, flags, mode=0777)  调用系统底层的文件打开调用，返回文件描述符（整数），flags包括（以下为Unix和Windows共有的）：
`os.O_RDONLY`：只读
`os.O_WRONLY`：只写
`os.O_RDWR`：读写
`os.O_APPEND`：追加
`os.O_CREAT`：文件不存在则创建
`os.O_EXCL`：文件已存在则打开失败
`os.O_TRUNC`：如果可写，则打开后截断为0
+ fdopen(fd[, mode[, bufsize]])：将一个文件描述符封装为文件对象，mode和bufsize默认和文件描述符文件打开方式相同

##### 2.2.2 环境
+ getenv(key, default=None)    返回由字符串key指定的环境变量的值，如果不存在该环境变量则返回default
+ putenv(key, value)            设置或变更一个环境变量
+ umask(new)                设置新的umask，并返回之前的mask

##### 2.2.3 进程
+ getpid()                    返回当前进程号
+ kill(pid, sig)                使用信号sig杀死进程pid
+ waitpid(pid, opt)            返回(pid, status << 8)
+ system(cmd)                在一个子shell中执行字符串cmd的命令，返回命令的退出状态（所有标准输出和标准错误都被直接显示）
+ popen(cmd, mode=’r’[, bufsize])
执行字符串cmd的命令，返回管道的文件对象
该对象可以使用read()获得cmd的标准输出；而标准错误则直接显示；命令的退出状态是在管道文件对象close时返回。
管道的文件对象和普通文件对象的不同就是它只能单向读写，即不能使用seek
此外，还可以使用commands.getstatusoutput(cmd)，它是对popen的封装，返回一个(status, output)的二元组，分别是命令的退出状态和所有输出。
+ exec系列函数
+ spawn系列函数
+ abort()                    直接退出，用于dumps core或其他错误退出

##### 2.2.4 杂项
tmpfile()                    返回一个临时文件对象（close文件对象时删除）
tmpnam()                返回一个唯一的临时文件名
tempnam([dir,[, prefix]])        返回一个唯一的临时文件名（带前缀和路径的版本）
urandom(n)                返回一个n字节的随机字符串（用于加密用途）
mkfifo

#### 2.3 子模块os.path
##### 2.3.1 模块方法
+ basename(path)            去掉路径，返回文件名
+ dirname(path)                去掉文件名，返回目录（不含最后一个os.sep）
+ split(path)                按当前的os.sep属性将path分割成为一个(basename, dirname)的二元组。分割位置为path中最右的os.sep（若没有os.sep，则二元组第一个元素为空串；如果是以os.sep结束的，则二元组第二个元素为空串）
+ join(path1,path2,…)        将指定的这些路径用os.sep连接起来，如果这些路径的字符串不以os.sep结束，则将自动添加上os.sep（注意，不要以os.sep作为字符串开头，否则将认为从该位置开始作为根，则前面的参数都将被忽略）
+ splitext(path)                将指定的路径分割出扩展名，返回一个二元组，以path中最后一个os.sep之后的最后一个’.’定界，含有’.’的右半部分作为二元组的第二个元素，其余作为第一个元素。若最后一个os.sep后面没有’.’，则第二个元素为空串。
+ exists(path)                判断path指定的路径是否存在
+ isfile(path)                判断path指定的是否是一个普通文件
+ isdir(path)                判断path指定的是否是一个目录
+ islink(path)                判断path指定的是否是一个符号链接（在Windows下总是False）
+ ismount(path)                判断path指定的是否是一个挂载点（定义为驱动器的根）
+ isabs(path)                判断path是否是一个绝对路径
+ getsize(filename)            返回指定文件的大小，该信息来自于os.stat()
+ getctime(filename)            返回文件的最近创建时间，该信息来自于os.stat()
+ getatime(filename)            返回文件的最近访问时间，该信息来自于os.stat()
+ getmtime(filename)        返回文件的最近修改时间，该信息来自于os.stat()
+ abspath(path)                返回指定路径的绝对路径
+ normpath(path)            返回指定路径的规范字符串形式（滤除多余的os.sep）
+ expanduser(path)            将路径中的~或~user转换为对应用户的主目录后的path的绝对路径（如果用户未知或$HOME未定义，则不返回）

### 3. subprocess 模块
用于调用shell（为了代替os.system/`os.popen*`/`os.spawn*`/`popen2.*`/`commands.*`）
该模块提供了一个类和三个简易函数

#### 3.1 Popen类
```
class Popen(
	args,
	bufsize=0, executable=None,
	stdin=None, stdout=None, stderr=None,
	preexec_fn=None, close_fds=False,
	shell=False, cwd=None, env=None,
	universal_newlines=False,
	startupinfo=None, creationflags=0)
```
args是一个字符串或序列，用以描述命令（因为它包含了args[0]即执行的命令）
bufsize同open的buffering参数
executable可以指定执行程序，比如可以指定某个具体的shell（若未指定，则由args[0]决定）
stdin、stdout、stderr可以指定程序的输入输出，可以使用常量PIPE（将创建于子进程的管道，可以进行输入和获得输出），文件对象，文件描述符（一个整数）或None（从父进程继承）。（其中stderr也可以指定为常量STDOUT，则等价于2>&1）
`preexec_fn`是一个可执行对象，它将在子进程启动时执行
`close_fds`若为True，则在子进程执行前除0/1/2外的所有文件描述符都将被关闭
shell若为True，则args通过shell执行。默认是通过os.execvp执行，即使args是一个字符串，也被视为只有一个元素的序列。
cwd可以指定子进程执行的工作目录
env可以指定子进程的环境变量（默认从父进程继承），可以指定一个str:str的字典
`universal_newlines`若为True，则stdout、stderr都将被认为”t”打开，并且不再被Popen对象的communicate()方法更新。
startupinfo、creationflags是Windows接口特定的参数

##### 3.1.1 Popen对象的属性
stdin、stdout、stderr，仅当设置为PIPE可获得，否则为None
pid子进程的进程id
returncode：None表示进程还没结束，负值-N表示子进程已被信号N终止，其他是子进程的正常返回值

##### 3.1.2 Popen对象的方法
+ poll()：返回当前returncode
+ wait()：等待子进程结束，返回returncode
+ kill()：用SIGKILL杀死子进程
+ terminate()：用SIGTERM结束进程
+ send_signal(sig)：给子进程发送一个信号量sig
+ communicate(input=None)：input是一个字符串，可以将其发给子进程作为stdin（需要是PIPE），而后等待子进程结束，返回(stdout, stderr)的二元组（需要是PIPE）。注意：当数据量比较大时，不要用该方法。

#### 3.2 模块函数
三个简易函数call、`check_call`、`check_output`
它们的参数和Popen的一致，都等待子进程执行结束
call直接返回returncode
`check_call`仅当0才返回，其他都抛出CalledProcessError异常，可以访问该异常对象的returncode属性获取返回值
`check_output`如果正常返回（0）返回执行命令的输出；如果返回值非0，则抛出CalledProcessError异常，可以访问该异常对象的returncode属性获取返回值，output属性获得标准输出

### 4. tempfile 模块
用于创建临时文件（os.tmpfile使用的是系统调用，而tempfile模块是基于python而且有更多的选项可以控制）

#### 4.1 模块属性
template：所有临时名的前缀，默认是'tmp'
tempdir：临时文件的存放目录，可以在使用本模块以下函数前设置，默认是环境变量TMPDIR, TMP, TEMP指定的目录，如果没有定义这些环境变量，则为当前工作目录。

#### 4.2 模块函数
+ NamedTemporaryFile(mode='w+b', bufsize=-1, suffix='', prefix='tmp', dir=None, delete=True)
mode和bufsize参数同open
suffix、prefix、dir可以指定临时文件名的后缀、前缀、所在目录
delete表示是否在文件对象关闭是删除文件
返回的临时文件对象。
+ TemporaryFile(mode='w+b', bufsize=-1, suffix='', prefix='tmp', dir=None)
参数同上，只不过返回的临时文件对象没有名字。创建的临时文件其他程序是无法看到的，因为它没有引用文件系统表，临时文件会在关闭后自动删除。
+ mkstemp(suffix='', prefix='tmp', dir=None, text=False)
参数同上，如果text为True，则使用文本，而非二进制模式打开，创建一个临时文件（权限600）。返回是一个二元组(fd, name)，其中fd是打开临时文件的文件描述符，name是临时文件的全文件名。该临时文件需要自己去删除。
+ mkdtemp(suffix='', prefix='tmp', dir=None)
参数同上，创建一个临时目录（权限700）。返回该临时目录的路径，该临时目录需要自己去删除
+ gettempdir()
可以访问tempfile.tempdir属性
+ gettempprefix()
可以访问tempdir.template属性

### 5. fcntl
#### 5.1 模块函数
flock(fd, op)：fd可以是文件描述符，也可以是带有fileno()方法的文件对象；op可以是LOCK_SH（共享锁）、LOCK_EX（互斥锁）、LOCK_UN（移除该进程持有的锁），以上的锁可以和LOCK_NB联用，表示非阻塞请求。申请不到锁会阻塞当前进程。注：文件的 close() 操作会使文件锁失效；同理，进程结束后文件锁失效

### 6. 数据持久化
#### 6.1 序列化
pickle 和 marshal 模块

##### 6.1.1 共性
都可以将很多种Python数据类型序列化为字节流以及反序列化。

序列化格式是Python特定的，与机器架构无关的。优点是没有外部标准的限制，可以跨平台使用，缺点是序列化结果无法用于非Python程序反序列化。
pickle有三种序列化格式协议：
0：ASCII表示，可读性好，但空间和时间性能都不好。（默认）
1：旧式的二进制格式，兼容旧版本的Python。
2：Python 2.3引入的新的二进制格式，序列化新式的class更有效。
如果给的协议号为负或`pickle.HIGHEST_PROTOCOL`都表示使用最大的协议号。

这两个模块只负责序列化，并不保证对数据源序列化时的安全性，并不处理持久化对象及其并发访问的问题。但也因此可以灵活的将其用于持久化文件、数据库、网络传输。

##### 6.1.2 对比
marshal是更原始的序列化模块，其存在的目的主要是为了支持Python的.pyc文件。

pickle比起优越在，pickle会跟踪已序列化的对象，因此可以处理循环引用和对象共享；pickle可以序列化自定义对象，而想要反序列化必须使用相同的类定义；pickle的序列化格式针对Python版本向后兼容，而marshal为了支持Python的.pyc文件并不保证向后兼容。
cPickle是pickle的C实现版，比其快1000倍。它们有着相同接口，除了Pickler()和Unpickler()这两个类都作为函数来实现，因此，就不能通过继承该类实现自定义的反序列化。而且，它们序列化成的字节流也是可以互通的。

##### 6.1.3 pickle
通常，要序列化就要创建Pickler对象并调用其dump()方法，要反序列化就要创建Unpickler对象并调用其load()方法。但pickle模块提供了更简易的函数：
+ dump(obj, file[, protocol])
序列化，等价于Pickler(file, protocol).dump(obj)，obj是待序列化对象，file是一个带有write(str)方法的类文件对象，protocol就是上面提到的序列化格式协议。
+ load(file)
反序列化，等价于Unpickler(file).load()，file是一个必须有read(size)和readline()方法的类文件对象，该函数能自动识别序列化协议格式。
此外，还有
+ dumps(obj[, protocol])
+ loads(string)
两个函数，用于直接序列化为字符串和从字符串中反序列化。

pickle可以序列化的类型参考：<https://docs.python.org/2/library/pickle.html#what-can-be-pickled-and-unpickled>
如果不能序列化，将抛出一个PicklingError异常。（但可能已经有数据写入file中了）
如果序列化对象递归深度超过最大递归深度，将抛出RuntimeError异常，可以通过sys.setrecursionlimit()调整。

如果使用Pickler对象和Unpickler对象进行序列化和反序列化，那么还可以在字节流上附加一个用于识别的标记，称为persistent id。
Pickler对象有一个名为persistent_id的属性，可以赋值一个自定义的persistent_id(obj)函数，该函数或者返回一个作为persistent id的ASCII字符串，或者返回一个None。如果返回一个None，则与默认无标记一样，如果返回字符串，则序列化的字节流就会带上该标记用以Unpickler对象识别。例如：
```
def persistent_id(obj):
    if hasattr(obj, 'x'):
        return 'the value %d' % obj.x
    else:
        return None
```
Unpickler对象对应有一个persistent_load属性，该属性可以赋值为一个自定义的persistent_load(persid)函数，其中persid就是字节流中的标记字符串，返回一个反序列化对象。例如：
```
def persistent_load(persid):
    if persid.startswith('the value '):
        value = int(persid.split()[2])
        return FancyInteger(value)
    else:
        raise pickle.UnpicklingError, 'Invalid persistent id'
```
这样，在调用Unpickler对象对象的load()函数就会自动检测标识进行反序列化。
注：在cPickle模块里persistent_load属性可以被赋值为一个列表，那么Unpickler对象每发现一个persistent id就将其追加到列表中。

#### 6.2 dbm
##### 6.2.1 anydbm
anydbm是多种不同dbm实现的统一接口，比如dbhash（需要bsddb），gdbm，dbm，dumbdbm。它能够通过whichdb模块选择系统已安装的“最好”的模块，只有当都没有安装时，才使用dumbdbm 模块，它是一个简单的dbm的实现。

open(filename, flag=’r’ [, mode])
打开一个dbm文件，名为filename，如果文件已存在，就使用whichdb模块来确定其类型，并使用相应的模块。如果文件不存在，就按上面列出的顺序选择一个导入。
flag表示文件的打开方式：’r’表示只读（已存在的文件），’w’表示读写（已存在的文件），’c’表示读写，如果文件不存在则创建，’n’表示总是创建一个空文件。
mode表示创建dbm文件的访问权限，默认是0666（可能被umask修改）
函数返回一个类字典对象，只不过键值都必须是字符串。（另外，不能print、不支持values()和items()方法）
使用完毕后用其close()方法关闭。

##### 6.2.2 whichdb
whichdb模块只有一个函数：
whichdb(filename)：如果指定文件名的文件不存在，返回None；如果无法确定返回空串；否则返回确定具体dbm模块名的字符串，如下：
dbhash（需要bsddb）：BSD的dbm接口，dbhash是统一的接口，bsddb则是Berkeley DB库的接口（2.6后已废弃）
gdbm：GNU的dbm接口，基于ndbm接口，但文件格式和dbm并不兼容。
dbm：标准的Unix的ndbm接口（library属性，可以查看使用的库名），自动加.db扩展名
dumbdbm：dbm接口的可移植实现（完全python实现，不需要外部库），自动加.dat或.dir扩展名

##### 6.2.3 gdbm
gdbm模块还有三个附加flag（并非所有版本都支持，可以通过查看模块的open_flags属性查看支持的flag），可以附加在上面四种flag之后：
‘f’快速写模式（不同步文件），’s’同步模式（每次写都同步文件），’u’不对文件加锁。
它返回的对象还支持以下方法：
firstkey()和nextkey(key)用于遍历key，顺序是按内部的哈希值进行排序。
reorganize()，压缩文件大小（因为默认的删除操作并不减小文件大小，而留作后续添加用）
sync()，用于’f’模式打开的文件，进行手动同步。

##### 6.2.4 dbhash/bsddb
dbhash模块还有一个附加flag，可以附加在上面四种flag之后：
‘l’加锁模式。
它返回的对象还支持以下方法：
first()、last()和next(key)、previous()用于遍历kv对，顺序是按内部的哈希值进行排序。
sync()，进行强制同步。
bsddb模块可以创建hash、btree和基于记录的文件。

##### 6.2.5 dumbdbm
dumbdbm.open的flag是被忽略的，总是以不存在则创建，存在则更新的模式打开。
它返回的对象还支持以下方法：
sync()，进行强制同步。

#### 6.3 shelve
shelf是一个字典式的持久化对象。和dbm不同于，字典的值可以是任意的可以用pickle处理的对象（字典的键认为普通的字符串）。实际上，它使用cPickle进行序列化，而后再用anydbm进行持久化。
因为它使用pickle，所以同样不保证对数据源序列化时的安全性，也不支持对shelf对象的并发读写。

open(filename, flag='c', protocol=None, writeback=False)
创建一个shelf对象。filename是持久化的文件名（后面会自动添加扩展名，而且可以会创建多于1个的文件）。
flag参数和anydbm模块一致，protocol参数和pickle模块一致
writeback=False，表示模块自身负责同步文件的工作，但弊端是，对于shelf对象成员的修改，不能直接进行，而必须取出，修改，而后回赋才能完成（因为已经序列化为不可变的字符串）。如果设置为True，则表示用户自己负责shelf对象的同步文件的工作，而shelf对象的成员全部缓冲在内存，直到手动调用sync()或close()才同步到文件，这时可以直接对shelf对象成员进行修改，但缺点是需要消耗大量内存并且在close()时更慢（需要同步全部成员）。

shelf对象处理支持字典的所有操作外，还支持以下方法：
sync()，手动同步文件（清空cache）
close()，同步并关闭shelf对象。

此外，还可以从类字典对象来构造shelf对象：
Shelf(dict, protocol=None, writeback=False)
BsdDbShelf(dict, protocol=None, writeback=False)
后者需要一个支持first(), next(), previous(), last() 和 set_location()这些操作的类字典（通常使用bsddb模块的函数创建）

#### 6.4 数据库
简单的可以使用DB-API 2.0 interface
需要ORM可以使用SQLObject，SQLAlchemy，Django自带的ORM
[参考](http://smartzxy.iteye.com/blog/680740)

##### 6.4.1 MySQLdb
[下载](https://pypi.python.org/pypi/MySQL-python/) [文档](http://mysql-python.sourceforge.net/MySQLdb.html)

模块函数：
+ connect(host, user, passwd[, db, port, charset])
连接数据库，返回一个连接对象，其中，数据库名db可以省略，可以使用连接对象的select_db方法，或使用sql命令use来指定；port是MySQL使用的TCP端口，默认是’3306’，charset是数据库编码。
+ escape_string(str)：

连接对象的方法：
+ select_db(db)
+ cursor(cursorclass=None)：获得了操纵游标对象（默认的游标对象SQL查询返回的结果是tuple of tuple，如果设置为MySQLdb.cursors.DictCursor，则SQL查询返回的结果是tuple of dict）
+ query(sql)：不用游标对象，直接执行sql语句
+ commit()：对于支持事务的数据库引擎（如InnoDB引擎，而mysiam引擎则不是），执行对数据库的改动（增删改，不过，不包括truncate table），如果在数据库连接关闭前没有执行该方法提交，则这些改动不会生效。
+ ping()：检查连接是否关闭，如果关闭将自动重连
+ rollback()：如果sql执行失败（会有异常抛出），需要回滚以确保数据库一致性。
+ close()：断开数据库连接

游标对象的方法：
+ execute(query, args)：执行sql语句query（其中可以包含字符串格式化的占位符），args就是填充占位符的序列，返回受影响的行数。（之所以这样使用，而不是直接使用字符串格式化，是因为那样并不安全，容易受到SQL注入攻击）
+ executemany(query, args)：query同上，args是一个填充占位符的序列的序列，每一个内部序列都可以填充占位符成为一个完成的sql语句，该方法就对这个外部序列重复执行多次sql，返回受影响的行数。
+ nextset()：移动到下一个结果集，返回True，如果没有下一个则返回None。
+ callproc(procname, args)：执行一个存储过程，args为存储过程的参数列表，返回受影响的行数。
+ fetchall()：获取执行sql语句返回的结果集（若前面已经获取，则获取余下的），如果有结果，则返回一个元组的序列（每个元组表示一行）。
+ fetchmany([size])：返回指定行数的结果集，若未指定或指定的行数大于实际的行数，则返回cursor.arraysize（默认是1）行数据
+ fetchone()：返回结果集中的下一行。
+ scroll(value, mode=’relative’)：移动游标value行，’relative’表示相对当前行，’absolute’表示相对第一行。
+ close()：
此外，还有一个只读属性：rowcount，表示执行execute后受影响的行数。

##### 6.4.2 sqlite3
[文档](https://docs.python.org/2/library/sqlite3.html)
<http://www.cnblogs.com/hongten/p/hongten_python_sqlite3.html>

模块函数：
+ connect(database[, timeout, detect_types, isolation_level, check_same_thread, factory, cached_statements])
获得一个连接对象。database是一个数据库文件名，或者用":memory:"表示使用RAM而不是磁盘文件作为数据库。当多个连接访问一个数据库时，如果其中一个进行写操作就会对数据库加锁直到事务提交，timeout就是等锁的时间，如果超时就抛出异常，默认是5.0秒。本地SQLite值支持TEXT, INTEGER, REAL, BLOB 和 NULL 这些类型，如果还需其他，则需要你自己去支持，detect_types默认是0，你可以设置为sqlite3.PARSE_DECLTYPES、sqlite3.PARSE_COLNAMES的组合

连接对象的方法：
+ cursor()：获得了操纵游标对象
+ commit()：保存更改
+ close()

游标对象的方法：
+ execute(query, args)：执行一个非标准的SQL语言的变种。query可以使用“?”作为占位符，args就是填充占位符的序列，返回一个迭代器，每次迭代结果集中的一行。
+ executemany(query, args)：执行多条非标准SQL。args就是填充占位符序列的序列
+ fetchone()：返回结果集中的下一行。

#### 6.5 其他
+ ZODB：一个健壮的、多用户和面向对象的数据库系统，它能够存储和管理任意复杂的python对象，并提供事务操作和并发控制支持；
+ Durus：Quixote团队的作品，可以看作是轻量级版本的ZODB实现，纯开源的Python实现，并提供一个可选的C语言插件类；
+ Missile BD：是一种Python的、简洁高效的DBMS，适用于Stackless Python环境。同时需要说明的是它是并发性能极高的Eurasia3项目的一个子项目；
+ ODB（spugdb）:一个轻量级的纯Python实现的Python对象数据库系统，支持嵌套事务、对象模型、游标和一个简单的类似X-Path的查询语言，它的前身只是围绕Berkeley DB做的Python包装，现在已逐步淘汰对Berkeley DB的支持；
+ PyPerSyst：它是由用java实现的Provayler到Python的移植实现，PyPerSyst将整个对象系统保存在内存中，通过将系统快照pickle到磁盘以及维护一个命令日志（通过日志可以重新应用最新的快照）来提供灾难恢复。因此PyPerSyst应用程序会受到可用内存的限制，但好处是本机对象系统可以完全装入到内存中，因而速度极快；
+ PyDbLite：Python实现的快速的、无类型的内存数据库引擎，使用Python语法代替SQL语法，支持Python2.3以及以上版本，同时提供对SQLite和MySQL支持；
+ buzhug：Python实现的快速的数据库引擎，使用Python程序员觉得直观的语法，数据存储在磁盘上；
+ Gadfly：它是一个简单的关系数据库系统，使用Python基于SQL结构化查询语言实现。

### 7. 相关模块
tarfile        访问tar归档文件，支持压缩
zipfile        访问zip归档文件的工具
gzip/zlib        访问GNU zip（gzip）文件（压缩需要zlib 模块）
bz2            访问bz2格式的压缩文件
shutil        高级文件访问功能（比如复制文件、复制文件权限、目录树递归复制）
csv            访问csv文件（逗号分隔文件）
filecmp        比较目录和文件
fileinput        多个文本文件的行迭代器
glob/fnmatch    Unix样式的通配符（`*`和?）匹配功能（但并不支持~）
socket        网络文件访问
urllib        通过URL建立到指定web服务器的网络连接

## 第九章. 异常
面对错误，应用程序应该成功的捕获并处置，而不至于灾难性的影响其执行环境。

### 1. 异常结构
try-except-else-finally
```
try:
    代码块
except (ValueError, TypeError)[, e]:        # 处理多个异常
    代码块
except IOError[, e]:                    # 带错误原因e
    print 'file open error', e
    代码块
except:                            # 捕获所有异常，但无法获得错误原因（除非通过sys.exc_info()获得），因此推荐捕获Exception异常，从而获得异常原因
    代码块
else:                       # 可选的，当try块中没有发生任何异常时执行
    代码块
finally:                    #  可选的，无论是否有异常总会执行
    代码块
```
其中，
except可以通过使用 raise 语句重新引发一个异常；
except可以0个或多个，分别表示捕获不同异常的处理，每个可以处理任意多个异常（放在一个元组中）；
e 是一个捕获异常类的一个实例，使用str(e) 总能得到一个良好可读的错误原因；该实例是一个可遍历对象，可以通过遍历获取到构造该异常使用的元组；
except和finally至少有一个，在较老版本中两者无法兼容；
如果try中有return，那么只要程序运行正常，也会先执行finally，再return

#### 1.1 异常处理
##### 1.1.1 无异常
正常执行 try 块所有代码；如果有 else，执行对应代码块；最后，执行finally
##### 1.1.2 有异常
忽略 try 块中触发点之后的剩余代码；
寻找第一个匹配的处理器except（当前域没有匹配的except，会退栈跳到调用者寻找，如果在顶层仍为找到，这个未处理的异常会导致程序退出，Python解释器会打印traceback信息，然后退出），执行代码块;
最后，执行finally

#### 1.2 特殊结构
```
try:
    try:
        ...
    finally:
        ...
except ...:
    ...
```
这个结构，优点是可以捕获finally中引发的异常，但问题是如果在finally中引发异常，如果未保存原有异常的上下文信息，将会丢失。另外，就是在异常处理之前，就已经将资源释放。并且，如果finally中引发了另一个异常，或由于return，break，continue语句而终止，原来的异常将会丢失而无法重新引发。

#### 1.3 sys.exc_info()
返回最近一次被捕获的异常信息
该异常信息是一个三元组：(异常类，异常实例，traceback对象)
其中traceback对象提供发生异常的上下文，如代码的执行frame和发生异常的行号等

### 2. 抛异常
raise SomeException, args, traceback
三个参数都是逆序可选的
如果有SomeException参数，则它必须是一个字符串、类或实例
如有args，可以是一个对象（通常是一个字符串指示错误的原因），也可以是一个元组（一个错误编号，一个错误字符串，一个错误的地址，等）
如果有traceback，是一个用于exception-normally的traceback对象，当你想重新引发一次是，第三个参数很有用（区分当前和先前的位置）

**注**：
如果SomeException是一个实例，那么就不能用其他的参数
如果SomeException是一个字符串（不建议），那么就触发一个字符串异常
如果这个args是一个异常类的实例，则不能有更多参数。如果其不是SomeException类或其子类的实例时,那么解释器就使用该实例的异常参数创建一个SomeException类的新实例
如果args不是一个异常类的实例，那么它将作为SomeException类的实例化参数列表
如果三个参数都没有，则引发当前代码块最近触发的一个异常，如果之前没有异常触发，会因为没有可以重新触发的异常而生成一个TypeError异常。

### 3. 内置异常
SystemExit 表示程序退出
KeyoboardInterupt 表示Ctrl+C，用户中断

BaseException 是所有异常的基类，Exception 是除 SystemExit 和 KeyoboardInterupt 之外所有异常的基类，StandardError是所有内建标准异常的基类，EnvironmentError是操作系统环境异常的基类

创建一个新的异常仅需要从一个异常类中派生一个子类

### 4. 断言
断言是一句必须布尔判断为真的判断，否则就触发AssertionError
assert expression[, arg]
expression是这个判断的表达式，arg提供给AssertionError作为参数，进行异常构建

### 5. 资源自动释放
```
with context_expr [as var]:
    code_suite
```
例如：
```
with open(name, ‘rb’) as input:
    data = input.read()
```
context_expr返回一个上下文管理对象赋值到var，仅能工作于志成上下文管理协议的对象，比如：
file
decimal.Context
thread.LockType
threading.Lock
threading.RLock
threading.Condition
threading.Semaphore
threading.BoundedSemaphore

上下文对象是通过`__context__()`获得的
而上下文对象本身就是上下文管理器，因此该对象就有上面的方法
一旦获得了上下文对象，就会调用其`__enter__()`方法，完成with语句块执行前的准备工作，如果提供了as，就用该方法的返回值来赋值；而后执行with语句块，执行结束后都会调用上下文对象的`__exit__()`方法，该方法有三个参数：异常类，异常实例，traceback对象，如果没有异常发生，三个参数都是None；否则就被赋以异常的上下文环境，从而在`__exit__()`里处理异常，如果该函数返回一个布尔测试为False的值，则异常将抛给用户进行处理，如果想屏蔽这个异常，则返回一个布尔测试为True的值（如果没有异常返回的也是True）
上下文管理器主要作用于共享资源，`__enter__()`和`__exit__()`方法基本和资源的分配和释放有关（如数据库连接、锁、信号量、状态管理、文件）。
为了帮助你编写对象的上下文管理器，有一个contextlib模块，包含了实用的functions/decorators，这样即可以不用关心上面这些下划线方法的实现。


## 并发编程
### threading 模块
### multiprocessing 模块

## 网络编程
### socket 模块
### urllib 和urllib2 模块
### requests 模块
<https://zhuanlan.zhihu.com/p/21976757>

## 结构化数据处理
### json
json 模块

### html
#### HTMLParser 模块
##### HTMLParser 类
一般通过继承该类，实现若干事件处理函数，当处理遇到tag/text/comment等文本时回调对应的handle
该类无构造参数（并且该类不支持super关键字，因此其子类调用父类的构造函数只能是`HTMLParser.__init__(self)`）

###### handle 方法（需要重写）
+ handle_starttag(tag, attrs)：遇到开始tag 时调用，参数tag 是标签名（已转化为小写）；attrs 是一个(name, value) 二元组的列表，name 是属性名（已转化为小写），value 是属性值（转义字符已替换）
+ handle_endtag(tag)：遇到结束tag 时调用
+ handle_startendtag(tag, attrs)：当遇到空元素时调用，参数意义同handle_starttag，默认行为是依次调动handle_starttag 和handle_endtag
+ handle_data(data)：当遇到内容结点时调用
+ handle_comment(data)：当遇到注释标签时使用，data 是注释的内容，即两个-- 之间的内容

###### 其他方法
+ feed(data)：给解析器提供HTML文本片段，其中完整的元素会被处理，不完整的元素进行缓存，当下次调用补齐，或者调用的close 函数
+ close()：强制终止解析（缓存的内容都作为data 解析），可以重写该函数，增加额外的操作，不过必须要调用基类的close 函数
+ reset()：丢弃未处理的缓存数据
+ getpos()：返回一个(lineno, offset) 的二元组，lineno是当前处理的行号（第一行为1），offset 是列偏移（第一列为0）。在handle 方法中调用，返回在刚刚遇到指定内容的位置。
+ get_starttag_text()：返回最近遇到的一个打开的开始tag

#### Beautifulsoup 库
第三方库，用于帮助解析Html/XML等内容
[BeautifulSoup官网](http://www.crummy.com/software/BeautifulSoup/)
##### 安装
```
pip install beautifulsoup4      # BeautifulSoup 是BeautifulSoup3 的包（pip 支持卸载）

easy_install beautifulsoup4

python setup.py install     # 源码安装
```
##### BeautifulSoup 类
```
from bs4 import BeautifulSoup
soup = BeautifulSoup(html_doc)
```
第一个参数可以使用字符串，或文件对象
第二个参数 是解析器（HTML 支持内置标准库'html.parser'，C 解析器'lxml'支持XML，纯Python实现的'html5lib'，XML 使用'xml'，只支持lxml），如果未指定，则由BeautifulSoup选择最适合
如果使用HTML 解析器返回的对象会自动补全`<html><head><body>` 并将自关闭标签拆成一对开闭标签，如果使用XML 解析器，则加XML头。

Beautiful Soup 将复杂HTML文档转换成一个复杂的树形结构，每个节点都是Python对象，所有对象可以归纳为4种: Tag, NavigableString, BeautifulSoup, Comment.
HTML解析器把这段字符串转换成一连串的事件，例如: 打开`<html>`标签, 打开一个`<head>`标签, x打开一个`<title>`标签, 添加一段字符串, 关闭`<title>`标签, 打开`<p>`标签, 等等.
BeautifulSoup 对象代表了一个HTML 或 XML文档的全部内容，大部分时候，可以把它当作 Tag 对象，因为它继承自Tag 类
`<html>`就是其唯一子结点，其parent属性为None。
因为 BeautifulSoup 对象并不是真正的HTML或XML的tag，所以它没有name和attribute属性。但有时查看它的name 属性是很有用的，所以BeautifulSoup 对象包含了一个值为u'[document]' 的特殊属性 .name

`new_string(s, subclass=<class 'bs4.element.NavigableString'>)`：创建一个NavigableString 对象，也可以传入bs4.Comment 作为第二个参数可以创建一个注释对象
`new_tag(name, namespace=None, nsprefix=None, **attrs)`：创建一个Tag 对象，可以用关键字参数表示Tag 标签属性。

##### Tag
Tag是HTML或XML中一个完整的标签
可以当做一个字典对象访问标签属性，可以直接修改和删除
Tag对象也可以有很多子结点（包含分支结点Tag和叶子结点NavigableString）

###### 属性
name：Tag 的标签名，可修改
attrs：Tag 的标签属性，用法很像字典，支持增删改，对于HTML中的多值属性（例如class, rel, rev, accept-charset, headers, accesskey），访问这种属性是一个list（默认是一个str）而XML则不会，当多值属性序列化时，就会合并为一个空格分隔的字符串。
string：该标签的文本内容，对应NavigableString 类，用法类似Unicode 字符串，可以直接将一个字符串赋值给该属性进行修改（如果该Tag 还有其他子Tag，那么子Tag将被覆盖；注意：对于包含有多个子结点的的标签，由于无法确定具体引用那个子结点的string，故其string 属性为None
strings：该属性是一个生成器，可以递归向下遍历该标签下的所有文本内容
stripped_strings：同上，只不过移除了空行和段收尾的空白
tag 名：可以递归向下（深度优先）查找第一个发现的该标签名的Tag 对象，如果找不到返回None（其实际上是调用了find 方法）
contents：将子结点以列表方式给出
children：该属性是一个迭代器，可以遍历子结点
descendants：该属性是一个生成器，可以递归遍历后代结点
parent：父节点
parents：该属性是一个生成器，可以递归遍历所有祖先节点
next_sibling 和previous_sibling：相邻兄弟结点（注意，相邻标签直接的分隔符或换行符也会被视为一个NavigableString，从而成为一个兄弟结点），不存在为None，这两个属性同样可以后面加 s 用于递归遍历
next_element 和previous_element：按照深度优先的遍历顺序的前一个和后一个元素，这两个属性同样可以后面加 s 用于递归遍历。

###### 方法
Tag类标签可以使用 find 和 find_all 方法进行搜索（搜索当前结点和子孙结点），这两个方法的参数都可以接受多种的参数类型：
+ 字符串：完全匹配（最好使用Unicode 字符串，否则将认为utf-8 编码进行转换）
+ re.compile 的正则对象：正则匹配
+ 列表：完全匹配其中一个
+ True：匹配所有存在指定属性的结点（例如存在标签名即Tag结点，存在某个标签属性等）
+ 函数对象：该函数接受一个参数，返回一个布尔值，True表示匹配，False反之。

`find_all(name=None, attrs={}, recursive=True, text=None, limit=None, **kwargs)`
name 为标签名过滤器，可以使用上面五种参数类型（函数参数的参数为Tag 结点对象）
attrs 为标签属性过滤器，可以提供一个字典参数
text 为标签文本过滤器，可以使用上面五种参数类型（函数参数的参数为NavigableString 结点对象）
kwargs 可以指定标签属性名作为参数名，作为标签属性过滤器，可以使用字符串、正则、列表、True，其中True表示具有某属性，None表示没有某属性；不过，由于有些属性不满足python的命名规范，所以这些属性不能用于kwargs 过滤，比如HTML5中的`data-*` 属性；另外，class属性因为是Python关键字也不能使用，不过可以使用`class_` 作为属性名查找（可以使用字符串、正则、True、函数对象，函数参数为字符串），另外由于class 是一个多值属性，所以使用任何一个class 的字符串都可以独立进行查找，当然可以使用所有的class 的字符串进行完全匹配（要求顺序也必须一致）
limit 限定返回结果集的数量（到达数据就会停止搜索，可以加快返回）；
recursive 默认为True，进行递归搜索，可以设为False，则只搜索直接子节点。
返回所有匹配命中的结点列表
由于该方法很常用，所以可以直接使用Tag 结点对象进行调用，如`soup('a', text=True)`
find 方法等价于find_all 方法参数limit=1，不过前者直接返回一个结点，后者还是一个结点列表，当没有匹配命中时，前者返回None，后者返回空列表。

`find_parents(name=None, attrs={}, limit=None, **kwargs)`：向祖先结点遍历的搜索
find_parent 方法：find_parents 参数limit=1 的情形，返回最近的一个祖先结点

`find_next_siblings(name=None, attrs={}, text=None, limit=None, **kwargs)`：前向兄弟结点遍历搜索
find_next_sibling 方法：find_next_siblings 参数limit=1 的情形，返回后面最近的一个兄弟结点
find_previous_siblings 方法：类似find_next_siblings 不过是前向兄弟结点遍历
find_previous_sibling 方法：find_previous_siblings 参数limit=1 的情形，返回前面最近的一个兄弟结点

`find_all_next(name=None, attrs={}, text=None, limit=None, **kwargs)`：通过next_elements 属性进行遍历搜索
find_next 方法：find_all_next 参数limit=1 的情形
find_all_previous 方法：通过previous_elements 属性进行遍历搜索
find_previous 方法：find_all_previous 参数limit=1 的情形

select(selector)：该方法可以使用[CSS 元素选择器](http://www.w3school.com.cn/css/css_selector_type.asp)的语法

`get_text(separator=u'', strip=False, types=(<class 'bs4.element.NavigableString'>, <class 'bs4.element.CData'>))`：得到所有的文本内容（报告子孙的文本内容），用指定分隔符分隔，可以指定strip=True，滤除文本前后的空白

has_attr(key)：key 是标签属性名，检查标签是否具有该属性

append(tag)：给当前对象追加内容，tag 可以是一个字符串，工厂方法 BeautifulSoup.new_string()、BeautifulSoup.new_tag() 返回的对象
insert(position, new_child)：给当前对象内容的指定位置添加新的内容，new_child 同上tag
insert_before(predecessor)：在当前对象的前面添加内容，predecessor 同上tag
insert_after(successor)：在当前对象的后面添加内容，successor 同上tag
replace_with(new_tag)：将当前对象替换为new_tag，并返回当前对象，new_tag 同上tag
wrap(outer_tag)：将当前对象包进outer_tag 中返回
unwrap()：方法别名是replace_with_children，即去掉当前对象的标签，返回被移除的tag
clear(decompose=False)：移除当前对象的所有内容
extract()：将自身从文档树中移除，并返回一个移除对象
decompose()：将自身从文档树中移除，并销毁

prettify(encoding=None, formatter='minimal')：返回一个带缩进的HTML字符串
而如果只想要字符串，而不关心显示效果的话，可以直接用str()或unicode()进行转型即可（unicode 会将HTML中的特殊字符转换成Unicode，str 默认返回UTF-8编码的字符串，可以指定编码设置）
encode(encoding='utf-8', indent_level=None, formatter='minimal', errors='xmlcharrefreplace')
decode(indent_level=None, eventual_encoding='utf-8', formatter='minimal')

##### NavigableString
NavigableString是HTML中的文本内容，通常通过Tag 对象的string 属性获得，还可以使用 .strings 属性递归遍历所有NavigableString，.stripped_strings 属性是对应去除多余空白符的结果。
可以使用unicode() 函数将该对象转换为一个Unicode字符串，而且最好这么做，因为该对象会引用BeautifulSoup 对象，使用该对象会导致BeautifulSoup 对象无法释放，比较浪费内存。
不能直接编辑，但可以调用.string.replace_with()方法进行替换。
NavigableString 对象支持 遍历文档树 和 搜索文档树 中定义的大部分属性, 但并非全部。而且NavigableString是叶子结点，因此不能包含其它内容，即不支持 .contents 或 .string 属性或 find() 方法.

##### Comment
获得该对象的方式和获得NavigableString的方式相同，因为它就是一种特殊的NavigableString。
查看该对象只能看到注释文本的内容，当进行HTML 序列化时才会转换为HTML 注释的格式。
*其他XML 对象CData, ProcessingInstruction, Declaration, Doctype 类似的也都是NavigableString 的一个子类*

##### 编码
任何HTML或XML文档都有自己的编码方式,比如ASCII 或 UTF-8,但是使用Beautiful Soup解析后,文档都被转换成了Unicode
Beautiful Soup用了 编码自动检测 子库来识别当前文档编码并转换成Unicode编码. BeautifulSoup 对象的 .original_encoding 属性记录了自动识别编码的结果。编码自动检测 功能大部分时候都能猜对编码格式,但有时候也会出错.有时候即使猜测正确,也是在逐个字节的遍历整个文档后才猜对的,这样很慢.如果预先知道文档编码,可以设置编码参数来减少自动检查编码出错的概率并且提高文档解析速度.在创建 BeautifulSoup 对象的时候设置 from_encoding 参数.
特别的，当文档混杂了其他编码格式，Unicode编码就不得不将文档中少数特殊编码字符替换成特殊Unicode编码,“REPLACEMENT CHARACTER” (U+FFFD, �)。如果Beautifu Soup猜测文档编码时作了特殊字符的替换,那么Beautiful Soup会把 UnicodeDammit 或 BeautifulSoup 对象的 .contains_replacement_characters 属性标记为 True .这样就可以知道当前文档进行Unicode编码后丢失了一部分特殊内容字符.如果文档中包含� 而 .contains_replacement_characters 属性是 False ,则表示� 就是文档中原来的字符, 不是转码失败.

编码自动检测 功能可以在Beautiful Soup以外使用,检测某段未知编码时,可以使用这个方法:
```
from bs4 import UnicodeDammit
dammit = UnicodeDammit("Sacr\xc3\xa9 bleu!")
print(dammit.unicode_markup)    # Sacré bleu!
dammit.original_encoding
```
如果Python中安装了 chardet 或 cchardet 那么编码检测功能的准确率将大大提高.输入的字符越多,检测结果越精确,如果事先猜测到一些可能编码,那么可以将猜测的编码作为参数,这样将优先检测这些编码:
```
dammit = UnicodeDammit("Sacr\xe9 bleu!", ["latin-1", "iso-8859-1"])
print(dammit.unicode_markup)    # Sacré bleu!
dammit.original_encoding
```

##### 解析部分文档
如果想在加载文档时就对文档进行一次过滤（仅解析某些文档片段），可以使用SoupStrainer这个类，它的构造参数和find方法相同，使用时只需在构造BeautifulSoup实例时，使用parse_only参数指定一个这个类的实例即可

##### 附注
BeautifulSoup本身没有文本解析功能，它的解析功能来源于他使用的解析器
目前他支持3种解析器：
Python标准库（Python2的HTMLParser，Python3的html.parser）
lxml（目前唯一支持XML解析的解析器，C实现，速度快）
html5lib（更好的容错性）

安装：
pip install lxml
pip install html5lib
用这两种解码器可以解决很多标准库存在的编码问题

参考：<http://www.crifan.com/files/doc/docbook/python_topic_beautifulsoup/release/htmls/index.html>


### xml
常见的XML编程接口有DOM 和SAX
python有三种方法解析：DOM、SAX、ElementTree
+ DOM（Document Object Model）解析为语法树（需要全部载入，慢且占用内存），使用树的操作
+ SAX（Simple API for XML）用事件驱动模型，通过触发回调函数来处理（流式读取，不必全部载入，但API并不友好，需用户实现回调函数Handler）
+ ElementTree，轻量DOM，具有友好的API，速度快，内存占用少
但他们都不具备抵御实体扩展的能力，有两个defused packages可以，但他们并不能够向后兼容。
[参考](https://docs.python.org/2/library/markup.html)

#### xml.dom 模块
##### 概念说明
###### 基类Node
+ childNodes属性获得子Node列表
+ nodeType属性获得结点类型
+ toxml([encoding])方法返回XML字符串
+ appendChild(newChild)方法给结点追加一个子结点，并返回之。如果newChild已经是文档树中的结点，则首先先删除之。

###### Document
代表一个完整的XML文档对象
documentElement 属性获取唯一的一个Element对象
getElementsByTagName()查找元素，返回一个NodeList对象
支持`__len__()` 和 `__getitem__()`

+ createElement(tagName)创建并返回一个新的Element
+ createTextNode(data)创建并返回一个新的Text
+ createComment(data)创建并返回一个新的Comment
+ createAttribute(name)创建并返回一个新的Attr

###### Element
代表XML中的一个元素
+ getElementsByTagName()查找元素
+ hasAttribute('')/getAttribute('')/removeAttribute(name) 判断/获取/删除元素属性值
+ setAttribute(name, value) 设置元素属性值
+ setAttributeNode(newAttr) 将一个属性结点添加为当前元素的属性，如果name重复则替换之（返回旧属性结点），如果newAttr已经被使用，则抛出异常
+ removeAttributeNode(oldAttr)

###### Attr
代表元素的一个属性

###### Comment
代表注释元素
data属性访问内容

###### Text
代表文本元素
data属性访问内容

##### xml.dom.minidom 模块
最小的DOM实现，一次性读取整个文档，保存为一个树形结构
并不扩展外部实体，而直接返回实体字面值
parse(file)：从文件名或文件对象解析出 Document
parseString('...')：从字符串解析出Document

##### xml.dom.pulldom 模块
支持部分DOM树的构建


#### xml.sax 模块
两部分内容：解析器和事件处理器
解析器负责读取XML文档，并向事件处理器发送事件；事件处理器处理事件，处理传入的XML数据

##### 模块方法
+ make_parser([parser_list])
创建并返回一个SAX XMLReader对象，parser_list是一个模块名的字符串列表，这些模块必须有create_parser()函数，该函数将查找列表中第一个可用的。
+ parse(file, handler, [err_handler])
创建一个SAX解析器并用其解析文档，file可以是文件名或文件对象。handler参数是一个ContentHandler实例，err_handler是一个ErrorHandler实例
+ parseString(string, handler[, error_handler])
同上，只不过来源于字符串

##### xml.sax.xmlreader 模块
XMLReader对象可用直接parse(source)，source可以是文件名或url的字符串，也可以是一个文件对象或InputSource对象。通过setContentHandler(handler)设置事件处理器对象。

##### xml.sax.handler 模块
ContentHandler的一些重要接口：
+ startDocument()：在其他接口之前调用，并只调用一次
+ endDocument()：在其他接口之后调用，并只调用一次
+ startElement(name, attrs)：元素开始时触发，不支持namespace，name是这个元素时的名字，attrs是一个类似字典的对象，可以以属性名为key获取属性值
+ endElement(name)：元素结束时触发，不支持namespace
+ characters(content)：处理内容数据，content就是两个标签之间或与换行之间的内容
通常，从该类继承并重写相应的事件处理函数，用于处理解析事件。


#### xml.etree.ElementTree 模块
并不扩展外部实体，而是抛出ParserError异常
C 实现的模块：xml.etree.cElementTree

两个类：
ElementTree：代表整个XML文档
Element：代表树上的一个节点

```
import xml.etree.ElementTree as ET
tree = ET.parse('country_data.xml')     # 从文件得到ElementTree，文件名也可以是一个文件对象
root = tree.getroot()                   # 得到Element
root = ET.fromstring(xml_string)        # 从字符串得到Element
bEle = ET.iselement(root)               # 检查是否是Element对象。
xml_str = ET.tostring(element, encoding="us-ascii", method="xml")

ET.dump(Element)                        # 导出字符串到标准输出中
```
如果不是良构的XML，parser将抛异常，但异常信息比较模糊，如果想要详细的错误信息，可以使用lxml模块，import lxml.etree as ET（另外，合法验证也需要该模块）

##### Element
被设计为灵活的容器对象，既可表达为一个列表也能表达为一个字典，可以用序列的方式访问子元素，可以用访问字典的方法访问属性
当进行遍历时，是按照序列方式遍历的子元素

###### 属性
tag：str，元素的标签名
attrb：dict，元素属性
text：str，文本内容（从开始标签到下一个标签之间的内容，如果没有为None），读写
tail：str，文本后缀（从结束标签到下一个标签之间的内容，如果没有为None），读写

###### 方法
iter('tagname')：递归查找指定标签名（缺省则为任意标签名）的后代元素（迭代器，深度优先前序遍历），返回迭代器
itertext()：迭代后代元素的text
findall('xpath')：查找满足指定条件元素，xpath如果是tagname，表示其直接子元素，返回Element列表
iterfind('xpath')：findall的迭代器版本
find('xpath')：查找满足指定条件的首个子元素
findtext('xpath', default=None)：查找指定tag首个子元素的text

词典方法
clear()：重置元素（清除所有子元素、属性、文本）
get('attr_name', default=None)：获取属性值，未找到返回default
set('attr_name', 'val')：设置或修改属性值
items()：返回属性kv二元组序列
keys()：返回属性名列表

列表方法
append(Element)：追加子元素
extend(Elements)：追加子元素序列
insert(index, Element)：在指定位置插入元素
remove(Element)：移除一个子元素
len

###### 直接构造XML
ET.Element('tag_name', {attrib})：创建一个根元素
ET.SubElement(Element, 'tag_name', {attrib})：创建一个子元素并指定父元素

##### ElementTree
###### 构造
ET.ElementTree(element=None, file=None)：element指定root，文件用于初始化
同Element，有find, findall, findtext, iter, iterfind方法，该元素为root
getroot()：获得root Element
parse(file, parser=None)
write(file, ...)：修改XML写回


#### lxml 模块
基于C 库libxml2 和libxslt 封装的python 模块，不仅能处理XML，还能处理HTML。
[参考](http://lxml.de/tutorial.html)

##### lxml.etree
###### lxml.etree.Element
```
from lxml import etree
root = etree.Element("root", interesting="totally")
etree.Entity("#234")
etree.Comment("some comment")

root = etree.XML('''\
        <?xml version="1.0"?>
        <!DOCTYPE root SYSTEM "test" [ <!ENTITY tasty "parsnips"> ]>
        <root>
            <a>&tasty;</a>
        </root>
''')
tree = etree.ElementTree(root)
```
lxml.etree.Element 继承xml.etree.ElementTree.Element 的所有接口
但要注意的是，lxml 的元素具有移动语义，即如果将一个元素赋值给另一个元素，那么代表了将前者移动并替换后者，也正是因此，lxml 的每个元素都有唯一确定的位置
如果确实不需要移动语义，则需要使用copy.deepcopy() 对元素进行深拷贝之后再赋值

增强的方法：
iter() 支持多个tagname的过滤，此外，它还支持按节点类型进行过滤，即可以将Element, Comments, ProcessingInstructions 和 Entity 的构造方法作为参数：
```
root.iter(tag=etree.Element)    # 只返回Element
root.iter('d', 'a', etree.Comment)  # 返回tagname 为a 或b 或注释节点
```

lxml新增的方法：
`iterchildren(*tags, reversed=False)`：遍历该元素的子元素，tags参数同iter，reversed 可以逆序遍历
`iterancestors(*tags)`：遍历祖先节点（从父节点向上）
`iterdescendants(*tags)`：遍历后代节点（和iter 相比少了当前结点）
`itersiblings(*tags, preceding=False)`：遍历兄弟元素，默认后向遍历，preceding 可以进行前向遍历
index(Element)：返回指定子元素的索引位置
getparent()：返回该元素的父元素
getprevious()：返回该元素的前一个兄弟元素
getnext()：返回该元素的后一个兄弟元素
xpath("string()")：使用xpath 方法，返回一个list，如果使用xpath 的text()函数，则对于每个成员可以通过is_text、is_tail 属性判断是哪种text

###### lxml.etree.ElementTree
lxml.etree.ElementTree 是建立在一个文档树根节点，对XML文档的封装
对该对象使用tostring 方法，会带有DTD
其属性：
docinfo.xml_version
docinfo.doctype
docinfo.public_id
docinfo.system_url

新方法
getelementpath(Element)：返回指定元素的xpath

###### 模块方法
+ 解析
    - etree.fromstring(some_xml_data) 直接从字符串解析，返回Element
    - etree.XML(some_xml_data) 直接从字符串解析xml，返回Element
    - etree.HTML(some_html_data) 直接从字符串解析html，返回Element
    - etree.parse(some_file_or_file_like_object) 从类文件对象解析，返回ElementTree
    参数可以是文件名、http/ftp url（支持有限，能力不足可以引入urllib2 或requests 支持）、具有read(byte_count)方法返回二进制字符串的对象
第二个参数可以配置解析器，未指定则使用默认的标准解析器，可以通过etree.XMLParser() 配置一个解析器传入
+ etree.tostring(root, method="text", pretty_print=True,  with_tail=False, xml_declaration=True, encoding='iso-8859-1')
method="text" 表示只显示root 结点下的text，并递归向下，其他还支持xml（默认）、html
with_tail=False 表示不显示root 结点后的tail，默认为True
xml_declaration=True 表示带开头的xml 声明
encoding 默认是plain ASCII（str类型，如果需要unicode，可以指定unicode）
+ etree.iselement(root)
+ etree.XPath("//text()")
返回一个函数对象，接受一个元素作为参数，调用该元素的xpath 方法（这种方式会预编译xpath，带来性能提升）

###### 分批解析
两种方法：
1. 传给etree.parse 的类文件对象
这样会不断调用类文件对象的read 方法（每次可能只返回文档的一部分），直到返回空
2. 使用etree.XMLParser() 对象的feed() 方法
每次调用feed(xml_fragment) 都只解析一部分，直到调用该对象的close() 方法，返回Element

###### 事件驱动解析
可以不必加载整棵文档树到内存，而在特定条件下调用对应接口完成解析

方法1 （更快也更简单）
通过etree.iterparse(some_file_like, events, tag) 方法可以返回一个迭代器
该迭代器返回一个(event, element) 的二元组
event是触发事件，默认只有end，除非指定参数events=("start", "end")，可以迭代start 和end 两种事件，这是因为在处理start 事件时，元素的text, tail 和子元素还是未知的，而在end 事件才能确定。
element 是触发事件的Element 对象
参数tag 可以限定触发事件的标签。
**注：iterparse并不会释放每一次迭代的结点引用，所以如果想要节省内存，需要在遍历过程中对不再需要的element对象调用clear() 方法，将其重置为空，并清理其父节点对其的引用`del element.getparent()[0]`**

方法2
还可以使用类SAX 的事件接口，例如：
```
class ParserTarget:
    def start(self, tag, attrib):
        '''
            在元素打开时被调用
            tag 是元素的标签名
            attr 是元素属性的字典
        '''
        pass
    def end(self, tag):
        '''
            在元素关闭时被调用
            tag 是元素的标签名
        '''
        pass
    def data(self, data):
        '''
            文本结点被调用
            data 是文本字符串
        '''
        pass
    def close(self):
        '''
            解析完成后被调用
        '''
        pass

parser_target = ParserTarget()
parser = etree.XMLParser(target=parser_target)
```
当调用这个parser 时，将返回close()方法的返回值


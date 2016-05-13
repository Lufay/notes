# Python

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
#### 行注释
`#`
#### 文档注释
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
	suite = addTest(ATestCase("testSize"))
	suite = addTest(ATestCase("testResize"))
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
可以在执行Python时加上-m pdb选项，进行调试，断点是在程序执行的第一行之前。
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
%(message)s            用户输出的消息

##### 每个级别对应一个打印函数
logging.debug('debug message')
logging.info('info message')
logging.warning('warning message')
logging.error('error message')
logging.critical('critical message')
实际上，调用这些打印函数，是通过一个Logger对象完成的

##### 四个概念
+ Logger：负责接收用户message，完成打印；可以添加多个Handler和Filter
+ Handler：负责管理一个日志target；可以设置一个Formatter和添加多个Filter
+ Formatter：负责日志的格式
+ Filter：负责日志过滤

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
setFormatter()：  给这个handler选择一个Formatter
addFilter(filt)：增加Filter
removeFilter(filt)：删除Filter

可用的Handler：
+ logging.StreamHandler          可以向类似与sys.stdout或者sys.stderr的任何文件对象(file object)输出信息
+ logging.FileHandler                用于向一个文件输出日志信息
+ logging.handlers.RotatingFileHandler        类似于上面的FileHandler，但是它可以管理文件大小。当文件达到一定大小之后，它会自动将当前日志文件改名，然后创建一个新的同名日志文件继续输出
+ logging.handlers.TimedRotatingFileHandler 和RotatingFileHandler类似，不过，它没有通过判断文件大小来决定何时重新创建日志文件，而是间隔一定时间就自动创建新的日志文件
+ logging.handlers.SocketHandler                  使用TCP协议，将日志信息发送到网络。
+ logging.handlers.DatagramHandler             使用UDP协议，将日志信息发送到网络。
+ logging.handlers.SysLogHandler                 日志输出到syslog
+ logging.handlers.NTEventLogHandler         远程输出日志到Windows NT/2000/XP的事件日志 
+ logging.handlers.SMTPHandler                   远程输出日志到邮件地址
+ logging.handlers.MemoryHandler                日志输出到内存中的指定buffer
+ logging.handlers.HTTPHandler                    通过"GET"或"POST"远程输出到HTTP服务器

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

#### 4.4 Profilers（性能测试器）
Profile：老，Python实现，最慢
hotshot：较新，C实现，生成结果时间长
cProfile：新，C实现，分析时间长

## 第三章. 数据类型

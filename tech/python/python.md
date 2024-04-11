Python

[Python 2](https://docs.python.org/2/)
[Python 3](https://docs.python.org/3/)
[文档目录](https://docs.python.org/zh-cn/3/contents.html)
[Python Cookbook 3rd Edition](https://python3-cookbook.readthedocs.io/zh_CN/latest/)
[教程](https://blog.hszofficial.site/TutorialForPython/)
[TOC]

# 第一章. Python特性

## 1. 内置的高级数据结构
列表（高级数组，向量）、元组、字典（k-v map）

## 2. 面向对象
数据、行为、功能逻辑的封装
Python 采用的是duck-typing（鸭子类型）的方式，即不依靠查找对象类型来确定其是否具有正确的接口，而是直接调用或使用其方法或属性。所以避免使用 type() 或 isinstance() 检测，而往往会采用 hasattr() 检测或是 EAFP 编程（假定对象满足指定的接口，而通过try-except 处理异常情况，与LBYL 风格先对，其是先检查是否满足条件在进行处理）
针对hasattr() 检测比较笨拙的方式，ABC（abstract base class）引入了虚拟子类，即不需要显式继承，而能够被 isinstance() 和 issubclass() 所认可
对应的getattr()，比直接使用`.`获取属性多了可以指定默认值，即当属性不存在时返回默认值

## 3. 函数式编程
函数式编程使用一系列的函数解决问题。函数仅接受输入并产生输出，不包含任何能影响产生输出的内部状态。任何情况下，使用相同的参数调用函数始终能产生同样的结果。
在一个函数式的程序中，输入的数据“流过”一系列的函数，每一个函数根据它的输入产生输出。
函数式风格避免编写有“边界效应”(side effects)的函数：修改内部状态，或者是其他无法反应在输出上的变化。完全没有边界效应的函数被称为“纯函数式的”(purely functional)。避免边界效应意味着不使用在程序运行时可变的数据结构，输出只依赖于输入。

### 3.1 优点
逻辑可证，模块化、组件化（简单原则，一个函数只做一件事情，将大的功能拆分成尽可能小的模块，小的函数件组合出新功能），易测试（无效构造状态的测试桩）、易调试（只需检查是否正确使用接口即可），更好的可读性和可维护性。

### 3.2 特征
函数是第一类值（first-class value）：函数（通常使用函数名）和整型、字符串等一样，可以作为变量、参数、返回值。
匿名函数（lambda）：使用处定义，不求重用，为更可读。
封装控制结构的内置模板函数：为了控制边界效应，就要尽量避免使用变量，尤其是为了控制流而定义的变量，于是这些控制流就被内化为一些模板函数，比如filter。结果是代码更简洁，也更可读，代价仅仅是一些学习成本。
闭包（closure）：函数可以定义于任何位置，而闭包就是绑定了函数定义所在域变量的函数。那么当离开函数定义的域之外使用这个函数对象时，就可以使用其绑定的变量；并且当执行到内部函数定义处，也就创建了不同的闭包，这样，即使是同一个函数，也绑定了不同的变量。（注：在python2.x中，绑定变量被看出创建了一个同名的局部变量将外部变量隐藏，因此实际上是无法修改绑定变量的值；而在python3.x中，引入了nonlocal关键字，使用该关键字修饰外部变量后，后面就绑定的是外部变量本身，于是也就可以修改外部变量了，也就是说不同闭包将会相互影响）
支持不可变的数据结构：使用不可变的数据结构，可以确保边界效应。

## 4. 可重用性，易扩展性，可移植性，可读性，易维护
易扩展性建立在无论要访问的模块是来自于标准库还是自定义的，其访问方式都是一致的
对于强调性能的部分，还可以使用C作为Python扩展，并且访问方式也都是一致的
因为 Python 的标准实现是使用 C 语言完成的（也就是 CPython），所以要使用 C 和 C++ 编写 Python 扩展。Python 的 Java 实现被称作 Jython，要使用 Java 编写其扩展。最后，还有 IronPython，这是针对 .NET 或 Mono 平台的 C# 实现。你可以使用 C# 或者 VB.Net 扩展 IronPython。
CPython 的一个局限就是每个 Python 函数调用都会产生一个 C 函数调用. 这意味着同时产生的函数调用是有限制的, 因此 Python 难以实现用户级的线程库和复杂递归应用. 一旦超越这个限制, 程序就会崩溃. 你可以通过使用一个 “stackless” 的  Python 实现来突破这个限制, 一个 C 栈帧可以拥有任意数量的 Python 栈帧. 这样你就能够拥有几乎无穷的函数调用, 并能支持巨大数量的线程. 这个 Python 实现的名字就叫Stackless

基于C的可移植性，Python的可移植性既适用于不同的架构，也适用于不同的操作系统

没有其他语言通常用来访问变量、定义代码块和进行模式匹配的命令式符号。通常这些符号包括：美元符号（$）、分号（;）、波浪号（~）等等。
强制的代码风格要求

## 5. 健壮性（错误追踪）
一旦你的 Python 由于错误崩溃，解释程序就会转出一个“堆栈跟踪”，那里面有可用到的全部信息，包括你程序崩溃的原因以及是那段代码（文件名、行数、行数调用等等）出错了。这些错误被称为异常。如果在运行时发生这样的错误，Python 使你能够监控这些错误并进行处理。

## 6. 高效的快速原型开发工具
与那些封闭僵化的语言不同，Python 有许多面向其他系统的接口，它的功能足够强大，本身也足够强壮，所以完全可以使用 Python 开发整个系统的原型。传统的编译型语言也能实现同样的系统建模，但是 Python 工程方面的简洁性让我们可以在同样的时间内游刃有余的完成相同的工作。
大家已经为 Python 开发了为数众多的扩展库，所以无论你打算开发什么样的应用程序，都可能找到先行的前辈。你所要做的全部事情，就是来个“即插即用”（当然，也要自行配置一番）！只要你能想得出来，Python 模块和包就能帮你实现。Python 标准库是很完备的，如果你在其中找不到所需，那么第三方模块或包就会为你完成工作提供可能。

## 7. 内存管理
将内存管理工作从程序员的业务逻辑中分离出来，使之更为专注于后者。
引用计数技术：对每个对象都有一个引用计数器。释放掉引用计数为0的对象，和仅有这个对象可达的其他对象。
此外，为解决引用计数的循环引用问题，还有一个循环垃圾收集器。试图清理所有未引用的循环。
（Python的内存泄露？？）

## 8. 字节码
类似Java，Python同样字节编译的，而后在解释执行。
当源文件被解释器加载，或显式进行字节码编译时，会被编译为字节码，由于调用解释器的方式不同，源文件会被编译成.pyc或.pyo文件

GIL（global interpreter lock）：CPython 解释器所采用的一种机制，它确保同一时刻只有一个线程在执行 Python bytecode。此机制通过设置对象模型（包括 dict 等重要内置类型）针对并发访问的隐式安全简化了 CPython 实现。给整个解释器加锁使得解释器多线程运行更方便，其代价则是牺牲了在多处理器上的并行性。
不过，某些标准库或第三方库的扩展模块被设计为在执行计算密集型任务如压缩或哈希时释放 GIL。此外，在执行 I/O 操作时也总是会释放 GIL。

## 9. 与其他语言的比较
Perl 最大的优势在于它的字符串模式匹配能力，其提供了一个十分强大的正则表达式匹配引擎。这使得 Perl 实际上成为了一种用于过滤、识别和抽取字符串文本的语言，而且它一直是开发 Web 服务器端 CGI(common gateway interface,通用网关接口)网络程序的最流行的语言。Python 的正则表达式引擎很大程度上是基于 Perl 的。
然而，Perl 语言的晦涩和对符号语法的过度使用，让解读变得很困难。Perl 的这些额外的“特色”使得完成同一个任务会有多个方法，进而引起了开发者之间的分歧和内讧。

Python的简洁比纯粹的使用 Java 提供了更加快速的开发环境。
在 Jython 的脚本环境中，你可以熟练地处理 Java 对象，Java可以和 Python 对象进行交互，你可以访问自己的 Java 标准类库，就如同 Java 一直是 Python环境的一部分一样。

由于 Rails 项目的流行，Python 也经常被拿来和 Ruby 进行比较。就像前面我们提到的，Python 是多种编程范式的混合，它不像 Ruby 那样完全的面向对象，也没有像 Smalltalk那样的块，而这正是 Ruby 最引人注目的特性。而 Ruby 事实上可以看作是面向对象的 Perl。

Tcl 是最易于使用的脚本语言之一，程序员很容易像访问系统调用一样对 Tcl 语言进行扩展。与 Python相比，它或许有更多局限性（主要是因为它有限的几种数据类型），不过它也拥有和 Python一样的通过扩展超越其原始设计的能力。更重要的是，Tcl 通常总是和它的图形工具包 Tk 一起工作， 一起协同开发图形用户界面应用程序。所以 Tk 已经被移植到Perl(Perl/Tk)和 Python(Tkinter)中. 与 Tcl 相比，因为Python 有类， 模块及包的机制，所以写起大程序来更加得心应手。

Python 有一点点函数化编程（functional programming ，FP）结构，这使得它有点类似List 或 Scheme 语言。举例来说， 列表解析就是一个广受欢迎的来自 Haskell 世界的特性， 而 Lisp 程序员在遇到 lambda, map, filter 和 reduce 时也会感到异常亲切。
参考：<http://www.cs.sfu.ca/CourseCentral/310/pwfong/Lisp/>

JavaScript 是基于原型系统的， 而 Python 则遵循传统的面向对象系统， 这使得二者的类和对象有一些差异。

# 第二章. 开始
Python之禅，输入import this就可以查看

## 1. 交互REPL
Python 的主提示符( >>> )和次提示符( ... )，其功效类似于SHELL中的主提示符( $ )和次提示符( > )。主提示符是解释器告诉你它在等待你输入下一个语句，次提示符告诉你解释器正在等待你输入当前语句的其它部分。
退出交互：使用exit()函数或者输入EOF（Linux下的Ctrl+D，Windows下的Ctrl+Z）

### 1.1 输出
```py
print var1, var2, var3  # Python 2 print是关键字，整体是一个语句，无法参与其他语句构造
print(var1, var2, var3) # Python 3 print是一个正常的函数，返回None，可以参与到语句构造中；而且函数本身就是对象，所以可以对其进行改写：

@contextlib.contextmanager
def replace_print():
    import builtins
    _print = print # store the original print function
    # or do something useful, e.g. store output to some file
    builtins.print = lambda *args, **kwargs: _print('new printing', *args, **kwargs)
    yield
    builtins.print = _print
    
with replace_print():
    # code here will invoke replaced print function
```
其中var可以是字面值也可以是变量，用逗号分隔的各部分将显示为一个空格分隔，最后换行（Python3 可以通过sep=' ' 和end='\n' 参数来指定）
如果不想要换行，可以在语句末尾加上一个逗号“,”即可。结果将是以空格收尾，而不是换行收尾。
单独的一个print语句，将打印一个空行

如果打印的是变量，由于python的面向对象特性，实际上是对变量调用了 str() 函数
在交互式环境中，直接使用变量名进行显示的是变量的原始内容，即对变量调用了 repr()函数，相当于反引号运算符（`` ` `` `` ` ``）。
*附*:str() 与repr() 的区别：
str() 目的在于可读性较好的字符串表示
repr() 目的在于可重建对象的字符串表示，对于一个对象obj，一般 obj == eval(repr(obj))
对于内置的容器对象，会默认str=repr，所以容器元素也会默认调用repr

print 语句相当于函数`sys.stdout.write('xxxx\n')'`，只不过后者需要import sys模块。

#### 输出重定向
```py
logfile = open('/tmp/mylog.txt', 'a')
print >> logfile, 'Fatal error: invalid input!'     # Python 2
print("critical error", file=sys.stderr)            # Python 3
logfile.close()
```
这里logfile，还可以是 sys.stderr （不需要打开，直接 import sys 即可）

#### pprint 模块
使打印python 的结构化数据更可读
该模块有一个类PrettyPrinter 和几个简易函数：
pformat(object, indent=1, width=80, depth=None)：返回一个字符串
pprint(object, stream=None, indent=1, width=80, depth=None)：默认打印到sys.stdout，除非设置stream 参数
isrecursive(object)：检查对象是否递归包含
isreadable(object)：检查对象是否可以使用 eval() 函数进行重建（如果递归包含返回False）
saferepr(object)：返回一个字符串（对递归包含处理为`<Recursion on typename with id=number>`，但不会做格式化）

##### PrettyPrinter 类
构造：`PrettyPrinter(indent=1, width=80, depth=None, stream=None)`
stream 可以设置为支持write 方法的类文件对象，如果未指定，则使用sys.stdout
depth 是打印的最大嵌套深度，对于超过深度的内容，将表示为...
indent 是显示坐进量
width 是显示宽度

方法：
+ pformat(object)
+ pprint(object)
+ isrecursive(object)
+ isreadable(object)：对于超过深度的对象也返回False
+ format(object, context, maxlevels, level)：该方法用于该类被继承后修改格式化字符串的实现，默认使用saferepr() 实现
context 参数是一个字典，包含了当前上下文中已经存在的对象id，如果该对象再次被发现，说明有递归包含，递归调用format 方法将容器对象添加到这个字典中
maxlevels 指定支持的最大嵌套深度，0 表示无限，在递归调用中，该参数不修改直接传递
level 指定当前的层级
该函数需要返回三个值：格式化字符串，一个表示是否可读的flag，一个表示是否发现递归包含的flag

### 1.2 输入
```python
user_in = raw_input('Enter login name: ')
```
`raw_input`这个函数的参数（可选的）是提示信息（系统不会补充换行符），而后等待用户输入，读取用户输入的一行后，返回输入的字符串（不包括最后的换行符）。
由于返回的是字符串，所以如果想用变为其他类型，必须使用类型转换函数。
如果读到EOF，则抛出EOFError异常；如果使用Ctrl+C，将产生一个KeyboardInterrupt异常。
当你需要暂停脚本的执行，观察之前执行的状态时，可以直接使用`raw_input()`，这样就可以保持窗口开着，直到你按下回车键才关闭。

### 1.3 命令行参数
只需要import sys，命令行参数就在sys.argv这个列表中

#### 1.3.1 解析工具getopt
```python
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

#### 1.3.2 解析工具optparse
```python
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

##### Option类的属性
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

#### 1.3.3 optparse的升级版argparse
##### 概念
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
    `store_const` flag使用（仅指定标识，不指定参数），保存const参数的值
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
	- metavar，用以提醒用户，该选项期望的参数的描述（用以帮助信息中的占位），默认为positional argument或option argument 的dest属性变大写。当需要多个期望参数是，该项指定为一个tuple.
	- dest，指定保存到`parse_args`返回Namespace对象的属性名（若不指定，则为选项名的长格式名，若没有则使用short格式名，其中间的`-`转换为`_`）
+ `parse_args()`：返回一个Namespace对象（可以通过vars()函数将其转换为dict）。无参调用将自动解析sys.argv，也可以手动提供这样一个list作为参数。
+ `add_argument_group(title=None, description=None)`：增加一个分组，返回一个分组对象，该对象同样可以进行`add_argument`
+ `add_mutually_exclusive_group(required=False)`：增加一个互斥分组（可以将冲突的参数合在一个互斥分组中，则该分组只能选一个），required为True，则要求互斥分组必选其一。
+ exit(status=0, message=None)：结束程序，返回status，并打印message
+ error(message)：结束程序，返回2，并打印message

*注*：
1. 如果没有add任何argument，也会自动生成一个-h/--help选项
2. 支持分隔式给定参数值，long格式=给定参数值，short格式和参数值连用，short格式一起连用；支持前缀指定参数（在不造成混淆的情况下）
参考：<https://docs.python.org/zh-cn/3/library/argparse.html>

### 1.4 帮助
+ help([obj]): 如果给出obj，则将给出其的帮助信息（文档字符串等），如果没有给出参数，则进入交互式帮助。
+ type(obj): 返回obj 的类型对象（类型本身就是一个对象，可以通过该对象的__name__属性查看类型名）
+ `isinstance(x, class_type_tuple)`: `class_type_tuple`可以是一个类型或类，也可以是一个类型或类的元组（Python3.10，还可以是类型的union）。如果x是这些类型或其子类的实例，则返回True，否则返回False
+ `issubclass(class, class_type_tuple)`: 判断一个类型对象是否是另一个/组类型的子类（如果自身也算自身的子类）
+ dir([obj]): 如果给出obj（可以是模块，类，对象等），则返回obj 空间下的属性列表（包括继承的属性，但不包括定义在元类(metaclass)中的类属性）；未给出则返回当前域的可访问属性列表（相当于locals().keys()）
+ vars([obj]): 返回obj 空间下的属性字典（不包括继承的属性）。对一个自定义的类调用该函数，相当于访问该类的`__dict__`属性；未传obj 将返回当前域的可访问属性的字典（相当于locals()）
+ hash(obj): 返回一个对象的哈希值（整数），同值有相同哈希值（仅限同进程内），反之不一定。对于不可哈希的类型会抛TypeError异常
对一个自定义的类调用该函数，则将调用该类的`__hash__(self)`这个方法，可以自己重定义该函数，返回一个整数值。

#### 环境信息：
import sys
sys.platform
sys.version

退出程序：
sys.exit([status])
如果缺省status，则进程返回0。如果是整数，则进程返回该整数，如果是其他的，则打印该对象，进程返回1.

### 1.5 关于函数中进行IO的建议
设计函数时，最好将其输入输出都作为参数和返回值，而将IO的工作放在函数之外，除非该函数的功能就是完成IO。这样做的好处是使该函数的重用性更好。

## 2. 代码文本
执行脚本：python script.py

### 2.1 脚本首行指定解释器（类Unix下）
指定绝对路径：
```
#!/usr/local/bin/python
```
使用env在系统搜索路径中找python解释器：
```
#!/usr/bin/env python
```

完成之后就可以给该脚本以执行权限执行了

### 2.2 注释
#### 行注释
`#`
#### 文档注释
在模块、类或者函数的起始添加一个字符串（位于def后的第一行）
这种注释可在运行时访问（通过访问对象（模块、类、对象、函数的名字）的`__doc__`属性，动态获得）
也可以用来自动生成文档（help查看）

### 2.3 标识符
大小写敏感，命名规范同C
Python 不支持重载标识符，所以任何时刻都只有一个名字绑定。

#### 2.3.1 关键字
import keyword
导入keyword模块，可以查看关键字列表`keyword.kwlist`和使用`iskeyword()`函数进行判断

#### 2.3.2 内建标识符
built-in系统保留字，可以把它们看成可用在任何一级 Python 代码的全局变量，表示特定的意义，一般不做他用，除非是在某些特定情况下进行重定义。
built-in 是`__builtins__`模块（在python3中是`builtins`模块）的成员，在你的程序开始或在交互解释器中给出>>>提示之前，由解释器自动导入。

#### 2.3.3 专用下划线标识符
`_`：表示最后一个表达式的值（注意：有些表达式可能没有值，比如赋值、print）
`_xxx`：不用`from module import *`导入；
`__xxx__`：系统定义名字；（例如：`obj.__name__`是obj的名字，`obj.__doc__`是obj的文档字符串）
`__xxx`：类中的私有变量名。
一般来讲，使用变量名`_xxx`命名私有的成员，即在模块或类外不可以使用。

### 2.4 代码块
语句块通过缩进表示从属于哪个代码块，同一缩进深度表示属于同一代码块级别内
没有缩进的代码块是最高层次的，被称做脚本的“main”部分

如果一行写一条语句，则不需要语句分隔符，否则，需要用分号“;”
如果一行语句分多行写，可以在行末使用“\”进行续行（此外，括号和三引号内的内容，可以直接跨行而不用“\”）

推荐缩进格式（参考PEP8）：
```
# 对齐缩进
foo = long_function_name(var_one, var_two,
                         var_three, var_four)

# 参数缩进
def long_function_name(
		var_one, var_two, var_three,
		var_four):
	print(var_one)

# 续行缩进
foo = long_function_name(
	var_one, var_two,
	var_three, var_four)

# 使用注释区别同级缩进
if (this_is_one_thing and
    that_is_another_thing):
    # Since both conditions are true, we can frobnicate.
    do_something()

# 运算符增加缩进
if (this_is_one_thing
        and that_is_another_thing):
    do_something()

# 运算符和右操作数一起
income = (gross_wages
          + taxable_interest
          + (dividends - qualified_dividends)
          - ira_deduction
          - student_loan_interest)
```

### 2.5 代码结构
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

from __future__ import barry_as_FLUFL

__all__ = ['a', 'b', 'c']
__version__ = '0.1'
__author__ = 'Cardinal Biggles'

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

## 3. Python的一些特性
### 3.1 一切类型的值均为对象
所有对象都有三个特性：Id、类型、值。他们分别可以使用内建函数id(obj)、type(obj)、obj来获得。其中Id用于唯一的标识一个对象，是一个int型的值，type返回的类型本身也是一种类型，这两者都是只读的，对于可变对象，值是可写的，而对于不可变对象，值也是只读的。
因此，那些在其他语言中视为常量的值，在Python中都是对象，可以直接调用他们的方法或运算符，而不必先将他们赋值给一个变量。

### 3.2 动态类型
变量免声明，其类型和值在赋值时被赋予（但在变量在使用前必须初始化）

## 4. 其他开发工具
### 4.1 测试
对于那些不直接执行的库模块，可以让其直接执行去完成一些测试任务，即在`__main__`中直接写简单的测试代码，因为该部分在import时是不执行的

#### unittest
[参考](https://docs.python.org/2/library/unittest.html)
Python标准库中还提供了unittest模块，有时也被称为PyUnit，是Python的单元测试框架
软件测试中最基本的组成单元是测试用例（test case），PyUnit使用TestCase类来表示测试用例，并要求所有用于执行测试的类都必须从该类继承。TestCase子类实现的测试代码应该是自包含（self contained）的，也就是说测试用例既可以单独运行，也可以和其它测试用例构成集合共同运行。利用Command和Composite设计模式，多个TestCase还可以组合成测试用例集合。

##### TestCase
在从TestCase继承的测试子类中，定义setUp()和tearDown()方法可以用于进行每个case的前置初始化和测试完的收尾工作。
一个TestCase的执行过程就是setUp –> 测试方法 –> tearDown。
测试方法的定义有两种方式，一种是静态方式，即定义一个runTest()方法，那么实例化测试类时，就使用无参构造；另一种是动态方式，不再定义runTest()方法，而定义多个测试方法（习惯以test开头），那么实例化测试类时，就要在构造时给出所要执行的那个测试方法的方法名字符串（作为参数）。

##### TestSuite
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

##### TestRunner
PyUnit使用TestRunner类作为测试用例的基本执行环境，来驱动整个单元测试过程。Python开发人员在进行单元测试时一般不直接使用TestRunner类，而是使用其子类TextTestRunner来完成测试，并将测试结果以文本方式显示出来：
```
runner = unittest.TextTestRunner()
runner.run(suite)
```
默认情况下，TextTestRunner将结果输出到sys.stderr上，但如果在创建TextTestRunner类实例时将一个文件对象传递给了构造函数，则输出结果将被重定向到该文件中。

##### 简易方法
PyUnit模块中定义了一个名为main的全局方法，使用它可以很方便地将一个单元测试模块变成可以直接运行的测试脚本，main()方法通过TestProgram这个类使用TestLoader类来搜索所有包含在该模块中的测试方法，使用makesuite组装成一个testSuite，而后将之交给TextTestRunner去执行它们。如果Python程序员能够按照约定（以test开头）来命名所有的测试方法，那就只需要在测试模块的最后加入如下几行代码即可：
```
if __name__ == "__main__":
	unittest.main()
```
使用这种方式后，可以使用
`python main.py` 来执行所有case（按照测试方法名的字典序依次执行）
`python main.py ATestCase.testSize` 来执行指定的case
`python main.py –h` 来查看运行该脚本所有可能用到的参数

##### 测试结果
一个点（.）表示通过一个case
一个F表示fail了一个case
E表示程序自身异常

##### TestCase类中可用的检测方法
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

### 4.2 调试器
pdb，支持（条件）断点，逐行执行，检查堆栈。还支持事后调试。
可以在执行Python时加上-m pdb选项（python -m pdb a.py args），进行调试，断点是在程序执行的第一行之前。
当然，也可以在代码中import pdb；而后通过调用`pdb.run('mymodule.test()')`进行调试，或`pdb.set_trace()`设置断点。

#### 调试命令
h [cmd]	查询cmd命令
l		列出当前运行部分的代码
p		打印某个变量
b [line/func]	在line行或func函数入口设置断点（如果未给出位置，则显示当前所有断点）
condition bnum [cond]	将bnum号断点设置条件cond
cl [bnum]	清除指定断点，如果未给出断点号，则清除当前所有断点
disable/enable bnum	将bnum号断点禁用/激活
r       执行代码直到从当前函数返回
s		单句步进
n		单行步进
c		（从中断）恢复执行
j line		跳到指定行line
a		显示当前函数的参数
!stat		执行语句stat，可以直接改变某个变量
q		退出调试
w		打印栈跟踪信息（即bt命令）最近使用的栈框（frame）在底部，当前栈框有箭头指示
u/d		将当前栈框上移/下移

### 4.3 日志
logging模块
线程安全

```py
import logging
logging.basicConfig(
    filename = 'xxx.log', filemode = 'a', encoding='utf-8',
    datefmt = '%Y-%m-%d %H:%M:%S %f',
    format = '%(levelname)s %(asctime)s [%(funcName)s:%(lineno)d] %(message)s',
    level = logging.DEBUG
)
```
其被设置为一次性的配置，只有第一次调用会进行操作。
配置：
filename：   用指定的文件名创建FiledHandler，日志会被存储在该文件中。
filemode：   文件打开方式，在指定了filename时使用这个参数，默认值为“a”还可指定为“w”。
encoding:   文件编码，Python3.9 添加该参数
datefmt：    指定日期时间格式，同time.strftime()。
format：      指定日志显示格式，默认：'%(levelname)s:%(name)s:%(message)s'
level：        设置rootlogger的日志级别（只有该级别或以上级别的日志才会打印）默认WARNING
stream：     用指定的stream创建StreamHandler。可以指定输出到sys.stderr, sys.stdout或文件，默认为sys.stderr。当设置了filename之后，该配置忽略

#### 日志的级别有
CRITICAL > ERROR > WARNING > INFO > DEBUG > NOTSET
除此之外，还可以自定义日志级别

CRITICAL：致命，程序无法继续运行
ERROR：错误，程序一些功能失败
WARNING：警告，程序可以按预期执行，但一些意想不到的事发生了，可能存在一些错误
INFO：通知信息
DEBUG：调试信息

#### format中的格式化串：
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

#### 每个级别对应一个打印函数
logging.debug('debug message')
logging.info('info message')
logging.warning('warning message')
logging.error('error message')
logging.critical('critical message')
实际上，调用这些打印函数，是通过一个Logger对象完成的
函数的原型是`(msg, *args, **kwargs)`，支持`msg % args`

#### 四个概念
+ Logger：负责接收用户message，完成打印；可以添加多个Handler和Filter
+ Handler：负责管理一个日志target，可以根据不同的级别分发到不同地方；可以设置一个Formatter和添加多个Filter
+ Formatter：负责日志的格式
+ Filter：负责日志过滤（基于logger的name）

##### Logger
获得一个Logger
```
logging.getLogger([name])
```
name是一个Logger的标识key，因为Logger组成一个树形的层次关系，所以name字符串中可以用`.`划分层次。默认有一个root Logger，所有其他的Logger都默认在root之下，如果name缺省获得的就是root。子Logger继承父Logger的配置（可以通过将记录器的 propagate 属性设置为 False 来关闭传播）。一般可以使用`__name__`模块名作为标识key，作为模块级logger

一个Logger可以拥有多个Handler，从而可以同时输出到多个target

方法：
上面5个打印函数实质上就是调用root Logger 的对应方法，此外还有exception()用法和前5个一样，差别是会记录当前的堆栈追踪，若自定义的日志级别，可以使用log()，它将日志级别作为显式参数
setLevel(lel)：设置打印最低日志级别，低于此级别则不会下发给其下面的handler
addHandler(hd)：增加Handler
removeHandler(hd)：删除Handler
addFilter(filt)：增加Filter
removeFilter(filt)：删除Filter

如果在多模块使用：
同一个解释器中，日志管理的是同一套，即相同的标识key都是会返回同一个logger实例

##### Handler
获得一个Handler：
```py
logging.FileHandler('/tmp/test.log')

logging.StreamHandler()

RotatingFileHandler('myapp.log', maxBytes=10*1024*1024, backupCount=5)
```

方法：
setLevel(lel)：设置打印最低日志级别，低于此级别则该handler不会处理
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

##### Formatter
获得一个Formatter：
```
logging.Formatter(fmt=None, datefmt='%Y-%m-%d %H:%M:%S', style='%')
```
style 是Python3.2 新加入的参数，可以是 `％`，`{` 或 `$` 之一（`%` 格式见上，`{`格式与str.format() （使用关键字参数）兼容，`$`格式符合 string.Template.substitute()）

##### Filter
获得Filter：
```
logging.Filter('mylogger.child1.child2')：通过Logger标识key的前缀来完成过滤
```

#### 配置
```py
import logging
import logging.config

LOGGING_CONFIG = {
    "version": 1,       # 模式版本，当前有效值只能为1
    "formatters": {
        "default": {
            'format':'%(asctime)s %(filename)s %(lineno)s %(levelname)s %(message)s',
        },
        "plain": {
            "format": "%(message)s",
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "level": "INFO",
            "formatter": "default",
        },
        "console_plain": {
            "class": "logging.StreamHandler",
            "level":logging.INFO,
            "formatter": "plain"
        },
        "file":{
            "class": "logging.FileHandler",
            "level":20,
            "filename": "./log.txt",
            "formatter": "default",
        }
    },
    "loggers": {
        "console_logger": {
            "handlers": ["console"],
            "level": "INFO",
            "propagate": False,
        },
        "console_plain_logger": {
            "handlers": ["console_plain"],
            "level": "DEBUG",
            "propagate": False,
        },
        "file_logger":{
            "handlers": ["file"],
            "level": "INFO",
            "propagate": False,
        }
    },
    "disable_existing_loggers": True,   # 该配置默认是True，表示此前配置的除root 之外的loggger 都将失效
}

# 使用文件配置，disable_existing_loggers 默认是True
logging.config.fileConfig("logger.conf", disable_existing_loggers=True)
# 使用字典配置
logging.config.dictConfig(LOGGING_CONFIG)

logger = logging.getLogger("example01")
```
也可以使用YAML 格式读入字典配置
```conf
# 列出对象标识key，若getLogger的key 未配置，则使用root logger
[loggers]
keys=root,simpleExample
[handlers]
keys=consoleHandler,hand01,hand02
[formatters]
keys=simpleFormatter,form01,form02

# 下划线后面的是标识key
# propagate 是否继承父类的log信息，0:否 1:是
[logger_root]
level=DEBUG
handlers=consoleHandler
[logger_simpleExample]
level=DEBUG
handlers=hand01,hand02
qualname=simpleExample
propagate=0

# args handler初始化函数参数
[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)
[handler_hand01]
class=FileHandler
level=DEBUG
formatter=form01
args=('myapp.log', 'a')
[handler_hand02]
class=handlers.RotatingFileHandler
level=INFO
formatter=form02
args=('myapp.log', 'a', 10*1024*1024, 5)

[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt=
[formatter_form01]
format=%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s
datefmt=%a, %d %b %Y %H:%M:%S
[formatter_form02]
format=%(name)-12s: %(levelname)-8s %(message)s
datefmt=
```

### 4.4 配置文件
Python 支持对ini 格式的配置文件进行读取

#### ini配置文件格式
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

#### ConfigParser 模块（Python3 改为小写的 configparser）
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


### 4.5 Profilers（性能测试器）
Profile：老，Python实现，最慢
hotshot：较新，C实现，生成结果时间长
cProfile：新，C实现，分析时间长

# 第三章. 数据类型
[内置类型](https://docs.python.org/zh-cn/3/library/stdtypes.html)

## 1. 数值类型
这些类型都是不可变类型

字面值可以在数字中加入下划线进行分隔：
```py3
one_million = 1_000_000
addr = 0xCAFE_F00D
flags = 0b_0011_1111_0100_1110

# same, for string conversions
flags = int('0b_1111_0000', 2)
```

### 1.1 int
+ 二进制：0b 打头
可以使用`bin()`将一个十进制数转换为二进制字符串（带有0b）
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

~~其宽度取决于环境，比如32位环境（机器和编译器）宽度为32位，只不过当计算溢出后，结果会自动转变为long~~

#### 类方法
int.from_bytes(bytes, byteorder, *, signed=False)：Python3.2

#### 方法
+ bit_length()：Python3.1，返回整数绝对值二进制表示的位数（不包括符号和先导的0），整数0返回0
+ bit_count()：Python3.10，返回整数绝对值二进制表示中 1 的个数
+ to_bytes(length, byteorder, *, signed=False)：Python3.2
  + 返回的字节数是length（可以使用`(bit_length+7)//8`计算获得），若整数超出length，则抛OverflowError，若不足则按整数字节码进行高位补齐；
  + byteorder 是字节序（可以使用`sys.byteorder`获取主机的字节序），"big"表示高字节放在字节数组的开头，"little"表示低字节放在字节数组的开头；
  + signed 是否使用二的补码来表示整数，若负整数使用signed=False，将抛OverflowError

### 1.2 long
Python3 移除该类型（整形统一为int）
后缀l或L（也支持十进制、八进制、十六进制表示）

其宽度仅受限于用户计算机的虚拟内存大小，类似于 Java 中的 BigInteger 类型

### 1.3 bool（布尔值）
只有两个实例：True（数值1）、False（数值0）
是int的子类，但不能被继承

构造函数：
bool()          False

所有标准对象都可用于布尔测试，因为可以隐式对其调用bool(obj)。
该函数的作用是调用类的`__nonzero__()`方法
对于内建类型：None，值为零的任何数字，空字符串、空列表、空元祖、空字典的布尔值都是False。其他都是True。
对于自定义的类的实例，如果类实现了`__nonzero__()`方法（返回类型为int或bool），则返回其返回值，如果没有实现该方法，而实现了`__len__()`方法（返回类型为非负整数），则返回其返回值，否则都没有时，为True。

### 1.4 float（浮点数）
支持e和E的科学计数法

构造函数：
float()         0.0
支持字符串转换为一个浮点数，但字符串中不能含有非法字符，否则会抛异常

占8个字节，遵守IEEE754规范（52M底/11E指/1S符）
然而实际精度依赖于机器架构和编译Python解释器的编译器

#### decimal
还有一种十进制浮点数decimal，比float有着更大的取值范围或精度，但不是内建类型：
```py
import decimal
decimal.Decimal('1.1')  # 获得一个该类型的值
```
为什么要有十进制浮点数呢，是因为float表示精度有限，而且是基于二进制的，因此即便`0.1` 这种简单的浮点数，实际上都有着精度误差，可以通过`decimal.Decimal(.1)`看到，而decimal可以构造出十进制上无误差的小数。于是，要构造这种小数就不能用浮点数来构造，而应该用字符串，即如上。同理，这种类型不能和float进行运算，可以和整数进行运算，因为和float进行运算会导致不精确的结果，污染decimal，而和整形数则不会。

#### fractions.Fraction
Python3 支持的分数运算
实例是可哈希的，并应当被视为不可变对象
```py
from fractions import Fraction
Fraction()              # 默认，分子=0,分母=1
Fraction(16, -10)       # 会约简为Fraction(-8, 5)
Fraction(2.25)          # Fraction(9, 4)
Fraction('3/7')         # Fraction(3, 7)
Fraction('-.125')       # Fraction(-1, 8)
Fraction('7e-6')        # Fraction(7, 1000000)
Fraction(Decimal('1.1'))    # Fraction(11, 10)
```

numerator: 最简分数形式的分子
denominator: 最简分数形式的分母
as_integer_ratio(): 返回由两个整数组成的元组
limit_denominator(max_denominator=1000000): 找到并返回一个 Fraction 使得其值最接近 self 并且分母不大于 max_denominator。
支持math.floor() math.ceil() round(number[, ndigits])

### 1.5 complex（复数）
使用j或J表示虚数的单位，实部real和虚部imag都是float
不支持比较运算

构造函数：
complex()               0j
complex(3.6)            (3.6+0j)
complex(1.2, 4.5)       (1.2+4.5j)

conjugate()方法：返回共轭复数

### 1.6 相关模块
+ numbers		[数字的抽象基类](https://docs.python.org/zh-cn/3/library/numbers.html)
+ math/cmath	标准C数学函数库，前者是常规运算，后者是复数运算
+ random		多种分布的伪随机数发生器
该模块有很多直接可用的函数，但实际上这些函数都是Random这个类的方法，它们被关联到一个共享状态的实例上，当多线程需要随机数可以使用多个实例，并用jumpahead()方法确保生成不重叠的随机序列。
这些函数以random()为基础：该函数以当前时间为随机数种子，返回`[0, 1)`中的一个随机浮点数
其他常用的方法还有：
    - uniform(a, b)：a, b是上下限，顺序可换，返回a、b之间的浮点数（即`a + (b - a)*random()`）
    - randint(a, b)：返回[a, b]中的一个随机整数
    - randrange([start,] stop [, step])：在range(start, stop, step)生成的列表中随机选择一项（并不实际生成列表）
    - choice(seq)：从非空序列seq中随机选出一个元素
    - choices(seq, weights=None, *, cum_weights=None, k=1)：从非空序列seq中随机选出k个元素，可以设置权重和累计权重（必须跟seq等长），其内部会自动将weights转换为cum_weights，比如weights=[1,2,3,4]，那么就对应了cum_weights=[1,3,6,10]
    - shuffle(x [, random])：将序列x原地打乱，random是一个0元函数返回`[0, 1)`之间的随机数，默认使用random()函数。
    - sample(population, k)：从序列population中随机选取k个元素组成一个新的序列返回
[参考](https://docs.python.org/2/library/random.html)

第三方包：
SciPy有最优化、线性代数、积分、插值、特殊函数、快速傅里叶变换、信号处理和图像处理、常微分方程求解和其他科学与工程中常用的计算。

## 2. 容器类型
+ 可变类型：list、set、dict（key不可变，value可变）
+ 不可变类型：string、unicode、tuple、frozenset
不能改变容器的数量和每个的引用，但可以改变每个对象的内容

容器通用操作
1. 可以使用 len() 函数获得一个**序列（字符串、列表、元组）**或字典、集合的长度（大小）
len()函数实际上是调用对象类中的`__len__()`方法
2. obj [not] in container，判断obj是否是序列或集合的元素，或者obj是否是字典的键

序列通用操作
1. `+` 序列连接（类似的也支持`+=`运算）
2. `* n` 重复 n 次进行连接（类似的也支持`*=`运算）（重复的这n 次都是同一个对象的引用）
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

### 2.1 字符串
引号之间的字符集合（单引号和双引号均可）。
*注*：如果两个字符串写在一起，如"aa" 'bb'，这两个字符串将在编译时就连接为一个字符串了，这种写法便于分行写字符串，并给以行注释）。

#### unicode & bytes
在Python2 中，str串（无前缀引号）默认是字节串，unicode字符串需要在引号前面使用u 前缀
前者是对外IO（包括存储和网络传输）交互使用的，后者是python内使用的，这也就是之所以`s->u`叫做解码decode，反之`u->s`叫做编码encode。
若字节串字面值中使用了超出ASCII 的字符串，需要在代码文本开头加上编码注释

在Python3 中，str串（无前缀引号）默认是unicode，字节串（bytes）需要引号前面使用b 前缀
bytes 字面值中只允许 ASCII 字符（无论源代码声明的编码为何）。任何超出 127 的二进制值必须使用相应的转义序列形式（如`\xf0`之类的）加入 bytes 字面值。
bytes 序列中的每个值的大小被限制为 0 <= x < 256 (否则将抛 ValueError)，所以实际上更像是不可变的整数序列（即b[i] 是一个整数，list(b) 是一个整数列表）

实例方法：hex([sep[, bytes_per_sep]])：返回一个字符串，该字符串是用2个16进制字符表示一个字节
    sep是字节分隔符，默认为空
    是分隔的多字节长度bytes_per_sep，默认是1，若bytes_per_sep 是正，则返回的字符串从右开始，每bytes_per_sep 为一组，每组使用sep 分隔；若bytes_per_sep 是负，则从左开始
类方法：bytes.fromhex(str): 将hex() 格式的字符串编码为bytes（其间的空白符会被忽略）

##### bytearray
bytes 是不可变序列，而bytearray 就是对应的可变的字节序列

bytearray()             空实例
bytearray(10)           0填充的指定长度实例
bytearray(range(20))    整数填充的实例
bytearray(b'Hi!')       通过缓冲区协议复制现有的二进制数据

支持bytes 的所有方法

#### raw string
引号前面使用r 前缀（u在r前）
字符串中的所有字符都直接按照字面值给出，不存在转义或不能打印的字符（常用于构造正则表达式）。
转义方法类同标准C，有点不同就是，如果"\"和后面无法匹配转义，则"\"将保留在字符串中。（使用ASCII码表示的字符，可以使用八进制如\134或十六进制如\x5C表示；使用Unicode表示的字符，可以使用\u1234表示）

#### 三引号字符串
三引号（三个连续的单引号或者双引号）之间的字符是一种所见即所得的字符串，因为该串中的换行，制表和引号等特殊字符无需转义。
对于长字符串，需要跨行写的情况，如果用普通字符串，则在换行前使用"\"（此时，"\"和换行都将忽略，而不会出现在字符串中），否则会有语法错误。而使用三引号字符串，则可以直接跨多行书写（此时，换行将以"\n"保留在字符串中）。
*注：多行字符串是从前三引号就已经开始到后三引号结束的所有字符，其中包含了换行和缩进*

#### 构造函数
bytes()             Python3 对原字节串的支持，bytes(10) 是用0填充的字节序列，bytes(range(20)) 是用整数序列填充，如果对对象使用该函数，则通过缓冲区协议进行复制
str()               ''（空串）（如果对对象使用该函数，则调用对象的`__str__()`方法）
unicode()           u''（Unicode空字符串）（如果对对象使用该函数，则调用对象的`__unicode__()`方法）
basestring()        抽象工厂函数，作用仅仅是为前两者提供父类，因此，不能调用实例化

#### 字符操作
Python没有字符类型，所以字符串可以被视为一种自包含的容器。不过，却有以下函数：
ord(ch)：ch是一个单字符的字符串（ASCII或Unicode），该函数返回相应的ASCII或Unicode值。
chr(num)：返回给定数字（0<=num<=255）对应的ASCII字符。
unichr(num)：返回给定数字对应的Unicode字符，接受的码值范围依赖于Python是构建于UCS-2（0x0000-0xFFFF）还是UCS-4（0x000000-0x110000）

由于字符串的自包含特性，所以，对于[not] in运算符，不仅支持单字符的判断，还支持子串的判断。

#### 字符串格式化
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

##### f-string
在Python2 中使用的是字符串自身的format 方法，而在Python3 中可以直接在字符串前加上f，而后字符串内就可以直接使用当前的变量
```py
# in Python 2，当然{} 中可以使用位置参数的数字索引、关键字参数的名称、也可以省略
# 另外还有format_map(mapping)方法，相当于format(**mapping)，差别是前者直接使用参数本身，后者会将参数拷贝到字典mapping
print '{batch:3} {epoch:3} / {total_epochs:3}  accuracy: {acc_mean:0.4f}±{acc_std:0.4f} time: {avg_time:3.2f}'.format(
    batch=batch, epoch=epoch, total_epochs=total_epochs,
    acc_mean=numpy.mean(accuracies), acc_std=numpy.std(accuracies),
    avg_time=time / len(data_batch)
)
# in Python3.6+
print(f'{batch:3} {epoch:3} / {total_epochs:3}  accuracy: {numpy.mean(accuracies):0.4f}±{numpy.std(accuracies):0.4f} time: {time / len(data_batch):3.2f}')
print(f'Car({key!r}')   # 打印repr
print(f'{{batch}}')     # 两层{} 则表示转义，将输出一组{} 并且其中的内容也只认为是普通字符串
```

#### 判断
`startswith(obj, start=0, end=len)`方法：检查字符串的指定子串是否以obj开头
`endswith(obj, start=0, end=len)`方法：检查字符串的指定子串是否以obj结尾
`isalpha()`方法：是否是非空字母串
`isascii()`：Python3.7，是否所有字符都是 ASCII（空串也返回True）
`isdigit()`方法：是否是数字串（不能含小数点）
`isnumeric()`方法：是否只含数字字符（目前只对Unicode字符串存在）
`isalnum()`方法：是否是非空字母或数字串
`isdecimal()`方法：是否只含十进制数
`islower()`方法：是否是非空小写字符串
`isupper()`方法：是否是非空大写字符串
`isspace()`方法：是否非空且只含空白字符
`istitle()`方法：是否是非空标题化（见title()）的字符串
`isidentifier()`: 是否是有效的标识符，可以用keyword.iskeyword(s) 检测字符串 s 是否为保留标识符

#### 查找
`find(substr, start=0, end=len)`方法：正向查找子串，找到返回开始的索引值，找不到返回-1
`rfind(substr, start=0, end=len)`方法：反向查找子串
`index(substr, start=0, end=len)`方法：同find，只不过，找不到抛出ValueError异常
`rindex(substr, start=0, end=-1)`方法：同rfind，只不过，找不到抛出ValueError异常
`count(substr, start=0, end=len)`方法：查找子串，返回找到的个数

#### 串变换（不改变原串，返回一个新字符串）
`upper()`/`lower()`方法：将所有字符变成大写/小写
`swapcase()`方法：大小写互换
`capitalize()`方法：首字母大写
`title()`方法：所有单词首字母大写，其他字母为小写
`expandtabs(tabsize=8)`方法：把字符串中的tab符号转换为指定数量的空格
`lstrip([chars])`方法：把字符串中左侧的空白符去除（可以指定一个字符串chars，则字符串开头的所有字符如果在chars中，都会被删掉）
`rstrip([chars])`方法：把字符串中右侧的空白符去除（可以指定一个字符串chars，则字符串结尾的所有字符如果在chars中，都会被删掉）
`removeprefix(prefix)`: 移除前缀字符串
`removesuffix(suffix)`：移除后缀字符串
`strip([chars])`方法：同时执行lstrip()和rstrip()方法
`center(width[, fillchar])`方法：返回一个原字符居中，并使用fillchar（默认空格）填充至给定长度width的新字符串。若width 过短，则返回原串
`ljust(width[, fillchar])`方法：同上，左对齐
`rjust(width[, fillchar])`方法：同上，右对齐
`zfill(width)`方法：返回一个原字符右对齐，前面填充0的新字符串（若带有+、- 前缀，则在符号之后填充）
`replace(str1, str2, num=count)`方法：把串中str1替换为str2，如果指定num，则替换不超过num次
`translate(table)`方法：table是一个长度为256的字符串，用于提供一个字符映射表，该方法就将字符串中的字符按给定的字符映射表进行转换。table 可以使用静态方法str.maketrans() 进行创建，该方法可以有1到3个参数，若只有一个参数，则必须是一个字典（key必须是单字符，value可以是任意字符串，或者None 表示移除）；若有2个参数，则必须是相同长度的字符串；若有第3个参数，则是一个字符串表示要移除的字符。

#### 合并与拆分
`join(str_seq)`方法：参数是一个字符串构成的序列，该方法将序列按序用该字符串连接起来。（比+运算符更高效，因为+需要为每一个参与连接的字符串重新分配内存，以产生新的字符串）
`split(str, num=count)`方法：分割字符串为列表，默认按一个或多个空白字符分割，如果给定一个字符串参数，则按该字符串作为分割元；如果指定num，则仅分割为num个子串
`rsplit(str, num=count)`: 从 最右边 开始
`splitlines(keepends=False)`方法：把字符串按行分割为列表。行边界包括了`\n \r \r\n \v \f 文件分隔符\x1c 组分隔符\x1d 记录分隔符\x1e 行分隔符\u2028 段分隔符\u2029`
`partition(str)`方法：把字符串分成字符串三元组，即str前部分，str（从左侧首次出现），str后部分，如果字符串中找不到str这个字符，则str前部分为原串，后两项为空串
`rpartition(str)`方法：同上，不过从右边查找str（于是，如果找不到，则str后部分为原串，前两项为空）

#### 编码
`decode(encoding='UTF-8', errors='strict')`方法：对字节串按encoding解码为python的unicode串（和unicode(str, encoding)等效）。如果转码失败，除非errors指定为'ignore'或'replace'，否则出错抛出ValueError异常。注意：该方法仅对str串有效，因此，如果unicode串调用该方法，实际上是先str(unicode)转为str串（默认ascii编码）而后进行解码的。
`encode(encoding='utf-8', errors='strict')`方法：以encoding指定方式编码字符串为str字节串。如果转码失败，除非errors指定为'ignore'或'replace'，否则出错抛出ValueError异常。注意：该方法仅对unicode串有效，因此，如果str串调用该方法，实际上是先unicode(str)转为unicode串而后进行编码的。
******
字节串可能有多重编码方式，如UTF-8、UTF-16、ISO8859-1/Latin-1SCII码
UTF-8使用的是变长编码方式，可以完全兼容ASCII码
UTF-16是定长的16位编码（易于读写）（这里的定长是针对基本多文种平面BMP，而其他的平面一般很少使用），由于是多字节表示，故而，需要一个BOM（Byte Order Mark）或者显式定义LE（小端）或BE（大端）
当需要将Unicode字符串写入文件时，就需要指定一个编码方式，这时就需要使用encode函数；反之，需要从文件中读取Unicode字符串时，必须进行解码
若将Unicode字符串和字节串连接，会将字节串转换为Unicode字符串
1. 不要将Unicode字符串传给非Unicode兼容的函数（比如string模块，pickle模块。前者已经有Unicode版本，而后者可以不使用文本格式，而使用二进制格式）
2. 在Web应用中，数据库这边只需确保每张表都用UTF-8编码即可。数据库适配器（如MySQLdb）需要考察其是否支持Unicode，以及需要哪些设置来配置为Unicode字符串。Web开发框架方面（如Django、`mod_python`、cgi、Zope、Plane）同样需要考察哪些配置来支持Unicode。

注意：python代码中的字符串字面值是以文件本身的编码进行保存的，为了让python解析器识别其编码，需要在源码文件中的第一行或第二行进行编码说明（以cp936为例）：
```py
# coding=cp936
# -*- coding: cp936 -*-
# vim: set fileencoding=cp936 :
```
以上三种格式选一即可
那么，当python解析器读入代码文件时，如果是Unicode字符串，就会先将文件中的字节串按指定的编码说明进行decode（如果文件本身编码和声明编码不兼容就可能报错）；如果是字节串，则会直接原样读取，但在和Unicode字符串进行连接等操作进行decode 的时候，就会按文件中指定的编码说明进行decode（此时不兼容会报错）。
因此，在python 代码中写中文，尽量使用Unicode字符串（因为能和大多数软件兼容）
如果在命令行直接使用python，则需要考虑命令行的编码（Windows下为gbk，也即cp936）
******
此外，python，还有一些非字符的编码集(non-character-encoding-codecs)：
比如16进制的编码：
```py
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
```py
#py2
print u'\\u0203'.decode('unicode_escape')
print u'\\u53eb\\u6211'.decode('unicode_escape')
#py3
'中文'.encode('unicode_escape') # 可以查看字符串对应的Unicode 编码
```

******
sys模块有个sys.setdefaultencodeding方法，该方法可以修改解释器对字符的默认编码
但在python的启动过程中，自动执行的site.py脚本会`del sys.setdefaultencodeding`，所以查看sys模块找不到该方法
可以通过`reload(sys)`重获该方法，但在IDLE 环境下，由于sys.stdout/sys.stderr/sys.stdin都是特定的，如果reload之后，这三个变量都会被重置导致IDLE下IO都失灵，因此，需要在reload之前先将这三个变量保存一下，在reload之后用保存的值进行恢复即可（最好使用其他方法解决编码问题，因为reload(sys)会衍生一些问题）

#### string 模块
import string
预制的字符串：
`string.ascii_uppercase`（ASCII大写字母串）string.uppercase（Unicode大写字母串）
`string.ascii_lowercase`（ASCII小写字母串）string.lowercase（Unicode小写字母串）
`string.ascii_letters`（ASCII字母串）string.letters（Unicode字母串）
string.digits（数字串）
string.whitespace（空白符字符串）
方法：
string.upper(str)	返回str的大写字符串
`string.join(str_seq, sep=' ')`	等价于`sep.join(str_seq)`

##### 字符串模板类（比字典格式化更简单的替换方式，不用指定格式化类型）
例如：`s = string.Template('There are ${howmany} ${lang} Quotation Symbols')`
s.substitute(lang='Python', howmany=3)，必须给出全部$变量的替换，否则将跑出KeyError异常
`s.safe_substitute(lang='Python')`，可以不给出全部的$变量，仅作部分替换

#### re 模块
<https://docs.python.org/zh-cn/3/library/re.html>
内置的正则工具，支持Perl 类似的正则
支持Unicode 和 bytes 两种字符串，但不能混用

该模块可以将正则字符串编译为正则对象，便于使用同一个正则表达式进行多次匹配；匹配的结果是一个匹配对象，可以检索结果，或者对字符串进行操作

如果编译正则发现异常，可以通过异常的一下属性查看：
msg：未格式化的错误消息
pattern：正则表达式的模式串
pos：编译失败的 pattern 的位置索引
lineno：对应 pos (可以是 None) 的行号
colno：对应 pos (可以是 None) 的列号

##### 模块函数
+ compile(pattern, flags=re.NOFLAG): 返回一个正则对象。flags 可以使用re.A/I/L/M/S/X（优先级弱于正则表达式中内嵌的模式），以及它们可以使用`|` 进行组合
    re.A: 只对Unicode样式有效，表示内置的字符类只匹配ASCII
    re.I: 忽略大小写匹配
    re.L: 只能对byte样式有效，由当前语言区域决定 \w, \W, \b, \B 和大小写敏感匹配（不推荐使用）
    re.M: 多行模式（改变`^`和`$`的行为）
    re.S: 让`.`特殊字符匹配任何字符，包括换行符
    re.X: 更可读的正则表达式，忽略空白符，所以可以使用多行字符串，支持使用# 的行注释
+ search(pattern, string, flags=0): 不编译直接进行匹配，匹配成功返回匹配对象，失败返回None。它不必从string的开始位置开始匹配，而是找第一个匹配位置
+ match(pattern, string, flags=0): 不编译直接进行匹配，匹配成功返回匹配对象，失败返回None。pattern必须从string的开始位置开始匹配
+ fullmatch(pattern, string, flags=0): 不编译直接进行匹配，匹配成功返回匹配对象，失败返回None。pattern必须完整匹配string
+ findall(pattern, string, flags=0): 返回所有非重叠匹配，若没有分组或只有一个分组则返回字符串列表，若有多个分组则返回字符串元组列表。扫描从左到右按序返回，包含空匹配
+ finditer(pattern, string, flags=0): findall的返回迭代器版本，只不过每次迭代返回的是匹配对象
+ split(pattern, string, maxsplit=0, flags=0): 使用pattern匹配的字段分割string（空匹配如果不相邻也会分割字符串），若在 pattern 中有分组，则分组内容也会依次保留在结果列表中（如果是以分隔符开始或结尾时，则结果列表的开头或结尾就会多出一个空串）。若maxsplit不是0，则最多分割maxsplit 次
+ sub(pattern, repl, string, count=0, flags=0): 将匹配的部分使用repl进行替换，默认全部替换，也可以使用 count 指定次数。
    repl 可以是字符串或函数
    字符串可以使用转义字符和分组引用（需要使用raw 字符串，如果为了避免跟后续字符无法区分，就必须使用`\g<name>`或`\g<n>`来作为分组引用，这种无需raw字符串）；
    函数则接受一个匹配对象参数返回替换后的字符串
+ subn(pattern, repl, string, count=0, flags=0): 跟sub 函数一样，只不过返回(替换后字符串, 替换次数) 二元组
+ escape(pattern): 将pattern 中的特殊字符转义返回，用于需要匹配大量正则特殊字符

##### Pattern 对象
属性
pattern: 正则原始字符串
flags：编译时指定的标记
groups：正则中的分组数量
groupindex：正则中命名分组的名字到序号的映射

方法
+ search(string[, pos[, endpos]]): 比模块还是多了可以指定开始和结束搜索的位置，但`^`依然匹配的是原串的串首或行首，这是跟使用切片的不同
+ match(string[, pos[, endpos]]): Pattern 从 string 的pos 位置开始匹配
+ fullmatch(string[, pos[, endpos]]): Pattern 只匹配 string 的[pos, endpos]的内容
+ findall(string[, pos[, endpos]])
+ finditer(string[, pos[, endpos]])
+ split(string, maxsplit=0)
+ sub(repl, string, count=0)
+ subn(repl, string, count=0)

##### Match 对象
对象的布尔值始终为True

属性
re: 对应的正则对象
string: 被匹配的字符串
pos: 搜索的起始位置
endpos: 搜索的结束位置
lastindex: 最后一个匹配的group 索引（注意：不是group函数的最后一个索引，因为这里是以右括号为判断哪个是最后一个），如果没有捕获的分组，则返回None
lastgroup: 最后一个匹配的分组的名字，如果未命名或没有捕获分组，则返回None

方法
+ expand(template): 使用匹配的分组按照 template 生成字符串（template 中可以使用分组引用（需要raw）或`\g<name>`或`\g<n>`（无需raw）
+ group([group1, ...]): 返回指定分组匹配的字符串（多个返回元组），未指定则返回整体匹配的字符串（也就是0）。负数、超界、未知命名会抛IndexError。若没有捕获返回None；若一个分组被重复匹配，则返回最后一次匹配的内容。Match 对象支持`__getitem__` 所以可以直接用索引获取单一分组。
+ groups(default=None): 返回所有分组匹配的字符串元组，未匹配的分组使用default 作为默认值
+ groupdict(default=None): 返回所有命名分组匹配的字典（key 是分组名，val 是匹配到的字符串）
+ start(group=0)、end(group=0)、span(group=0): 返回指定分组匹配到字符串的开始、结束索引、以及两个索引的二元组。未匹配返回索引为-1，负数、超界、未知命名会抛IndexError。

#### regex 模块
功能更强大的正则库

安装：`pip install regex`
兼容re: `import regex as re`

#### difflib 模块
比较序列对象间的不同

##### 模块函数
+ context_diff(a, b, fromfile='', tofile='', fromfiledate='', tofiledate='', n=3, lineterm='\n'): 比较两个字符串列表，返回一个diff 的generator
  + fromfile, tofile, fromfiledate, tofiledate 都是为了指定表头
  + 上下文行数由n 指定
  + 默认返回的diff 字符串没有换行符，可以通过lineterm 来指定换行符
+ get_close_matches(word, possibilities, n=3, cutoff=0.6): 返回possibilities最佳“近似”匹配word构成的列表（按相似度得分排序，最相似的排在最前面）
  + n 指定最多返回多少个近似匹配
  + cutoff 是一个 [0, 1] 范围内的浮点数。 与 word 相似度得分未达到该值的候选匹配将被忽略。
  + 

##### SequenceMatcher 类
核心类，可用于比较任何类型的序列对，只要序列元素可哈希
基于Ratcliff-Obershelp 算法，默认使用启发式计算来自动将特定序列项视为垃圾（大量重复出现的文本片段），通常是分隔或定界符

##### Differ
用于比较文本序列，基于SequenceMatcher 完成比较和行内的近似匹配
其返回通过行首的两个字符完成该行的特点：
`- `: 序列 1 所独有
`+ `: 序列 2 所独有
`  `: 两序列共有
`? `: 两序列都没有

##### HtmlDiff
可用于创建 HTML 表格（或包含表格的完整 HTML 文件）以并排地逐行显示文本比较

构造
HtmlDiff(tabsize=8, wrapcolumn=None, linejunk=None, charjunk=IS_CHARACTER_JUNK)
+ wrapcolumn 是一个可选关键字参数，指定行文本自动打断并换行的列位置，默认值为 None 表示不自动换行。
+ linejunk 和 charjunk 均是可选关键字参数，会传入 ndiff()

方法
+ make_file(fromlines, tolines, fromdesc='', todesc='', context=False, numlines=5, *, charset='utf-8'): 比较 fromlines 和 tolines (字符串列表) 并返回一个字符串，表示一个完整 HTML 文件，其中包含各行差异的表格，行间与行外的更改将突出显示。
  + fromdesc 和 todesc 均是可选关键字参数，指定来源/目标文件的列标题字符串。
  + 当只要显示上下文差异时就将 context 设为 True（numlines 指定上下文行数），否则默认值 False 为显示完整文件。
+ make_table(fromlines, tolines, fromdesc='', todesc='', context=False, numlines=5): 比较 fromlines 和 tolines (字符串列表) 并返回一个字符串，表示一个包含各行差异的完整 HTML 表格，行间与行外的更改将突出显示。

#### hashlib 模块
多种不同安全哈希算法和信息摘要算法的API，支持增量输入的哈希计算
之前还有md5 模块可以进行MD5信息摘要，python3 移除，统一使用hashlib

##### 常量
algorithms_guaranteed: 各个平台都存在的哈希算法名称（字符串）集合
algorithms_available: new()函数，有效的算法名。algorithms_guaranteed总是其子集

##### 构造器
总是存在的
sha1(), sha224(), sha256(), sha384(), sha512(), sha3_224(), sha3_256(), sha3_384(), sha3_512(), shake_128(), shake_256(), blake2b() 和 blake2s()
通常可用，使用稀有的 "FIPS 兼容" Python 编译版时它可能会缺失或被屏蔽
md5()
通用的
`new(name, [data, ]\*, usedforsecurity=True)`: name 就是有效的算法名，data 是初始化的算法输入数据


#### 其他相关模块
struct      字符串和二进制之间的转换
base64      Base 16/32/64数据编解码
baseascii       ASCII编解码
uu          格式编解码
[codecs](http://docs.python.org/library/codecs.html)      解码器注册和基类
crypt       进行单方面加密
hma         HMAC信息鉴权算法
rotor       提供多平台的加解密服务
sha         NIAT的安全哈希算法SHA
rsa         RSA 数据加密。RSA 算法很慢。通常并不使用 RSA 算法直接加密用户数据，而是用它来加密对称加密系统中使用的共享秘钥，因为对称加密系统速度很快，适合用来加密大量数据。
stringprep  提供用于IP协议的Unicode字符串
textwrap        文本打包和填充
unicodedata Unicode数据库

### 2.2 列表
列表（[a, b, c]）能保存任意数量任意类型的 Python 对象（有序）
PEP8 运行最后一个元素后面带一个逗号

#### 构造函数
list()					[]
list((1, 2, 3))			[1, 2, 3]（浅拷贝构造，即元素使用引用原容器元素），其中可以使用`*it`，来将一个可迭代对象展开到列表中
list("fjal")			['f', 'j', 'a', 'l']（可将其他可迭代对象转换为列表）

##### 数字列表生成器
```
range([start,] stop[, step])
```
start默认为0，stop标定终止数字（结果不含该数字），step是步进值，可正可负，默认为1。它将生成从start开始的，每项递增step，最后一项小于（step为正）或大于（step为负）的列表（Python3 是生成器对象）

#### 方法
append(x)：追加一个元素
extend(iter)：追加一个可迭代对象的所有元素（比+=运算符更高效，因为+=会创建一个新list，而extend是本地操作）
insert(i, x)：在i位置插入元素
pop(i=-1)：删除位置为i的元素并返回之
remove(x)：删除第一个值为x的元素，不存在则抛异常
index(x, start=0, stop=len)：在[start:stop]范围内返回第一个值为x的元素的位置，不存在则抛异常
count(x)：返回,值为x的元素在列表中出现的次数
sort(cmp=None, key=None, reverse=False)：排序，cmp是一个类似cmp(x,y)的比较函数，key是一个一元函数，传入列表的每个元素，返回用于比较的key，reverse为True时，表示反序排序（Python3 移除cmp参数，作为迁移方案，提供了functools.cmp_to_key()可以将cmp函数转换为key函数）
reverse()：反转序列
del alist：销毁列表
del alist[i]：删除列表的第i项（还可以删除一个切片）
`alist[1:3] = []`：切片更新操作（等号右侧必须是一个可迭代对象），将指定切片替换为赋值的列表，例子所示为删除，`[1:1]`相当于在1的位置插入，其他相当于替换（区别`[1:2]`和`[1]`，前者的替换是扩展式的，即右侧的可迭代对象的元素替换切片元素；而后者单索引替换则是使用右侧的对象整体替换索引位置的元素）
*注：并没有拷贝函数，所以浅拷贝可以使用`c = a[:]` 或c = list(a) 或copy.copy 函数*

#### 列表解析
```
[expression for var1 in iterable1 if cond1
			for var2 in iterable2 if cond2
			...
]
```
这里，expression是var1, var2, ...组成的表达式（可以应用函数），其中var1从iterable1中取得，并满足cond1，var2从iterable2中取得，并满足cond2。注意：这里两个循环虽然是并列的，但内部是一个嵌套关系，即var1先取得一个值后遍历var2的所有值。
例如：`[x ** 2 for x in range(8) if not x % 2]`，该列表含有x取值 0~7 的满足条件的x的平方
注：若expression不含某个迭代变量，则相当于在该迭代变量变化中，取得的值都是相同的。

#### 生成器表达式
由于列表解析意味着必须生成整个列表，也就意味着可能需要占用大量的内存，而实际使用的可能仅仅是遍历其元素，而不是真的需要整个列表。于是就有了更节省内存的生成器表达式，即为列表解析中的 [] 替换为 ()（当用作函数参数时可以省略）。
生成器表达式每次仅仅产生（yield）一个元素，非常适合于迭代。只不过，生成器表达式返回的是一个生成器（generator），也是一种迭代器。
生成器只能迭代一次，不能多次使用，也不能使用[]、len() 进行切片和计算长度

#### array 模块
一种受限的可变序列类型array，要求所有元素都必须是同一类型，它需要在构造时，指定它受限的类型：
|代码 | 等价的C类型 | 最小字节数 |
|---|---|---|
|c		|char			    |1|
|u		|unicode char		|2|
|b/B	|byte/unsigned byte	|1|
|h/H	|short/unsigned short|2|
|i/I	|int/unsigned int	|2|
|l/L	|long/unsigned long	|4|
|f		|float				|4|
|d		|double				|8|
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

### 2.3 元组
元组（(a, b, c)，括号在不引起歧义的情形下是可选的）能保存固定数量任意类型的 Python 对象（有序）（注意：只有一个元素的元祖也要保留一个逗号，用以区分括号中的标量）
元组就是一个const语义的list，也就是说它只能保证自己是不可变的，而如果其中有可变对象，如果该可变对象变化，而由于可变对象的id没有变化，并不与元组的不可变性矛盾。

#### 构造函数
tuple()				()
tuple([1, 2, 3])	(1, 2, 3) （浅拷贝构造，即元素使用引用原容器元素），其中可以使用`*it`，来将一个可迭代对象展开到元组中
tuple("fjal")		('f', 'j', 'a', 'l')（可将其他可迭代对象转换为元组）

#### 多元赋值
实际上是隐式的元组赋值
例如：`x, y, z = 1, 2, 'a string'`，也即圆括号是可以被省略的。并且一个变量出现在右侧不会因左侧的变化而受影响，也就是其结果好像是同一计算好了右值构造了一个新的元组对象赋给左侧的各个对象。（这样就可以使用一条语句进行变量值交换）

### 2.4 字典
字典（{ak:av, bk:bv, ck:cv}）保存无序的键值映射（Python3.6+，字典将保留构造和插入的顺序）
几乎所有不可变类型（可哈希类型）都可以作为键，一般常用整数和字符串，值可以是任何类型。各个元素的键的类型都可以不同，同样值的类型也都可以不同

#### 构造函数
dict()						{}
dict(x=1, y=2)				{'x':1, 'y':2}
dict([(ak, av), (bk, bv)])	{ak:av, bk:bv}（二元可迭代对象构造字典，二元不一定是元组）
dict(d)				使用另一个字典构造，比copy方法慢

#### 字典推导
类似于列表解析
```
{ key_expr: value_expr for value in collection if condition }
```
在Python3.6+ 中，生成的字典会保留它们在collection 中的顺序

#### 方法
d[key] = value：有则改值，无则添加key:value（注：当aaa[key]不存在且作为右值时，则将抛出KeyError，不会添加）
setdefault(key, default=None)方法：有key则返回对应值（并不会修改字典），无key则将key:default加入字典，返回default
get(key, default=None)方法：类似[key]，如果存在该key则返回value；如果不存在，get返回default
key in d：判断key是否是字典的一个键
`has_key(key)`方法：判断字典中是否有这个key（推荐使用in 运算符）
keys()、values()、items()：返回所有key、value、(k,v)二元组的列表（Python3 返回的是一个view 对象，可以及时反映出原始dict 对象的变化，该对象可迭代、支持len 和in 操作）
~~iterkeys()/itervalues()/iteritems()方法：同上，只不过返回的是一个迭代子，而不是列表~~（Python3 废弃）
update(dict)方法：将另一个字典dict合并到本词典中，冲突的键，则覆盖之
Python3.5+ 支持`|` 和`|=`运算，`|` 相当于`{**dict_x, **dict_y}`（相当于后者覆盖前者），`|=` 相当于update() 方法（都是右值覆盖左值）
del d[key]：将key对应的键值对从字典中删除，若key不存在则抛出KeyError
pop(key[, default])方法：如果key存在，将key对应的键值对从字典中删除，并返回对应值；否则若key不存在，若给出default，返回default，否则没提供default就抛出KeyError异常
popitem()方法：按print序删除并返回一个元素（作为二元组形式），若字典为空，则抛出KeyError异常
clear()方法：清空字典
copy()方法：返回一个和自己一样的字典（浅拷贝）

dict.fromkeys(iterkey, value=None)函数：返回一个字典，字典的键来自于iterkey（可迭代对象），值都是value

注意：
+ 不支持连接`+`和重复`*`操作
+ 不支持一到多的映射，相同的key，会用后value覆盖前value，即使在一个{}中，靠后的也会覆盖前面的同key项。还要注意的是相同的key不是指id相同，而是指hash相同，于是，即使类型不同，只要哈希相同，就被认定为同key.

#### 继承dict
dict 的子类可以实现`__missing__(key)` 的方法，那么当d[key]不存在且作为右值时，就会调用该方法返回值

### 2.5 集合
一组无序可哈希的对象。
集合有两种：
可变集合set和不可变集合frozenset
其中：
set([1,3,6]) 可以直接使用 `{1,3,6}` 构造（空集合只能用set()），其中可以使用`*it`，来将一个可迭代对象展开到集合中
frozenset只能使用frozenset(iterable) 进行构造

集合判断重复的条件是
1. 首先根据`__hash__`进行预判
2. 若hash 相同，在使用`__eq__`进行等值判断

#### 集合推导
类似于列表解析，只不过把`[]`换成`{}`

#### 集合运算
比较运算符表示集合的包含关系
`&`	表示交运算
`|`	表示合运算
`-`	表示差运算
`^`	表示对称差分
这些运算和集合的类型无关

#### 可变集合方法
`add(obj)`方法：向集合增添一个元素，如果已存在则无效果
`remove(obj)`方法：从集合中删除一个元素，如果不存在，则抛出KeyError
`discard(obj)`方法：从集合中删除一个元素，如果不存在则无效果
`pop()`方法：从集合中删除任意一个元素并返回，如果集合为空，则抛出KeyError
`update(iter)`方法：向集合添加一组元素（做合运算，等价于|=）
`intersection_update(iter)`方法：仅保留共有元素（做交运算，等价于&=）
`difference_update(iter)`方法：剔除包含在iter中的元素（做差运算，等价于-=）
`symmetric_difference_update(iter)`方法：剔除共有元素，加上iter独有元素（做差分运算，等价于^=）
`clear()`方法：清空集合

#### 通用方法
`issubset(iter)`方法：本集合是否是s集合的子集，即<=运算
`issuperset(iter)`方法：本集合是否是s集合的超集，即>=运算
`intersection(iter)`方法：返回本集合和s集合的交集，即&运算
`union(iter)`方法：返回本集合和s集合的合集，即|运算
`difference(iter)`方法：返回本集合和s集合的差集，即-运算
`symmetric_difference(iter)`方法：返回本集合和s集合的XOR集（元素只属于一个集合），即^运算
上述运算返回的结果的类型取决于左操作数，即本集合的类型。方法和操作符的区别，在于方法支持传入一个可迭代对象，而运算符只支持集合间的运算
`copy()`方法：浅拷贝一个自己的副本，比构造函数要快

### 2.6 collections 模块
提供一些高性能容器数据类型和容器的抽象基类（ABC）

容器的抽象基类可以使用isinstance()函数进行实例判断
| ABC | Abstract Methods |
|-----|------------------|
| Container | `__contains__` |
| Sized | `__len__` |
| Iterable | `__iter__` |
|     Iterator | next |
|     Sequence | `__getitem__` |
|         MutableSequence | `__setitem__`, `__delitem__`, insert |
|     Set |  |
|         MutableSet | add, discard |
|     Mapping | `__getitem__` |
|         MutableMapping | `__setitem__`, `__delitem__` |
| Hashable | `__hash__` |
| Callable | `__call__` |

#### namedtuple
生成一个命名元组类，通过该类构造的元组，可以类似访问属性的方式访问成员（而不必用索引），而且其很轻量，不比普通元组占用更多内存。
生成函数：
```python
t = namedtuple(typename, field_names, rename=False, defaults=None, module=None)
```
返回一个名为typename 的tuple的子类，跟class 定义的类一样返回的都是type类型，其`__name__`是typename（相当于namedtuple返回了一个匿名类型，其返回值是一个类型对象）
field_names 可以是一个str序列，或者是一个用空格或逗号分隔的字符串。用以表示各个成员的命名，如果命名不符合规范或重名，且rename 参数为True，则使用`_n`进行命名替换（n 是成员的索引）
defaults 可以是一个默认值iterable，并且右对齐进行默认值分配
module 可以指定返回类型对象的`__module__`属性，缺省则为当前位置的模块

返回的这个类型，可以使用位置参数，也可以使用关键字参数进行构造；同时既可以当作tuple 操作，也可以当作一个对象操作（支持`.`和getattr函数）。
此外还有一些新增的属性和方法：  
`_fields`: 字符串元组  
`_field_defaults`: 字段名->默认值 的字典
`_make(iterable)`: 类方法，使用一个可迭代对象生成一个对象
`_asdict()`: 对象方法，返回一个OrderedDict 对象
`_replace(**kwargs)`: 对象方法，修改部分成员，并返回一个新的对象

使用namedtuple 可以很容易定义枚举常量

#### deque
双端队列类，支持常数时间，线程安全的双端操作
```
deque([iterable[, maxlen]])
```
使用可迭代对象从左而右地构造，如果maxlen 被指定且不是None，那么双端队列就被限定最大长度，当充满时，在一端插入会在另一端丢弃相应成员。
支持属性和方法：  
maxlen：只读属性，如果未制定为None  
append(x)：右端插入  
appendleft(x)：左端插入  
extend(iterable)：右端插入多个  
extendleft(iterable)：左端插入多个  
pop()：右端弹出  
popleft()：左端弹出  
remove(value)：删除第一个值为x的元素，不存在则抛异常  
count(x)：返回,值为x的元素在队列中出现的次数  
reverse()：原地反转  
clear()：清空队列  
rotate(n)：如果n为正，则队列循环右移n 个位置；n为负则向左

支持容器通用操作，可迭代，可pickle，支持reversed，可使用copy模块进行拷贝  
支持索引，但不支持切片（访问中间位置的元素具有线性复杂度，因此不适合随机访问）

#### defaultdict
带默认值生成器的字典（dict的子类）
```py
defaultdict(default_factory=None[, ...])
```
default_factory默认值的行为和dict 一样，可以指定一个无参的函数对象，当字典索引key失败时，调用该函数获取一个默认值插入字典并返回。
剩余参数将传给dict，进行构造  
该类的实例有一个同名属性default_factory，可以动态修改这个生成器  
**注意：仅当索引key失败会触发生成器，如果使用get()等方法，则不会而保持其默认行为**
这是由于它实现了dict 的`__missing__(key)` 方法，并使用default_factory 获取默认值，然后调用setdefault 返回

#### OrderedDict
有序字典（按插入顺序）（dict的子类）  
**注意：对于使用关键字参数的构造器和update方法，其顺序将丢失，因为python使用dict 进行参数传递**  
更新值并不影响顺序  
和OrderedDict 进行等值比较顺序敏感，和其他Mapping 对象比较则顺序不敏感  
额外支持的方法：  
popitem(last=True)：默认弹出最后插入的kv二元组，last为False，则弹出最早插入的kv二元组  
move_to_end(key, last=True)：将指定的key 放到尾部（默认）或头部（last=False）
还支持reversed()函数进行逆序
Python3.9 支持`|`和`|=` 进行合并操作

#### Counter
计数器类（dict的子类）
```
Counter([iterable-or-mapping])
```
可以从Mapping 对象构造，也可以给一个可迭代对象进行统计构造  
支持0 和负值  
该对象不强制要求key/val的类型，只要它们能满足操作条件即可  
在使用索引key 访问计数时，如果key 不存在则返回0

额外的方法：  
elements()：返回一个迭代器，对每个key 迭代对应计数次（顺序随机），计数不大于0则忽略  
most_common([n])：返回一个(key, count)二元组的列表，如果指定n且不为None，则返回count最大的n个，对于count相同的值则随机排序  
subtract([iterable-or-mapping])：减去另一个计数，并更新自身

有2个字典方法行为变化：  
fromkeys(iterable)：未实现  
update([iterable-or-mapping])：加上另一个计数，并更新自身

该对象该支持一些运算符：  
c1 + c2：将每个计数对应相加  
c1 - c2：将每个计数对应相减  
c1 & c2：取每个计数的最小值  
c1 | c2：取每个计数的最大值  
**注意：返回结果会丢弃那些不大于0 的计数值**

#### ChainMap（Python3.3+）
多层映射结构，MutableMapping 的list，当查找时进行深度搜索，修改和删除仅仅操作第一层映射
整体操作上，依然可以当做一个dict

ChainMap(*maps): 可以使用0个或多个进行构造（0个将初始化一个空字典）

##### 属性
maps: 内部的映射列表，第一个就是第一层，该属性可写，也会会直接反应对应映射的更新
parents: 等价于 ChainMap(*d.maps[1:])

##### 方法
new_child(m=None, **kwargs): m 默认相当于{}，然后m.update(kwargs)，该函数相当于返回ChainMap(m, *d.maps)

#### UserDict/UserList/UserString
这三个类用于子类化dict、list、str（其中UserList 子类必须重写一个接受0个或1个参数的构造器，这个参数是一个序列）
都有一个data 属性，保留其常规类型的值（保留的是copy 而不是引用）

之所以子类化这三个类，而不是dict、list、str，因为：
```py
class MyDict(dict):
    def __setitem__(self, __k, __v):
        return super().__setitem__(__k, [__v] * 2)

class MyUserDict(UserDict):
    def __setitem__(self, key, item) -> None:
        return super().__setitem__(key, [item] * 2)

d = MyDict(one=1)   # {'one': 1}
d['two'] = 2        # {'one': 1, 'two': [2, 2]}
d.update(three=3)   # {'one': 1, 'two': [2, 2], 'three': 3}

d = MyUserDict(one=1)   # {'one': [1, 1]}
d['two'] = 2            # {'one': [1, 1], 'two': [2, 2]}
d.update(three=3)       # {'one': [1, 1], 'two': [2, 2], 'three': [3, 3]}
```
可以看到dict 的子类，构造和update 都不会调用`__setitem__`，语义并不一致；而UserDict 语义是一致的

### 2.7 heapq 模块
堆队列，该实现是一个最小堆，即`heap[k] <= heap[2*k+1] and heap[k] <= heap[2*k+2]`，故最小的元素是 heap[0]

#### 模块函数
heapify(x)：把一个list 转换成一个最小堆（原地，线性时间）
heappush(heap, item)：给堆加入一个元素，并保持堆的特性
heappop(heap)：弹出heap[0]，并保持堆的特性  
heappushpop(heap, item)：先push，后pop（更有效率）
heapreplace(heap, item)：先pop，后push

`merge(*iterables)`：把多个有序的输入合并为一个有序输出，返回一个迭代器（省内存）  
nlargest(n, iterable[, key])：返回迭代器中n 个最大的数组成的列表，key 可以提供一个获取比较key 的函数  
nsmallest(n, iterable[, key])：返回迭代器中n 个最小的数组成的列表，key 可以提供一个获取比较key 的函数  
*注：nlargest 和nsmallest 仅当n 较小时比较有效，如果较大，使用sorted() 更有效，如果n == 1，则使用min 和max 更有效*

## 3. 其他内建类型
类型对象，type 是所有类型的类型，也是所有类型的元类
object 是所有对象的基类
None（等价于 NULL）单例

函数function/方法instancemethod：本质上都是可调用对象，差别在于是否绑定参数
类 classobj：python2 中的经典类的类型，Python3 已移除
模块对象
文件file对象

### 代码
代码对象是编译过的Python源代码片段，是可执行对象。通过调用内建函数compile()可以得到代码对象。代码对象可被exec命令或eval()内建函数执行。对象本身不含任何执行环境信息，在被执行时动态获得上下文。事实上，代码对象是函数的一个属性（函数还有其他属性，如函数名、文档字符串等）

### 帧（frame）
帧对象表示Python的执行栈帧。包含了所有Python解释器所需的执行环境信息。每次函数调用就会产生一个新的帧。

### 跟踪记录（traceback）
当异常发生时，一个含有该异常的堆栈跟踪信息的跟踪记录对象被创建。如果一个异常有其处理程序，处理程序就可以访问这个对象。

### 切片（slice）
可以使用内建函数`slice([start,] stop, [step])` 来创建一个切片对象，切片对象可以直接用在序列的索引上

### XRange
当调用内建函数xrange()时，将生成一个XRange对象，该函数用于需要节省内存时或range()函数无法完成的超大数据集的场合，它只被用在for循环中，性能远高于range()。


# 第四章. 运算符、表达式、语句
## 1 运算符和表达式
operator 模块，其中包含了所有运算符的函数形式
truth, `not_`（对对象进行真值判断和否定判断）
concat(+), contains(in), indexOf, countOf, getitem(索引/切片取值), setitem(索引/切片赋值), delitem(索引/切片删除)

模块函数
`attrgetter(*attrs)`: 返回一个函数对象，该函数接受一个对象，然后访问其多个属性，返回一个元组
`itemgetter(*items)`: 返回一个函数对象, 该函数接受一个对象，然后访问其多个索引，返回一个元组
`methodcaller(name, *args, **kwargs)`: 返回一个函数对象，该函数接受一个对象，然后调用其name 字符串指定的方法，参数通过后续参数指定

### 1.1 赋值与销毁
Python的变量都是引用，因此，对于一个频繁使用的其他模块、类变量，可以用一个本地的局部变量去接收该引用，既能简化写法，又能提高访问效率。
在赋值时，不管这个对象是新创建的，还是一个已经存在的，都是将该对象的引用（并不是值）赋值给变量。并且Python 的赋值语句不会返回值，这是因为Python支持链式赋值，例如
```
y = x = x+1
```
表示创建一个对象保存x+1的结果，并将这个对象的引用分别赋给x和y。
但这个只是一个语言特性，并不代表赋值语句有返回值，Python 3.8+ 的海象表达式有返回值

销毁对象的引用：del x, y, ...

#### 增量赋值
支持增量赋值（例如`*=`），但不支持自增自减（连用的+/-表示两个单目的+/-），它和一般格式的赋值不同的是，对于可变对象，这种赋值是直接修改对象（原地运算），而对于不可变对象则是运算后重新申请一个对象，再赋引用给这个变量
原地运算，在operator 中是对应的运算符函数前加上i，仅对可变类型有效

#### 多元赋值
使用基于元组的多元赋值：
```py
(go_surf, get_a_tan_while, boat_size, toll_money) = (1,'windsurfing', 40.0, -2.00)
```
左右的括号都可以省略
右侧的值是在全部都计算完毕之后，才赋给左边的；由于是基于元祖的多元赋值，因此，必须保证左右两边的个数相同
左侧可以使用一个`*s` 的拆包形式进行接收多个值，此时，左侧可以少于右侧个数
```py
*prev, next_to_last, last = iter_train(args)    # 取最后两个保存
prev, next_to_last, *last = iter_train(args)    # 取前两个保存
```

#### 海象运算符 := 
一般的赋值语句不会返回值，所以不能用在任何需要值的位置，比如if/while 判断，lambda 表达式中。
Python 3.8 支持的海象表达式可以返回被赋值的变量，可以作为其他语法结构中
注意：海象表达式不能是多元赋值，并且由于优先级较低，一般放在括号中
```py
my_list = [1,2,3]
if (count := len(my_list)) > 3:
    print(f"Error, {count} is too many items")

while (p := input("Enter the password: ")) != "the password":
    print(p)

# 可以只调用longFunction 一次
[result for n in scores if result := longFunction(n)]
```

### 1.2 算术运算符
`+`：对应operator.pos 和operator.add
`-`：对应operator.neg 和operator.sub
`*`：对应operator.mul
`/`：类型相关的除法，整数执行地板除，浮点数执行真除法（Python3 不区分类型均为真除法，即返回类型是float，对应operator.truediv）
`//`：地板除，即⌊x/y⌋，float也可以执行，对应operator.floordiv
`%`：取余，计算公式：x%y=x-⌊x/y⌋×y，对应operator.mod
`**`：幂，乘方，对应operator.pow
`@`：矩阵乘，对应operator.matmul

从上可以发现：`a == (a//b)*b + a%b`
这个等式无论正数还是负数，或是浮点数、复数都是成立的（注：复数的地板除，是对实部下取整，虚部为0）

#### 幂运算与单目运算符
幂运算比其左侧的单目运算符优先级高，比其右侧的单目运算符优先级低，单目运算符又高于其他双目运算符。
即`-10**-2` 表示的是`-(10**(-2))`

#### 内置的算术函数
abs(x)，取绝对值或复数的模，对应operator.abs
divmod(x, y)，取得由`x//y`和`x%y`组成的二元组
pow(x, y[, z])，两个参数同`x**y`，三个参数同`x**y % z`，但效率更高，用于密码计算
round(num, ndigit=0)：对num四舍五入到小数点后ndigit位（可以为负数），返回之（float类型）（对于负数，先对正数四舍五入，再取负）。（注意：虽然名义上是四舍五入，但由于float的精度问题，当舍入位为5且后无尾数时，并不能保证一定就进位，比如round(0.15,1)得到0.1，而round(0.05+0.1,1)得到0.2。
int(x)，截断x的小数部分（正数下取整，负数上取整）

#### math 模块
math.pi
math.inf，float('inf')
math.nan，float('nan')
math.e，自然指数
math.floor(x)，将x下取整
math.ceil(x)，将x上取整
math.factorial(x)，x!

### 1.3 比较运算符（返回True或False的布尔值）
<       <=      >       >=      ==      !=      <>（同前者，不推荐）
operator 对应的 lt(<), le(<=), eq(==), ne(!=), ge(>=), gt(>)
特别的，像`3 < 4 < 5`这种语句也是合法的（连用比较运算符相当于隐式使用and运算）

#### 对象比较的逻辑
1. 同类型比较
    + 数字类型的比较，自动进行转换而后比较（注：complex无法参与任何比较）
    + 字符串比较，逐字符按字典序比较，若不同则直接返回结果，否则继续，若一个先比较完所有字符，则其较小。
    + 列表和元组的比较，逐元素进行比较，若不同则直接返回结果，否则继续，若一个先比较完所有元素，则其较小。
    + 字典的比较，首先比较len，长者较大；相同长度，则按keys()顺序比较各个键，若不同则返回结果；否则再比较各个键对应的值，若不同则返回结果，否则则相同。
    + Instance，classobj之间比较？？？（实例和类型均按名的字符串比较）
1. 混合类型比较（Python3 将不再支持这种混合类型比较）
instance  <  数字型  <  classobj  <  dict  <  function  <  list  <  str  <  tuple

#### 内置的比较函数
cmp(obj1, obj2)
    If obj1 < obj2: return 负整数
    If obj1 > obj2: return 正整数
    If obj1 == obj2: return 0
如果比较用户自定义对象，则会调用类的`__cmp__()`方法

### 1.4 is (not) （返回True或False的布尔值）
用is或is not判断两个变量是否指向同一对象，相当于id(a) == id(b)或id(a) != id(b)
在operator 中对应`is_`, `is_not` 函数

### 1.5 逻辑运算符与条件表达式
and     or      not
优先级低于比较运算符

支持短路计算：
x and y：判断x为False，则返回x；x为True，则返回y
x or y：判断x为True，则返回x；x为False，则返回y
于是，可以从此模拟出三目表达式：(cond and [x] or [y])[0]，这里之所以使用列表，是为了保证x恒为True值；
但事实上，正规的写法应该是x if cond else y

### 1.6 位运算（仅用于整数）
~    &    |    ^    <<    >>
operator 对应的inv(~), lshift(<<), rshift(>>), `and_(&)`, `or_(|)`, xor(^)
其中 << 左移运算，对int左移溢出后，会自动转变为long，而不会变为异号或为0

设value为一个值，bit为指定位为1的值：
打开位：value |= bit
关闭位：value &= bit
切换位：value ^= bit
测试位：if value & bit:

## 2 语句
### 2.1 条件语句
```py
if expression1:
    代码块1
elif expression2:       # 可选任意多个：当expression1为False时进行测试
    代码块2
else:                   # 可选：当expression? 均为False时执行
    代码块3
```
如果expression的值非0或为True，则执行对应的代码块。

### 结构化模式匹配
```py
match subject:
    case <pattern_1>:
        代码块1
    case <pattern_2>:
        代码块2
    case <pattern_3>:
        代码块3
    case _:
        默认代码块
```
其中subject 可以是任意结构的对象，每个case 都是可选的
pattern 有以下三种模式，并且可以进行嵌套组合

#### 字面值匹配
```py
def http_error(status):
    match status:
        case 400:
            return "Bad request"
        case 401 | 403 | 404:           # 多种命中其一，可以用as var 捕获具体命中的值
            return "Not found"
        case 418:
            return "I'm a teapot"
        case _:
            return "Something's wrong with the internet"
```

#### 解包匹配
将严格匹配的进行前置
可以使用`()` 或`[]` 匹配序列（包括list、tuple、range，但不包括字符串、迭代器）
```py
match point:
    case (0, 0):                # if point[0] == 0 and point[1] == 0:
        print("Origin")
    case (0, y):                # if point[0] == 0: y = point[1]
        print(f"Y={y}")
    case (x, 0):
        print(f"X={x}")
    case (x, y):                # x, y = point
        print(f"X={x}, Y={y}")
    case (x, y, _):             # 3 元组，忽略第三个元组
        print(f'X={x}, Y={y} triple')
    case (x, y, *rest):         # 匹配list，若不在意剩余的，可以使用 *_
        print(f'X={x}, Y={y}, rest={rest} in sequence')
    case {"x": x, "y": y, **rest}:      # 匹配dict，由于是部分匹配，所以不需要 **_
        print(f'X={x}, Y={y}, rest={rest} in dict')
    case _:
        raise ValueError("Not a point")
```

#### 类型匹配
```py
class Point:
    __match_args__ = ('x', 'y')     # 为了case 能捕获位置参数

    x: int
    y: int

def location(point):
    match point:
        case Point(0, 0):       # 参考Point.__match_args__ 捕获位置参数，即相当于x=0, y=0
            print("Origin is the point's location.")
        case Point(x=0, y=y):
            print(f"Y={y} and the point is on the y-axis.")
        case Point(x=t, y=0):
            print(f"X={t} and the point is on the x-axis.")
        case Point():
            print("The point is located somewhere else on the plane.")
        case str(s)             # if isinstance(point, str): s = point
            print(f"point str is {s!r}")
        case _:
            raise ValueError("Not a point")
```

#### 约束项
在模式之后可以加 if 条件，即给该case 附加条件，若不满足则跳过
```py
match point:
    case Point(x, y) if x == y:
        print(f"The point is located on the diagonal Y=X at {x}.")
    case Point(x, y) as p:
        print(f"Point is not on the diagonal.")
```

### 2.2 循环语句
```py
while expression:
    代码块
else:                # 可选：当expression为False时执行，当break跳出则不执行
    代码块

for 迭代元 in 可迭代对象:
    代码块
else:             # 可选：迭代结束后执行，当break跳出则不执行
    代码块
```
可迭代对象包括：字符串（字符），列表和元组（元素），字典（key），文件对象（行）等

+ 为了产生计数循环，可以使用range函数或xrange函数作为序列发生器。
+ 对于一个字符串或序列，如果想要同时迭代它的位序和值，可以使用enumerate函数生成一个新的迭代器（详见下）：`for i, ch in enumerate(foo):`

#### for 实现机制 与 迭代器
for循环的机制：
1. 调用可迭代对象的`__iter__()`方法获得迭代器（通过iter()这个内建方法）
1. 每次循环迭代调用迭代器的`__next__()`方法获得遍历的下一个数据（通过next()这个内建方法）
1. 当捕获到StopIteration异常，循环结束（当全部数据取完后会抛出一个StopIteration异常，以告知迭代完成）

+ 可迭代对象是一个有`__iter__()`方法的对象，该方法返回这个可迭代对象的迭代器。
+ 迭代器是一个有`__next__()`方法的对象（当然，通常迭代器本身也是可迭代对象，所以可以在`__iter__()`方法中返回自身）。

*注：迭代器只能单向遍历（不能回溯），而且不能复制，只能重新创建。*

序列、字典、集合、文件对象、迭代器、生成器都是可迭代对象
只不过序列和集合迭代的是成员；字典迭代的是key，因为可以通过key找到value；文件对象迭代的是行。

> iter函数
iter(obj)，obj是可迭代对象，返回该可迭代对象的迭代器（会调用对象的__iter__ 方法）
iter(func, sentinel)，返回一个迭代器，它在迭代过程中不断调用这个函数返回，直到函数返回sentinel就抛出StopIteration异常

> next函数
next(iterator[, default])
调用iterator的`__next__()`方法返回下一个元素，如果给定default 参数，则不抛StopIteration异常，改为返回default。

#### 与迭代有关的函数
**注意：以下返回的迭代器，支持惰性计算，但不支持[]索引、len()计算长度、bool()判断空，并且只能迭代一次，无法重复使用**
+ reversed(seq)：返回该序列seq的逆序*迭代器*
+ sorted(iter, cmp=None, key=None, reverse=False)：返回一个有序的列表，其他的可选参数同列表的sort方法（Python3 移除了cmp 参数）
+ enumerate(iterable[, start])：iterable为一个可迭代对象，start设置迭代的起始位置，返回一个*迭代器*，该对象每次next会生成一个由(位序, 值)构成的二元组。
+ filter类
    - filter(func, iter)：func是一个判断函数对象，返回func判断为True的元素的*迭代器*，即每次从iter中取出一个元素，作为func的参数进行判断，若为True则加入结果中，返回的具体类型和iter的类型一致。如果func为None，则func相当于bool()，即判断元素本身的布尔值。
+ map类
    - zip(iter1, iter2, …)：返回一个元组的*迭代器*，其中第一个元组由这些序列的第一个元素依次组成，第二个元组由这些序列的第二个元素依次组成，直到其中一个序列取完为止。即返回的列表长度和这些序列中最短的一个相同。
    - map(func, iter1[, iter2, …])：func是一个函数对象，返回func结果的*迭代器*，即每次从各个序列中取出一个元素作为func的参数（具体是先组成一个元组，再使用`*tuple`传参），返回结果依次作为结果列表的一个元素，如果某些序列提前耗尽，则后续均为None。如果func指定为None，则func的行为就是直接返回组成的这个元组（行为类似zip，但zip返回的列表长度取决于序列中最短的一个，而map返回的序列长度则取决于序列中最长的一个）
+ reduce类
    - any(iter)：如果可迭代对象iter至少存在一个bool(x)为True的元素x，则返回True，否则返回False
    - all(iter)：如果可迭代对象iter为空，或所有元素x的bool(x)都为True，则返回True，否则返回False
    - sum(iter, init=0)：返回数值序列和init的总和（效果同reduce(operator.add, seq, init)）
    - max(iter, key=None)，min(iter, key=None)：key是一个函数返回一个用于比较的值，按该函数返回的值选出迭代对象中的最大和最小值。（此外，这两个函数还有一个可变参数版本：max(arg1, arg2, …, key=None)，min(arg1, arg2, …, key=None)
    - reduce(func, iter[, init])：func是一个需要两个参数的函数对象，每次从iter中取出一个元素和上次func的结果作为本次func的参数，如果提供了init参数，则初始init作为上次func的结果，如果未提供init参数，则首次取iter的两个元素作为func的参数。这里func不能是None。

##### 相关模块
itertools
1. 无限迭代器
	+ count(start=0, step=1)：无限版range: `start, start+step, start+2*step, start+3*stemp, ...`
	+ cycle(iterable)：无限循环迭代生成器
	+ repeat(e, times=None): e * times 无限版
1. 终止于最短的输入序列的迭代器
	+ `chain(*iterables)` 和`chain.from_iterable(iterable)`: 二阶flat
	+ groupby(iterable, key=None): 需要先把key 聚集（比如sorted）再调用本函数才有意义，即，它将已经聚集在一起的key 合并为一条记录(key, 聚集生成器) 的二元组
	+ pairwise(iterable): 返回新的迭代器`[(a0, a1), (a1, a2), (a2, a3), ...]`
	+ map 升级
		- `zip_longest(*iterables, fillvalue=None)`：和zip 相同，只不过返回的列表长度和这些序列中最长的一个相同，不足的用fillvalue 补充
		- starmap(function, iterable)：返回一个迭代对象, 每次迭代返回用iterable 的每个元素作为参数解包后调用func的返回值
		- `accumulate(iterable, func=operator.add, *, initial=None)`: p=func(initial, a0), func(p, a1), func(p, a2), ...
	+ filter 升级
		- filterfalse(predicate, iterable): filter 的False 版
		- takewhile(predicate, iterable): 保留满足predicate 的前导序列，返回一个生成器
		- dropwhile(predicate, iterable): 去掉满足predicate 的前导序列，返回一个生成器
		- islice(iterable, stop) 和islice(iterable, start, stop, step=1)：相当于用range 产出（不支持负索引）的下标遍历iterable，返回一个生成器，可以使用它对生成器进行切片
		- compress(data, selectors): (d for d, s in zip(data, selectors) if s)
	+ tee(iterable, n=2): 返回一个n 元组，每个元素都是一个iterable 构成的生成器（非线程安全）（一旦使用该函数，原来的iterable 就不要使用了，因为它的动作都不会通知给tee 返回的生成器）
1. 排列组合
	+ `product(*iterables, repeat=1)`: iterables * repeat 后，每个iterable 取一个元组进行笛卡尔积（类似多层嵌套循环）返回一个生成器，每个元素时一个元组（每次迭代，最右侧元素最先步进）
	+ permutations(iterable, r=None): 从iterable 取出r 个元素进行全排列
	+ combinations(iterable, r): 从iterable 取出r 个元素进行组合
	+ combinations_with_replacement(iterable, r): 从iterable 取出r 个（可重复）元素进行组合
支持无限迭代的输入

#### 2.3 continue、break、pass
continue语句：跳过循环中剩下语句，进行下次迭代（进行条件检查或调用next()）
break语句：跳出循环
pass语句：空语句的占位符

# 第五章. 函数
## 1. 函数定义
```
def func_name([args]):
    'optional documention string'
    函数代码块
```
注意：
不支持函数重载，但可以通过type()确定参数类型来实现
支持调用在前，定义在后
函数调用时，小括号不可省略
支持递归（[尾递归消除](https://github.com/hunterwilhelm/functional-recursion)）
关键字参数：通过形参名来指定参数，可以不按顺序

### 1.1 参数
参数是引用传递，所以对于可变对象，函数内的改变影响原始对象，而不可变对象则不影响
#### 1.1.1 默认参数
参数可以用赋值符给以默认参数，必须在所有非默认参数之后
**注意：默认值只使用不可变对象: 函数的默认值是在函数定义时确认，并将该值存储起来，当默认值启用时，就使用该存储起来的值，类似于类的静态变量；而如果该默认值是一个可变对象，那么如果函数中对这个使用默认值的参数进行的修改就会影响到这个存储起来的值，从而对下次使用默认值的函数调用造成影响**
例如：
```py
def foo(a=[]):
    a.append('aa')
    return a

print foo() # 多次调用的结果不同
```
虽然和直觉相违，但也可以利用该特性做一些事情，比如记录一个函数距上次调用经过的时间：
```py
import time
def dur( op=None, clock=[time.time()] ):
    if op != None:
        duration = time.time() - clock[0]
        print '%s finished. Duration %.6f seconds.' % (op, duration)
    clock[0] = time.time()
```
即利用列表默认值，实现了函数静态变量的特性


#### 1.1.2 可变参数
位序可变参数必须在关键字可变参数之前（位序可变参数后面可以放置其他参数，但只能使用关键字形式赋值，关键字可变参数后则不可以有其他参数），例如：
```py
func(*tuple_args, **dict_args)
```
额外的位序参数将封装为元组`tuple_args`, 额外的关键字参数封装为字典`dict_args`
说明：`*`运算符可以把序列拆解为多个参数，`**`运算符可以把字典拆解为多个关键字参数
在进行函数调用和返回值拆包时，则不限于最后一个，比如`do_something(**first_args, **second_args)`，不过需要确保展开后没有关键字冲突，也不和现有位序参数冲突

#### 1.1.3 强制位序参数和关键词参数
用/ 占位，则它前面的参数必须使用位序参数，不能使用关键字形式
用* 占位，则后面的参数必须使用关键字形式显式指定
```py
def func(a, b, /, c, d, *, e, f):
    # a b 必须使用位序参数，e f 必须使用关键字参数，中间的两种都可以
```

### 1.2 返回值
动态返回类型：能返回不同类型
如果函数无return语句，则将返回None对象
#### 1.2.1 多值返回
实际返回的是元组，只不过语法上可以不需要括号（同样，在接受多值返回时，也可以不需要括号）

## 2. 函数对象
函数定义就声明了一个函数对象，函数名就是这个函数对象的引用，可以赋给其他变量或作为参数传递，也可以del 掉

支持函数嵌套定义，因为函数是对象，内部定义的函数相当于一个在外部函数的作用域内函数对象实例
函数嵌套定义的作用是内部函数可以访问外部函数作用域内的变量，从而形成闭包

### 2.1 属性
`func_name`：函数名（可写），Python3 是`__name__`
`func_doc`：函数的文档注释（可写），Python3 是`__doc__`
`func_module`: 函数所在的模块（可写），Python3 是`__module__`
`func_defaults`：函数的默认值元组（可写），若没有默认值则返回None，Python3 是`__defaults__`
`func_kwdefaults`: 函数的关键字参数默认值字典，Python3 是`__kwdefaults__`
`func_globals`: 函数持有的全局变量的字典（只读），Python3 是`__globals__`
`func_closure`：函数持有自由变量的元组（只读）元组的每个元素是cell类型，存储一个自由变量；如果没有自由变量，则为None，Python3 是`__closure__`
`func_code`：函数的code 对象（可写），Python3 是`__code__`

### 2.2 闭包
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

## 3. 装饰器
装饰器是一种函数（也可以是类似于函数的可调用对象，比如一个类实现`__call__` 方法）
+ 无参装饰器，其参数是被装饰的函数(对象)，返回被装饰后的函数(对象)；
+ 有参装饰器，其参数是装饰器参数，返回一个无参数的装饰器

通过装饰器，可以实现AOP编程

装饰器可以叠加，即：
```
@deco1(deco_arg)
@deco2
def func():
    pass
# 相当于
func = deco1(deco_arg)(deco2(func))
```
装饰器通常使用闭包实现，即在装饰器函数内定义一个函数，作为替换函数，该函数会调用被装饰函数，从而完成装饰，最后装饰器返回该替换函数。
装饰器也可以使用类来实现，相当于`__init__` 是外层的装饰函数，`__call__` 是内层的替换函数
由于装饰器返回的了装饰后的函数对象，所以装饰后，原函数的函数属性将被覆盖，如果想要原函数的函数属性（函数名、docstring、参数列表），可以使用`functools.wraps` 装饰器，该装饰器是个有参装饰器，参数是被装饰的函数对象，如：
```py
from functools import wraps
def deco2(func):
	@wraps(func)
	def wrapped_function(*args, **kwargs):
		print func.__name__
		retrun func(*args, **kwargs)
	return wrapped_function
```
wraps 实际上是调用了update_wrapper(new, old, assigned = WRAPPER_ASSIGNMENTS, updated = WRAPPER_UPDATES) 方法，WRAPPER_ASSIGNMENTS 是`('__module__', '__name__', '__qualname__', '__doc__', '__annotations__')` 这个元组，WRAPPER_UPDATES 是`('__dict__',)` 这个元组，也就是默认会把这些属性从old 覆写到new 上

装饰器除了可以用在函数装饰之外，还可以用在类上。
那么外层的装饰器函数的参数是这个类对象，内层替换函数替换的是这个类的`__init__` 调用。
例如：用装饰器实现一个单例
```py
def singleton(cls):
    _ins = None
    def inner(*args, **kwargs):
        nonlocal _ins
        if _ins is None:
            _ins = cls(*args, **kwargs)
        return _ins
    return inner
```

### cache
functools.cache 装饰器可以让函数针对不同的参数进行结果缓存，可以理解成一个字典（因此参数的必须都是可哈希的）
*注意：对于def func(a=1)，func()和func(1)会缓存两次*

functools.cached_property 装饰器用于实例方法，和property 装饰器不同的是，property 装饰的属性是只读的（需要另外2个装饰器才能可写可删），而cached_property 则直接是可读写的，写入的值优先于缓存的值，可以通过del 删除属性值，使其重新缓存
其原理是cached_property 将实例方法名（也就是一个类属性）做成了一个描述符，该描述符会将方法的返回值存到实例`__dict__`的方法名中，则此后再访问这个属性，就是直接获取到这个缓存值（写入也会直接写入到这个缓存值中，所以无需`__set__`方法，del 则是恰好将这个这个属性从实例的`__dict__`中删除，从而可以重新缓存，所以也无需`__delete__`方法），而描述器仍保存在类的`__dict__`中，那么当用类直接访问这个属性，是可以获取到这个描述符对象。

functools.lru_cache(maxsize=128, typed=False) 装饰器比cache 多提供了容量上限的设置，当达到上限时使用LRU 算法进行替换
被包装的函数有以下方法：
+ cache_parameters()：获取装饰器配置参数
+ cache_info()：显示 hits, misses, maxsize 和 currsize的named tuple
+ cache_clear()：清空缓存
+ `__wrapped__` 属性：获取包装前的原始函数

#### 其他三方cache
同时兼容 Python2 和 Python3 的第三方模块 fastcache 能够实现同样的功能，且其能支持 TTL

<https://github.com/dgilland/cacheout>
<https://github.com/tkem/cachetools/>
<https://github.com/pallets-eco/cachelib>

## 4. 匿名函数lambda
```
lambda [arg_list]: expression
```
`arg_list`可省，可以有默认参数和可变参数
expression的结果就是返回值
结果是一个函数对象
**注意：expression 只能是单条表达式语句，而且该语句不能是赋值语句和print 语句，因为它们没有返回值**

## 5. 偏函数
即其他语言中的参数绑定
对函数使用functools.partial()函数，对实例方法使用functools.partialmethod()函数
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

## 6. 生成器
从句法上，生成器函数是一个带yield 语句的函数，该函数返回一个生成器。
生成器可以看做迭代器的一个简易的实现（使用的是函数，而不是类），但更重要的是生成器可以实现协程。

### 6.1 生成器的执行
从生成器函数调用者角度，调用生成器函数可以获得一个生成器（不会执行生成器函数的代码），生成器也是一个可迭代对象，可以调用生成器的next() 函数，以获得生成器函数下一次通过yield 返回的值，如果没有yield 语句或者遇到return 的话就抛出StopIteration 异常（return 的值就是这个异常的value）。
从生成器角度，从第一次调用next() 函数（刚获取的生成器必须使用next 而不能使用send），开始执行生成器函数代码，直到遇到yield 语句，该语句会挂起生成器的执行，保存函数状态，直到调用者再次调用next() 或send() 重新激活生成器，才恢复执行。

### 6.2 和生成器进行交互
生成器的调用者，可以通过生成器对象的方法和其交互：
+ send(v) 跟执行next() 函数类似，都返回生成器下一次yield 的值；不同的是send 的这个参数，会通过yield 语句的返回值传给生成器（若使用next() 函数，相当于send(None)，即yield 语句的返回值为None）
+ close() 要求生成器退出，将在yield 位置抛出GeneratorExit 异常，该异常不会抛到生成器之外，因此若捕获到该异常可以raise 重新抛出，也可以自然结束（包括return），唯独不能再yield，否则将引起RuntimeError。该方法没有返回值（None）。退出后再调用生成器的next() 方法将抛出StopIteration 异常
+ throw(Etype[, value[, traceback]]) 在生成器yield 位置抛Etype(value) 异常，若生成器捕获该异常，则继续执行到下一个yield 返回之，或者执行结束，抛出StopIteration 异常；若生成器没捕获，则将抛出Etype异常到该方法的调用处

创建生成器之后，必须首先使用next() 或者send(None) 进行预热，才能调用其他方法，否则在进入生成器函数之前就会抛异常
一旦生成器函数不是通过yield 退出，就无法再调用next/send 方法了，否则将抛出StopIteration 异常
换句话说，只有停在yield 处的生成器，才能使用上述方法进行交互，否则都将有异常

# 第六章. 对象和类
## 1. 类定义
```
class ClassName(base_class, ...):
    "optional documentation string"
    static_member_declarations

    method_declarations(self)
```
`base_class`声明基类，如果没有指定，则使用 object 作为基类（object是最基本的类型），支持多继承
类文档字符串不会被继承，但类属性会被继承（除非覆盖定义）

属性可以在任何时候动态添加、修改和del（甚至在类的外部，动态添加要求该类必须有`__dict__`属性）
定义在类域之下的是静态成员，属于类自身；定义在方法中，用self绑定的是实例属性

当使用实例访问一个属性时，优先查找实例属性，若找不到定义，再访问同名的类属性，如果还没有，则延继承mro顺序向基类查找；
当用类访问一个属性，则直接访问的是类属性，如果没有，则延继承mro顺序向基类查找。
这样就导致了一种结果，那就是使用实例访问类属性无法进行修改，因为写属性的语法会被认为定义了一个同名的实例属性，所以修改类属性只能使用类调用（可以使用`self.__class__` 获取类）
不过有点例外就是，若类属性时可变类型时，可以修改其内容

和函数对象类似，在类定义完成时，就声明了一个类对象，所以类定义可以放在局部作用域

一个py 文件就是一个模块空间，那么class 就是一个模块内的一块命名空间，也就是在class 内可以写可执行代码，该代码跟静态成员一样会在类被加载进来之后就会被执行和实例化

super(type[, obj]) 方法
如果obj 缺省，则返回的是一个未绑定的代理对象，而后可以使用`__get__(obj)`方法进行绑定
绑定obj 就会根据`obj.__class__.__mro__`（也就是mro()方法，差别是属性返回的是tuple，方法返回的是list）的顺序链，找到type 的下一个，若obj 是实例对象，则返回的是obj 父类的代理实例；若是类对象，则返回的是obj 父类的代理类对象
在Python3 中，如果两者都缺省，则type 就是当前代码位置的类，obj 是self，所以这种方式仅仅能用于拥有self 的方法内。除此之外，则并不限制其使用位置

## 2. 内置属性
`__class__` 实例对应的类对象（即使调用的是从父类继承而来的方法，self也是当前实例，所以该属性也始终是该实例对应的那个子类），也可以作为一个可调用对象使用（调用的是构造器）
`__name__` 对象的名字(字符串)
`__qualname__` 对象的限定名（带有点分限定的名字）
`__doc__` 对象的文档字符串
`__base__` 对象的第一个父类
`__bases__` 对象所有父类构成的元组
`__dict__` 实例所有属性构成的字典（仅包括当前对象已经初始化的，不包括类声明的属性和类的属性，这些属于类对象，类对象的`__dict__`可以拿到类属性和方法），改变该字典的内容会直接影响实例属性值
`__module__` 对象定义所在的模块
`__annotations__` 对象类型注解的字典（对函数对象而言，就是参数和返回值的类型注解）
`__slots__` 限定实例的可用的属性名，其值可以是一个字符串可迭代对象，阻止自动为每个实例创建 `__dict__` 和 `__weakref__`（能显著节省空间和提高属性查找速度）。想要实例能够动态赋值，就需要在这个字符串可迭代对象中加入`'__dict__'`

### 设置属性
property(fget=None, fset=None, fdel=None, doc=None): 通过这个工厂方法可以返回一个属性关联读写删除方法
```py
class C:
    def __init__(self):
        self._x = None

    def getx(self):
        return self._x

    def setx(self, value):
        self._x = value

    def delx(self):
        del self._x

    x = property(getx, setx, delx, "I'm the 'x' property.")
```
如果 c 为 C 的实例，c.x 将调用 getter，c.x = value 将调用 setter， del c.x 将调用 deleter

property 也可以作为装饰器用于getter 方法上，它将拷贝 fget 的文档字符串作为属性的doc
```py
class C:
    def __init__(self):
        self._x = None

    @property
    def x(self):
        """I'm the 'x' property."""
        return self._x          # 若_x 是可变对象，可以改变_x 的内容，不能改变_x 的指向

    @x.setter
    def x(self, value):
        self._x = value         # 只有通过这种方式可以改变指向

    @x.deleter
    def x(self):
        del self._x
```

## 3. 构造器 和 析构器
在调用`obj = cls()` 生成一个实例时，首先是调用`__new__(cls)` 进行构造，若返回的对象是cls 实例，则调用`__init__(self)`进行初始化，而后就返回该对象。

`__new__(cls)` 构造方法，该方法是一个类方法（参数一般和`__init__`一致），但无需使用classmethod装饰器修饰，若没有重写该方法，默认继承父类的该方法（直到object 的该方法是返回cls 类型的一个实例，但还没初始化），该方法需要返回一个实例
由于没有使用classmethod 修饰，所以调用父类的的该方法必须显式指定clsc参数：`super().__new__(cls, ...)`
若该方法返回的不是当前类的实例，则不再调用`__init__()`初始化方法
该方法一般不用重写，一般用在这些场景：
1. 继承内置的不可变类型时，可以对参数进行处理后，使用处理后的参数调用父类（即该不可变类）的`__new__()` 返回实例返回（`__init__()` 不能接受这种参数）
2. 实现单例模式
3. 实现自定义的metaclass

例如：
```py
class Singleton:
    _ins = None
    def __new__(cls, *args, **kwargs):
        if cls._ins is None:
            cls._ins = object.__new__(cls)
        return cls._ins
```
这个类本身就是单例类，这种方式的缺点就是需要给每个单例类加这样的一个`__new__`方法，而且`__init__` 方法仍会执行，进而对单例进行再次初始化

`__init__(self)` 初始化方法（self 就是`__new__()`方法返回的当前类的实例），如果没有显式定义该方法，则默认提供一个空的构造器（对于子类会自动调用父类的构造器）。
该方法不需要返回（若返回了一个非None 值将报错）
foo = ClassName()就创建了一个该类的实例。当一个实例被创建，`__init__()`就会被自动调用。
在子类中，若显式定义了构造器，就需要手动去调用父类的构造器了，有两种找到父类的方式：
```py
FooParent.__init__(self)    # python2 的经典类只能使用这种方式
# 或者
super(FooChild, self).__init__()     # python2 的新式类可以使用super
super().__init__()                  # Python3 可以不带任何参数，则两个参数分别隐式是当前类（FooChild）和当前对象（self）
```
super 函数会将 self 转化为FooChild 父类的对象

`__del__(self)` 析构方法，由于Python 使用引用技术的垃圾回收机制，所以该函数要到对象的引用计数清零时才会执行
注：
1. del t 命令只能清理当前t 的引用，但并不能保证清理对象，所以不一定能调用析构方法
2. 不要忘记首先调用父类的`__del__()`
3. 该函数中未捕获的异常会被忽略掉

## 4. 方法
无论哪种方法，其本质上都是函数对象（保存在`__dict__`中，也可以通过`cls.method_name`或`obj.method_name.__func__`获取），差别只不过是可以使用可以被其所有者进行调用，而后将调用者(caller, 也即`obj.method.__self__` is obj) 绑定到函数对象的第一个参数上（静态方法比较例外，没做这种绑定，直接返回原始函数对象）
而从类的角度来看，方法其实也还是类及其实例的属性，只不过这个属性被赋值为一个函数对象，所以方法的调用，还是先遵从属性查找机制（即x.name 的查询顺序是`__getattribute__` -> 数据描述器 -> 实例属性或方法（`obj.__dict__`） -> 非数据描述器 -> 类属性或方法（`cls.__dict__`） -> `__getattr__` -> 抛AttributeError），然后根据属性的类别，是函数对象则可以调用

### 4.1 实例方法
实例方法也是一个函数对象，也可以保存为变量或使用参数传递（和普通的函数对象差别仅仅是第一个参数绑定了self对象而已）
第一个参数都是self，它是对象实例的引用，对象的私有成员和类的静态成员都可以使用它引用，例如通过`self.__class__.__name__`可以得到类名
类似于实例属性，实例方法也可以定义在类的外部：
```py
def f1(self, x, y):
    return min(x, x+y)

class C:
    f = f1
```
从这个例子可以看出，方法其实就是类自身的属性，只不过类型是函数对象

#### 魔术方法
`__hash__`: 供hash() 调用
`__bool__`/`__nonzero__`: 用于真值测试 以及 bool() 调用（前者是Python3，后者是Python2）

`__str__`: 供str() 以及 format() 和 print() 调用
`__repr__`: 供 repr() 调用，用于调试
`__bytes__`: 供 bytes() 调用

`__len__`: 供 len() 调用
`__setitem__`: 按照索引赋值，也支持切片key
`__getitem__` 按照索引获取值
`__missing__` 在找不到指定的键时调用
`__getattribute__`: x.name 的使用（包括对内置属性），也可以供getattr(obj, attr[, default]) 调用，这些调用都会直接进入该函数，除非通过super() 委托给同名方法，才会查看是否已经定义了指定的属性或方法 或者 抛AttributeError（但这种情况也会跳过定义的属性或方法，直接去调用`__getattr__`）
`__getattr__`: x.name 的使用，也可以供getattr(obj, attr[, default]) 调用（若不存在attr指定的属性或方法，则返回default，否则会引发AttributeError，可以先用hasattr(obj, attr) 进行测试）若类已定义了指定的属性或方法，则直接使用之，该方法不再调用
`__setattr__`: x.name 的赋值，也可以供setattr(obj, attr, val) 调用
`__delattr__`: x.name 的删除，也可以供delattr(obj, attr) 调用
`__set_name__(self, owner, name)`: 在类被创建完成时，会按次序逐个调用每个属性的该方法（通常用于描述器命名绑定）
`__get__(self, ins, owner=None)`: 描述器读方法，当读该属性时，就会调用描述器的该方法，用其返回值作为读取的属性值。ins 是被描述的类的实例（若使用类调用，则ins是None），owner 是被描述的类对象；若是继承得到的描述器属性，ins/owner也是当前的实例和类（而不是定义属性的基类）。若有异常，请抛AttributeError 异常
`__set__(self, ins, value)`: 描述器写方法，无需返回值。注意，没有owner 参数，也就意味着只能用被描述的类的实例调用，而不能用类对象调用（类对象调用会认为是常规的赋值行为）。
`__delete__(self, ins)`: 描述器del方法，无需返回值。同上，没有owner 参数，只能用被描述的类的实例调用
`__getstate__`: 供pickle.dumps 使用，返回一个可序列化对象，若未定义该方法，则使用`__dict__` 作为返回
`__setstate__(state)`: 供pickle.loads 使用，将序列化出来的对象作为参数state，用于给self 赋值，若未定义该方法，则将state 赋值到`__dict__`
`__getnewargs__`: 返回一个tuple，用于pickle.loads 传递给`__new__` 作为位置参数使用。如果定义了`__getnewargs_ex__`，则忽略该方法
`__getnewargs_ex__`: 返回一个二元组(args, kwargs)，用于pickle.loads 传递给`__new__` 作为位置参数和关键字参数（用于协议2+版本）
`__iter__`: 供iter() 或for 循环调用，返回当前对象的迭代器（带有`__next__`方法的对象），若自身定义了`__next__`可以直接返回self。该方法也可以定义为一个生成器
`__next__`: 供next() 或for 循环调用，返回下一个元素或抛 StopIteration
`__reversed__`: 供reversed() 调用，以返回反向迭代器
`__contains__`:重载运算符in

`__cmp__` 供cmp() 使用
`__lt__` 重载运算符<, 若没有实现，会返回单例对象 NotImplemented
`__le__` 重载运算符<=
`__eq__` 重载运算符==
`__ne__` 重载运算符!=
`__gt__` 重载运算符>
`__ge__` 重载运算符>=
*可以仅实现`__eq__`和`__lt__、__le__、_gt__、__ge__` 这些方法之一，而后使用functools.total_ordering 这个类装饰器，就可以自动生成全部的方法*

`__call__` 重载函数调用运算符()
以下这些运算符加上r 表示右操作数运算符，加上i 表示原地操作运算符（返回值是self）
`__add__` 重载运算符+
`__sub__` 重载运算符-
`__mul__` 重载运算符`*`
`__matmul__` 重载运算符@
`__truediv__`  重载运算符/
`__floordiv__` 重载运算符//
`__mod__` 重载运算符%
`__pow__` 重载运算符`**`
`__lshift__` 重载运算符<<
`__rshift__` 重载运算符>>
`__and__` 重载运算符&
`__or__` 重载运算符|
`__xor__` 重载运算符^

`__neg__`
`__pos__`
`__abs__` 供abs() 调用
`__invert__`: 重载运算符~

`__complex__` 供complex() 调用
`__int__(self)`: 供int() 调用
`__float__(self)`: 供float() 调用
`__index__`:  供operator.index() 调用，返回一个整数索引
`__round__` 供round() 调用
`__trunc__` 供math.trunc() 调用
`__floor__` 供math.floor() 调用
`__ceil__` 供math.ceil() 调用

#### 描述器
描述器类是一个具有`__get__`/`__set__`/`__delete__` 这些魔术方法其一的类（`__set_name__` 非必选）
其实例（描述器）可以赋值给另一个类的属性

若未定义`__get__`，则描述器属性将返回这个描述器对象，除非实例本身有该属性的定义
若未定义`__set__`，则赋值行为将取消该属性的描述器特性
若未定义`__delete__`，则del 行为将直接删除该类属性
只定义了`__get__`称为非数据描述器，实例的`__dict__`优先于描述器调用；否则称为数据描述器，描述器调用优先于实例的`__dict__`
只读属性需要在`__set__` 中抛AttributeError

##### 应用
ORM 中定义的字段规格，还有一些Validator 组件，都是使用描述器进行字段的`__set__`检查
classmethod、staticmethod、property、cached_property 这些装饰器都是通过描述器实现的（前两者是只定义了`__get__`方法的描述器）
我们用描述器，来实现一个类属性的装饰器，可以实现延迟获取、动态取值等特性
```py
class classproperty:        # 该装饰器非线程安全，如需线程安全需要加锁
    def __init__(self, method_or_cached):
        if callable(method_or_cached):
            functools.update_wrapper(self, method_or_cached, updated=())
            self.method = method_or_cached
            self.cached = False
        else:
            self.cached = bool(method_or_cached)
    
    def __call__(self, method):
        functools.update_wrapper(self, method, updated=())
        self.method = method
        return self

    def __get__(self, ins, owner=None):
        if owner is None:
            owner = type(ins)
        if not self.cached:
            return self.method(owner)
        if not hasattr(self, '_cache'):
            self._cache = self.method(owner)
        return self._cache

    from collections import namedtuple
    property_val = namedtuple('property_val', 'value cached')
    def __set__(self, ins, value):
        if isinstance(value, self.property_val):    # 这里是为了可以转换缓存状态
            self.cached = bool(value.cached)
            value = value.value
        if callable(value):
            functools.update_wrapper(self, value, updated=())
            self.method = value
        elif self.cached:
            self._cache = value
        else:
            self.method = lambda c: value

    def __delete__(self, ins):
        if self.cached:
            del self._cache

    def __set_name__(self, owner, name):
        self.__name__ = name
        setattr(owner, f'_{name}_name', name)

class Demo:
    @classproperty      # 无参装饰不做缓冲，只做延迟动态；若有参装饰，还可以实现缓存功能
    def engine(cls):
        return load_engine(...)

    @classmethod        # 3.9 <= version < 3.11 可以两者连用，classmethod 必须在外层
    @property
    def engine2(cls):
        ...

Demo.engine # 类访问属性，调用__get__
demo.engine # 实例访问属性，调用__get__
demo.engine = lambda c: load_another_engine()   # 切换加载方法，调用__set__
del demo.engine # 清除缓存，下次重新加载

Demo.engine = xxx   # 不会调用__set__，而是将类属性值更新，后续将失去描述器特效
del Demo.engine # 不会调用__delete__，而是将engine 从vars(Demo) 中移除

vars(Demo)[Demo._engine_name] # 通过这种方式可以获取到描述器实例，而不会触发__get__
```

### 4.2 类方法 和 静态方法
需要通过装饰器，将方法进行转化
```py
class A: # Python2 经典类，不能使用super；但在python3 中和新式类一样，默认继承object
    @classmethod
    def c_method(cls):
        print(cls.__name__)

    @staticmethod
    def s_method():
        print(A.__name__)

class B(object): # 新式类
    @classmethod
    def c_method(cls):
		super(B, cls).c_method(cls)	# 调用父类类方法，super 第二个参数使用类对象

def outer_cls(cls):
    pass
A.c1_method = types.MethodType(outer_cls, A) # 在类外定义类方法
obj.c2_method = types.MethodType(outer_cls, obj, A) # 也可以绑定实例方法，但该方法仅限于该实例

a = A()
type(A)        # <type ‘classobj’>
type(a)        # <type ‘instance’>

b = B()
type(B)        # <type ‘type’>
type(b)        # <class ‘__main__.B’>
```
当需要对类方法进行装饰时，classemethod 应该放在外层，内层装饰器返回的函数的参数中包括了cls 参数

## 5. 访问权限
private: 标识符使用双下划线 `__` 开头，实际上通过加上前缀`_className`就可以访问得到这些隐藏标识符（这样可以避免先祖类或子类定义同名变量带来的冲突）
protected: 

## 继承
使用super() 可以延mro() 的链找到最近的一个拥有指定方法的定义去执行。
Python 支持多继承，所以就可能存在菱形继承结构。Python的多继承更像是一种 ChainMap 的结构，首个父类类是第一层，而后的父类是parents
在解析继承结构时，Python 基于[C3算法](https://en.wikipedia.org/wiki/C3_linearization)（按继承列表从左向右，0度剪枝，深度优先），确保每个祖先类的构造函数只执行一次（不限于构造函数，所有函数调用都使用该规则），并且解析的结果（执行序列的类对象元组，元组的第一个元素一定是当前类对象，最后一个是object）也会存入类对象的`__mro__`属性（Method Resolution Order）中，例如
```py
class A:
  def __init__(self):
    print("Enter A")
    super().__init__()
    print("Leave A")
  def get_name(self):
    t = super()
    if hasattr(t, 'get_name'):
        return 'A' + t.get_name()
    else:
        return 'A'
class B(A):
  def __init__(self):
    print("Enter B")
    super().__init__()
    print("Leave B")
  def get_name(self):
     return 'B' + super(B).__get__(self).get_name()
class C(A):
  def __init__(self):
    print("Enter C")
    super().__init__()
    print("Leave C")
class D(A):
  def __init__(self):
    print("Enter D")
    super().__init__()
    print("Leave D")
class E(B, C, D):
  def __init__(self):
    print("Enter E")
    super().__init__()
    print("Leave E")

class F:
    def __init__(self) -> None:
       print('Enter F')
       super().__init__()
       print('Leave F')
    def get_name(self):
        return 'F'
class G(B, F):
    def __init__(self):
        print('Enter G')
        super().__init__()
        print('Leave G')
    def get_name(self):
       return 'G' + super().get_name()
```
E()执行结果为：
Enter E
Enter B
Enter C
Enter D
Enter A
Leave A
Leave D
Leave C
Leave B
Leave E

g.get_name()执行结果是GBAF
由于深度优先，虽然A 跟F 没有任何直接关系，但在G 的mro 链中F 是在A 之后，所以需要A 中调用super 才可能调用到F；或者就需要在G 中显示调用super(A, self) 才能调用到F（或者直接用F.get_name(self) 进行直接调用）

多继承通常只用在Mixin组件制作时，Mixin 是一组动作的集合，可以集成添加到另一个类中。通常Mixin 会对被添加的类（通常称为宿主）有一定的要求，这些要求就是协议(contract)，具体来说就是需要具有某些属性或方法，而且Mixin 和宿主之间除了协议不需要额外的关联。所以Mixin 应当显著声明其植入协议，以便于复用。
Mixin最大的优势是使用者可以随时安插这些功能,并且可以在必要的时候覆写他们
Mixin 类并不表示一个实体概念，而仅仅是一系列行为的组合，以便于重用，所以Mixin 类绝不实例化。为了明确指示该类的目的，通常这种类都使用Mixin 后缀

### 内置的类方法
`__subclasses__()`: 获取该类的所有子类的列表


### 方法重写
使用 typing_extensions.override 装饰器，可以
+ 进行签名检查，确保重写的方法前面跟父类一致
+ 让编译器知道该方法的父子关联，当一者变化后，可以进行提示

在多重继承中可以以一个父类作为参数，表示重载的是那个父类的方法

## 6. 元类
元类就是类的类，所以它本身也是一个类，其实例是类对象，所有类默认的元类是type
通过元类，可以当创建类时，能够自动地改变被创建的类

它形式上就是一个可调用对象，接受类的描述信息(name, bases, attrd)，返回一个类对象，attrd 是一个字典，表示当前类的namespace
所以元类相对与类，就像装饰器相对于函数，都是对原来的类型或函数对象进行修改，而后回赋给原对象

### 在执行类定义时，解释器会
1. 查找元类metaclass：
	1. 先寻找当前类属性`__metaclass__`，如果此属性存在，就将这个属性赋值给此类作为它的元类；
	2. 否则它会向上查找父类中的`__metaclass__`；
	3. 若所有父类都没有定义`__metaclass__`，则在模块层次中去寻找`__metaclass__`
	4. 如果还是找不到`__metaclass__`, Python就会用内置的type来创建这个类对象
2. 获取类头参数，准备namespace: `namespace = metaclass.__prepare__(name, bases, **kwds)`，name是当前类的类名，bases 是当前类的基类元组，kwds 是基类类头自定义的关键字参数。返回的namespace 是一个字典。
3. 执行元类体，将元类体中定义的属性和方法注入到namespace 中: `exec(body, globals(), namespace)`
4. 执行元类构造器（或元类函数）: ` metaclass(name, bases, namespace, **kwds)`，其返回结果回赋给这个类对象
	1. 在执行`__new__` 方法，在方法中使用`type.__new__` 创建这个类型时，会调用父类的`__init_subclass__(cls)` 方法，kwds 也会经由`__new__` 传给`__init_subclass__`（注意，object 的`__init_subclass__` 函数并不接受kwds 参数，所以这时`type.__new__` 调用不要带kwds）

### 在执行类实例化时，解释器会
1. 执行元类的`__call__(cls, *args, **kwargs)`方法cls 是当前类的类对象，后面是实例化参数。返回一个实例化对象。该方法的默认实现是返回调用`cls.__new__`的结果。
2. 若在`__call__` 中调用父类的`__call__` 则执行当前类的`__new__` 以及`__init__`（是否执行`__init__` 取决于`__new__` 的返回）

### 在查询类属性时
优先查找当前类的继承链中定义的属性，若找不到，再到元类的继承链中去找对应的属性

### 示例
#### 指定元类
```py
class FooMeta(type):				# 元类继承自type 或type 的子类
	def __new__(cls, name, bases, attrd, **kwargs):     # 目标类创建时调用（即类定义时，可以通过参数查看类定义的描述信息），这里的cls 是FooMeta
		return type.__new__(cls, name, bases, attrd)
	def __init__(cls, name, bases, attrd, **kwargs):    # 目标类初始化时调用（也是类定义时，可以通过参数查看类定义的描述信息），这里的cls 是目标类，也就是__new__ 的返回值
		super(FooMeta, cls).__init__(name, bases, attrs)
	def __call__(cls, *args, **kwargs):		# 在目标类进行实例化的时候被调用（先于目标类的__new__）
        return super().__call__(*args, **kwargs)    # 默认调用__new__ -> __init__

def func_meta(name, bases, attrd):	# 元类也可以是一个函数
	return type(name, bases, attrd)	#  type 还可以作为一个工厂方法来声明一个类型，name 就是这个类型的名字，bases 是这个类型父类的元组，attrd 是类字典属性（属性和方法）

class Foo(object):
    __metaclass__ = FooMeta			# Python2 通过__metaclass__ 属性指定元类

class Simple1(object, metaclass=func_meta, other_opt=''):	# Python3 这样定义元类，还可以自定义其他参数
```

#### 单例meta
```py
class Singleton(type):
    _ins = None
    def __call__(cls, *args, **kwargs):
        if cls._ins is None:
            cls._ins = super().__call__(*args, **kwargs)    # 这里会给当前类设置静态成员，然后会屏蔽meta 的静态成员
        return cls._ins
```
这种方式缺点是有参调用构造器时，会屏蔽掉`__new__` 的调用

## 7. 抽象类
可以通过使用abc.ABCMeta 或其派生类作为元类，来使一个类变为抽象基类；或者也可以通过继承abc.ABC 来完成（抽象基类不能实例化，除非它的全部的抽象方法和特征属性均已被重载）
抽象基类可以通过register(subclass) 方法注册它的抽象子类，这种继承关系不会出现在MRO中，但可以为issubclass() 识别
register 一个一个的添加过于麻烦，可以在抽象基类中重载`__subclasshook__` 方法，用以自动判断一个类是否是其抽象子类
```py
from abc import ABCMeta

class MyABC(metaclass=ABCMeta):	# 方式1
    pass

from abc import ABC

class MyABC(ABC):				# 方式2
    @classmethod
    def __subclasshook__(cls, C):		# cls 是当前的抽象基类，C 是这个被判断的类
        if cls is MyIterable:
            if any("__iter__" in B.__dict__ for B in C.__mro__):
                return True				# True/False 都将作为issubclass/isinstance 的判断结果
        return NotImplemented			# 这种返回值将按照正常机制继续执行检测

MyABC.register(tuple)
assert issubclass(tuple, MyABC)
assert isinstance((), MyABC)
```

抽象基类可以用 @abc.abstractmethod 装饰器声明抽象方法和特征属性，表明一个方法必须被重载（否则不能实例化，只能调用类方法或静态方法），这个方法可以拥有实现，也可以被派生类调用
该装饰器仅仅影响常规继承所派生的子类；通过 ABC 的 register() 方法注册的“虚子类”不会受到影响
当该装饰器需要和其他装饰器共同修饰一个函数时，本装饰器必须在最内层，例如：
```py
class C(ABC):
    @abstractmethod
    def my_abstract_method(self, ...):
        ...
    @classmethod
    @abstractmethod
    def my_abstract_classmethod(cls, ...):
        ...
    @staticmethod
    @abstractmethod
    def my_abstract_staticmethod(...):
        ...

    @property
    @abstractmethod
    def my_abstract_property(self):
        ...
    @my_abstract_property.setter
    @abstractmethod
    def my_abstract_property(self, val):
        ...

    @abstractmethod
    def _get_x(self):
        ...
    @abstractmethod
    def _set_x(self, val):
        ...
    x = property(_get_x, _set_x)
```

嵌套类

## dataclasses 模块
Python3.7 新增，辅助数据类的构造，[参考](https://docs.python.org/zh-cn/3/library/dataclasses.html)
数据对象类似于Java 的POJO 对象，类似于@Data 注解，它可以很好的替代namedtuple的功能。

### dataclass
通过装饰器dataclass，它解析`__annotations__`，来自动生成魔术方法。也可以自定义覆盖默认的方法
```py
@dataclass
class Person:
    name: str
    _: KW_ONLY      # 该类后面的字段，在`__init__` 中是只限关键字参数
    age: int
    mylist: List[int] = field(default_factory=list) # 默认值是该类的所有实例共享的，如果使用[]，那么多个实例会相互影响，所以可变默认值应该使用这种形式

@dataclass(init=True, repr=True, eq=True, order=False, unsafe_hash=False, frozen=False, match_args=True, kw_only=False, slots=False)
class Coder(Person):
    preferred_language: str = 'Python 3' # 字段默认值,默认值属性必须在无默认值属性之后，因为装饰器会据此定义顺序生成__init__ 方法的参数列表
    
    @property
    def method_with_property(self): # 使用property，可以obj.method_with_property 访问
```
dataclass 装饰器既可以是无参，也可以是有参装饰（都是关键字参数）：
+ init：是否自动生成`__init__`，默认为True
+ repr：是否自动生成`__repr__`，默认为True
+ eq：是否生成`__eq__`，所有属性进行等值比较，默认为True
+ order：自动生成`__lt__`，`__le__`，`__gt__`，`__ge__`，默认为False
+ frozen：对象是否不可变，默认为False，若重写`__setattr__`和`__delattr__`会引发TypeError，所以初始化时只能使用`object.__setattr__`
+ unsafe_hash：默认False，根据eq 和frozen 决定是否生成`__hash__`；若为True，则会根据类属性自动生成`__hash__`，由于属性是可变的，所有会导致hash 值不固定，所有除非能确定属性不会变化，否则不要设置为True：
    + eq和frozen都为True，`__hash__`将会生成
    + eq为True而frozen为False，`__hash__`被设为None
    + eq为False，frozen为True，`__hash__`将使用父类的`__hash__`（通常是object 的基于对象ID的hash）
+ match_args: 是否生成`__match_args__` 元组（Python3.10+）

### field
为字段提供额外的信息，其参数也都是关键字参数：
+ default：默认值，优先于default_factory
+ default_factory：默认值生成函数（必须是无参数或者全是默认参数的callable对象），不要和default 同时设置
+ init：默认为True，是否参与到`__init__`初始化，如果False 这个字段还可以在`__post_init__` 方法中进行赋值
+ repr：默认为True，是否参与到`__repr__`
+ compare：是否参与到比较运算中
+ hash：是否参与到`__hash__` 中
+ kw_only：Python3.10，标记该字段在`__init__` 中是只限关键字参数
+ metadata

### 模块方法
make_dataclass(cls_name, fields, bases=(), ...)：函数式构造一个dataclass类
fields(class_or_instance): 参数可以是dataclass的类或其实例，返回该类定义的字段元组（每个元素都是Field 类）
asdict(obj, *, dict_factory=dict)：将dataclass实例转为一个字典（深拷贝，使用dict_factory构造的）
astuple(obj, *, tuple_factory=tuple)：将dataclass实例转为一个元组（深拷贝，使用tuple_factory构造的）
is_dataclass(obj)：判断obj 是否一个dataclass 类或实例（可以使用isinstance(obj, type) 区分是类还是实例）
replace(obj, /, **changes)：创建一个与 obj 类型相同的新对象，obj 必须是一个dataclass 实例，changes 不能包含init=False 的字段

### __post_init__(self)
生成的 `__init__` 最后将调用该方法，可以重写该方法以对一些需要自定义初始化逻辑的值进行处理，例如：
当dataclass 类的父类不是dataclass 类，那么生成的 `__init__` 不会调用父类的 `__init__`，所以`super().__init__()` 需要在这里进行调用（若父类还是dataclass 类，则生成的`__init__` 会按MRO 从父类成员->子类成员的顺序排进参数列表中，当然重名会覆盖定义，但位序不会改变）

### ClassVar & InitVar
```py
from typing import ClassVar
from dataclasses import dataclass, InitVar

@dataclass
class Square():
    side: float
    t1: ClassVar[int]    # 静态成员：声明类型式
    t2 = 10              # 静态成员：无类型注解初始化式

    database: InitVar[str] = ''

    def __post_init__(self, database):
        ...
```
对于dataclass 类的静态成员可以有两种方式，无论那种形式，都会避免让dataclass 生成Field

声明为 InitVar 类型的字段，该字段也不会让dataclass 生成Field，它仅仅会出现在`__init__` 和`__post_init__` 的参数列表中，作为一个仅仅用于初始化的变量

无论ClassVar 还是InitVar 的字段，fields() 函数都不会返回

## enum 模块
枚举表示的是常量，因此，建议枚举成员名称使用大写字母

### Enum 类
枚举常量的基类，成员值可以是 int、str 等
若无需设定确切值，auto 实例可以自动为成员分配合适 的值。

```py
# 类形式定义 Enum
class Color(Enum):
    def _generate_next_value_(name, start, count, last_values):
        '''
        name: 当前的枚举值name
        start: 1
        count: 当前的枚举值位序（从0开始）
        last_values: 之前枚举value的list
        '''
        return name

    RED = 1
    GREEN = 2
    DARK_RED = 1
    BLUE = 3
    YELLOW = auto()

name = Color.RED.name
value = Color.RED.value
Color(value)    # 可以获得对应的单例
Color[name]     # 可以获得对应的单例

# 工厂定义形式，类似namedtuple
Animal = Enum('Animal', 'ANT BEE CAT DOG',  # 第二个参数可以是空格或逗号分隔的名称字符串、名称的可迭代对象、kv 2 元组的迭代对象、名称到值的映射（如字典）
    module=__name__,                        # 所在模块的名称
    qualname='SomeData.Animal',             # 在模块中的具体位置
    type=<mixed-in class>,
    start=1)
```
每个枚举成员都是该类的单例（可哈希，可以用is/is not 确认是否相等），而且由于EnumMeta 为枚举类准备了一个特别的`__new__` 所以该类无法额外定义实例。
每个单例都有2个属性：name（str类型）、value，也可以通过这两个属性反向找到单例
其中，name 不允许重复，而value 可以重复（表示后者是前者的别名，即反向找单例时都会找第一个定义该值的枚举值），除非使用`@unique` 装饰该枚举类，则value也不允许重复（重复会抛出ValueError 异常）

若不在意value 可以使用auto() 自动获取一个，该方法会调用枚举类的`_generate_next_value_` 方法获取返回值，该方法必须定义在任何其他成员之前，若未定义该方法，默认使用最近的一个数值+1（若前面没有整数，则从1开始），该方式并不会避开已经定义的值，所以可能会重value

默认以 1 而以 0 作为起始数值的原因在于 0 的布尔值为 False，但所有枚举成员都应被求值为 True

如果在类的静态定义区，却不想让这些变量成为枚举单例，可以定义一个`_ignore_` 成员，该成员可以是一个空格分隔的字符串，或者list，其中指定的名字将不会作为枚举单例

不支持比较和排序
支持pickle

EnumMeta 还为枚举类提供好了`__contains__()`、`__str__()` 和 `__repr__()`
`__iter__()`: 枚举类是一个可迭代对象，可以按定义顺序进行迭代每个枚举值（不包括别名）
`__members__`: 从name到成员的只读有序映射（包含别名）

#### 更丰富的成员内容
希望一个成员具有更多的内容信息，但仅需要一个值作为value
```py
class Coordinate(bytes, Enum):
    """
    Coordinate with binary codes that can be indexed by the int code.
    """
    def __new__(cls, value, label, unit):
        obj = bytes.__new__(cls, [value])
        obj._value_ = value                 #  作为value
        obj.label = label
        obj.unit = unit
        return obj
    PX = (0, 'P.X', 'km')
    PY = (1, 'P.Y', 'km')
    VX = (2, 'V.X', 'km/s')
    VY = (3, 'V.Y', 'km/s')
```

#### 子类化
若一个枚举类定义了枚举值，则该枚举类无法直接继承；若一个枚举类仅仅定义了一些方法并没有定义成员，则可以直接继承

```py
class AutoNumber(Enum):
    def __new__(cls, *args):
        value = len(cls.__members__) + 1
        obj = object.__new__(cls)           # 直接使用object 定义一个实例
        obj._value_ = value                 # 作为value
        return obj

    def some_behavior(self):
        pass

class Swatch(AutoNumber):
    def __init__(self, pantone='unknown'):
        self.pantone = pantone
    AUBURN = '3497'
    SEA_GREEN = '1246'
    BLEACHED_CORAL = ()     # unknown
```


### IntEnum 类
int 子类枚举常量的基类
相当于
```py
class IntEnum(int, Enum):   # 枚举基类必须是最后一个，该类才能被枚举化
    pass
```
所有成员必须是int 类型的value
可以支持int 行为的操作：比如可以和整数比较，可以基于整数值，和其他IntEnum 成员进行比较，可以作为切片索引

### Flag 类
可与位运算符(&, |, ^, ~)搭配使用
但不具备int 的行为操作

### IntFlag 类
可与位运算符搭配使用（计算结果依然是该类的成员）

也具有IntEnum 的特性

```py
class Perm(IntFlag):
    R = 4
    W = 2
    X = 1

RW = Perm.R | Perm.W
assert Perm.R in RW
assert not (Perm.R & Perm.X)

class Color(Flag):
    RED = auto()
    BLUE = auto()
    GREEN = auto()
    WHITE = RED | BLUE | GREEN
```
使用auto() 从1 开始，每次*2（即`2**n` 排列）


# 第七章. 模块
当你创建了一个 Python 源文件，就是一个独立的模块，模块名是不带 .py 后缀的文件名
在该源文件中，
变量`__name__`就是当前模块的名字。一般作为主模块直接执行的，`__name__`都是`__main__`，而被import的模块使用`__name__`则显示该模块的模块名。
变量`__file__`是当前模块文件的路径（包含文件名，可能是一个相对路径）
变量`__package__`是当前所在包的名字。若作为主模块直接执行，其为None

## 1. 导入模块
```py
# 导入整个模块
import module_name [as alias_name]
# 导入模块中的某个标识符，但这种导入方式只能读取不能改写模块变量，想要改写只能导入整个模块
from module_name import identifier1 [as alias_name1][, identifier2 [as alias_name1][, ...identifierN [as alias_nameN]]]
# 导入当前所在包的标识（即定义在当前包的 __init__.py 中的）
from . import pkg_idf
# 导入父包的标识（每一个 . 就是向上一级）
from .. import pkg_idf
# 导入同级包中模块的标识
from .module_name import identifier
# 导入父级包中的标识
from ..module_name import identifier
```
相对导入是使用`__name__` 确定当前模块的位置的，而`__name__ == '__main__'`时，是顶级模块，而无视其所处的模块位置，所以相对导入就可能失效

sys.modules 变量是一个字典，它保存了已经加载的模块名和模块实例的映射关系，比如`sys.modules[__name__]`就是当前模块实例

模块导入遵循作用域原则，模块顶层导入的有全局作用域，函数中导入的，是局部作用域
首次导入模块会加载模块的代码，即会执行模块的顶层代码

from-import 语法 实际上是个语法糖：
```py
from a import v
# 大体上相当于（当然并不能直接引用a）
import a
v = a.v
```
所以from-import 就有一个问题，就是它相当于在本文档建立了一个原模块变量的一个引用
那么，如果改引用，就意味着跟原模块的变量进行了解绑，而并不会对应修改原模块的变量值
另一方面，如果原模块变量改引用，这里绑定的仍然是原来的引用，所有也无法立即提现出对应的变化
综上：对于可能存在的模块变量的引用修改，一定要使用`import a`，然后在使用时在使用`a.v`，不要使用from-import 这个语法糖

### 1.1 搜索路径
想要成功导入模块，就要确保该模块在搜索路径中可以找到
搜索路径在启动Python时，通过环境变量PYTHONPATH（冒号分隔的一组路径）读入。在解释器启动后，搜索路径被保存在sys.path 变量里，该变量是一个字符串列表，可以进行动态修改
sys.path 默认值是第一个元素是空串，表示当前目录，而后是PYTHONPATH 导入的各个路径，然后是自带的标准库目录，最后是通过 pip 等命令安装的第三方库的目录
搜索时是按照该列表顺序进行搜索，如果找到就不再搜索后面的路径

还支持从zip 归档文件中导入模块（.py, .pyc, .pyo），只需要将归档文件当做一个目录即可
只不过Python 不会为py 文件生成pyc 文件，所以如果zip 归档中如果没有pyc，导入速度会较慢

*注意：如果sys.path路径上一旦找到 import 的前缀模块，那么无论最终是否能找到目标模块，都不会继续搜索sys.path 后续的若干个路径。也就是找不到会直接抛 ModuleNotFoundError*

### 1.2 importlib
该包以编程方式提供import 的实现
比如：
```py
name = 'mypy'

if name in sys.modules：
    print(f"{name!r} already in sys.modules")
elif (spec := importlib.util.find_spec(name)) is not None:  # 检查某模块可否导入
    mypy = importlib.import_module(name)
    # 或者
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    print(f"{name!r} has been imported")
else:
    print(f"can't find the {name!r} module")
```

import_module(name, package=None): 支持绝对和相对导入，相对方式需要指定package作为锚点

## 2. 命名空间
命名空间是标识符到对象的映射集合
Python 解释器首先加载内建名称空间，即`__builtins__`（在python3中是`builtins`）中的标识符；而后加载模块的全局命名空间；当调用函数时创建局部命名空间
（Python3 中，内置模块更名为builtins，当需要修改内置标识符时可以导入该模块）
可以通过globals() 和 locals() 内建函数判断出某一名字属于哪个名称空间
globals()：返回当前全局标识符名到对象映射的字典（包括import 进来的对象，无论是模块、类、函数）
locals()：返回当前局部标识符名到对象映射的字典。在函数作用域下，是包括函数参数在内的局部变量（也包括函数对象和类对象，但不包括自由变量）；在全局作用域下，返回和globals()函数相同

模块包和类定义，都会创建一个新的命名空间

访问导入模块中的成员：
```
module_name.variable
module_name.function()
```

## 3. 作用域
作用域是标识符的可见性
在函数中定义的变量拥有函数级作用域（局部作用域），在所有函数之外定义的变量拥有模块级作用域（全局域）
当搜索一个标识符的时候:
1. 最先从当前的局部作用域开始搜索;
2. 如果在当前的局部作用域内没有找到那个名字，就会逐层向外查找该标识符（自由变量），直到全局域;
3. 如果还没找到, 最后确认该标识符是否是一个内置标识符，如果依然找不到就会被抛出 NameError 异常。

### 3.1 作用域覆盖
如果函数没有对全局变量（以及外部的自由变量）进行赋值，则可以直接读取该变量的值；
如果函数内对全局变量（以及外部函数的同名变量）赋值，则视为定义了一个局部变量隐藏了同名的全局变量（或外部变量），而如果在赋值前读取该变量的值将抛出 UnboundLocalError 异常；
想要真正对全局变量赋值，需使用`global var[, var, ...]`声明（位于对全局变量的读写操作之前，否则会有警告）
Python 3.x引入了nonlocal 关键字，和global 功能类似，用于声明一个变量是外部（自由）变量，并且在当前作用域中需要修改这个外部变量。

总结一下：
+ import 相当于在当前作用域锁引用的命名空间中引入外模块标识符并绑定（通过as 可以绑定别名）
+ global 和nonlocal 也分别是在当前作用域引入外层的标识符并绑定（外层可以还没有声明该标识符）
+ del 则是将该标识符从当前作用域所引用的命名空间中移除绑定

## 4. 包
包是带有`__init__.py` 文件的目录
通过目录这种层次结构，可以实现包的层次关系（子目录带上`__init__.py` 文件就是一个子包）
`__init__.py`的内容可以为空，一般用来进行包的某些初始化工作或设置`__all__`的值，`__all__`是在使用`from package-name import *`语句决定导出哪些模块，它由一个模块名字符串组成的列表（也可以是import 进来的名字字符串）；若没有`__all__`，则该语句会导出模块内所有非下划线开头的成员
`__init__.py` 文件会在包被首次导入时执行，当导入子包时，会从顶层到导入的子包，依次执行未加载的包的`__init__.py` 文件

### 导入包和使用包
通过包导入模块
```
import package_name.sub_package_name.module_name
package_name.sub_package_name.module_name.identifier
```
也可以只导入某一层包，那么能够使用的只有那一层以及上面各层包的`__init__.py` 文件中的内容
只要保证顶层包在搜索路径中就可以保证该包下的任何子包和模块都可以成功导入

如果标识符以 _ 开头，则不可被from module import * 导入进来，只能显式导入指定的标识符才行

当包中标识符和模块或者包重名，如果模块或包被导入，则模块或包优先绑定该标识符；
当模块和子包重名，则子包优先绑定该标识符

导入子包
```
from package_name import sub_package_name
sub_package_name.module_name.identifier

from package_name.sub_package_name import module_name
module_name.identifier

from package_name.sub_package_name.module_name import identifier
identifier
```
注意：如果名字和标准库模块的符号冲突，会覆盖标准库的定义

在命令行可以使用`python -m module_name` 来预导入指定的包

## 5. 自定义导入器
需要两个类：查找器和载入器。查找器的实例接受一个参数：模块或包的全名。如果找到，返回一个载入器对象。载入器把模块载入内存，完成创建一个模块所需的所有操作，返回模块。
把这些实例加入到`sys.path_hooks`，`sys.path_importer_cache` 只是用来保存这些实例, 这样就只需要访问 `path_hooks` 一次。 最后, `sys.meta_path` 用来保存一列需要在查询 sys.path 之 前访问的实例, 这些是为那些已经知道位置而不需要查找的模块准备的。 meta-path 已经有了指定模块或包的载入器对象的读取器。

由于import 语句实际上是调用`__import__()` 函数，例如import sys 相当于`sys = __import__('sys')`
当然也可以覆盖它的实现来自定义导入。只不过这样比较麻烦
```
__import__(module_name[, globals[, locals[, fromlist]]])
```
参数是导入的模块名，当前全局符号表名字的字典，局部符号表名字的字典，使用 from-import 语句所导入符号的列表
后三个参数默认值为globals(), locals() 和 []。

reload(module)
可以重新导入一个已经导入的模块，module 是你想要重新导入的模块（必须是已经成功全部导入的模块，而不能只是导入部分标识符）
*注：该函数会再次执行一次模块的顶层代码*

## 6. 常用模块
### time 模块
有两种时间表示方式：时间戳表示，元组表示
1. 时间戳表示：从epoch 开始的秒数（整数或浮点，范围在1970 – 2038 之间）
1. 元组表示：9个整数分别表示年月日，时分秒，星期（周一是0），一年中的第几天，DST
在python中，有个`struct_time`就是这个9元组的一个表示

> **GMT 格林威治标准时间（Greenwich Mean Time）**，是指位于伦敦郊区的皇家格林威治天文台的标准时间，因为本初子午线（Prime meridian）被定义为通过那里的经线。GMT也叫世界时UT。
> **UTC 协调世界时间（Coordinated Universal Time）**, 又称世界标准时间，基于国际原子钟，误差为每日数纳秒。协调世界时的秒长与原子时的秒长一致，在时刻上则要求尽量与世界时接近（规定二者的差值保持在 0.9秒以内）。
> **时区** 是地球上的区域使用同一个时间定义。有关国际会议决定将地球表面按经线从南到北，划分成24个时区，并且规定相邻区域的时间相差1小时。当人们跨过一个区域，就将自己的时钟校正1小时（向西减1小时，向东加1小时），跨过几个区域就加或减几小时。比如我大中国处于东八区，表示为GMT+8。
> **夏令时 （Daylight Saving Time：DST）**，又称日光节约时制、日光节约时间或夏令时间。这是一种为节约能源而人为规定地方时间的制度，在夏天的时候，白天的时间会比较长，所以为了节约用电，因此在夏天的时候某些地区会将他们的时间定早一小时，也就是说，原本时区是8点好了，但是因为夏天太阳比较早出现，因此把时间向前挪，在原本8点的时候，订定为该天的9点(时间提早一小时)～如此一来，我们就可以利用阳光照明，省去了花费电力的时间，因此才会称之为夏季节约时间！
> **闰秒** 是的，不只有闰年，还有闰秒。闰秒是指为保持协调世界时接近于世界时时刻，由国际计量局统一规定在年底或年中（也可能在季末）对协调世界时增加或减少1秒的调整。由于地球自转的不均匀性和长期变慢性（主要由潮汐摩擦引起的），会使世界时（民用时）和原子时之间相差超过到±0.9秒时，就把世界时向前拨1秒（负闰秒，最后一分钟为59秒）或向后拨1秒（正闰秒，最后一分钟为61秒）； 闰秒一般加在公历年末或公历六月末。
> **Unix时间戳** 指的是从协调世界时（UTC）1970年1月1日0时0分0秒开始到现在的总秒数，不考虑闰秒。

#### 函数
sleep(seconds)：线程休眠，seconds是一个浮点数
time()：返回当前时间的浮点时间戳（从epoch 开始的秒数）
time_ns(): 当前时间的整数时间戳（从epoch 开始的纳秒数）

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

### datetime 模块
实现了日期和时间的类型，用于算术运算
类date、time、datetime（继承date）、timedelta、timezone

#### date 类
date(year, month, day)
参数必须在取值范围内（year 必须在[datetime.MINYEAR, datetime.MAXYEAR]区间中）
hashable（可用于字典key）

支持比较

##### 类属性
min/max
resolution：最小日期差（timedelta(days=1)）
##### 实例属性（只读）
year、month、day
##### 类方法
today()：返回本地的当天日期对象
fromtimestamp(timestamp)：将一个时间戳（秒级时间戳，可以是浮动数）转换为日期对象
fromordinal(ordinal)：将一个日期序数转换为日期对象，以date(1, 1, 1)为1，date(1, 1, 2)为2，以此类推
fromisoformat('YYYY-MM-DD'): isoformat方法的逆操作，python3.7引入，3.11还支持'YYYYMMDD'/'2021-W01-2'（该年第一个完整周的周二）这两种格式
##### 实例方法
replace(year=None, month=None, day=None)：修改日期中某部分的值，生成一个新的日期对象
timetuple()：返回`time.struct_time`类型的9元组
toordinal()：返回日期序数
weekday()：返回星期（0是周一，6是周末）
isoweekday()：返回星期（1是周一，7是周末）
isoformat()：返回形如'2002-12-04'的字符串，也就是str()函数的返回结果
ctime()：返回ctime格式字符串
strftime(format)：返回指定格式的字符串
`__format__(format)`：支持str对象的format 方法

#### time 类
time([hour[, minute[, second[, microsecond[, tzinfo]]]]])
和date类构造方法一样，构造参数必须在指定区间之内
hashable（可用于字典key）

支持比较
注意：不支持算术运算

##### 类属性
min/max
resolution：最小时间差（timedelta(microseconds=1)）
##### 类方法
fromisoformat('hh:mm:ss'): isoformat方法的逆操作，python3.7引入（仅支持isoformat方法返回的格式），3.11还支持更多格式
##### 实例属性（只读）
hour、minute、second、microsecond、tzinfo
##### 实例方法
replace(hour=None, minute=None, second=None, microsecond=None, tzinfo=None)：修改time 中某部分的值，生成一个新的time对象
isoformat()：返回形如'00:00:00.000000'的字符串，也就是str()函数的返回结果
strftime(format)：返回指定格式的字符串
`__format__(format)`：支持str对象的format 方法

#### datetime 类
datetime(year, month, day[, hour[, minute[, second[, microsecond[,tzinfo]]]]])
和date类构造方法一样，构造参数必须在指定区间之内
hashable（可用于字典key）

支持比较

##### 类属性
min/max
resolution：最小时间差（timedelta(microseconds=1)）
##### 实例属性（只读）
year、month、day、hour、minute、second、microsecond、tzinfo
##### 类方法
today()：返回本地的当前的datetime对象
fromtimestamp(timestamp[, tz])：将一个时间戳转换为本地的datetime 对象
fromordinal(ordinal)：将一个日期序数转换为datetime 对象（时分秒均为0，tz为None），以date(1, 1, 1)为1，date(1, 1, 2)为2，以此类推
fromisoformat('YYYY-MM-DDThh:mm:ss'): isoformat方法的逆操作，python3.7引入（仅支持isoformat方法返回的格式），3.11还支持更多格式
now([tz])：如果不带tz参数，相当于today()方法，如果带tz参数，则其为tzinfo的一个子类实例，这样当前时间将被转化为指定的time zone。
utcnow()：返回当前的UTC datetime 对象
utcfromtimestamp(timestamp)：UTC 版本的fromtimestamp
combine(date, time)：组合date 对象和time 对象（包括其tz信息）为一个datetime 对象
strptime(dateString, format)：将一个字符串按指定格式转化为一个datetime 对象
##### 实例方法
replace(year=None, month=None, day=None, hour=None, minute=None, second=None, microsecond=None, tzinfo=None)：修改datetime 中某部分的值，生成一个新的datetime对象
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

#### timedelta 类
timedelta(days=0, seconds=0, microseconds=0, milliseconds=0, minutes=0, hours=0, weeks=0)
日期差值类型
实例化参数支持整数、浮点数、正数负数
由于内部只保存days、seconds、microseconds这三个属性，其他的参数将被转换到这三个属性上（浮点数可能会导致微秒级的精度丢失），并正规化到合理的区间（正规化的顺序是从microseconds 到 days）
hashable（可用于字典key）

该对象支持+-运算，支持对乘整数和整除整数，支持取反，abs，比较
还可以跟date/datetime对象进行加减运算（以表示之前、或之前的时间）

`total_seconds()`返回时间区间的秒数（浮点）

#### timezone 类
实现了tzinfo 这个抽象基类
北京时间时区：`timezone(timedelta(hours=8), 'Asia/Shanghai')`

#### pytz 模块（第三方）
使用Olson TZ Database解决了跨平台的时区计算一致性问题，解决了夏令时带来的计算问题。

默认创建的datetime 对象都是naive datetime，因为没有时区信息（本质上是相对时间），可以使用timezone 返回的时区对象的localize(dt)方法为其设置tzinfo
而有时区信息的datetime 则可以使用astimezone 将其时间按时区转化为另一个时区的对应时间

LMT学名Local Mean Time，用于比较平均日出时间的，北京时间是+8:06，astimezone 可能会收到LMT 时间扰动
CST是China Standard Time，北京时间是+8:00
有个看起来的坑是
```py
TZ_SH = pytz.timezone('Asia/Shanghai')
t = datetime(..., TZ_SH)
tt = t.astimezone(pytz.utc).astimezone(TZ_SH)
```
这里t 和tt 可能展现上有所不同，就是因为前者采用的是LMT，后者采用的是CST，但实际上t == tt

##### 属性和方法
utc: UTC 时区对象，相当于timezone('UTC')
all_timezones: 所有的的时区name列表
timezone(name): 返回指定name 的时区对象，例如中国是'Asia/Shanghai'，该时区对象也是实现了tzinfo 这个抽象基类

#### zoneinfo 模块
Python3.9 支持的标准库，可以替换pytz
其使用系统时区数据库或 PyPI 上的第一方包 tzdata 获取时区信息。所以对于跨平台兼容性的项目，推荐对 tzdata 声明依赖。 如果系统数据和 tzdata 均不可用，则所有对 ZoneInfo 的调用都将引发 ZoneInfoNotFoundError。
系统的搜索路径，在编译时被加载到zoneinfo.TZPATH 这个常量中，可以在编译时通过`--with-tzpath` 进行修改
加载该模块时，也会使用PYTHONTZPATH 这个环境变量（必须使用绝对路径，并用os.pathsep 分隔）重置TZPATH
运行时也可以通过reset_tzpath() 重置TZPATH

##### 模块方法
available_timezones(): 类似all_timezones，返回一个set

##### ZoneInfo 类
实现了tzinfo 这个抽象基类

ZoneInfo(name): 返回一个时区对象实例，该实例会被缓存，因此可以使用is 进行比较（在调用时，会一次搜索TZPATH 中的路径找name 的文件，失败则会在 tzdata 包中查找匹配）
ZoneInfo.no_cache(name): 返回一个时区对象实例，不缓存

###### 实例
key: 构造时使用的name，默认的`__str__` 也将返回它，同样，进行序列化时，也只会序列化这个key（但反序列化则会取决于实例原本的生成方式）

### calendar 模块
isleap(year)：是否是闰年
leapdays(y1, y2)：返回y1, y2 两年之间的闰年个数
monthrange(year, month)：返回一个二元组(w, d)，w 是该月1号的星期码（0是星期一，6是星期日），d 是该月的天数
weekday(year, month, day)：返回指定日期的星期码（0是星期一，6是星期日）

### smtplib 模块
smtplib 模块主要通过SMTP类和其子类`SMTP_SSL`定义一个SMTP 客户端会话对象来完成邮件发送

`SMTP([host[, port[, local_hostname[, timeout]]]])`
如果提供了host 参数，将自动调用connect() 方法，连接指定的SMTP 服务器
port 是SMTP 服务的端口，默认是25

`SMTP_SSL([host[, port[, local_hostname[, keyfile[, certfile[, timeout]]]]]])`
其实例的行为和SMTP 的实例行为一致，仅当连接时必须使用SSL 时使用。
如果host未指定，则使用localhost；如果port忽略，则使用默认的SSL端口465；

#### 方法
1. `set_debuglevel(level=False)`：默认非调试模式，不会输出调试信息。
1. connect([host[, port]])：默认连接localhost 和默认的SMTP端口25。如果host以":number"结尾，则host将截去这部分，并解析为port。返回一个二元组(状态码，连接信息)
1. login(user, password)：当需要身份验证时调用之。
1. `sendmail(from_addr, to_addrs, msg[, mail_options, rcpt_options])`：发送邮件，只要有一个接收者正常接收，该函数就正常返回，否则将抛出异常。
`from_addr` 参数的格式必须是 RFC 822 的地址字符串；`to_addrs` 参数是该格式的字符串列表（如果只有一个的话，也可以是一个字符串）。msg是一个字符串，必须按照指定的格式指定发件人、收件人、标题、内容、附件等信息，通常使用email模块的类进行构造。
该函数返回一个字典，key是没有发送成功的`to_addr`，val是一个二元组`(SMTP_error_code, 错误信息)`
1. quit()：结束SMTP 会话并关闭连接

### email 模块
<https://docs.python.org/2/library/email.html>

### types 模块
标准解释器的类型名，也可以进行动态类型创建

#### 类型对象
IntType：等价int，Python3 移除
FloatType：等价float，Python3 移除
StringType：等价str，Python3 移除
ListType：等价list，Python3 移除
TupleType：等价tuple，Python3 移除
DictType：等价dict，Python3 移除

NoneType: None 的类型，即type(None)
NotImplementedType：NotImplemented 的类型
EllipsisType：Ellipsis 的类型

FunctionType
LambdaType
MethodType
GeneratorType: yield 函数
CoroutineType：async def 函数
AsyncGeneratorType：async def 函数 + yield
CodeType：例如 compile() 的返回值
CellType：用作函数中自由变量的容器
ModuleType

# 第八章. IO相关
## 1. 文件对象file
文件对象不仅可以访问普通的磁盘文件，还可以访问其他抽象的“类文件”。一旦设置了合适的“钩子”，就可以通过文件对象的接口访问其他文件，就好像访问普通文件一样。这是因为，文件就是一种字节流的抽象。

### 1.1 创建（打开文件）
#### 1.1.1 open()
```
open(file_name, access_mode = 'r', buffering=-1, encoding="utf-8")
```
`file_name`是打开文件名的字符串（可使用绝对路径和相对路径）
`access_mode`是打开模式，'r' 表示读取（默认，文件必须存在），'w' 表示覆写（没有则新建，有则清空原内容重写）， 'a' 表示追加（没有则新建）；可叠加的：'+' 表示读写（r+要求文件必须存在，w+若已存在会清空），’U’通用换行符支持（通常配合r和a，如果使用该选项打开文件，则在文件读入python时，无论原来的EOL是什么，都将替换为\n）， 'b'表示二进制访问（为了兼容非Unix的文本文件）
buffering：0表示无缓冲，1表示行缓冲（二进制模式无效），更大的数表示指定的缓冲大小（大约字节数），负值表示使用系统默认缓冲机制（io.DEFAULT_BUFFER_SIZE，通常是全缓冲）。
如果 open() 成功，一个文件对象会被返回。

Python 3.10 支持使用 encoding="locale" 来表示使用当前语言区域的编码格式

#### 1.1.2 file()
file(name, mode=’r’, buffering=1)
和open完全通用，推荐使用open()函数

### 1.2 属性
+ name：文件名
+ mode：打开模式
+ encoding：文件编码，None使用系统默认编码。当Unicode字符串被写入时，将自动使用该编码转换为字节字符串
+ closed：标记文件是否已经关闭
+ newlines：文件中使用的换行符模式（是一个tuple）
+ softspace：空格是否显示的标识，默认是false（表示输出数据后加上一个空格符，true表示不加）

### 1.3 方法
#### 1.3.1 关闭文件对象close()
尽管python的垃圾收集会在文件对象的引用计数减为0时自动关闭文件对象。但那可能会丢失缓冲区数据。

#### 1.3.2 读文件
+ read([size])：至多读取size个字节，返回字符串。若size缺省，则读到EOF为止。
+ readline([size])：至多读取size个字节，返回字符串。若size缺省，则读取一行（带换行符），若遇到EOF，则返回空串
+ readlines([size])：将文件按行读取，返回字符串列表。如果指定了size，则至多读取大约size个字节的行（这里是大约，因为，实际会读取多于size个字节，因为它会按size指定的大小，凑足内部缓冲的整数倍）
+ next()：为文件对象进行迭代。

#### 1.3.3 写文件
+ write(str)：向文件写入字符串str（不会带额外的换行）。由于buffer，需要调用flush或close才能刷新到文件。
+ writelines(str_iter)：将字符串迭代对象逐个写入文件（并不会写入额外的换行符）

#### 1.3.4 文件指针
+ seek(offset, whence=0)：whence是偏移基准，默认是0（文件头），还可以是1（当前位置），2（文件尾）。而offset是偏移量（单位字节），注意：如果是text模式打开文件，则不允许定位于文件尾之后的位置。此外，并不是所有文件对象都可以被seek的（比如以’a’模式打开的文件）。
+ tell()：返回当前读写文件偏移量（字节数）。

#### 1.3.5 杂项
+ truncate([size])：把文件裁成指定的大小（字节数），size默认是tell()的返回值。
+ fileno()：返回一个整型的文件描述符，用于底层的文件接口，如os.read()
+ isatty()：是否关联到一个类tty设备上
+ flush()：刷新内部的文件buffer（立即写到文件中）

### 1.4 遍历
文件对象是一个可迭代对象，使用for in 则遍历文件每一行（含行末的换行符。注：这里的文件读写调用C的文件读写函数，因此不必考虑系统行分隔符的差异，因为，即使在Windows下，’\n’也将被转换为’\r\n’）。
遍历的性能优于使用readlines遍历列表，因为readlines是一次性将文件读入，对于大文件需考虑内存的占用，而使用迭代方式一次仅仅会读取一行。

### 1.5 标准文件对象
标准输入sys.stdin（一般是键盘）
标准输出sys.tdout（到显示器的缓冲输出）
标准错误sys.tderr（到显示器的非缓冲输出）
这三个文件对象是预置的，无须打开，只要导入sys模块即可访问这三个对象。

## io 模块
IOBase <- RawIOBase <- FileIO
       <- BufferedIOBase <- BytesIO
                         <- BufferedReader <--|
                         <- BufferedWriter <- BufferedRandom
                         <- BufferedRWPair
       <- TextIOBase <- TextIOWrapper
                     <- StringIO

### StringIO/cStringIO
内存中文本流，可以使用文件读写的接口（当做文本读写）后者是C版本，更快一些，但不能被继承
StringIO(str)

getvalue(): 返回一个包含缓冲区全部内容的 str

### BytesIO
内存中二进制流，可以使用文件读写的接口（当做二进制读写）
BytesIO(bytes)

getbuffer(): 返回一个对应于缓冲区内容的可读写视图而不必拷贝其数据
getvalue(): 返回包含整个缓冲区内容的 bytes

## 2. os 模块
该模块实际上只是真正加载的模块的前端，而真正加载的模块与具体的操作系统有关，比如：posix（适用于Unix）、nt（Win32）、mac（旧版的MacOS）、dos（DOS）、os2（OS/2）等。不需要直接导入这些模块，只需导入os 模块，Python会自动选择正确的模块。（根据某个系统支持的特性，可能无法访问到一些在其他系统上可用的属性）

### 2.1 模块属性
name		系统类型：posix（Unix/Linux/新版mac）nt（Windows）, 想要区分Linux 和Mac 可以使用sys.platform（构建时指定的）或platform.system()（执行uname 和相关函数确认）
linesep        系统的行分隔符。（如Windows使用'\r\n'，Linux使用'\n'）
sep            用来分隔文件路径名的字符串
pathsep        多个路径之间的分隔符（如Windows使用’;’，Linux使用’:’）
extsep         文件名和扩展名之间的分隔符
curdir        返回当前目录（’.’）
pardir        返回当前目录的父目录（’..’）
environ       当前环境变量的一个字典

### 2.2 模块方法
#### 2.2.1 文件与目录
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
+ rmdir(path)                删除一个目录（也有一个递归版本：removedirs，它会按path由右向左依次调用rmdir，直到整个path都被删除 或 遇到错误，该错误将被忽略，因为它一般是因为已经不满足删除条件，即非空目录）
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

#### 2.2.2 环境
+ getenv(key, default=None)    返回由字符串key指定的环境变量的值，如果不存在该环境变量则返回default
+ putenv(key, value)            设置或变更一个环境变量
+ umask(new)                设置新的umask，并返回之前的mask

#### 2.2.3 进程
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

#### 2.2.4 杂项
tmpfile()                    返回一个临时文件对象（close文件对象时删除）
tmpnam()                返回一个唯一的临时文件名
tempnam([dir,[, prefix]])        返回一个唯一的临时文件名（带前缀和路径的版本）
urandom(n)                返回一个n字节的随机字符串（用于加密用途）
mkfifo

### 2.3 子模块os.path
#### 2.3.1 模块方法
+ basename(path)            去掉路径，返回文件名
+ dirname(path)                去掉文件名，返回目录（不含最后一个os.sep）
+ split(path)                按当前的os.sep属性将path分割成为一个(dirname, basename)的二元组。分割位置为path中最右的os.sep（若没有os.sep，则二元组第一个元素为空串；如果是以os.sep结束的，则二元组第二个元素为空串）
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
+ realpath(filename)        返回指定文件的绝对路径（会对符号链接进行解析到真实路径）
+ normpath(path)            返回指定路径的规范字符串形式（滤除多余的os.sep）
+ expanduser(path)            将路径中的~或~user转换为对应用户的主目录后的path的绝对路径（如果用户未知或$HOME未定义，则不返回）
+ expandvars('$HOME')

## 3. Unix样式的通配符
支持 Unix样式的通配符（`*` ? `[]` `[!]`），对于这些元字符，要表示字面值，可以将其放在`[]`中

Python3.5+ 通配符还支持`**`，例如`/path/**/*.jpg` 可以表示0个或多个中间目录：
```
/path/*.jpg
/path/*/*.jpg
/path/*/*/*.jpg
/path/*/*/*/*.jpg
...
```

### glob 模块
该模块只有 2个函数：glob(path) 和 iglob(path)
它们的行为就像shell 中的ls 命令一样，后者和前者的区别是后者返回的是一个迭代器而前者是一个列表

### fnmatch 模块
和 glob 的区别是它不会把`/` 和文件开头的`.` 特殊处理
+ fnmatch(filename, pattern)：使用os.path.normcase 把filename 进行处理后，和pattern进行匹配，返回是否匹配
+ fnmatchcase(filename, pattern)：大小写严格匹配
+ filter(names, pattern)：相当于`[n for n in names if fnmatch(n, pattern)]`
+ translate(pattern)：将pattern 转换为正则字符串，可以使用re.compile 处理

## pathlib 模块（Python3.4+ 支持）
可以替代os.path 库，更方便处理文件路径

### Path 类
不可变并可哈希的。相同风格的路径可以排序与比较。这些性质尊重对应风格的大小写转换语义
```py
from pathlib import Path
home = Path.home() # HOME 目录
cur_p = Path.cwd() # 返回当前目录
path_root = Path('/path/to/datas/')

cur_p.drive  # 磁盘驱动号，仅在win 下非空
cur_p.root   # 根，即'/'
cur_p.anchor # 自动判断返回drive 还是root
cur_p.name   # 文件（夹）名
cur_p.parent # 上一级目录（还有parents 返回一个Seq，从上一级目录，直到根目录）
cur_p.parts  # 从anchor 到 name 按目录分割为元组
cur_p.suffix # 文件后缀
cur_p.stem  # name 去掉 suffix 的部分
cur_p.suffixes # 例如：tmp.tar.gz 返回['.tar', '.gz']

# 解析显示
cur_p.as_uri() # URI 格式
cur_p.resolve() # 返回真实的绝对路径（会解析符号连接，并使用系统对应的分隔符）
cur_p.relative_to(cur_p.home()) # 返回相对路径

# 修改
file = path_root / 'test'  # 路径连接，也支持/=
cur_p.joinpath(*list)   # 路径连接，可以连接多个
file.with_name('aa') # 修改name（只是Path对象的变更，不实际修改文件）
file.with_suffix('.txt') # 仅修改suffix（只是Path对象的变更，不实际修改文件）
file.replace('td') # 移动文件或文件夹，若目标文件或文件夹存在，则会覆盖（文件夹需要非空，否则报错），返回改名后的Path 对象
# 不能跨磁盘驱动器移动，此时应该使用shutil.move
# rename 方法和它类似，但效果依赖环境

# 遍历
file.iterdir()   # 当前路径下的子文件（夹），返回一个生成器
file.glob('*.py')  # 使用通配符，搜索当前路径
file.rglob('*.py') # 使用通配符，对当前路径下进行递归搜索

# 操作
file.touch() # 创建文件，若exist_ok=False，则当文件存在，会抛FileExistsError
file.open() # 默认只读打开，可以使用mode 指定
file.read_text/read_bytes/write_text/write_bytes 可以直接操作文件（write 会覆写），不用打开关闭
file.unlink() # 删除文件
file.stat() # 返回文件详情（st_size文件大小，st_ctime创建时间，st_mtime修改时间，st_atime访问时间）
file.chmod(777)  # 修改文件权限
cur_p.mkdir() # 创建文件夹，默认值创建一层，除非设置parents=True，则创建多层
cur_p.rmdir() # 删除空文件夹，如果非空想要递归删除，使用shutil.rmtree()

# 判断
file.exists()  # 路径是否存在
file.is_dir()  # 判断是否为文件夹
file.is_file()
file.match(pattern) # 判断是否满足指定模式
```

## shutil 模块
高级文件访问功能（比如复制文件、复制文件权限、目录树递归复制）
+ move( src, dst)  移动文件或重命名
+ copyfile( src, dst) 从源src复制到dst中去。当然前提是目标地址是具备可写权限。抛出的异常信息为IOException. 如果当前的dst已存在的话就会被覆盖掉
+ copymode( src, dst) 只是会复制其权限其他的东西是不会被复制的
+ copystat( src, dst) 复制权限、最后访问时间、最后修改时间
+ copy( src, dst)  复制一个文件到一个文件或一个目录
+ copy2( src, dst)  在copy上的基础上再复制文件最后访问时间与修改时间也复制过来了，类似于cp –p的东西
+ copy2( src, dst)  如果两个位置的文件系统是一样的话相当于是rename操作，只是改名；如果是不在相同的文件系统的话就是做move操作
+ copytree( olddir, newdir, True/Flase) 把olddir拷贝一份newdir，如果第3个参数是True，则复制目录时将保持文件夹下的符号连接，如果第3个参数是False，则将在复制的目录下生成物理副本来替代符号连接
+ rmtree( src ) 递归删除一个目录以及目录内的所有内容

## 3. subprocess 模块
用于调用shell（为了代替os.system/`os.popen*`/`os.spawn*`/`popen2.*`/`commands.*`）
该模块提供了一个类和三个简易函数
对于Python3.5+一般推荐直接使用run 这个模块函数
```py
run(args, *,
    input=None, capture_output=False, stdin=None, stdout=None, stderr=None,
    shell=False, cwd=None, env=None, timeout=None, check=False,
    encoding=None, errors=None, text=None, universal_newlines=None, **others)
```
args是一个字符串或序列（若文件名中包括空白符或转义字符则用序列格式更好），就是要执行的命令行内容
input 必须是一个字节序列，不过如果指定了encoding 或errors 或者text=True，也可以是一个字符串。该参数会将stdin=PIPE，所以不能自己指定stdin了
capture_output 若为True，则将stdout=PIPE 和 stderr=PIPE，所以就不能自己指定stdout 和stderr 了
stdin、stdout、stderr可以指定命令的标准输入输出，可以使用常量PIPE（将创建与子进程的管道，可以进行输入和获得输出）、DEVNULL（使用os.devnull）、文件对象、文件描述符（一个整数）或None（从父进程继承）。（其中stderr也可以指定为常量STDOUT，则等价于2>&1）
shell 若为True，则将使用shell 执行命令，能使用shell的管道、通配符、环境变量展开、`~`展开到HOME 目录等特性，此时args推荐使用字符串。否则则需要使用Python的glob, fnmatch, os.path.expandvars(), os.path.expanduser() 和 shutil 来实现。
cwd 修改命令执行的当前目录，可以是字符串或路径对象
env 可以指定一个字典，为新的进程设置环境变量（是替换而非新增）
timeout 设置子进程的超时时间（单位秒），超时将杀死子进程后抛TimeoutExpired 异常
check 若为True，则将检查命令返回状态码，若非0，则抛出CalledProcessError 异常，这个异常包含了参数，退出码，stdout和stderr
默认文件对象都以二进制模式打开，除非指定了encoding 或errors 或者text=True，才以文本模式打开

若命令完成，返回一个CompletedProcess 实例
+ args：run 的首个参数
+ returncode：子进程的退出状态码。一个负值 -N 表示子进程被信号 N 中断 (仅 POSIX).
+ stdout、stderr
+ check_returncode()：如果 returncode 非零, 抛出 CalledProcessError

### 3.1 Popen类
```py
class Popen(
	args,
	bufsize=-1, executable=None,
	stdin=None, stdout=None, stderr=None,
	preexec_fn=None, close_fds=False,
	shell=False, cwd=None, env=None,
	universal_newlines=False,
	startupinfo=None, creationflags=0,
    restore_signals=True, start_new_session=False, pass_fds=(), *, group=None, extra_groups=None, user=None, umask=- 1, encoding=None, errors=None, text=None, pipesize=- 1)
```
args是一个字符串或序列，用以描述命令（因为它包含了args[0]即执行的命令）
bufsize同open函数的buffering参数，是为stdin/stdout/stderr 管道文件提供的缓冲
executable可以指定执行程序，比如可以指定某个具体的shell（若未指定，则由args[0]决定）
stdin、stdout、stderr 同run 函数参数
`preexec_fn`是一个可执行对象，它将在子进程创建时执行（仅 POSIX）
`close_fds`若为True，则在子进程执行前除0/1/2外的所有文件描述符都将被关闭
shell若为True，则args通过shell执行，此时推荐使用字符串，在 POSIX 默认为 /bin/sh，在Windows则使用COMSPEC环境变量指定的shell。否则通过os.execvp执行，即使args是一个字符串，也被视为只有一个元素的序列。
cwd可以指定子进程执行的工作目录
env可以指定子进程的环境变量（默认从父进程继承），可以指定一个str:str的字典
`universal_newlines`若为True，则stdout、stderr都将被认为”t”打开，并且不再被Popen对象的communicate()方法更新。
startupinfo、creationflags是Windows接口特定的参数
restore_signals, start_new_session, pass_fds, group, extra_groups, user, umask 这些都是POSIX 专属参数

#### 3.1.1 Popen对象的属性
stdin、stdout、stderr，仅当设置为PIPE可获得，否则为None
pid子进程的进程id
returncode：None表示进程还没结束，负值-N表示子进程已被信号N终止，其他是子进程的正常返回值

#### 3.1.2 Popen对象的方法
+ poll()：若子进程已终止，返回当前returncode，否则返回None
+ wait(timeout=None)：等待子进程结束，返回returncode，若超时则抛TimeoutExpired。当子进程stdout=PIPE 或者 stderr=PIPE并产生了足以阻塞 OS 管道缓冲区的数据就会产生死锁。此函数使用busy loop 实现，可以使用 asyncio 模块进行异步等待
+ kill()：用SIGKILL杀死子进程
+ terminate()：用SIGTERM结束子进程
+ send_signal(sig)：给子进程发送一个信号量sig
+ communicate(input=None, timeout=None)：input是一个字符串/字节串（取决于管道打开模式），可以将其发给子进程作为stdin（需要是PIPE），而后等待子进程结束，返回(stdout, stderr)的二元组（需要是PIPE，内容为字符串/字节串，取决于管道打开模式）。若超时则抛TimeoutExpired，捕获后不会丢失任何输出。注意：当数据量比较大时，不要用该方法，因为内存里数据读取是缓冲的。

### 3.2 模块函数
三个简易函数call、`check_call`、`check_output`（Python3.5-使用）
它们的参数和Popen的一致，都等待子进程执行结束
call直接返回returncode
`check_call`仅当0才返回，其他都抛出CalledProcessError异常，可以访问该异常对象的returncode属性获取返回值
`check_output`如果正常返回（0）返回执行命令的输出；如果返回值非0，则抛出CalledProcessError异常，可以访问该异常对象的returncode属性获取返回值，output属性获得标准输出

### 异常基类SubprocessError
TimeoutExpired：
+ cmd：创建子进程的指令
+ timeout：超时秒数
+ output：子进程的输出
+ stdout、stderr

CalledProcessError
+ returncode
+ cmd：创建子进程的指令
+ timeout：超时秒数
+ output：子进程的输出
+ stdout、stderr

### 实例
```sh
output=$(dmesg | grep hda)
```
可以替换为
```py
p1 = Popen(["dmesg"], stdout=PIPE)
p2 = Popen(["grep", "hda"], stdin=p1.stdout, stdout=PIPE)
p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
output = p2.communicate()[0]
# 或
output = check_output("dmesg | grep hda", shell=True)
```
shell 命令字符串的安全性需要自己保证，小心注入

## 4. tempfile 模块
用于创建临时文件（os.tmpfile使用的是系统调用，而tempfile模块是基于python而且有更多的选项可以控制）

### 4.1 模块属性
template：所有临时名的前缀，默认是'tmp'
tempdir：临时文件的存放目录，可以在使用本模块以下函数前设置，默认是环境变量TMPDIR, TMP, TEMP指定的目录，如果没有定义这些环境变量，则为当前工作目录。

### 4.2 模块函数
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

## 5. fcntl
### 5.1 模块函数
flock(fd, op)：fd可以是文件描述符，也可以是带有fileno()方法的文件对象；op可以是LOCK_SH（共享锁）、LOCK_EX（互斥锁）、LOCK_UN（移除该进程持有的锁），以上的锁可以和LOCK_NB联用，表示非阻塞请求。申请不到锁会阻塞当前进程。注：文件的 close() 操作会使文件锁失效；同理，进程结束后文件锁失效

## 6. 数据持久化
### 6.1 序列化
pickle 和 marshal 模块

#### 6.1.1 共性
都可以将很多种Python数据类型序列化为字节流以及反序列化。

序列化格式是Python特定的，与机器架构无关的。优点是没有外部标准的限制，可以跨平台使用，缺点是序列化结果无法用于非Python程序反序列化。
pickle有三种序列化格式协议：
0：ASCII表示，可读性好，但空间和时间性能都不好。（默认）
1：旧式的二进制格式，兼容旧版本的Python。
2：Python 2.3引入的新的二进制格式，序列化新式的class更有效。
如果给的协议号为负或`pickle.HIGHEST_PROTOCOL`都表示使用最大的协议号。

这两个模块只负责序列化，并不保证对数据源序列化时的安全性，并不处理持久化对象及其并发访问的问题。但也因此可以灵活的将其用于持久化文件、数据库、网络传输。

#### 6.1.2 对比
marshal是更原始的序列化模块，其存在的目的主要是为了支持Python的.pyc文件。

pickle比其优越在于
+ pickle会跟踪已序列化的对象，因此可以处理循环引用和对象共享；
+ pickle可以序列化自定义对象，而想要反序列化必须使用相同的类定义；
+ pickle的序列化格式针对Python版本向后兼容，而marshal为了支持Python的.pyc文件并不保证向后兼容。
cPickle是pickle的C实现版，比其快1000倍。它们有着相同接口，除了Pickler()和Unpickler()这两个类都作为函数来实现，因此，就不能通过继承该类实现自定义的反序列化。而且，它们序列化成的字节流也是可以互通的。

#### 6.1.3 pickle
通常，要序列化就要创建Pickler对象并调用其dump()方法，要反序列化就要创建Unpickler对象并调用其load()方法。但pickle模块提供了更简易的函数：
+ dump(obj, file[, protocol])
序列化，等价于Pickler(file, protocol).dump(obj)，obj是待序列化对象，file是一个带有write(str)方法的类文件对象，protocol就是上面提到的序列化格式协议。
+ load(file)
反序列化，等价于Unpickler(file).load()，file是一个必须有read(size)和readline()方法的类文件对象，该函数能自动识别序列化协议格式。
此外，还有
+ dumps(obj[, protocol])
+ loads(data)
两个函数，用于直接序列化为字符串和从字符串中反序列化（Python3 中为bytes 类型）

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

### 6.2 dbm
#### 6.2.1 anydbm
anydbm是多种不同dbm实现的统一接口，比如dbhash（需要bsddb），gdbm，dbm，dumbdbm。它能够通过whichdb模块选择系统已安装的“最好”的模块，只有当都没有安装时，才使用dumbdbm 模块，它是一个简单的dbm的实现。

open(filename, flag=’r’ [, mode])
打开一个dbm文件，名为filename，如果文件已存在，就使用whichdb模块来确定其类型，并使用相应的模块。如果文件不存在，就按上面列出的顺序选择一个导入。
flag表示文件的打开方式：’r’表示只读（已存在的文件），’w’表示读写（已存在的文件），’c’表示读写，如果文件不存在则创建，’n’表示总是创建一个空文件。
mode表示创建dbm文件的访问权限，默认是0666（可能被umask修改）
函数返回一个类字典对象，只不过键值都必须是字符串。（另外，不能print、不支持values()和items()方法）
使用完毕后用其close()方法关闭。

#### 6.2.2 whichdb
whichdb模块只有一个函数：
whichdb(filename)：如果指定文件名的文件不存在，返回None；如果无法确定返回空串；否则返回确定具体dbm模块名的字符串，如下：
~~dbhash（需要bsddb）：BSD的dbm接口，dbhash是统一的接口，bsddb则是Berkeley DB库的接口~~（2.6后已废弃）
gdbm：GNU的dbm接口，基于ndbm接口，但文件格式和dbm并不兼容。
dbm：标准的Unix的ndbm接口（library属性，可以查看使用的库名），自动加.db扩展名
dumbdbm：dbm接口的可移植实现（完全python实现，不需要外部库），自动加.dat或.dir扩展名

#### 6.2.3 gdbm
gdbm模块还有三个附加flag（并非所有版本都支持，可以通过查看模块的open_flags属性查看支持的flag），可以附加在上面四种flag之后：
‘f’快速写模式（不同步文件），’s’同步模式（每次写都同步文件），’u’不对文件加锁。
它返回的对象还支持以下方法：
firstkey()和nextkey(key)用于遍历key，顺序是按内部的哈希值进行排序。
reorganize()，压缩文件大小（因为默认的删除操作并不减小文件大小，而留作后续添加用）
sync()，用于’f’模式打开的文件，进行手动同步。

#### 6.2.4 dbhash/bsddb
dbhash模块还有一个附加flag，可以附加在上面四种flag之后：
‘l’加锁模式。
它返回的对象还支持以下方法：
first()、last()和next(key)、previous()用于遍历kv对，顺序是按内部的哈希值进行排序。
sync()，进行强制同步。
bsddb模块可以创建hash、btree和基于记录的文件。

#### 6.2.5 dumbdbm
dumbdbm.open的flag是被忽略的，总是以不存在则创建，存在则更新的模式打开。
它返回的对象还支持以下方法：
sync()，进行强制同步。

### 6.3 shelve
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

### 6.4 数据库
简单的可以使用DB-API 2.0 interface
需要ORM可以使用SQLObject，SQLAlchemy，Django自带的ORM
[参考](http://smartzxy.iteye.com/blog/680740)

#### 6.4.1 MySQLdb（第三方）
[下载](https://pypi.python.org/pypi/MySQL-python/) [文档](http://mysql-python.sourceforge.net/MySQLdb.html)
底层直接调用了 MySQL 提供的原生库作为处理网络的机制，因此不能享受 gevent 的性能红利。不过此库已经很久没有维护，并且也不支持 python3，因此现在不建议使用。其2.0 版本更名为[moist](https://github.com/farcepest/moist)


#### 6.4.2 PyMySQL（第三方）
Python3 使用，支持的特性更多，并且使用纯 python 编写。
`pymysql.install_as_MySQLdb()` 该语句可以后续`import MySQLdb` 或`import _mysql` 都实际使用的是pymysql（因为他们API 基本一致，类似猴子补丁）
##### 安装
```
pip3 install PyMySQL
# 或
git clone https://github.com/PyMySQL/PyMySQL
cd PyMySQL/ && python3 setup.py install
```

##### 使用
模块函数：
+ connect(host, user, passwd[, db, port, charset])
连接数据库，返回一个连接对象，其中，数据库名db可以省略，可以使用连接对象的select_db方法，或使用sql命令use来指定；port是MySQL使用的TCP端口，默认是’3306’，charset是数据库编码。
+ escape_string(str)：

连接对象的方法：
+ select_db(db)
+ cursor(cursorclass=None)：获取游标对象，默认的游标对象SQL查询返回的结果是tuple of tuple，如果设置为MySQLdb.cursors.DictCursor，则SQL查询返回的结果是tuple of dict（该操作会默认开始一个隐形的事务）
+ query(sql)：不用游标对象，直接执行sql语句，返回受影响的行数
+ commit()：对于支持事务的数据库引擎（如InnoDB引擎，而mysiam引擎则不是），执行游标对象对数据库的所有改动（增删改，不包括truncate table），如果在数据库连接关闭前没有执行该方法提交，则这些改动不会生效。
+ rollback()：如果sql执行失败（会有异常抛出），需要回滚以确保数据库一致性。
+ ping()：检查连接是否关闭，如果关闭将自动重连
+ close()：断开数据库连接

游标对象的方法：
+ execute(query, args=None)：执行sql语句query（其中可以包含字符串格式化的占位符），args就是填充占位符的序列，返回受影响的行数。（之所以这样使用，而不是直接使用字符串格式化，是因为那样并不安全，容易受到SQL注入攻击）
+ executemany(query, args)：query同上，args是一个填充占位符的序列的序列，每一个内部序列都可以填充占位符成为一个完成的sql语句，该方法就对这个外部序列重复执行多次sql，返回受影响的行数。
+ nextset()：移动到下一个结果集，返回True，如果没有下一个则返回None。
+ callproc(procname, args=None)：执行一个存储过程，args为存储过程的参数序列，返回受影响的行数。
+ fetchall()：获取执行sql语句返回的结果集（若前面已经获取，则获取余下的），如果有结果，则返回一个元组的序列（每个元组表示一行）。
+ fetchmany(size=None)：返回指定行数的结果集，若size=None或大于实际的行数，则返回cursor.arraysize（默认是1）行数据
+ fetchone()：返回结果集中的下一行。
+ scroll(value, mode='relative')：移动游标value行，’relative’表示相对当前行，’absolute’表示相对第一行。
+ close()：
此外，还有一个只读属性：rowcount，表示执行execute后受影响的行数。

#### 6.4.3 sqlite3
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

### 6.5 其他
+ ZODB：一个健壮的、多用户和面向对象的数据库系统，它能够存储和管理任意复杂的python对象，并提供事务操作和并发控制支持；
+ Durus：Quixote团队的作品，可以看作是轻量级版本的ZODB实现，纯开源的Python实现，并提供一个可选的C语言插件类；
+ Missile BD：是一种Python的、简洁高效的DBMS，适用于Stackless Python环境。同时需要说明的是它是并发性能极高的Eurasia3项目的一个子项目；
+ ODB（spugdb）:一个轻量级的纯Python实现的Python对象数据库系统，支持嵌套事务、对象模型、游标和一个简单的类似X-Path的查询语言，它的前身只是围绕Berkeley DB做的Python包装，现在已逐步淘汰对Berkeley DB的支持；
+ PyPerSyst：它是由用java实现的Provayler到Python的移植实现，PyPerSyst将整个对象系统保存在内存中，通过将系统快照pickle到磁盘以及维护一个命令日志（通过日志可以重新应用最新的快照）来提供灾难恢复。因此PyPerSyst应用程序会受到可用内存的限制，但好处是本机对象系统可以完全装入到内存中，因而速度极快；
+ PyDbLite：Python实现的快速的、无类型的内存数据库引擎，使用Python语法代替SQL语法，支持Python2.3以及以上版本，同时提供对SQLite和MySQL支持；
+ buzhug：Python实现的快速的数据库引擎，使用Python程序员觉得直观的语法，数据存储在磁盘上；
+ Gadfly：它是一个简单的关系数据库系统，使用Python基于SQL结构化查询语言实现。

## 7. 相关模块
tarfile        访问tar归档文件，支持压缩
zipfile        访问zip归档文件的工具
gzip/zlib        访问GNU zip（gzip）文件（压缩需要zlib 模块）
bz2            访问bz2格式的压缩文件
filecmp        比较目录和文件
fileinput        多个文本文件的行迭代器

# 第九章. 异常
面对错误，应用程序应该成功的捕获并处置，而不至于灾难性的影响其执行环境。

## 1. 异常结构
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

### 1.1 异常处理
#### 1.1.1 无异常
正常执行 try 块所有代码；如果有 else，执行对应代码块；最后，执行finally
#### 1.1.2 有异常
忽略 try 块中触发点之后的剩余代码；
寻找第一个匹配的处理器except（当前域没有匹配的except，会退栈跳到调用者寻找，如果在顶层仍为找到，这个未处理的异常会导致程序退出，Python解释器会打印traceback信息，然后退出），执行代码块;
最后，执行finally

### 1.2 特殊结构
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

### 1.3 sys.exc_info()
返回最近一次被捕获的异常信息
该异常信息是一个三元组：(异常类，异常实例，traceback对象)
其中traceback对象提供发生异常的上下文，如代码的执行frame和发生异常的行号等

### 1.4 sys.excepthook(type, value, traceback)
解释器使用函数处理未捕获的异常，即将异常信息打印到sys.stderr 而后退出，三个参数分别是异常类、异常实例和一个回溯对象

### traceback 模块
print_exception(e, value=_s, tb=_s, limit=None, file=None): 打印异常堆栈信息，默认按由外到内（从调用方到被调用方）排列堆栈，如果指定limit 就仅展示栈顶前若干项；不指定file，则默认输出到sys.stderr
print_exc(limit=None, file=None): 相当于print_exception(*sys.exc_info(), limit, file)
print_tb(tb, limit=None, file=None): 只打印堆栈信息，不打印异常信息

format_exception(e, value, tb) -> str
format_exc() -> str
format_exception_only(e) -> str: 只格式化异常，不返回堆栈信息
format_tb(tb) -> str

## 2. 抛异常
`raise SomeException, args, traceback [from ex]`
三个参数都是逆序可选的
如果有SomeException参数，则它必须是一个字符串、类或实例
如有args，可以是一个对象（通常是一个字符串指示错误的原因），也可以是一个元组（一个错误编号，一个错误字符串，一个错误的地址，等）
如果有traceback，是一个用于exception-normally的traceback对象，当你想重新引发一次是，第三个参数很有用（区分当前和先前的位置）
from ex 一般用于except 中捕获到一个ex 异常而后抛出另一个异常而建立关联（通过新异常的`__cause__` 属性），因为如果except 中抛出另一个异常没有建立关联则认为在处理异常中又触发了另一个异常（该异常的`__context__`会记录原异常）。ex 可以是一个异常类或异常实例或None（会设置异常的`__suppress_context__`=True，从而`__context__` 就不会记录原异常，那么异常栈就不会有原异常）。

**注**：
如果SomeException是一个实例，那么就不能用其他的参数
如果SomeException是一个字符串（不建议），那么就触发一个字符串异常
如果这个args是一个异常类的实例，则不能有更多参数。如果其不是SomeException类或其子类的实例时,那么解释器就使用该实例的异常参数创建一个SomeException类的新实例
如果args不是一个异常类的实例，那么它将作为SomeException类的实例化参数列表
如果三个参数都没有，则引发当前代码块最近触发的一个异常，如果之前没有异常触发，会因为没有可以重新触发的异常而生成一个TypeError异常。

## 3. 异常关系结构
创建一个新的异常仅需要从一个异常类中派生一个子类

内置异常继承树
```
BaseException 所有异常的基类
 +-- SystemExit 表示程序退出，默认会被忽略
 +-- KeyboardInterrupt 表示Ctrl+C，用户中断
 +-- GeneratorExit 生成器已启动未结束前被销毁（比如显式del gen），可以在生成器中捕获该异常，用于生成器的善后处理
 +-- Exception 常规异常基类（非控制类异常，即程序存在某种问题，Python2 中叫做StandardError）
      +-- StopIteration 迭代器或生成器函数退出时抛出该异常，该异常有一个value 属性，就是生成器函数的返回值
      +-- StopAsyncIteration
      +-- ArithmeticError
      |    +-- FloatingPointError
      |    +-- OverflowError
      |    +-- ZeroDivisionError
      +-- AssertionError 断言失败的异常
      +-- AttributeError 即 obj.attr获取属性异常
      +-- BufferError
      +-- EOFError
      +-- ImportError
      |    +-- ModuleNotFoundError
      +-- LookupError
      |    +-- IndexError
      |    +-- KeyError
      +-- MemoryError
      +-- NameError
      |    +-- UnboundLocalError
      +-- OSError 操作系统环境异常的基类（Python3.3 之前叫做EnvironmentError）
      |    +-- BlockingIOError
      |    +-- ChildProcessError
      |    +-- ConnectionError
      |    |    +-- BrokenPipeError
      |    |    +-- ConnectionAbortedError
      |    |    +-- ConnectionRefusedError
      |    |    +-- ConnectionResetError
      |    +-- FileExistsError
      |    +-- FileNotFoundError
      |    +-- InterruptedError
      |    +-- IsADirectoryError
      |    +-- NotADirectoryError
      |    +-- PermissionError
      |    +-- ProcessLookupError
      |    +-- TimeoutError
      +-- ReferenceError
      +-- RuntimeError
      |    +-- NotImplementedError 抽象方法可以抛该异常，确保该方法必须被重写
      |    +-- RecursionError
      +-- SyntaxError
      |    +-- IndentationError
      |         +-- TabError
      +-- SystemError
      +-- TypeError
      +-- ValueError
      |    +-- UnicodeError
      |         +-- UnicodeDecodeError
      |         +-- UnicodeEncodeError
      |         +-- UnicodeTranslateError
      +-- Warning 警告类的基类
           +-- UserWarning 函数 warn() 的默认类别
           +-- DeprecationWarning 用于已弃用功能的警告（默认被忽略）；可以直接使用typing_extensions.deprecated(msg) 这个装饰器
           +-- PendingDeprecationWarning 对于未来会被弃用的功能的警告（默认将被忽略）
           +-- RuntimeWarning 用于有关可疑运行时功能的警告
           +-- SyntaxWarning 用于可疑语法的警告
           +-- FutureWarning 对于未来特性更改的警告
           +-- ImportWarning 导入模块过程中触发的警告（默认被忽略）
           +-- UnicodeWarning 与 Unicode 相关的警告
           +-- BytesWarning 与 bytes 和 bytearray 相关的警告 (Python3)
           +-- ResourceWarning 与资源使用相关的警告(Python3)
```

## 4. 断言
断言是一句必须布尔判断为真的判断，否则就触发AssertionError
assert expression[, arg]
expression是这个判断的表达式，arg提供给AssertionError作为参数，进行异常构建

## 5. 警告
warnings 模块
可以产生警告、过滤警告、或者转为异常

命令行也可以控制警告过滤器。可以在启动 Python 解释器的时候使用 -W 选项（格式：action:message:category:module:lineno，部分空缺则使用默认值）。

### 函数
+ warn(msg, category=None, stacklevel=1, source=None): 将category警告类（默认是UserWarning）和信息（可以是字符串，也可以是Warning类的一个子类实例，这时将忽略category参数）打到sys.stderr（默认，有钩子可以改变这个行为）
+ filterwarnings(action, message='', category=Warning, module='', lineno=0, append=False): 添加警告过滤规则（默认加到规则头部，append=True，则追加到尾部），message 和module 可以指定正则表达式（使用match匹配，message不区分大小写，module区分大小写）lineno=0 默认匹配所有行号，跟命令行`-W` 参数功能类似
+ simplefilter(action, category=Warning, lineno=0, append=False): 简易过滤，无需正则
+ resetwarnings(): 重置警告过滤规则（包括函数增加的和`-W`选项指定的）
+ showwarning(msg, category=None, filename, lineno, file=None, line=None): 警告消息输出到文件file（默认sys.stderr）line 是包含在警告消息中的一行源代码，如果未提供则尝试读取由 filename 和 lineno 指定的行；其默认实现通过调用 formatwarning() 格式化消息，它也可以由自定义

action 可以取以下值(str)：
default: 同一位置的警告只输出一次
always: 始终输出
module: 一个模块的相同文本只输出一次
once: 相同文本只输出一次
error: 转为异常
ignore

## 6. 资源自动释放
```py
with context_expr [as var]:
    code_suite

# python3.10 支持多个context_mng
with (
    CtxManager1() [as example1],
    CtxManager2() [as example2],
    CtxManager3() [as example3],
):
    ...
```
例如：
```py
with open(name, ‘rb’) as input:
    data = input.read()
```
context_expr返回一个上下文管理器赋值到var，上下文管理器是一个拥有`__enter__()`方法和`__exit__()`方法的对象，主要作用于共享资源，`__enter__()`和`__exit__()`方法基本和资源的分配和释放有关（如数据库连接、锁、信号量、状态管理、文件）比如：
file
decimal.Context
thread.LockType
threading.Lock
threading.RLock
threading.Condition
threading.Semaphore
threading.BoundedSemaphore

若context_expr 就是一个构造函数调用，则构造函数会先于`__enter__()`方法被调用
~~上下文对象是通过`__context__()`获得的~~
~~而上下文对象本身就是上下文管理器，因此该对象就有上面的方法~~
1. 一旦获得了上下文对象，就会调用其`__enter__(self)`方法，完成with语句块执行前的准备工作，如果提供了as，就用该方法的返回值来赋值；
2. 而后执行with语句块，执行结束后就会调用上下文对象的`__exit__(self, exc_type, exc_val, exc_tb)`方法，该方法后三个参数：异常类型，异常实例，traceback对象（即sys.exc_info()函数返回的三个值），如果没有异常发生，三个参数都是None；否则就被赋以异常的上下文环境，从而在`__exit__()`里处理异常。如果该函数返回一个布尔测试为False的值，则异常将抛给用户进行处理，如果想屏蔽这个异常，则返回一个布尔测试为True的值（如果没有异常返回的也是True）

### contextlib 模块
该模块可以帮助你编写对象的上下文管理器，它包含了实用的functions/decorators，可以不用关心上面这些下划线方法的实现。
+ contextmanager: 简化上下文管理器的写法
+ closing: close() 协议的上下文管理器
+ suppress: 忽略报错的上下文管理器
+ redirect_stdout, redirect_stderr: 标准IO 的重定向
+ ExitStack: 动态上下文堆栈的管理器
```py
@contextlib.contextmanager
def get_ctx(i)
    enter_process()
    yield ctx(i)
    exit_process()

@get_ctx(1)  # 被contextmanager 装饰的函数，也会变成一个有参装饰器，可以装饰其他函数，对被装饰函数进行包装
def demo():  # 但不能传递，即demo 不能作为装饰器
    ...
# 调用demo()相当于
with get_ctx(1):
    demo()

from contextlib import closing  # exit 自动调用close() 方法
with closing(urlopen('https://www.python.org')) as page:
    pass

with contextlib.suppress(NonFatalError):    # 可以在下面的语句块中忽略指定的异常
    pass

from contextlib import redirect_stdout, redirect_stderr
capture = io.StringIO()
with redirect_stdout(capture), redirect_stderr(capture):
    print_func(5)

with contextlib.ExitStack() as stack:
    @stack.callback
    def callback():     # stack.callback 可以直接作为装饰器进行回调注册，但无法指定参数
        pass

    for i in range(n):
        stack.enter_context(get_ctx(i)) # 先依次执行每个context的enter，在语句块退出时，再反序执行每个context 的exit
    stack.callback(func1, *args)
    stack.callback(func2, *args)    # 上下文结束时，逆序执行func2 -> func1
    do_something()
```
contextmanager 会将上下文管理的区域内抛出的异常进行回收，重新在yield 语句位置进行抛出
可以try-except 进行处理，然后正常退出抛StopIteration异常，该异常会被抑制（return True）
也可以不做处理，则contextmanager 就会return False，将该异常抛出到with 块之外。

# 类型注解
可以辅助IDE 识别参数的类型进而给用户提示，以及进行静态代码检查
运行时类型不符不会出现错误，可以使用三方模块mypy 来进行静态检查
`var: type` 而不进行赋值，可以单独作为语句，该语句的作用仅仅是向`__annotations__` 中增加记录，而并没有实际的变量定义

## typing 模块
提供了进行注解的各种类型
可以用于模块变量、类和实例成员、函数参数和返回值的类型限定

若没有声明类型，默认是typing.Any

### 常量限定
```py
from typing import Final, Literal

RATE: Final = 3000  # 常量，不可修改

MODE = Literal['r', 'rb', 'w', 'wb']
def open_helper(file: str, mode: MODE) -> str:
    # 限定mode 的取值，只能是上述4种
```

### 字符串
typing.AnyStr

### 容器
```py
from typing import List, Tuple, Dict, Set
from typing import Sequence, Mapping, Hashable   # 序列、映射（k-v）、可哈希对象（也就是不可变对象，可以作为dict 的key 或set 的成员）
from collections.abc import Sequence as Seq     # Python 3.9+ 可以使用

def mix(scores: List[int], ages: Dict[str, int]) -> Tuple[int, int]:
    # 上面返回的是二元组，可以使用Tuple[int, int, ...] 表示不定长元组
    # 如果带有元素类型，Python 3.9 之前需要导入上面的包，之后就可以直接使用list, tuple, dict, set 进行注解


from typing import Iterable, Iterator, Generator    # 可迭代对象、迭代器、生成器

def func(a: Iterator[int], b: Iterable[float]) -> Generator[int, float, str]:
    # Iterable 可迭代对象（Sequence, Mapping、迭代器、生成器都是），需要有__iter__ 方法（该方法理论上返回的就是其迭代器）
    # Iterator 迭代器，需要有__iter__ 和__next__ 两个方法
    # Generator 的三个参数类型分别是YieldType, SendType, ReturnType
    sent = yield 0
    while sent >= 0:
        sent = yield round(sent)
    return 'Done'
```

### 接口限定
类似Go 的interface 的duck-typing
```py
from typing import Protocol

# 定义接口
class Proto(Protocol):
    def foo(self) -> str: ...
# 泛型接口
class ProtoT(Protocol[T]):
    def foo(self) -> T: ...

# 匹配接口
class A:
    def foo(self):
        return 'I am A'

def yeah(a: Proto):
    return f'yeah {a.foo()}'

yeah(A())   # A 的实例符合接口协议
```

### 函数返回
```py
from typing import Optional, NoReturn

# 可能返回None
def foo(a: int = 0) -> Optional[str]:
    if a == 1:
        return 'Yeah'

 # NoReturn 用于抛异常，而非返回None
def exp() -> NoReturn:
    raise RuntimeError('oh no')
```

### 可调用对象
```py
from typing import Callable

def mix(func: Callable[[int, int], str]):
    # Callable 是可调用类型，是参数和返回类型，缺省则表示Callable[..., Any]
```

### 混合类型
Python 3.10 之前使用 `Union[list[int], tuple[int]]` 表示两者任一
Python 3.10+ 支持 X|Y 形式，即`list[int]|tuple[int]`

### 类型别名、类型派生
```py
vector = list[int]|tuple[int]  # vector 就是这个UnionType 的一个引用

from typing import NewType
new_vector = typing.NewType('NewA', list[int]|tuple[int])
```
NewType 会创建一个可调用对象，不同于类的继承，该对象没有bases，不过可以通过`__supertype__` 属性访问其基类型
这个可调用对象实际上就是一个类型检查的过滤器，即`lambda x: x`，这里的x 必须是`__supertype__` 中的类型

别名和派生的不同点，在于
标注为别名的变量，就相当于原类型的标注，只不过换了一个简单的名字
标注为派生的变量，是无法直接使用原类型给其赋值的，必须使用该NewType 的实例给该变量赋值

### 泛型协变
```py
from typing import TypeVar, Generic

# 泛型函数
T = TypeVar('T', str, int) # 后两个参数是限制类型，也可以无限制

def bar(a: T, b: T) -> List[T]:
    # a 和 b 必须保持相同类型
    
# 泛型类
class Queue(Generic[T]):
 	def __init__(self, l: List[T]):
  	 	self.queue = l

q = Queue([1, 2, 3])
q = Queue[float]([1, 2, 3])
```

### 类型的类型
```py
from typing import Type

class User: ... 
class TeamUser(User): ... 
def make_new_user(user_class: Type[User]) -> User:
    # Type 参数可以指定一种基类，该变量可以是该基类或其子类的一个类对象
    return user_class()  # 可以返回基类对象，也可以是派生类对象
```

### 自身引用
```py
# 3.11+
from typing import Self
class AA:
    a: Self

# 3.7+
from __future__ import annotations
class AA:
    a: AA

# 较老的版本可以使用 typing-extensions
from typing_extensions import Self
class AA:
    a: Self
```
typing-extensions 这个三方模块，还包含了很多PEP 已批准，但还没进入标准库typing 的特性

### 继承相关
```py
@final
class Base:     # 类不可被继承
    ...

class Base:
    @overload
    def method(self) -> None: ...
    @overload
    def method(self, arg: int) -> int: ...
    @final
    def method(self, x=None):   # 方法不可被重写
        ...
```

## mypy 模块
`pip install mypy`



# 运行时
## inspect
<https://docs.python.org/zh-cn/3/library/inspect.html>
反射自省，该模块提供了4种主要的功能：类型检查、获取源代码、检查类与函数、检查解释器的调用堆栈。

### 函数
`getmembers(obj, [pred])`: 获取obj 对象的指定类别的成员(name, value)的二元组列表，pred 可以使用以下的is 函数，*注意：若obj 是一个模块对象，则这里获取的成员还包括了通过import 导入的对象*
ismodule(obj)
isclass(obj)
ismethod(obj)
isfunction(obj): 判断是否是函数对象，包括lambda 表达式的函数对象
isgeneratorfunction(obj)：判断是否是生成器函数（带有yield 的函数）
isgenerator(obj)：判断是否是一个生成器（生成器函数返回的）
iscoroutinefunction(obj)
iscoroutine(obj)
isawaitable(obj)
isasyncgenfunction(obj)
isasyncgen(obj)
istraceback(obj)
isframe(obj)
iscode(obj)
isbuiltin(obj)
isroutine
isabstract

getmodulename(path): 获取指定路径的文件的模块名

getmodule(obj): 尝试获取obj定义的模块
getsourcefile(obj): 返回obj定义的源文件名（对于内置对象将抛TypeError）
getsourcelines(obj): 返回一个(list, int) 二元组，前者是源代码列表，后者是源代码的起始行号
getsource(obj): 返回obj定义的源文件文本
getfile(obj): 返回obj定义的文件名（对于内置对象将抛TypeError）
getdoc(obj)
getcomments(obj)
getgeneratorstate(gen): 获取生成器状态

### Signature & Parameter & BoundArguments
signature(callable): 获取一个可调用对象的Signature 对象

#### Signature属性
parameters: 有序字典，key 是参数名，value 是Parameter 对象
return_annotation: 返回类型标注，若没有，则该值是Signature.empty

#### Signature方法
bind(*args, **kwargs): 若参数匹配签名，则返回BoundArguments，否则抛TypeError
bind_partial(*args, **kwargs): 和bind 相同，可以缺省必选参数

#### Parameter属性
name: 参数名
default: 参数默认值，若没有，则为Parameter.empty
annotation: 参数类型标注，若没有，则为Parameter.empty
kind: 包括POSITIONAL_ONLY、POSITIONAL_OR_KEYWORD、VAR_POSITIONAL、KEYWORD_ONLY、VAR_KEYWORD

#### BoundArguments属性
arguments: 参数名-参数值的字典，其变动会反映在args和kwargs的属性上
args: 位置参数元组
kwargs: 关键字参数字典
signature: Signature对象的引用

#### BoundArguments方法
apply_defaults(): 将默认值应用于缺省参数上

# 并发编程
<https://docs.python.org/zh-cn/3/library/concurrency.html>

## threading 模块
由于存在 全局解释器锁，同一时刻只有一个线程可以执行 Python 代码（虽然某些性能导向的库可能会去除此限制）

### 常量
TIMEOUT_MAX：阻塞函数（ Lock.acquire(), RLock.acquire(), Condition.wait(), ...）中形参 timeout 允许的最大值。

### 模块函数
current_thread()：返回当前对应调用者的控制线程的 Thread 对象。如果调用者的控制线程不是利用 threading 创建，会返回一个功能受限的虚拟线程对象。
get_ident()：返回当前线程的 “线程标识符”，是一个非零的整数。线程标识符可能会在线程退出，新线程创建时被复用。
get_native_id()：返回内核分配给当前线程的原生集成线程 ID。是一个非负整数。线程终结，在那之后该值可能会被 OS 回收再利用
main_thread(): 返回主 Thread 对象。一般情况下，主线程是Python解释器开始时创建的线程。
active_count()：返回当前存活的 Thread 对象的数量。 返回值与 enumerate() 所返回的列表长度一致。
enumerate(): 返回当前所有存活的 Thread 对象的列表。包括守护线程以及 current_thread() 创建的空线程。 它不包括已终结的和尚未开始的线程。

excepthook(args)：处理由 Thread.run() 引发的未捕获异常，会将异常信息打印到sys.stderr。args 参数具有以下属性:
    exc_type: 异常类型
    exc_value: 异常值，可以是 None.
    exc_traceback: 异常回溯，可以是 None.
    thread: 引发异常的线程，可以为 None。
    可以重写该方法以自定义处理异常，如果想要恢复，可以使用`__excepthook__`

### Thread 类
Thread(group=None, target=None, name=None, args=(), kwargs={}, *, daemon=None)
+ group：保持None即可，为了日后扩展 ThreadGroup 类实现而保留
+ target：用于 run() 方法调用的可调用对象，默认是None，表示不需要调用任何方法
+ name：线程名，默认是"Thread-N" 的形式
+ args、kwargs 是target 调用的参数
+ daemon：默认继承当前线程的守护模式属性。当剩下的线程都是守护线程时，整个 Python 程序将会退出。所以守护线程在程序关闭时会突然关闭，因为他们的资源（例如已经打开的文档，数据库事务等等）可能没有被正确释放。

继承该类，可以重写`__init__()` and run() 这两个方法
重写`__init__()`，应首先调用基类构造器`Thread.__init__()`

#### 属性
name：线程名字符串，可读写
daemon：一个布尔值，表示这个线程是否是一个守护线程，可以在start 之前修改
ident：线程标识符，如果线程尚未开始则为 None，它是个非零整数
native_id：线程 ID，由 OS (内核) 分配，是一个非负整数，线程未启动时为None

#### 方法
start()：启动该线程，该线程将执行run() 方法，一个线程对象最多只能被调用一次
join(timeout=None)：阻塞当前线程（caller），直到该线程对象（callee）结束或超时（单位为秒的浮点数），该方法可以调用多次，总是返回None
is_alive()：检查该线程是否存活（join 超时后，可以使用该方法判断指定线程是否存活），在run() 方法执行期间，为True

### Timer 类
是Thread 的子类，用于延迟一段时间的操作，start() 启动

Timer(interval, function, args=None, kwargs=None): 延迟interval 秒执行function

#### 方法
cancel(): 可以在计时截止前终止任务

### local 类
线程本地数据，即每个线程都有一份副本数据，相互之间独立。由于模块级或类级数据是多线程共享的，所以就会存在多线性相互的影响，而local 类的实例会给每个线程开辟一个独立的空间，不会多线程共享。

### 线程同步
#### Lock 类
一旦一个线程获得一个锁，会阻塞随后尝试获得锁的线程，直到它被释放

其实例支持上下文管理协议，即
```py
with Lock() as t:   # 调用acquire
    ...
    # 结束调用release
```

##### 方法
所有方法的执行都是原子性的
acquire(blocking=True, timeout=-1)：默认阻塞直到获取到锁，并可以设置超时时间（单位为秒），返回是否成功获取到锁
release()：释放锁，无返回值，由于锁跟获取该锁的线程不绑定，所以不限定该方法调用的线程
locked()：返回该锁是否被锁定

#### RLock 类
重入锁：可以被同一个线程多次获取，该锁跟获锁线程绑定，且有"递归等级" 的概念

也支持 上下文管理协议

##### 方法
acquire(blocking=True, timeout=- 1)：若获取成功，递归级别为1，而后该线程再次调用则递归级别+1，返回是否成功获取到锁
release(): 释放锁，自减递归等级。如果减到零，则将锁重置为非锁定状态。由于存在线程绑定，所以必须是拥有锁的线程调用

#### 信号量
信号量，当计数器归零时等待，相当于带计数的锁

信号量对象也支持 上下文管理协议

##### Semaphore 类
Semaphore(value=1)：value 是信号计数器初始值
BoundedSemaphore(value=1)：可以保障计数器的值不会超过初始值value（不会过多release，超过会抛ValueError 异常）

###### 方法
acquire(blocking=True, timeout=None): 计数器值为正，则-1返回True；值为0，则将阻塞直到调用release 唤醒，唤醒后再执行-1返回True。未获取到信号量将返回False
release(n=1): 计数器+n。被唤醒的线程次序不一定就是等待的顺序

#### Barrier 类
Barrier(parties, action=None, timeout=None): 至少要parties 个线程wait 后才能一起通过。action 可以指定一个可调用对象，在一起通过的中的一个线程中执行
其实例可以多次使用，除非调用action 时异常，超时，或者重置对象时仍有线程在等待，都将进入损坏态，这时将抛BrokenBarrierError 异常

##### 属性
parties
n_waiting: 此时正在等待的线程数
broken: 是否是损坏态

##### 方法
wait(timeout=None): 这里的 timeout 参数优先于创建栅栏对象时提供的 timeout 参数。返回一个[0, parties-1]之间的数，每个线程返回的都不同，可以用于决定后续的不同动作
reset(): 重置栅栏为默认的初始态，需要确保当前没有线程在等待
abort(): 直接进入损坏态，若再调用wait 将抛BrokenBarrierError 异常

### 线程通信
#### Condition 类
条件变量，本质上是一个等待队列，当条件不满足时，线程就加入队列进行等待，当条件满足后将被唤醒继续执行（避免了自旋循环检查）。
正因为要操作这个共享的等待队列，所以无论wait/notify 都需要在互斥锁内进行。同时，由于wait 的线程阻塞在该互斥锁内了，为了能让另一个线程进入互斥锁进行notify，wait 会在排队睡眠之前释放该锁，并在被唤醒后，重新加锁。
综上，wait 操作会原子性的执行：enquene - release操作，在经过休眠 - 唤醒之后，再原子性的执行lock - dequene操作；notify 则仅仅是将该等待队列上休眠的线程进行唤醒
而且，需要确保notify 必须在对应的wait 之后执行，否则该等待队列上的线程将无人唤醒

条件变量遵循 上下文管理协议
```py
cv = Condition(lock=None)   # lock 默认为空，将自动创建一个RLock 对象；也可以指定一个Lock 或者 RLock 对象作为关联的锁

# 消费者
with cv:    # 自动acquire 关联的锁
    while not predicate():  # 这两行相当于cv.wait_for(predicate)
        cv.wait()
    get()
    # 自动release 关联的锁
# 生产者
with cv:
    make()
    cv.notify()
```

##### 方法
+ acquire(*args): 调用关联锁的acquire 方法
+ release(): 调用关联锁的release 方法
+ wait(timeout=None): 进入等待队列，直到被唤醒或超时。该方法总是返回None
+ wait_for(predicate, timeout=None): predicate 是一个可调用对象，返回值可以被解释为布尔值，当为True时，才是真正的条件达成而退出等待（因为wait 因为超时退出，所以需要一个判断）。若超时，则返回False；否则返回predict 最后的返回值
+ notify(n=1): 唤醒n个等待队列上的线程（不保证一定是n个，具体实现可能多于n）
+ notify_all(): 唤醒所有等待队列上的线程

##### 例子：实现读写锁
该实现没有考虑优先排队，也就是说后到的读请求将和先到的写请求一起去抢锁，如果频繁的读请求，将可能导致写请求饥饿，反之亦然（之所以，写饥饿更严重是因为读写的申请和释放这4个方法都要去抢同一把锁，那么在频繁请求的情况下，就会阻塞一样多的申请请求和释放请求，这就导致读计数很难归0，从而阻塞写请求）。类似的实现可以参考<https://github.com/wuyfCR7/ReadWriteLock-For-Python/blob/master/rwlock.py>。
也不具有blocking 和 timeout 的特性。特性比较丰富的库可以参考<https://github.com/elarivie/pyReaderWriterLock>，支持多种优先排队，支持写锁在锁定过程中降级为读锁
```py
class ReadWriteLock:
    """ A lock object that allows many simultaneous "read locks", but
    only one "write lock." """
    
    def __init__(self):
        self._read_ready = threading.Condition()
        self._readers = 0

    def acquire_read(self):
        """ Acquire a read lock. Blocks only if a thread has
        acquired the write lock. """
        with self._read_ready:
            self._readers += 1

    def release_read(self):
        """ Release a read lock. """
        with self._read_ready:
            self._readers -= 1
            if not self._readers:
                self._read_ready.notify_all()

    def acquire_write(self):
        """ Acquire a write lock. Blocks until there are no
        acquired read or write locks. """
        self._read_ready.acquire()
        while self._readers > 0:
            self._read_ready.wait()

    def release_write(self):
        """ Release a write lock. """
        self._read_ready.release()

    @contextmanager
    def rlock(self):
        try:
            self.acquire_read()
            yield self
        finally:
            self.release_read()

    @contextmanager
    def wlock(self):
        try:
            self.acquire_write()
            yield self
        finally:
            self.release_write()
```

#### Event 类
红绿灯控制，简单的wait-notify_all 机制，不需要额外的锁

##### 方法
set(): 设置内部标识为true。所有正在等待这个事件的线程将被唤醒
clear(): 设置内部标识为false。之后调用 wait() 方法的线程将会被阻塞
wait(timeout=None): 阻塞线程直到内部变量为 true。超时单位为秒，除非超时，否则总返回True
is_set(): 返回内部标识状态


## multiprocessing 模块
三种启动进程的方法：
1. spawn: 启动一个新的Python解释器进程（启动较慢），子进程仅仅从父进程继承足以满足run() 方法使用的资源。全平台可用，macOS、Windows 的默认方式
2. fork: 父进程使用 os.fork() 来产生 Python 解释器分叉。父进程的所有资源都由子进程继承，当进程有多线程时不推荐。只用于POSIX 系统
3. forkserver: 选择该方式启动程序时将启动一个服务器进程。每次需要新进程时，父进程就会连接到服务器并请求它分叉一个新进程。分叉服务器进程是单线程的，因此使用 os.fork() 是安全的。没有不必要的资源被继承。在支持通过 Unix 管道传递文件描述符的 POSIX 平台上可用。
在主模块的`__main__`中调用set_start_method('spawn') 进行设置，而且只能调用一次
或者可以调用get_context('spawn') 获取ctx 对象，该对象跟模块有相同的API，不过不会影响到整个程序（不同启动方式的进程可能不兼容，创建的相应对象不能混用）

在 Unix 上通过 spawn 和 forkserver 方式启动多进程会同时启动一个 资源追踪 进程，负责追踪当前程序的进程产生的、并且不再被使用的命名系统资源(如命名信号量以及 SharedMemory 对象)。当所有进程退出后，资源追踪会负责释放这些仍被追踪的的对象。通常情况下是不会有这种对象的，但是假如一个子进程被某个信号杀死，就可能存在这一类资源的“泄露”情况。（泄露的信号量以及共享内存不会被释放，直到下一次系统重启，对于这两类资源来说，这是一个比较大的问题，因为操作系统允许的命名信号量的数量是有限的，而共享内存也会占据主内存的一片空间）

必须在主模块的`__main__`中创建Process、Pool、Manager 等多进程对象

### 模块函数
active_children(): 返回当前进程存活的子进程的列表
cpu_count(): 返回系统的CPU数量。当前进程可以使用的CPU数量可以由 len(os.sched_getaffinity(0)) 方法获得。
current_process(): 返回与当前进程相对应的 Process 对象
parent_process(): 返回父进程 Process  对象。如果一个进程已经是主进程， parent_process 会返回 None
get_all_start_methods(): 返回支持的启动方法的列表，该列表的首项即为默认选项（不同平台可能有差异）
get_context(method=None): 返回一个 Context 对象。该对象具有和 multiprocessing 模块相同的API。默认上下文对象
get_start_method(allow_none=False): 返回启动进程时使用的启动方法名。如果启动方法已经固定，并且 allow_none 被设置成 False ，那么启动方法将被固定为默认的启动方法，并且返回其方法名。如果启动方法没有设定，并且 allow_none 被设置成 True ，那么将返回 None
set_executable(executable): 设置在启动子进程时使用的 Python 解释器路径。 ( 默认使用 sys.executable ) 
set_start_method(method, force=False): 只能用在主模块，并且在`if __name__ == '__main__'` 之下，最多只能调用一次

### Process 类
跟Thread 一样的构造方式
Process(group=None, target=None, name=None, args=(), kwargs={}, *, daemon=None)
+ group 应始终为None，仅用于兼容Thread 接口
+ target: 必须是可以pickle序列化的全局可访问的函数（def 函数/方法和`__call__`对象都可以，但lambda 不行，定义在`__main__`中的函数不行，若是方法，则实例的成员也必须是可以pickle序列化的）

继承该类，可以重写`__init__()` 和 run() 方法
重写`__init__()`，应首先调用基类构造器`Process.__init__()`

start() 、 join() 、 is_alive() 、 terminate() 和 exitcode 只能由创建进程对象的进程调用。

#### 属性
name：进程名，默认是`Process-N1:N2:...:Nk`，Nk 是其父亲的第 N 个孩子
daemon：必须在start() 之前设置。默认初值继承父进程。进程退出时，会尝试终止其所有守护子进程。守护进程不允许创建子进程
pid：进程ID，生成进程前为None
exitcode：子进程的退出码。未结束时，为None；正常返回0，通过sys.exit(N) 退出的，即返回退出码N；未捕获异常退出，返回1；由信号N 终止的，返回-N
authkey：进程的身份验证密钥（字节字符串）。multiprocessing 模块初始化时，主进程使用 os.urandom() 分配一个随机字符串。子进程会继承父进程的身份验证密钥，尽管可以通过将 authkey 设置为另一个字节字符串来更改。
sentinel：系统对象的数字句柄。当进程结束时将变为 "ready"。如果要使用 multiprocessing.connection.wait() 一次等待多个事件，可以使用此值。（Unix 的select 模块）

#### 方法
start()：启动进程，该进程执行run() 方法，一个进程对象最多只能被调用一次
join(timeout=None)：阻塞，直到该进程终止，或者timeout 秒后超时，都返回None，可以通过检查进程的exitcode 确定它是否终止。一个进程可以被join 多次
is_alive()：进程是否还活着（从start() 到进程终止）
close()：关闭 Process 对象，释放与之关联的所有资源。如果底层进程仍在运行，则会引发 ValueError
kill()：终止进程。在Unix上使用 SIGKILL 信号
terminate()：终止进程。在Unix上，这是使用 SIGTERM 信号完成的。注意，不会执行退出处理程序和finally子句等（可能损坏管道，或者由于没有释放锁而造成死锁）。进程的后代进程将不会被终止，即它们将简单地变成孤立的。

### Pool 类
```py
with Pool(5) as p:
    print(p.map(f, [1, 2, 3]))  # 会将可迭代对象中的每个元素放到一个进程中执行f(ele)，返回一个res 的list
    pool.imap_unordered(f, range(10))   # 结果无序返回
    pool.apply_async(f, (20,))  # 异步执行，返回的对象，可以使用get(timeout) 方法获取到结果
```
如果可迭代对象为空，则无参执行一次

同Process的target，apply_async的f 也必须是可以pickle 序列化的全局可访问的函数/方法

apply_async的f 是执行在进程池的一个进程中
apply_async的callback 是执行在当前进程中
进程空间不同，变量是不共享同步的，除非使用同步通信机制

pool 中的进程和当前进程无继承关系（inheritance），所以诸如Lock、Queue 等对象，是无法通过参数或者实例成员传到pool 中的进程中
此时就应当使用manager 创建Lock()、Queue() 等，其创建的这些对象是可以传到pool 中

### 进程同步
建议使用消息机制，而不是同步原语

#### Lock/RLock/Semaphore/BoundedSemaphore/Barrier/Condition/Event 类
同threading 的对应类

##### 方法
Lock/RLock/Semaphore/BoundedSemaphore.acquire(block=True, timeout=None): 第一个参数名跟threading 不同，当 timeout 是负数时，等价于timeout=0，默认值是一直等待

#### 共享内存
由于经过同步器包装过，所以进程和线程安全的。
默认只能往子进程单向传参数，共享内存变量在子进程改动后，主进程可以获取到改动后的值

Value(typecode_or_type, *args, lock=True)
Array(typecode_or_type, size_or_initializer, *, lock=True)

```py
num = Value('d', 0.0)       # typecode 跟array 模块 一致
arr = Array('i', range(10))

num.value   # 值内容
len(arr)
arr[i]  # 可索引
arr[:]  # 可切片
```

#### 进程管理器
返回一个服务进程，该进程保存Python对象并允许其他进程使用代理操作它们。
支持类型： list 、 dict 、 Namespace 、 Lock 、 RLock 、 Semaphore 、 BoundedSemaphore 、 Condition 、 Event 、 Barrier 、 Queue 、 Value 和 Array 。
可以通过网络进行进程共享，但比共享内存要慢
```py
with Manager() as manager:
    d = manager.dict()
    l = manager.list(range(10))
```

### 进程通信
放入队列或管道的对象必须是可以pickle序列化的，因为后台线程会先将obj 序列化后，再通过底层管道进行传递

如果一个进程在尝试使用 Queue 期间被 Process.terminate() 或 os.kill() 调用终止了，那么队列中的数据很可能被破坏。 这可能导致其他进程在尝试使用该队列时发生异常。

#### Pipe 类
r_conn, s_conn = Pipe(duplex=True)
返回管道的两端，不同进程不能操作同一端，所以只能用于两个进程的通信
默认是双工（双向），使用duplex=False，可以使r_conn 仅用于收，s_conn 仅用于发

支持上下文管理协议

##### 方法
send(obj)
recv(): 会一直阻塞直到接收到对象。 如果对端关闭了连接或者没有东西可接收，将抛出 EOFError 异常
`send_bytes(buffer[, offset[, size]])`: 发送字节数组
`recv_bytes([maxlength])`: 接收字节数据，返回字符串。在收到数据前一直阻塞，如果对端关闭或者没有数据可读取，将抛出 EOFError 异常；超长将抛出 OSError 并且该连接对象将不再可读
`recv_bytes_into(buffer[, offset])`: buffer必须是可写的类字节数组对象，offset 指定写入位置，返回读入的字节数。在收到数据前一直阻塞，如果对端关闭或者没有数据可读取，将抛出 EOFError 异常；如果缓冲区太小，则将引发 BufferTooShort  异常，并且完整的消息将会存放在异常实例 e 的 `e.args[0]` 中。
close()
`poll([timeout])`: 返回连接对象中是否有可以读取的数据。未指定timeout 则不阻塞；timeout=None，则一直阻塞，否则为超时秒数

#### Queue 类
近似 queue.Queue 的克隆，可以用于多个生产者消费者通信，实现其除task_done() 和 join() 外的所有方法
线程和进程安全的

构造`Queue([maxsize])`

##### 方法
get(block=True, timeout=None): 出队，默认阻塞，直到有对象或超时，抛queue.Empty 异常
get_nowait(): 相当于 get(False)
put(obj, block=True, timeout=None): 入队，默认阻塞，直到有空槽位或超时，抛queue.Full 异常。如果队列已关闭，抛ValueError 
put_nowait(obj): 相当于 put(obj, False)
close(): 指示当前进程将不会再往队列中放入对象。一旦所有缓冲区中的数据被写入管道之后，后台的线程会退出。这个方法在队列被gc回收时会自动调用。
join_thread(): 这个方法仅在调用了 close() 方法之后可用。这会阻塞当前进程，直到后台线程退出，确保所有缓冲区中的数据都被写入管道中。
cancel_join_thread(): 防止 join_thread() 方法阻塞当前进程。这可能会导致已排入队列的数据丢失。
empty(): 是否为空（多线程、多进程环境下不可靠）
full(): 是否已满（多线程、多进程环境下不可靠）
qsize(): 返回队列的大致长度（多线程、多进程环境下不可靠）

#### SimpleQueue
不同进程可以操作同一端的Pipe
##### 方法
put(item)
get()
empty()
close()

#### JoinableQueue
Queue 的子类，额外添加了 task_done() 和 join() 方法

##### 方法
task_done(): 对于每次调用 get() 获取的任务，执行完成后**必须**调用 task_done() 告诉队列该任务已经处理完成，否则会造成计数信号量溢出
join(): 阻塞至队列中所有的元素都被接收和处理完毕。

### multiprocessing.sharedctypes 模块
支持创建从共享内存分配的任意ctypes对象

## concurrent.futures 模块
### ProcessPoolExecutor
比multiprocessing 模块的Pool 提供了更高层的接口（更可读）

## 协程
非抢占式或合作型多任务，并不存在并发，因此省去了锁和多线程竞争的开销

### yield from
`yield from Iterable` 相当于 `for i in Iterable: yield i`，不同的是后者是语句没有返回值，前者是表达式，其返回值就是StopIteration.value，也就是生成器函数的返回值
具有该表达式的函数同样是生成器函数，只不过每次调用next/send 都会将请求转发给Iterable，直到其迭代返回

### async-def & await
在函数定义前加上async（即async def xxx），相当于将该函数包装成一个*协程函数*（在3.5之前，使用@asyncio.coroutine 装饰器）
直接调用该函数，将返回一个*协程对象*（类似于生成器对象，不会立即执行函数体，需要特定的方式触发执行）

`await Awaitable`，该表达式语句只能在async修饰的函数（协程对象函数）中使用。该语句是将这个可调度对象放进事件循环的调度中，然后让出控制权，由事件循环调用一个协程对象执行
协程对象的类Coroutine继承了Awaitable，此外，Future，Task对象也都是Awaitable
事件循环：检索一个任务列表的所有任务，并执行所有未执行任务，直至所有任务执行完成。这些任务共享一个CPU核心，在进行IO 或者主动让出CPU时，进行任务切换和调度

#### async-for
自动调用迭代器的`async def __anext__` 方法

#### async-with
自动调用`async def __aenter__` 和`async def __aexit__` 方法
```py
# 3.11 引入
async with asyncio.TaskGroup() as tg:
    task1 = tg.create_task(a_func())
    task2 = tg.create_task(a_func())
```

### asyncio 模块
提供事件循环调度的工具

#### 函数
高层级API：
+ run(coro)：驱动协程函数执行，当有其他 asyncio 事件循环在同一线程中运行时，此函数不能被调用。此函数总是会创建一个新的事件循环并在结束时关闭之。
+ sleep(secends, result=None): 返回一个阻塞休眠的协程对象，可以指定返回结果。secends=0，就是单纯的让出控制权，让事件循环进行调度
+ wait_for(aw, timeout)：等待 aw 可等待对象 完成，返回一个协程对象。指定 timeout 秒数后超时，超时会取消async_task
+ wait(aws,timeout=None, return_when=ALL_COMPLETED)：（弃用，Python3.11将移除）可以将一组Awaitable组合为一个协程对象，这些aws可以并发执行，可以指定超时时间和返回情况，超时不会取消async_task。若使用await 执行，则返回(dones, pendings)，前者是已完成的任务集合（若async_tasks 是协程，则返回的时封装的task，若async_tasks 是task，则返回的就是原来的task）
+ gather(*aws)：并发执行，返回一个协程对象。若使用await 执行，则返回results
+ as_completed(aws, timeout=None)：返回一个协程的迭代器，遍历await 则会并发执行aws，当遇到最早执行完成的，就返回其结果，而后执行循环体，而后await 则等待下一个完成的，直到所有aws 都完成则结束。
+ shield(aw)：保护aw 不会被取消，返回一个Awaitable。（CancelledError 仍会被抛出，但并不终止aw 的执行）

低层级API：
+ get_event_loop()：返回消息循环对象，可以调用run_until_complete(futrue)方法，进行任务调度，通过close方法结束消息循环
+ Future()：返回future对象也是一个Awaitable

#### Task
可以通过 create_task(coro, *, name=None, context=None) 创建
即将协程coro 封装为Task（也是Awaitable），其中包含任务的各种状态，可以使用await 可以并发执行，返回async_task的result。
Python3.11 新增的context 参数可以指定自定义的 contextvars.Context
在Python3.7 之前使用ensure_future(async_task) 创建
在Python3.11 也可以通过TaskGroup.create_task() 创建

支持任务的取消、保护、回调等操作
任务取消会抛出 asyncio.CancelledError
**注意** 需要持有任务对象的引用，因为事件循环只保存其弱引用，若不持有可能会被垃圾回收清理

#### TaskGroup
异步上下文管理器，其退出时，其中的所有任务都将被等待

它跟gather 方法的不同点在于若其中一个子任务发生异常
gather(*aws, return_exceptions=False)：默认，会将异常立刻传给gather 任务，其他子任务不会取消，会继续执行（除非gather 任务被取消，则其中所有的任务都被取消）
gather(*aws, return_exceptions=True)：异常会和成功的结果一样处理，并聚合至结果列表
TaskGroup：剩余已排期的任务将被取消


# 网络编程
HTTP协议中，定义了八种方法来操作指定的资源：
+ GET：向指定的资源发出“显示”请求
+ POST：向指定资源提交数据，请求服务器进行处理
+ PUT：向指定的资源上传最新内容
+ DELETE：请求服务器删除所标识的资源
+ OPTIONS：使服务器传回该资源所支持的所有HTTP请求方法，可以测试服务器功能是否正常运作
+ HEAD：向服务器发出指定资源的请求，只不过服务器将不传回资源的本文部分
+ CONNECT：通常用于SSL加密服务器的链接
+ TRACE：显示服务器收到的请求，用于测试

## socket 模块
socket        网络文件访问

## urllib 和urllib2 模块
通过URL建立到指定web服务器的网络连接

[urllib2](https://docs.python.org/2/library/urllib2.html)
Python3 合并为一个[urllib](https://docs.python.org/zh-cn/3/library/urllib.html)

### urllib.request 模块
用于打开URL 链接（通常是HTTP），包括了数字认证、重定向、cookies 等等

#### 函数
+ urlopen(url, data=None[, timeout[, cafile[, capath[, cadefault[, context]]]]])
该函数的行为是构造了一个Request对象（无论是传入的还是构造的），经过编码，发到指定URL，并获得response的过程。该函数默认会自动处理重定向，而其他的错误（400-599的错误码）则需要自己处理。
其中：
url 可以是一个字符串或者Request 对象
data 是一个字符串，表示传给server 的额外数据（此时为POST 请求），没有为None（此时为GET 请求）。data 的格式必须是application/x-www-form-urlencoded，可以使用urlencode() 函数将一个字典或二元组序列转化成该格式。
timeout 是请求超时时间（秒），仅用于HTTP, HTTPS 和FTP 连接，如果未指定，则使用全局的默认超时时间
context 是ssl.SSLContext 实例
cafile 和capath 用于提供HTTPS 请求的受信CA 证书集，前者指定一个单文件，后者指定一个目录
cadefault 参数忽略
该函数返回一个类文件对象（addinfourl这个类），除了read、readline、readlines、close这些方法外，还有：
getcode()：返回HTTP 状态码
geturl()：返回获取页面的真实URL（因为其间可能存在重定向）
info()：返回一个httplib.HTTPMessage 对象，可以直接print 查看Response对象的各种头信息（kv）
该函数失败产生URLError（继承自IOError），它有一个reason属性（是一个错误状态码和错误信息的二元组），HTTPError是其子类，它有一个code 属性，是HTTP 状态码
+ install_opener(opener)
安装一个OpenerDirector 实例作为默认的全局opener（即urlopen 函数默认使用的opener）
+ build_opener([handler, ...])
按照给定的handler 顺序构造并返回一个OpenerDirector 实例。这些handler 是BaseHandler 或其子类的实例（而且必须可以进行无参构造）
另外，在这些handler 之前还有一些默认的handler，除非参数handlers 中包含了这些handler 或其子类的实例：ProxyHandler (if proxy settings are detected), UnknownHandler, HTTPHandler, HTTPSHandler (if ssl module can be imported), HTTPDefaultErrorHandler, HTTPRedirectHandler, FTPHandler, FileHandler, HTTPErrorProcessor

#### 类
+ `Request(url, data=None[, headers][, origin_req_host][, unverifiable])`
其中：
url 必须是一个有效URL 的字符串
data 同urlopen 函数的data 参数
headers 是一个字典，表示各种头信息
    注意一些header：
    - User-Agent：有些 Server 或 Proxy 会检查该值，用来判断是否是浏览器发起的 Request；此外，浏览器信息也被用于服务器识别来发送不同版本的内容。默认，urllib2把自己作为“Python-urllib/x.y”（x和y是Python主版本和次版本号）
    - Content-Type：在使用 REST 接口时，Server 会检查该值，用来确定 HTTP Body 中的内容该怎样解析，设置错误会导致 Server 拒绝服务。常见的取值有：
    application/x-www-form-urlencoded：浏览器提交 Web 表单时使用（会进行编码）
    application/xml：在 XML RPC，如 RESTful/SOAP 调用时使用 
    application/json;charset=UTF-8：在 JSON RPC 调用时使用
    text/plain;charset=UTF-8：空格转换为`+`加号，但不对特殊字符编码
    multipart/form-data：文件上传（不编码）
后两个参数用于处理第三方的HTTP cookies
+ OpenerDirector
opener 类
+ BaseHandler
handler 基类
+ HTTPPasswordMgr
维护一个`(realm, uri) -> (user, password)` 映射的数据库
    - add_password(realm, uri, user, passwd)
    uri 可以是一个单个uri，也可以是uri 序列
    realm, user, passwd 是一个字符串
    - find_user_password(realm, authuri)
    根据给定的realm 和 URI获取user/password，如果没有匹配，返回(None, None)
+ HTTPPasswordMgrWithDefaultRealm
维护一个`(realm, uri) -> (user, password)` 映射的数据库，对于找不到合适realm 时，会使用realm 为None 的映射
兼容HTTPPasswordMgr 接口
即调用其add_password 方法时，可用设realm 参数为None
+ HTTPBasicAuthHandler([password_mgr])
如果提供password_mgr 参数，必须兼容HTTPPasswordMgr 接口
当需要基础验证时，服务器发送一个header(401错误码) 请求验证。这个指定了scheme 和一个realm，形如：`Www-authenticate: SCHEME realm="REALM"`，例如：`Www-authenticate: Basic realm="cPanel Users"`
客户端必须使用新的请求，并在请求头里包含正确的姓名和密码。这是“基础验证”
如果你知道realm(从服务器发送来的头里)是什么，你就能使用HTTPPasswordMgr；如果不关心realm是什么，就能用方便的HTTPPasswordMgrWithDefaultRealm。

#### 定制化
当你获取一个URL 你使用的是一个opener（一个urllib2.OpenerDirector的实例），而该opener 可以使用它管理的Handler 针对特定的协议和请求进行处理。
可以通过使用build_opener() 函数创建一个新的OpenerDirector实例，而后直接调用其open() 方法打开一个URL（当然也可以用install_opener() 函数安装后用urlopen 进行打开）

### urllib.parse 模块
用于 URL 解析和转码

#### 函数
+ urlparse(url, scheme=''): 将url（scheme://netloc/path;params?query#fragment） 解析为(scheme, netloc, path, params, query, fragment)的named tuple，scheme 给出默认值。除了6元组中的名字，还可以访问这些成员：username、password、hostname、port（这些成员不存在则为None）
+ urlunparse(parts): 将包含6个元素的可迭代对象组合成为一个url
+ urlsplit(urlstring, scheme=''): 将url（scheme://netloc/path?query#fragment） 解析为(scheme, netloc, path, query, fragment)的SplitResult 对象，scheme 给出默认值。除了5元组中的名字，还可以访问这些成员：username、password、hostname、port（这些成员不存在则为None）
+ urlunsplit(parts): urlsplit 的逆操作，可能与原URL有不同，但等价。也可以直接调用SplitResult 对象的geturl()方法
+ parse_qs(qs, keep_blank_values=False, strict_parsing=False, encoding='utf-8', errors='replace'): 解析query 部分（application/x-www-form-urlencoded 格式）为一个字典（val 是值列表），若解析失败，默认静默忽略，若strict_parsing=True，错误会抛ValueError，encoding 和errors 是用于解码和解码错误的处理方式。
+ parse_qsl(qs, keep_blank_values=False, strict_parsing=False, encoding='utf-8', errors='replace'): 解析query 部分为一个二元组列表
+ urlencode(query, doseq=False, safe='', encoding=None, errors=None, quote_via=quote_plus): parse_qs 和 parse_qsl 的逆操作，可以用于生成request 的 data 参数（application/x-www-form-urlencoded 格式）
+ urljoin(base, url): 用url 部分替换base 中的内容，返回一个新的URL（若url是以`/`开头，则取base的path 之前的部分与url 连接；否则 base 最后一个`/`之前的部分(含)与url 连接）
+ urldefrag(url): 返回(pure_url, fragment)的named tuple，pure_url 是不含fragment 的部分，若没有fragment 则其为空串
+ quote(string, safe='/', encoding=None, errors=None): 用 %xx 转义符替换 string 中的特殊字符。 字母、数字和 '_.-~' 等字符一定不会被转码（safe参数可以额外指定）。默认只对路径部分进行转码。
+ quote_plus(string, safe='', encoding=None, errors=None): 还会使用加号来替换空格，而且safe 为空
+ unquote(string, encoding='utf-8', errors='replace'): 将 %xx 转义符替换为其单字符等价物
+ unquote_plus(string, encoding='utf-8', errors='replace'): 还会将加号替换为空格


## requests 模块
### 安装
```
pip install requests
```

### 模块方法
`get(url, params=None, **kwargs)`
params 是GET 的请求参数，即网址上`?` 后面用`&`分隔的部分，这里可以指定一个字典（其value 可以是字符串和字符串列表）
kwargs 包括：
+ headers：可以指定一个字典（value 必须是字符串）
+ cookies：可以指定一个字典或RequestsCookieJar 对象
+ timeout: 建立连接的超时时间，没有默认值，建议必选；可以指定一个二元组，表示connect 和 read 的超时时间，若为单值则二者共用
+ `allow_redirects`: 是否允许重定向，默认为True
+ auth: 元组('user', 'pass')，认证信息的优先级：auth > .netrc > headers
+ verify: 验证 SSL 证书，如果忽略对 SSL 证书的验证，可以设置为False（默认为True），或者可以指定`CA_BUNDLE` 文件的路径
+ cert: 客户端证书，可以是一个字符串（包含包含密钥和证书的文件名），也可以是一个二元组（证书文件路径，秘钥文件路径）（证书私钥必须是解密状态）
+ stream: 默认响应会立即下载。若为True，则返回的Response 仅下载响应头，响应体延迟到主动获取时下载。由于连接需读取完所有数据才会自动关闭，所以该模式需手动调用 Response.close() 才能提前关闭，或者使用with-as 语句中。
返回一个Response 对象


post(url, data = {'key':'value'})
+ data：可以是字符串（直接发出）、（提交表单，此时Content-Type会被设置为application/x-www-form-urlencoded）字典或二元组序列（当一个key 下有多个值使用这种）、文件对象（流式上传）、生成器或迭代器（分块传输）
+ json: 可以自动将参数使用json.dumps 进行编码，然后作为字符串发出（此时Content-Type会被设置为application/json）
+ files: 一个字典key 为'file'，value 为一个文件对象（最好用二进制模式打开）、二元组（文件名, 字符串）、四元组（文件名, 文件对象, 文件类型, 请求头）；或者一个二元组列表，二元组为(表单name, 文件信息)，其中文件信息为三元组（文件名、文件对象、文件类型）
大文件requests 不支持（会内存不足而崩溃），requests-toolbelt 是支持的

put(url, data = {'key':'value'})

delete(url)

head(url)

options(url)


#### 文件上传
##### 单文件上传
```py
# 只给出文件对象的value
files = {'file1': open('logo.png', 'rb')}
# 四元组的value
files = {'file1': ('logo.png',  # 显式指定文件名
                    open('logo.png', 'rb'),
                    'image/png',  # 请求头Content-Type字段对应的值
                    {'Expires': '0'})}
resp = requests.post(url, files=files)
```

##### 多文件上传
```py
files = [
    ('file1', ('1.png', open('logo.png', 'rb'), 'image/png')),
    ('file2', ('2.png', open('logo.png', 'rb'), 'image/png'))
]
resp = requests.post(url, files=files)
```

##### 流式上传（适合大文件）
本质上是通过multipart/form-data 提交数据
需要安装`pip install requests-toolbelt`
```py
form = {
    'name': 'logo.com',
    'file1': ('1.png', open('logo.png', 'rb'), 'image/png'),
    'file2': ('2.png', open('logo.png', 'rb'), 'image/png') 
}
m = MultipartEncoder(fields=form)
# 还可以将其封装到一个监视器中，这样可以实时查看上传进度
def my_callback(monitor):
    progress = (monitor.bytes_read / monitor.len) * 100
    print("\r 文件上传进度：%d%%(%d/%d)" % (progress, monitor.bytes_read, monitor.len), end=" ")
m = MultipartEncoderMonitor(m, my_callback)
# 无论是MultipartEncoder 还是MultipartEncoderMonitor 使用上都是一样的
resp = requests.post(url, data=m, headers={'Content-Type': m.content_type})
```

#### 文件下载
对于python2 可以直接使用`urllib.urlretrieve`，但该函数在python3 将被废弃，所以，可以使用以下的替代方案

```py
with urllib.request.urlopen(url) as resp, open(output_file, 'wb') as f:
    shutil.copyfileobj(resp, f)     # 默认会分块循环处理，当然也可以指定第三个length 参数，指定缓冲区大小

# use requests
with contextlib.closing(requests.get(url, stream=True)) as r:
    r.raise_for_status()
    with open(filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=8_192):
            f.write(chunk)
```

### 类
#### Request
`Request(method, url, **kwargs)`: kwargs 类似上面get 方法
##### 方法
prepare(): 返回一个PreparedRequest 对象

#### models.Response
Requests 会自动为你解码 gzip 和 deflate 传输编码的响应数据。
##### 字段
+ encoding: 默认根据请求头中的charset来猜测网页解码方式（若未指定则默认使用ISO-8859-1），可以手动设置从而改变text 的编码方式，也可以使用requests.utils.get_encodings_from_content 方法从内容猜测编码
+ content: 响应内容（字节串）
+ text: 响应内容（Unicode字符串），若未设置encoding 则使用`chardet` 根据HTTP headers 猜测编码方式
+ raw: 返回一个urllib3.response.HTTPResponse 对象（请求方法必须stream=True）
+ `status_code`: 响应状态码，内置了一个成功的状态码为requests.codes.ok
+ ok: `status_code` < 400 为True，否则为False
+ headers: 服务器响应头，一个字典
+ cookies: RequestsCookieJar 类型，行为类似字典
+ history: Response 对象的列表，按从最老到最近的请求进行排序，可以追踪重定向
+ request: 获得请求对象

##### 方法
json(): 将响应内容用json 进行loads
`raise_for_status()`: 若`status_code`错误，抛一个HTTPError 异常
`iter_content(chunk_size=1, decode_unicode=False)`: 返回一个generator，可以迭代文本流；若`chunk_size=None`，则可以进行分块迭代
`iter_lines`: 返回一个generator，可以迭代行

#### cookies.RequestsCookieJar
##### 方法
set(key, val, domain, path): 后两个参数可以指定域名和路径使用

#### Session
在同一个 Session 实例发出的所有请求之间保持 cookie，使用urllib3 的连接池功能，如果你向同一主机发送多个请求，底层的 TCP 连接将会被重用（会话持久链接的保持），从而带来显著的性能提升
给对象设置的字段属性，都会在方法请求时，与请求参数进行合并（如果想要滤除会话中的字段属性，只需要将参数的对应字段设置为None），但请求参数不会被合并到会话属性中
可以使用`with requests.Session() as s` 打开，这样可以自动退出会话
##### 字段
auth: 二元组
headers: 字典
cookies

##### 方法
get 等方法
`prepare_request(req)`: 将Request 对象准备为PreparedRequest 对象（带有会话特性的）
`send(PreparedRequest, **kwargs)`
kwargs 包括：
+ stream
+ timeout
+ verify
+ proxies
+ cert



# 结构化数据处理
## csv 模块
<https://docs.python.org/2.7/library/csv.html>
CSV(Comma-Separated Values)即逗号分隔值，一种表格数据，所有值都是字符串
在打开文件时，最好使用'b' mode
### 函数
`reader(iter, dialect='excel', **fmtparams)`：返回一个reader 对象，可逐行迭代，每行的数组作为一个列表。iter 是一个每次返回一个字符串的可迭代对象，dialect 可以是Dialect 子类的实例或`list_dialects()`函数返回的其中一个字符串，其他的格式化参数会覆盖dialect 定义的格式
`writer(iter, dialect='excel', **fmtparams)`：返回一个writer 对象。iter 是一个有write()方法的对象，dialect 可以是Dialect 子类的实例或`list_dialects()`函数返回的其中一个字符串，其他的格式化参数会覆盖dialect 定义的格式。注：None 将被写为空串，float 使用repr() 字符串化，其他非字符串数据使用str() 字符串化

### 类
`DictReader(f, fieldnames=None, restkey=None, restval=None, dialect='excel', *args, **kwds)`：返回一个reader 对象，可逐行迭代，每行的数组作为一个字典，如果fieldnames 参数缺省，则使用reader 对象的第一行作为fieldnames，如果key 的个数小于val 的个数，则剩下的val 将以restkey 为key，val 是一个序列，如果key 的个数大于val 的个数，则这些key 将以restval 为值。其他的参数都类同 reader
`DictWriter(f, fieldnames, restval='', extrasaction='raise', dialect='excel', *args, **kwds)`：返回一个writer 对象。fieldnames 是一个字符串的序列，用以表示将字典写入文件的顺序。如果fieldnames 中有字典中不存在的列名，则使用restval 作为值。反之，如果字典有的key 不在fieldnames 中时，由extrasaction 决定采取的策略：'raise' 表示抛ValueError 异常，'ignore' 表示忽略该多余key。其他的参数都类同 writer

### Dialect 属性
delimiter：field 分隔符，必须是单字符，默认是','
lineterminator：行终结符，默认是'\r\n'
quotechar：当字段内有delimiter 和lineterminator 时，可以使用该字符引用，必须是单字符，默认是'"'
doublequote：决定quotechar 如果出现在字段内，如何做转义。如果该值为True（默认），则使用双写转义，否则使用escapechar 在quotechar 之前进行转义（如果此时escapechar 未设置，将抛出一个Error）
quoting：在writer 生成quote 和reader 识别quote 时进行控制，默认是QUOTE_MINIMAL
escapechar：若quoting 设为QUOTE_NONE 并且doublequote 为False，使用其去转义后面一个字符的特殊含义。默认是None，表示不使用转义
skipinitialspace：delimiter 之后的空白符是否被忽略，默认是False
strict：当输入格式错误时，是否抛Error

### Reader 对象属性
dialect：只读的
`line_num`：行数（从1开始），由于CSV 文件中可能有多行记录，所以并不等同于记录数
fieldnames：如果创建对象时未指定，则该属性按照文件中的第一条记录初始化

### Writer 对象
writerow(row)：row 是一个字符串或数字的序列（对于DictWriter 对象是一个fieldnames 到字符串或数字的字典）
writerows(rows)：rows 是row 的迭代对象
writeheader()
dialect：只读的


## json 模块
[参考](../data/json.md)

## html
### html 模块方法
+ escape(s, quote=True)：将`&, <, >` 转义为html 安全字符序列，quote=True则引号也会被转义
+ unescape(s)：将转义后的html 字符序列反转义，映射表可以看html.entities.html5 这个字典

### HTMLParser 模块（Python3 改为html.parser）
#### HTMLParser 类
一般通过继承该类，实现若干事件处理函数，当处理遇到tag/text/comment等文本时回调对应的handle
该类无构造参数（并且该类不支持super关键字，因此其子类调用父类的构造函数只能是`HTMLParser.__init__(self)`）

##### handle 方法（需要重写）
+ handle_starttag(tag, attrs)：遇到开始tag 时调用，参数tag 是标签名（已转化为小写）；attrs 是一个(name, value) 二元组的列表，name 是属性名（已转化为小写），value 是属性值（转义字符已替换）
+ handle_endtag(tag)：遇到结束tag 时调用
+ handle_startendtag(tag, attrs)：当遇到空元素时调用，参数意义同handle_starttag，默认行为是依次调动handle_starttag 和handle_endtag
+ handle_data(data)：当遇到内容结点时调用
+ handle_comment(data)：当遇到注释标签时使用，data 是注释的内容，即两个-- 之间的内容

##### 其他方法
+ feed(data)：给解析器提供HTML文本片段，其中完整的元素会被处理，不完整的元素进行缓存，当下次调用补齐，或者调用的close 函数
+ close()：强制终止解析（缓存的内容都作为data 解析），可以重写该函数，增加额外的操作，不过必须要调用基类的close 函数
+ reset()：丢弃未处理的缓存数据
+ getpos()：返回一个(lineno, offset) 的二元组，lineno是当前处理的行号（第一行为1），offset 是列偏移（第一列为0）。在handle 方法中调用，返回在刚刚遇到指定内容的位置。
+ get_starttag_text()：返回最近遇到的一个打开的开始tag

### Beautifulsoup 库
第三方库，用于帮助解析Html/XML等内容
[BeautifulSoup官网](http://www.crummy.com/software/BeautifulSoup/)
<https://beautifulsoup.readthedocs.io/zh_CN/v4.4.0/>

#### 安装
```
pip install beautifulsoup4      # BeautifulSoup 是BeautifulSoup3 的包（pip 支持卸载）

easy_install beautifulsoup4

python setup.py install     # 源码安装
```
#### BeautifulSoup 类
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

#### Tag
Tag是HTML或XML中一个完整的标签
可以当做一个字典对象访问标签属性，可以直接修改和删除
Tag对象也可以有很多子结点（包含分支结点Tag和叶子结点NavigableString）

##### 属性
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

##### 方法
Tag类标签可以使用 find 和 find_all 方法进行搜索（搜索当前结点和子孙结点），这两个方法的参数都可以接受多种的参数类型：
+ 字符串：完全匹配（最好使用Unicode 字符串，否则将认为utf-8 编码进行转换）
+ re.compile 的正则对象：正则匹配
+ 列表：完全匹配其中一个
+ True：匹配所有存在指定属性的结点（例如存在标签名即Tag结点，存在某个标签属性等）
+ 函数对象：该函数接受一个参数，返回一个布尔值，True表示匹配，False反之。

`find_all(name=None, attrs={}, recursive=True, text=None, limit=None, **kwargs)`
name 为标签名过滤器，可以使用上面五种参数类型（函数参数的参数为Tag 结点对象）
attrs 为标签属性过滤器，可以提供一个字典参数
string ~~text废弃~~ 为标签文本过滤器，可以使用上面五种参数类型（函数参数的参数为NavigableString 结点对象）
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

#### NavigableString
NavigableString是HTML中的文本内容，通常通过Tag 对象的string 属性获得，还可以使用 .strings 属性递归遍历所有NavigableString，.stripped_strings 属性是对应去除多余空白符的结果。
可以使用unicode() 函数将该对象转换为一个Unicode字符串，而且最好这么做，因为该对象会引用BeautifulSoup 对象，使用该对象会导致BeautifulSoup 对象无法释放，比较浪费内存。
不能直接编辑，但可以调用.string.replace_with()方法进行替换。
NavigableString 对象支持 遍历文档树 和 搜索文档树 中定义的大部分属性, 但并非全部。而且NavigableString是叶子结点，因此不能包含其它内容，即不支持 .contents 或 .string 属性或 find() 方法.

#### Comment
获得该对象的方式和获得NavigableString的方式相同，因为它就是一种特殊的NavigableString。
查看该对象只能看到注释文本的内容，当进行HTML 序列化时才会转换为HTML 注释的格式。
*其他XML 对象CData, ProcessingInstruction, Declaration, Doctype 类似的也都是NavigableString 的一个子类*

#### 编码
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

#### 解析部分文档
如果想在加载文档时就对文档进行一次过滤（仅解析某些文档片段），可以使用SoupStrainer这个类，它的构造参数和find方法相同，使用时只需在构造BeautifulSoup实例时，使用parse_only参数指定一个这个类的实例即可

#### 附注
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


## xml
常见的XML编程接口有DOM 和SAX
python有三种方法解析：DOM、SAX、ElementTree
+ DOM（Document Object Model）解析为语法树（需要全部载入，慢且占用内存），使用树的操作
+ SAX（Simple API for XML）用事件驱动模型，通过触发回调函数来处理（流式读取，不必全部载入，但API并不友好，需用户实现回调函数Handler）
+ ElementTree，轻量DOM，具有友好的API，速度快，内存占用少
但他们都不具备抵御实体扩展的能力，有两个defused packages可以，但他们并不能够向后兼容。
[参考](https://docs.python.org/2/library/markup.html)

### xml.dom 模块
#### 概念说明
##### 基类Node
+ childNodes属性获得子Node列表
+ nodeType属性获得结点类型
+ toxml([encoding])方法返回XML字符串
+ appendChild(newChild)方法给结点追加一个子结点，并返回之。如果newChild已经是文档树中的结点，则首先先删除之。

##### Document
代表一个完整的XML文档对象
documentElement 属性获取唯一的一个Element对象
getElementsByTagName()查找元素，返回一个NodeList对象
支持`__len__()` 和 `__getitem__()`

+ createElement(tagName)创建并返回一个新的Element
+ createTextNode(data)创建并返回一个新的Text
+ createComment(data)创建并返回一个新的Comment
+ createAttribute(name)创建并返回一个新的Attr

##### Element
代表XML中的一个元素
+ getElementsByTagName()查找元素
+ hasAttribute('')/getAttribute('')/removeAttribute(name) 判断/获取/删除元素属性值
+ setAttribute(name, value) 设置元素属性值
+ setAttributeNode(newAttr) 将一个属性结点添加为当前元素的属性，如果name重复则替换之（返回旧属性结点），如果newAttr已经被使用，则抛出异常
+ removeAttributeNode(oldAttr)

##### Attr
代表元素的一个属性

##### Comment
代表注释元素
data属性访问内容

##### Text
代表文本元素
data属性访问内容

#### xml.dom.minidom 模块
最小的DOM实现，一次性读取整个文档，保存为一个树形结构
并不扩展外部实体，而直接返回实体字面值
parse(file)：从文件名或文件对象解析出 Document
parseString('...')：从字符串解析出Document

#### xml.dom.pulldom 模块
支持部分DOM树的构建


### xml.sax 模块
两部分内容：解析器和事件处理器
解析器负责读取XML文档，并向事件处理器发送事件；事件处理器处理事件，处理传入的XML数据

#### 模块方法
+ make_parser([parser_list])
创建并返回一个SAX XMLReader对象，parser_list是一个模块名的字符串列表，这些模块必须有create_parser()函数，该函数将查找列表中第一个可用的。
+ parse(file, handler, [err_handler])
创建一个SAX解析器并用其解析文档，file可以是文件名或文件对象。handler参数是一个ContentHandler实例，err_handler是一个ErrorHandler实例
+ parseString(string, handler[, error_handler])
同上，只不过来源于字符串

#### xml.sax.xmlreader 模块
XMLReader对象可用直接parse(source)，source可以是文件名或url的字符串，也可以是一个文件对象或InputSource对象。通过setContentHandler(handler)设置事件处理器对象。

#### xml.sax.handler 模块
ContentHandler的一些重要接口：
+ startDocument()：在其他接口之前调用，并只调用一次
+ endDocument()：在其他接口之后调用，并只调用一次
+ startElement(name, attrs)：元素开始时触发，不支持namespace，name是这个元素时的名字，attrs是一个类似字典的对象，可以以属性名为key获取属性值
+ endElement(name)：元素结束时触发，不支持namespace
+ characters(content)：处理内容数据，content就是两个标签之间或与换行之间的内容
通常，从该类继承并重写相应的事件处理函数，用于处理解析事件。


### xml.etree.ElementTree 模块
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

#### Element
被设计为灵活的容器对象，既可表达为一个列表也能表达为一个字典，可以用序列的方式访问子元素，可以用访问字典的方法访问属性
当进行遍历时，是按照序列方式遍历的子元素

##### 属性
tag：str，元素的标签名
attrb：dict，元素属性
text：str，文本内容（从开始标签到下一个标签之间的内容，如果没有为None），读写
tail：str，文本后缀（从结束标签到下一个标签之间的内容，如果没有为None），读写

##### 方法
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

##### 直接构造XML
ET.Element('tag_name', {attrib})：创建一个根元素
ET.SubElement(Element, 'tag_name', {attrib})：创建一个子元素并指定父元素

#### ElementTree
##### 构造
ET.ElementTree(element=None, file=None)：element指定root，文件用于初始化
同Element，有find, findall, findtext, iter, iterfind方法，该元素为root
getroot()：获得root Element
parse(file, parser=None)
write(file, ...)：修改XML写回


### lxml 模块
基于C 库libxml2 和libxslt 封装的python 模块，不仅能处理XML，还能处理HTML。
[参考](http://lxml.de/tutorial.html)

#### lxml.etree
##### lxml.etree.Element
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

##### lxml.etree.ElementTree
lxml.etree.ElementTree 是建立在一个文档树根节点，对XML文档的封装
对该对象使用tostring 方法，会带有DTD
其属性：
docinfo.xml_version
docinfo.doctype
docinfo.public_id
docinfo.system_url

新方法
getelementpath(Element)：返回指定元素的xpath

##### 模块方法
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

##### 分批解析
两种方法：
1. 传给etree.parse 的类文件对象
这样会不断调用类文件对象的read 方法（每次可能只返回文档的一部分），直到返回空
2. 使用etree.XMLParser() 对象的feed() 方法
每次调用feed(xml_fragment) 都只解析一部分，直到调用该对象的close() 方法，返回Element

##### 事件驱动解析
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


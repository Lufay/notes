## 概念
每个进程都有一个进程ID唯一识别（pid_t pid=getpid()）
每个进程都属于一个进程组（getpgrp()），进程组属于一个会话（getsid(getpid())），是子集关系

进程组（process group）：一个或多个进程的集合，每一个进程组有唯一的进程组ID，即进程组长进程的ID。进程组中有任何一个进程存在，则进程组存在，与组长进程是否存在无关。进程组最后一个进程可能终止或者转移到另一个进程组（setpgid()）。进程只能修改自己或者自己的子进程的进程组ID，但是子进程调用exec函数后就不能在改变子进程的进程组ID。
进程组通常与同一作业相关联，接收同一终端的各种信号。
会话（session）：一个或多个进程组的集合，有唯一的会话首进程（session leader）。会话期ID为首进程的ID。用户登录Linux时，系统会分配给登录用户一个终端session。
会话可以有一个单独的控制终端（controlling terminal）。与控制终端连接的会话首进程叫做控制进程（controlling process）。当断开连接时，则将挂断信号SIGHUP发给控制进程（会话首进程）。

当前与终端交互的进程组称为前台进程组（foreground）。其余进程组称为后台进程组（background）。终端输入与信号都是发给前台任务组（后台进程组不受影响）
+ 前台：可以通过stdin和终端信号与之交互
+ 后台：后台默默运行，无法收到stdin，也不响应Ctrl+C。当其结束时，会向前台发送job number Done的信息。工作状态可以分为stop和running
只能管理自己登陆的shell下启动的job
后台任务若有stdout和stderr时，其仍会显示到屏幕上，会干扰前台工作，所以一般将输出重定向到日志中：`cmd >log.txt 2>&1 &`

守护进程是生存期较长的一种进程，一般在系统启动时启动，系统关闭时停止，没有控制终端，后台运行。

## 任务启动
在一个命令后面加上`&`，就将该job放到后台运行，将返回其job number和触发的PID
例如：一个程序aaa
前台执行：`./aaa`
后台执行：`./aaa &`

## 任务转换
对于前台正在执行的程序，使用Ctrl+z就可以将其挂起到后台，暂停执行：
（需要注意的是，如果挂起会影响当前进程的运行结果，请慎用此方法）

## 命令
### 查看当前后台任务及状态
jobs
-l：除列出job number和命令串外，还列出PID
-r：只列出后台running状态的job
-s：只列出后台stopped状态的job
其中`+/-`的意义是，`+`的job是直接使用fg命令取回的job（最近被放入后台的工作）；`-`表示倒数第二个被放入后台的job

### 将后台job取回前台
fg %jobid
其中%是可有可无的
也可以使用`fg -`则取回`-`所表示的job
如果省略jobid则默认把最近放入后台的job取回，也就是jobs命令看到的标识为`+`的job

### 切换后台job运行状态
bg %jobnumer
把stopped的job变为running

### 等待子进程
`wait [id]`
如果不写id，则将等待当前shell上的所有子进程
id可以指定进程pid，也可以指定`%jobid`（`%` 是必选）

### 进程休眠
`sleep n[s|m|h|d]`
默认后缀是s，表示等待n秒，这里n不仅是整数，还可以是任意浮点数（其他后缀还有分、小时、天）

### 杀死子进程
kill -signal %jobid
kill -l列出当前kill能够使用的signal有哪些：
-1：HUP终端断线，通知session 内的进程组，默认的动作是终止程序
-2：INT中断信号，和键盘输入Ctrl+C等效
-3：QUIT退出信号，进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号。
-4：SIGILL执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号。
-5：SIGTRAP由断点指令或其它trap指令产生. 由debugger使用。
-6：SIGABRT调用abort函数生成的信号。
-7：SIGBUS非法地址, 包括内存地址对齐(alignment)出错。比如访问一个四个字长的整数, 但其地址不是4的倍数。它与SIGSEGV的区别在于后者是由于对合法存储地址的非法访问触发的(如访问不属于自己存储空间或只读存储空间)。
-8：SIGFPE在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误。
-9：KILL强制终止一个job，本信号不能被阻塞、处理和忽略
-11：SIGSEGV试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.
-13：SIGPIPE通常在进程间通信产生，比如采用FIFO(管道)通信的两个进程，读管道没打开或者意外终止就往管道写，写进程会收到SIGPIPE信号。此外用Socket通信的两个进程，写进程在写Socket的时候，读进程已经终止。
-14：SIGALRM时钟定时信号, 计算的是实际的时间或时钟时间. alarm函数使用该信号.
-15：TERM信号，以正常步骤（该信号可以被阻塞和处理）结束一个job，等同于-SIGTERM
-17：SIGCHLD子进程结束时, 父进程会收到这个信号。如果父进程没有处理这个信号，也没有等待(wait)子进程，子进程虽然终止，但是还会在内核进程表中占有表项，这时的子进程称为僵尸进程。（父进程可以捕捉或忽略SIGCHILD信号，也可以wait它派生的子进程，或者父进程先终止，这时子进程的终止自动由init进程来接管）
-18：CONT继续信号，让一个停止(stopped)的进程继续执行，和STOP 信号相反。本信号不能被阻塞
-19：STOP暂停信号，和键盘输入Ctrl+Z等效。本信号不能被阻塞, 处理或忽略.
和fg不同，此处%是必须的，因为一般是使用PID在指定，只有加上%才指定的是jobid
直接使用：`kill PID`  
杀死同一过程组内的所有：`killall`

## 后台常驻
无论上面提到的前后台进程，其父进程都是当前终端连接的shell。同样，使用telnet或SSH远程登录linux时，启动的所有进程都会绑定到当前session上。
当用户注销（logout）或者网络连接断开时，终端会收到 SIGHUP（hangup）信号，从而关闭其所有子进程。而一旦父进程退出，则会发送HUP（hangup）信号给所有子进程，子进程收到hangup以后也会退出。
如果我们要在退出shell的时候继续运行进程，则需要使用nohup忽略hangup信号，或者setsid将将父进程设为init进程(进程号为1)

### 使用nohup
如果想要执行一个断连后，仍然工作的程序aaa，可以使用nohup命令：
nohup ./aaa &
标准输出和标准错误缺省会被重定向到当前目录的 nohup.out 文件中，如果当前目录的 nohup.out 文件不可写，输出重定向到 $HOME/nohup.out 文件中，也可用">filename 2>&1"来更改缺省的重定向文件名

### 使用setsid
其中sid指的是session id，意指以该命令运行的进程是一个新的session，因此其父进程id不属于当前终端
和nohup一样简单，只须在需要的命令前加上setsid，就可以将该命令的进程的父进程设置为1（即为 init 进程 ID），而不是当前终端的进程 ID
但输出重定向必须手动设置

setsid创建新会话的条件是，当前调用进程不能是进程组组长进程，否则返回错误。正常情况下会完成：(a)该进程变成会话首进程；(b)进程成为新的进程组组长进程；(c)该进程没有控制终端，即使在之前有控制终端，也会断开

我们知道，将一个或多个命名包含在“()”中就能让这些命令在子 shell 中运行中
当我们将"&"也放入“()”内之后，我们就会发现所提交的作业并不在作业列表中，也就是说，是无法通过jobs来查看的，此时的效果等价于使用setsid

上面两种方法都仅仅对尚未提交的命令有效，对于已经提交的命令可以使用disown
用`disown -h jobid`来使某个作业忽略HUP信号。
用`disown -ah`来使所有的作业都忽略HUP信号。
用`disown -rh`来使正在运行的作业忽略HUP信号。
当使用过 disown 之后，会将把目标作业从作业列表中移除，我们将不能再使用jobs来查看它，但是依然能够用ps -ef查找到它
注：这里的试验环境为Red Hat Enterprise Linux AS release 4 (Nahant Update 5),shell为/bin/bash，不同的OS和shell可能命令有些不一样。例如AIX的ksh，没有disown，但是可以使用nohup -p PID来获得disown同样的效果。

### 使用screen
适用于有大量这种命令需要在稳定的后台里运行

一般使用SSH远程登录后执行的所有进程都是这个登录bash的子进程，而这个登录bash则是一个sshd的一个子进程（通过pstree -H pid可以观察到这一点）。于是当SSH断开连接后，其子进程也就会依次响应SIGHUP信号而终止；而在使用screen -dmS后，screen本身是是守护进程，是init的子进程，所以即使SSH断开连接也不会影响screen内的子进程

screen 提供了 ANSI/VT100 的终端模拟器，使它能够在一个真实终端下运行多个全屏的伪终端。多个窗口可以同多个交互程序进行交互，而不用担心断线
用screen -dmS sessionName来建立一个处于断开模式下的会话（并指定其会话名）。 （使用-dmS建立的进程是守护进程，其父进程是init，而仅仅使用-S启动的进程是普通进程，是当前shell的子进程）
用screen -list（ls） 来列出所有会话。
用screen -r sessionName来重新连接指定会话。
在窗口中键入exit退出该窗口，如果这是该screen会话的唯一窗口，该screen会话退出，否则screen自动切换到前一个窗口。
也可以在Screen命令后跟你要执行的程序，则退出该程序也就退出会话

#### 选项
-S sessionname 创建screen会话时为会话指定一个名字n。注意，如果在.screenrc里面能把sessionname配置项指定了的话，-S是无效的。
-m 　即使当前已在作业中的screen作业，仍强制建立新的screen作业。
`-d|-D [pid.tty.host]` 不开启新的screen会话，而是断开其他正在运行的screen会话
-d -m 启动一个开始就处于断开模式的会话
-list|-ls 列出现有screen会话，格式为pid.tty.host（新版的使用 <pid>.sockname替代<pid>.<tty>.<host>）
`-wipe [match]` 同-list，但删掉那些无法连接（ls可以看到是dead状态）的会话
`-r sessionowner/ [pid.tty.host]` 重新连接一个断开的会话。多用户模式下连接到其他用户screen会话需要指定sessionowner，需要setuid-root权限
-R 　先试图恢复离线的作业。若找不到离线的作业，即建立新的screen作业。
-h num 指定历史回滚缓冲区大小为num行
-A 　将所有的视窗都调整为当前终端机的大小
-c file 使用配置文件file，而不使用默认的$HOME/.screenrc
`-s<shell>` 指定建立新视窗时，所要执行的shell。
-v 显示screen版本信息

#### 键组合
在screen的会话中可以使用特殊的键组合C-a（比如C-a c，即Ctrl键+a键，之后再按下c键，screen 在该会话内生成一个新的窗口并切换到该窗口）。这是因为我们在键盘上键入的信息是直接发送给当前screen窗口，必须用其他方式向 screen窗口管理器发出命令，默认情况下，screen接收以C-a开始的命令。这种命令形式在screen中叫做键绑定（key binding），C-a叫做命令字符（command character）。
Screen也允许你使用-e选项设置自己的命令字符和转义字符，其格式为：-exy x为命令字符，y为转义命令字符的字符
下面命令启动的screen会话指定了命令字符为C-t，转义C-t的字符为t，通过C-t ?命令可以看到该变化
screen -e^tt
常用的键绑定有：
C-a ?  ->  Help显示所有键绑定信息
C-a w  ->  Windows显示出所有已开启窗口的列表（可以看到这些窗口名字）
C-a c  ->  Create创建一个新的运行shell的窗口并切换到该窗口
C-a n  ->  Next切换到下一个窗口
C-a p  ->  Previous切换到前一个窗口(与C-a n相对)
C-a C-a  ->  切换到之前显示的窗口
C-a 0..9  ->  切换到窗口0..9
C-a [Space]  ->  下一个视窗（由视窗0循序换到视窗9）
C-a [backspace]  ->  前一个视窗（由视窗9循序换到视窗0）
C-a a  ->  发送 C-a到当前窗口，在 emacs, ve, bash, tcsh 下可移到行首
C-a d  ->  暂时断开当前screen会话
C-a K  ->  Kill杀掉当前窗口
C-a : -> 进入命令模式，可以输入quit，直接终止screen
`C-a [`或Esc  ->  进入进入 copy mode，在 copy mode 下可以回滚、搜索、 复制就像用使用 vi 一样
C-b Backward，PageUp
C-f Forward，PageDown
H（High），将光标移至左上角
L（Low），将光标移至左下角
0 移到行首
`$` 行末
w forward one word，以字为单位往前移
b backward one word，以字为单位往后移
Space 第一次按为标记区起点，第二次按为终点
Esc 结束 copy mode
`C-a ]` -> Paste，把刚刚在 copy mode 选定的内容贴上 
C-a S -> split，水平分屏，C-a <TAB>键来切换各个分割的区域， C-a x 关闭当前区域，C-a Q 关闭除当前区域外所有区域
C-a | -> 垂直分屏
C-a A -> 给当前窗口起名。最好能给每个窗口起一个名字，这样好记些。
C-a s  ->  锁住当前的 window，使用C-a q解锁
C-a x  ->  锁住当前的 window，需用用户密码解锁
C-a z  ->  把当前session放到后台执行，用 shell 的 fg 命令则可回去。
C-a t  ->  Time，显示当前时间，和系统的 load
C-a M ->  窗口发生变化，发送一个msg
C-a _  ->  窗口15秒没变化，发送一个msg

#### 配置
默认两级配置文件/etc/screenrc和$HOME/.screenrc
可以设定 screen选项，定制绑定键，设定screen会话自启动窗口，启用多用户模式，定制用户访问权限控制等等

##### 状态栏
默认的screen配置文件里面不会有提示栏的显示，类似上面截图的界面是通过自己修改配置文件来实现的。比如我的配置项是下面：
```s
hardstatus string '%{= kG}[%{Y}%l%{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %d/%m %{W}%c %{g}]'
```
最左边是当前系统的负载。中间是在screen中打开的终端tab标记(比如上面打开了5个终端连接)。最右边是当前系统的日期和时间。

screen status-bar有两种：caption和hardstatus。前者仅仅当多于一个窗口被打开，可以查看他们的详情；而后者用于显示来自于screen的状态信息（比如一些警告和提醒）
例如：
```s
caption string "%w"
hardstatus alwayslastline "This is a test..."
```
其中后者是长显的，如果不希望其总是长显，可以通过设置键绑定：
```s
# Toggle 'fullscreen' or not.
bind f eval "caption splitonly" "hardstatus ignore"
bind F eval "caption always" "hardstatus alwayslastline"
```
在screen中，可以C-a : 进入命令模式，进而可以使用screen 的命令
这样，就可以通过C-a f 取消长显，而用C-a F恢复长显

##### 多用户
screen默认是以单用户模式运行的，你需要在配置文件中指定multiuser on 来打开多用户模式，通过acl*（acladd,acldel,aclchg…）命令，你可以灵活配置其他用户访问你的screen会话。


##### 设置定时器
```s
backtick 1 5 5 uptime
hardstatus alwayslastline "%1`"
```
第一行backtick 设置一个定时器，ID为1，5秒后生效，且每个5秒refresh一次，执行的刷新操作来自uptime命令
第二行将第一行的output（通过指定ID为1的命令）显示到状态条中
<https://blog.csdn.net/proudeng/article/details/6089847>
字符串中的转义字符：
       % 转义字符自身
       a either 'am' or 'pm'
       A either 'AM' or 'PM'
       c current time HH:MM in 24h format
       C current time HH:MM in 12h format
       d day number
       D weekday name
       f flags of the window
       F sets %? to true if the window has the focus
       h hardstatus of the window
       H hostname of the system
       l current load of the system
       m month number
       M month name
       n window number
       s seconds
       t window title
       u all other users on this window
       w all window numbers and names. With '-' quailifier: up to the
              current window; with '+' qualifier: starting with the window
       W all window numbers and names except the current one
       y last two digits of the year number
       Y full year number

##### 示例
```s
startup_message off
term linux
defscrollback 4096
#在vi或less之类退出时完全恢复到原屏幕的内容
altscreen on
#显示屏幕下方状态栏
hardstatus alwayslastline
#状态栏的显示信息定制
hardstatus string "%{= kG}[%{G}{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B}%Y-%m-%d%{W} %c:%s%{g}]"
#默认开启的窗口，格式为： screen -t {窗口标题} {窗口数字编号(可选)} {screen之后执行的命令}）
#快捷键绑定
bindkey -k k1 select 1    #F1 to select 1
bindkey -k k7  title            #bind F7 to rename current screen window
bindkey -k k8 kill            #bind F8 to kill current screen window
bindkey -k k9 screen        #F9 to new a screen
bindkey -k k; detach        #F10 to detach
bindkey -k F11 prev        #F11 to previous
bindkey -k F12 next        #F12 to next
```
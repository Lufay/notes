# 常用功能命令

### 实用配置
```
alias la='ls -A'
alias ftplink='echo -n ftp://$HOSTNAME;readlink -f $1'
export LANG=zh_CN.UTF8
export LANGUAGE=zh_CN.GB18030:zh_CN.GB2312
export TERM=xterm-color
export PATH=.:$PATH
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
export PYTHONPATH=.:$PYTHONPATH
export JAVA_HOME=
export CLASSPATH=.:$CLASSPATH
```

### 查看二进制文件依赖的动态链接库
```
ldd [-d|-r] bin
```
-d --data-relocs　　执行符号重部署，并报告缺少的目标对象（只对ELF格式适用）
-r --function-relocs　　对目标对象和函数执行重新部署，并报告缺少的目标对象和函数（只对ELF格式适用）
注：
ldd本身不是一个程序，而仅是一个shell脚本，其依靠设置一些环境变量而实现的，比如`LD_TRACE_LOADED_OBJECTS(必要) LD_WARN LD_BIND_NOW LD_LIBRARY_VERSION LD_DEBUG`
其实质是通过ld-linux.so（elf动态库的装载器）来实现的。

### 查看当前目录下各个文件和目录的大小
```
find -maxdepth 1  -name '*' -exec du -sh {} \;
```
或
```
find -maxdepth 1 -mindepth 1|xargs du -sh
```
带上排序：
```
find -maxdepth 1  -name '*' -exec du -s {} \; | sort -n
```
*注*：-exec后面接的内容都将被视为内部命令的内容，直到读到 ; 为止，但 ; 又是shell的命令分隔符，为了避免被shell解析这个 ; 必须使用转义

### 统计代码行数
```
wc -l `find ./ -name "*.cpp" -o -name "*.h" -o -name "*.sh" -o -name "*.py" -o -name "*.php" -o -name "*.idl"`
```

### 获得文件所在的目录名
```
LOCALPATH=$(cd `dirname $0`;pwd)
```

### 批量变tab为4个空格
```
find -type f ! -name "Makefile" | while read fn
do
    expand -t4 $fn >$fn.expand
    mv $fn.expand $fn
done
```

## 系统信息
“/proc”(process information pseudo-filesystem 进程信息伪文件系统)中文件包含了各种系统信息
+ cpuinfo: CPU信息
+ meminfo: 内存信息
+ version: 版本信息
+ filesystems: 文件系统信息
+ dma: DMA通道信息
+ interrupts: 各设备的中断请求(IRQ)
+ bus/usb/devices: USB设备
+ /proc/bus/pci/devices: PCI设备
+ ioports: I/O端口号信息

### CPU
都在 /proc/cpuinfo 文件中
#### 物理CPU个数
```
grep 'physical id' /proc/cpuinfo | sort -u | wc -l
```
#### 单个CPU的物理核数
```
grep "cpu cores" /proc/cpuinfo | uniq
```
#### 单个CPU的逻辑核数
```
grep "siblings" /proc/cpuinfo | uniq
```
如果逻辑核数是物理核数的两倍，表示支持超线程技术，否则表示不支持或没有启动超线程（将一个物理核模拟成两个逻辑核，有助于并行计算）
#### 总逻辑核数
```
grep -c processor /proc/cpuinfo
```

### 内存
都在 /proc/meminfo 文件中
MemTotal: 内存总量
MemFree: 空闲内存量

```
free -m # 查看内存使用量和交换区使用量  (total属性下显示的是内存的大小，m表示显示单位是MB)
```

### 内核版本
```
cat /proc/version
```
```
uname -r
```

### 发行版本
```
head -n1 /etc/issue
```
更多信息
```
lsb_release -a
```

### 主机名和IP
```
hostname    # 获得本机机器名
$HOSTNAME
hostname -i    # 获得本机IP

nslookup $mach_name    # 获得指定机器名的IP
nslookup $ip   # 根据IP 获取注册的域名

uname -n
```

```
/sbin/ifconfig |awk -F'[ :]+' '/Bcast/{print $4}'
```
可能有多个（网卡）
也可能有没启动的网卡，可以到`/etc/sysconfig/network-scripts`目录下去查看，有诸如ifcfg-eth0、ifcfg-eth1的文件
对应的可以使用
```
ifup eth0
```
启动网卡

#### netstat
该命令的输出分为两部分：Active Internet connections 和 Active UNIX domain sockets
前者包括如下内容：
Proto：连接使用的协议
Recv-Q：接收队列（一般是0）
Send-Q：发送队列（一般是0）
Local Address
Foreign Address
State
后者本机通信的套接字，性能更高，包括如下内容：
Proto：连接使用的协议
RefCnt
Flags
Type：套接字的类型
State：套接字的当前状态
I-Node Path：连接到套接字的其它进程使用的路径名

#### 选项
-a (all)显示所有选项，默认不显示LISTEN相关
-l 仅列出在 Listen (监听) 状态的连接
-t (tcp)仅显示tcp相关选项
-u (udp)仅显示udp相关选项
-x 仅显示UNIX 套接字
-n 拒绝显示别名，能显示数字的全部转化成数字。
-p 显示建立相关链接的程序PID和程序名（并不是所有都能显示，使用root权限可以查看所有）
-r 显示路由信息，路由表
-i 显示网络接口列表
-e 显示扩展信息，例如uid等
-s 按各个协议进行统计
-c 每隔1s执行该netstat命令
```
netstat -lntp # 查看所有监听端口
netstat -antp # 查看所有已经建立的连接
netstat -rm # 检查路由表
netstat -s # 查看网络统计信息
```

### 查看磁盘
```
fdisk -l
```
需要root权限

### 查看各分区的文件系统类型与使用情况
```
df -hT
```

### 查看指定目录大小
```
du -sh $dir
```

### 进程
#### ps 命令
```
ps -ef # 查看所有进程
ps aux
```

#### top 命令
top 实时显示进程状态 用户，内存 进程 负载 都有了
##### 选项
-p: 指定查看的进程号
-u/-U: 查看指定用户的进程
-d: 指定刷新间隔（秒）
-n: 指定刷新几次（常和-b联用）
-b: 批处理模式，用于把输出传给其他程序或文件，不再接受输入
-c: COMMAND 列显示命令行而不是程序名
##### 显示信息
+ 第一行是负载信息，信息格式和uptime 命令相同（当前时间、系统运行时间、当前登录用户数、系统负载）
    - 系统运行时间，格式为天、小时:分钟
    - 系统负载，即任务队列的平均长度，三个数值分别为  1分钟、5分钟、15分钟前到现在的平均值。
+ 第二行是Tasks信息，可以看到系统running、sleeping、stopped、zombie进程的个数
+ 第三行是Cpu信息：us表示用户进程占用CPU比例，sy表示内核进程占用CPU比例，id表示空闲CPU百分比，wa表示IO等待所占用的CPU时间的百分比
+ 第四行是Mem信息：total是总的内存大小，used是已使用的，free是剩余的，buffers是用作内核缓存的内存量
+ 第五行是Swap信息：同Mem行，cached表示缓存的交换区总量（即内容已存在于内存中的交换区的大小。相应的内存再次被换出时可不必再对交换区写入），例如用户打开的文件。如果Swap的used很高，则表示系统内存不足。
+ 下面是进程信息
    - PID 进程id
    - PPID 父进程id
    - RUSER Real user name
	- UID 进程所有者的用户id
	- USER 进程所有者的用户名
	- GROUP 进程所有者的组名
	- TTY 启动进程的终端名。不是从终端启动的进程则显示为 ?
	- PR 优先级
	- NI nice值。负值表示高优先级，正值表示低优先级
	- P 最后使用的CPU，仅在多CPU环境下有意义
	- %CPU 上次更新到现在的CPU时间占用百分比
	- TIME 进程使用的CPU时间总计，单位秒
	- TIME+ 进程使用的CPU时间总计，单位1/100秒
	- %MEM 进程使用的物理内存百分比
	- VIRT 进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
	- SWAP 进程使用的虚拟内存中，被换出的大小，单位kb。
	- RES 进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
	- CODE 可执行代码占用的物理内存大小，单位kb
	- DATA 可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb
	- SHR 共享内存大小，单位kb
	- nFLT 页面错误次数
	- nDRT 最后一次写入到现在，被修改过的页面数。
	- S 进程状态。 D=不可中断的睡眠状态 R=运行 S=睡眠 T=跟踪/停止 Z=僵尸进程
	- COMMAND 命令名/命令行
	- WCHAN 若该进程在睡眠，则显示睡眠中的系统函数名
	- Flags 任务标志，参考 linux/sched.h
##### 交互指令
h：使用帮助
f：选择想要查看的进程信息项（第一列是显示/隐藏的快捷键，最后按回车键确定）
o：进程信息项排序（第一列是显示/隐藏的快捷键，小写下移，大写上移，最后按回车键确定）
F/O：可以选择进程按照哪个进程信息项进行排序（第一列是显示/隐藏的快捷键，最后按回车键确定），还可以使用'<'/'>'快捷键左右切换排序列
R：进程排序反转
c：切换COMMAND 列显示命令行还是程序名
s：改变两次刷新之间的延迟时间。系统将提示用户输入新的时间，单位为s。如果有小数，就换算成ms。输入0值则系统将不断刷新，默认值是5 s。需要注意的是如果设置太小的时间，很可能会引起不断刷新，从而根本来不及看清显示的情况，而且系统负载也会大大增加。
k：终止一个进程。系统将提示用户输入需要终止的进程PID，以及需要发送给该进程什么样的信号。一般的终止进程可以使用15信号；如果不能正常结束那就使用信号9强制结束该进程。默认值是信号15。在安全模式中此命令被屏蔽。
r：重新安排一个进程的优先级别。系统提示用户输入需要改变的进程PID以及需要设置的进程优先级值。输入一个正值将使优先级降低，反之则可以使该进程拥有更高的优先权。默认值是10。
q：退出
1：展示出服务器有多少CPU，及每个CPU的使用情况
W：将当前设置写入~/.toprc文件中。这是写top配置文件的推荐方法。

### 用户
```
w # 查看活动用户
id <用户名> # 查看指定用户信息
last # 查看用户登录日志
cut -d: -f1 /etc/passwd # 查看系统所有用户
cut -d: -f1 /etc/group # 查看系统所有组
```

### 系统限制
查看所有：ulimit -a
可以看到每一项的具体选项，例如 ulimit -n 可以看到最大打开的文件句柄数（包括socket），也可以后面跟一个数字直接修改（当前shell有效，并且对于非root用户只能改小，不能改大），另外还可以加上`-H`, `-S` 选项表示硬限制和软限制
如果想要修改永久有效，可以修改 /etc/security/limits.conf 文件
soft 和 hard 表示硬限制和软限制


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

### 网络上的主机名
```
hostname
$HOSTNAME
```
```
uname -n
```

### 获取IP
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
-u: 查看指定用户的进程
-d: 指定刷新间隔（秒）
-n: 指定刷新几次（常和-b联用）
##### 显示信息
第一行是负载信息，信息格式和uptime 命令相同
第二行是Tasks信息，可以看到系统running、sleeping、stopped、zombie进程的个数
第三行是Cpu信息：us表示用户进程占用CPU比例，sy表示内核进程占用CPU比例，id表示空闲CPU百分比，wa表示IO等待所占用的CPU时间的百分比
第四行是Mem信息：total是总的内存大小，userd是已使用的，free是剩余的，buffers是目录缓存
第五行是Swap信息：同Mem行，cached表示缓存，用户已打开的文件。如果Swap的used很高，则表示系统内存不足。
##### 指令
q：退出
1：展示出服务器有多少CPU，及每个CPU的使用情况


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


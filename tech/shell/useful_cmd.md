# 常用功能命令

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



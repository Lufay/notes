# 内存

/proc/meminfo 文件，它是一个虚拟文件用于报告系统内存信息：
+ 全部内存（MemTotal）
+ 空闲内存（MemFree）
+ 可用内存（MemAvailable）
+ 缓冲区（Buffers）：用于暂存写磁盘的内容
+ 文件缓存（Cached）：用于从磁盘读取的高速缓存
+ 交换缓存（SwapCached）
+ 全部交换区（SwapTotal）
+ 空闲交换区（SwapFree）
/proc/$pid/statm 显示指定进程所占用的内存
/proc/$pid/maps 显示指定进程所占用的虚拟地址

free命令，可以查看该文件收集到的信息的一个总览（默认单位是block，可以使用-m 指定单位为MB 或-g 单位为GB）：
+ shared: 多个进程共享的内存
+ buffers: 系统分配但未被使用的缓冲区
+ cached: 系统分配但未被使用的缓存
+ -/+ buffers/cache: Linux 为了进行高速访问，尽可能的使用buffers+cache 缓存一些内容，所以free 内存就比较少，而这些缓存对于进程而言是可以立即释放投入使用的，所以这里显示的是实际占用和实际可用的内存
+ Swap: 磁盘交换区（也就是虚拟内存）若值大于0，代表服务器物理内存已经遇到内存瓶颈了，已开始使用虚拟内存了

top命令，也可以查看当前内存和交换区的使用情况，以及每个进程使用的内存占比
使用`top -o $MEM` 可以把进程按使用占比进行排序

pmap命令，`pmap -d $pid` 可以查看指定进程的内存使用情况

vmstat命令，可以查看当前虚拟内存的统计信息

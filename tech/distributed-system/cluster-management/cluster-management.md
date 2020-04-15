# 集群管理系统

## 基础技术
### cgroup
CGroup 是 Control Groups 的缩写，是 Linux 内核提供的一种可以限制、记录、隔离进程组 (process groups) 所使用的物力资源 (如 cpu memory i/o 等等) 的机制。
CGroup 是将任意进程进行分组化管理的 Linux 内核功能。CGroup 提供了一个 CGroup 虚拟文件系统，作为进行分组管理和各子系统设置的用户接口。要使用 CGroup，必须挂载 CGroup 文件系统。

#### 相关概念
+ task: 就是一个进程（该进程的子进程默认成为父进程cgroup的成员）
+ control group: 一组按照某种标准划分的进程。是实现资源控制的单位，一个进程可以加入一个控制组也可以迁移到另一个组（一个进程可以加入属于不同hierarchy的控制组）。一个控制组也必须存在于一个hierarchy中。
+ hierarchy: 控制组组织形式（树形层次关系）子控制组继承父控制组的属性。在系统中创建hierarchy，会自动创建一个控制组，称之为root cgroup，在该hierarchy中创建的cgroup都是其后代。
+ subsystem: 一个子系统就是一个资源控制器（如cpu/mem等），子系统通过attach到一个hierarchy上（而且也只能attach到一个hierarchy上，但反之可以被attach多个子系统），从而控制这个hierarchy上所有控制组的资源使用。

如图
![概念关系图](http://www.ibm.com/developerworks/cn/linux/1506_cgroup/img001.png)

通常系统默认包含了8 种子系统：
+ cpu: cpu 时间片
+ cpuset: 指定运行的核
+ cpuacct: 
+ memory: 内存
+ blkio: 块设备IO 时间片
+ devices: 是否允许对设备的访问
+ freezer: 所有进程挂起
+ net-cls: 网络收发的带宽

#### 创建cgroup 文件系统
```
sudo mount -t cgroup -o memory memory_cgroup /dev/cgroup/
```
在/dev/cgroup/ 下创建了一个memory 的hierarchy（-t 指定文件系统类型，-o 指定attach的子系统，而后是hierarchy 的层级名称，最后是挂载位置）
当创建了一个cgroup实例后，对应的挂载点下会有一些文件，这些文件是用户与cgroup进行交互的接口。由于cgroup位于VFS层之下，因此用户可以通过统一的文件操作接口去读取或设置子系统的参数，当然也可以直接使用echo或者cat等命令。

#### 参考
<http://www.ibm.com/developerworks/cn/linux/1506_cgroup/index.html>
<http://my.oschina.net/cloudcoder/blog/424418?p=1>
<http://www.cnblogs.com/yjf512/p/3298582.html>
<http://blog.chinaunix.net/uid-26127124-id-3404142.html>
<http://blog.chinaunix.net/uid-20940095-id-3294134.html>
<http://bbs.chinaunix.net/thread-3574612-1-1.html>
<http://blog.sina.com.cn/s/blog_4af327e10101hvfw.html>
<http://blog.blog.chinaunix.net/uid-26896862-id-3847068.html>
<http://edsionte.com/techblog/archives/4336>


## Borg
google 的服务器集群管理系统
通过 Borg，公司可以将众多数据中心视为一个电脑，进行统一管理。

### 优点
+ 屏蔽资源管理和失败处理，使用户专注应用开发，不必操心资源管理的问题
+ 高可靠性、高可用性
+ 跨多个数据中心的资源利用率最大化

### 使用场景
用户以job的形式提交任务，每个job包含一个或者多个tasks，每个job运行在一个cell里，cell是机器的集合（通常包括1万台服务器）。
集群，一般来说包含了一个大型cell，有时也会包含一些用于特定目的的小cell。一个集群通常来说是在一个数据中心大楼里，集群中的所有机器都是通过高性能的网络进行连接的。
它负责对来自于几千个应用程序所提交的job进行接收、调试、启动、停止、重启和监控，这些job将用于不同的服务，运行在不同数量的集群中。

#### Job
有两种类型：
+ prod job（即生产job）：常驻型，这些服务的响应延迟很短，最多几百毫秒。例如：gmail，google docs，google搜索等服务，以及bigtable，GFS
+ non-prod job：批处理型，无须对请求进行即时响应，运行的时间也可能会很长，甚至是几天。

prod job 相对于 non-prod job来说优先级更高，通常会占用更多的资源
在cell 中混合不同类型的job，需要结合不同类型任务的特点，做出不同的调度策略。目的在于尽可能地优化资源的使用情况，能够节约Google在整个数据中心上的成本 。

##### Task
每个task都会有一个优先级，高优先级的task可以抢占低优先级的task的资源，优先级是一个正整数，borg里将这些优先级分成4类：monitoring, production, batch, and best e ort

#### 资源管理
alloc的本质上就是现在的容器，用来运行一个或者多个task，是task的运行环境，是一组资源的描述。多个task可以同时跑在一个alloc里，一个task跑完了可以将alloc分配给另外一个task使用
配额（quota）：表示所需要的资源，例如cpu，内存，网络带宽，磁盘
硬限，软限
google并没有使用虚拟机的方式来进行task之间的资源隔离，而是使用轻量级的容器技术cgroup

### 参考
<http://xpc.im.baidu.com/html/richmedia/show.html?t=1&key=NjQ5ZWExYWJhODJlMjU0NzEwZWNkMjY5MWIzMjlhMTc1NTBjNmQyNGJkN2Y4ZmE0NWQ1ZTIwYzRhNzQwOGY0NA&index=1#>

## Kubernetes


## Mesos
由 Twitter 工程师开发，开源
2009年发布，2019年5月2日宣布转向 Kubernetes

## Matrix
百度的现行集群管理系统

## galaxy
百度开源

## 伏羲(Fuxi)
阿里云的资源管理和任务调度系统

## 台风
腾讯的云计算平台



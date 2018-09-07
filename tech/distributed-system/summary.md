# 分布式系统概述
[资料](http://book.mixu.net/distsys/ebook.html)

关注点
+ 离线：吞吐量
+ 在线：高并发（care延迟）
+ 数据一致性限制了存储数据的可用性（不一致的窗口内的可用性下降）
+ CAP原则
+ 可靠性
+ 扩展性、伸缩性
+ 资源共享
+ 可信计算：依赖于系统的可靠性

## 方向
### 分布式存储模型
1. kv 哈希 随机seek 快
2. 有序 顺序scan 快
3. 全局有序 例如：bigtable、Tera

### 分布式计算
多线程编程：可开的线程数有限，CS模式下可用连接数有限
事件驱动开发：异步回调，性能较好，当回调嵌入回调，思路就很麻烦，也难于调试。例如ESP kylin，nginx
Coroutine（协程）：综合上两者。是一种非抢占调度（在用户态下，自己管理挂起和恢复）（适合少计算大IO）。可以参考lua和golang语言。http://www.douban.com/note/11552969/
<http://articles.csdn.net/plus/view.php?aid=307323>
参考：<http://www.kuqin.com/system-analysis/20110910/264592.html>

MapReduce下一代分裂为
资源调度YARN，计算Tez

### 两者关系
存储模型和计算模型是相辅相成的，一种计算模型仅仅适用于某种存储模型


## 工具
特别提下GO语言
分布式系统开发系统的利器
性能、内存和C相近，比Python优一个数量级
有单测框架，覆盖率统计，有CPU、内存的profile
执行错误报告也有panic
GC延迟的问题，应根据应用场景想办法绕过
优化点：起因：扫描，对象探活；解决方法：使用对象的集合，比如对象数组（仅扫描一次）；或者，使用对象池，复用对象，减少新对象的生成
但问题是如果对象持久比较多，可以采用多进程，控制进程进行集中gc，在gc 期调度另一个进程进行服务，以避免gc 服务断流
<http://www.zhihu.com/question/23486344>
<http://wiki.babel.baidu.com/twiki/bin/view/Main/Golang_presentation>
<http://nil.csail.mit.edu/6.824/2015/>

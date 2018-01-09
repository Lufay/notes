# RPC 协议
## 服务化的关注点
1. 序列化协议
表达能力（语言适配性），扩展性（版本的兼容性，服务的变更），性能
1. 通信协议
TCP
HTTP
1. 服务地址管理
服务的弹性伸缩和迁移（云）需要动态发现机制
服务的注册和授权
一种非常流行的做法是服务提供者会把它的服务注册到注册中心，消费者会去订阅拉取这些消息，然后在本地缓存一个提供者的信息。这样每一次交互的时候，只查本地内存就可以了，不需要强依赖这个注册中心（降低中心节点的压力和依赖），实际上对服务中心依赖就是一个弱依赖，当配置中心的服务元信息发生变化时，通过通知的方式告知服务使用者更新本地缓存。管理的服务节点数在万级以内用ZK比较成熟，规模再大一点时延和性能包括可靠性会有一些问题，这时可以考虑一些其他的技术手段。
1. 低耦合，低侵入
采用配置化的方式进行服务注入，动态查找和加载服务组件
1. 容错和路由
负载均衡（流控）和容灾策略（故障隔离），本地短路策略（不走网络，不用序列化）
最佳状态就是我们要做无状态，其实应用肯定是要状态的。但是我们做应用的时候，把它的状态信息不要扔到本地，最终要放出去，不管是缓存还是放到统一集中式的会话管理中心。最终是不会扔到本地的，因为扔到本地有几个问题，第一个是幂等性肯定没法状态，第二个是有了状态以后，重试就会有一些问题。
1. 多种调用方式
同步，异步（回调）
1. 性能：吞吐和时延
单服务节点处理的消息数（QPS）
取决于IO 模型（BIO/NIO），序列化（文本、二进制、压缩）和线程调度模型（核心理念就是尽量的无锁）
1. 服务部署
Docker 和PaaS平台（VM）
自动化部署和生命周期管理

## 各种RPC 协议
最早为人所知并接受的RPC实现是由Sun提供的SunRPC机制，使用在其网络文件系统（NFS）中。
常见的RPC机制还包括Java的RMI、DCOM、XML-RPC、SOAP、CORBA，以及Google的gRPC等等。
https://christophermeiklejohn.com/pl/2016/04/12/rpc.html
http://www.open-open.com/lib/view/open1426302068107.html

### XML-RPC
+ 冗余数据太多，处理速度太慢

### jsonRPC
+ 受 JavaScript 语言子集的限制，可表示的数据类型不够多
+ 无法表示数据内的自引用，互引用和循环引用

### ZeroC Ice

### Thrift
最初由Facebook于2007年开发，2008年进入Apache开源项目
通过一个中间语言(IDL, 接口定义语言)来定义RPC的接口和数据类型，然后通过一个编译器生成不同语言的代码（目前支持C++,Java, Python, PHP, Ruby, Erlang, Perl, Haskell, C#, Cocoa, Smalltalk和OCaml）,并由生成的代码负责RPC协议层和传输层的实现。

### Finagle
Twitter基于Netty开发的支持容错的、协议无关的RPC框架

### Protocol Buffer
gRpc 采用http协议，性能上差了许多，而且像服务治理与监控都需要额外的开发工作

### Avro
是Hadoop的一个子项目，一个数据序列化系统，设计用于支持大批量数据交换的应用。

### sofa
百度内部的组件式开发框架
基于boost asio 和epoll

### Dubbo
Alibaba 开源的基于Netty的TCP RPC框架
RMI的序列化和反序列化是JAVA自带的，Hessian里的序列化和反序列化是私有的，传输协议则是HTTP，Dubbo的序列化可以多种选择，一般使用Hessian的序列化协议，传输则是TCP协议，使用了高性能的NIO框架Netty。
Hessian 是一个基于HTTP的远程方法调用，在性能方面还不够完美，负载均衡和失效转移依赖于应用的负载均衡器
已于12年底停止维护，可以使用dubbox，是当当团队基于dubbo升级的一个版本
序列化可以使用Kryo 提高性能
反射可以使用reflectasm
使用objenesis来创建无默认构造函数的类的对象

### Motan
新浪微博开源的一套轻量级、方便使用的RPC框架
<https://github.com/weibocom/motan/>

### Tars
<https://github.com/Tencent/Tars>
<http://www.oschina.net/news/83719/tencent-tars-opensource?nocache=1491815068108>

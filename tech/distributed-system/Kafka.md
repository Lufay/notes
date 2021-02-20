# Kafka
分布式流处理平台
[官网](http://kafka.apache.org/)
Kafka的目的是通过Hadoop的并行加载机制来统一线上和离线的消息处理

1. 分布式消息队列（发布：生产者，订阅：消费者）
消息队列（Message Queue）：把消息按照产生的次序加入队列，而由另外的模块将其从队列中取出，并加以处理；从而形成了一个基本的消息队列。
使用消息队列可以很好地将任务以异步的方式进行处理，或者进行数据传送和存储等。也可以很好进行模块间的解耦、平滑流量
保证时序性是MQ的一个基本要求。
1. 容错存储
1. 流处理

用于构建可靠的系统间实时流数据管道，也用于构建变换流数据的实时流应用

## 概念
Kafka 存储的数据分类叫做topics
对于每个topic，Kafka 维护多个partition，每个partition 是一个记录的队列，每个记录被分配了一个时序id，称为offset，唯一标识其在partition 中的位置。
可以配置一个Kafka 保存记录的时间，在该时间内，所有记录都会被保存，无论是否被订阅者消费
每条记录包含了一个key，一个value，和一个时间戳

### 分布式
多个partition 分布在多个server上（这个server称为broker），每个partition存在数据冗余以容错。
每个partition 的这些server其中有一个是leader，其他是followers，leader处理所有的读写请求，followers被动从leader同步，如果leader挂掉后，一个follower就会自动成为leader。
每个server同时作为它上面一些partition的leader，和其他partition的follower，以此进行负载均衡。
依赖于zookeeper保存一些meta信息来保证系统可用性

### 四种API
+ Producer API 发布流数据到一个或多个topics中，它还负责哪个记录分配到哪个partition上
+ Consumer API 订阅一个或多个topics，将收到处理完的流数据。每个Consumer属于一个特定的Consumer Group（可为每个Consumer指定group name，若不指定group name则属于默认的group）
+ Streams API 作为流处理器，从输入topics 获取流数据处理后放到输出topics中
+ Connector API 连接Kafka topics 和其他系统（例如数据库）

![](./kafka-apis.png)
![](http://kafka.apache.org/images/kafka-apis.png)

其他：
http://blog.jobbole.com/75328/
https://my.oschina.net/u/2279119/blog/774700

python kafka
http://chenxiuheng.iteye.com/blog/2265887
http://blog.csdn.net/chuliuxiangjiao/article/details/46838545

消息队列的应用场景
http://www.oschina.net/translate/top-10-uses-for-message-queue

ELK(ElasticSearch, Logstash, Kibana)
http://www.tuicool.com/articles/YR7RRr


# Spark
[HOME](http://spark.apache.org)

[TOC]

比MapReduce 提供了更丰富的算子

Spark将分布式数据抽象为弹性分布式数据集（RDD），实现了应用任务调度、RPC、序列化和压缩，并为运行在其上的上层组件提供API。
其底层采用Scala这种函数式语言书写而成，并且所提供的API深度借鉴Scala函数式的编程思想，提供与Scala类似的编程接口。
Spark程序其实是隐式地创建出了一个由操作组成的逻辑上的有向无环图DAG，这样 Spark就把逻辑计划转为一系列步骤(stage)，而每个步骤又由多个任务组成。

Spark驱动器是执行程序中的main()方法的进程，负责将用户程序转换为task（driver，物理执行计划）。
而后在各个执行器（executor）进程间协调任务的调度（基于数据所在位置分配给合适的执行器）。
当执行任务时，执行器进程会把数据缓存起来，而驱动器进程同样会跟踪这些缓存数据的位置，并利用这些位置信息来调度以后的任务，以尽量减少数据的网络传输（就是所谓的移动计算，而不移动数据)。

执行器负责运行task，并将结果返回给驱动器进程。
通过自身的块管理器(blockManager)为用户程序中要求缓存的RDD提供内存式存储（执行器进程内）。

驱动器程序通过一个SparkContext对象来访问spark（在spark-shell 中已经预创建了一个sc 的变量，通过sparkConf对象来加载集群的配置），而后使用sc 创建RDD
RDD（Resilient Distributed Datasets）弹性分布式数据集，是分布式内存的一个抽象概念。它是只读的记录分区的集合，高度受限，只能通过其他RDD执行确定的转换操作（如map、join和group by）而创建。
Transformation返回值还是一个RDD。它使用了链式调用的设计模式，对一个RDD进行计算后，变换成另外一个RDD，然后这个RDD又可以进行另外一次转换。这个过程是分布式的。该操作是lazy的，等到有Action 的时候才会真正启动计算过程进行计算。
Action返回值不是一个RDD。它要么是一个Scala的普通集合，要么是一个值，要么是空，最终或返回到Driver程序，或把RDD写入到文件系统中。
Spark 会在你每次对它们进行行动操作时重新计算。如果想在多个行动操作中重用同一个RDD，那么可以使用RDD.persist()或RDD.collect()让Spark把这个RDD缓存下来。（可以是内存，也可以是磁盘)

窄依赖 (narrowdependencies) 和宽依赖 (widedependencies) 
窄依赖是指 父 RDD 的每个分区都只被子 RDD 的一个分区所使用 。相应的，那么宽依赖就是指父 RDD 的分区被多个子 RDD 的分区所依赖。例如，map 就是一种窄依赖，而 join 则会导致宽依赖。
窄依赖支持在一个结点上管道化执行；窄依赖支持更高效的故障还原，因为对于窄依赖，只有丢失的父 RDD 的分区需要重新计算。


Spark 会尽可能地管道化，并基于是否要重新组织数据来划分 阶段 (stage)。
而后将各阶段划分成不同的 任务 (task) ，每个任务都是数据和计算的合体。在进行下一阶段前，当前阶段的所有任务都要执行完成。因为下一阶段的第一个转换一定是重新组织数据的，所以必须等当前阶段所有结果数据都计算出来了才能继续。

Spark SQL的核心是把已有的RDD，带上Schema信息，然后注册成类似sql里的”Table”，对其进行sql查询。
如果是spark-hive项目，那么读取metadata信息作为Schema、读取hdfs上数据的过程交给Hive完成，然后根据这俩部分生成SchemaRDD，在HiveContext下进行hql()查询。
SparkSQL可以读取Hive支持的任何表。要把Spark SQL连接已有的hive上，需要提供Hive的配置文件。hive-site.xml文件复制到spark的conf文件夹下。再创建出HiveContext对象(sparksql的入口)，然后就可以使用HQL来对表进行查询，并以由行组成的RDD的形式拿到返回的数据。


```
val sparkConf = newSparkConf().setMaster("local").setAppName("cocapp").set("spark.executor.memory","1g")
val sc: SparkContext = new SparkContext(sparkConf))
rdd = sc.textFile(...)
		.map(a => (a.charAt(0), a))
		.groupByKey()
		.mapValues(a => a.toSet.size)
		.collect()	// Action
rdd.first()		// Action，会返回RDD的第一个元素
```

[Spark知识体系完整解读](http://mt.sohu.com/20160522/n450849016.shtml)
[与 Hadoop 对比，如何看待 Spark 技术？](http://www.zhihu.com/question/26568496)
[Spark入门（Python版）](http://blog.jobbole.com/86232/)
[从Hadoop到Spark的架构实践](http://www.csdn.net/article/2015-06-08/2824889)

# Hadoop
[官方文档](http://hadoop.apache.org/docs/)

一个典型的Map-Reduce过程包括：`Input->Map->Patition->Reduce->Output`。Pation负责把Map任务输出的中间结果按key分发给不同的Reduce任务进行处理。
当然，“分块计算(map)->汇总处理(reduce)”这个过程可以多次重复

每次调用hadoop client都需要通过返回值$?判断是否成功

## HDFS
```
hadoop dfs -test -d $hdfs_path  # 查看HDFS 路径是否存在
hadoop dfs -test -e $hdfs_file  # 查看HDFS 文件是否存在
hadoop dfs -ls $hdfs_path       # 查看一个HDFS 路径
hadoop dfs -lsr $hdfs_path      # 递归查看一个HDFS 路径
hadoop dfs -cat $hdfs_file      # 查看一个HDFS 文件

hadoop dfs -rm $hdfs_file       # 删除一个HDFS 文件
hadoop dfs -rmr $hdfs_path      # 删除一个HDFS 路径

hadoop dfs -mkdir $hdfs_path    # 创建一个HDFS 路径

hadoop dfs -put $local_file $hdfs_path  # 把一个本地文件上传到HDFS
hadoop dfs -get $hdfs_file $local_path  # 把一个HDFS 文件下载到本地
hadoop dfs -copyToLocal
```

## Hadoop Streaming
命令：
```
hadoop streaming \
    -input $hdfs_path \
    -output $hdfs_dir \
    -file $local_file \
    -mapper $map_cmd \
    -reducer $reducer_cmd \
    -D $config \
    -jobconf $job_conf \
    -cmdenv $env_var=$env_val
```
其中：
+ -input 是输入文件路径（HDFS 路径），可以使用通配符`*`，可以指定多个。文件的每一行被认为一个key/value，默认分隔符是\t。在mapper 的程序中可以通过名为`map_input_file` 的环境变量查看该文件名。
+ -output 是输出文件路径（HDFS 路径，且该目录必须事先不存在）最终输出结果为每个reduce对应一个文件，文件名固定为part-00000、part-00001 ...
+ -file 是需从客户端所在机器上传到hadoop server的文件，如map/reduce程序/脚本、程序配置文件、词典文件等
如果词典文件比较大，可以使用-files 选项，该选项后面跟的是HDFS上的一个文件，也可以使用#符号在本地建一个系统链接，例如`hdfs://host:fs_port/user/dict.txt#dict_link`，则可以`fopen("dict_link ","r")`或`fp = fopen("dict.txt ","r")`
+ -mapper/-reducer 是每个mapper/reducer 的执行命令
map/reduce程序/脚本的输入被固定为标准输入，输出被固定为标准输出。
Map/reduce程序尽量输出一些重要的错误日志到标准错误输出，不要写本地log。
每个reduce的输入是经过了排序的（以第一个Tab之前的字符串作为key进行排序，key和value默认按第一个tab键进行分割，也可以指定分割符
单机程序在遇到如下异常时，必须主动退出：从标准输入读到eof, 读标准输入异常，pipe broken异常，写标准输出异常，写标准错误输出异常。
+ -D
    - stream.map.input.field.separator 和stream.map.output.field.separator：map task输入/输出数据的分隔符,默认均为\t
    - stream.num.map.output.key.fields：指定map task输出记录中key所占的域数目
    - stream.reduce.input.field.separator 和stream.reduce.output.field.separator：reduce task输入/输出数据的分隔符，默认均为\t
    - stream.num.reduce.output.key.fields：指定reduce task输出记录中key所占的域数目
+ -jobconf Hadoop 任务的配置，常用的配置项包括：
    - mapred.job.name：任务名
    - mapred.job.priority：任务优先级
    - mapred.job.map.capacity
    - mapred.job.reduce.capacity
    - mapred.reduce.tasks
    - mapred.reduce.memory.limit
+ -cmdenv 给job 提供的环境变量（可以在mapper 和reducer 中使用）

streaming正常结束的返回值一定是0

### Patition
把Map任务输出的中间结果按key分发给不同的Reduce任务进行处理
Hadoop 提供了一个非常实用的partitioner类KeyFieldBasedPartitioner，通过配置相应的参数就可以使用。
使用方法：
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner
一般配合：
    -D map.output.key.field.separator：指定key内部的分隔符
    -D num.key.fields.for.partition：指定对key分出来的前几部分做partition而不是整个key
使用

### 二进制格式数据
0.21.0版本中增加了两种二进制文件格式，分别为：
+ rawbytes：key和value均用【4个字节的长度+原始字节】表示
+ typedbytes：key和value均用【1字节类型+4字节长度+原始字节】表示
如果用-io指定二进制格式为typedbytes，则map的输入输出，reduce的输入输出均为typedbytes，如果想细粒度的控制这几个输入输出，可采用以下几个选项：
    -D stream.map.input=[identifier]
    -D stream.map.output=[identifier]
    -D stream.reduce.input=[identifier]
    -D stream.reduce.output=[identifier]
python 可以使用typedbytes 库进行解析

### 环境变量
streaming框架通过设置环境变量的方式给mapper、reducer程序传递配置信息。常用的环境变量如下：
	HADOOP_HOME 计算节点上配置的Hadoop路径
	LD_LIBRARY_PATH 计算节点上加载库文件的路径列表
	PWD 当前工作目录
	dfs_block_size 当前设置的HDFS文件块大小
	map_input_file mapper正在处理的输入文件路径
	mapred_job_id 作业ID
	mapred_job_name 作业名
	mapred_tip_id 当前任务的第几次重试
	mapred_task_id 任务ID
	mapred_task_is_map 当前任务是否为map
	mapred_output_dir 计算输出路径
	mapred_map_tasks 计算的map任务数
	mapred_reduce_tasks 计算的reduce任务数

相关参数在streaming中`.`用`_`代替即可




# Redis
REmote DIctionary Server
[TOC]
Redis是一个使用ANSI C语言编写的、开源的Key-Value 内存数据库，和Memcached类似，但它支持存储的value类型相对更多，包括字符串、哈希表、列表、集合、有序集合，位图，hyperloglogs等数据类型。
可以定期通过异步操作把数据flush 到硬盘
[参考](http://www.redis.net.cn/)
[中文文档](http://www.redis.cn/documentation.html)
[命令参考](http://redisdoc.com/)
[对比Memcached](https://www.zhihu.com/question/19595880)

## 特点
全内存数据库，也支持持久化磁盘（重启reload）
丰富的value 类型，单个value 的最大限制是 1GB
可以将数据复制到任意数量的从服务器中（master-slave模式）
所有操作都是原子的（其他用户总能得到最新更新值）
一般都用来做缓存的，当然也可以作为消息队列（原生支持发布/订阅）

## 操作
### 安装
下载解压make

make PREFIX=/some/other/directory install
或
使用`utils/install_server.sh`脚本

或使用homebrew 安装：`brew install redis`

### 启动
```
./src/redis-server [redis.conf]
```
如果不给出redis.conf，则使用默认配置启动

若使用homebrew 安装，则可以使用`brew services start redis`  启动后台Redis 服务

### client
```
./src/redis-cli [-h host -p port -a password]

redis 127.0.0.1:6379> ping [msg]
```
命令不区分大小写

#### 一些命令
SELECT num：选择num号db（num从0起始，默认使用0号数据库）
DBSIZE：返回当前数据库的 key 的数量
FLUSHDB：清空当前数据库中的所有 key
FLUSHALL：清空整个 Redis 服务器的数据(删除所有数据库的所有 key )
ECHO message
QUIT


### 配置
可以在客户端通过 CONFIG 命令查看或设置配置项
```
CONFIG GET $setting_name
CONFIG SET $setting_name $new_config_value
```
在GET 中`$setting_name` 可以使用 * 查看全部

#### 一些配置说明
port 6379：Redis server 的监听端口
bind 127.0.0.1：绑定的主机地址
timeout 300：客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
loglevel verbose：指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
logfile stdout：日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null
daemonize no：Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程
pidfile /var/run/redis.pid：当Redis以守护进程方式运行时，Redis默认会把pid写入/var/run/redis.pid文件，可以通过pidfile指定
databases 16：设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
include /path/to/local.conf：包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件
`save <seconds> <changes>`：在多长时间内，有多少次更新操作，就将数据同步到数据文件
rdbcompression yes：指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
dbfilename dump.rdb：指定本地数据库文件名，默认值为dump.rdb
dir ./：指定本地数据库存放目录，redis-server启动时会自动加载该目录下的本地数据库文件
`slaveof <masterip> <masterport>`：设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
`masterauth <master-password>`：当master服务设置了密码保护时，slav服务连接master的密码
requirepass foobared：设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过`AUTH <password>`命令提供密码（foobared是默认密码），默认关闭
maxclients 128：设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息
`maxmemory <bytes>`：指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区
vm-enabled no：指定是否启用虚拟内存机制，默认值为no，（VM机制将数据分页存放，由Redis将访问量较少的页即冷数据swap到磁盘上，访问多的页面由磁盘自动换出到内存中）
vm-swap-file /tmp/redis.swap：虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享
vm-max-memory 0：将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有索引数据都是内存存储的(Redis的索引数据 就是keys),也就是说,当vm-max-memory设置为0的时候,其实是所有value都存在于磁盘。默认值为0
vm-page-size 32：Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上不能被多个对象共享，vm-page-size是要根据存储的数据大小来设定的，建议如果存储很多小对象，page大小最好设置为32或者64bytes；如果存储很大大对象，则可以使用更大的page，如果不确定，就使用默认值
vm-pages 134217728：设置swap文件中的page数量，由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中的，在磁盘上每8个pages将消耗1byte的内存
vm-max-threads 4：设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4
appendonly no：是否在每次更新操作后进行日志记录，默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为no
appendfilename appendonly.aof：指定更新日志文件名，默认为appendonly.aof
appendfsync everysec：指定更新日志条件，共有3个可选值：
    no：表示等操作系统进行数据缓存同步到磁盘（快）
    always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全）
    everysec：表示每秒同步一次（折衷，默认值）
glueoutputbuf yes：设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开
hash-max-zipmap-entries 64
hash-max-zipmap-value 512：在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法
activerehashing yes：是否激活重置哈希，默认为开启

### 数据类型
[命令大全-en](https://redis.io/commands)
[命令大全-cn](https://www.redis.com.cn/commands.html)

#### 字符串 string
一个字节序列，二进制安全的（可以存储二进制数据），最大存储 512 MB的字符串
SET key $val：创建或修改
SETNX key $val：创建
SETEX key seconds value：带过期时间（秒）
PSETEX key milliseconds value：毫秒单位
GET key
GETSET key value：将给定 key 的值设为 value ，并返回 key 的旧值

MSET key value [key value ...]：同时设置一个或多个 key-value 对
MGET key1 [key2..]：获取所有(一个或多个)给定 key 的值
MSETNX key value [key value ...]：同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在

INCR key：数字值增一
DECR key：数字值减一
INCRBY key increment：将 key 所储存的值加上给定的增量值（increment）
DECRBY key decrement：key 所储存的值减去给定的减量值（decrement）
INCRBYFLOAT key increment：将 key 所储存的值加上给定的浮点增量值（increment）

STRLEN key：返回 key 所储存的字符串值的长度
SETRANGE key offset value：用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始
GETRANGE key start end：返回字符串子串
SETBIT key offset value：对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)
GETBIT key offset：对 key 所储存的字符串值，获取指定偏移量上的位(bit)
APPEND key value：如果 key 已经存在并且是一个字符串， APPEND 命令将 value 追加到 key 原来的值的末尾

#### 哈希 hash
字符串字段 和 任意类型值 之间映射的集合
每个 hash 可以存储 2^32 - 1 个键值对
HSET key field value：将哈希表 key 中的字段 field 的值设为 value
HSETNX key field value：只有在字段 field 不存在时，设置哈希表字段的值
HGET key field：获取存储在哈希表中指定字段的值。如果给定的字段或 key 不存在时，返回 nil。
HEXISTS key field：查看哈希表 key 中，指定的字段是否存在。如果哈希表含有给定字段，返回 1 。 如果哈希表不含有给定字段，或 key 不存在，返回 0。
HDEL key field2 [field2]：删除一个或多个哈希表字段

HLEN key：获取哈希表中字段的数量
HKEYS key：获取所有哈希表中的字段
HVALS key：获取哈希表中所有值
HGETALL key：获取在哈希表中指定 key 的所有字段和值。以列表形式返回哈希表的字段及字段值。 若 key 不存在，返回空列表
`HSCAN key cursor [MATCH pattern] [COUNT count]`：迭代哈希表中的键值对

HINCRBY key field increment：指定字段的整数值加上增量 increment
HINCRBYFLOAT key field increment：浮点数值

HMGET key field1 [field2]：获取所有给定字段的值
HMSET key field1 value1 [field2 value2 ]：同时将多个 field-value (域-值)对设置到哈希表 key 中


#### 列表 list
字符串列表
列表的最大长度为2^32 - 1 个元素
LPUSH key value1 [value2]：将一个或多个值插入到列表头部。返回列表的长度
LPUSHX key value：将一个或多个值插入到已存在的列表头部。列表不存在时操作无效
LPOP key：移出并获取列表的第一个元素

RPUSH key value1 [value2]：列表的尾部(最右边)
RPUSHX key value：已存在的列表尾部(最右边)
RPOP key：最后一个元素

RPOPLPUSH source destination：移除列表的最后一个元素，并将该元素添加到另一个列表并返回。返回被弹出的元素

BLPOP key1 [key2 ] timeout：移出并获取列表的第一个元素（会对所有列表依次询问）， 如果所有列表都没有元素会阻塞列表直到等待超时或发现可弹出元素为止。timeout 单位为秒。返回一个含有两个元素的列表，成功时是被弹出元素所属的 key 和被弹出元素的值；超时失败时是nil 和等待时长。
BRPOP key1 [key2 ] timeout
BRPOPLPUSH source destination timeout：成功时是被弹出元素的值和等待时长

LLEN key：获取列表长度。如果列表 key 不存在，则 key 被解释为一个空列表，返回 0 。 如果 key 不是列表类型，返回一个错误。
LINDEX key index：通过索引获取列表中的元素。可以使用负数下标，以 -1 表示列表的最后一个元素， -2 表示列表的倒数第二个元素，以此类推。如果指定索引值不在列表的区间范围内，返回 nil
LRANGE key start stop：获取列表指定范围内[start, stop]的元素。0 表示列表的第一个元素， 1 表示列表的第二个元素，以此类推。 你也可以使用负数下标

`LINSERT key BEFORE|AFTER existing_val new_val`：在列表的元素前或者后插入元素。成功返回插入操作完成之后，列表的长度。 如果没有找到指定元素，不执行任何操作，返回 -1 。 如果 key 不存在或为空列表，不执行任何操作，返回 0。如果 key 不是列表类型，返回一个错误。
LSET key index value：通过索引来设置元素的值。当索引参数超出范围，或对一个空列表进行 LSET 时，返回一个错误。
LREM key count value
    count > 0 : 从表头开始向表尾搜索，移除与 VALUE 相等的元素，数量为 COUNT
    count < 0 : 从表尾开始向表头搜索，移除与 VALUE 相等的元素，数量为 COUNT 的绝对值。
    count = 0 : 移除表中所有与 VALUE 相等的值。
LTRIM key start stop：对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除。下标 0 表示列表的第一个元素，以 1 表示列表的第二个元素，以此类推。 你也可以使用负数下标，以 -1 表示列表的最后一个元素， -2 表示列表的倒数第二个元素，以此类推。


#### 集合 set
字符串的无序集合
成员最大数量为 2^32 - 1
SADD key member1 [member2]：向集合添加一个或多个成员。返回被添加到集合中的新元素的数量，不包括被忽略的元素。
SPOP key：移除并返回集合中的一个随机元素。当集合不存在或是空集时，返回 nil
SRANDMEMBER key [count]：返回集合中一个或多个随机元素，count 默认为1
    如果 count 为正数，且小于集合基数，那么返回一个包含 count 个元素的数组，数组中的元素各不相同。如果 count 大于等于集合基数，那么返回整个集合。
    如果 count 为负数，那么命令返回一个数组，数组中的元素可能会重复出现多次，而数组的长度为 count 的绝对值。
SREM key member1 [member2]：移除集合中一个或多个成员，不存在的成员元素会被忽略。返回被成功移除的元素的数量，不包括被忽略的元素。
SMOVE source destination member：将 member 元素从 source 集合移动到 destination 集合。如果成员元素被成功移除，返回 1 。 如果成员元素不是 source 集合的成员，并且没有任何操作对 destination 集合执行，那么返回 0

SCARD key：获取集合的成员数
SMEMBERS key：返回集合中的所有成员
SISMEMBER key member：判断 member 元素是否是集合 key 的成员。如果成员元素是集合的成员，返回 1 。 如果成员元素不是集合的成员，或 key 不存在，返回 0 。

SINTER key1 [key2]：返回给定所有集合的交集
SINTERSTORE destination key1 [key2]：返回给定所有集合的交集并存储在 destination 中。如果指定的集合已经存在，则将其覆盖。返回交集的成员数
SUNION key1 [key2]：返回所有给定集合的并集
SUNIONSTORE destination key1 [key2]
SDIFF key [key1 key2 ...]：返回给定所有集合的差集（key - key1 - key2 - ...）
SDIFFSTORE destination key [key1 key2 ...]

`SSCAN key cursor [MATCH pattern] [COUNT count]`



#### 有序集合 zset
字符串的有序集合
每个元素都会关联一个double类型的分数，按权重分值从最小到最大排序。虽然成员都是独一无二的，按权重分数值可能会重复。
成员最大数量为 2^32 - 1
ZADD key score1 member1 [score2 member2]：向有序集合添加一个或多个成员，如果某个成员已经是有序集的成员，那么更新这个成员的分数值，并通过重新插入这个成员元素，来保证该成员在正确的位置上。分数值可以是整数值或双精度浮点数。返回被成功添加的新成员的数量，不包括那些被更新的、已经存在的成员。
ZINCRBY key increment member：有序集合中对指定成员的分数加上增量 increment，可以通过传递一个负数值 increment ，让分数减去相应的值。当 key 不存在，或分数不是 key 的成员时，执行ZADD 操作。返回member 成员的新分数值

ZSCORE key member：返回有序集中，成员的分数值
ZCARD key：获取有序集合的成员数
ZCOUNT key min max：计算在有序集合中指定区间[min, max]分数的成员数
ZLEXCOUNT key min max：指定字典区间内成员数量
ZRANK key member：返回有序集合中指定成员的索引。如果成员不是有序集 key 的成员，返回 nil
ZRANGE key start stop [WITHSCORES]：通过索引区间返回有序集合成指定区间内的成员
ZRANGEBYLEX key min max [LIMIT offset count]：通过字典区间
`ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]`：通过分数。默认情况下，区间的取值使用闭区间，你也可以通过给参数前增加 ( 符号来使用可选的开区间，另外分值可以使用inf表示无穷大
ZREVRANK key member：返回有序集合中指定成员的排名（逆向）
ZREVRANGE key start stop [WITHSCORES]：返回指定区间内的成员，通过索引，分数从高到底，具有相同分数值的成员按字典序的逆序(reverse lexicographical order)排列
ZREVRANGEBYSCORE key max min [WITHSCORES]：指定分数区间

ZREM key member [member ...]：移除有序集合中的一个或多个成员。返回被成功移除的成员的数量，不包括被忽略的成员。
ZREMRANGEBYLEX key min max：移除给定的字典区间的所有成员
ZREMRANGEBYRANK key start stop：移除给定的排名区间的所有成员
ZREMRANGEBYSCORE key min max：移除定的分数区间的所有成员

`ZINTERSTORE destination numkeys key [key ...] [WEIGHTS weight [weight ...]] [AGGREGATE SUM|MIN|MAX]`：计算给定的一个或多个（numkeys指定）有序集的交集并将结果集存储在新的有序集合 destination 中。默认情况下，结果集中某个成员的分数值是所有给定集下该成员分数值之和。
`ZUNIONSTORE destination numkeys key [key ...] [WEIGHTS weight [weight ...]] [AGGREGATE SUM|MIN|MAX]`：并集
`ZSCAN key cursor [MATCH pattern] [COUNT count]`


### 操作key
EXISTS key...：检查给定 key 是否存在。返回指定这些key 存在的个数
KEYS pattern：查找所有符合给定模式(pattern 可以使用shell中的? * []通配符)的 key。返回key 的列表
DEL key：删除 key，key 不存在会被忽略。返回被删除key 的数量
RENAME key newkey：修改 key 的名称，当newkey 已存在时，会覆盖
RENAMENX key newkey：仅当 newkey 不存在时，将 key 改名为 newkey。修改成功时，返回 1 。 如果 newkey 已经存在，返回 0
TYPE key：返回 key 所储存的值的类型: none (key不存在) string (字符串) list (列表) set (集合) zset (有序集) hash (哈希表)
RANDOMKEY：从当前数据库中随机返回一个 key。当数据库不为空时，返回一个 key 。 当数据库为空时，返回 nil
MOVE key db：将当前数据库的 key 移动到给定的数据库 db 中。
DUMP key：用于序列化给定 key ，并返回被序列化的值。如果 key 不存在，那么返回 nil

#### 过期时间
EXPIRE key seconds：为给定 key 设置过期时间。设置成功返回 1 。 当 key 不存在或者不能为 key 设置过期时间时(比如在< 2.1.3 版本)返回0（SET会清除掉设置的过期时间，但INCR不会）
PEXPIRE key milliseconds：毫秒级
EXPIREAT key timestamp：为 key 设置过期时间。给出一个固定的UNIX 时间戳为过期时间
PEXPIREAT key milliseconds-timestamp：毫秒级时间戳
TTL key：以秒为单位返回 key 的剩余的过期时间。当 key 不存在时，返回 -2 。 当 key 存在但没有设置剩余生存时间时，返回 -1 。 否则，以毫秒为单位，返回 key 的剩余生存时间。
PTTL key：毫秒单位
PERSIST key：移除 key 的过期时间，key 将持久保持


### HyperLogLog
HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。
因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。

#### 基数
比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(不重复元素)为5。 基数估计就是在误差可接受的范围内，快速计算基数。

#### 命令
PFADD key element [element ...]：添加指定元素到 HyperLogLog 中。返回添加元素的个数
PFCOUNT key [key ...]：返回给定 HyperLogLog 的基数估算值。如果多个 HyperLogLog 则返回基数估值之和
PFMERGE destkey sourcekey [sourcekey ...]：将多个 HyperLogLog 合并为一个 HyperLogLog，合并后的 HyperLogLog 的基数估算值是通过对所有 给定 HyperLogLog 进行并集计算得出的。


### 发布订阅(pub/sub)
PUBSUB subcommand [argument [argument ...]]：查看订阅与发布系统状态
    PUBSUB CHANNELS

#### 订阅
SUBSCRIBE channel [channel ...]：订阅一个或多个的频道，client将hold 住等待订阅的信息
UNSUBSCRIBE [channel [channel ...]]：退订给定的频道
PSUBSCRIBE pattern [pattern ...]：订阅一个或多个符合给定模式的频道，每个模式以 * 作为匹配符
PUNSUBSCRIBE [pattern [pattern ...]]：退订所有给定模式的频道

#### 发布
PUBLISH channel message：把消息message 发送到channel 频道。返回接收到该信息的订阅数


### 事务
原子性：事务中的命令要么全部被执行，要么全部都不执行。
隔离型：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。

#### 操作
MULTI：开始一个事务（后续的命令都都不会立即执行，直到执行EXEC 或DISCARD 为止）
然后将多个命令入队到事务中
EXEC：触发事务，一并执行事务中的所有命令，注意，执行过程中如果出错并不能回滚
DISCARD：取消事务，清空事务命令队列并退出事务上下文

WATCH key [key ...]：监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将不会被执行
UNWATCH：取消 WATCH 命令对所有 key 的监视

### 内嵌支持Lua 脚本
EVAL script numkeys key [key ...] arg [arg ...]
    script是一段 Lua 5.1 脚本程序；可以通过redis.call('cmd', args) 调用redis 命令
    numkeys键名参数的个数；
    从 EVAL 的第三个参数开始算起，表示在脚本中所用到的那些 Redis 键(key)，这些键名参数可以在 Lua 中通过全局变量 KEYS 数组，用 1 为基址的形式访问(KEYS[1], KEYS[2]，以此类推)
    附加参数，在 Lua 中通过全局变量 ARGV 数组访问，访问的形式和 KEYS 变量类似( ARGV[1] 、 ARGV[2] ，诸如此类)

SCRIPT LOAD script：将脚本 script 添加到脚本缓存中，但并不立即执行这个脚本（相当于定义一个存储过程，因此也无需提供脚本所需的参数）。脚本可以在缓存中保留无限长的时间。返回给定脚本的 SHA1 校验和。
EVALSHA sha1 numkeys key [key ...] arg [arg ...]：根据给定的 sha1 校验码，执行缓存在服务器中的脚本
SCRIPT EXISTS sha1 [sha2 ...]：查看指定的脚本是否已经被保存在缓存当中（1 表示已缓存，0 表示未缓存）
SCRIPT FLUSH：从脚本缓存中移除所有脚本
SCRIPT KILL：杀死当前正在运行的 Lua 脚本，当且仅当这个脚本没有执行过任何写操作时，这个命令才生效。执行这个脚本的客户端会从 EVAL 命令的阻塞当中退出，并收到一个错误作为返回值。

## Python client
安装redis 模块，该模块提供两个类Redis和StrictRedis用于实现Redis的命令，StrictRedis用于实现大部分官方的命令，并使用官方的语法和命令，Redis是StrictRedis的子类，用于向后兼容旧版本。
```python
__init__(self, host='localhost', port=6379, db=0, password=None, socket_timeout=None, socket_connect_timeout=None, socket_keepalive=None, socket_keepalive_options=None, connection_pool=None, unix_socket_path=None, encoding='utf-8', encoding_errors='strict', charset=None, errors=None, decode_responses=False, retry_on_timeout=False, ssl=False, ssl_keyfile=None, ssl_certfile=None, ssl_cert_reqs=None, ssl_ca_certs=None, max_connections=None)
```
该模块使用connection pool来管理对一个redis server的所有连接，避免每次建立、释放连接的开销。
默认，每个Redis实例都会维护一个自己的连接池。可以直接建立一个连接池，然后作为参数Redis，这样就可以实现多个Redis实例共享一个连接池

### Redis 类方法
一般都和对应的命令名相同（全小写），不过也有一些例外：
`delete(*name)`：删除一个或多个key

### 管道（pipeline）
redis在提供单个请求中缓冲多条服务器命令的基类的子类。它通过减少服务器-客户端之间反复的TCP数据库包，从而大大提高了执行批量命令的功能。

### 发布订阅(pub/sub)
```python
r = Redis()

# 订阅
p = r.pubsub()          # init PubSub 实例
p.subscribe('chan1')    # 订阅
p.subscribe(['chan1', 'chan2']) # 订阅多个频道

for item in p.listen():         # 等待接收每个频道的信息
    print item                  # 每个item 都是一个字典结构{'pattern': None, 'type': 'subscribe', 'channel': 'chan2', 'data': 2L}
                                # 订阅N 个频道，则头N 次循环的信息都是类似上面的订阅信息（type 为subscribe）
                                # 而后hold 住，等待各个频道发来的信息（type 为message，信息体在data 域）

# 发布
r.publish('spub', 'message')
```

## 集群方案
### 官方提供的Redis Cluster工具
Redis 集群不支持那些需要同时处理多个键的 Redis 命令， 因为执行这些命令需要在多个 Redis 节点之间移动数据， 并且在高负载的情况下， 这些命令将降低 Redis 集群的性能， 并导致不可预测的错误。

Redis 集群通过分区（partition）来提供一定程度的可用性（availability）： 即使集群中有一部分节点失效或者无法进行通讯， 集群也可以继续处理命令请求。

Redis 集群使用数据分片（sharding）而非一致性哈希（consistency hashing）来实现： 一个 Redis 集群包含 16384 个哈希槽（hash slot）， 数据库中的每个键都属于这 16384 个哈希槽的其中一个， 集群使用公式 CRC16(key) % 16384 来计算键 key 属于哪个槽



### codis


## 原理
### 数据淘汰策略
1. noeviction: 返回错误当内存限制达到，并且客户端尝试执行会让更多内存被使用的命令。
2. allkeys-lru: 尝试回收最少使用的键（ LRU ） ， 使得新添加的数据有空间存放。
3. volatile-lru: 尝试回收最少使用的键（ LRU ） ， 但仅限于在过期集合的键 , 使得新添加的数据有空间存放。
4. allkeys-random: 回收随机的键使得新添加的数据有空间存放。
5. volatile-random: 回收随机的键使得新添加的数据有空间存放，但仅限于在过期集合的键。
6. volatile-ttl: 回收在过期集合的键，并且优先回收存活时间（ TTL ） 较短的键, 使得新添加的数据有空间存放。

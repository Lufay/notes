# MongoDB
[官方文档](https://docs.mongodb.com/manual/)
[TOC]
基于分布式文件存储的开源数据库系统

MongoDB 将数据存储为一个文档，数据结构由键值(`key=>value`)对组成。
MongoDB 文档类似于 JSON 对象（BSON）。字段值可以包含其他文档，数组及文档数组。

## 概念
### 和SQL对比
|SQL术语/概念 | MongoDB术语/概念 | 解释/说明 |
|---|---|---|
|database | database | 数据库 |
|table | collection | 数据库表/集合 |
|row | document | 数据记录行/文档 |
|column | field | 数据字段/域 |
|index | index | 索引 |
|table | joins | 表连接,MongoDB不支持 |
|primary key | primary key | 主键,MongoDB自动将`_id`字段设置为主键|

### 数据库
一个mongodb中可以建立多个数据库

### 集合
文档组
当第一个文档插入时，集合就会被创建。

#### capped collections
固定大小的collection，有很高的性能以及队列过期的特性（过期按照插入的顺序）
创建一个capped collection 必须要显式指定，包括collection的大小，单位是字节，最大存储为1e9( 1X109)个字节。collection的数据存储空间值提前分配的。（注意：指定的存储大小包含了数据库的头信息）例如：
```
db.createCollection("mycoll", {capped:true, size:100000})
```

### 文档
文档中的键/值对是有序的
文档的键是字符串。除了少数例外情况，键可以使用任意UTF-8字符（键不能含有\0 (空字符)。这个字符用来表示键的结尾）

### 元数据
数据库的信息是存储在集合中
它们使用了系统的命名空间：`dbname.system.*`


## 数据类型
|数据类型 | 描述 | 类型值 |
|---|---|---|
|Double | 双精度浮点值。用于存储浮点值。 | 1 |
|String | 字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。 | 2 |
|Object | 用于内嵌文档。 | 3 |
|Array | 用于将数组或列表或多个值存储为一个键。 | 4 |
|Binary Data | 二进制数据。用于存储二进制数据。 | 5 |
|Object ID | 对象 ID。用于创建文档的 ID。 | 7 |
|Boolean | 布尔值。用于存储布尔值（真/假）。 | 8 |
|Date | 日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。 | 9 |
|Null | 用于创建空值。 | 10 |
|Regular expression | 正则表达式类型。用于存储正则表达式。 | 11 |
|JavaScript | 代码类型。用于在文档中存储 JavaScript 代码。 | 13 |
|Symbol | 符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。 | 14 |
|JavaScript(with scope) | | 15 |
|Integer(32bit) | 整型数值。 | 16 |
|Timestamp | 时间戳。记录文档修改或添加的具体时间。 | 17 |
|Integer(64bit) | 整型数值。 | 18 |
|Min/Max keys | 将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。 | 255/127 |

**注意：**
由于使用shell client 时是基于json 的，而json 只有number类型，而不区分具体的细类（BSON 会区分），所以，如果仅仅写一个数字的话，为了保证兼容性，都会当做Double 进行保存，如果确实想要存储为int32或int64，可以使用NumberInt() 或NumberLong() 对数字进行显示转换。

## 操作
### 安装
下载相应平台的压缩包解压接口
创建数据目录，默认是/data/db

### 启动
```
./mongod [--dbpath $path] [--rest]
```
如果使用默认的数据目录，则无需--dbpath 选项，否则需要显示指定
如果需要HTTP 用户界面，可以加上--rest 选项
MongoDB 的默认运行端口是27017，web 用户界面的端口是28017

### Client
#### Javascript shell
使用的bin目录下的mongo
默认会链接到 test 文档（数据库）

##### 数据库
```
show dbs
```
显示所有数据库（刚刚创建的数据库并不显示，只有当该数据库插入数据时才显示在该列表中）

```
db
```
显示当前数据库对象或集合（db不仅仅是命令，还是当前数据库的一个引用）
```
db.dropDatabase()
```
删除当前数据库

```
use <db_name>
```
切换数据库，如果指定数据库不存在则创建之

```
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```
连接数据库，支持连接replica set
其中[option参考](http://www.runoob.com/mongodb/mongodb-connections.html)

##### 文档，集合
```
var = (<document>);
```
声明一个变量，`<document>`是一个json格式的对象

###### 查询
```
db.<collection_name>.find(<query>[, <project>])
db.<collection_name>.findOne(<query>[, <project>])
```
查询文档（前缀返回所有匹配文档，后者返回一个文档）
query：筛选条件（见下），默认为{}，表示选出全部文档。
project：字段投影（相当于SQL的select 字段，例如`{"title":1,_id:0,ok:"$field"}`表示每个document 只返回title字段，不需要`_id`字段，该字段默认总是返回，另外，field字段改名为ok）

1. 比较
| 比较运算 | Mongo query格式 |
|:--------:|:---------------:|
| `==`  | `{<key>:{$eq:<value>}}` 或 `{<key>:<value>}` |
| `!=`  | `{<key>:{$ne:<value>}}` |
| `< `  | `{<key>:{$lt:<value>}}` |
| `<=`  | `{<key>:{$lte:<value>}}` |
| `> `  | `{<key>:{$gt:<value>}}` |
| `>=`  | `{<key>:{$gte:<value>}}` |
2. 集合
`{ field: { $in: [<value1>, <value2>, ... <valueN> ] } }`
注：field可以是数组字段，则数组字段至少有一个成员命中集合就可以
valueX也可以是/pattern/的正则表达式
`{ field: { $nin: [ <value1>, <value2> ... <valueN> ]} }`
注：field可以是数组字段，则数组字段不存在一个成员可以命中集合
如果field字段不存在也会命中
2. 检查是否含有指定字段（含有字段包括字段值为null）
`{ field: { $exists: <boolean> } }`
7. 检查类型码
`{"title": {"$type": 2}}`
2. 逻辑
AND：`{key1:value1, key2:value2}`
OR：`{$or: [{key1: value1}, {key2:value2}] }`
NOT：`{ field: { $not: { $gt: 1.99 } } }`
注：也命中不存在field字段
$gt 不能换成$regex，但可以使用{$not: /pattern/}，在其他语言中可以用对应的正则对象，例如python中的Pattern对象，即re.compile()的返回
NOR：`{$nor: [{key1: value1}, {key2:value2}] }`
注：命中每个条件均不成立或keyX不存在
3. 算术
$add, $subtract, $multiply, $divide, $mod
4. 字符串
$toLower, $toUpper, $concat, $substr, $strcasecmp
5. 日期
$dayOfYear  Converts a date to a number between 1 and 366.
$dayOfMonth Converts a date to a number between 1 and 31.
$dayOfWeek  Converts a date to a number between 1 and 7.
$year       Converts a date to the full year.
$month      Converts a date into a number between 1 and 12.
$week       Converts a date into a number between 0 and 53
$hour       Converts a date into a number between 0 and 23.
$minute     Converts a date into a number between 0 and 59.
$second     Converts a date into a number between 0 and 59. May be 60 to account for leap seconds.
$millisecond    Returns the millisecond portion of a date as an integer between 0 and 999.
6. 正则
`{<key>: /regular-expression/ }`
或
`{<key>: {$regex: "regular-expression", $options: "$i"}}`
这里使用
$i 的option表示不区分大小写
m 多行查找
x 空白字符除了被转义的或在字符类中的以外完全被忽略
s 圆点元字符（.）匹配所有的字符，包括换行符
支持在字符串数组字段直接使用
8. 查询嵌套文档
对于嵌套文档，使用`==`比较运算，如果value 是一个文档，则进行精确匹配，包括各个field 的顺序
也可以使用`outerField.innerField`作为key 筛选单个field
9. 查询数组字段
数组字段可以这样理解，数组的每一个值都是一个有效value
因此对于数组字段，使用`==`比较运算，如果value是一个单值，则数组中含有value 就会被选中；如果value 是一个数组，则进行精确匹配，即数组完全相同才会被选中；
也可以使用
`{"key": {"$all": [val1, val2, ...]}}`
表示至少含有数组中的所有value 就好被选中（不要求顺序）
即`$all`表示*且*的关系，如果想要*或*的关系，可以使用`$in`
+ 使用索引
`{"key.index": value}`，index是从0 开始的整数，表示数组的index索引位置的值是value
+ 根据数组长度
`{"key": {"$size": n}}`，数组长度为n
注：`$size`不接受范围值，也就是说只能使用精确值，为了能够进行范围查找，可以在文档中设置一个计数字段，需要自己来维护该字段，但`$addToSet`没法配合使用，因为你无法判断这个元素是否添加到了数组中
+ 某个元素的条件
`{"key": {"$elemMatch": {query1, query2, ...}}}`
如果query 只有一个，则无需elemMatch；如果query 是多个的话，而没有使用elemMatch，则不是对数组元素进行筛选，而是对整个数组字段进行筛选，例如`{"finished": { $gt: 15, $lt: 20 } }`，表示finished 的这个数组字段中某个元素大于15 且又有某个元素（可能是同一个元素也可能不同）小于20
+ 提取数组子序列
project 使用`{"key":{"$slice": n}}`，其中n 可以是正数（表示前n 项），负数（表示后n 项），[m, n]（表示从第m 个元素开始的n 个元素）
10. 内嵌query 逻辑
`{"$where": query}`，其中query 可以一个js 表达式，或一个js 匿名函数，返回布尔值。
在函数中可以使用this 应用当前被筛选的文档


可以对结果再调用：
pretty()：得到一个格式化的输出
count()：获得返回的文档数
> On a sharded cluster, count can result in an inaccurate count if orphaned documents exist or if a chunk migration is in progress.
> 由于分布式集群正在迁移数据，它导致count结果值错误，需要使用aggregate pipeline来得到正确统计结果
> 参考<https://docs.mongodb.com/manual/reference/command/count/>
limit(NUMBER)：返回指定个数的文档数
skip(NUMBER)：跳过指定个数的文档
sort({<KEY>: 1})：排序，val的1表示升序，-1表示降序
forEach(function(u) {})

###### 增删改
```
db.<collection_name>.insert(<document>)
```
插入文档，`<collection_name>`指定的集合名如果没有会自动创建，`<document>`是一个json格式的对象，也可以是上面定义的变量

```
db.<collection_name>.drop()
```
删除集合

```
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
```
删除文档
query：筛选条件，同上，如果给`{}`表示删除所有文档
justOne：可选，是否只删除一个文档（默认false）
writeConcern：可选，抛出异常的级别
注：后两项可以直接作为位序参数传入

```
db.<collection_name>.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
```
更新文档
query：筛选条件
update：更新操作，例如`{$set:{'title':'MongoDB'}}`表示把title字段修改为MongoDB；`{$inc:{"count":1}}`
upsert：可选，如果不存在更新的记录，是否改为插入（默认false，不插入）
multi：可选，是否更新全部匹配记录（默认false，只更新匹配的第一条记录）
writeConcern：可选，抛出异常的级别
注：后三项可以直接作为位序参数传入，例如：
```
db.col.update({"count": {$gt: 15 } } , {$inc: {"count": 1} }, false, true);
```

```
db.<collection_name>.save(
   <document>,
   {
     writeConcern: <document>
   }
)
```
更新/新增文档
document：一个json格式的对象，如果带有`"_id"`字段，则表示update操作，否则表示insert操作
writeConcern：可选，抛出异常的级别

###### 聚合
```
db.<collection_name>.aggregate(AGGREGATE_OPERATION)
```
其中`AGGREGATE_OPERATION`可以是一个操作，也可以是多个操作组成的pipeline

+ 单一操作
例如：`{$group: {_id: "$by_user", num_tutorial: {$sum: 1} } }`
+ pipeline
```
[
    { $match: { score : { $gt : 70, $lte : 90 } } },
    { $group: { _id: null, count: { $sum: 1 } } }
]
```

支持的操作：
+ $project：字段投影（相当于SQL的select 操作）。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。
+ $match：过滤数据（相当于SQL的where 操作），只输出符合条件的文档。$match使用MongoDB的标准查询操作。
+ $geoNear：输出接近某一地理位置的有序文档。
+ $limit：用来限制MongoDB聚合管道返回的文档数。
+ $skip：在聚合管道中跳过指定数量的文档，并返回余下的文档。
+ $sort：将输入文档排序后输出。
+ $unwind：将文档中的某一个数组类型字段拆分成多条记录，每条包含数组中的一个值（{ "result" : [{...}, {...}, ... ], "ok" : 1 }）。
+ $group：将集合中的文档分组，可用于统计结果。
格式：`{$group : {_id : "$field", num_tutorial : {$sum : "$st_field"}}}`
其中，`_id`指定聚合的键，即SQL中的group by，可以是多个字段组成的一个对象；`st_field`是聚合字段


聚合运算：
$sum    计算总和
$avg    计算平均值
$min    获取集合中所有文档对应值得最小值
$max    获取集合中所有文档对应值得最大值
$push    在结果文档中插入值到一个数组中
$addToSet    在结果文档中插入值到一个数组中，但不创建副本
$first    根据资源文档的排序获取第一个文档数据
$last    根据资源文档的排序获取最后一个文档数据

```
db.<collection_name>.mapReduce(
    function() {emit(key,value);},  //map 函数
    function(key,values) {return reduceFunction},   //reduce 函数
    {
        out: collection,
        query: document,
        sort: document,
        limit: number
    }
)
```
其中，
在map 函数中，this指当前的文档对象，最后通过emit 函数传给reduce 函数作为kv参数
reduce 函数，参数values 是一个数组
out：统计结果存放集合 (不指定则使用临时集合,在客户端断开后自动删除)
query：一个筛选条件，只有满足条件的文档才会调用map函数
sort：在发往map函数前给文档排序，可以优化分组机制
limit：发往map函数的文档数量的上限（要是没有limit，单独使用sort的用处不大）
输出如下：
```
{
	"result" : "out_collection",
	"timeMillis" : 23,
	"counts" : {
		"input" : 5,
		"emit" : 5,
		"reduce" : 1,
		"output" : 2
	},
	"ok" : 1
}
```
result是上面指定的out collection
timeMillis：执行花费的时间，单位毫秒为
counts.input：满足条件发送到map函数的文档数
counts.emit：在map函数中emit被调用的次数，也就是所有集合中的数据总量
counts.ouput：结果集合中的文档个数
ok：是否成功，成功为1
err：如果失败，这里可以有失败原因，不过从经验上来看，原因比较模糊，作用不大

#### Python pymongo
```
from pymongo import MongoClient
client = MongoClient('mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]')
client.close()
```

##### 数据库
```
client.database_names()
```
所有数据库列表

```
db = client.<db_name>
db = client['db_name']
db = client.get_database(name, codec_options=None, read_preference=None, write_concern=None, read_concern=None)
```
获得指定数据库实例，后者当需要设置option时使用

```
client.drop_database(name_or_database)
```
参数可以是字符串（`db_name`）也可以是一个db实例

##### collection
```
db.collection_names(include_system_collections=True)
```
所有collection 的列表，默认包含system collection

```
collection = db.<collection_name>
collection = db['collection_name']
collection = db.get_collection(name, codec_options=None, read_preference=None, write_concern=None, read_concern=None)
```
获得指定的collection 实例，后者当需要设置option时使用

```
collection.rename(new_name, **kwargs)
```
collection改名

```
db.drop_collection(name_or_collection)
collection.drop()
```
参数可以是字符串（`collection_name`）也可以是一个collection实例

```
db.create_collection(name, codec_options=None, read_preference=None, write_concern=None, read_concern=None, **kwargs)
```
通常collection会自动创建，该方法用于在需要指定特殊配置的collection
特殊的配置通过关键字参数进行指定，这些关键字包括size（初始化大小bytes，对于capped collections，该大小是collection的最大size）capped（是否是capped collections）max（如果是capped的话，指定其对象个数的上限）

##### 文档
```
collection.find(*args, **kwargs)
collection.find_one(filter=None, *args, **kwargs)
collection.find_one_and_update(filter, update, projection=None, sort=None, upsert=False, return_document=False, **kwargs)
collection.find_one_and_replace(filter, replacement, projection=None, sort=None, upsert=False, return_document=False, **kwargs)
collection.find_one_and_delete(filter, projection=None, sort=None, **kwargs)
```
查询文档
可选的参数包括：
`filter`可以是一个python 字典，筛选必须在结果集中满足的条件
`projection`投影，可以是字段名列表，或一个字典（key是字段名，val是可以进行布尔求值的对象，True表示投影到结果集中，False表示不投影）
skip 和 limit 可以分段返回
sort 可以是(key, direction)二元组列表（其中direction可以是pymongo.DESCENDING）
find返回一个类似字典列表的对象cursor.Cursor
`find_one` 和`find_one_and_delete`返回单个文档（无匹配则返回None）
`find_one_and_update`和`find_one_and_replace`的upsert参数如果为True，则无论是否找到一个对象，都会插入replacement；`return_document`的默认值是ReturnDocument.BEFORE，表示和`find_one`的返回相同（查询到的原文档），如果是ReturnDocument.AFTER，则返回的是更新后的新文档


该对象还可以调用
copy()：返回一个拷贝的实例
count()：获得返回的文档数
sort("field", pymongo.ASCENDING)：升序排列，降序使用pymongo.DESCENDING

```
collection.distinct(key, filter=None, **kwargs)
```
返回指定的文档字段不重复的值列表


```
collection.insert_one(document, bypass_document_validation=False)
collection.insert_many(documents, ordered=True, bypass_document_validation=False)
```
document 是一个python 字典，documents 是python 字典的列表
ordered 表示是否按照documents 所列的操作顺序进行，如果True，则操作顺序执行，如果遇到错误，则剩下的都不会执行；如果False，则操作将随机进行（可能并行），那么所有操作都将尝试完成
返回一个pymongo.results.InsertOneResult 对象，其中有个属性`inserted_id` 是被插入元素的`_id`
返回一个pymongo.results.InsertManyResult 对象，其中有个属性`inserted_ids` 是被插入元素的`_id` 的列表（按照documents 列表的顺序）

```
collection.replace_one(filter, replacement, upsert=False, bypass_document_validation=False, collation=None)
collection.update_one(filter, update, upsert=False, bypass_document_validation=False, collation=None)
collection.update_many(filter, update, upsert=False, bypass_document_validation=False, collation=None)
```
replacement 是用来替换的文档
update 是一个修改操作（python 字典，例如`{'$inc': {'count': 1}, '$set': {'done': True}}`）
返回pymongo.results.UpdateResult，其属性
matched_count：一个update 匹配的文档条数
modified_count：修改的文档条数
upserted_id：如果upsert 发送时，是被插入元素的`_id`，否则是None

```
collection.delete_one(filter, collation=None)
collection.delete_many(filter, collation=None)
```
删除文档
返回对象pymongo.results.DeleteResult 对象，其属性
`deleted_count`：可以查看删除文档个数

```
bulk_write(requests, ordered=True, bypass_document_validation=False)
```
批量写接口
requests 是一个操作对象列表，操作对象包括：
pymongo.InsertOne(document)
pymongo.UpdateOne(filter, update, upsert=False)
pymongo.UpdateMany(filter, update, upsert=False)
pymongo.ReplaceOne(filter, replacement, upsert=False)
pymongo.DeleteOne(filter)
pymongo.DeleteMany(filter)
ordered 表示是否按照requests 所列的操作顺序进行，如果True，则操作顺序执行，如果遇到错误，则剩下的都不会执行；如果False，则操作将随机进行（可能并行），那么所有操作都将尝试完成
返回pymongo.results.BulkWriteResult 对象，其属性
inserted_count：插入的文档条数
deleted_count：删除的文档条数
matched_count：一个update 匹配的文档条数
modified_count：修改的文档条数
upserted_count：upsert 的文档条数
upserted_ids


```
collection.count(filter=None, **kwargs)
```
collection中的文档数
可以使用limit 和skip 的关键字参数进行分段

```
collection.group(key, condition, initial, reduce, finalize=None, **kwargs)
collection.aggregate(pipeline, **kwargs)
collection.map_reduce(map, reduce, out, full_response=False, **kwargs)
collection.inline_map_reduce(map, reduce, full_response=False, **kwargs)
```
key 是分组的键，可以是形如`{"Year":-1,"Rank":1}`的字典，或一个字段列表
condition 是筛选条件（一个python 字典）
initial 是一个python 字典，其中是聚集结果的初值
reduce 是一个js 函数，形如
```
from bson.code import Code
code = Code('''
    function (obj, prev) {
        prev.count++;
    }
''')
```
其中函数参数obj是一个文档，prev 是对应key 的一个initial 字典
group 函数返回一个类似字典列表的对象，每个对象包括key 的prev 字典
注：在sharded collection 上group 函数无法工作；*另外，该函数从3.4 废弃，请使用aggregate()函数的$group 或使用`map_reduce`*


注：文档对象如果想要使用json.dumps() 函数进行序列化，必须`del doc['_id']`，因为ObjectId类型无法序列化
不过可以使用`bson.json_util.dumps()`进行序列化（对应的反序列化方法是`bson.json_util.loads()`）


<http://www.cnblogs.com/cswuyg/p/4355948.html>

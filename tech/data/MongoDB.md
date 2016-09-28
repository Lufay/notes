# MongoDB
[官方文档](https://docs.mongodb.com/manual/)
[TOC]
基于分布式文件存储的开源数据库系统

MongoDB 将数据存储为一个文档，数据结构由键值(`key=>value`)对组成。
MongoDB 文档类似于 JSON 对象。字段值可以包含其他文档，数组及文档数组。

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
|数据类型    描述
|---|---|
|Null | 用于创建空值。 |
|String | 字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。 |
|Integer | 整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。 |
|Double | 双精度浮点值。用于存储浮点值。 |
|Boolean | 布尔值。用于存储布尔值（真/假）。 |
|Min/Max keys | 将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。 |
|Arrays | 用于将数组或列表或多个值存储为一个键。 |
|Object | 用于内嵌文档。 |
|Symbol | 符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。 |
|Timestamp | 时间戳。记录文档修改或添加的具体时间。 |
|Date | 日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。 |
|Object ID | 对象 ID。用于创建文档的 ID。 |
|Binary Data | 二进制数据。用于存储二进制数据。 |
|Code | 代码类型。用于在文档中存储 JavaScript 代码。 |
|Regular expression | 正则表达式类型。用于存储正则表达式。 |


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
db.<collection_name>.find(<query>)
```
查询文档
可以对结果再调用pretty()方法得到一个格式化的输出
该方法返回所有文档，可以用findOne方法返回一个文档

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
db.col.update( { "count" : { $gt : 15 } } , { $inc : { "count" : 1} },false,true );
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



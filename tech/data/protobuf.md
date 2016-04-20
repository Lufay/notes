[TOC]
# Protocol Buffers
一种结构化数据的序列化协议
[开源项目地址](https://github.com/google/protobuf)
[开发者指南](https://developers.google.com/protocol-buffers/)
[中文翻译1](http://www.cnblogs.com/dkblog/archive/2012/03/27/2419010.html)
[中文翻译2](http://blog.csdn.net/menuconfig/article/details/12837173)

## 特色
### 优点
+ 序列化和反序列化性能好
+ 序列化的空间占用更小
+ 多版本兼容，数据接口轻松升级
+ 自动的代码生成，多语言支持
+ 编程模式友好，无需学习复杂的DOM
### 缺点
+ 二进制格式可读性差
+ 不具有自解释性，需要proto文件才能解释二进制数据
+ 通用性不如XML

## 安装
下载源码，解压
```
./configure --prefix=$INSTALL_PATH --with-zlib
make
make install
```

## 使用
### 基本使用流程
1. 定义IDL（编写.proto文件）
2. 编译IDL为目标语言
```
protoc -I=$SRC_DIR --cpp_out=$DST_DIR $SRC_DIR/addressbook.proto
```
对于cpp而言，会编译出.h 文件和.cc 文件，其中实现了自己定义的数据结构各个字段的set/get以及序列化接口。


### 编写.proto文件
#### 注释
使用`//`

#### 消息格式(数据)
```
message XXX {
    MODIFIER TYPE xxx = ID [default=yyyy];
    enum EEE {      // 嵌套定义枚举类型
        AA = 0;
        BB = 1;
        CC = 2;
    }
    message YYY {   // 嵌套定义其他消息
    }
}
```
MODIFIER：量词修饰符，包括required（1个），optional（0或1个），repeated（0或多个，有序）
TYPE：数据类型，多种整型、float/double、bool、string、bytes、enum、message
ID：标识号，1 到 2^29-1（其中[19000－19999]协议保留，不要使用），较小的ID占用的空间更小，因此应尽量为频繁出现的字段分配[1, 15]之内的标识号。因为标识号一旦分配就不能更改，所以也要注意为未来添加、频繁出现的字段预留标识号。
[default = ?]：设置默认值，当optional字段缺省时，将被置为这里指定的值（为了让高版本兼容低版本的格式）。如果没有指定默认值，则使用类型默认值（0，false，空串，枚举的第一个值）。
**注**：由于一些历史原因，基本数值类型的repeated的字段并没有被尽可能地高效编码。在新的代码中，用户应该使用特殊选项[packed=true]来保证更高效的编码。例如：
```
repeated int32 samples = 4 [packed=true];
```
要引用其他message嵌套定义的enum，需要使用`MessageType.EnumType`引用。

##### 编译产出
每个message将被编译为一个类，其中包含了`field()`、`set_field()`、`has_field()`、`clear_field()`函数（其中field是字段名）来进行get/set/test/清为默认值的操作；
如果是repeated，还可以使用`field_size()`获得个数，`add_field()`增加一个元素（而且上面提到的接口都需要指定index）；
###### serialize/parse方法
SerializeToString()返回序列化的字符串，ParseFromString(data) 反序列化
SerializeToOstream(&output)序列化到输出流，ParseFromIstream(&input)从输入流进行反序列化；

##### 整型
| int type | 说明 |
|:---:|---|
| int32/int64 | 使用变长编码，负数编码比较低效 |
| uint32/uint64 | 变长编码 |
| sint32/sint64 | 变长编码，负数比int高效 |
| fixed32/fixed64 | 定长编码，当值大于2^28、2^56比uint更高效 |
| sfixed32/sfixed64 | 定长编码 |

##### 字符串
包含UTF-8编码或 ASCII 编码的字符

##### 枚举
每个枚举值后面是分号结尾
32位整型值，不推荐负数（因为使用的是变长编码），不允许值冲突，除非设置`allow_alias`选项，例如：
```
enum EnumAllowingAlias {
    option allow_alias = true;
    UNKNOWN = 0;
    STARTED = 1;
    RUNNING = 1;    // 是STARTED的别名
}
```

##### map
```
map<key_type, value_type> map_field = N;
```
其中，`key_type`可以是任何整型或字符串类型，`value_type`可以是任何类型。
*注*：
1. extension不支持该类型
1. 不带MODIFIER

##### 协议变更
+ 如果要增加字段，可以指定optional 或repeated 类型，以确保旧版本可以忽略该字段（但并不会丢弃，当该message要被序列化，这些字段会被重新序列化，从而当传给新版本后，这些字段依然可用）；
+ 如果要删除字段，该字段不能是required 类型，此外，为避免该字段的ID 或名字被重复使用而造成冲突，可以给字段加上`OBSOLETE_`前缀，或在删除字段后使用`reserved`以避免被重用：
```
message Foo {
    reserved 2, 15, 9 to 11;
    reserved "foo", "bar";
}
```
+ int32/int64/uint32/uint64 和 bool都是类型兼容的，当协议变更时，可以变更类型。
+ 当bytes是有效的UTF-8编码，那它就和string是兼容的。
+ 当bytes是嵌套message字段的编码，那他们是兼容的。
+ optional 类型和repeated 类型是兼容的。

#### 扩展
通过扩展，可以不必修改原始的proto文件，达到协议变更的目的。
```
message Foo {
    // ...
    extensions 100 to 199;  // 留出ID范围给扩展，可以使用max 表示2^29-1
}

extend Foo {
    optional int32 bar = 126;   // 使用预留ID 进行扩展
}
```
扩展可以嵌套定义在其他message中
但访问扩展字段的方法有所不同：
SetExtension(field, value)、GetExtension(field)、HasExtension(field)、ClearExtension(field)、AddExtension(field, index)
这里的field，若不含嵌套，则直接是字段值；若含嵌套，则是Parent::field，Parent是嵌套的外部message名
通常的设计模式是将扩展嵌套与扩展字段类型的message之内
**注意**：要避免多个用户使用相同的扩展ID进行扩展，否则会引起冲突

#### oneof
多个optional字段至多只有一个有效（类似C 的union，共享内存）
```
message SampleMessage {
    oneof test_oneof {
        string name = 4;
        SubMessage sub_message = 9;
    }
}
```
*注*：
1. oneof内的字段都是optional的，所以，其中的MODIFIER不写
2. oneof内增删字段对兼容性都是有风险的，因为对于未知字段，不能确定其是否是oneof的成员
2. extension不支持



#### 导入
```
import "da/db/dc.proto"
```
必须在文件第一行
import默认只导入直接导入文件的内容，不做递归导入，除非使用`import public`来进行导入。
proto编译器搜索导入文件是通过指定 `-I/--proto_path` 来确定目录的，如果没有指定，就以当前执行目录作为搜索根目录。

#### 包
```
package a.b.c;
```
解决名字冲突。
名字解析方式和C++一致（类似目录的 /），以 `.` 打头的名字，从最外的域开始解析


#### 服务
```
service FooService {
    rpc GetSomething(FooRequest) returns (FooResponse);
}
```
1. 定义service接口
2. 编译产生抽象接口和存根（Stub）实现（该stub会转发所有的调用给RpcChannel，而后者也是一个抽象接口）
3. 实现抽象接口
4. server端export service，run
5. client端，实现RpcChannel
    1. 使用 RpcChannel 建立到指定地址的连接
    2. 使用抽象接口的Stub，创建一个代理服务
    3. 设置RPC参数，调用抽象接口的服务(MyRpcController，input，output，NewCallback)

google RPC 的官方实现：gRPC，推荐使用proto3 去定义服务


#### 选项
Options并不改变整个文件声明的含义，但却能够影响特定环境下处理方式。
完整的可用选项可以在google/protobuf/descriptor.proto找到

##### 分级
文件级
message级
field级

##### 支持自定义

### 编译proto文件
```
protoc --proto_path=IMPORT_PATH --cpp_out=DST_DIR --java_out=DST_DIR --python_out=DST_DIR path/to/file.proto
```
`IMPORT_PATH`：指定import 命令查找.proto文件的目录。如果缺省，则使用当前执行目录。如果有多个目录则`--proto_path` 可以写多次，它们将会顺序的被访问并执行导入。`-I=IMPORT_PATH`是它的简化形式。
`--cpp_out` 在目标目录`DST_DIR`中产生C++代码(另有`--python_out`、`--java_out`)。如果`DST_DIR` 是以.zip或.jar结尾的，编译器将输出结果打包成一个zip格式的归档文件(jar同理)。如果该输出归档文件已经存在，它将会被重写，编译器并没有做到足够的智能来为已经存在的归档文件添加新的文件


### 动态编译
[参考](http://www.ibm.com/developerworks/cn/linux/l-cn-gpb/#minor4.2)

google::protobuf::compiler::MultiFileErrorCollector errorCollector；
google::protobuf::compiler::DiskSourceTree sourceTree;
google::protobuf::compiler::Importer importer(&sourceTree, &errorCollector);

sourceTree.MapPath("", protosrc);
importer.import("lm.helloworld.proto");
importer对象有2个构造参数，一个是 source Tree 对象，该对象指定了存放 .proto 文件的源目录。第二个参数是一个 error collector 对象，该对象有一个 AddError 方法，用来处理解析 .proto 文件时遇到的语法错误。

类 FileDescriptor 表示一个编译后的 .proto 文件；类 Descriptor 对应该文件中的一个 Message；类 FieldDescriptor 描述一个 Message 中的一个具体 Field。
通过 Descriptor，FieldDescriptor 的各种方法和属性，应用程序可以获得各种关于 Message 定义的信息。比如通过 `field->name()` 得到 field 的名字。这样，您就可以使用一个动态定义的消息了。



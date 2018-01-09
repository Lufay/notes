# Thrift
[官网](http://thrift.apache.org/)

## 概念
+ Transport 层
提供了一个简单的网络读写抽象层
+ Protocol 层
定义了一种将内存中数据结构映射成可传输格式的机制（序列化编码）
+ Processor 层
封装了从输入数据流中读数据和向数据数据流中写数据的操作
从连接中读取数据（使用输入protocol），将处理授权给handler（由用户实现），最后将结果写到连接上（使用输出protocol）。
+ Server
创建一个transport对象，为transport对象创建输入输出protocol，基于输入输出protocol创建processor，等待连接请求并将之交给processor处理


## 实现
### Transport类
TSocket - 阻塞式，采用TCP Socket进行数据传输
THttpTransport – 采用Http传输协议进行数据传输
TFileTransport – 以文件形式进行传输。
TZlibTransport – 使用zlib进行压缩， 与其他传输方式联合使用。当前无java实现。
装饰模式
TBufferedTransport – 对某个Transport对象操作的数据进行buffer，即从buffer中读取数据进行传输，或者将数据直接写入buffer
TFramedTransport – 以frame为单位进行传输，非阻塞式服务中使用
TMemoryTransport – 将内存用于I/O. java实现时内部实际使用了简单的ByteArrayOutputStream

### Protocol类
TBinaryProtocol – 二进制格式
TCompactProtocol – 压缩格式
TJSONProtocol – JSON格式
TSimpleJSONProtocol – 提供JSON只写协议, 生成的文件很容易通过脚本语言解析。
TDebugProtocol – 使用易懂的可读的文本格式，以便于debug

### Server类
TSimpleServer – 简单的单线程服务模型，常用于测试
TThreadPoolServer – 多线程服务模型，使用标准的阻塞式IO。
TNonblockingServer – 多线程服务模型，使用非阻塞式IO（使用TFramedTransport数据传输方式必须使用该类型的server）

## IDL
参考tutorial/tutorial.thrift

### 注释
支持shell/C 的单行多行注释

### 包含文件
```
include "shared.thrift"
```

### 名空间、包
```
namespace java tutorial
```
针对语言特别定义

### 类型
```
 *  bool        Boolean, one byte
 *  i8 (byte)   Signed 8-bit integer
 *  i16         Signed 16-bit integer
 *  i32         Signed 32-bit integer
 *  i64         Signed 64-bit integer
 *  double      64-bit floating point value
 *  string      String
 *  binary      Blob (byte array)
 *  map<t1,t2>  Map from one type to another，可以使用JSON格式进行定义
 *  list<t1>    Ordered list of one type
 *  set<t1>     Set of unique elements of one type
```
容器中的元素类型可以是除了service 以外的任何合法thrift类型（包括结构体和异常）。
支持typedef

#### 枚举
```
enum Operation {
  ADD = 1,
  SUBTRACT = 2,
  MULTIPLY = 3,
  DIVIDE = 4
}
```
32位整数，未指定数值始于1

#### 结构
```
struct Work {
  1: i32 num1 = 0,
  2: i32 num2,
  3: Operation op,
  4: optional string comment,
}
```
整数标识: 类型 标识符 可选的默认值
required 标识必须字段
optional 标识可选字段（可省）
可以包含其他结构，但不支持继承

##### 变更
+ 不要修改现存域的整数标识
+ 新添加的域必须是optional
需要将它的`__isset`值设为true，这样才能序列化并传输或者存储（不然optional字段被认为不存在，不会被传输或者存储）
`__isset`是每个thrift对象的自带的public成员，来指定optional字段是否启用并赋值
+ 非required域可以删除，前提是它的整数编号不会被其他域使用。对于删除的字段，名字前面可添加`OBSOLETE_`以防止其他字段使用它的整数编号

#### 异常
```
exception InvalidOperation {
  1: i32 whatOp,
  2: string why
}
```
同结构

#### 服务
```
service SharedService {
  SharedStruct getStruct(1: i32 key)
}

service Calculator extends shared.SharedService {
   void ping(),

   i32 add(1:i32 num1, 2:i32 num2),

   i32 calculate(1:i32 logid, 2:Work w) throws (1:InvalidOperation ouch),

   oneway void zip()
}
```
参数是只读的，不可作为输出参数
支持接口继承
oneway 方法指示client 不必等应答，返回值必须是void

## 编译IDL
```
./thrift --gen java tutorial.thrift
```
编译产生`${thrift_name}_constants`、`${thrift_name}_types`、`${service_name}`、`${service_name}_server.skeleton`若干个文件
Thrift编译器（采用C++语言编写）也分为词法分析、语法分析等步骤，Thrift使用了开源的flex和Bison进行词法语法分析（具体见thrift.ll和thrift.yy），经过语法分析后，Thrift根据对应语言的模板（在compiler/cpp/src/generate目录下）生成相应的代码。


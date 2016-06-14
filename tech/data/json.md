[TOC]
# JSON(JavaScript Object Notation)
一种轻量级的数据交换格式。

## 优点
独立于语言
具有自描述性（可读性）
读写性能更好（比XML）
空间占用更小（比XML）
更易解析（比XML）

## 语法规则
顾名思义，JSON是JavaScript对象表示法的子集。
+ null
+ 数值：整数或浮点数
+ 字符串：使用双引号，而且不允许出现控制字符，所以`\n\t`必须写为`\\n\\t`
+ 逻辑值：true 或 false
+ 数组：使用方括号，中间用逗号分隔，成员可以是不同类型
+ 对象：使用花括号，数据结构为键值对的结构：`{key: value, key: value, ... }`
其中key为字符串，value可以是任何类型

## 格式化与解析
网上有很多在线解析

### JavaScript 解析
首先要明确，尽管json和js object很像，但在web数据传输过程，json是以字符串形式传输，而 JavaScript 操作的是js object
由于json是JavaScript对象表示法的子集，所以可以直接用`eval('(' +str + ')')`进行解析
其中str就是近似符合json格式的字符串，将其转换为js object，之所以称之为近似，是因为JSON的语法是js object语法的子集，这里是可以使用js object语法，包括不严格要求key带引号，也不严格要求单引号还是双引号
但eval函数存在执行js代码的风险，因此最好使用下面介绍的方法

#### 一般方法
ECMAScript 5对解析JSON进行规范，定义了全局对象JSON，可以通过调用该对象的方法完成
##### 序列化
js object -> json
JSON.stringify(value[, replacer [, space]])
其中
+ value 是将被序列化的 js 值
+ replacer 过滤器，可以是
    - string数组，用于指定序列化的键
    - 函数function(key, val)，该函数对value参数进行预处理，初始key是空串，val是value。如果该函数返回undefined，则不序列化该键；如果返回一个标量，则作为该字段的序列化的结果；如果返回一个obj（包括数组和object），则将其中每个字段递归调用该函数进行序列化，key是数组的索引或object的key，val是对应数组值或value。
+ space 决定是否美化：缺省表示不美化
    - 数字，表示缩进几个空格（1~10，小于1则不美化，大于10则为10）
    - 字符串，则将缩进填充该字符串（最大长度也是10）。

另外，如果value或其中的成员有toJSON()方法，则该函数将直接使用该方法的返回值。
##### 反序列化
json -> js object
JSON.parse(str[, reviver])
其中
+ str 是合法的json串（如果非法会抛出异常）
+ reviver 函数function(key, val)，该函数对反序列化后的对象进行后处理，对于一个字段反序列化后成为一对key,val调用该函数，如果返回null或undefined，则删除该字段；否则，使用返回值作为该字段反序列化的结果。由于子子对象先于父对象反序列化，所以父对象而后也会调用该函数进行过滤，直到最后调用的key为空串，val为str参数整体的反序列化结果。


#### 使用jQuery
##### 序列化
~~$.toJSON(val)~~
##### 反序列化
$.parseJSON(str)

#### 对于较老的浏览器
可以使用js的json库<https://github.com/douglascrockford/JSON-js>

### PHP解析
<http://www.json.org>

### python解析
import json
#### 序列化
py object -> json
类型的映射关系：
| Python类型 | Json类型 |
|---|---|
| dict | object |
| list, tuple | array |
| string, unicode | string |
| int, long, float | number |
| True/False | true/false |
| None | null |
```
dump(obj, skipkeys=False, ensure_asci=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, encoding='utf-8', default=None, sort_keys=False,...)
```
+ obj 就是序列化的Python对象；
+ skipkeys 如果设置为False，则如果obj字典的key不是基本类型就会被忽略而不是抛出一个TypeError异常；
+ `ensure_asci` 如果为False，那么所有的非ASCII字符将不被转义，返回值将是一个Unicode实例；
+ `check_circular` 如果是False，就不再对容器进行循环引用检查，如果有循环引用将导致OverflowError异常；
+ `allow_nan` 如果是False，那么对于python的nan, inf, -inf不再转换为json的NaN，Infinity, -Infinity，而是抛出一个ValueError；
+ indent 是一个自然数，默认None，即紧凑形式，0是带换行，其他是表示缩进的字符数（因为默认的分隔符是", "，因此每行末都会有一个多余的空格，可以通过制定separators来自定义分隔符）；
+ separators 是一个二元组(`item_sep`, `dict_sep`)，前者是kv中每个项目的分隔符，后者是kv之间的分隔符，默认是(', ', ': ')；
+ encoding 指定返回字符串的编码；
+ `sort_keys` 如果为True，那么返回的内容将按key进行排序。

还有一个dump函数，它多了一个第二个参数，是一个类文件对象（支持write操作，用于自定义字符串的产出位置）

例子：
```
dd = {
    u'jsonrpc': u'2.0',
    u'id': 0,
    u'error': {
        u'message': u'service on specified stub not found',
        u'code': 7,
        u'data': {
            u'function': u'OnReceived',
            u'stack': u'',
            u'file': u'sofa/rpc/rpc_server_impl.cpp',
            u'line': 546,
            u'prev_exception': None,
            u'error_code': 7,
            u'message': u'service on specified stub not found'
        }
    }
}
ss = json.dumps(dd, indent=4)
```

#### 反序列化
json -> py object
类型的映射关系：
| Json类型 | Python类型 |
|---|---|
| object | dict |
| array | list |
| string | unicode |
| number(int) | int, long |
| number(real) | float |
| true/false | True/False |
| null | None
```
loads(s, encoding=None, cls=None, obj_hook=None, parse...)
```
+ s 是json字符串（基于ASCII编码，如果不是的话，还需要字符串调用decode解析为一种基于ASCII编码的字符集）；
+ encoding 指定了这个字符串的编码（如果不是utf-8编码需指定）；
+ `obj_hook`是一个函数，用解码返回的字典做参数进行调用，用返回值替代解码返回的字典；
+ 而parse...系列参数是在某种类型被解析是调用

还有一个load函数，它的第一个参数是一个类文件对象（支持read操作，用于提供解析的字符串）

例子：
```
ss = '{"jsonrpc":"2.0","error":{"code":7,"message":"service on specified stub not found","data":{"error_code":7,"line":546,"prev_exception":null,"file":"sofa\\/rpc\\/rpc_server_impl.cpp","function":"OnReceived","message":"service on specified stub not found","stack":""}},"id":0}'
dd = json.loads(ss)
```

### shell 解析
工具jq

### cpp 解析
使用rapidjson 性能好，更符合标准，[中文文档](http://rapidjson.org/zh-cn/index.html)
使用jsoncpp 接口友好


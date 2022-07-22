# JMESPath 快速json查询
<https://www.osgeo.cn/jmespath/tutorial.html>

`pip install jmespath`

```py
jmespath.compile(j_path) -> Parser
jmespath.search(j_path, data) -> Any
```
其中j_path 就是获取数据的路径字符串

## 路径字符串语法能力
### 字典对象化
把字典当成对象，key 都是对象属性，可以使用`.`获取属性
若没有key 返回null

### 数组索引和切片
`[start:stop]` 或 `[start:stop:step]` 支持负索引，step 为负，则逆序获取
越界返回null

### 投影
#### 列表投影
```py
data = {
  "people": [
    {"first": "James", "last": "d"},
    {"first": "Jacob", "last": "e"},
    {"first": "Jayden", "last": "f"},
    {"missing": "different"}
  ]
}
jmespath.search('people[*].first', data)
```
投影结果数组中会过滤 null

##### Flatten 投影
用`[]` 替换`[*]` 就能展平一层
同理，`[][]` 可以展平两层

#### 字典投影
```py
data = {
  "ops": {
    "functionA": {"numArgs": 2},
    "functionB": {"numArgs": 3},
    "functionC": {"variadic": true}
  }
}
jmespath.search('ops.*.numArgs', data)
```

### 列表过滤
```py
data = {
  "machines": [
    {"name": "a", "state": "running"},
    {"name": "b", "state": "stopped"},
    {"name": "b", "state": "running"}
  ]
}
jmespath.search('machines[?state==`running`].name', data)
```
仅支持`==, !=, <, <=, >, >=`（比较运算符仅能用于数字比较）
常量都需要使用`` ` ``（该字符可以使用`\`进行转义）包住，无论是数字、字符串、true/false

### 管道
管道就是先把结果计算出来，然后再作为输入作用后一个表达式
通常用于投影后的收集
```py
data = {
  "people": [
    {"first": "James", "last": "d"},
    {"first": "Jacob", "last": "e"},
    {"first": "Jayden", "last": "f"},
    {"missing": "different"}
  ]
}
jmespath.search('people[*].first | [0]', data)
```

### 结果变换
类似SQL的select，它并不会过滤null
```py
data = {
  "people": [
    {
      "name": "a",
      "state": {"name": "up"}
    },
    {
      "name": "b",
      "state": {"name": "down"}
    },
    {
      "name": "c",
      "state": {"name": "up"}
    }
  ]
}
# 返回列表
jmespath.search('people[].[name, state.name]', data)
# 返回字典
jmespath.search('people[].{Name: name, State: state.name}', data)
```

### 函数调用
```py
for item in ret['detail']:
    if (ls:=item['Labels']) and 'Global' in ls and \
            (c:=len(item['CategoryID'])) != 2:
        print(c, item)
# 可以转换为
d = jmespath.search('detail[?contains(Labels, `Global`) == `true` && length(CategoryID) != `2`][length(CategoryID), @]', res)
for i in d:
    print(*i)
```
在过滤表达式中，使用了contains 和length 两个函数，对指定字段内容进行计算，最后结果转换为二元组的列表，`@` 表示当前元素节点
函数参数可以使用`&exp`，用于指定不立即求值的表达式，类似一个匿名函数参数，供当前函数进行使用

#### 函数
string type(any)：返回参数的类型字符串

##### 类型转换
to_string
to_number
to_array：将字符串表示的列表转换成列表，或者直接将参数装入列表

##### 数字函数
num abs(num)
num ceil(num)
num floor(num)

##### 字符串函数
bool contains(array|string, any)
bool ends_with(string, string prefix)、starts_with
string join(string, array[string])
num length(string|array|object)
array|string reverse(array|string)

##### 列表函数
num avg(arr[num])、sum
bool contains(array|string, any)
num length(string|array|object)
array map(exp, array): 跟投影的不同是不会过滤null，都会返回到结果array 中
num max(array[num]|array[string])、min、sort
max_by(array, exp)、min_by、sort_by：使用exp 来对array 每个元素计算比较的key（num 或string）
not_null(any...)：返回第一个不是null 的值，若全是null，则返回null
array|string reverse(array|string)

##### 字典（object）函数
array keys(object)、values
num length(string|array|object)
object merge(object...)：合并多个字典（后者覆盖前者）

### 和、或表达式
空值包括：null、false、空串、空列表[]、空字典{}

`!exp` 返回布尔值

`exp1 && exp2` 若exp1 为空值，则返回，否则返回exp2 

可以使用`||` 连接多个path 表达式，则返回第一个不为空值的结果，若全部都是空值则返回null


# TOML
Tom’s Obvious, Minimal Language
极简的配置文件格式，从而被多种语言解析。
[参考](https://github.com/toml-lang/toml/tree/master/tests)

## 格式
+ 大小写敏感
+ `#` 表示注释，从这个字符一直到行尾，都会被解析器忽略

### 数据类型
#### 字符串
以引号包裹，里面的字符必须是UTF-8 格式
支持多行字符串，使用三引号（字符串中除了位于开头的换行符外都保留，可以在行尾使用'\'，来忽略其后的换行符和空白符）

##### 双引号字符串
支持转义字符
\b     - backspace       (U+0008)
\t     - tab             (U+0009)
\n     - linefeed        (U+000A)
\f     - form feed       (U+000C)
\r     - carriage return (U+000D)
\"     - quote           (U+0022)
\/     - slash           (U+002F)
\\     - backslash       (U+005C)
\uXXXX - unicode         (U+XXXX)

二进制数据建议使用Base64 或其他合适的编码。具体的处理取决于特定的应用。

##### 单引号字符串
完全字面值表示

#### 整数
支持正负，64位

#### 浮点数
64位

#### 布尔值
true/false

#### 日期
使用ISO 8601 完整格式。
例如`1979-05-27T07:32:00Z`

#### 数组
用方括号包裹，逗号分隔，元素必须是同种类型
可以嵌套（内层各个数组可以是不同元素组成），可以跨多行定义

#### 表格
类似哈希或字典
```
[table]
  key = "val"
```
在此之下，直到下一个table 或EOF 之前，是这个表格的键值对
缩进不要求，怎么缩进都行
table 可以是点分的，表示嵌套
不要求先定义表a，才能定义a.b
但不能重复定义table
例如
```
[dog.tater]
type = "pug"
```
表示为JSON 是`{ "dog": { "tater": { "type": "pug" } } }`

##### 表格数组
`[table]`变为`[[table]]`
多次定义按顺序加入数组


## 格式化与解析
### Python 解析
<https://github.com/uiri/toml>
<https://github.com/hit9/toml.py>
<https://github.com/bryant/pytoml>
<https://github.com/felipap/toml-python>

### PHP 解析
<https://github.com/yosymfony/toml>
<https://github.com/jamesmoss/toml>
<https://github.com/leonelquinteros/php-toml>
<https://github.com/checkdomain/toml>


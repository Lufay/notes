# YAML
YAML Ain't Markup Language
是一种直观的能够被电脑识别的数据序列化格式，是一个可读性高并且容易被人类阅读，容易和脚本语言交互，用来表达资料序列的编程语言。
[参考](http://www.ruanyifeng.com/blog/2016/07/yaml.html?f=tt)

## 格式
+ 大小写敏感
+ 通过缩进来表示层级关系（不能使用TAB字符，只允许使用空格）
+ 缩进的空格数目并不是非常重要（Saltstack 使用2个），只要相同层级的元素左侧对齐即可
+ `#` 表示注释，从这个字符一直到行尾，都会被解析器忽略
示例：
```
house:
  family:
    name: Doe
    parents:
      - John
      - Jane
    children:
      - Paul
      - Mark
      - Simone
  address:
    number: 34
    street: Main Street
    city: Nowheretown
    zipcode: 12345
```
可以缩写：
```
house:
  family: { name: Doe, parents: [John, Jane], children: [Paul, Mark, Simone] }
  address: { number: 34, street: Main Street, city: Nowheretown, zipcode: 12345 }
```

### 结构
YAML 支持的数据结构有三种：
+ 对象：键值对的集合，又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）
key/value对用冒号“:”来分隔，冒号后面一定要有一个空格（以冒号结尾不需要空格，表示文件路径的模版可以不需要空格）
如果key 为数组需要在key 前加`?`
+ 数组：一组按次序排列的值，又称为序列（sequence） / 列表（list）
通过减号“-”加一个空格来表示。多个项使用同样的缩进级别作为同一个列表的一部分
+ 纯量（scalars）：单个的、不可再分的值
	- 整数、浮点数
	- 字符串（可以不使用引号，除非有空格或特殊字符，单双引号都可以，单引号之中如果还有单引号，必须连续使用两个单引号转义）
	字符串可以写成多行，从第二行开始，必须有一个单空格缩进。换行符会被转为空格
	多行字符串可以使用`|`保留换行符，也可以使用`>`折叠换行
	`+`表示保留文字块末尾的换行，`-`表示删除字符串末尾的换行
	- 布尔值（true/false）
	- 时间（ISO8601 格式）、日期（复合 iso8601 格式）
	- Null（~）

#### 注意
1. 许在文件中加入选择性的空行，以增加可读性；
1. 一个YAML 文件中可同时包含多个文档，文档间用`---`分隔；用`...`表示文档结尾（在利用串流的通讯中，这非常有用，可以在不关闭串流的情况下，发送结束讯号）

YAML 允许使用两个感叹号，强制转换数据类型。
```
e: !!str 123
f: !!str true
```
对应JavaScript 为：
```
{ e: '123', f: 'true' }
```

#### 引用
锚点`&`和别名`*`
`&`用来建立锚点，`<<`表示合并到当前数据，`*`用来引用锚点
```
defaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  <<: *defaults

test:
  database: myapp_test
  <<: *defaults
```
等同于
```
defaults:
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  adapter:  postgres
  host:     localhost

test:
  database: myapp_test
  adapter:  postgres
  host:     localhost
```

## 格式化与解析
### PHP 解析
[PECL扩展YAML](http://pecl.php.net/package/yaml)
需要PHP 5.2+
PECL 需要编译安装
使用`yaml_emit($arr)`可以将其转化成YAML 字符串
使用`yaml_parse($yaml)`解析YAML 字符串

[spyc](https://github.com/mustangostang/spyc)
需要PHP 5.3+
可以使用Composer安装，当然也可以直接`require_once`或include
解析YAML 文件可以使用Spyc::YAMLLoad('spyc.yaml')，也可以使用`spyc_load_file('spyc.yaml')`

[TOC]
# shell通配符和正则

## shell通配符
`?`         单字符
`*`         0个或多个字符
`[abc]`     字符集
`{aa,bb,cc}`、`{a..z}`	范围集合（支持自身嵌套`{a{1..3},b}`，笛卡尔积`{a..b}{0..4}{x,y}`）

当通配符作为globbing时，会根据文件名进行展开

## 正则表达式
### POSIX 正则表达式
包括BRE(Basic Regular Expression) 和 ERE(Extended Regular Expressions)

#### 共同的
`\`       转义
`.`       匹配除换行符外的任一字符
`*`       闭包（0个或多个前一个字符）
`^`       匹配串首或行首
`$`       匹配串尾或行尾
`[a-z]`      匹配集合（注意，如果集合中含有"]"，则应将其放在第一个，否则将被视为集合的终止）
`[^a-z]`     匹配补集
*注*：对于BRE而言，`* ^ $`必须是合法位置，否则将被视为普通字符

#### BRE 专属的
`\(reg\)`     分组，分组的匹配内容可以被提取
`\n`          分组引用（n为1到9，以左括号的顺序为准）
`\{n\}`       重复n次
`\{m, n\}`    重复次数，至少m次，至多n次（m、n其一可以缺省）
*注*：GNU的BRE支持所有ERE的内容，只不过类似的都需要对元字符进行转义。

#### ERE扩展的
`|`       或
`+`       1个或多个
`?`       0个或1
`(reg)`   分组，ERE的不支持分组引用
`{n}`     重复n次
`{m, n}`  重复次数，至少m次，至多n次（m、n其一可以缺省）
*注*：GNU的ERE也支持分组引用。

#### 字符类
`[:ascii:]` ASCII字符 `[\x01-\x7F]`
`[:alnum:]` 字母数字 `[a-zA-Z0-9]`
`[:alpha:]` 字母 `[a-zA-Z]`
`[:digit:]` 数字 `[0-9]`
`[:xdigit:]` 十六进制数字 `[0-9a-fA-F]`
`[:lower:]` 小写 `[a-z]`
`[:upper:]` 大写 `[A-Z]`
`[:space:]` 空白符 `[\n\r\t \x0B]`
`[:blank:]` 水平空白符 `[ \t]`
`[:punct:]` 标点字符 `[-!"#$%&'( )*+,./:;<=>?@[\\\]^_'{|}~]`
`[:cntrl:]` 控制字符 `[\x01-\x1F]`
`[:graph:]` 任何可视字符 `[\x01-\x20]`
`[:print:]` 可打印字符 `[\t\x20-\xFF]`
字符类可以用在[]集合中作为一类字符

#### 锚
`[:<:]` 单词的开始位置
`[:>:]` 单词的结束位置
*注*：GNU 支持可以直接使用`\<` 和 `\>`。

#### collating sequence
多语言中使用，当语言中一个字符序列表示一个字符时使用
例如ch表示一个字符，可以使用`[.ch.]`

#### equivalence class
多语言中使用
例如，在法语地区中， [[=e=]] 可以匹配任意e、è或é

### PERL 正则
兼容 ERE 正则
包含次数的匹配，默认进行贪婪匹配，如果在次数模式后加上`?`，就进行非贪婪匹配（即尽可能少地匹配命中）

#### 修饰符
i   不区分大小写
g   全文搜索（默认查找到第一次匹配后停止）
m   多行模式（`^ $`从串首位变为行首尾，用\A表示串首）

#### 锚和字符集
\b 匹配单词的边界
\d 匹配一个数字
\w 匹配一个字母数字或下划线
\s 匹配一个空格或制表符或换页符
如果使用大写字母，则表示反义
\r 回车符
\n 换行符
\t 水平制表符
\v 垂直制表符
\f 换页符
\xnn 16进制字符

#### 分组和断言
`(?<name>exp)`    命名分组
`(?:exp)`         不保存的分组
`(?>exp)`         固化分组，分组被固化后只能整体匹配或放弃匹配，分组内的备用状态都被废弃。（一旦匹配就不再接受分组中部分的回溯）（备用状态通常是在量词位置发生）

##### 零宽断言
*预测表示后面会出现或不出现什么样的字符串，回顾表示前面会出现或不出现什么样的字符串*
正预测先行断言：`(?=exp)`，定界于表达式exp之前的位置
负预测先行断言：`(?!exp)`，定界于不出现表达式exp之前的位置
正回顾后发断言：`(?<=exp)`，定界于表达式exp之后的位置
负回顾后发断言：`(?<!exp)`，定界于非表达式exp之后的位置

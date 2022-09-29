# Lua

大小写敏感

## 开始
### 注释
```lua
-- 单行注释

--[[
    块注释
]]--

--[[
    块注释，可以省略结尾的--
]]

--[=[
    块注释，可以在加入任意多个=
]=]
```

### 执行
脚本文件头：`#!/usr/bin/env lua`

## 类型
使用函数type() -> string 可以得到变量或值的类型

### nil
未定义，仅有一个单例，作为布尔值为false

### boolean
两个实例：true/false
除了false和nil，其他作为布尔值都是true

### number
实数

`tonumber(str, base=10)` 可以将字符串转换成指定进制（最多36，即10+26个字符）的数字，转换失败返回nil

### string
字符串，不可变类型，字节序列，因此可以保存二进制数据
使用单引号和双引号均可
`"\u{3b1} \u{3b2} \u{3b3}"` 可以使用UTF-8 编码的字符

`#str` 获取字符串str（可以是变量，也可以是常量）的长度
`str1 .. str2` 字符串连接
`assert("2" > "15")` 按字典序进行比较
`tostring(num)` 将数字转换为字符串

#### 多行字符串
```lua
str = 'aa\
bb'

multi_line = [[
    多行字符串会忽略前置的换行符，不解析转义字符
]]

multi_line = [=[
    和注释一样，= 可以添加多个，只要一致就行
]=]
```
所以，字符串中除了和C相同的转义字符外，还需要对`[`和`]`进行转义
Lua 5.2及其之后引入了一个转义符`\z`，它将忽略后面的明文空白符（不包含使用转义字符的空白符），直到遇到非空白符为止。

#### string库
`string.char(97,98,100)` 将使用各个字节码表示的字符组成一个字符串
`string.byte(str, idx=1, ...)` 返回指定位置字符的字节码，若未指定默认为首字符（位序从1 开始），限于栈容量，最多返回一百万个值
`string.format(fmt, arg...)` 类似sprintf，fmt 可以使用`%s %02d %x %f %.2f` 等形式的占位符，flag：cdioux表示的是不同格式的一个整数；efg表示不同格式的一个浮点数；sq表示一个字符串（q返回一个使用双引号包围的原字符串，并对其中的双引号进行转义）
`string.len(str)` 相当于`#str`
`string.find(str, pattern)` pattern 可以是正则表达式，可以用`%a %d %s` 分别表示字母、数字、空白符，返回找到模式在原字符串中的起始和结束位置返回，找不到返回nil
`string.rep(str, n)` 重复n 次连接
`string.reverse(str)` 反转
`string.lower('Hello')`
`string.upper('Hello')`
`string.sub(str, start, end)` 返回位序从start 到end（包括）的子串（支持负位序，最后一个位序为-1）
`string.gsub(str, pattern, replace)` 模式替换，返回替换后的字符串和替换次数



### table
表，可以模拟array/dict/struct等多种数据结构

### userdata
可以保存C数据
仅有赋值和相等判断运算

### function
函数对象

### thread
协程对象

## 运算
### 比较
不同类型进行比较会抛异常
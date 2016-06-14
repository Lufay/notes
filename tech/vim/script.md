可以脚本中可以执行在vim中 : 模式下的命令
[TOC]

# 变量
## 变量赋值：
```
let var = expr
```
单独的let命令显示当前所有变量

默认变量都是全局的，在变量名前加上 s: 表示局部
其他前缀：
b:    缓冲区的局部变量
w:    窗口的局部变量
g:    全局变量（用于函数中）
v:    预定义变量（例如v:version，表示vim的版本号，600表示6.0）

## 删除变量：
```
unlet var
```
如果并不确定其存在与否，使用unlet!可以避免报错

函数exists()：检查一个变量名（字符串）是否已定义

$name    环境变量
&name    配置选项（如ic等）
@r    寄存器

# 类型
## 数值
支持十进制、十六进制、八进制

##字符串
支持单引号和双引号
使用 \ 做转义

# 运算符和表达式
## 算术：
\+ - * / %

## 字符串连接
.

## 三目表达式

## 关系
==、!=、>、>=、<、<=、=~、!~
最后两个可以用于字符串匹配一个模式（模式最好使用单引号，因为反斜杠在双引号字符串中需要双写才生效）
在做字符串比较时，在比较运算符后加上 # 表示大小写敏感；? 表示不敏感
当字符串和数值做比较，字符串会被转换为一个数值。
注意：如果期待数值类型，Vim 自动把字符串转换为数值。如果使用不以数位开始的字符串，返回的数值为零。

## 逻辑
Vim 把任何非零的值当作真。零代表假。
!    取反


# 语句
## 条件：
```
if cond
    statements
elseif cond
    statements
else
    statements
endif
```
cond的期望是一个整数

## 循环：
```
while cond
    statements
endwhile

for i in range(1,4)
    statements
endfor
```
支持 continue 和 break

# 执行
execute str
执行一个命令的字符串
normal cmd
执行一个普通模式下的命令（不能使用表达式）
为了使用表达式，可以：
exec "normal " . cmd
cmd 必须是一个完整的命令，如
exec "normal Inew text \<Esc>"
开始进入插入模式，最后退出插入模式
## 执行求值
eval(expr)
即：计算expr的值，而后将值作为一个表达式再进行计算，返回

# 显示
echo a b c

# 其他
sleep 1
休息 1 秒，如果使用 50m 表示 50 毫秒

# 函数

[参考](http://blog.chinaunix.net/uid-20564848-id-73068.html)
[参考](http://blog.chinaunix.net/uid-22548820-id-3396168.html)

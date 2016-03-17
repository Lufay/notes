# Vim 小技巧备忘
******
[TOC]

### 大段复制、移动
```
:m,n co d
```
m行到n行的内容复制到d行之后
co 换成 m 表示移动，d 表示删除
******

### 块注释
Ctrl+v 进入块选模式
选择你要注释的行
I 进行前插入
输入行注释

想要取消注释可以用块选删除注释符
******

### vim 粘贴不缩进
```
:set paste
```
恢复：
```
:set nopaste
```
如果想要进一步设置开关快捷键：
```
:set pastetoggle=<F11>
```
即设置 F11 为开关快捷键，[参考](http://www.cnblogs.com/jianyungsun/archive/2011/03/19/1988855.html)
******

### 重新加载打开的文件：
```
:e
```
如果后面加 ! 表示放弃当前修改，而重新加载
******

### 快速定位光标所在的单词：
\*      向下查找
\#      向上查找
******

### 自动调整缩进版式：
先将光标移到自动调整的起始位置（例如：gg，nG）
点 =
再将光标移到自动调整的终止位置（例如：nG，G）
******

### 分屏
http://www.cnblogs.com/me115/archive/2011/05/05/2037273.html
http://blog.csdn.net/brince101/article/details/6322421
http://blog.sina.com.cn/s/blog_7d34486c0100ztku.html
http://hi.baidu.com/iamzangzhi/item/7b5d1dda96937619d78ed025
http://www.yqdown.com/chengxukaifa/shujujiegou/15800.htm
******

### 多粘贴板
用`:reg`命令可以查看各个粘贴板里的内容
其中
"" 是默认的vim粘贴板，直接使用 d/y/p 命令都从这里存取（最近一次）
"0 是复制粘贴板，即 y 命令存入这里
"1 是剪切粘贴板，即 d 命令存入这里
"0 到 "9
"a 到 "z
"A 到 "Z
"- 是行内剪切板
以下只读：
": 是最近执行的命令
". 是最近插入文本
"% 是当前文件名
"# 是当前交替文件名
"/ 是最近搜索的模式
选择与拖拽（非GUI版本的vim，不可用）：
"*
"+ 系统粘贴板，可以用Ctrl+v粘贴到外部或者外部Ctrl+c复制到这里
"~
系统粘贴板可用时，可与外部应用交互
黑洞：
"_ 不存储，直接丢弃

如果要使用其他粘贴板，只需在命令前带上粘贴板的板号即可（例如"a）
***

### 标记
使用`mx`命令可以在当前光标行插入一个标记（x是A-Za-z的一个字母，不过小写字母的标记是文件级的，大写字母的标记是全局的）
`'x`或`` `x``命令可以快速跳转到标记的该行，另外，所有需要行号的命令位置，都可以使用该命令替代行号（差别是 ' 不记忆列，而是在第一个非空白字符，\` 可以调到原列）
`:marks` 显示所有设置的标记
`:delm x y z` 删除标记
有一些常用的自动标记：
`'` 跳转前的位置
`"` 最后编辑的位置
`[` 最后修改位置的开头
`]` 最后修改位置的结尾
0-9 在 .viminfo 文件中设置
****

### 打开文件并定位到某一行
```
vim filename +n
```
****

### 其他
[垂直对齐线](http://www.oschina.net/code/snippet_574132_13357)
[键映射](http://haoxiang.org/2011/09/vim-modes-and-mappin/)
[键映射](http://blog.chinaunix.net/uid-128922-id-289967.html)
<http://www.tuicool.com/articles/f6feae>







# Exuberant Ctags

## 安装
```
./configure --prefix=
make && make install
```

## 使用
```
ctags [options] [file(s)]
```
选项：
--list-languages：支持的语言
--list-maps=[language|all]：列出支持语言对文件名后缀的映射
--langmap=c++:+.inl：增加.inl到C++的映射
-R：递归子目录（只要文件名后缀可识别就会被扫描）
--languages=[+|-]list：扫描的文件类型列表（逗号分隔）
-h <list>：list是一个一个扩展名表，指定这些扩展名被当做被包含文件
--fields=[+|-]flags：指定tag entry显示的字段（包括afmikKlnsStz，默认fks）(a:access可访问性)(f:)(m:)(i:inherit显示父类)(k:kind)(K:类型全称)(I:)(n:)(s:)(S:函数签名)(t:)(z:语法元素的类型)
--extra=[+|-]flags：flags包括fq（f:记录扫描那些文件，一个文件一个tag entry）（q：默认只记录不包括namespace和所属类的名字，加上这个选项后，则追加一条tag entry，附带上这些信息）
--list-kinds=[language|all]：列出指定语言的kinds
--<LANG>-kinds=[+|-]kinds：为某种语言增减kinds
--exclude=pattern：不检查的文件或目录
-f <name>：指定输出文件名，如果指定为 -，表示stdout
不管一次扫描多少文件，一条命令都把所有内容记到一个文件中，默认是当前目录的tags

在vim中：
`:set tags=./tags, ./../tags, ./*/tags`    指定多个tags文件（注意：中间不要有空格，否则需要使用 \ 对空格进行转义；开头的./中的 . 代表的是当前文件所在的目录，而不是真正的当前目录，不能用 .. 直接开头）（支持 * 统配）(支持+=进行添加）
如果:set ignorecase，而tagcase又被设置为followic或ignore，那么就忽略大小写
:tag pattern        将跳转到pattern（可使用正则，须使用 / 打头）的定义位置（如果带上前缀n表示跳转到第n个命中pattern位置）
CTRL+]               跳转到当前光标下word的定义位置（如果带上前缀n表示跳转到第n个命中pattern位置）
:tags                    列出到过的tag stack
:pop                    跳到之前一次tag（可以带前缀n表示向前跳n次）
CTRL+T              同上
:tag                      跳到之后一次tag（可以带前缀n表示向前跳n次）
:ts pattern            列出匹配pattern的位置list
g]                          同上，pattern为当前光标下Word
:tn                        跳到tag matched list中下一个位置（可以带前缀n表示向下跳n次）
:tp                        跳到tag matched list中上一个位置（可以带前缀n表示向上跳n次）
:tf                        跳到tag matched list中第一个位置
:tl                        跳到tag matched list中最后一个位置
在跳转后使用:split命令，则将分割窗口进行显示，如果要直接分割使用:stag命令和CTRL+W+]
这些命令加前缀 p，则将以preview窗口展示（不跳转，可以使用:pclose关闭preview窗口）


# shell 变量
http://www.cnblogs.com/barrychiao/archive/2012/10/22/2733210.html

## shell 字符串
shell 下默认的类型就是字符串，而引号仅仅是移除shell的meta字符的特殊含义

### meta 字符
```
|  &  ;  <  >  (  )  $  `  \  "  '  <space>  <tab>  <newline>
```
部分环境下的meta字符
```
*   ?   [   #   ˜   =   %
```

### 转义符
这种移除特殊含义的功能还可以通过`\`转义实现，只不过转义只能移除其后一个字符的特殊含义。
如果该字符没有特殊含义，则该字符保留，`\`则不会保留；
而且`\`转义还有一个例外，就是如果`\`是在一行的末尾，即转义的是`<newline>`，那么它表示的是续行，而不是字符串的换行，即该字符串会将两行连接为一行。

### 双引号
被双引号引起来的字符串，除``$  `  \  !``外均被转义（注意，不支持`\n`之类的控制字符，不过因为引号引的所有字符都原样保留，包括`<newline>`，所以，可以直接换行）
``$ ` ``保持其原意，进行变量替换或命令执行结果的替换；
`!`，将使用history 中的命令记录进行替换；
`\`，仅当在以上三字符以及`"`字符之前才保持转义功能，即将这四种字符转义为文本，除此之外，该字符都作为普通字符保留在字符串中

### 单引号
被单引号引起来的字符串，所有meta字符均被转义
不过有一种特殊的用法用以解决不支持`\n`之类的控制字符的问题
就是在单引号字符串前加上`$`，即形如`$'string'`，则string中的ANSI C 标准的控制字符都会生效
而双引号字符串前加上`$`，其转换方式则取决于当前的locale。如果当前的locale是C 或 POSIX `$`就会被忽略。

### 字符串变量
当将字符串赋值给变量，如果直接echo这个变量，该变量会被解析为直接的字符串从而进行显示，而字符串中的换行会作为一个空格进行显示，要想显示为一个换行，就将这个变量用双引号引起来


# shell 数组
http://bbs.chinaunix.net/thread-1779167-1-1.html
例：
```
arr=('work@10.226.52.66' 'work@10.226.52.67' 'work@10.226.53.65' 'work@10.226.57.67')
for site in ${arr[@]}
do
	sshpass -p baidu@soFa123 scp $site:/home/work/wangxing/ps/se/sofa/test/module_test_3/rpc_test/p2mp_test/server*.log ./server${site}.log
done
```
其中`@`也有用`*`的

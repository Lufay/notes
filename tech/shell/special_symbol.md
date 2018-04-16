# shell 中的特殊字符

`:`		还可以作为环境变量的分隔符
`,`		一系列连续运算，只有最后一项被返回
`!`		执行history中指定编号的命令
`&`		后台执行
`>`		输出重定向（覆写模式）
`>>`	输出重定向（追加模式）
`<`		输入重定向
`<<`	Here Document
`<<<`	Here Strings（和前者的区别在于这里是单行，不需要终结符）

## 除某个之外删除
```
rm !(aaa)
rm !(aaa|bbb)
```
其他方法：
```
find ./ -name '' -maxdepth 1 -type f | grep -v 'keep' | xargs rm
```
`find`查找基础的删除集，`grep -v`对删除集进行过滤，最后执行删除
*注1*：这里使用了xargs，而不是将find+grep用$()做 rm 的参数是为了防止当删除集过大时 rm 会报告参数列表过长的问题
因为xargs 会把长串拆分为多个子串，多次调用 rm
*注2*：也不要直接使用`find -exec rm '{}' \;`，因为它会对find 的每一行结果调用一次rm，性能较差。

## 输出重定向
+ 使用覆盖式的，则自使用重定向的命令就会清空文件，即在进行命令内部的处理之前，就已经清空文件了
+ 使用追加式的，则不会清空文件

因此，使用输出重定向，就相当于以不同模式打开文件，命令中的输出都写到该文件中的了。
但有一点要注意的是，如果命令是一个函数，函数中前面有输出，而后面又会以该文件为输入（cat不行），则前面的输出会对后面的造成影响。

shell对函数输出重定向后，如果函数中的某条语句在使用重定向则会劫走外部的重定向输出
若想要两个地方获得输出，可以使用 `| tee fileName`，但管道只导出标准输出，而不导出标准错误，所以如果标准错误也要导出到文件，则管道前需将标准错误重定向（`2>&1`）

### 重定向正在运行的进程
1. 获得程序的进程号(PID)
1. 使用gdb调试这个进程。(gdb -p $pid)
1. 通过close系统调用关闭标准输出(STDOUT：`call close(1)`)或者标准错误(STDERR：`call close(2)`)
1. 通过creat系统调用打开一个文件并将其文件描述符通过dup2系统调用复制给标准输出或者标准错误(`call dup2(creat("/tmp/log", 0600), 1)`)
1. 退出调试器。现在可以将程序通过“CTRL+z”, “bg”, “disown“放入后台运行了(quit)

## 清空文件
1. 利用NOP命令：
```
: > file
```
2. 使用echo：
```
echo -n > file
```
3. 使用cat：
```
cat /dev/null > file
```
4. 不使用任何命令：
```
> file
```

## here document用法
Here Document 是在Linux Shell 中的一种特殊的重定向方式，它的基本的形式如下:
```
cmd << delimiter
    Here Document Content
delimiter
```
它的作用就是将两个 delimiter 之间的内容(Here Document Content 部分) 传递给cmd 作为输入。
delimiter只是一个标识而已，可以替换成任意的合法字符序列
作为起始的delimiter前后的空格会被省略掉，作为结尾的delimiter一定要单独成行，前后都不能有任何字符 （包括空格）
Here Document Content中可以引用变量
如果使用的是`<<-`，那么Here Document Content中每行开始的 tab 将被删掉。
使用该用法可以构造块注释：
```
: << EOF
    Comment Document
EOF
```

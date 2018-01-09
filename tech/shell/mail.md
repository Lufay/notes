# mail
## 直接使用mail 命令
查看收件箱，此时命令提示符为"&"

### 命令
unread 标记为未读邮件
h | headers 显示当前的邮件列表
l | list 显示当前支持的命令列表
? | help 显示多个邮件命令及参数和用法
d 删除当前邮件，指针并下移。 d 1-100 删除第1到100封邮件
f | from 只显示当前邮件的简易信息。 f num 只显示某一个邮件的简易信息（并将指针移动到该封邮件上）
z 显示刚进行收件箱时的后面二十封邮件列表
t | type | more | p | page 阅读当前指针所在的邮件内容（如果后面跟一个数字，就阅读指定的邮件）。阅读时，按空格键就是翻页，按回车键就是下移一行
n | next | {直接回车} 若当前邮件未阅，则阅之，否则阅读下一封邮件内容，如果调整指针则重置为未阅（后面可以跟一个数字，来阅读指定的邮件）
     阅读时，按空格键就是翻页，按回车键就是下移一行
v | visual 当前邮件进入纯文本编辑模式
s filename 把信保存到文件
top 显示当前指针所在的邮件的邮件头
file | folder 显示系统邮件所在的文件，以及邮件总数等信息
x 退出mail命令平台，并不保存之前的操作，比如删除邮件
q 退出mail命令平台，保存之前的操作，比如删除已用d 删除的邮件，已阅读邮件会转存到当前用户家目录下的mbox文件中。如果在mbox中删除文件才会彻底删除。

在linux文本命令平台输入 mail -f mbox，就可以看到当前目录下的mbox中的邮件了。

cd 改变当前所在文件夹的位置
写信时，连按两次Ctrl+C 键则中断工作，不送此信件。
读信时，按一次Ctrl+C，退出阅读状态。

## 发信
mail [选项] to-addr
邮件内容来自标准输入

### 选项
-s subject
-r from-addr
-c cc
-b bcc
-a attachment，指定一个文件作为附件
-q file，使用一个文件的内容作为邮件内容的开头


# sendmail
电子邮件传送代理程序，基于SMTP

检查所传送的电子邮件是否送出，还是滞留在邮件服务器中
可以使用sendmail -bp 或mailq 命令
若屏幕显示为“Mail queue is empty” 的信息，表示mail 已送出。
若为其他错误信息，表示电子邮件因故尚未送出。

## 发信
sendmail [选项] to-addr
邮件内容来自标准输入
最常用的选项是-t，即从标准输入的头部中解析发件人、收件人、Cc、Bcc

content.txt:
```
Subject: xxx
From: aa@bb.com
To: cc@dd.com
Cc: ee@ff.com

mail content...
```

html 格式：
```
Subject: xxx
From: aa@bb.com
To: cc@dd.com
Cc: ee@ff.com
MIME-VERSION: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"

--GvXjxJ+pjyke8COw
Content-type: text/html; charset=gb2312  #设置编码后中文还是乱码
Content-Transfer-Encoding: 7bit

<html>
	...
</html>
```
或
```
Subject: xxx
From: aa@bb.com
To: cc@dd.com
Cc: ee@ff.com
Content-Type: text/html;charset=utf-8

<html>
	...
</html>
```

### 附件
可以将文件用uuencode 命令进行编码

### 例子
```
(cat content.txt; uuencode att.txt att.txt) | sendmail -t test@hello.com
```


sendmail有着非常好的扩充能力，支持众多的特性，功能可谓豪华。包括频率控制到集群支持应有尽有。而milter API则更加使sendmail的灵活性发挥至极，通过milter，用户可以对邮件几乎所有的参数进行控制！但是在存储方面，由于只支持mbox，会有一定的问题。
使用m4语法，单一的主配置文件（sendmail.cf）是三个mta中最难使用的，但是如果熟悉使用的话却能实现复杂的功能。


formail+sendmail



# gsmsend



# qmail
体积非常小巧
模块化设计，避免了sid 权限问题，基本功能齐全。配置相对sendmail 而言，简单了很多，而且用户非常广泛。而且补丁和插件非常多，例如著名的vpopmail，netqmail，以及qmail-ldap等。
功能扩充需要补丁来完成，扩展能力不足
适合建立中小型邮件系统
qmail使用的是大量小配置文本，格式最简单，每个配置一个文件，存放在/var/qmail/control目录里。



# postfix
流水线、模块化的设计，兼顾了效率和功能。灵活的配置和扩展
至今依然保持活跃的开发工作，而且稳步发展，适合高流量大负载的系统，扩充能力较强。
也使用单一的主配置文件（main.cf），同时还有对应master主服务进程的配置文件master.cf，但使用的是简明易懂的key = value 格式，并配备强大的postconf工具


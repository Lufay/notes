# wget
支持通过HTTP、HTTPS、FTP三个最常见的TCP/IP协议下载，并可以使用HTTP代理
支持断点下传功能

## 格式
```
wget [options] addr
```

### 选项
-b: 后台下载，一般和-o logfile 配合，若没指定-o 则日志输出到wget-log
-t n: 指定重试次数，若n=0，则无限重试（可以使用--waitretry=secs指定重试之间的等待时间，默认是10，wget 会使用线下退避从1增长到secs）
-T secs: 指定超时时间（会同时设置--dns-timeout, --connect-timeout, --read-timeout 这三个超时时间）
-d/-v/-nv/-q: debug/verbose/no-verbose/quiet 模式，显示信息由多到少，默认-v
-i file: 指定输入文件，若为“-”则表示标准输入，文件每行一个链接，命令行的这个链接优先（也可以没有）
-O file: 指定输出文件，若为“-”则输出到标准输出中
-P prefix: 默认下载到当前目录，该选择在保存文件前，先创建指定名称的目录
-c: 断点续传（需要服务器支持）
-N: 除非文件较新，否则不再取回
-nc: 不覆盖已存在的文件，使用“.n"做后缀
--limit-rate=amount: 限速（默认单位是B/s）可以指定k/m 作为单位
-A/-R list: 指定下载的白名单或黑名单，可以是后缀名或者通配符，逗号分隔
-I/-X list: 目录白名单或黑名单，可以使用通配符，逗号分隔
-r: 递归下载，指定地址目录下的所有子目录都会被下载（甚至包括该地址引用的其他网站，所以最好使用-l depth 选项进行限制最大深度）
-np: -r 不会递归父目录
-nd: -r 不创建层次目录，全部文件平铺在当前目录，同名文件会加上.n 后缀
-nH: -r 会默认创建host 的根目录，该选择可以不创建
--cut-dirs=n: -r 会把父目录也都创建出来，该选项可以去掉n 个父目录的创建
--preserve-permissions: 保持文件的控制权限
-w secs: 指定下载多个文件之间的间隔，可以使用m/h/d 表示分钟、小时、天，可以减轻server负载
--no-remove-listing: 不删除.listing 临时文件（该文件是在上次使用wget 的地址中含有通配符时，记录匹配到的文件的列表），该文件用于查看都有哪些文件，但可能会导致下次下载失败
--http-user=user: 也可以放在链接中，或者存储在.wgetrc 或.netrc 配置文件中
--http-password=password
--use-askpass

--method=HTTP-Method: 指定RESTful 请求方法
--post-data=string/--post-file=file: 发送POST 请求（默认发送GET 请求），string 通常是形如“key1=val1&key2=val2”的字符串
--header='name: val': 指定一条req header，可以多次使用以指定多条
-U agent: 指定浏览器的user-agent
--no-cookies: 禁用cookie
--load-cookies file: 指定加载的cookie文件
--save-cookies file: 指定cookie 的保存位置
--keep-session-cookies: 保存会话cookie（默认save-cookies 不保存会话），可以用于免登录
--no-proxy: 禁用proxy，无视环境变量
--proxy-user=user: 通过设置http_proxy、https_proxy、ftp_proxy 环境变量可以使用代理
--proxy-password=password

# curl
支持很多协议：FTP, FTPS, HTTP, HTTPS, GOPHER, TELNET, DICT, FILE 以及 LDAP，支持文件的上传和下载

## 格式
```
curl [options / URLs]
```
其中URL支持集合和范围的模式，并且在-o选项中可以指定这些变量的引用，按顺序指定为#1，#2....
+ 集合形式：`{one,two,three}`
+ 范围形式（可以设置步长）：`[1-100]`、`[001-100]`、`[1-100:10]`、`[a-z:2]`

### 选项
-o file: 输出写到指定文件（默认写到标准输出）
-O: 保留远程文件文件名
--create-dirs: 建立本地目录的目录层次结构。默认对于一个目录，仅仅显示其目录下的内容
-l: 列出FTP目录下的文件名
-F name=val: 模拟表单提交数据，如果val是一个指定的文件名，则使用@开头
-d 使用post方式传送指定数据，对于含&的各个项，可以使用多个-d，如果是以@开头的字符串，表示这是一个文件名，该文件内容必须是经过URL编码的。
-c <file> 操作结束后把cookie写入指定文件
-b,--cookie <name=string/file> 指定读取的cookie字符串或读取cookie的文件位置
-C 断点续传，可以指定偏移量，则从偏移位置开始续传
-r/--range <range> 检索来自HTTP/1.1或FTP服务器字节范围，对于大文件，可以用此方式分段下载，如指定0-10240，10241-20480，20481-40960，40961- 最后cat在一起即可
-L/--location 默认不会发送HTTP Location headers(重定向)，当一个被请求页面移动到另一个站点时，会发送一个该请求，然后将请求重定向到新的地址上。使用该选项可以强制进行重定向。
-# 显示进度条
-s 安静模式，不显示下载进度
-v 显示一次http通信的整个过程，包括端口连接和http request头信息
--trace <file> 进行debug，比-v更详细的信息
-i 默认情形下，输出不包含协议头信息，比如下载HTML文件，不显示header。该选项包含协议头信息
-I 只显示协议头信息
-D <file> 将服务器的返回的header保存为文件，头部的cookie也可被保存
-H, --header <header:value> 为HTTP请求自定义头信息传给服务器
-X, --request <method> 为HTTP请求指定使用的方法
-e 伪装请求来源，由于有些资源的位置必须通过另一个网络地址才能跳转过去，使用-e指定这个源地址
-A, --user-agent 伪装浏览器，例如："Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"（IE5.0，Win2000）或"Mozilla/4.73 [en] (X11; U; Linux 2.2.15 i686)"（Netscape，PIII的Linux）
-x <host[:port]>在给定端口上使用HTTP代理，避免对方的IP屏蔽
-u <user[:password]>指定服务器的用户名和密码（如果未填密码，则以交互式输入密码）
-U <user[:password]>指定代理服务器的用户名和密码
-E/--cert <cert[:passwd]> 客户端证书文件和密码 (SSL)

### data 格式
application/x-www-form-urlencoded（默认）：-d "param1=value1&param2=value2" 或 -d @data.txt
application/json：-d '{"key1":"value1", "key2":"value2"}' 或 -d @data.json

### 示例
```
curl -H 'Content-Type: application/json'\
-X POST -d '["student1", "student2"]'\
http://localhost:8080/api/somepath/resource
```

# nc
NetCat，可通过TCP或UDP协议传输读写数据。支持二进制数据

## 格式
```sh
# 作为client
nc [-options] hostname port[s]  # 可以使用 < file 用标准输入流输入
# 作为server
nc -lp port     # 在mac 环境不带p
```
作为client 可以将标准输入发送给host，连接返回的数据也会发回到标准输出，ports 可以指定一个范围，比如1-14000
作为server 只能接受一个client的连接，当该client 结束连接后，也将退出

### 通用选项
-i secs: 指定每行之间内容延时发送和接收的时间间隔（秒），也可以使多个端口之间的连接延时，以便传送信息及扫描通信端口
-n: 直接使用IP地址，而不通过域名服务器（DNS）解析
-w secs: client设置等待连线的时间。一个链接一段时间无操作，则自动断开，默认无超时
-v: 显示指令执行过程。 使用2个v将得到更详细的信息
-u: 使用UDP传输协议
-t: 使用TELNET交互方式
-r: 随机端口
-s addr: client设置本地主机送出数据包的IP地址
-z: 关闭输入/输出模式，只在扫描通信端口时使用

### linux 使用的选项
当client 转后台后，即使重新转回前台也不再发送标准输入
-c string: client 使用该选项，不再等待标准输入，而是直接将string 发给server 使用/bin/sh -c 去执行，而后退出
-f file: 同上，指定的是执行的文件
-o file: 将连接通信的内容dump 为16进制数据
-C: 使用CRLF 作为换行符
-g gateway: 设置路由器跃程通信网关（source-routing hop point），最多可设置为8
-G num: 设置来源路由指向器（source-routing pointer），其数值为4的倍数
-T ToS: 指定链接的IP服务类型（TOS: "Minimize-Delay", "Maximize-Throughput", "Maximize-Reliability", or "Minimize-Cost"）

### mac 使用的选项
-4: 强制使用ipv4 
-6: 强制使用ipv6 
-p port: client 指定本地连接端口
-c: 使用CRLF 作为换行符
-d: 后台模式,标准输入不再发给server
`-x proxy_address[:port]`: 指定nc使用的代理地址和端口。默认设置:1080(SOCKS),3128(HTTPS) 

## 实例
```
# HTTP 请求，win 环境使用\r\n\r\n 结尾
echo -n "GET /movie HTTP/1.1\nHeaderName: HeadVal\n\n" | nc localhost 5000
```


# telnet
TELNET 协议客户端

## 格式
```
telnet [-options] [host [port]]
```
将启动客户端命令行
如果成功连接到主机，则可以向其发送标准输入

^表示Ctrl键，按照Escape character说明，输入Ctrl+]就进入telnet的命令模式了

### 选项
-4: 强制使用ipv4 
-6: 强制使用ipv6 
-d: debug 模式
-n tracefile: 使用文件记录trace 信息
-S tos: 指定链接的IP服务类型（TOS）

## 命令
display args: 打印信息
set/unset arg value: 设置/取消变量赋值，value=off 时，set 相当于unset
`open host [[-l] user][- port]`: 连接远端（端口默认23）
close: 关闭远端连接
environ
    define variable value: 定义环境变量（自动export）
    undefine variable
    export variable: 将环境变量导出到远端
    list: 列出当前的环境变量（带* 的是已经导出到远端的）
send: 向远端发送信号
quit: 退出telnet
`? [command]`: 获取命令帮助

# Supervisor
[官网](http://www.supervisord.org)

一个Python写的进程管理器。能监控进程状态，在意外结束时能自动重启。

## 优势
1. 简单
通常管理linux进程的时候，一般来说都需要自己编写一个能够实现进程start/stop/restart/reload功能的脚本，然后丢到/etc/init.d/下面
supervisor管理进程，就是通过fork/exec的方式把这些被管理的进程，当作supervisor的子进程来启动。
只要在supervisor的配置文件中，把要管理的进程的可执行文件的路径写进去就OK了
1. 组管理
对进程组统一管理，也就是说咱们可以把需要管理的进程写到一个组里面，然后我们把这个组作为一个对象进行管理，如启动，停止，重启等等操作。
1. 方便
管理的进程，进程组信息，全部都写在一个ini格式的文件里就OK了。而且，我们管理supervisor的时候的可以在本地进行管理，也可以远程管理，而且supervisor提供了一个web界面，我们可以在web界面上监控，管理进程。
1. 准确高效
当supervisor的子进程挂掉的时候，操作系统会直接给supervisor发信号。而其他的一些类似supervisor的工具，则是通过指定进程的pid，然后定期轮询来重启失败的进程。显然supervisor更加高效
1. 可扩展性
提供了两个可扩展的功能。一个是event机制。再一个是xml_rpc, supervisor的web管理端和远程调用的时候，就要用到它了。

## 安装

## 使用
给我们自己开发的应用程序编写一个配置文件，让supervisor来管理它。每个进程的配置文件都可以单独分拆，放在/etc/supervisor/conf.d/目录下，以.conf作为扩展名

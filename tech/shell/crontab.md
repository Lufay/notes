# 定时任务
利用crontab来定时执行任务大致有如下三步：
1. 编写shell脚本
2. 利用crontab加入到定时任务队列
3. 查看作业完成情况

## crontab 命令
允许用户提交、编辑或删除相应的作业

crontab 各个域的意义和格式（分 时 日 月 星期 要运行的命令，使用空格分隔）
第1列：分钟0～59
第2列：小时0～23（0表示子夜）
第3列：日1～31
第4列：月1～12
第5列：星期0～6（0表示星期天）
第6列：要运行的命令

在前5列中
可以用横杠`-`来表示一个时间范围
可以使用逗号`,`分隔几个离散的数
可以使用`*`，表示所有有效的数，表示每个单位时间执行一次
可以使用`*/n`，表示每隔n个单位时间执行一次，其中*还可以替换为其他有效区间

可使用“#”，做行注释

### 格式
crontab [-u user] file
crontab [-u user] [ -e | -l | -r ]
-e 使用$EDITOR编辑crontab 文件。（在保存文件时会进行合法性检查）
-l 列出crontab 文件中的内容。可以先导出以备份原crontab 文件
-r 删除crontab 文件。
不指定用户，则默认是当前用户
第一个格式是载入任务文件，这样，就会在/var/spool/cron/的目录下产生一个以该用户名命名的文件，文件内容就是载入的文件

环境变量EDITOR 默认是vi

crontab的日志文件为 /var/log/cron

### 环境和依赖
当使用crontab运行shell 脚本时，要由用户来给出脚本的绝对路径（要有执行权限），设置相应的环境变量（比如解释器python和依赖的so的位置）。


## 调度进程
cron 是系统主要的调度进程（/etc/init.d/cron），可以在无需人工干预的情况下运行作业。
每一个用户都可以有一个crontab文件来保存调度信息。可以使用它运行任意一个 shell 脚本或某个命令
系统管理员是通过/etc/cron.deny和/etc/cron.allow这两个文件来禁止或允许用户使用crontab命令

cron服务每分钟不仅要读一次/var/spool/cron内的所有文件（用户级），还需要读一次/etc/crontab（系统级），当符合时间条件，就会执行后面要运行的命令
由于/var/spool/cron是每分钟读取一次，如果把时间设置为最近一分钟之内，可能还没读取更新的设置就把时间错过了，所以至少应将时间设置到2分钟之后

/etc/crontab 是cron 的主配置，它包括下面几行：
```sh
SHELL=/bin/bash         # 使用哪个 shell 环境（在这个例子里是 bash shell）
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root             # 任务的输出被邮寄给 MAILTO 变量定义的用户名，若为空，则电子邮件就不会被寄出
HOME=/                  # 设置在执行命令或脚本时使用的主目录。
# run-parts
01 * * * * root run-parts /etc/cron.hourly
02 4 * * * root run-parts /etc/cron.daily
22 4 * * 0 root run-parts /etc/cron.weekly
42 4 1 * * root run-parts /etc/cron.monthly
```
前四行是用来配置 cron 任务运行环境的变量。

### 进程运维
```sh
/etc/init.d/cron start      # 启动
/etc/init.d/cron stop       # 停止
/etc/init.d/cron restart    # 重启
/etc/init.d/cron reload     # 重新载入配置
# 或
/sbin/service crond restart
```

想要该服务在服务器开启时自启动可以将启动命令追加到`/etc/rc.d/rc.local` 这个脚本中
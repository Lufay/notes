Advanced Python Scheduler，基于Quartz 的定时任务框架
[git home](https://github.com/jcass77/django-apscheduler)
<https://apscheduler.readthedocs.io/en/latest/userguide.html#>

支持三种调度任务：固定时间间隔，固定时间点（日期），Crontab 命令
支持异步执行、后台执行调度任务
支持windows和linux

它并不是一个服务或守护进程，本身也没有任何命令行工具，所以需要在现有应用程序中将scheduler 启动起来，就会重新将任务加载起来恢复执行

# 安装 & 配置
## 安装
```sh
pip install django-apscheduler  # 依赖apscheduler 和 django
# 或
pip install apscheduler
```

## 配置
settings.py中INSTALLED_APPS引入app，完成子应用注册
```py
INSTALLED_APPS = [
    ...
    'django_apscheduler',
]
```

### 其他配置
```py
SCHEDULER_CONFIG = {
    "apscheduler.jobstores.default": {
        "class": "django_apscheduler.jobstores:DjangoJobStore"
    },
    'apscheduler.executors.processpool': {
        "type": "threadpool"
    },
}
```
这里配置默认的作业存储器和执行器，该配置可以作为scheduler 的构造参数

## 数据库准备
`python manage.py migrate --database mysql django_apscheduler`
因为django-apscheduler会创建表来存储定时任务的一些信息
--database 是为了指定同步的数据库（在多数据库时使用）
django_apscheduler 是需要同步的app_label（当已经有其他app 已经同步到数据库时使用，否则重复migrate 会报错）

该操作会在数据库中生成2个表格：
django_apscheduler_djangojob：用于存储任务
django_apscheduler_djangojobexecution：用于存储任务执行状态

```sql
create table django_apscheduler_djangojob(
    id varchar(255) primary key,
    next_run_time datetime(6),
    job_state longblob not null comment '任务的序列化信息'
)

create table django_apscheduler_djangojobexecution(
    id bigint auto_increment primary key,
    status varchar(50) not null comment '执行状态',
    run_time datetime(6) not null comment '开始执行时间（时区相关）',
    duration decimal(15,2) comment '执行时长',
    finished decimal(15,2) comment '执行结束时间戳',
    exception varchar(1000) comment '执行job 出现了什么异常',
    traceback longtext,
    job_id varchar(255) not null,

    foreign key (job_id) references django_apscheduler_djangojob (id)
)
```

可以通过反序列化查看job_state：
```py
def get_data(packled_data: str):
    assert packled_data.startswith('0x')
    data_i = int(packled_data, 16)
    b = data_i.to_bytes((data_i.bit_length()+7)//8, 'big')
    return pickle.loads(b)
```


# 配置和编写任务
APScheduler 有四种组件，分别是：调度器(scheduler)，作业存储(job store)，触发器(trigger)，执行器(executor)

## scheduler
调度器是用户直接操作的界面
可以配置作业存储器和执行器，供调度器执行使用（当然也都有默认值）
其构造参数为调度器配置，既可以使用上面的全局配置作为gconfig参数（`apscheduler.`前缀会被忽略），也可以使用关键字参数作为当前配置（当前优于全局），参数的key 包括：
+ logger: 默认使用name = apscheduler.scheduler 的配置
+ timezone: 默认使用tzlocal.unix.get_localzone()
+ job_defaults: job 的默认配置
+ executors: 一个字典，key 是执行器别名，value 是执行器实例或者一个字典{"class": "执行器类", "type": "执行器别名", ...}（字典其他内容是其他构造参数）
+ jobstores: 一个字典，key 是存储器别名，value 是存储器实例或者一个字典{"class": "存储器类", "type": "存储器别名", ...}（字典其他内容是其他构造参数）

其中执行器别名 和 存储器别名 都是通过pkg_resources.iter_entry_points(group)，group 分别是'apscheduler.executors' 和'apscheduler.jobstores' 对包进行动态解析获得的
可以直接查看该包dist-info 目录下的entry_points.txt 文件中配置

共有7种调度器
+ BlockingScheduler : 调度器在当前进程的主线程中运行，也就是会阻塞当前线程。
+ BackgroundScheduler : 调度器在后台线程中运行，不会阻塞当前线程。（Django框架使用）
+ AsyncIOScheduler : 结合 asyncio 模块（一个异步框架）一起使用。
+ GeventScheduler : 程序中使用 gevent（高性能的Python并发框架）作为IO模型，和 GeventExecutor 配合使用。
+ TornadoScheduler : 程序中使用 Tornado（一个web框架）的IO模型，用 ioloop.add_timeout 完成定时唤醒。
+ TwistedScheduler : 配合 TwistedExecutor（事件驱动），用 reactor.callLater 完成定时唤醒。scrapy爬虫框架
+ QtScheduler : 适用于构建 Qt 应用，需使用QTimer完成定时唤醒。

### 方法
+ start(paused=False): 加载jobstore 中存储的任务，默认会启动执行，如果paused=True则只启动任务处于暂停状态。BlockingScheduler 会阻塞循环处理定时任务（把待执行的jobs从jobstore加载进来，而后找executor去执行），调度器启动后不能修改配置
+ shutdown(wait=True): 默认会等待当前所有任务都执行完毕自己再关闭，如果wait=False，则不会等待立即关闭
+ add_jobstore(jobstore, alias, **kwargs)：为scheduler配置一个作业存储器，并为之起一个别名。若jobstore 是一个字符串（别名），则kwargs 都是给这个作业存储器的构造参数
+ add_job(func, trigger, args=None, kwargs=None, id=None, name=None,
          misfire_grace_time=1, coalesce=True, max_instances=1, next_run_time=undefined,
          jobstore='default', executor='default', replace_existing=False, **trigger_args)
给scheduler 添加一个任务（若scheduler 在运行中，则使其开始准备执行该任务）；任务是执行func(args, kwargs)，func也可以是一个格式为pkg.module:some.obj的文本；
触发器是trigger（可以是触发器的名字ID，也可以是触发器实例），trigger_args 是触发器参数；
id 是保存job 的主键，name 是job 的描述信息；
coalesce：错过任务的执行时间将如何处置，默认情况下，已经错过就不再回补，而是合并为一次执行（如果在scheduler 启动期间错过的，会标注执行状态为Missed!），若将coalesce 置为False，则会将错过的进行回补执行
misfire_grace_time：一个整数，单位为秒，表示一个任务错过next_run_time 多久还可以再次执行
max_instances：该任务并行执行的最大实例数，默认是1个，即串行
next_run_time：指定首次执行的时间（默认会按触发器找到最近的一个时间）
replace_existing是当id 冲突时是否替换原任务；返回一个apscheduler.job.Job 实例
+ get_jobs(): 获取所有的任务（可用指定存储器，前提是该存储器存储的任务已经被scheduler 加载进来）
+ get_job(job_id): 获取指定的任务
+ modify_job(job_id, **change): 修改指定的任务（只能改变任务参数，id除外），有job 实例可以直接操作其job 实例方法
+ reschedule_job(job_id, trigger=None, **trigger_args): 修改任务的触发器，有job 实例可以直接操作其job 实例方法
+ remove_all_jobs(): 移除所有任务
+ remove_job(job_id): 移除指定的任务，有job 实例可以直接操作其job 实例方法
+ pause(): 暂停所有任务
+ pause_job(job_id): 暂停指定的任务，有job 实例可以直接操作其job 实例方法
+ resume(): 重启所有任务
+ resume_job(job_id): 重启指定的任务（若该任务已经结束，则移除之），有job 实例可以直接操作其job 实例方法
+ add_listener(callback, mask): 注册事件回调callback 是一个单参函数对象，参数为事件对象SchedulerEvent及其子类的实例（code就是事件的mask），mask 可以参考apscheduler.events 包
+ remove_listener(callback): 将事件回调移除

除了使用add_job 动态添加任务外，还可以使用@scheduler.scheduled_job(trigger, args=None, kwargs=None, id=None, ...) 装饰一个方法来进行静态添加任务（原来的register_job装饰器废弃）
添加任务建议指定id，虽然不指定也会自动生成，但为了便于操作，最好还是自己指定

若scheduler 未启动，则add_job 仅仅只是pending job，并不会开始计算next_run_time，仅当scheduler 启动后，才会保存到jobstore，并计算next_run_time
如果计算不到next_run_time，就会认为任务调度结束，会将任务删除

## trigger
描述任务的触发条件
无状态的

在scheduler 添加任务时同步配置

共有3种触发器，另外，还可以and 和 or 关系来组合多种触发方式

### date
在指定时间点触发一次

#### 参数
run_date: 可以指定一个date/datetime/str(yyyy-mm-dd hh:MM:ss格式)，用以指定job 执行的时间
timezone: 可以指定一个datetime.tzinfo 或 str，用以指定时区

#### 示例
```py
scheduler.add_job(job_func, 'date', run_date=date(2017, 12, 13), args=['text'])
scheduler.add_job(job3,"date",run_date='2020-12-13 14:00:01',kwargs={'a':'apple'},id="job3")
```

### interval
固定时间间隔触发

#### 参数
weeks (int)	间隔几周
days (int)	间隔几天
hours (int)	间隔几小时
minutes (int)	间隔几分钟
seconds (int)	间隔多少秒
start_date (datetime 或 str)	开始日期
end_date (datetime 或 str)	结束日期
timezone (datetime.tzinfo 或str)	时区
jitter 每次触发添加一个随机浮动秒数，避免同时运行造成服务拥堵

#### 示例
```py
scheduler.add_job(job_func, 'interval', minutes=2, start_date='2017-12-13 14:00:01' , end_date='2017-12-13 14:00:10')
```

### cron
和Linux crontab格式兼容

#### 参数
year (int 或 str)	年，4位数字
month (int 或 str)	月 (范围1-12)
day (int 或 str)	日 (范围1-31）
week (int 或 str)	周 (范围1-53)
day_of_week (int 或 str)	周内第几天或者星期几 (范围0-6 或者 mon,tue,wed,thu,fri,sat,sun)
hour (int 或 str)	时 (范围0-23)
minute (int 或 str)	分 (范围0-59)
second (int 或 str)	秒 (范围0-59)
start_date (datetime 或 str)	最早开始日期(包含)
end_date (datetime 或 str)	最晚结束时间(包含)
timezone (datetime.tzinfo 或str)	指定时区（默认使用scheduler 的timezone 设置）
jitter 每次触发添加一个随机浮动秒数，避免同时运行造成服务拥堵

其中前8个参数str 格式就支持了crontab 的范围表达式：
`*` 每个时间单位
`*/n` 每n 个时间单位
`a-b` 从a 到b 每个时间单位
`a-b/n` 从a 到b 每n 个时间单位
`a,b,c` a,b,c 可以是表达式，也可以是离散的数，表示并集，即满足其一即可
`xth y` 仅用于day 参数，每月第x 个星期y
`last x` 仅用于day 参数，每月最后一个星期x
`last` 仅用于day 参数，每月最后一天

#### 示例
```py
scheduler.add_job(job4,"cron",hour='2', minute='35-37',args=['王涛'],id="job4")
```

## job store
任务持久化，默认保存在内存（无状态的），也可以保存在各种数据库中
注意：一个任务储存器不要共享给多个调度器，否则会导致状态混乱
apscheduler.jobstores 这个包中包含了所有的任务存储器
如果要使用'redis'，decode_responses=False 一定要保持默认值，否则读取会解码失败

django_apscheduler.jobstores.DjangoJobStore: 将任务保存在django_apscheduler_djangojob

由于任务存储器会序列化任务和参数（MemoryJobStore 除外），所以，任务必须是全局可用的，并且参数也必须是可序列化的

## executor
提交指定的可调用对象到一个线程或者进程池来执行
当作业完成时，执行器将会通知调度器

最常用的是线程池（ThreadPoolExecutor，默认max_workers=10）和进程池（ProcessPoolExecutor，会序列化任务，所以任务必须是全局可用的）
```py
from apscheduler.executors.pool import ThreadPoolExecutor, ProcessPoolExecutor

executors = {'default': ThreadPoolExecutor(max_workers), 'ppe': ProcessPoolExecutor(max_workers)}
scheduler = BackgroundScheduler(executors=executors)
```

# 注意
1. 由于scheduler 读取并执行任务会修改任务的next_run_time，所以，scheduler 会使用select_for_update()，而该方法需要在事务内使用，django_apscheduler 使用的是`with transaction.atomic()` 即default 数据库，所以需要确保default 数据库支持事务（sqlite 不支持），并且django_apscheduler_djangojob 必须是支持事务的表；
若default 数据库不支持事务，并且使用了多数据库，则atomic 必须使用using 参数来指定指定使用的数据库，可以使用：`transaction.atomic = partial(transaction.atomic, 'mysql')` 对原方法进行替换
用partial 替换还是不够灵活，因为如果调用transaction.atomic 并使用了参数，就会导致参数错误，可以这样写：
```py
ori_atomic = transaction.atomic
transaction.atomic = lambda *args, **kwargs: ori_atomic(*args, **kwargs) if args or kwargs else ori_atomic('mysql')
```
并放入manage.py 中（确保比其他模块更早加载）
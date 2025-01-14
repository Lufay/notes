分布式任务队列，是一个处理异步任务的框架，其本质是生产者消费者模型，由于它本身不支持消息服务，所以需要第三方消息服务来传递任务，一般使用Redis

# 安装 & 配置
```
pip install celery[redis]

# 其他周边
django-celery-beat      # 定时和周期任务安装
django-celery-results   # 存储任务结果
folower                 # 监控运行任务状态
```

配置项在from celery.app.defaults import NAMESPACES 这个字典里
## 环境变量配置
环境变量配置优先于代码中的配置
环境变量配置包括
CELERY_BROKER_URL = 'redis://127.0.0.1:6379/0'：指定borker为redis 如果指定rabbitmq：'amqp://guest:guest@localhost:5672//'
CELERY_RESULT_BACKEND = 'redis://127.0.0.1:6379/1'：指定存储结果的地方，支持使用rpc、数据库、redis等等，例如指定MySQL可以使用'db+mysql://scott:tiger@localhost/foo'
```py
# from kombu import Exchange, Queue
# 设置任务接受的类型，默认是{'json'}
CELERY_ACCEPT_CONTENT = ['application/json']
# 设置task任务序列列化为json
CELERY_TASK_SERIALIZER = 'json'
# 任务结果的序列化方案
CELERY_RESULT_SERIALIZER = 'json'
# 时区配置
CELERY_TIMEZONE = 'Asia/Shanghai'
# 是否使用UTC时间
CELERY_ENABLE_UTC = False
# 设置任务结果过期时间，单位为秒。默认是一天，若为None或0 表示永不过期
CELERY_TASK_RESULT_EXPIRES = 60 * 60 * 24
# 设置worker并发数，默认是cpu核心数
# CELERYD_CONCURRENCY = 12
# 设置每个worker最大任务数
CELERYD_MAX_TASKS_PER_CHILD = 100
# 指定任务的位置
CELERY_IMPORTS = (
    'base.tasks',
)
# 使用beat启动Celery定时任务
# schedule时间的具体设定参考：https://docs.celeryproject.org/en/stable/userguide/periodic-tasks.html
CELERYBEAT_SCHEDULE = {
    'add-every-10-seconds': {
        'task': 'base.tasks.cheduler_task',
        'schedule': 10,
        'args': ('hello', )
    },
}
```

在主项目目录下（settings.py 同级目录），新增一个celery.py的文件，内容如下
```py
import os
import django
from celery import Celery
from django.conf import settings        # *


# 设置系统环境变量，安装django，必须设置，否则在启动celery时会报错
# main_app 是主项目的目录
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'main_app.settings')     # 类似manage.py 中一样设置settings.py的模块
django.setup()                                                           # 什么作用？

celery_app = Celery('main_app')
celery_app.config_from_object('django.conf:settings',      # : 分隔表示from prefix import suffix，当然也可以直接将 * 哪里导入的settings 直接传进去
                            namespace='CELERY')     # namespace='CELERY'作用是允许你在Django配置文件中对Celery进行配置，但所有Celery配置项必须以CELERY开头，防止冲突
celery_app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)     # 参数是什么作用？
```
然后在主项目的`__init__.py` 中添加：
```py
from .celery import celery_app
__all__ = ['celery_app']
```

在子应用下建立各自对应的任务文件tasks.py(必须是tasks.py这个名字，不允许修改)：
```py
from celery import shared_task

@shared_task
def add(x, y):
    return x + y
```

启动
```sh
celery -A main_app beat -l info # 定时任务
celery -A main_app worker -l -l info # 执行任务
```

由三部分构成：

+ 消息中间件(Broker)：官方提供了很多备选方案，支持RabbitMQ、Redis、Amazon SQS、MongoDB、Memcached 等，官方推荐RabbitMQ
+ 任务执行单元(Worker)：任务执行单元，负责从消息队列中取出任务执行，它可以启动一个或者多个，也可以启动在不同的机器节点，这就是其实现分布式的核心
+ 结果存储(Backend)：官方提供了诸多的存储方式支持：RabbitMQ, Redis, Memcached, SQLAlchemy, Django ORM、Apache Cassandra、Elasticsearch等

![架构图](./celery.png)
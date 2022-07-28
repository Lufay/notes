基于系统的crontab，所以不能在Windows 上使用，并且系统需要启动cron 服务
<https://github.com/kraiz/django-crontab>

# 安装 & 配置
`pip install django-crontab`

settings.py中INSTALLED_APPS引入app，完成子应用注册
```py
INSTALLED_APPS = [
    ...
    'django_crontab'
]
```

# 配置和编写定时任务
## 编写定时任务
定时任务就是注册在INSTALLED_APPS 应用里的一个模块函数

## 配置定时任务
在settings.py中，添加：
```py
CRONJOBS = [  
    # 每天6点计算当月的域名的中断时间和中断次数
    ('0 6 * * *', 'app_name.scripts.cron.run_python',[],{},f'>>{BASE_DIR.parent}/django_crontab.log'),
]
```
列表一个元素表示一个任务，每个任务包括了：
1. crontab 定时配置 [参考](../../shell/crontab.md)
2. 应用模块函数
3. 位序参数列表 和 关键字参数字典（可以缺省，两者必须同时有 或 同时缺省）
4. 输出重定向（可以缺省）

### 其他配置
在settings.py中，还可以进行其他配置：
```py
CRONTAB_LOCK_JOBS = False       # 当一个任务未完成，默认不会进行下一次调度
CRONTAB_EXECUTABLE = '/usr/bin/crontab'     # 配置系统的crontab 命令
CRONTAB_DJANGO_PROJECT_NAME = DJANGO_SETTINGS_MODULE    # 
CRONTAB_DJANGO_MANAGE_PATH = DJANGO_PROJECT_NAME        # manage.py 文件的路径
CRONTAB_COMMAND_PREFIX = ''     # crontab 任务命令前缀，通常用于设置环境变量
CRONTAB_COMMAND_SUFFIX = ''     # 令后缀，例如2>&1crontab 任务命
CRONTAB_COMMENT = 'django-crontabs for ' + CRONTAB_DJANGO_PROJECT_NAME      # 用于crontab 任务命令注释
```

# 运维定时任务
```sh
manage.py crontab add   # 读取CRONJOBS 的配置，解析job 生成hashcode，和当前已添加的jobs 进行比较，若不同则添加）
manage.py crontab show  # 展示当前已添加的job
manage.py crontab remove ${hashcode}    # 删除指定的job，若没有hashcode，则所有的job 都被删除
manage.py crontab run ${hashcode}       # 立即执行指定的job，但不会进行输出重定向，结果会直接打印
```
当add 或 remove 时，都会对系统的crontab 进行编辑，使用`crontab -l` 就能看到变化
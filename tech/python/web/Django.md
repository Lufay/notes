# Django
[4.0文档](https://docs.djangoproject.com/zh-hans/4.0/)
[2.0](http://docs.30c.org/djangobook2/index.html)
[2.0](http://djangobook.py3k.cn/2.0/)
[2.0](http://www.pythontip.com/study/books/djangobook-py3k-cn)
[社区](https://www.django.cn)
<https://www.liujiangblog.com/course/django/84>
<http://c.biancheng.net/django/>
<https://www.w3cschool.cn/django/>
<http://www.uml.org.cn/python/201911074.asp>
<https://code.ziqiangxuetang.com/django/django-tutorial.html>

## MTV 模式
+ M 表示模型（Model）：负责业务对象与数据库的映射(ORM)
+ T 表示模板 (Template)：负责如何把页面(html)展示给用户
+ V 表示视图（View）：负责业务逻辑，并在适当时候调用 Model和 Template
还需要一个 URL 分发器，它的作用是将一个个 URL 的页面请求分发给不同的 View 处理，View 再调用相应的 Model 和 Template


## 使用
项目中如果代码有改动，服务器会自动监测代码的改动并自动重新载入，所以如果你已经启动了服务器则不需手动重启。

### 1. 创建项目并启动
```sh
django-admin startproject ${project_name}
cd ${project_name}
python manage.py runserver 8080         # 启动项目，端口缺省为8000，或者使用django-admin runserver --settings=
python manage.py startapp ${app_name}   # 启动项目的一个应用
```
manage.py：管理文件，和`django-admin --settings=` 作用一致
wsgi.py：runserver命令就使用wsgiref模块做简单的web server
asgi.py: 一个 ASGI 兼容的 Web 服务器的入口
settings.py：配置文件，通过查看manage.py 文件可以看到，该文件是通过设置DJANGO_SETTINGS_MODULE环境变量进行指定的，因此可以使用其他配置文件进行启动。`python manage.py diffsettings` 可以查看当前配置与默认配置的差异。在应用中可以使用django.conf.settings 这个对象（不是模块）访问配置。
urls.py：路由系统，即url与视图的对应关系。该文件是在配置中的ROOT_URLCONF 所指定的。

app/admin.py: 
app/apps.py: app 的配置
app/models.py:
app/views.py
app/tests.py

### 2. 创建视图
views.py：
```py
from django.http import HttpResponse
from django.shortcuts import render
 
def hello(request):
    return HttpResponse("Hello world ! ")

def run(request):
    context = {}
    context['hello'] = 'world'
    return render(request, 'a.html', context)

def red(request):
    return redirect("/index/")
```
request.GET、request.POST 可以获取GET、POST 参数

而后将该模块配置到urls.py 中
```py
from django.urls import path, re_path
 
from . import views
 
urlpatterns = [
    path('hello/', views.hello),
    re_path(r'^hello\d$', views.hello),
]
```
re_path 替换 1.x的 django.conf.urls.url

#### HttpRequest
path：请求页面的全路径
method：GET、POST
body：请求体的字节流，用于处理非HTTP数据（比如JSON、图片等）
REQUEST：GET、POST 参数的合集（POST 优先），也就是`__getitem__`的逻辑
COOKIES
FILES：上传文件，key 是输入框的name属性，value是(filename, content-type, content)
META：HTTP头信息的字典
user：是一个django.contrib.auth.models.User 对象，代表当前登录的用户。未登录则为django.contrib.auth.models.AnonymousUser的实例
session：可读写，需要激活Django中的session支持


### 3. 路由
正则路径中的分组，会作为参数传递给视图函数（无名分组对应的是位置参数，命名分组对应的是关键字参数）

#### 路由分发
`include('app1.urls')` 可以分发到应用中的urls.py

命名空间

#### 反向解析
path 函数的name 参数可以指定一个路由别名
在 views.py 中，从 django.urls 中引入 reverse，利用 reverse("路由别名", args=(符合正则匹配的参数,), kwargs={"分组名":符合正则匹配的参数}) 进行反向解析
模板 templates 中的 HTML 文件中，利用 {% url "路由别名" 分组名=符合正则匹配的参数 %} 反向解析
### 4. 使用模板
[参考](https://www.runoob.com/django/django-template.html)
模板可以使用`{{var}}` 解析render 函数第三个参数传入的dict 的key

模板的路径配置在TEMPLATES.DIRS，默认在BASE_DIR（项目根目录）下

#### 过滤器
`{{ 变量名 | 过滤器:可选参数 }}`
过滤器可以类似管道进行套接
支持自定义

#### 标签
逻辑标签
支持自定义标签

#### 继承

### 5. 使用模型
使用模型，必须要创建一个 app，也就需要添加到配置文件中的INSTALLED_APPS 中

#### 配置数据库
```py
DATABASES = { 
    'default': 
    { 
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'database_name',
        'HOST': '127.0.0.1',
        'PORT': 3306,
        'USER': 'root',
        'PASSWORD': '123456',
    }  
}
DATABASE_ROUTERS = ['path.to.AuthRouter', 'path.to.PrimaryReplicaRouter']
```
DATABASES 是数据库配置
DATABASE_ROUTERS 是数据库路由配置，每当查询需要知道正在使用哪个数据库时，它会依次尝试每个路由直到找到数据库。如果没有找到，它试着访问提示实例的当前 instance._state.db。若instance._state.db 为 None ，主路由将分配默认数据库。
路由类（如上AuthRouter、PrimaryReplicaRouter）需要实现4个方法：
+ db_for_read(model, **hints): 建议用于读取“模型”类型对象的数据库。若知道使用哪个数据库配置，则返回配置的别名，否则返回None
+ db_for_write(model, **hints): 建议用于写入模型类型对象的数据库。
+ allow_relation(obj1, obj2, **hints): 如果允许 obj1 和 obj2 之间的关系（外键或多对多），返回 True 。如果阻止关系，返回 False。如果路由没意见，则返回 None。如果所有路由返回 None，则只允许同一个数据库内的关系
+ allow_migrate(db, app_label, model_name=None, **hints): 决定是否允许迁移操作在别名为 db 的数据库上运行。如果操作运行，那么返回 True ，如果没有运行则返回 False ，或路由没有意见则返回 None。app_label 参数是要迁移的应用程序的标签。makemigrations 会在模型变动时创建迁移，但如果 allow_migrate() 返回 False，任何针对model_name 的迁移操作会在运行 migrate 的时候跳过。
[参考实例](https://docs.djangoproject.com/zh-hans/4.0/topics/db/multi-db/#an-example)

在与 settings.py 同级目录下的 __init__.py 中引入模块和进行配置
```py
import pymysql
pymysql.install_as_MySQLdb()
```

#### 模型类
模型是一个继承自django.db.models.Model 的类，其对应了一个数据库的表，类属性对应了该表的字段
模型类对应的表名默认是`${app_name}_${class_name}`，并且全部变成小写（除非超长，会自动缩写，而后使用大写）
```py
# models.py
from django.db import models
 
class Test(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=20, null=False, unique=True)
    gender = models.BooleanField(null=False, default=0)
    g = models.ForeignKey(Grade, on_delete=models.CASCADE)      # 对应的数据表字段为 g_id
    c = models.ManyToManyField(Course)
    class Meta:
        db_table = 'grade'
        ordering = ['id']
```
继承自Model 的方法：
类方法：
objects.using('db_alias')，指定使用的数据库别名
objects.all()，相当于SELECT *，返回的结果可以直接调用update、delete
objects.filter(id=1)，相当于WHERE
objects.create(name='Apple')
objects.get(id=1)，取单个对象
objects.order_by('name')[0:2]，相当于ORDER BY LIMIT
实例方法：
save()：落库，可以使用using='db_alias' 来指定使用的数据库，若指定force_insert=True，则若主键冲突将报错
update(name='Google')：修改并落库
delete()：删除，可以使用using='db_alias' 来指定使用的数据库

##### 字段
###### 主键
默认Django 给每个模型一个自动递增的主键id，其类型在 AppConfig.default_auto_field 中指定，或者在 DEFAULT_AUTO_FIELD 配置中全局指定。除非，你显示指定了`primary_key`

###### 外键
ForeignKey（即ManyToOne，会自动创建索引，除非使用`db_index=False`来禁用）， ManyToManyField 和 OneToOneField，第一个位置参数是另一个模型类（可以是'self'，类名或类名的字符串，若在另一个app中，需要带`<app_name>.`前缀）
+ ForeignKey：两个位置参数：被引用类（即ToOne的那个）和 on_delete 选项（可以是CASCADE、PROTECT、RESTRICT、SET_NULL、SET_DEFAULT、SET(Callable)、DO_NOTHING），还可以设置limit_choices_to指定外键引用的筛选条件（字典、Q对象，或者返回字典或Q对象的Callable），to_field 可以指定关联的字段（默认是主键）
  + 数据字段名是该属性名后加`_id`，可以使用db_column 来指定
  + on_delete 选项可选（在django.db.models 中）：
    + CASCADE：级联删除，即模拟了 SQL 约束 ON DELETE CASCADE 的行为
    + PROTECT：将raise ProtectedError
    + RESTRICT：将raise RestrictedError 
+ ManyToManyField：Django 会自动生成一个表（默认生成表名，除非使用db_table指定）来管理多对多关系，可以使用 through 选项来指定代表你要使用的中间表的 Django 模型，当中间表对其中一个表有多个关联时，需要使用through_fields 指定关联的键
+ OneToOneField：类似于 ForeignKey 与 unique=True

###### 字段备注名
除ForeignKey， ManyToManyField 和 OneToOneField 之外的Field 都有一个可选的位置参数verbose_name，该参数是模型转换成表单View 时，提示输入的文字，如果没有指定这个参数，默认使用属性名（下划线变空格）
ForeignKey， ManyToManyField 和 OneToOneField，由于第一个位置参数是另一个模型类，所以verbose_name 是一个关键字参数。

##### 模型继承
###### 抽象模型
```py
class AbstractCar(models.Model):
    manufacturer = models.ForeignKey('Manufacturer', on_delete=models.CASCADE)

    class Meta:
        abstract = True
```



```sh
python3 manage.py migrate   # 创建表结构，可以使用--database来指定操作的数据库，默认使用default
python3 manage.py makemigrations TestModel  # 让 Django 知道我们在我们的模型有一些变更
```

##### 字段类型
SmallAutoField、AutoField、BigAutoField：自增ID
UUIDField： UUID 类，最好设置default=uuid.uuid4
SmallIntegerField、IntegerField、BigIntegerField、PositiveSmallIntegerField、PositiveIntegerField、PositiveBigIntegerField：16、32、64 位整数
FloatField：
DecimalField：Decimal 可以设置max_digits 表示最大位数，decimal_places 表示小数位数
BooleanField：true／false
CharField：可以设置max_length，在表单校验使用
TextField：大量文本
JSONField：可以指定encoder、decoder用于序列化标准 JSON 序列化器不支持的数据类型（例如 datetime.datetime 或 UUID ）
BinaryField：二进制数据，可以设置max_length，在表单校验使用
DateField、TimeField、DateTimeField、DurationField：datetime.date、datetime.time、datetime.datetime、timedelta，auto_now=True 则在执行save()时自动更新该字段，auto_now_add=True 则在创建对象时设置该字段
FileField：用于文件上传，upload_to 可以指定上传的相对路径（相对于MEDIA_ROOT）具体可以使用字符串、Path 对象、Callable 对象，返回一个相对路径（可以包含 strftime 的格式）
ImageField：用于上传图片，需要 Pillow 库
FilePathField：用于选择某个目录下的文件名，path 指定目录路径，可以是Callable 对象，match 用于过滤文件名，recursive=True 可以递归搜索，allow_files、allow_folders 可以决定是否只要文件或文件夹（至少一个为True）
EmailField：特殊的CharField，使用 EmailValidator 校验
GenericIPAddressField：IPv4 或 IPv6 地址，protocol 可以是'both' （默认）、'IPv4' 或 'IPv6'
URLField：特殊的CharField，由 URLValidator 验证。


```py
from django.db import models

class Person(models.Model):
    name = models.CharField(max_length=50)

class Group(models.Model):
    name = models.CharField(max_length=128)
    members = models.ManyToManyField(
        Person,
        through='Membership',
        through_fields=('group', 'person'),
    )

class Membership(models.Model):
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    inviter = models.ForeignKey(
        Person,
        on_delete=models.CASCADE,
        related_name="membership_invites",
    )
    invite_reason = models.CharField(max_length=64)
```

##### 字段选项
null：若为True，当该字段为空时，Django 会将数据库中该字段设置为 NULL
blank：若为True，该字段允许为空，涉及表单验证
choices：二元组序列，前者是数据库存储值（模型直接属性访问），后者是表单显示值（使用get_xxxx_display()访问）
default：可以是一个值或者是个可调用的对象
help_text：用于表单提示和生成文档
unique


## django-admin
### 内置命令
<https://docs.djangoproject.com/zh-hans/4.0/ref/django-admin>

### 自定义命令

## 权限管理
```
python manage.py createsuperuser
```

# REST framework
前后端分离的开发思路：后端不再渲染HTML 或重定向，而仅仅返回处理后的应用数据，而由前端负责展示效果，从而解耦
RESTful 就是一种实现前后端分离的接口协议：
+ 每一个URL代表一种资源
+ 前端通过四个HTTP动词，对服务器端资源进行操作，实现"表现层状态转化"

安装：`pip install djangorestframework`

修改项目settings设置：
```
INSTALLED_APPS = (
    ...
    'rest_framework',
)

REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAdminUser',
    ],
    'PAGE_SIZE': 10
}
```

## 序列化
用于将Model 对象转换为http 传输的格式（比如json）
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

### 创建项目并启动
```sh
django-admin startproject ${project_name}
cd ${project_name}
python manage.py runserver 8080         # 启动项目，端口缺省为8000
python manage.py startapp ${app_name}   # 启动项目的一个应用
```
manage.py：管理文件
wsgi.py：runserver命令就使用wsgiref模块做简单的web server
asgi.py: 一个 ASGI 兼容的 Web 服务器的入口
settings.py：配置文件
urls.py：路由系统，即url与视图的对应关系

### 创建视图
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


### 路由
正则路径中的分组，会作为参数传递给视图函数（无名分组对应的是位置参数，命名分组对应的是关键字参数）

#### 路由分发
`include('app1.urls')` 可以分发到应用中的urls.py

命名空间

#### 反向解析
path 函数的name 参数可以指定一个路由别名
在 views.py 中，从 django.urls 中引入 reverse，利用 reverse("路由别名", args=(符合正则匹配的参数,), kwargs={"分组名":符合正则匹配的参数}) 进行反向解析
模板 templates 中的 HTML 文件中，利用 {% url "路由别名" 分组名=符合正则匹配的参数 %} 反向解析
### 使用模板
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

### 使用模型
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
```

在与 settings.py 同级目录下的 __init__.py 中引入模块和进行配置
```py
import pymysql
pymysql.install_as_MySQLdb()
```

#### 模型文件
一个类代表了一个数据库表，类字段表示数据库字段
```py
# models.py
from django.db import models
 
class Test(models.Model):
    name = models.CharField(max_length=20)
```
继承自Model 的方法：
类方法：
objects.all()，相当于SELECT *，返回的结果可以直接调用update、delete
objects.filter(id=1)，相当于WHERE
objects.get(id=1)，取单个对象
objects.order_by('name')[0:2]，相当于ORDER BY LIMIT
实例方法：
save()：落库
update(name='Google')：修改并落库
delete()：删除


```sh
python3 manage.py migrate   # 创建表结构
python3 manage.py makemigrations TestModel  # 让 Django 知道我们在我们的模型有一些变更
```
表名为${app_name}_${class_name}
Django 会自动添加一个 id 作为主键
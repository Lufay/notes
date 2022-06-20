# Flask
[文档](https://dormousehole.readthedocs.io/en/latest/)
<https://www.w3cschool.cn/flask/flask_message_flashing.html>

Flask基于Werkzeug WSGI工具包和Jinja2模板引擎。

安装：`pip install Flask`

## 快速开始
```py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('hello.html')

@app.route('/hello/<name>')
def hello_name(name):
   return 'Hello %s!' % name

if __name__ == '__main__':
   app.run(debug = True)
```
Flask类的一个对象是我们的WSGI应用程序
app.route(rule, options)，进行URL 绑定（必须使用/ 开头，建议使用/结尾，这样能兼容带/结尾和不带的两种情况），和参数列表（比如methods），可以绑定多个
app.run(host, port, debug, options)：
+ host：默认为127.0.0.1（localhost）。设置为“0.0.0.0”以使服务器在外部可用
+ port：默认值为5000
+ debug：默认为false。true 则支持调试信息和自动加载代码更新
+ options：转发到底层的Werkzeug服务器

如果设置环境变量FLASK_APP，或者当前目录中有"wsgi.py" 或 "app.py" 文件，可以直接使用`flask run` 进行启动（不需要调用app.run）
FLASK_APP可以设置为启动的模块名 或 启动文件的路径名
另外还可以设置环境变量FLASK_ENV，默认是production，可以设置为development 启动开发模式
也可以设置环境变量FLASK_DEBUG=1，启动调试模式

## 路由
路由变量可以作为函数的参数传入，默认是字符串类型，还可以使用：
`<int:postID>`、`<float:revNo>`、path

### 转发和错误
`redirect(url_for('hello_guest', guest = name))` 转发到函数hello_guest，并提供参数
redirect(location, statuscode, response)：location 是重定向响应的URL，statuscode默认是302，response用于实例化响应
url_for 就是为了避免手写URL，使用端点生成URL，函数名就是最常用的端点

#### 状态码可以使用
HTTP_300_MULTIPLE_CHOICES
HTTP_301_MOVED_PERMANENTLY
HTTP_302_FOUND
HTTP_303_SEE_OTHER
HTTP_304_NOT_MODIFIED
HTTP_305_USE_PROXY
HTTP_306_RESERVED
HTTP_307_TEMPORARY_REDIRECT

#### 错误
abort(code) 返回错误页面，默认是空页面

code 取值：
400 - 用于错误请求
401 - 用于未身份验证的
403 - Forbidden
404 - 未找到
406 - 表示不接受
415 - 用于不支持的媒体类型
429 - 请求过多

自定义错误页面：
```py
@app.errorhandler(404)
def not_found(error):
    resp = make_response(render_template('error.html'), 404)
    resp.headers['X-Something'] = 'A value'
    resp.status_code = error.status_code
    return resp
```
errorhandler 除了可以注册错误代码外，还可以注册指定的异常类型

## request
route 默认响应GET 请求
```py
from flask import request

@app.route('/login',methods = ['POST', 'GET'])
def login():
    pass

request.method  # GET/POST
request.args    # GET 参数字典
request.form    # POST 的表单字典，key 是input的name
request.cookies # 字典
request.files   # 上传文件的字典，key 是input的name，value 可以用filename 查看文件名（最好使用werkzeug.utils.secure_filename() 对文件名进行处理）
```

### cookies
以文本形式存储在客户端
```py
resp = make_response("success")   # 设置响应体
resp.set_cookie("name", "value", max_age=3600)
resp.delete_cookie("name")
```
设置一个cookie值及其有效时长（单位是秒），若不设置有效时长，则当浏览器关闭该cookie值失效
删除也只是让这个cookie值过期

### session
会话中保存的数据会存储在服务器上的临时目录中。服务器为每个客户端的会话分配会话ID。会话数据存储在cookie的顶部，服务器以加密方式对其进行签名。为了加密，所以需要
使用session 必须要设置app.secret_key，否则就会报错，最好使用一个尽量复杂的随机字符串
可以像使用一个字典，一样使用session
```py
from flask import Flask, session, redirect, url_for, escape, request

app = Flask(__name__)

@app.route('/')
def index():
    if 'username' in session:
        return 'Logged in as %s' % escape(session['username'])
    return 'You are not logged in'
    
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return '''
        <form method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
    '''
    
@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('username', None)
    return redirect(url_for('index'))

app.secret_key = 'jfaljfl'
```

## 模板
render_template 可以使用关键字参数，将变量传入到模板文件中。默认的查找路径是和启动文件同级的templates目录下

模板文件可以使用`{{var}}` 进行引用

### 过滤器
<https://jinja.palletsprojects.com/en/2.10.x/templates/#list-of-builtin-filters>

### 逻辑
```html
{% if not session.logged_in %}
    <p><a href="{{ url_for('login') }}">log in</a></p>  {# 这里的缩进只是为了可读性，不是必须的 #}
{% else %}
    <p><a href="{{ url_for('logout') }}">log out</a></p>
{% endif %}

<table border = 1>
    {% for key, value in result.items() %}
    <tr>
        <th> {{ key }} </th>
        <td> {{ value }}</td>
    </tr>
    {% endfor %}
</table>
```

### 静态文件
比如图片、CSS 文件和JS 文件，可以使用特殊端点'static'用于生成静态文件的URL
```html
<script type = "text/javascript" 
         src = "{{ url_for('static', filename = 'hello.js') }}" ></script>
```
上述url_for 将被解析为/static/hello.js

### 模板继承
```html
{# layout.html #}
<title>Hello Sample</title>
<link rel="stylesheet"  type="text/css"  href="{{ url_for('static', filename='style.css') }}">
<div class="page">
    {% block body %}
    {% endblock %}
</div>

{# hello.html #}
{% extends 'layout.html' %}
{% block title %}主页{% endblock %}
{% block body %}
    <div class="jumbotron">
        <h1>主页</h1>
    </div>
{% endblock %}
```

## 模型
Flask 自身并不有ORM 能力，需要使用插件实现
<https://read.helloflask.com/c5-database>
<https://blog.csdn.net/gfdfhjj/article/details/83869441>
<https://www.jianshu.com/p/80039ee6b4db>
<https://blog.csdn.net/qq_28452411/article/details/86553914>

## 安全
用户输入的数据会包含恶意代码，所以不能直接作为响应返回，需要使用 Flask 提供的 escape() 函数可以对用户输入进行转义处理
或者使用 flask.Markup 类及其方法，对输出的内容进行处理（避免注入）
```py
Markup('<div>Hello %s</div>')  %  '<em>Flask</em>'
```
这样`<em>` 标签就会被原样展示出来，而不是被解析为斜体

## 日志
app.logger 是一个标准的Python Logger
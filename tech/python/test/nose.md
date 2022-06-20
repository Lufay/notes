# nose
[参考](http://nose.readthedocs.io/en/latest/)

## 安装
```
easy_install nose
pip install nose
python setup.py install
```

## 测试执行
```
nosetests [options] [test_case]
```
对于options，除了在命令行指定，还可以通过项目中的setup.cfg 配置文件或用户主目录的.noserc 或 nose.cfg 配置文件进行指定，该文件是一个ini 格式的配置文件，将nosetests 的配置放在[nosetests] 的section 下，例如：
```
[nosetests]
verbosity=3
with-doctest=1
```
如果有这些配置文件，其中的配置将被组合，也可以使用-c 选项指定（可以使用多次以指定多个，其中的配置将被组合）
如果某次执行nosetests 时想要忽略配置文件，可以设置`NOSE_IGNORE_CONFIG_FILES` 环境变量

`test_case`如果缺省，则默认在当前目录下（可以使用-w 选项指定工作目录）进行测试用例的发现
否则，可以指定为：
1. 文件或目录名（绝对或相对路径）
1. 模块名
1. 文件或模块名:函数名
1. 文件或模块名:类名
1. 文件或模块名:类名.方法名

除了使用nosetests 脚本，还可以在测试脚本里导入nose 模块使其通过nose 执行：
```
import nose
nose.main()
```
执行并打印结果，脚本exit 0 表示成功，1 表示失败
```
import nose
result = nose.run()
```
如果成功，result 为True，否则为False 或抛出一个未捕获的异常

如果需要使用nose 的插件，只要安装即可，插件将给nosetests 增加命令行参数，为了确认插件是否安装，可以使用：
```
nosetests --plugins
```
还可以使用-v 或-vv 获得每个插件的更详细信息
如果使用`nose.main(plugins=[])`或`nose.run(plugins=[])`，可以指定一个使用的插件列表

### 测试用例发现
nose会自动识别源文件，目录或包中的测试用例。任何符合正则表达式`(?:\b|_)[Tt]est``(?:^|[\\b_\\.-])[Tt]est`（可以使用-m 选项进行更改）的类、函数、文件或目录，以及TestCase的子类都会被识别并执行。
*注意：nose 不会包含那些可执行的文件，所以要想要这些文件被包含，就需要移除可执行位，或使用–exe选项*

### 测试用例编写
在测试用例中可以使用assert或raise AssertionErrors

nose支持setup和teardown函数，在测试用例的前后执行。四种作用域：
1. package。可以在`__init__.py`中定义，setup方法名可以是setup, `setup_package`, setUp, setUpPackage，而teardown方法名可以是teardown, `teardown_package`, tearDown, tearDownPackage
1. module。在模块内定义setup, `setup_module`, setUp, setUpModule，和/或teardown, `teardown_module`, tearDownModule
1. class。除了继承自unittest.TestCase 的类，其他被发现的测试类也可以定义setUp 和tearDown 方法使之在每个测试方法之前和之后执行；在类中还可以定义`setup_class`, setupClass, setUpClass, setupAll, setUpAll 和`teardown_class`, teardownClass, tearDownClass, teardownAll, tearDownAll 类方法，使之在整个类的加载前和后执行
1. function。任何符合正则的函数都会被包装成FunctionTestCase，可以修改函数对象的setup 和teardown 属性，也可以通过`with_setup`这个装饰器进行设置
```
def setup_func():
    "set up test fixtures"

def teardown_func():
    "tear down test fixtures"

@with_setup(setup_func, teardown_func)
def test():
    "test ..."
```

### 测试用例批量生成
可以将测试函数和方法做成生成器。这个生成器必须yield 一个tuple，这个tuple 的第一个元素必须是一个可调用对象，剩下的参数是传给这个可调用对象的参数。
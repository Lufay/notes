# 组件
[TOC]
基类：yii\base\Component
该类继承yii\base\Object

yii\base\Object 类实现yii\base\Configurable 接口
yii\base\Configurable 接口建议其继承类的构造器的最后一个参数是一个配置数组，如：
```php
public function __constructor($param1, $param2, ..., $config = [])
```
那么继承yii\base\Object 的类在重写`__constructor`方法时，都应该保留最后一个参数为配置数组，并在该方法实现的最后调用：
```
parent::__construct($config);
```
进行属性初始化（使用`Yii::configure($this, $config);` 而后调用init()方法）
因此，如果重写了init() 方法，那么最好首先调用
```
parent::init();
```
以确保父类的初始化完毕。
注：`__construct`和init 方法的区别就在于前者可以实现配置生效前的初始化过程，而后者实现配置生效后的初始化过程

实现yii\base\Configurable 接口就可以通过Yii::createObject() 方法传入一个配置数据获取到到一个实例（具体的实现参考内置的DI 容器部分）
配置数组的格式：
```
[
    'class' => 'ClassName',
    'propertyName' => 'propertyValue',
    'on eventName' => $eventHandler,
    'as behaviorName' => $behaviorConfig,
]
```
class：必须使用完全限定类名；
propertyName：必须是public属性（无论是类的public 数据成员或是用getter和setter方法定义的属性）
eventHandler：参考事件处理器的格式
behaviorConfig：参考行为配置数组

配置实例：
config/ 目录下，小部件配置
例如：config/web.php，是在入口脚本中进行实例化`(new yii\web\Application($config))->run();`
而其依赖的配置是通过require 其他配置文件返回的，PHP 配置文件就是直接return 一个kv-array

配置派生：
在不同的环境使用不同的配置
在入口脚本会设置两个和环境相关的常量：
```
defined('YII_DEBUG') or define('YII_DEBUG', true);
defined('YII_ENV') or define('YII_ENV', 'dev');
```
其中`YII_ENV`可取三种值：
+ prod：生产环境。常量 YII_ENV_PROD 将被看作 true。如果你没修改过，这就是 YII_ENV 的默认值。
+ dev：开发环境。常量 YII_ENV_DEV 将被看作 true。
+ test：测试环境。常量 YII_ENV_TEST 将被看作 true。


## 功能
+ 属性（Property）
+ 事件（Event）
+ 行为（Behavior）

### 属性
属性功能是通过getter和setter方法定义新的对象public属性（yii\base\Object 类支持，如果不需要事件和行为可直接继承该类）
例如：
```
use yii\base\Object;

class Foo extend Object
{
    private $_label;

    public function getLabel()
    {
        return $this->_label;
    }

    public function setLabel($value)
    {
        $this->_label = trim($value);
    }
}
```
即上述的setter 和 getter 两个方法定义了一个新的label 属性（可读可写），该对象的实例可以像定义在类中的public 属性一样使用：
```
$obj = new Foo();
$obj->label = '   xxx  ';
```
该功能可以控制属性的读写能力，封装读写逻辑
注意：
1. 此种方法定义的属性名不区分大小写；
1. 如果此种方法定义的属性已存在，则访问属性将直接访问直接定义的属性，而非此法定义的属性；
1. 定义属性的 getter 和 setter 方法是 public、protected 还是 private 对属性的可见性没有任何影响；
1. getter 和 setter 方法只能定义为非静态的；
1. php 的`property_exists()`函数是不能确认此种方法定义的属性，而应该使用yii\base\Object 的canGetProperty() 方法和canSetProperty() 方法确认。


### 事件
事件可以将自定义代码“注入”到现有代码中的特定执行点，从而实现面向切面的编程（AOP）。
#### 对象级
##### 事件注册
on(事件名，事件处理器 [，附加数据，$append=true])
其中
事件名是一个字符串，推荐使用类常量进行定义，例如`const EVENT_HELLO = 'hello'`；
事件处理器，可以是
    - 全局函数名（字符串）
    - 对象方法（[$obj, $method]，$method为方法名的字符串）
    - 类静态方法（[$class, $method]，$class是类的全名字符串，$method是该类的静态方法名字符串）
    - 匿名函数（function ($event) {...}）
    事件处理器可以接受一个yii\base\Event 或其子类的一个实例为参数，可以通过访问该实例的name、sender、data 属性获取事件名、触发事件的对象（即调用trigger方法的对象）、附加数据；若将$event->handled = true;则后续处理器不再调用；
默认的事件按注册顺序触发，除非设置$append为false则置于队头。

##### 触发事件
trigger(事件名 [，事件实例])

##### 移除处理器
off(事件名 [，事件处理器])：不要第二个参数则移除所有处理器

#### 类级
Event::on(A::class_name(), 事件名，处理器)
Event::trigger(A::class_name(), 事件名)：该方式只触发类级处理器，如果使用实例（该类及其子类的实例）的触发方式，则先执行对象级处理器，而后执行类级处理器
Event::off(A::class_name(), 事件名 [，处理器])

#### 全局
Yii::$app->on(事件名，处理器)
Yii::$app->trigger(事件名 [，事件实例])
也可以使用其他可以全局访问的单例
注意：全局事件全局共享，所以在定义事件名时，可以按命名空间进行划分。


### 行为
被称为Mixins，指的是不依赖继承关系，增强一个 yii\base\Component 类功能。一个行为代表了一个可共享的修饰功能，可以加入多个组件中给组件增加这种修饰功能，因此，从另一方面，一个行为可以看做一个带有实现的接口，而组件“实现”该接口加入功能。

#### 定义行为
行为类继承自yii\base\Behavior 或其子类，它所定义的属性和方法都会被注入到组件中
*注意：通过行为添加的属性，为了可以使canGetProperty() 方法和canSetProperty() 方法可用，需要重写行为类的这两个方法*

##### 添加事件处理
可以通过重写events()方法注入事件处理，该方法返回一个kv-Array，其中key为事件名，val为事件处理器
例如：
```
class MyBehavior extends Behavior
{
    public function events()
    {
        return [
            ActiveRecord::EVENT_BEFORE_VALIDATE => 'beforeValidate',
        ];
    }

    public function beforeValidate($event)
    {
        // 处理器方法逻辑
    }
}
```
这里，如果指定的事件处理器是一个行为类的方法，可以直接使用方法名的字符串

#### 附加行为
类比多继承会有冲突的情形，当多个附加行为出现冲突，那么以首先附加上的为准
##### 静态附加行为
重写组件的behaviors()方法，该方法返回一个数组：
若为kv（命名行为），则key为行为名，val为行为类名或类的配置数组；
若不是kv（匿名行为），则为行为类名。
```
class User extends ActiveRecord
{
    public function behaviors()
    {
        return [
            // 匿名行为，只有行为类名
            MyBehavior::className(),

            // 命名行为，只有行为类名
            'myBehavior2' => MyBehavior::className(),

            // 匿名行为，配置数组
            [
                'class' => MyBehavior::className(),
                'prop1' => 'value1',
                'prop2' => 'value2',
            ],

            // 命名行为，配置数组
            'myBehavior4' => [
                'class' => MyBehavior::className(),
                'prop1' => 'value1',
                'prop2' => 'value2',
            ]
        ];
    }
}
```

##### 动态附加、获取、移除行为
调用组件的attachBehavior(行为名，行为类)方法，其中行为类可以是一个行为类实例，可以是行为类名，也可以是行为类的配置数组。
还可以通过attachBehaviors([])方法动态附加多个行为，其中参数数组和上面behaviors() 方法的返回数组格式相同。

可以通过组件的getBehavior(行为名)来获取行为实例。getBehavior()来获取所有行为。
可以通过组件的detachBehavior(行为名)来移除一个命名行为。detachBehaviors()方法移除所有行为。

#### 内置的行为类
在`yii\behaviors\*`之下
扩展：[yii2tech\ar\softdelete\SoftDeleteBehavior](https://github.com/yii2tech/ar-softdelete), [yii2tech\ar\position\PositionBehavior](https://github.com/yii2tech/ar-position)

#### 对比Traits
行为类，支持继承，不侵入被注入组件，支持配置生成、注入事件处理、自动处理符号冲突（先注入优先）
[Traits](http://www.php.net/traits)，语言级别支持（可以有IDE支持）性能（效率、内存）更好，需要对被注入对象进行修改，符号冲突需要手动解决


## 依赖注入（Dependency Injection，DI）
### 为什么要DI
在从面向对象编程到面向接口，或者说是面向抽象编程中，我们经常提到，要使用工厂方法而不是new，要使用DI 而不是继承
其基本思想就是解耦，避免硬编码
使用工厂方法，我们可以通过字符串去创建一个实例；使用DI，我们的类就不依赖于具体的父类，而依赖于一个抽象的接口。
这样，当系统发生实现变更时，修改配置就可以完成（因为使用哪个的实例是通过字符串指定的）

### 依赖注入容器（DI容器）
在Yii中，是通过DI容器实现的。DI容器就是一个对象（\yii\di\Container的一个实例，这里需要new），它知道怎样初始化并配置对象及其依赖的所有对象。

#### 设置依赖
##### 构造函数参数类型提示
```
class Foo
{
    public function __construct(Bar $bar)
    {
    }
}
```

##### Setter 和属性


#### 注册依赖
当被依赖的是一个具体的类，且不需要特别的实例化参数，可以不用注册
1. 如果依赖一个接口
`$container->set('yii\mail\MailInterface', 'yii\swiftmailer\Mailer');`
1. 需要特别的实例化参数
```
$container->set('yii\db\Connection', [
    'dsn' => 'mysql:host=127.0.0.1;dbname=demo',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8',
]);
```
1. 注册别名
`$container->set('foo', 'yii\db\Connection');`
1. 注册别名，并拥有特别的初始化参数
```
$container->set('db', [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=127.0.0.1;dbname=demo',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8',
]);
```
1. 注册特定实例
`$container->set('pageCache', new FileCache);`
1. 注册回调
```
$container->set('db', function ($container, $params, $config) {
    return new \yii\db\Connection($config);
});
```
注1. 其中`$container`就是一个\yii\di\Container 的实例
注2. 使用set 注册的依赖，每次使用都会产生一个新实例，使用setSingleton 进行注册，可以依赖一个单例。

##### 注册依赖的时机
总的原则是尽可能早
+ 应用程序开发者
可以在入口脚本注册
+ 扩展的开发者
扩展的引导类中注册

#### 使用DI 容器创建对象
使用DI 容器的get($class, $params = [], $config = []) 方法创建新的对象
其中，
`$class`，可以是一个类名、接口名、别名
$params，是类的构造器参数
$config，是类的配置数组

### 内置的DI 容器
在Yii 启动引导是就创建一个DI容器：Yii::$container
当使用 `Yii::createObject($type, $params=[])` 创建对象时，实际上使用的是这个DI容器的get方法获得对象（并自动递归创建其依赖对象，并注入）
具体的，
如果`$type`是字符串，就直接`get($type, $params)`
如果`$type`是数组，就从该数组从提取'class'这个key 的val作为`$type`，其余的作为`$config`调用get
如果`$type`是可调用对象，就直接用$params作为其参数调用之返回。

可以通过该DI 容器修改对象依赖（set方法），由于Yii核心代码都使用createObject创建对象，所以该修改对全局生效。

## 服务定位器
基类：yii\di\ServiceLocator
能力：通过service ID 获取服务组件
因为\yii\base\Module（\yii\base\Application 的父类）继承自yii\di\ServiceLocator，因此，模块对象（包括Yii::$app对象）就是一个服务定位器

### 服务的注册和注销
set($id, $definition)
$id 就是service ID （字符串）
$definition 就是是组件的定义可以是：
+ 类的全名
+ 类的配置数组
+ 可调用对象（用`is_callable`检查，比如返回对象实例的匿名函数）
+ 对象实例
+ null （用于注销一个服务）
该行为也可以通过clear($id)方法完成

setComponents($components)
$components 是一个kv-array，该方法会遍历数组调用set(key, value) 进行批量注册

### 获取到服务组件实例
可以通过get方法，也可以直接像使用属性一样（`->service_id`）就可以（因为有`__get`魔术方法）
其行为是：
如果指定的组件已经实例化，则返回之；
否则则通过Yii::createObject($definition) 方法创建一个新的实例

如果服务未注册会抛异常
可以通过has($id, $checkInstance = false) 方法判断一个service ID 是否已经注册
默认只检查是否有注册，如果$checkInstance = true 的话，就检查是否实例化（这里的实例化时机是指get()方法的调用）

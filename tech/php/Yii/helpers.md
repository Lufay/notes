# 帮助工具
[TOC]

## Yii
文件位于vendor/yiisoft/yii2/Yii.php
继承于\yii\BaseYii

静态方法：
getVersion()：获得当前使用Yii 的版本号

### 别名系统
为了避免了在代码中硬编码一些绝对路径 和 URL，yii 提供了一套别名系统用来进行文件的定位（类似于相对路径）
别名必须以 @ 字符开头

#### 常用的内置别名
@app：当前运行的应用的根目录，即yii\base\Application::basePath
@webroot：web 入口目录（即index.php所在目录）
@runtime：runtime目录，默认为@app/runtime
@vender：vender目录（yii\base\Application::vendorPath），默认@app/vendor
@yii：BaseYii.php 文件所在的目录（也被称为框架安装目录）
@web：当前应用的URL 根路径（即url中去掉addr:port之后，index.php之前的路径部分），即yii\web\Request::baseUrl

#### 别名操作
##### 定义别名
```
// 文件路径的别名
Yii::setAlias('@foo', '/path/to/foo');

// URL 的别名
Yii::setAlias('@bar', 'http://www.example.com');
```
可以用已有别名定义新的别名：
```
Yii::setAlias('@foobar', '@foo/bar');
```
并不要求别名中不能包含`/`字符

别名可以在应用配置中通过设置yii\base\Application::aliases 属性进行添加：
```
[
    'aliases' => [
        '@name1' => 'path/to/path1',
        '@name2' => 'path/to/path2',
    ],
]
```

##### 解析别名
```
echo Yii::getAlias('@foo/bar/file.php');  // 输出：/path/to/foo/bar/file.php
```
因为不要求别名中不能包含`/`字符，所以在解析别名时，采用最长匹配优先的原则


## yii\helpers\Html
解决HTML动态生成的问题
`encode($content, $doubleEncode = true)`：调用htmlspecialchars进行HTML的特殊字符转义
`decode($content)`：调用htmlspecialchars_decode进行反向转义


## yii\helpers\Url
解决动态的Url生成的问题


## yii\helpers\ArrayHelper
操作数组的扩展工具

### 静态方法
+ `getValue($arr, $field, $default=null)`：`$field`可以是一个字符串或回调函数，字符串可以是点分的数组键名或对象属性名，回调函数接受2个参数`$arr`, `$default`。
+ `remove($arr, $key)`：删除数组的指定键，并返回该键的值
+ `keyExists($key, $array, $caseSensitive = true)`：同`array_key_exists`，不过可以大小写不敏感
+ `getColumn($arr, $name, $keepKeys = true)`：从一个二维数组中获取一列的值，`$name`同getValue的`$field`（默认保存行key的）
+ `index($arr, $key)`：重建索引（多维数组或对象数组），即将多维数组内部的一个值提取为该子数组（或对象）的索引，`$key`同getValue的`$field`
+ `map($arr, $from, $to, $group = null)`：提取映射，即将`$arr`的`$from`字段作为key，`$to`字段作为val，重新构造一个映射表，而`$group`是`$arr`中作为分组的字段， `$from`, `$to`, `$group`同getValue的`$field`
+ `multisort(&$arr, $key, $direction = SORT_ASC, $sortFlag = SORT_REGULAR)`：多维数组排序， `$key`可以是键名字符串，可以是字符串数组，也可以是匿名函数（参数是数组中的一项，返回该项排序的字段），`$direction`可以是`SORT_ASC` 或者 `SORT_DESC` 之一或其数组， `$sortFlag`是传给PHP的sort函数的参数
+ `isIndexed($array, $consecutive = false)`：判断数组是否是普通数组（全部是数字索引，如果 `$consecutive`为true，则数组索引比现是从0开始的顺序整数）
+ `isAssociative($array, $allStrings = true)`：判断数组是否是关联数组（全部是字符串索引，如果`$allStrings`是false，则数组索引至少有1个是字符串）
+ `htmlEncode($data, $valuesOnly = true, $charset = null)`：对数组的值进行编码，如果`$valuesOnly`为false，则也对key进行编码
+ `htmlDecode($data, $valuesOnly = true)`：对数组值进行解码
+ `merge($a, $b, ...)`：将多个数组合并并返回，键值相同，如果值都是数组的话，就进行递归合并，否则，就后者覆盖前者
+ `toArray($object, $properties = [], $recursive = true)`：对象转数组，也可以在一个特定的类中实现yii\base\Arrayable接口， 从而为其对象提供默认的转换成数组的方法。


## yii\helpers\FileHelper
`normalizePath($path, $ds=DIRECTORY_SEPARATOR)`：规格化路径串
copyDirectory
removeDirectory
findFiles
filterPath
createDirectory，类似mkdir，但避免了umask对访问权限的影响
getMimeType


## yii\helpers\Json
支持js表达式的嵌入，编解码失败抛异常
实现方式是通过json_encode之前，递归对数据进行预处理


# 视图

视图中 `$this` 是当前的视图对象(yii\web\View)，来管理和渲染这个视图文件

### render
render函数有四种：
render：将渲染的视图内容extract到布局视图中进行渲染
renderPartial：只渲染视图，不带布局
renderAjax：只渲染视图，不带布局，触发各种渲染事件，并注入js/css脚本和文件中，用于响应AJAX网页请求
renderFile：上面三个方法最终都会调用该方法，因为上面使用的都是视图名，而该方法使用的是视图文件名（可以带路径别名）
参数有三个：
第一个指定视图（前三个指定视图名，最后一个指定视图文件名）
第二个可缺省，是传给视图的数据（kv-Array），该Array会被extract为以key为名的变量，可以在视图中直接访问
第三个可缺省，是视图上下文ViewContextInterface（Controller 和 Widget 都实现该接口）
返回渲染的视图文件结果（对于PHP文件，直接require导入视图文件，require返回的就是渲染结果的字符串）。
******
控制器拥有这四种方法，通过调用视图的方法来实现
Widget只有 render 和 renderFile 两个方法，通过调用视图的方法来实现
视图拥有除 renderPartial 以外的三个方法(render/renderAjax/renderFile)，因此，可以在视图中渲染另一个视图（通过`$this`调用）

#### 视图路径解析
当使用前三个render函数时，都需要通过findViewFile函数进行视图路径解析
`@`开头的视图名是别名，使用别名解析获得路径名
`//`开头的视图名，是指定在`@app\views\`下的对应视图文件
`/`开头的视图名，可以指定多级的模块，如果在模块中找不到，再到`@app\views\`下对应controller目录中去找
其他的，视图名就直接是文件名，差别只在所在目录：
如果传入了一个ViewContextInterface（controller就是该接口的一个实现），就调用其getViewPath方法获得所在目录；
如果调用视图本身的getViewFile方法，如果不是false，就使用该文件的所在目录。
最后如果解析完含路径的视图文件名没有后缀，就会加上后缀。

### 布局
布局也是一种视图，用于提取视图中公共的框架的内容
因为在调用render方法时，视图的渲染结果被保存，并以 $content 变量的形式导入（extract）布局
所以可以用
```
<?= $content?>
```
将视图渲染的结果填入布局
#### 布局支持嵌套
```
<?php $this->beginContent('@app/views/layouts/base.php'); ?>
...child layout content here...
<?php $this->endContent(); ?>
```
它使用ContentDecorator这个Widget，将子layout的渲染内容保存起来，extract 到base layout中作为 $content变量

### 视图之间共享数据
可以通过yii\base\View::params属性共享，例如：
```
$this->params['breadcrumbs'][] = 'About Us';
```
这里就将一个数组放入到breadcrumbs这个分类下共享

### 内容块
在一个地方定义一块内容保存起来，在另一个地方展示，例如：
```
<?php $this->beginBlock('block1'); ?>
...content of block1...
<?php $this->endBlock(); ?>
```
它使用Block这个Widget，将框住的内容保存起来，而后可以通过`$this->blocks['block1']`进行访问
使用前先用isset测试，这里推荐使用PHP逻辑控制的替代语法
> PHP逻辑控制的替代语法
> 便于嵌入HTML标签而会因为花括号显得乱
> 即，将 `{` 替换为 `:`，将最后的 `}` 替换为`endxx;`
```
<?php if (isset($this->blocks['block1'])): ?>
    <?= $this->blocks['block1'] ?>
<?php else: ?>
    ... default content for block1 ...
<?php endif; ?>
```

### 视图类其他有用的属性和方法
#### 标题
title属性
#### meta标签
registerMetaTag方法
第一个参数是一个kv-Array
第二个参数是一个meta标签的标识，确保相同标识只渲染一次
#### link标签
registerLinkTag方法
参数同上
#### CSS代码块
registerCss方法
第一个参数是css代码块的字符串
第二个参数是`<style>`标签的属性
第三个参数是一个标签的标识，确保相同标识只渲染一次
#### JS代码块
registerJs方法
除了第二个参数有差异，其他同上
第二个参数可以是：
+ `POS_HEAD`: `<head>`的底部
+ `POS_BEGIN`: `<body>`的开头
+ `POS_END`: `<body>`的末尾
+ `POS_LOAD`: `$(window).load()`中
+ `POS_READY`: `$(document).ready()`中
#### CSS文件
registerCssFile
第一个参数是css文件的路径（可以是url）
第二个参数是`<link>`标签的属性，可以配depends依赖AssetBundle
第三个参数是一个标签的标识，确保相同标识只渲染一次
#### JS文件
registerJsFile
第一个参数是js文件的路径（可以是url）
第二个参数是`<script>`标签的属性，可以配depends依赖AssetBundle
第三个参数是一个标签的标识，确保相同标识只渲染一次
#### 注册资源包
```
AppAsset::register($this);
```
该方法会调用视图的registerAssetBundle方法将资源包的文件注册到视图中，那么，在该视图中就可以使用资源中的内容。


### 渲染静态页面的简便方法
如果一个action仅仅只是一条不带数据的render语句
那么可以将这样的action放到Controller的actions方法中，例如：
```
public function actions()
{
    return [
        'page' => [
            'class' => 'yii\web\ViewAction',
        ],
    ];
}
```
那么，如果url是`?r=site/page&view=about`，就可以直接render('aboat')，而不需要再写那个action方法了
还可以通过配置修改默认视图、搜索路径、布局

#### 自定义视图类
可以从 yii\base\View 或 yii\web\View 继承实现一个视图类，而后修改配置使用该视图组件：
```
[
    // ...
    'components' => [
        'view' => [
            'class' => 'app\components\View',
        ],
        // ...
    ],
]
```


### 关于安全
当参数来自于最终用户时，参数中可能隐含的恶意 JavaScript 代码会导致跨站脚本（XSS）攻击。
因此，在输出之前需要用 yii\helpers\Html::encode() 方法处理


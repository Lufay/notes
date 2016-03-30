[TOC]

### 简介
由Twitter两位前员工2010年8月创建。代码开源（MIT协议），并有着良好的代码规范。
基于Less的前端开发库（也包含了Sass源码），提供了很多常用的CSS和JavaScript合集。

#### 特性
+ 一套完整的CSS插件。
+ 丰富的预定义样式表。
+ 一组基于jQuery的JS插件集。
+ 一个非常灵活的响应式（Responsive）栅格系统，崇尚移动先行（Mobile First）的思想。

一般正式运行时，使用压缩的.min.css、.min.js文件，而进行开发调试时，使用未经压缩的.css、.js文件
******

### 栅格系统
该系统将窗口划分为12列，这就是col的语义（即一个row之内的列总数是12）
而后为了适应不同尺寸的屏幕设备，定义了4种：xs（超小型）sm（小型）md（中型）lg（大型），为了兼容多种屏幕设备，就需要混合使用各类的布局
最后的一个数字，表示所占用的列数
列偏移：`col-*-offset-n`, 这里的n表示向右偏移n列
列嵌套：row之内再嵌套一个row，内层的row依然被划分为12列
列排序：`col-*-(push/pull)-n`, push表示右移的列数n，pull表示向左移的列数
row必须包含在container容器中
在IE6和IE7下不支持，可以加
```
<meta http-equiv="X-UA-Compatible" content="IE=edge”>
```
这个IE降级标签来兼容



参考：
<http://www.runoob.com/bootstrap/bootstrap-tutorial.html>
模态框
<http://www.runoob.com/bootstrap/bootstrap-modal-plugin.html>

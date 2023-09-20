# 代码结构

## 项目级配置
针对开发者工具的配置

project.private.config.json 中的相同设置优先级高于 project.config.json
project.private.config.json 是私人配置，可以写到.gitignore 中避免公开
开发者工具内的设置修改会优先覆盖 project.private.config.json

[配置项参考](https://developers.weixin.qq.com/miniprogram/dev/devtools/projectconfig.html)

## 爬虫索引配置
sitemap.json
默认，所有页面都会被微信索引

## 小程序级
app.wxss: 全局样式
app.js: 注册App 实例，所有页面共享，可以通过全局函数 getApp()可以获取APP实例（单例）
app.json: 全局配置（页面配置，超时配置，底部tab等）[参考](https://developers.weixin.qq.com/miniprogram/dev/reference/configuration/app.html)

写在 pages 字段的第一个页面就是这个小程序的首页

## 页面&组件
+ WXML 模板：基于组件构建页面，组件可以是微信内置组件，也可以是自定义组件；模板的也支持逻辑控制
+ WXSS 样式：页面&组件级样式。
+ JS 脚本：注册Page 实例，可以通过全局函数 getCurrentPages()可以获取当前页面栈
+ JSON 配置：页面配置。[参考](https://developers.weixin.qq.com/miniprogram/dev/reference/configuration/page.html)

### page 的生命周期
1. 实例的创建过程（在视图请求渲染数据之前）依次执行onLoad 和 onShow
2. 在视图使用page.data 初次渲染完成后，执行onReady
3. 切换前后台，执行onHide 和 onShow
4. 实例销毁执行onUnload

### 页面栈
基于页面路由的动作操作页面栈：
+ 打开新页面（navigateTo），就将此页面（非tabBar页）入栈，之前的页面转入后台
+ 页面重定向（redirectTo），就是栈顶替换，也就是当前页销毁，新页入栈（非tabBar页）
+ 页面返回（navigateBack），就是出栈，出栈后销毁
+ 重加载（reLaunch），会清空栈，只留新页（可以是任何页）
+ Tab 切换（switchTab），也是清空栈，只留新的Tab 页

tabBar 页 跟一般的页面的区别就是tabBar 页 是常驻页面，不会退栈销毁，只会Hide

# 框架
MVVM 的开发模式，提倡把渲染和逻辑分离。不要再让 JS 直接操控 DOM，JS 只需要管理状态即可，然后再通过一种模板语法来描述状态和界面结构的关系。

小程序有2个独立的线程分别管理渲染层和逻辑层，渲染层使用了WebView 渲染WXML 和WXSS（每个界面一个WebView 线程），逻辑层采用JsCore线程运行JS脚本。由微信客户端提供Native 能力
框架的核心是一个响应的数据绑定系统（支持双向绑定），数据在逻辑层改动，视图层会同步更新。

## 视图层
### WXML
```xml
<!--wxs-->
<wxs module="wer" src="./test.wxs"/>

<scroll-view class="scrollview" scroll-y type="list">
  <!--属性name绑定page.data.name-->
  <!--属性name 的change 事件，绑定到wxs的changeName属性（对应一个回调函数），这里必须使用{{}}-->
  <view class="container" name="{{name}}" change:name="{{wer.changeName}}">
    hello {{name}}
  </view>
  <!--双向数据绑定page.data.view-->
  <input id="ipp" model:value="{{view}}" />
  <!--按钮tap 事件绑定page.changeName属性（对应一个回调函数），这里不使用{{}}，除非绑定对应属性是一个字符串，该字符串是一个事件处理函数名（空串会使绑定失效）-->
  <button bind:tap="changeName" mark:anotherMark="leaf">change name</button>
  <!--模板的逻辑控制-->
  <view wx:if="{{view == 'WEBVIEW'}}"> WEBVIEW </view>
  <view wx:elif="{{view == 'APP'}}"> APP </view>
  <view wx:elif="{{view == 'MINA'}}"> MINA </view>
  <view wx:else>Other</view>
  <view wx:for="{{array}}" data-hi="{{item}}" bind:tap="{{wer.tapN}}"> {{item}} </view>

  <!--使用命名模板-->
  <template is="staffName" data="{{...staffA}}"></template>
  <template is="staffName" data="{{...staffB}}"></template>
  <template is="staffName" data="{{...staffC}}"></template>

  <!--命名模板-->
  <template name="staffName">
    <view>
      FirstName: {{firstName}}, LastName: {{lastName}}
    </view>
  </template>
</scroll-view>
```

### WXSS
支持新的尺寸单位 rpx（相对像素，规定屏幕宽为750rpx，然后进行自适应）

```css
/** 导入其他样式文件 **/
@import "common.wxss";
```

#### 内联样式
```xml
<!--静态样式-->
<view class="normal_view" />

<!--动态样式，尽量避免，以免影响渲染速度-->
<view style="color:{{color}};" />
```

#### 选择器
.class
#id
element
element, element
xx::after
xx::before

### WXS
视图里可以用wxs 写js 脚本，用于实时性更强的交互，减少视图到逻辑层的通信耗时
```xml
<wxs module="m1">
<!--直接写代码-->
var msg = "hello world";
module.exports.message = msg;
</wxs>
<view> {{m1.message}} </view>

<!--引用文件，绑定的WXS函数必须用{{}}括起来-->
<wxs module="wxs" src="./test.wxs"></wxs>
<view id="tapTest" data-hi="Weixin" bindtap="{{wxs.tapName}}"> Click me! </view>
```

```js
// test.wxs
function tapName(event, ownerInstance) {
  console.log('tap Weixin', JSON.stringify(event))
  return false // 不往上冒泡，相当于调用了同时调用了stopPropagation和preventDefault
}
module.exports = {
  tapName: tapName
}
```

## 逻辑层
```js
App({
  onLaunch (options) {
    // Do something initial when launch.
    // 小程序启动之后 触发
  },
  onShow (options) {
    // Do something when show.
  },
  onHide () {
    // Do something when hide.
  },
  onError (msg) {
    console.log(msg)
  },
  // 定义全局数据，只要获取到APP实例，任何页面都可以使用
  globalData: 'I am global data'
})
```

```js
Page({
    // 参与页面渲染的数据（页面模板可以直接绑定对应的属性）
    data: {
        text: "This is page data.",
        name: "sun",
        view: 'MINA',
        array: [1, 4, 6, 9],
        staffA: {firstName: 'Hulk', lastName: 'Hu'},
        staffB: {firstName: 'Shang', lastName: 'You'},
        staffC: {firstName: 'Gideon', lastName: 'Lin'}
    },
    behaviors: [require('b.js')],
    // 生命周期函数
    onLoad: function(options) {
    // 页面创建时执行
    },
    onShow: function() {
    // 页面出现在前台时执行
    // onLoad 之后 加载数据onReady 之前，会调用一次
    },
    onReady: function() {
    // 页面首次渲染完毕时执行
    },
    onHide: function() {
    // 页面从前台变为后台时执行
    },
    onUnload: function() {
    // 页面销毁时执行
    },
    onPullDownRefresh: function() {
    // 触发下拉刷新时执行
    },
    onReachBottom: function() {
    // 页面触底时执行
    },
    onShareAppMessage: function () {
    // 页面被用户分享时执行
    },
    onPageScroll: function() {
    // 页面滚动时执行
    },
    onResize: function() {
    // 页面尺寸变化时执行
    },
    onTabItemTap(item) {
        // tab 点击时执行
        console.log(item.index)
        console.log(item.pagePath)
        console.log(item.text)
    },
    // 事件响应函数
    viewTap: function() {
        // this 就是这个page 实例
        this.setData({
            text: 'Set some data for updating view.'
        }, function() {
            // this is setData callback
        })
    },
    changeName: function(e) {   // e 就是事件对象
        const len = Math.random()*10
        this.setData({
            name: Math.random().toString(36).slice(-len)
        })
    },
    // 自由数据
    customData: {
        hi: 'MINA'
    }
})
```

### 场景值
描述用户进入小程序的路径
可以在 App 的 onLaunch 和 onShow，或wx.getLaunchOptionsSync 中获取
[list](https://developers.weixin.qq.com/miniprogram/dev/reference/scene-list.html)

### Component
自定义组件：页面下的可复用模块，也具有ml/ss/js/json 4个组成


### 模块化 exports
每个文件定义的变量和函数仅在该文件有效，函数可以通过module.exports 对外暴露
exports 是 module.exports 的一个引用
```js
// 导出变量（文件a.js）
module.exports = ['a', 11]
// 引用变量（文本b.js）
let a = require('a.js') // 这里a 就是上面那个数组

// 导出函数（文件a.js）
exports.f = function() {}
// 引用函数（文本b.js）
let com = require('a.js')   // 这里com 就是一个对象，有一个字段f 是一个函数
com.f()	// 调用其他文件定义的方法
```

### behaviors
是一种mixins 机制，可以将其属性、数据、生命周期函数和方法，注入到page or 组件中
在page or 组件 的behaviors 是一个数组，也就是可以mixin 多个behaviors

```js
// 导出behaviors（文件a.js）
module.exports = Behavior({
  data: {
    sharedText: 'This is a piece of data shared between pages.'
  },
  methods: {
    sharedMethod: function() {
      this.data.sharedText === 'This is a piece of data shared between pages.'
    }
  }
})
// 引用behaviors（文本b.js）
var myBehavior = require('./a.js')
Page({
  behaviors: [myBehavior],
  onLoad: function() {
    this.data.sharedText === 'This is a piece of data shared between pages.'
  }
})
```

## 事件处理
### 事件对象
+ type: 事件类型
+ timeStamp: 事件生成时的时间戳（毫秒）
+ target: 触发事件源组件，主要包括了id 和 dataset（data-开头的自定义属性组成的Obj，连字符写法会转换成驼峰写法，大写字符会自动转成小写字符）
+ currentTarget: 当前处理函数的组件
+ mark: 事件标记数据，事件冒泡路径上所有的 mark 会被合并，同名会覆盖，不会做名字变更（mark: 前缀的属性）
+ detail: 如表单组件的提交事件会携带用户的输入，媒体的错误事件会携带错误信息
+ touches: 触摸事件特有，触摸点信息数组
+ changedTouches: 触摸事件特有，变化的触摸点信息（Touch 对象 or CanvasTouch）数组（如从无变有，位置变化，从有变无）
+ instance: WXS的事件对象特有，跟第二个参数ownerInstance一样，是个ComponentDescriptor对象

Touch 对象
+ identifier: 标识符
+ pageX, pageY: 文档的左上角为原点
+ clientX, clientY: 距离页面可显示区域（屏幕除去导航条）左上角距离

CanvasTouch 对象
+ identifier: 标识符
+ x, y: 距离 Canvas 左上角的距离，Canvas 的左上角为原点

### 事件类型
#### 冒泡事件
+ 点触：tap
+ 长按：longpress
+ 拖动：touchstart、touchmove、touchcancel、touchend
+ 动画：animationstart、animationiteration、animationend、transitionend

#### 非冒泡事件
自定义事件如无特殊声明都是非冒泡事件，如 form 的submit事件，input 的input事件，scroll-view 的scroll事件，canvas 中的触摸事件

### 绑定方式
捕获阶段：从外向内依次处理
冒泡阶段：由内向外依次处理

+ bind: 绑定冒泡阶段并继续冒泡
+ catch: 绑定冒泡阶段并拦截冒泡
+ capture-bind: 绑定捕获阶段并继续
+ capture-catch: 绑定捕获阶段并拦截
+ mut-bind: 互斥，带有该绑定的处理函数，一个事件对象只执行一个

# API

## 系统事件监听
如：wx.onSocketOpen，wx.onCompassChange 等

## 同步 API
约定，以 Sync 结尾的 API 都是同步 API
也有一些其他的同步 API，如 wx.createWorker，wx.getBackgroundAudioManager 等

同步 API 的执行结果可以通过函数返回值直接获取，如果执行出错会抛出异常

## 异步 API
大多数 API 都是异步

### callback型
提供如下的Object 参数：
```js
{
  success: function(res) {
    // 调用成功的回调
    res.errMsg
    res.errCode === 0
  },
  fail: function() {
    // 调用失败的回调
  },
  complete: function() {
    // 调用结束的回调（无论成败）
  },
  ...
}
```
这种类型，API一般没有返回值
这三个回调，不要求都包含，但如果都不包含，则变为promise型


### promise型
wx.onUnhandledRejection 可以监听未处理的 Promise 拒绝事件

## 云API
```js
wx.cloud.callFunction({
  // 云函数名称
  name: 'cloudFunc',
  // 传给云函数的参数
  data: {
    a: 1,
    b: 2,
  },
  success: function(res) {
    console.log(res.result) // 示例
  },
  fail: console.error
})
```
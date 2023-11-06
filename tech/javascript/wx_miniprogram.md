# 生命周期
小程序切后台后5秒会挂起，挂起后30分钟没有切前台后会自动销毁
无论是离开小程序还是把微信切后台、直接锁屏，都会把小程序切后台
挂起后小程序js 线程会停止运行，内存保留，所以不会响应事件，除非使用了后台音乐播放、后台地理位置等能力，才会继续在后台运行
运行内存不足会提示用户重新打开小程序，这时候会主动消耗小程序。所以必要时，使用`wx.onMemoryWarning` 监听内存告警事件，进行必要的内存清理
小程序启动时，如果带有路径，会自动进入相应的path 页

小程序启动时，会以同步方式更新代码包，所以会阻塞启动流程
若想对更新过程进行控制，可以通过wx.getUpdateManager() 获取对象，使用其方法注册对应函数
+ onCheckForUpdate(res => {}): 请求完新版本信息的回调
+ onUpdateReady(() => {}): 准备更新前的回调
+ onUpdateFailed(() => {}): 版本更新失败的回调
+ applyUpdate(): 应用新版本并重启

# 代码结构

js 不支持动态执行 JS 代码（包括使用eval 和new Function 两种方式）
内置了一份 core-js Polyfill
一些高级语法时，如 async/await 时，则需要借助 代码转换工具 来支持这些语法
Proxy 对象在部分低版本客户端中无法使用，请注意尽量避免使用

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

### 分栏模式
app.json 中
"resizable": true   使小程序支持 iPad 屏幕旋转
"frameset": true    和resizable 一起使用，启用分栏模式（若某一分栏没有展示页面，则展示frameset/placeholder.png 这个图片）

### 全局页面设置
设置在window 中的内容是对所有页面都生效的配置，比如：
+ restartStrategy: homePage（默认）首页重启；homePageAndLatestPage 当前页重启。如果重启时间超过一天，会直接首页重启

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
所有组件标签名和属性都必须是小写，且用`-`连接
通用属性：
hidden: 组件是否显示
data-*: 属性值可以是任何类型，可以是Boolean、Number、String、Array、Object 任意类型

```xml
<!--wxs-->
<wxs module="wer" src="./test.wxs"/>

<scroll-view class="scrollview" scroll-y type="list">
  <!--属性name绑定page.data.name-->
  <!--属性name 的change 事件，绑定到wxs的changeName属性（对应一个回调函数），这里必须使用{{}}-->
  <view class="container" name="{{name}}" change:name="{{wer.changeName}}">
    hello {{name}}
  </view>
  <!--双向数据绑定page.data.view，使用model: 前缀，而且，暂不支持a.b 这种形式-->
  <input id="ipp" model:value="{{view}}" />
  <!--按钮tap 事件绑定page.changeName属性（对应一个回调函数），这里不使用{{}}，除非绑定对应属性是一个字符串，该字符串是一个事件处理函数名（空串会使绑定失效）-->
  <button bind:tap="changeName" mark:anotherMark="leaf">change name</button>
  <!--模板的逻辑控制-->
  <view wx:if="{{view == 'WEBVIEW'}}"> WEBVIEW </view>
  <view wx:elif="{{view == 'APP'}}"> APP </view>
  <view wx:elif="{{view == 'MINA'}}"> MINA </view>
  <view wx:else>Other</view>
  <!-- list-item 启用节点样式共享 -->
  <view wx:for="{{array}}" data-hi="{{item}}" bind:tap="{{wer.tapN}}" list-item> {{item}} </view>

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

#### 样式属性
```xml
<!--样式类，用于静态样式-->
<view class="normal_view" />

<!--内联样式，可以使用动态样式，尽量避免，以免影响渲染速度-->
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
视图里可以用wxs 写js 脚本，用于实时性更强的交互，减少视图层到逻辑层的通信耗时
目前只能响应内置组件的事件，不支持自定义组件事件
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
event.instance 是触发事件的组件的 ComponentDescriptor 实例
ownerInstance 触发事件的组件所在的组件的 ComponentDescriptor 实例，比如页面内的组件，它就对应了页面实例

#### ComponentDescriptor 方法
selectComponent(selector): 返回ComponentDescriptor 实例
selectAllComponents(selectors): 返回ComponentDescriptor 实例数组
setStyle(str_or_obj): 设置组件样式，支持rpx。
addClass/removeClass/hasClass(str): 设置组件的 class。
getDataset(): 返回data- 属性对象
callMethod(funcName, {}): 调用组件的逻辑层函数
requestAnimationFrame(func): 用于设置动画。
getState(): 用于局部变量存储。
triggerEvent(eventName, detail):
getComputedStyle(...str)
setTimeout(func, num): 用于创建定时器
clearTimeout(num): 用于清除定时器
getBoundingClientRect()

### 初始渲染缓存
无需等待逻辑层初始化完成，直接使用缓存的渲染结果。但此时无法响应用户事件，需等待逻辑层初始化完成

启动方式是加配置："initialRenderingCache": "static"
可以加到app.json 的 window 配置段中

缓存的内容仅包括Page 的data 初始化的内容，不包含任何 setData 的结果，所以一般都是静态内容
想要动态内容，需要使用这个配置："initialRenderingCache": "dynamic"；此外，还需要在页面逻辑中调用this.setInitialRenderingCache(dynamicData) 才能真正启用（该方法开销较大，且不能早于页面或组件的ready 生命周期）
这样，Page 的data 字段就和dynamicData 一起被缓存
若dynamicData 是null，则禁用

### Skyline 渲染引擎
该引擎在 AppService 中划出一个独立的上下文，来运行之前 WebView 承担的 JS 逻辑、DOM 树创建等逻辑。减轻渲染线程的渲染负担，但询问页面信息等接口会变为异步，效率也可能有所下降；为此，新的 Worklet 机制比原有的 WXS 更靠近渲染流程，以提升构建动画效果的性能。
在光栅化策略上，Skyline 采用的是同步光栅化的策略，WebView 是异步分块光栅化的策略
WebView 模式，一个小程序页面对应一个 WebView 实例；Skyline 只有 AppService 线程，且多个 Skyline 页面会运行在同一个渲染引擎实例下，减少内存占用

可以在页面级设置渲染引擎
renderer 可以选择skyline 还是webview

#### worklet
替代WebView中的WXS，用来解决交互动画问题。让JS 代码运行在渲染线程，能够在渲染线程同步运行动画相关逻辑，使动画不再会有延迟掉帧

必须打开`将 JS 编译成 ES5` 的本地设置（开发者工具），并且只能在Skyline 页面使用
新版的开发者工具上有一个`编译worklet代码`选项，可以节省编译时间

worklet是一个特殊标记的函数，既可以执行在渲染线程（UI 线程），也可以执行在逻辑线程（JS 线程）
worklet 默认只能调用worklet 函数，如果要调用JS函数需要使用runOnJS
在JS线程中可以直接调用worklet 函数，而在UI线程中需要使用wx.worklet.runOnUI 调用

##### 共享变量 和 协变变量
worklet 会在定义时捕获外部变量并生成对应线程的拷贝，所以两个线程不会相互影响；除非使用wx.worklet.shared(initialValue) 定义的共享变量
基于shared(initialValue) 可以使用wx.worklet.derived(updaterWorklet) 获得一个协变变量。即当共享变量变化时，updaterWorklet会驱动执行，更新协变变量的值。协变变量也可以认为一个共享变量，所以可以继续作为协变的基准。

```js
// 普通函数
function someFunc(greeting) {
  console.log('hello', greeting);
}

const obj = { name: 'skyline'}
// 共享变量
const progress = wx.worklet.shared(0)
// 协变变量
const offset = wx.worklet.derived(() => {
 'worklet'
 return progress.value * 255
})
// worklet 函数
function anotherWorklet() {
  'worklet';
  console.log(offset.value) // 1
  offset.value = 2
  console.log(offset.value) // 2
  return obj.name;    // 外部变量，实际上会被序列化后生成在 UI 线程的拷贝，所以这里仍是 skyline
}

function someWorklet(greeting) {
  'worklet';
  // 调用worklet 函数（同步调用）
  const w = anotherWorklet();
  // 调用普通函数（异步调用）
  runOnJS(someFunc)(greeting + w);
  // 调用其他方法
  runOnJS(this.method.bind(this))(args);
}

// 在JS 线程中
offset.value = 1
someWorklet('hello')
// 在UI 线程
obj.name = 'change name'
wx.worklet.runOnUI(someWorklet)('hello')
```

##### 手势驱动动画
```xml
<pan-gesture-handler onGestureEvent="handlepan">
  <view class="circle"></view>
</pan-gesture-handler>
```

```js
Page({
  onLoad() {
    const offset = wx.worklet.shared(0)
    this.applyAnimatedStyle('.circle', () => {
      'worklet';
      return {
        transform: `translateX(${offset.value}px)`
      }
    })
    this._offset = offset
  },
  handlepan(evt) {
    'worklet';
    if (evt.state === GestureState.ACTIVE) {
      this._offset.value += evt.deltaX;
    }
  }
})
```
当手指在 circle 节点平滑的拖动时，会触发handlepan回调，修改共享变量的值
worklet.cancelAnimation(SharedValue): 可以取消由 SharedValue 驱动的动画
applyAnimatedStyle，当sharedValue 值更新时，updater 函数将被重新执行，并将新的 style 应用到选中节点上。默认新的样式会在下一个渲染时间片上生效，flush: sync 可使得在当前渲染时间片上生效
+ 第二个参数updater 是一个worklet 函数，返回的key为 css 属性的驼峰写法，应用到selector 指定的节点上，也就产生了动画；
+ 第三个参数userConfig 是`{immediate: true, flush: "async"}`，用于指定是否立即执行updater，以及刷新时机（async / sync）
+ 第三个参数callback 是当完成时的回调，`(res) => {res.styleId}`，可以获取到styleId，用于清除样式绑定。
clearAnimatedStyle(selector, styleIds, callback)：若styleIds 为空，则清除节点上所有的样式绑定。只是解绑，样式不会重置。


###### 内置的手势组件
其为虚组件，不会进行布局，真正响应事件的是其直接子节点，并且仅能含有一个直接子节点，否则不生效，因此，可以嵌套多种手势组件。
如同事件冒泡一样，由内向外进行手势识别，当满足后会阻断事件冒泡。
其回调函数均需声明为 worklet 函数，回调在 UI 线程触发

点击：<tap-gesture-handler>
双击：<double-tap-gesture-handler>
重按（iPhone）：<force-press-gesture-handler>
长按：<long-press-gesture-handler>
纵向滑动：<vertical-drag-gesture-handler>
横向滑动：<horizontal-drag-gesture-handler>
拖动（横向/纵向）：<pan-gesture-handler>
多指缩放：<scale-gesture-handler>

pan 弱于vertical-drag 和horizontal-drag，所以即使pan 放在内层，当命中外层的滑动手势时，也会使pan 失效

组件属性
+ tag 声明手势协商时的组件标识
+ worklet:ongesture 手势识别成功的回调（worklet 回调，无返回值）
+ worklet:should-response-on-move 手指移动过程中手势是否响应，worklet 回调函数在适当时机被执行以读取返回值
+ worklet:should-accept-gesture 手势是否应该被识别，worklet 回调函数在适当时机被执行以读取返回值
+ simultaneous-handlers 声明可同时触发的手势节点
+ native-view 代理其内部的原生节点类型（支持scroll-view 和 swiper）
  + <scroll-view> 的 scroll 事件仅在滚动时触发，当触顶/底后，不再回调
  + 手势回调当手指在屏幕上滑动时会一直触发，直到松手

手势事件回调参数的属性
+ tap / double-tap
  + state 手势状态，非连续，始终为1
  + absoluteX/absoluteY 相对于全局的 X、Y 坐标
+ pan / vertical-drag / horizontal-drag
  + state 手势状态
  + absoluteX/absoluteY 相对于全局的 X、Y 坐标
  + deltaX/deltaY 相对上一次，X、Y 轴方向移动的坐标
  + velocityX/velocityY 手指离开屏幕时的横向、纵向速度（pixel per second）
+ long-press
  + state 手势状态
  + absoluteX/absoluteY 相对于全局的 X、Y 坐标
  + translationX/translationY 相对于初始触摸点的 X、Y 轴偏移量
  + velocityX/velocityY 手指离开屏幕时的横向、纵向速度（pixel per second）
+ force-press
  + state 手势状态
  + absoluteX/absoluteY 相对于全局的 X、Y 坐标
  + pressure 压力大小
+ scale 是 pan 的超集
  + state 手势状态
  + focalX/focalY 中心点相对于全局的 X、Y 坐标
  + focalDeltaX/focalDeltaY 相对上一次，中心点在 X、Y 轴方向移动的坐标
  + scale 放大或缩小的比例
  + horizontalScale/verticalScale scale 的横向、纵向分量
  + rotation 旋转角（单位：弧度）
  + velocityX/velocityY 手指离开屏幕时的横向、纵向速度（pixel per second）
  + pointerCount 跟踪的手指数
其中state 状态字段是
```js
enum State {
  // 手势未识别
  POSSIBLE = 0,
  // 手势已识别
  BEGIN = 1,
  // 连续手势活跃状态
  ACTIVE = 2,
  // 手势终止
  END = 3,
  // 手势取消
  CANCELLED = 4,
}
```
对于如pan 之类的连续手势，会有如下几个阶段：
1. 手势识别：手指刚接触屏幕，state = 1，这个过程会调用should-accept-gesture 回调，若其返回false，则不会识别成功
2. 移动一小段距离，pan 手势判定生效时，state = 1
3. 继续移动，state = 2，这个阶段会持续进行事件派发，即调用should-response-on-move 和 ongesture，前者决定是否派发事件，后者是事件处理
4. 手指离开屏幕 state = 3
5. 若手势识别失败 或 不派发事件，则state = 4

##### 变化函数
该函数的返回值可以直接赋值给共享变量的value

+ worklet.timing(toValue, options, callback): 基于时间。toValue 是变化的目标值，options 是`{duration: 300, easing: Easing.inOut(Easing.quad)}`的obj，callback 是动画完成时的回调函数，动画被取消时，返回 fasle，正常完成时返回 true。
+ worklet.spring(toValue, options, callback): 基于物理。options 是含有以下字段的obj
  + damping: 默认值10，阻尼系数
  + mass: 默认值1，重量系数，值越大移动越慢
  + stiffness: 默认值100，弹性系数
  + overshootClamping: 默认值false，动画是否可以在指定值上反弹
  + restDisplacementThreshold: 默认值0.01，弹簧静止时的位移
  + restSpeedThreshold: 默认值2，弹簧静止的速度
  + velocity: 默认值0，速度
+ worklet.decay(options, callback): 基于滚动衰减。options 是含有以下字段的obj
  + velocity: 默认值0，初速度
  + deceleration: 默认值0.998，衰减速率
  + clamp: 默认值[]，边界值（2元组）
+ worklet.sequence(animation...): 组合动画序列，可以传入多个变化函数作为参数
+ worklet.repeat(animation, numberOfReps, reverse, callback): 重复执行动画。numberOfReps是重复次数。为负值时一直循环，直到被取消。reverse是反向运行动画（仅对timing和spring生效）
+ worklet.delay(delayMS, animation): 延迟执行。开始前等待的时间，单位：毫秒

[easing 函数](https://developers.weixin.qq.com/miniprogram/dev/api/ui/worklet/animation/worklet.Easing.html)


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
      var prevExitState = this.exitState // 尝试获得上一次退出前 onSaveExitState 保存的数据
      if (prevExitState !== undefined) { // 如果是根据 restartStrategy 配置进行的冷启动，就可以获取到
        prevExitState.myDataField === 'myData'
      }
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
    onSaveExitState() { // 若微信被系统杀死，该方法将不会被调用
      // 可以在页面退出时，保存一些用户填写的页面数据，以便下次启动时获得这些数据
      return {  // return 的对象会保存到this.exitState 中
        data: { myDataField: 'myData' },  // 需要保存的数据
        expireTimeStamp: Date.now() + 24 * 60 * 60 * 1000 // 超时时刻（默认是+1天），若微信要清理数据，该时间会提前
      }
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

#### 非冒泡事件
+ 动画：animationstart、animationiteration、animationend、transitionend
自定义事件如无特殊声明都是非冒泡事件，如 form 的submit事件，input 的input事件，scroll-view 的scroll事件，canvas 中的触摸事件

### 绑定方式
捕获阶段：从外向内依次处理
冒泡阶段：由内向外依次处理

+ bind: 绑定冒泡阶段并继续冒泡
+ catch: 绑定冒泡阶段并拦截冒泡
+ capture-bind: 绑定捕获阶段并继续
+ capture-catch: 绑定捕获阶段并拦截
+ mut-bind: 互斥，带有该绑定的处理函数，一个事件对象只执行一个，其他节点上的 mut-bind 绑定函数不会被触发

# API

## 提示信息
```js
wx.showModal({
  title: '',
  content: '',
  success(res) {
    if (res.confirm) {  // 用户确认
    }
  }
})
```

## 系统事件监听
如：wx.onSocketOpen，wx.onCompassChange 等

## 节点查询
```js
const query = wx.createSelectorQuery()
query.select('#the-id').boundingClientRect(res => res.top)  // 上边界坐标
query.selectViewport().scrollOffset(res => res.scrollTop)   // 显示区域的竖直滚动位置
query.exec()
```
在自定义组件或包含自定义组件的页面中，推荐使用 this.createSelectorQuery 来代替 wx.createSelectorQuery ，这样可以确保在正确的范围内选择节点。

### 节点布局相交状态
用于监听两个或多个组件节点在布局位置上的相交状态。常常可以用于推断某些节点是否可以被用户看见、有多大比例可以被用户看见。
其中一类是参考节点，取其布局区域为参考区域，多有多个节点，则取交集
另一类是目标节点，默认是一个，除非使用selectAll 选项
可以设置多个阈值，当橡胶比例达到时，就触发对应的阈值回调函数。
```js
wx.createIntersectionObserver(
  this, {thresholds: [0.2, 0.5]}  // 设置阈值20%和50%，可以缺省无参，则当进入和离开时触发回调
).relativeTo('.relative-class')   // 设置参考节点，若没有设置，默认是页面显示区域（不准确代表用户可见的区域，因为参与计算的区域是“布局区域”，布局区域可能会在绘制时被其他节点裁剪隐藏）
.relativeToViewport().observe('.target-class', (res) => { // 阈值回调函数
  res.id // 目标节点 id
  res.dataset // 目标节点 dataset
  res.intersectionRatio // 相交区域占目标节点的布局区域的比例
  res.intersectionRect // 相交区域
  res.intersectionRect.left // 相交区域的左边界坐标
  res.intersectionRect.top // 相交区域的上边界坐标
  res.intersectionRect.width // 相交区域的宽度
  res.intersectionRect.height // 相交区域的高度
})
```
在自定义组件或包含自定义组件的页面中，推荐使用 this.createIntersectionObserver 来代替 wx.createIntersectionObserver ，这样可以确保在正确的范围内选择节点。

## 动画
wx.createAnimation 
animate(selector, keyframes, duration, callback): 关键帧动画。keyframes就是关键帧数组，duration为动画持续时长（单位毫秒），callback是动画完成后的回调
animate(selector, keyframes, duration, ScrollTimeline): 用于绑定滚动元素（目前只支持 scroll-view）。ScrollTimeline是一个obj
clearAnimation(selector, options, callback): 清除动画样式，恢复原有样式。options 是一个obj，指定为true 的属性会被清除，若未指定则全部清除，callback是清除完成后的回调函数

### keyframes 中每个对象属性
#### 对应CSS的
backgroundColor: background-color
height/width
left/right/top/bottom
opacity: 不透明度，[0, 1]
rotate: transform rotate 旋转角度（顺时针）
rotate3d: transform rotate3d 三维旋转（数组）
rotateX: transform rotateX X方向旋转
rotateY
rotateZ
scale: transform scale 扩缩放（二元数组，每个元素表示扩缩倍率）
scale3d: transform scale3d 三维扩缩放
scaleX: transform scaleX X 方向扩缩放
scaleY
scaleZ
skew: transform skew 倾斜
skewX: transform skewX X 方向倾斜
skewY
translate: transform translate 位移
translate3d: transform translate3d 三维位移
translateX: transform translateX X 方向位移
translateY
translateZ
transformOrigin: transform-origin 基点位置
matrix: transform matrix 变换矩阵
matrix3d: transform matrix3d 三维变换矩阵

### ScrollTimeline 对象结构
scrollSource 该元素滚动时会驱动动画的进度（目前只支持 scroll-view）
startScrollOffset 开始驱动动画进度的滚动偏移量，单位 px
endScrollOffset 停止驱动动画进度的滚动偏移量，单位 px
timeRange 起始和结束的滚动范围映射的时间长度，该时间可用于与关键帧动画里的时间 (duration) 相匹配，单位 ms
orientation 指定滚动的方向。有效值为 horizontal 或 vertical（默认）

#### 非CSS
offset: 关键帧的偏移，范围[0, 1]
ease: 动画缓动函数（字符串）

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
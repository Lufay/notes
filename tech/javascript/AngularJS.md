# AngularJS

通过新的属性和表达式扩展了 HTML
最适于开发客户端的单页面应用（SPAs：Single Page Applications）

## 特性
+ 前端MVC
+ 模块化
+ 双向数据绑定
+ 指令属性：绑定在DOM元素上的函数
当一个Angular.JS应用启动时，Angular.JS编译器就会遍历DOM树(从有ng-app指令属性开始)，解析HTML寻找这些指令属性的函数，找到之后就会将其收集，排序，按照优先级顺序被执行。(每个指令属性都有优先级)，这些就是Angular.js应用动态性和响应能力的基础。

依赖注入

## 使用
### 指令属性
扩展HTML的标签属性
HTML5 允许扩展的（自制的）属性，以 data- 开头
AngularJS 属性以 ng- 开头，但是您可以使用 data-ng- 来让网页对 HTML5 有效

#### ng-app
ng-app="appName"
定义一个AngularJS 应用，在网页加载完毕时AngularJS 会自动初始化并解析其中的指令。
一个HTML文档只有第一个起作用；可以出现在html文档的任何一个元素上。
```
var app1 = angular.module("app1", []); //自动加载
var app2 = angular.module("app2", []); //手动加载
angular.bootstrap(document.getElementById("A2"), ['app2']); // 手动加载2
```

#### ng-init
ng-init="变量=值;变量='值'"
初始化变量的值，有多个变量时，中间用分号隔开
通常很少用

#### ng-controller
ng-controller="ctrlName"
定义一个Controller 的作用域
```
var app = angular.module('appName', []);
app.controller('ctrlName', function($scope) {
    $scope.var = "val";
});
```
多个controller 的函数将按序执行

#### ng-model
ng-model="变量"
用于表单元素，支持双向绑定
绑定当前标签内容到应用程序变量（view -> model）
绑定应用程序变量到当前标签内容（model -> view）

#### ng-bind
ng-bind="变量"
用于普通元素，应用程序单向地渲染数据到元素
通常使用表达式进行单向渲染
当ng-bind和{{}}同时使用时，ng-bind绑定的值覆盖该元素的内容

#### ng-repeat
ng-repeat="x in names track by $index"
对数组中的每一项会 克隆一次 HTML 元素

#### ng-click
ng-click="angular code"
定义指定标签的点击事件
类似的有click dblclick mousedown mouseup mouseover mouseout mousemove mouseenter mouseleave keydown keyup keypress submit focus blur copy cut paste（加上ng- 前缀即可）

#### ng-hide 和 ng-show
ng-hide="true" 设置 HTML 元素不可见
ng-show="false" 可以设置 HTML 元素 不可见

#### 自定义
```
var app = angular.module("myApp", []);
app.directive("runoobDirective", function() {
    return {
        template : "<h1>自定义指令!</h1>"
    };
});
```
函数返回一个js 对象：
```
{
	scope: false,  // 默认值，共享父级作用域；true 表示继承父级作用域并创建指令自己的作用域
	require: '',
	restrict: 'EA',
	template: 'first name:{{name}}',	// 用于显示
	templateUrl: 'xxx.html'
	controller:function($scope,$element,$attrs,$transclude){
      console.log("这是con");
    },
	prioruty: 0,	//指明指令的优先级，若在dom上有多个指令优先级高的先执行
	replace: flase,	// 默认值为false 当为true是直接替换指令所在的标签
	terminal: true,	//值为true时优先级低于此指令的其它指令无效
	link: function($scope,elm,attr,controller){	// 值为函数 用来定义指令行为从传入的参数中获取元素并进行处理
      console.log("这是link");
    },
}
```

##### 调用
```
<runoob-directive></runoob-directive>
<div runoob-directive></div>
<div class="runoob-directive"></div>
<!-- directive: runoob-directive -->
```

#### 限制使用
restrict 字段限制调用方式：
E	元素名
A	属性名
C	类名
M	注释
默认值是EA


### 表达式
{{ expression }}
实时获取表达式中变量指定数据源的数据，并计算表达式

#### 过滤器
{{ expression | filter:arg }}
过滤器可以接多个

##### 自定义
```
app.filter('reverse', function() { //可以注入依赖
    return function(text) {
        return text.split("").reverse().join("");
    }
});
```

### Scope
是HTML (视图) 和 controller 之间的纽带
Scope 是一个js 对象，带有属性和方法
所有的应用都有一个 $rootScope
```
app.controller('myCtrl', function($scope, $rootScope) {
    $scope.names = ["Emil", "Tobias", "Linus"];
    $rootScope.lastname = "Refsnes";
});
```
$scope 隶属于controller
$rootscope 设置的变量在所有controller里面都是可以直接用{{$root.变量名}}来显示的，当然也可以赋值给$scope

### 服务
服务是一个函数或对象，是对js-DOM 中的函数和对象的封装，以便在Angular应用声明周期中和应用整合

#### 内建服务
+ $location：封装window.location
+ $http：封装XMLHttpRequest
+ $timeout：封装window.setTimeout
+ $interval：封装window.setInterval

#### 自定义服务
```
app.service('hexafy', function() {
    this.myFunc = function (x) {
        return x.toString(16);
    }
});
```

